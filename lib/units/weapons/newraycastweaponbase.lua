local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_len = mvector3.length
local math_clamp = math.clamp
local math_lerp = math.lerp
local math_map_range_clamped = math.map_range_clamped
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local ids_single = Idstring("single")
local ids_auto = Idstring("auto")
NewRaycastWeaponBase = NewRaycastWeaponBase or class(RaycastWeaponBase)

require("lib/units/weapons/CosmeticsWeaponBase")
require("lib/units/weapons/ScopeBase")

-- Lines 27-61
function NewRaycastWeaponBase:init(unit)
	NewRaycastWeaponBase.super.init(self, unit)

	self._property_mgr = PropertyManager:new()
	self._gadgets = nil
	self._armor_piercing_chance = self:weapon_tweak_data().armor_piercing_chance or 0
	self._use_shotgun_reload = self:weapon_tweak_data().use_shotgun_reload
	self._movement_penalty = tweak_data.upgrades.weapon_movement_penalty[self:weapon_tweak_data().categories[1]] or 1
	self._deploy_speed_multiplier = 1
	self._textures = {}
	self._cosmetics_data = nil
	self._materials = nil
	self._use_armor_piercing = managers.player:has_category_upgrade("player", "ap_bullets")
	self._shield_knock = managers.player:has_category_upgrade("player", "shield_knock")
	self._knock_down = managers.player:upgrade_value("weapon", "knock_down", nil)
	self._stagger = false
	self._fire_mode_category = self:weapon_tweak_data().FIRE_MODE

	if managers.player:has_category_upgrade("player", "armor_depleted_stagger_shot") then
		-- Lines 44-44
		local function clbk(value)
			self:set_stagger(value)
		end

		managers.player:register_message(Message.SetWeaponStagger, self, clbk)
	end

	if self:weapon_tweak_data().bipod_deploy_multiplier then
		self._property_mgr:set_property("bipod_deploy_multiplier", self:weapon_tweak_data().bipod_deploy_multiplier)
	end

	self._bloodthist_value_during_reload = 0
	self._reload_objects = {}

	self:_default_damage_falloff()
end

-- Lines 64-78
function NewRaycastWeaponBase:_chk_has_charms(parts, setup)
	if self:is_npc() and not self:use_thq() then
		return
	end

	if self._charm_data then
		print("[NewRaycastWeaponBase:_chk_has_charms] Wiping existing charm data")
		Application:stack_dump()
		managers.charm:remove_weapon(self._unit)
	end

	managers.charm:add_weapon(self._unit, parts, setup and setup.user_unit, false, self._custom_units)
end

-- Lines 80-82
function NewRaycastWeaponBase:charm_data()
	return self._charm_data
end

-- Lines 84-87
function NewRaycastWeaponBase:set_charm_data(data, upd_state)
	self._charm_data = data
	self._charm_upd_state = upd_state
end

-- Lines 89-170
function NewRaycastWeaponBase:_chk_charm_upd_state()
	local data = self._charm_data

	if not data then
		print("[NewRaycastWeaponBase:_chk_charm_upd_state] No charm data")

		return
	end

	local state = false
	local to_remove = {}

	for u_key, c_data in pairs(data) do
		local charm_unit = c_data.unit

		if not alive(charm_unit) then
			to_remove[u_key] = true
		else
			local cur_upd_state = charm_unit:enabled() and charm_unit:visible()

			if cur_upd_state then
				state = true
			end

			if c_data.update_enabled then
				if not cur_upd_state then
					c_data.update_enabled = false
					local charm_body = c_data.body
					local orig_parent = c_data.orig_body_parent

					if orig_parent then
						charm_body:link(orig_parent)
						charm_body:set_local_rotation(c_data.orig_body_rot)
					end

					c_data.ring:set_local_rotation(c_data.orig_ring_rot)
					c_data.unit:set_moving()
				end
			elseif cur_upd_state then
				c_data.update_enabled = true

				if c_data.orig_body_parent then
					c_data.body:link(c_data.ring)
				end
			end
		end
	end

	if next(to_remove) then
		for u_key, _ in pairs(to_remove) do
			data[u_key] = nil
		end

		if not next(data) then
			print("[NewRaycastWeaponBase:_chk_charm_upd_state] All charm units are dead, wiping charm data. Possibly due to part swapping")
			managers.charm:remove_weapon(self._unit)

			return
		end
	end

	if state then
		if not self._charm_upd_state then
			self._charm_upd_state = true

			managers.charm:enable_charm_upd(self._unit)
		end
	elseif self._charm_upd_state then
		self._charm_upd_state = false

		managers.charm:disable_charm_upd(self._unit)
	end
end

-- Lines 174-186
function NewRaycastWeaponBase:setup(setup_data, multiplier)
	NewRaycastWeaponBase.super.setup(self, setup_data, multiplier)

	if self._assembly_complete then
		self:setup_underbarrel_data()

		if self._setup then
			self:_chk_has_charms(self._parts, self._setup)
		end
	end
end

-- Lines 188-196
function NewRaycastWeaponBase:setup_underbarrel_data()
	local underbarrel_part = managers.weapon_factory:get_part_from_weapon_by_type("underbarrel", self._parts)
	local underbarrel_ammo_data = managers.weapon_factory:get_part_data_type_from_weapon_by_type("underbarrel_ammo", "custom_stats", self._parts)

	if underbarrel_part and alive(underbarrel_part.unit) and underbarrel_part.unit:base() and underbarrel_part.unit:base().setup_data then
		underbarrel_part.unit:base():setup_data(self._setup, 1, underbarrel_ammo_data)
	end
end

-- Lines 200-210
function NewRaycastWeaponBase:_default_damage_falloff()
	local weapon_tweak = tweak_data.weapon[self._name_id]
	local falloff_data = weapon_tweak.damage_falloff or {
		optimal_range = weapon_tweak.damage_near,
		far_falloff = weapon_tweak.damage_far
	}
	self._optimal_distance = falloff_data.optimal_distance or 0
	self._optimal_range = falloff_data.optimal_range or 0
	self._near_falloff = falloff_data.near_falloff or 0
	self._far_falloff = falloff_data.far_falloff or 0
	self._near_mul = falloff_data.near_multiplier or 0
	self._far_mul = falloff_data.far_multiplier or 0
end

-- Lines 213-215
function NewRaycastWeaponBase:set_stagger(value)
	self._stagger = value
end

-- Lines 217-219
function NewRaycastWeaponBase:get_property(prop)
	return self._property_mgr:get_property(prop)
end

-- Lines 221-223
function NewRaycastWeaponBase:is_npc()
	return false
end

-- Lines 225-227
function NewRaycastWeaponBase:skip_queue()
	return false
end

-- Lines 229-231
function NewRaycastWeaponBase:use_thq()
	return false
end

-- Lines 233-235
function NewRaycastWeaponBase:skip_thq_parts()
	return tweak_data.weapon.factory[self._factory_id].skip_thq_parts
end

-- Lines 237-251
function NewRaycastWeaponBase:set_texture_switches(texture_switches)
	self._texture_switches = texture_switches

	if self._texture_switches then
		local sight_swap_switches = {}

		for part_id, texture_data in pairs(self._texture_switches) do
			sight_swap_switches[part_id] = texture_data
			sight_swap_switches[part_id .. "_steelsight"] = texture_data
		end

		self._texture_switches = sight_swap_switches
	end
end

-- Lines 253-256
function NewRaycastWeaponBase:set_factory_data(factory_id)
	self._factory_id = factory_id
end

-- Lines 258-260
function NewRaycastWeaponBase:fire_mode_category()
end

-- Lines 263-275
function NewRaycastWeaponBase:_check_thq_align_anim()
	if not self:is_npc() then
		return
	end

	if not self:use_thq() then
		return
	end

	local thq_anim_name = self:weapon_tweak_data().animations and self:weapon_tweak_data().animations.thq_align_anim

	if thq_anim_name then
		self._unit:anim_set_time(Idstring(thq_anim_name), self._unit:anim_length(Idstring(thq_anim_name)))
	end
end

-- Lines 277-287
function NewRaycastWeaponBase:_third_person()
	if not self:is_npc() then
		return false
	end

	if not self:use_thq() then
		return true
	end

	return self:skip_thq_parts() and true or false
end

-- Lines 289-295
function NewRaycastWeaponBase:assemble(factory_id)
	local third_person = self:_third_person()
	local skip_queue = self:skip_queue()
	self._parts, self._blueprint = managers.weapon_factory:assemble_default(factory_id, self._unit, third_person, self:is_npc(), callback(self, self, "clbk_assembly_complete", function ()
	end), skip_queue)

	self:_check_thq_align_anim()
	self:_update_stats_values()
end

-- Lines 297-304
function NewRaycastWeaponBase:assemble_from_blueprint(factory_id, blueprint, clbk)
	local third_person = self:_third_person()
	local skip_queue = self:skip_queue()
	self._parts, self._blueprint = managers.weapon_factory:assemble_from_blueprint(factory_id, self._unit, blueprint, third_person, self:is_npc(), callback(self, self, "clbk_assembly_complete", clbk or function ()
	end), skip_queue)

	self:_check_thq_align_anim()
	self:_update_stats_values()
end

-- Lines 306-329
function NewRaycastWeaponBase:_refresh_gadget_list()
	self._gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)

	if not self._gadgets or #self._gadgets == 0 then
		return
	end

	local part_a, part_b = nil
	local part_factory = tweak_data.weapon.factory.parts

	table.sort(self._gadgets, function (a, b)
		part_a = self._parts[a]
		part_b = self._parts[b]

		if not part_a then
			return false
		end

		if not part_b then
			return true
		end

		return part_b.unit:base().GADGET_TYPE < part_a.unit:base().GADGET_TYPE
	end)
end

-- Lines 331-441
function NewRaycastWeaponBase:clbk_assembly_complete(clbk, parts, blueprint)
	self._assembly_complete = true
	self._parts = parts
	self._blueprint = blueprint

	self:_update_fire_object()
	self:_update_stats_values()
	self:_refresh_gadget_list()

	if self._setup and self._setup.timer then
		self:set_timer(self._setup.timer)
	end

	local bullet_object_parts = {
		"magazine",
		"ammo",
		"underbarrel"
	}
	self._bullet_objects = {}

	for _, type in ipairs(bullet_object_parts) do
		local type_part = managers.weapon_factory:get_part_from_weapon_by_type(type, self._parts)

		if type_part then
			local bullet_objects = managers.weapon_factory:get_part_data_type_from_weapon_by_type(type, "bullet_objects", self._parts)

			if bullet_objects then
				local prefix = bullet_objects.prefix

				for i = 1, bullet_objects.amount do
					local object = type_part.unit:get_object(Idstring(prefix .. i))

					if object then
						self._bullet_objects[i] = self._bullet_objects[i] or {}

						table.insert(self._bullet_objects[i], {
							object,
							type_part.unit
						})
					end
				end
			end
		end
	end

	self:setup_underbarrel_data()
	self:_apply_cosmetics(clbk or function ()
	end)
	self:apply_texture_switches()
	self:apply_material_parameters()
	self:configure_scope()
	self:check_npc()
	self:_set_parts_enabled(self._enabled)

	if self._second_sight_data then
		self._second_sight_data.unit = self._parts[self._second_sight_data.part_id].unit
	end

	local category = tweak_data.weapon[self._name_id].use_data.selection_index == 2 and "primaries" or "secondaries"
	local slot = managers.blackmarket:equipped_weapon_slot(category)

	for part_id, part_data in pairs(parts) do
		local colors = managers.blackmarket:get_part_custom_colors(category, slot, part_id, true)

		if colors then
			local mod_td = tweak_data.weapon.factory.parts[part_id]
			local alpha = part_data.unit:base().GADGET_TYPE == "laser" and tweak_data.custom_colors.defaults.laser_alpha or 1

			part_data.unit:base():set_color(colors[mod_td.sub_type]:with_alpha(alpha))

			if mod_td.adds then
				for _, add_part_id in ipairs(mod_td.adds) do
					if self._parts[add_part_id] and self._parts[add_part_id].unit:base() then
						local sub_type = tweak_data.weapon.factory.parts[add_part_id].sub_type

						self._parts[add_part_id].unit:base():set_color(colors[sub_type])
					end
				end
			end
		end
	end

	if self._setup and self._setup.user_unit then
		self:_chk_has_charms(self._parts, self._setup)
	end

	clbk()
end

local material_type_ids = Idstring("material")

-- Lines 445-473
function NewRaycastWeaponBase:apply_material_parameters()
	local parts_tweak = tweak_data.weapon.factory.parts

	for part_id, part in pairs(self._parts) do
		local material_parameters = parts_tweak[part_id] and parts_tweak[part_id].material_parameters

		if material_parameters then
			local unit = part.unit
			local material_config = unit:get_objects_by_type(material_type_ids)

			for material_name, parameters in pairs(material_parameters) do
				local material_ids = Idstring(material_name)

				for _, material in ipairs(material_config) do
					if material:name() == material_ids then
						for _, parameter in ipairs(parameters) do
							if not parameter.condition or parameter.condition() then
								local value = type(parameter.value) == "function" and parameter.value() or parameter.value

								if value.type_name == "ScriptableRenderTarget" then
									Application:set_material_texture(material, parameter.id, value)
								end

								material:set_variable(parameter.id, value)
							end
						end
					end
				end
			end
		end
	end
end

-- Lines 475-531
function NewRaycastWeaponBase:apply_texture_switches()
	local parts_tweak = tweak_data.weapon.factory.parts
	self._parts_texture_switches = self._parts_texture_switches or {}

	if self._texture_switches then
		local texture_switch, part_data, unit, material_ids, material_config, switch_material = nil

		for part_id, texture_data in pairs(self._texture_switches) do
			if self._parts_texture_switches[part_id] ~= texture_data then
				local switch_materials = {}
				texture_switch = parts_tweak[part_id] and parts_tweak[part_id].texture_switch
				part_data = self._parts and self._parts[part_id]

				if texture_switch and part_data then
					unit = part_data.unit
					material_config = unit:get_objects_by_type(Idstring("material"))
					local ids = {}

					if type(texture_switch.material) == "table" then
						for _, name in ipairs(texture_switch.material) do
							table.insert(ids, Idstring(name))
						end
					else
						table.insert(ids, Idstring(texture_switch.material))
					end

					for _, material in ipairs(material_config) do
						for _, material_name in ipairs(ids) do
							if material:name() == material_name then
								table.insert(switch_materials, material)
							end
						end
					end

					if #switch_materials > 0 then
						local texture_id = managers.blackmarket:get_texture_switch_from_data(texture_data, part_id)

						if texture_id and DB:has(Idstring("texture"), texture_id) then
							local retrieved_texture = TextureCache:retrieve(texture_id, "normal")

							for _, switch_material in ipairs(switch_materials) do
								Application:set_material_texture(switch_material, Idstring(texture_switch.channel), retrieved_texture)
							end

							if self._parts_texture_switches[part_id] then
								TextureCache:unretrieve(Idstring(self._parts_texture_switches[part_id]))
							end

							self._parts_texture_switches[part_id] = Idstring(texture_id)
						else
							Application:error("[NewRaycastWeaponBase:apply_texture_switches] Switch texture do not exists", texture_id)
						end
					end
				end
			end
		end
	end
end

-- Lines 533-534
function NewRaycastWeaponBase:check_npc()
end

-- Lines 538-554
function NewRaycastWeaponBase:has_range_distance_scope()
	if not self._scopes or not self._parts then
		return false
	end

	if not self._assembly_complete then
		return false
	end

	local part = nil

	for i, part_id in ipairs(self._scopes) do
		part = self._parts[part_id]

		if part and (part.unit:digital_gui() or part.unit:digital_gui_upper()) then
			return true
		end
	end

	return false
end

-- Lines 556-572
function NewRaycastWeaponBase:set_scope_range_distance(distance)
	if not self._assembly_complete then
		return
	end

	if self._scopes and self._parts then
		local part = nil

		for i, part_id in ipairs(self._scopes) do
			part = self._parts[part_id]

			if part and part.unit:digital_gui() then
				part.unit:digital_gui():number_set(distance and math.round(distance) or false, false)
			end

			if part and part.unit:digital_gui_upper() then
				part.unit:digital_gui_upper():number_set(distance and math.round(distance) or false, false)
			end
		end
	end
end

-- Lines 574-598
function NewRaycastWeaponBase:check_highlight_unit(unit)
	if not self._can_highlight then
		return
	end

	if not self._can_highlight_with_skill and self:is_second_sight_on() then
		return
	end

	if unit:in_slot(8) and alive(unit:parent()) then
		unit = unit:parent() or unit
	end

	if not unit or not unit:base() then
		return
	end

	if unit:character_damage() and unit:character_damage().dead and unit:character_damage():dead() then
		return
	end

	local is_enemy_in_cool_state = managers.enemy:is_enemy(unit) and not managers.groupai:state():enemy_weapons_hot()

	if not is_enemy_in_cool_state and not unit:base().can_be_marked then
		return
	end

	managers.game_play_central:auto_highlight_enemy(unit, true)
end

-- Lines 602-616
function NewRaycastWeaponBase:change_part(part_id)
	self._parts = managers.weapon_factory:change_part(self._unit, self._factory_id, part_id or "wpn_fps_m4_uupg_b_sd", self._parts, self._blueprint)

	self:_update_fire_object()
	self:_update_stats_values()

	local setup = self._assembly_complete and self._setup

	if setup and setup.user_unit then
		self:_chk_has_charms(self._parts, setup)
	end
end

-- Lines 618-630
function NewRaycastWeaponBase:remove_part(part_id)
	self._parts = managers.weapon_factory:remove_part(self._unit, self._factory_id, part_id, self._parts, self._blueprint)

	self:_update_fire_object()
	self:_update_stats_values()

	local setup = self._assembly_complete and self._setup

	if setup and setup.user_unit then
		self:_chk_has_charms(self._parts, setup)
	end
end

-- Lines 632-644
function NewRaycastWeaponBase:remove_part_by_type(type)
	self._parts = managers.weapon_factory:remove_part_by_type(self._unit, self._factory_id, type, self._parts, self._blueprint)

	self:_update_fire_object()
	self:_update_stats_values()

	local setup = self._assembly_complete and self._setup

	if setup and setup.user_unit then
		self:_chk_has_charms(self._parts, setup)
	end
end

-- Lines 646-659
function NewRaycastWeaponBase:change_blueprint(blueprint)
	self._blueprint = blueprint
	self._parts = managers.weapon_factory:change_blueprint(self._unit, self._factory_id, self._parts, blueprint)

	self:_update_fire_object()
	self:_update_stats_values()

	local setup = self._assembly_complete and self._setup

	if setup and setup.user_unit then
		self:_chk_has_charms(self._parts, setup)
	end
end

-- Lines 661-667
function NewRaycastWeaponBase:blueprint_to_string()
	local s = managers.weapon_factory:blueprint_to_string(self._factory_id, self._blueprint)

	return s
end

-- Lines 670-682
function NewRaycastWeaponBase:_update_fire_object()
	local fire = managers.weapon_factory:get_part_from_weapon_by_type("barrel_ext", self._parts) or managers.weapon_factory:get_part_from_weapon_by_type("slide", self._parts) or managers.weapon_factory:get_part_from_weapon_by_type("barrel", self._parts)

	if not fire then
		debug_pause("[NewRaycastWeaponBase:_update_fire_object] Weapon \"" .. tostring(self._factory_id) .. "\" is missing fire object !")
	elseif not fire.unit:get_object(Idstring("fire")) then
		debug_pause("[NewRaycastWeaponBase:_update_fire_object] Weapon \"" .. tostring(self._factory_id) .. "\" is missing fire object for part \"" .. tostring(fire.unit) .. "\"!")
	else
		self:change_fire_object(fire.unit:get_object(Idstring("fire")))
	end
end

-- Lines 684-686
function NewRaycastWeaponBase:got_silencer()
	return self._silencer
end

-- Lines 689-878
function NewRaycastWeaponBase:_update_stats_values(disallow_replenish, ammo_data)
	self:_default_damage_falloff()
	self:_check_sound_switch()

	self._silencer = managers.weapon_factory:has_perk("silencer", self._factory_id, self._blueprint)
	self._locked_fire_mode = managers.weapon_factory:has_perk("fire_mode_auto", self._factory_id, self._blueprint) and ids_auto or managers.weapon_factory:has_perk("fire_mode_single", self._factory_id, self._blueprint) and ids_single
	self._fire_mode = self._locked_fire_mode or self:get_recorded_fire_mode(self:_weapon_tweak_data_id()) or Idstring(self:weapon_tweak_data().FIRE_MODE or "single")
	self._ammo_data = ammo_data or managers.weapon_factory:get_ammo_data_from_weapon(self._factory_id, self._blueprint) or {}
	self._can_shoot_through_shield = tweak_data.weapon[self._name_id].can_shoot_through_shield
	self._can_shoot_through_enemy = tweak_data.weapon[self._name_id].can_shoot_through_enemy
	self._can_shoot_through_wall = tweak_data.weapon[self._name_id].can_shoot_through_wall
	self._armor_piercing_chance = self:weapon_tweak_data().armor_piercing_chance or 0
	local primary_category = self:weapon_tweak_data().categories and self:weapon_tweak_data().categories[1]
	self._movement_penalty = tweak_data.upgrades.weapon_movement_penalty[primary_category] or 1
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)

	for part_id, stats in pairs(custom_stats) do
		if stats.movement_speed then
			self._movement_penalty = self._movement_penalty * stats.movement_speed
		end

		if tweak_data.weapon.factory.parts[part_id].type ~= "ammo" then
			if stats.ammo_pickup_min_mul then
				self._ammo_data.ammo_pickup_min_mul = self._ammo_data.ammo_pickup_min_mul and self._ammo_data.ammo_pickup_min_mul * stats.ammo_pickup_min_mul or stats.ammo_pickup_min_mul
			end

			if stats.ammo_pickup_max_mul then
				self._ammo_data.ammo_pickup_max_mul = self._ammo_data.ammo_pickup_max_mul and self._ammo_data.ammo_pickup_max_mul * stats.ammo_pickup_max_mul or stats.ammo_pickup_max_mul
			end
		end
	end

	local damage_falloff = {
		optimal_distance = self._optimal_distance,
		optimal_range = self._optimal_range,
		near_falloff = self._near_falloff,
		far_falloff = self._far_falloff,
		near_multiplier = self._near_multiplier,
		far_multiplier = self._far_multiplier
	}

	managers.blackmarket:modify_damage_falloff(damage_falloff, custom_stats)

	self._optimal_distance = damage_falloff.optimal_distance
	self._optimal_range = damage_falloff.optimal_range
	self._near_falloff = damage_falloff.near_falloff
	self._far_falloff = damage_falloff.far_falloff
	self._near_multiplier = damage_falloff.near_multiplier
	self._far_multiplier = damage_falloff.far_multiplier

	if self._ammo_data then
		if self._ammo_data.can_shoot_through_shield ~= nil then
			self._can_shoot_through_shield = self._ammo_data.can_shoot_through_shield
		end

		if self._ammo_data.can_shoot_through_enemy ~= nil then
			self._can_shoot_through_enemy = self._ammo_data.can_shoot_through_enemy
		end

		if self._ammo_data.can_shoot_through_wall ~= nil then
			self._can_shoot_through_wall = self._ammo_data.can_shoot_through_wall
		end

		if self._ammo_data.bullet_class ~= nil then
			self._bullet_class = CoreSerialize.string_to_classtable(self._ammo_data.bullet_class)
			self._bullet_slotmask = self._bullet_class:bullet_slotmask()
			self._blank_slotmask = self._bullet_class:blank_slotmask()
		end

		if self._ammo_data.armor_piercing_add ~= nil then
			self._armor_piercing_chance = math.clamp(self._armor_piercing_chance + self._ammo_data.armor_piercing_add, 0, 1)
		end

		if self._ammo_data.armor_piercing_mul ~= nil then
			self._armor_piercing_chance = math.clamp(self._armor_piercing_chance * self._ammo_data.armor_piercing_mul, 0, 1)
		end
	end

	if self._silencer then
		self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash_silenced or "effects/payday2/particles/weapons/9mm_auto_silence_fps")
	elseif self._ammo_data and self._ammo_data.muzzleflash ~= nil then
		self._muzzle_effect = Idstring(self._ammo_data.muzzleflash)
	else
		self._muzzle_effect = Idstring(self:weapon_tweak_data().muzzleflash or "effects/particles/test/muzzleflash_maingun")
	end

	self._muzzle_effect_table = {
		effect = self._muzzle_effect,
		parent = self._obj_fire,
		force_synch = self._muzzle_effect_table.force_synch or false
	}
	local base_stats = self:weapon_tweak_data().stats

	if not base_stats then
		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local stats_tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers
	local bonus_stats = self._cosmetics_bonus and self._cosmetics_data and self._cosmetics_data.bonus and tweak_data.economy.bonuses[self._cosmetics_data.bonus] and tweak_data.economy.bonuses[self._cosmetics_data.bonus].stats or {}

	if managers.job:is_current_job_competitive() or managers.weapon_factory:has_perk("bonus", self._factory_id, self._blueprint) then
		bonus_stats = {}
	end

	if stats.zoom then
		stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(primary_category, "zoom_increase", 0), #stats_tweak_data.zoom)
	end

	for stat, _ in pairs(stats) do
		if stats[stat] < 1 or stats[stat] > #stats_tweak_data[stat] then
			Application:error("[NewRaycastWeaponBase] Base weapon stat is out of bound!", "stat: " .. stat, "index: " .. stats[stat], "max_index: " .. #stats_tweak_data[stat], "This stat will be clamped!")
		end

		if parts_stats[stat] then
			stats[stat] = stats[stat] + parts_stats[stat]
		end

		if bonus_stats[stat] then
			stats[stat] = stats[stat] + bonus_stats[stat]
		end

		stats[stat] = math_clamp(stats[stat], 1, #stats_tweak_data[stat])
	end

	self._current_stats_indices = stats
	self._current_stats = {}

	for stat, i in pairs(stats) do
		self._current_stats[stat] = stats_tweak_data[stat] and stats_tweak_data[stat][i] or 1

		if modifier_stats and modifier_stats[stat] then
			self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
		end
	end

	self._current_stats.alert_size = stats_tweak_data.alert_size[math_clamp(stats.alert_size, 1, #stats_tweak_data.alert_size)]

	if modifier_stats and modifier_stats.alert_size then
		self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
	end

	if stats.concealment then
		stats.suspicion = math.clamp(#stats_tweak_data.concealment - base_stats.concealment - (parts_stats.concealment or 0), 1, #stats_tweak_data.concealment)
		self._current_stats.suspicion = stats_tweak_data.concealment[stats.suspicion]
	end

	if parts_stats and parts_stats.spread_multi then
		self._current_stats.spread_multi = parts_stats.spread_multi
	end

	self._alert_size = self._current_stats.alert_size or self._alert_size
	self._suppression = self._current_stats.suppression or self._suppression
	self._zoom = self._current_stats.zoom or self._zoom
	self._spread = self._current_stats.spread or self._spread
	self._recoil = self._current_stats.recoil or self._recoil
	self._spread_moving = self._current_stats.spread_moving or self._spread_moving
	self._extra_ammo = self._current_stats.extra_ammo or self._extra_ammo
	self._total_ammo_mod = self._current_stats.total_ammo_mod or self._total_ammo_mod
	self._reload = self._current_stats.reload or self._reload
	self._spread_multiplier = self._current_stats.spread_multi or self._spread_multiplier
	self._scopes = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("scope", self._factory_id, self._blueprint)
	self._can_highlight_with_perk = managers.weapon_factory:has_perk("highlight", self._factory_id, self._blueprint)
	self._can_highlight_with_skill = managers.player:has_category_upgrade("weapon", "steelsight_highlight_specials")
	self._can_highlight = self._can_highlight_with_perk or self._can_highlight_with_skill

	self:_check_second_sight()
	self:_check_reticle_obj()

	if not disallow_replenish then
		self:replenish()
	end

	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state
	self._fire_rate_multiplier = managers.blackmarket:fire_rate_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint)
end

-- Lines 881-942
function NewRaycastWeaponBase:get_damage_falloff(damage, col_ray, user_unit)
	if self._optimal_distance + self._optimal_range == 0 then
		return damage
	end

	local distance = col_ray.distance or mvector3.distance(col_ray.unit:position(), user_unit:position())
	local near_dist = self._optimal_distance - self._near_falloff
	local optimal_start = self._optimal_distance
	local optimal_end = self._optimal_distance + self._optimal_range
	local far_dist = optimal_end + self._far_falloff
	local near_mul = self._near_mul
	local optimal_mul = 1
	local far_mul = self._far_mul
	local primary_category = self:weapon_tweak_data().categories and self:weapon_tweak_data().categories[1]
	local current_state = user_unit and user_unit:movement() and user_unit:movement()._current_state

	if current_state and current_state:in_steelsight() then
		local mul = managers.player:upgrade_value(primary_category, "steelsight_range_inc", 1)
		optimal_end = optimal_end * mul
		far_dist = far_dist * mul
	end

	local damage_mul = 1

	if distance < self._optimal_distance then
		if self._near_falloff > 0 then
			damage_mul = math_map_range_clamped(distance, near_dist, optimal_start, near_mul, optimal_mul)
		else
			damage_mul = near_mul
		end
	elseif distance < optimal_end then
		damage_mul = optimal_mul
	elseif self._far_falloff > 0 then
		damage_mul = math_map_range_clamped(distance, optimal_end, far_dist, optimal_mul, far_mul)
	else
		damage_mul = far_mul
	end

	return damage * damage_mul
end

-- Lines 944-968
function NewRaycastWeaponBase:is_weak_hit(distance, user_unit)
	if not distance or not user_unit or self._optimal_distance + self._optimal_range == 0 then
		return false
	end

	local near_distance = self._optimal_distance - self._near_falloff
	local far_distance = self._optimal_distance + self._optimal_range + self._far_falloff
	local primary_category = self:weapon_tweak_data().categories and self:weapon_tweak_data().categories[1]
	local current_state = user_unit and user_unit:movement() and user_unit:movement()._current_state

	if current_state and current_state:in_steelsight() then
		local mul = managers.player:upgrade_value(primary_category, "steelsight_range_inc", 1)
		far_distance = far_distance * mul
	end

	if distance < near_distance then
		return self._near_mul < 1
	elseif far_distance < distance then
		return self._far_mul < 1
	end

	return false
end

-- Lines 971-976
function NewRaycastWeaponBase:get_add_head_shot_mul()
	if self:is_category("smg", "lmg", "assault_rifle", "minigun") and self._fire_mode == ids_auto or self:is_category("bow", "saw") then
		return managers.player:upgrade_value("weapon", "automatic_head_shot_add", nil)
	end

	return nil
end

-- Lines 978-989
function NewRaycastWeaponBase:_check_reticle_obj()
	self._reticle_obj = nil
	local part = managers.weapon_factory:get_part_from_weapon_by_type("sight", self._parts)

	if part then
		local part_id = managers.weapon_factory:get_part_id_from_weapon_by_type("sight", self._blueprint)
		local part_tweak = tweak_data.weapon.factory.parts[part_id]

		if part_tweak and part_tweak.reticle_obj and alive(part.unit) then
			self._reticle_obj = part.unit:get_object(Idstring(part_tweak.reticle_obj))
		end
	end
end

-- Lines 991-1004
function NewRaycastWeaponBase:_check_second_sight()
	self._second_sight_data = nil

	if self:has_gadget() then
		local factory = tweak_data.weapon.factory

		for _, part_id in ipairs(self._gadgets) do
			if factory.parts[part_id].sub_type == "second_sight" then
				self._second_sight_data = {
					part_id = part_id,
					unit = self._parts and self._parts[part_id] and alive(self._parts[part_id].unit) and self._parts[part_id].unit
				}

				break
			end
		end
	end
end

-- Lines 1006-1019
function NewRaycastWeaponBase:zoom()
	if self:is_second_sight_on() then
		local gadget_zoom_stats = tweak_data.weapon.factory.parts[self._second_sight_data.part_id].stats.gadget_zoom

		if not gadget_zoom_stats then
			local tweak_stats = tweak_data.weapon.factory.parts[self._second_sight_data.part_id].stats

			if not tweak_stats.gadget_zoom_add then
				debug_pause("Invalid second sight:", self._second_sight_data.part_id)
			end

			gadget_zoom_stats = math.min(NewRaycastWeaponBase.super.zoom(self) + tweak_stats.gadget_zoom_add, #tweak_data.weapon.stats.zoom)
		end

		return tweak_data.weapon.stats.zoom[gadget_zoom_stats]
	end

	return NewRaycastWeaponBase.super.zoom(self)
end

-- Lines 1021-1026
function NewRaycastWeaponBase:is_second_sight_on()
	if not self._second_sight_data or not self._second_sight_data.unit then
		return false
	end

	return self._second_sight_data.unit:base():is_on()
end

-- Lines 1028-1038
function NewRaycastWeaponBase:_check_sound_switch()
	local suppressed_switch = managers.weapon_factory:get_sound_switch("suppressed", self._factory_id, self._blueprint)
	local override_gadget = self:gadget_overrides_weapon_functions()

	if override_gadget then
		suppressed_switch = nil
	end

	self._sound_fire:set_switch("suppressed", suppressed_switch or "regular")
end

-- Lines 1042-1045
function NewRaycastWeaponBase:stance_id()
	return "new_m4"
end

-- Lines 1047-1049
function NewRaycastWeaponBase:weapon_hold()
	return self:weapon_tweak_data().weapon_hold
end

-- Lines 1053-1091
function NewRaycastWeaponBase:replenish()
	local ammo_max_multiplier = managers.player:upgrade_value("player", "extra_ammo_multiplier", 1)

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value(category, "extra_ammo_multiplier", 1)
	end

	ammo_max_multiplier = ammo_max_multiplier + ammo_max_multiplier * (self._total_ammo_mod or 0)

	if managers.player:has_category_upgrade("player", "add_armor_stat_skill_ammo_mul") then
		ammo_max_multiplier = ammo_max_multiplier * managers.player:body_armor_value("skill_ammo_mul", nil, 1)
	end

	ammo_max_multiplier = managers.modifiers:modify_value("WeaponBase:GetMaxAmmoMultiplier", ammo_max_multiplier)
	local ammo_max_per_clip = self:calculate_ammo_max_per_clip()
	local ammo_max = math.round((tweak_data.weapon[self._name_id].AMMO_MAX + managers.player:upgrade_value(self._name_id, "clip_amount_increase") * ammo_max_per_clip) * ammo_max_multiplier)
	ammo_max_per_clip = math.min(ammo_max_per_clip, ammo_max)

	self:set_ammo_max_per_clip(ammo_max_per_clip)
	self:set_ammo_max(ammo_max)
	self:set_ammo_total(ammo_max)
	self:set_ammo_remaining_in_clip(ammo_max_per_clip)

	self._ammo_pickup = tweak_data.weapon[self._name_id].AMMO_PICKUP

	if self._assembly_complete then
		for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
			if gadget and gadget.replenish then
				gadget:replenish()
			end
		end
	end

	self:update_damage()
end

-- Lines 1094-1096
function NewRaycastWeaponBase:update_damage()
	self._damage = ((self._current_stats and self._current_stats.damage or 0) + self:damage_addend()) * self:damage_multiplier()
end

-- Lines 1098-1134
function NewRaycastWeaponBase:calculate_ammo_max_per_clip()
	local added = 0
	local weapon_tweak_data = self:weapon_tweak_data()

	if self:is_category("shotgun") and tweak_data.weapon[self._name_id].has_magazine then
		added = managers.player:upgrade_value("shotgun", "magazine_capacity_inc", 0)

		if self:is_category("akimbo") then
			added = added * 2
		end
	elseif self:is_category("pistol") and not self:is_category("revolver") and managers.player:has_category_upgrade("pistol", "magazine_capacity_inc") then
		added = managers.player:upgrade_value("pistol", "magazine_capacity_inc", 0)

		if self:is_category("akimbo") then
			added = added * 2
		end
	elseif self:is_category("smg", "assault_rifle", "lmg") then
		added = managers.player:upgrade_value("player", "automatic_mag_increase", 0)

		if self:is_category("akimbo") then
			added = added * 2
		end
	end

	local ammo = tweak_data.weapon[self._name_id].CLIP_AMMO_MAX + added
	ammo = ammo + managers.player:upgrade_value(self._name_id, "clip_ammo_increase")

	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = ammo + managers.player:upgrade_value("weapon", "clip_ammo_increase", 0)
	end

	for _, category in ipairs(tweak_data.weapon[self._name_id].categories) do
		if not self:upgrade_blocked(category, "clip_ammo_increase") then
			ammo = ammo + managers.player:upgrade_value(category, "clip_ammo_increase", 0)
		end
	end

	ammo = ammo + (self._extra_ammo or 0)

	return ammo
end

-- Lines 1138-1140
function NewRaycastWeaponBase:movement_penalty()
	return self._movement_penalty or 1
end

-- Lines 1142-1144
function NewRaycastWeaponBase:armor_piercing_chance()
	return self._armor_piercing_chance or 0
end

-- Lines 1148-1150
function NewRaycastWeaponBase:get_reticle_obj()
	return self._reticle_obj
end

-- Lines 1154-1162
function NewRaycastWeaponBase:stance_mod()
	if not self._blueprint or not self._factory_id then
		return nil
	end

	local using_second_sight = self:is_second_sight_on()

	return managers.weapon_factory:get_stance_mod(self._factory_id, self._blueprint, self:is_second_sight_on())
end

-- Lines 1166-1174
function NewRaycastWeaponBase:_get_tweak_data_weapon_animation(anim)
	if self:gadget_overrides_weapon_functions() then
		local name = self:gadget_function_override("_get_tweak_data_weapon_animation", anim)

		return name
	end

	return anim
end

-- Lines 1177-1202
function NewRaycastWeaponBase:set_reload_objects_visible(visible, anim)
	local data = tweak_data.weapon.factory[self._factory_id]
	local reload_objects = anim and data.reload_objects and data.reload_objects[anim]

	if reload_objects then
		self._reload_objects[self._name_id] = reload_objects
	elseif self._reload_objects then
		reload_objects = self._reload_objects[self.name_id]
	end

	if reload_objects then
		self:set_objects_visible(self._unit, reload_objects, visible)
	end

	for part_id, part in pairs(self._parts) do
		local reload_objects = anim and part.reload_objects and part.reload_objects[anim]

		if reload_objects then
			self._reload_objects[part_id] = reload_objects
		elseif self._reload_objects then
			reload_objects = self._reload_objects[part_id]
		end

		if reload_objects then
			self:set_objects_visible(part.unit, reload_objects, visible)
		end
	end
end

-- Lines 1205-1255
function NewRaycastWeaponBase:tweak_data_anim_play(anim, speed_multiplier)
	local orig_anim = anim
	local unit_anim = self:_get_tweak_data_weapon_animation(orig_anim)
	local data = tweak_data.weapon.factory[self._factory_id]

	if data.animations and data.animations[unit_anim] then
		local anim_name = data.animations[unit_anim]
		local ids_anim_name = Idstring(anim_name)
		local length = self._unit:anim_length(ids_anim_name)
		speed_multiplier = speed_multiplier or 1

		self._unit:anim_stop(ids_anim_name)
		self._unit:anim_play_to(ids_anim_name, length, speed_multiplier)

		local offset = self:_get_anim_start_offset(anim_name)

		if offset then
			self._unit:anim_set_time(ids_anim_name, offset)
		end
	end

	for part_id, data in pairs(self._parts) do
		if data.unit and data.animations and data.animations[unit_anim] then
			local anim_name = data.animations[unit_anim]
			local ids_anim_name = Idstring(anim_name)
			local length = data.unit:anim_length(ids_anim_name)
			speed_multiplier = speed_multiplier or 1

			data.unit:anim_stop(ids_anim_name)
			data.unit:anim_play_to(ids_anim_name, length, speed_multiplier)

			local offset = self:_get_anim_start_offset(anim_name)

			if offset then
				data.unit:anim_set_time(ids_anim_name, offset)
			end
		end
	end

	self:set_reload_objects_visible(true, anim)
	NewRaycastWeaponBase.super.tweak_data_anim_play(self, orig_anim, speed_multiplier)

	return true
end

-- Lines 1258-1291
function NewRaycastWeaponBase:tweak_data_anim_play_at_end(anim, speed_multiplier)
	local orig_anim = anim
	local unit_anim = self:_get_tweak_data_weapon_animation(orig_anim)
	local data = tweak_data.weapon.factory[self._factory_id]

	if data.animations and data.animations[unit_anim] then
		local anim_name = data.animations[unit_anim]
		local ids_anim_name = Idstring(anim_name)
		local length = self._unit:anim_length(ids_anim_name)
		speed_multiplier = speed_multiplier or 1

		self._unit:anim_stop(ids_anim_name)
		self._unit:anim_play_to(ids_anim_name, length, speed_multiplier)
		self._unit:anim_set_time(ids_anim_name, length)
	end

	for part_id, data in pairs(self._parts) do
		if data.unit and data.animations and data.animations[unit_anim] then
			local anim_name = data.animations[unit_anim]
			local ids_anim_name = Idstring(anim_name)
			local length = data.unit:anim_length(ids_anim_name)
			speed_multiplier = speed_multiplier or 1

			data.unit:anim_stop(ids_anim_name)
			data.unit:anim_play_to(ids_anim_name, length, speed_multiplier)
			data.unit:anim_set_time(ids_anim_name, length)
		end
	end

	NewRaycastWeaponBase.super.tweak_data_anim_play_at_end(self, orig_anim, speed_multiplier)

	return true
end

-- Lines 1294-1319
function NewRaycastWeaponBase:tweak_data_anim_stop(anim)
	local orig_anim = anim
	local unit_anim = self:_get_tweak_data_weapon_animation(orig_anim)
	local data = tweak_data.weapon.factory[self._factory_id]

	if data.animations and data.animations[unit_anim] then
		local anim_name = data.animations[unit_anim]

		self._unit:anim_stop(Idstring(anim_name))
	end

	for part_id, data in pairs(self._parts) do
		if data.unit and data.animations and data.animations[unit_anim] then
			local anim_name = data.animations[unit_anim]

			data.unit:anim_stop(Idstring(anim_name))
		end
	end

	self:set_reload_objects_visible(false, anim)
	NewRaycastWeaponBase.super.tweak_data_anim_stop(self, orig_anim)
end

-- Lines 1322-1353
function NewRaycastWeaponBase:tweak_data_anim_is_playing(anim)
	local orig_anim = anim
	local unit_anim = self:_get_tweak_data_weapon_animation(orig_anim)
	local data = tweak_data.weapon.factory[self._factory_id]

	if data.animations and data.animations[unit_anim] then
		local anim_name = data.animations[unit_anim]

		if self._unit:anim_is_playing(Idstring(anim_name)) then
			return true
		end
	end

	for part_id, data in pairs(self._parts) do
		if data.unit and data.animations and data.animations[unit_anim] then
			local anim_name = data.animations[unit_anim]

			if data.unit:anim_is_playing(Idstring(anim_name)) then
				return
			end
		end
	end

	if NewRaycastWeaponBase.super.tweak_data_anim_is_playing(self, orig_anim) then
		return true
	end

	return false
end

-- Lines 1358-1391
function NewRaycastWeaponBase:_set_parts_enabled(enabled)
	if self._parts then
		local anim_groups = nil
		local empty_s = Idstring("")

		for part_id, data in pairs(self._parts) do
			if alive(data.unit) then
				if not enabled then
					anim_groups = data.unit:anim_groups()

					for _, anim in ipairs(anim_groups) do
						if anim ~= empty_s then
							data.unit:anim_play_to(anim, 0)
							data.unit:anim_stop()
						end
					end
				end

				data.unit:set_enabled(enabled)

				if data.unit:digital_gui() then
					data.unit:digital_gui():set_visible(enabled)
				end

				if data.unit:digital_gui_upper() then
					data.unit:digital_gui_upper():set_visible(enabled)
				end
			end
		end
	end
end

-- Lines 1393-1411
function NewRaycastWeaponBase:on_enabled(...)
	NewRaycastWeaponBase.super.on_enabled(self, ...)
	self:_set_parts_enabled(true)
	self:set_gadget_on(self._last_gadget_idx, false)

	if self:clip_empty() then
		self:tweak_data_anim_play_at_end("magazine_empty")
	end

	self:_chk_charm_upd_state()
end

-- Lines 1413-1425
function NewRaycastWeaponBase:on_disabled(...)
	if self:enabled() then
		self._last_gadget_idx = self._gadget_on

		self:gadget_off()
	end

	NewRaycastWeaponBase.super.on_disabled(self, ...)
	self:_set_parts_enabled(false)
	self:_chk_charm_upd_state()
end

-- Lines 1429-1431
function NewRaycastWeaponBase:_is_part_visible(part_id)
	return true
end

-- Lines 1433-1464
function NewRaycastWeaponBase:_set_parts_visible(visible)
	if self._parts then
		local is_visible = nil
		local is_player = self._setup.user_unit == managers.player:player_unit()
		local steelsight_swap_state = false

		if is_player then
			steelsight_swap_state = self._setup.user_unit:camera() and alive(self._setup.user_unit:camera():camera_unit()) and self._setup.user_unit:camera():camera_unit():base():get_steelsight_swap_state() or false
		end

		for part_id, data in pairs(self._parts) do
			local unit = data.unit or data.link_to_unit

			if alive(unit) then
				is_visible = visible and self:_is_part_visible(part_id)

				if self:is_second_sight_on() then
					is_visible = is_visible and not self._parts[part_id].steelsight_visible
				else
					is_visible = is_visible and (self._parts[part_id].steelsight_visible == nil or self._parts[part_id].steelsight_visible == steelsight_swap_state)
				end

				unit:set_visible(is_visible)
			end
		end
	end

	self:_chk_charm_upd_state()
end

-- Lines 1466-1469
function NewRaycastWeaponBase:set_visibility_state(state)
	NewRaycastWeaponBase.super.set_visibility_state(self, state)
	self:_set_parts_visible(state)
end

-- Lines 1472-1474
function NewRaycastWeaponBase:update_visibility_state()
	self:_set_parts_visible(self._unit:visible())
end

-- Lines 1477-1484
function NewRaycastWeaponBase:get_steelsight_swap_progress_trigger()
	local part = managers.weapon_factory:get_part_from_weapon_by_type("sight_swap", self._parts)

	if part and part.steelsight_swap_progress_trigger then
		return part.steelsight_swap_progress_trigger
	end

	return NewRaycastWeaponBase.super.get_steelsight_swap_progress_trigger(self)
end

-- Lines 1490-1501
function NewRaycastWeaponBase:fire_mode()
	if self:gadget_overrides_weapon_functions() then
		local firemode = self:gadget_function_override("fire_mode")

		if firemode ~= nil then
			return firemode
		end
	end

	self._fire_mode = self._locked_fire_mode or self._fire_mode or Idstring(tweak_data.weapon[self._name_id].FIRE_MODE or "single")

	return self._fire_mode == ids_single and "single" or "auto"
end

-- Lines 1505-1508
function NewRaycastWeaponBase:record_fire_mode()
	self._recorded_fire_modes = self._recorded_fire_modes or {}
	self._recorded_fire_modes[self:_weapon_tweak_data_id()] = self._fire_mode
end

-- Lines 1510-1515
function NewRaycastWeaponBase:get_recorded_fire_mode(id)
	if self._recorded_fire_modes and self._recorded_fire_modes[self:_weapon_tweak_data_id()] then
		return self._recorded_fire_modes[self:_weapon_tweak_data_id()]
	end

	return nil
end

-- Lines 1518-1528
function NewRaycastWeaponBase:recoil_wait()
	local tweak_is_auto = tweak_data.weapon[self._name_id].FIRE_MODE == "auto"
	local weapon_is_auto = self:fire_mode() == "auto"

	if not tweak_is_auto then
		return nil
	end

	local multiplier = tweak_is_auto == weapon_is_auto and 1 or 2

	return self:weapon_tweak_data().fire_mode_data.fire_rate * multiplier
end

-- Lines 1530-1537
function NewRaycastWeaponBase:can_toggle_firemode()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("can_toggle_firemode")
	end

	return tweak_data.weapon[self._name_id].CAN_TOGGLE_FIREMODE
end

-- Lines 1539-1558
function NewRaycastWeaponBase:toggle_firemode(skip_post_event)
	local can_toggle = not self._locked_fire_mode and self:can_toggle_firemode()

	if can_toggle then
		if self._fire_mode == ids_single then
			self._fire_mode = ids_auto

			if not skip_post_event then
				self._sound_fire:post_event("wp_auto_switch_on")
			end
		else
			self._fire_mode = ids_single

			if not skip_post_event then
				self._sound_fire:post_event("wp_auto_switch_off")
			end
		end

		return true
	end

	return false
end

-- Lines 1561-1565
function NewRaycastWeaponBase:set_ammo_remaining_in_clip(...)
	NewRaycastWeaponBase.super.set_ammo_remaining_in_clip(self, ...)
	self:check_bullet_objects()
end

-- Lines 1567-1571
function NewRaycastWeaponBase:check_bullet_objects()
	if self._bullet_objects then
		self:_update_bullet_objects("get_ammo_remaining_in_clip")
	end
end

-- Lines 1573-1575
function NewRaycastWeaponBase:predict_bullet_objects()
	self:_update_bullet_objects("get_ammo_total")
end

-- Lines 1577-1587
function NewRaycastWeaponBase:_update_bullet_objects(ammo_func)
	if self._bullet_objects then
		for i, objects in pairs(self._bullet_objects) do
			for _, object in ipairs(objects) do
				local ammo_base = self:ammo_base()
				local ammo = ammo_base[ammo_func](ammo_base)

				object[1]:set_visibility(i <= ammo)
			end
		end
	end
end

-- Lines 1591-1593
function NewRaycastWeaponBase:has_part(part_id)
	return self._blueprint and table.contains(self._blueprint, part_id)
end

-- Lines 1597-1612
function NewRaycastWeaponBase:on_equip(user_unit)
	NewRaycastWeaponBase.super.on_equip(self, user_unit)

	if self:was_gadget_on() then
		self:set_gadget_on(self._last_gadget_idx, false, nil)
		user_unit:network():send("set_weapon_gadget_state", self._gadget_on)

		local gadget = self:get_active_gadget()

		if gadget and gadget.color then
			local col = gadget:color()

			user_unit:network():send("set_weapon_gadget_color", col.r * 255, col.g * 255, col.b * 255)
		end
	end
end

-- Lines 1614-1616
function NewRaycastWeaponBase:on_unequip(user_unit)
	NewRaycastWeaponBase.super.on_unequip(self, user_unit)
end

-- Lines 1618-1620
function NewRaycastWeaponBase:has_gadget()
	return self._gadgets and #self._gadgets > 0
end

-- Lines 1622-1624
function NewRaycastWeaponBase:is_gadget_on()
	return self._gadget_on and self._gadget_on > 0
end

-- Lines 1626-1628
function NewRaycastWeaponBase:current_gadget_index()
	return self._gadget_on
end

-- Lines 1630-1632
function NewRaycastWeaponBase:gadget_on()
	self:set_gadget_on(1, true)
end

-- Lines 1634-1636
function NewRaycastWeaponBase:was_gadget_on()
	return self._last_gadget_idx and self._last_gadget_idx > 0 or false
end

-- Lines 1638-1641
function NewRaycastWeaponBase:gadget_off()
	self:set_gadget_on(0, true, nil)
end

-- Lines 1643-1660
function NewRaycastWeaponBase:set_gadget_on(gadget_on, ignore_enable, gadgets, current_state)
	if not ignore_enable and not self._enabled then
		return
	end

	if not self._assembly_complete then
		return
	end

	self._gadget_on = gadget_on or self._gadget_on
	local gadget = nil

	for i, id in ipairs(gadgets or self._gadgets) do
		gadget = self._parts[id]

		if gadget and alive(gadget.unit) then
			gadget.unit:base():set_state(self._gadget_on == i, self._sound_fire, current_state)
		end
	end
end

-- Lines 1663-1666
function NewRaycastWeaponBase:set_gadget_on_by_part_id(part_id, gadgets)
	local gadget_index = table.index_of(gadgets or self._gadgets, part_id)

	self:set_gadget_on(gadget_index, nil, gadgets, nil)
end

-- Lines 1668-1685
function NewRaycastWeaponBase:get_active_gadget()
	if not self._assembly_complete then
		return nil
	end

	local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("gadget", self._factory_id, self._blueprint)

	if gadgets then
		local gadget = nil

		for i, id in ipairs(gadgets) do
			gadget = self._parts[id]

			if gadget and gadget.unit:base():is_on() then
				return gadget.unit:base(), id
			end
		end
	end
end

-- Lines 1687-1708
function NewRaycastWeaponBase:set_gadget_color(color)
	if not self._enabled then
		return
	end

	if not self._assembly_complete then
		return
	end

	local gadgets = self._gadgets

	if gadgets then
		local gadget = nil

		for i, id in ipairs(gadgets) do
			gadget = self._parts[id]

			if gadget and gadget.unit:base() and gadget.unit:base().set_color then
				local alpha = gadget.unit:base().GADGET_TYPE == "laser" and tweak_data.custom_colors.defaults.laser_alpha or 1

				gadget.unit:base():set_color(color:with_alpha(alpha))
			end
		end
	end
end

local tmp_pos_vec = Vector3()

-- Lines 1713-1726
function NewRaycastWeaponBase:set_gadget_position(pos)
	if not self._enabled then
		return
	end

	local active_gadget = self:get_active_gadget()

	if active_gadget and active_gadget.set_position then
		mvec3_set(tmp_pos_vec, active_gadget._unit:position())
		mvec3_sub(tmp_pos_vec, self._unit:position())
		mvec3_add(tmp_pos_vec, pos)
		active_gadget:set_position(tmp_pos_vec)
	end
end

-- Lines 1728-1737
function NewRaycastWeaponBase:set_gadget_rotation(rot)
	if not self._enabled then
		return
	end

	local active_gadget = self:get_active_gadget()

	if active_gadget and active_gadget.set_rotation then
		active_gadget:set_rotation(rot)
	end
end

-- Lines 1740-1756
function NewRaycastWeaponBase:is_gadget_of_type_on(gadget_type)
	local gadget = nil

	for i, id in ipairs(gadgets) do
		gadget = self._parts[id]

		if gadget then
			local gadget_base = gadget.unit:base()
			local correct_type = gadget_base.GADGET_TYPE == gadget_type

			if correct_type and gadget_base:is_on() then
				return true
			end
		end
	end

	return false
end

-- Lines 1758-1773
function NewRaycastWeaponBase:toggle_gadget(current_state)
	if not self._enabled then
		return false
	end

	local gadget_on = self._gadget_on or 0
	local gadgets = self._gadgets

	if gadgets then
		gadget_on = (gadget_on + 1) % (#gadgets + 1)

		self:set_gadget_on(gadget_on, false, gadgets, current_state)

		return true
	end

	return false
end

-- Lines 1775-1777
function NewRaycastWeaponBase:gadget_update()
	self:set_gadget_on(false, true)
end

-- Lines 1779-1792
function NewRaycastWeaponBase:is_bipod_usable()
	local retval = false
	local bipod_part = managers.weapon_factory:get_parts_from_weapon_by_perk("bipod", self._parts)
	local bipod_unit = nil

	if bipod_part and bipod_part[1] then
		bipod_unit = bipod_part[1].unit:base()
	end

	if bipod_unit then
		retval = bipod_unit:is_usable()
	end

	return retval
end

-- Lines 1794-1808
function NewRaycastWeaponBase:gadget_toggle_requires_stance_update()
	if not self._enabled then
		return false
	end

	if not self:has_gadget() then
		return false
	end

	for _, part_id in ipairs(self._gadgets) do
		if self._parts[part_id].unit:base():toggle_requires_stance_update() then
			return true
		end
	end

	return false
end

-- Lines 1812-1852
function NewRaycastWeaponBase:check_stats()
	local base_stats = self:weapon_tweak_data().stats

	if not base_stats then
		print("no stats")

		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers
	local primary_category = self:weapon_tweak_data().categories and self:weapon_tweak_data().categories[1]
	stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(primary_category, "zoom_increase", 0), #tweak_data.zoom)

	for stat, _ in pairs(stats) do
		if parts_stats[stat] then
			stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
		end
	end

	self._current_stats = {}

	for stat, i in pairs(stats) do
		self._current_stats[stat] = tweak_data[stat][i]

		if modifier_stats and modifier_stats[stat] then
			self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
		end
	end

	self._current_stats.alert_size = tweak_data.alert_size[math_clamp(stats.alert_size, 1, #tweak_data.alert_size)]

	if modifier_stats and modifier_stats.alert_size then
		self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
	end

	return stats
end

-- Lines 1856-1864
function NewRaycastWeaponBase:_convert_add_to_mul(value)
	if value > 1 then
		return 1 / value
	elseif value < 1 then
		return math.abs(value - 1) + 1
	else
		return 1
	end
end

-- Lines 1866-1916
function NewRaycastWeaponBase:_get_spread(user_unit)
	local current_state = user_unit:movement()._current_state

	if not current_state then
		return 0, 0
	end

	local spread_values = self:weapon_tweak_data().spread

	if not spread_values then
		return 0, 0
	end

	local current_spread_value = spread_values[current_state:get_movement_state()]
	local spread_x, spread_y = nil

	if type(current_spread_value) == "number" then
		spread_x = self:_get_spread_from_number(user_unit, current_state, current_spread_value)
		spread_y = spread_x
	else
		spread_x, spread_y = self:_get_spread_from_table(user_unit, current_state, current_spread_value)
	end

	if current_state:in_steelsight() then
		local steelsight_tweak = spread_values.steelsight
		local multi_x, multi_y = nil

		if type(steelsight_tweak) == "number" then
			multi_x = 1 + 1 - steelsight_tweak
			multi_y = multi_x
		else
			multi_x = 1 + 1 - steelsight_tweak[1]
			multi_y = 1 + 1 - steelsight_tweak[2]
		end

		spread_x = spread_x * multi_x
		spread_y = spread_y * multi_y
	end

	if self._spread_multiplier then
		spread_x = spread_x * self._spread_multiplier[1]
		spread_y = spread_y * self._spread_multiplier[2]
	end

	return spread_x, spread_y
end

-- Lines 1918-1921
function NewRaycastWeaponBase:_get_spread_from_number(user_unit, current_state, current_spread_value)
	local spread = self:_get_spread_indices(current_state)

	return math.max(spread * current_spread_value, 0)
end

-- Lines 1923-1926
function NewRaycastWeaponBase:_get_spread_from_table(user_unit, current_state, current_spread_value)
	local spread_idx_x, spread_idx_y = self:_get_spread_indices(current_state)

	return math.max(spread_idx_x * current_spread_value[1], 0), math.max(spread_idx_y * current_spread_value[2], 0)
end

-- Lines 1928-1943
function NewRaycastWeaponBase:_get_spread_indices(current_state)
	local spread_index = self._current_stats_indices and self._current_stats_indices.spread or 1
	local spread_idx_x, spread_idx_y = nil

	if type(spread_index) == "number" then
		spread_idx_x = self:_get_spread_index(current_state, spread_index)
		spread_idx_y = spread_idx_x
	else
		spread_idx_x = self:_get_spread_index(current_state, spread_index[1])
		spread_idx_y = self:_get_spread_index(current_state, spread_index[2])
	end

	return spread_idx_x, spread_idx_y
end

-- Lines 1945-1960
function NewRaycastWeaponBase:_get_spread_index(current_state, spread_index)
	local cond_spread_addend = self:conditional_accuracy_addend(current_state)
	local spread_multiplier = 1
	spread_multiplier = spread_multiplier - (1 - self:spread_multiplier(current_state))
	spread_multiplier = spread_multiplier - (1 - self:conditional_accuracy_multiplier(current_state))
	spread_multiplier = self:_convert_add_to_mul(spread_multiplier)
	local spread_addend = self:spread_index_addend(current_state) + cond_spread_addend
	spread_index = math.ceil((spread_index + spread_addend) * spread_multiplier)
	spread_index = math.clamp(spread_index, 1, #tweak_data.weapon.stats.spread)

	return tweak_data.weapon.stats.spread[spread_index]
end

-- Lines 1962-1990
function NewRaycastWeaponBase:conditional_accuracy_addend(current_state)
	local index = 0

	if not current_state then
		return index
	end

	local pm = managers.player

	if not current_state:in_steelsight() then
		index = index + pm:upgrade_value("player", "hip_fire_accuracy_inc", 0)
	end

	if self:is_single_shot() and self:is_category("assault_rifle", "smg", "snp") then
		index = index + pm:upgrade_value("weapon", "single_spread_index_addend", 0)
	elseif not self:is_single_shot() then
		index = index + pm:upgrade_value("weapon", "auto_spread_index_addend", 0)
	end

	if not current_state._moving then
		index = index + pm:upgrade_value("player", "not_moving_accuracy_increase", 0)
	end

	if current_state._moving then
		for _, category in ipairs(self:categories()) do
			index = index + pm:upgrade_value(category, "move_spread_index_addend", 0)
		end
	end

	return index
end

-- Lines 1992-2017
function NewRaycastWeaponBase:conditional_accuracy_multiplier(current_state)
	local mul = 1

	if not current_state then
		return mul
	end

	local pm = managers.player

	if current_state:in_steelsight() and self:is_single_shot() then
		mul = mul + 1 - pm:upgrade_value("player", "single_shot_accuracy_inc", 1)
	end

	if current_state:in_steelsight() then
		for _, category in ipairs(self:categories()) do
			mul = mul + 1 - managers.player:upgrade_value(category, "steelsight_accuracy_inc", 1)
		end
	end

	if current_state._moving then
		mul = mul + 1 - pm:upgrade_value("player", "weapon_movement_stability", 1)
	end

	mul = mul + 1 - pm:get_property("desperado", 1)

	return self:_convert_add_to_mul(mul)
end

-- Lines 2019-2021
function NewRaycastWeaponBase:fire_rate_multiplier()
	return self._fire_rate_multiplier
end

-- Lines 2023-2028
function NewRaycastWeaponBase:damage_addend()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state

	return managers.blackmarket:damage_addend(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint)
end

-- Lines 2030-2035
function NewRaycastWeaponBase:damage_multiplier()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state

	return managers.blackmarket:damage_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, nil, current_state, self._blueprint)
end

-- Lines 2037-2039
function NewRaycastWeaponBase:melee_damage_multiplier()
	return managers.player:upgrade_value(self._name_id, "melee_multiplier", 1)
end

-- Lines 2042-2044
function NewRaycastWeaponBase:spread_addend(current_state)
	return managers.blackmarket:accuracy_addend(self._name_id, self:categories(), self._current_stats_indices and self._current_stats_indices.spread, self._silencer, current_state, self:fire_mode(), self._blueprint, current_state._moving, self:is_single_shot())
end

-- Lines 2046-2048
function NewRaycastWeaponBase:spread_index_addend(current_state)
	return managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, current_state, self:fire_mode(), self._blueprint)
end

-- Lines 2050-2052
function NewRaycastWeaponBase:spread_multiplier(current_state)
	return managers.blackmarket:accuracy_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, current_state, self._spread_moving, self:fire_mode(), self._blueprint, self:is_single_shot())
end

-- Lines 2054-2058
function NewRaycastWeaponBase:recoil_addend()
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state

	return managers.blackmarket:recoil_addend(self._name_id, self:weapon_tweak_data().categories, self._current_stats_indices and self._current_stats_indices.recoil, self._silencer, self._blueprint, current_state, self:is_single_shot())
end

-- Lines 2060-2067
function NewRaycastWeaponBase:recoil_multiplier()
	local is_moving = false
	local user_unit = self._setup and self._setup.user_unit

	if user_unit then
		is_moving = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state and user_unit:movement()._current_state._moving
	end

	return managers.blackmarket:recoil_multiplier(self._name_id, self:weapon_tweak_data().categories, self._silencer, self._blueprint, is_moving)
end

-- Lines 2069-2088
function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local multiplier = 1
	local categories = self:weapon_tweak_data().categories

	for _, category in ipairs(categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "combat_medic_enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value(self._name_id, "enter_steelsight_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1)

	if self._silencer then
		multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1)

		for _, category in ipairs(categories) do
			multiplier = multiplier + 1 - managers.player:upgrade_value(category, "silencer_enter_steelsight_speed_multiplier", 1)
		end
	end

	return self:_convert_add_to_mul(multiplier)
end

-- Lines 2090-2148
function NewRaycastWeaponBase:reload_speed_multiplier()
	if self._current_reload_speed_multiplier then
		return self._current_reload_speed_multiplier
	end

	local multiplier = 1

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "passive_reload_speed_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value(self._name_id, "reload_speed_multiplier", 1)

	if self._setup and alive(self._setup.user_unit) and self._setup.user_unit:movement() then
		local morale_boost_bonus = self._setup.user_unit:movement():morale_boost()

		if morale_boost_bonus then
			multiplier = multiplier + 1 - morale_boost_bonus.reload_speed_bonus
		end

		if self._setup.user_unit:movement():next_reload_speed_multiplier() then
			multiplier = multiplier + 1 - self._setup.user_unit:movement():next_reload_speed_multiplier()
		end
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "reload_weapon_faster") then
		multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "reload_weapon_faster", 1)
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "single_shot_fast_reload") then
		multiplier = multiplier + 1 - managers.player:temporary_upgrade_value("temporary", "single_shot_fast_reload", 1)
	end

	multiplier = multiplier + 1 - managers.player:get_property("shock_and_awe_reload_multiplier", 1)
	multiplier = multiplier + 1 - managers.player:get_temporary_property("bloodthirst_reload_speed", 1)
	multiplier = multiplier + 1 - managers.player:upgrade_value("team", "crew_faster_reload", 1)
	multiplier = self:_convert_add_to_mul(multiplier)
	multiplier = multiplier * self:reload_speed_stat()
	multiplier = managers.modifiers:modify_value("WeaponBase:GetReloadSpeedMultiplier", multiplier)

	return multiplier
end

-- Lines 2152-2162
function NewRaycastWeaponBase:_debug_bipod()
	for i, id in ipairs(self._gadgets) do
		gadget = self._parts[id]

		if gadget then
			local is_bipod = gadget.unit:base():is_bipod()

			if is_bipod then
				gadget.unit:base():_shoot_bipod_rays(true)
			end
		end
	end
end

-- Lines 2166-2172
function NewRaycastWeaponBase:reload_expire_t()
	if self._use_shotgun_reload then
		local ammo_remaining_in_clip = self:get_ammo_remaining_in_clip()

		return math.min(self:get_ammo_total() - ammo_remaining_in_clip, self:get_ammo_max_per_clip() - ammo_remaining_in_clip) * self:reload_shell_expire_t()
	end

	return nil
end

-- Lines 2174-2179
function NewRaycastWeaponBase:reload_enter_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_enter or 0.3
	end

	return nil
end

-- Lines 2181-2186
function NewRaycastWeaponBase:reload_exit_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_exit_empty or 0.7
	end

	return nil
end

-- Lines 2188-2193
function NewRaycastWeaponBase:reload_not_empty_exit_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_exit_not_empty or 0.3
	end

	return nil
end

-- Lines 2195-2200
function NewRaycastWeaponBase:reload_shell_expire_t()
	if self._use_shotgun_reload then
		return self:weapon_tweak_data().timers.shotgun_reload_shell or 0.5666666666666667
	end

	return nil
end

-- Lines 2202-2207
function NewRaycastWeaponBase:_first_shell_reload_expire_t()
	if self._use_shotgun_reload then
		return self:reload_shell_expire_t() - (self:weapon_tweak_data().timers.shotgun_reload_first_shell_offset or 0.33)
	end

	return nil
end

-- Lines 2210-2219
function NewRaycastWeaponBase:start_reload(...)
	NewRaycastWeaponBase.super.start_reload(self, ...)

	if self._use_shotgun_reload then
		self._started_reload_empty = self:clip_empty()
		local speed_multiplier = self:reload_speed_multiplier()
		self._next_shell_reloded_t = managers.player:player_timer():time() + self:_first_shell_reload_expire_t() / speed_multiplier
		self._current_reload_speed_multiplier = speed_multiplier
	end
end

-- Lines 2221-2226
function NewRaycastWeaponBase:started_reload_empty()
	if self._use_shotgun_reload then
		return self._started_reload_empty
	end

	return nil
end

-- Lines 2229-2239
function NewRaycastWeaponBase:update_reloading(t, dt, time_left)
	if self._use_shotgun_reload and self._next_shell_reloded_t and self._next_shell_reloded_t < t then
		local speed_multiplier = self:reload_speed_multiplier()
		self._next_shell_reloded_t = self._next_shell_reloded_t + self:reload_shell_expire_t() / speed_multiplier

		self:set_ammo_remaining_in_clip(math.min(self:get_ammo_max_per_clip(), self:get_ammo_remaining_in_clip() + 1))
		managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

		return true
	end
end

-- Lines 2241-2248
function NewRaycastWeaponBase:reload_prefix()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("reload_prefix")
	end

	return ""
end

-- Lines 2251-2256
function NewRaycastWeaponBase:reload_interuptable()
	if self._use_shotgun_reload then
		return true
	end

	return false
end

-- Lines 2258-2266
function NewRaycastWeaponBase:shotgun_shell_data()
	if self._use_shotgun_reload then
		local reload_shell_data = self:weapon_tweak_data().animations.reload_shell_data
		local unit_name = reload_shell_data and reload_shell_data.unit_name or "units/payday2/weapons/wpn_fps_shell/wpn_fps_shell"
		local align = reload_shell_data and reload_shell_data.align or nil

		return {
			unit_name = unit_name,
			align = align
		}
	end

	return nil
end

-- Lines 2268-2281
function NewRaycastWeaponBase:on_reload_stop()
	self._bloodthist_value_during_reload = 0
	self._current_reload_speed_multiplier = nil
	local user_unit = managers.player:player_unit()

	if user_unit then
		user_unit:movement():current_state():send_reload_interupt()
	end

	self:set_reload_objects_visible(false)

	self._reload_objects = {}
end

-- Lines 2283-2295
function NewRaycastWeaponBase:on_reload(...)
	NewRaycastWeaponBase.super.on_reload(self, ...)

	local user_unit = managers.player:player_unit()

	if user_unit then
		user_unit:movement():current_state():send_reload_interupt()
	end

	self:set_reload_objects_visible(false)

	self._reload_objects = {}
end

-- Lines 2299-2311
function NewRaycastWeaponBase:set_timer(timer, ...)
	NewRaycastWeaponBase.super.set_timer(self, timer)

	if self._assembly_complete then
		for id, data in pairs(self._parts) do
			if not alive(data.unit) then
				Application:error("[NewRaycastWeaponBase:set_timer] Missing unit in weapon parts!", "weapon id", self._name_id, "part id", id, "part", inspect(data), "parts", inspect(self._parts), "blueprint", inspect(self._blueprint), "assembly_complete", self._assembly_complete, "self", inspect(self))
			end

			data.unit:set_timer(timer)
			data.unit:set_animation_timer(timer)
		end
	end
end

-- Lines 2315-2340
function NewRaycastWeaponBase:destroy(unit)
	NewRaycastWeaponBase.super.destroy(self, unit)

	if self._parts_texture_switches then
		for part_id, texture_ids in pairs(self._parts_texture_switches) do
			TextureCache:unretrieve(texture_ids)
		end
	end

	if self._textures then
		for tex_id, texture_data in pairs(self._textures) do
			if not texture_data.applied then
				texture_data.applied = true

				TextureCache:unretrieve(texture_data.name)
			end
		end
	end

	if self._charm_data then
		managers.charm:remove_weapon(unit)
	end

	managers.weapon_factory:disassemble(self._parts)
end

-- Lines 2342-2352
function NewRaycastWeaponBase:is_single_shot()
	if self:gadget_overrides_weapon_functions() then
		local gadget_shot = self:gadget_function_override("is_single_shot")

		if gadget_shot ~= nil then
			return gadget_shot
		end
	end

	return self:fire_mode() == "single"
end

-- Lines 2357-2378
function NewRaycastWeaponBase:gadget_overrides_weapon_functions()
	if self._cached_gadget == nil and self._assembly_complete then
		local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("underbarrel", self._factory_id, self._blueprint)
		local gadget = nil

		for i, id in ipairs(gadgets) do
			gadget = self._parts[id]

			if gadget then
				local gadget_base = gadget.unit and gadget.unit:base() or gadget.base and gadget:base()

				if gadget_base and gadget_base:is_on() and gadget_base:overrides_weapon_firing() then
					self._cached_gadget = gadget_base
				end
			end
		end

		if self._cached_gadget == nil then
			self._cached_gadget = false
		end
	end

	return self._cached_gadget
end

-- Lines 2380-2383
function NewRaycastWeaponBase:reset_cached_gadget()
	self._cached_gadget = nil

	self:gadget_overrides_weapon_functions()
end

-- Lines 2385-2403
function NewRaycastWeaponBase:get_all_override_weapon_gadgets()
	if self._cached_gadgets == nil and self._assembly_complete then
		self._cached_gadgets = {}
		local gadgets = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("underbarrel", self._factory_id, self._blueprint)
		local gadget = nil

		for i, id in ipairs(gadgets) do
			gadget = self._parts[id]

			if gadget then
				local gadget_base = gadget.unit:base()

				if gadget_base and gadget_base:overrides_weapon_firing() then
					table.insert(self._cached_gadgets, gadget_base)
				end
			end
		end
	end

	return self._cached_gadgets or {}
end

-- Lines 2405-2410
function NewRaycastWeaponBase:gadget_function_override(func, ...)
	local gadget = self:gadget_overrides_weapon_functions()

	if gadget and gadget[func] then
		return gadget[func](gadget, ...)
	end
end

-- Lines 2412-2420
function NewRaycastWeaponBase:underbarrel_toggle()
	local underbarrel_part = managers.weapon_factory:get_part_from_weapon_by_type("underbarrel", self._parts)

	if underbarrel_part and alive(underbarrel_part.unit) and underbarrel_part.unit:base() and underbarrel_part.unit:base().toggle then
		underbarrel_part.unit:base():toggle()

		return underbarrel_part.unit:base():is_on()
	end

	return nil
end

-- Lines 2422-2427
function NewRaycastWeaponBase:underbarrel_name_id()
	local underbarrel_part = managers.weapon_factory:get_part_from_weapon_by_type("underbarrel", self._parts)

	if underbarrel_part and alive(underbarrel_part.unit) and underbarrel_part.unit:base() then
		return underbarrel_part.unit:base().name_id or underbarrel_part.unit:base()._name_id
	end
end

-- Lines 2432-2449
function NewRaycastWeaponBase:set_magazine_empty(is_empty)
	NewRaycastWeaponBase.super.set_magazine_empty(self, is_empty)

	for part_id, part in pairs(self._parts) do
		local magazine_empty_objects = part.magazine_empty_objects

		if magazine_empty_objects then
			self._magazine_empty_objects[part_id] = magazine_empty_objects
		elseif self._magazine_empty_objects then
			magazine_empty_objects = self._magazine_empty_objects[part_id]
		end

		if magazine_empty_objects then
			self:set_objects_visible(part.unit, magazine_empty_objects, not is_empty)
		end
	end
end

if _G.IS_VR then
	require("lib/units/weapons/vr/NewRaycastWeaponBaseVR")
end
