PlayerEquipment = PlayerEquipment or class()

-- Lines 5-7
function PlayerEquipment:init(unit)
	self._unit = unit
end

-- Lines 11-13
function PlayerEquipment:_m_deploy_rot()
	return self._unit:movement():m_head_rot()
end

-- Lines 17-22
function PlayerEquipment:on_deploy_interupted()
	if alive(self._dummy_unit) then
		World:delete_unit(self._dummy_unit)

		self._dummy_unit = nil
	end
end

-- Lines 25-45
function PlayerEquipment:valid_look_at_placement(equipment_data)
	local from = self._unit:movement():m_head_pos()
	local to = from + self._unit:movement():m_head_rot():y() * 200
	local ray = self._unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {}, "ray_type", "equipment_placement")

	if ray and equipment_data and equipment_data.dummy_unit then
		local pos = ray.position
		local rot = Rotation(ray.normal, math.UP)

		if not alive(self._dummy_unit) then
			self._dummy_unit = World:spawn_unit(Idstring(equipment_data.dummy_unit), pos, rot)

			self:_disable_contour(self._dummy_unit)
		end

		self._dummy_unit:set_position(pos)
		self._dummy_unit:set_rotation(rot)
	end

	if alive(self._dummy_unit) then
		self._dummy_unit:set_enabled(ray and true or false)
	end

	return ray
end

-- Lines 47-64
function PlayerEquipment:use_trip_mine()
	local ray = self:valid_look_at_placement()

	if ray then
		managers.statistics:use_trip_mine()

		local sensor_upgrade = managers.player:has_category_upgrade("trip_mine", "sensor_toggle")

		if Network:is_client() then
			managers.network:session():send_to_host("place_trip_mine", ray.position, ray.normal, sensor_upgrade)
		else
			local rot = Rotation(ray.normal, math.UP)
			local unit = TripMineBase.spawn(ray.position, rot, sensor_upgrade, managers.network:session():local_peer():id())

			unit:base():set_active(true, self._unit)
		end

		return true
	end

	return false
end

-- Lines 67-84
function PlayerEquipment:valid_placement(equipment_data)
	local valid = not self._unit:movement():current_state():in_air()
	local pos = self._unit:movement():m_pos()
	local rot = self._unit:movement():m_head_rot()
	rot = Rotation(rot:yaw(), 0, 0)

	if equipment_data and equipment_data.dummy_unit then
		if not alive(self._dummy_unit) then
			self._dummy_unit = World:spawn_unit(Idstring(equipment_data.dummy_unit), pos, rot)

			self:_disable_contour(self._dummy_unit)
		end

		self._dummy_unit:set_position(pos)
		self._dummy_unit:set_rotation(rot)

		if alive(self._dummy_unit) then
			self._dummy_unit:set_enabled(valid)
		end
	end

	return valid
end

local ids_contour_color = Idstring("contour_color")
local ids_contour_opacity = Idstring("contour_opacity")
local ids_material = Idstring("material")

-- Lines 89-96
function PlayerEquipment:_disable_contour(unit)
	local materials = unit:get_objects_by_type(ids_material)

	for _, m in ipairs(materials) do
		m:set_variable(ids_contour_opacity, 0)
	end
end

-- Lines 98-119
function PlayerEquipment:use_ammo_bag()
	local ray = self:valid_shape_placement("ammo_bag")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		PlayerStandard.say_line(self, "s01x_plu")
		managers.statistics:use_ammo_bag()

		local ammo_upgrade_lvl = managers.player:upgrade_level("ammo_bag", "ammo_increase")
		local bullet_storm_level = managers.player:upgrade_level("player", "no_ammo_cost")

		if Network:is_client() then
			managers.network:session():send_to_host("place_ammo_bag", pos, rot, ammo_upgrade_lvl, bullet_storm_level)
		else
			local unit = AmmoBagBase.spawn(pos, rot, ammo_upgrade_lvl, managers.network:session():local_peer():id(), bullet_storm_level)
		end

		return true
	end

	return false
end

-- Lines 121-158
function PlayerEquipment:use_doctor_bag()
	local ray = self:valid_shape_placement("doctor_bag")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		PlayerStandard.say_line(self, "s02x_plu")

		if managers.blackmarket:equipped_mask().mask_id == tweak_data.achievement.no_we_cant.mask then
			managers.achievment:award_progress(tweak_data.achievement.no_we_cant.stat)
		end

		managers.mission:call_global_event("player_deploy_doctorbag")
		managers.statistics:use_doctor_bag()

		local upgrade_lvl = managers.player:upgrade_level("first_aid_kit", "damage_reduction_upgrade")
		local amount_upgrade_lvl = managers.player:upgrade_level("doctor_bag", "amount_increase")
		upgrade_lvl = math.clamp(upgrade_lvl, 0, 2)
		amount_upgrade_lvl = math.clamp(amount_upgrade_lvl, 0, 2)
		local bits = Bitwise:lshift(upgrade_lvl, DoctorBagBase.damage_reduce_lvl_shift) + Bitwise:lshift(amount_upgrade_lvl, DoctorBagBase.amount_upgrade_lvl_shift)

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "DoctorBagBase", pos, rot, bits)
		else
			local unit = DoctorBagBase.spawn(pos, rot, bits, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

-- Lines 160-184
function PlayerEquipment:use_first_aid_kit()
	local ray = self:valid_shape_placement("first_aid_kit")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		PlayerStandard.say_line(self, "s12")
		managers.statistics:use_first_aid()

		local upgrade_lvl = managers.player:has_category_upgrade("first_aid_kit", "damage_reduction_upgrade") and 1 or 0
		local auto_recovery = managers.player:has_category_upgrade("first_aid_kit", "first_aid_kit_auto_recovery") and 1 or 0
		local bits = Bitwise:lshift(auto_recovery, FirstAidKitBase.auto_recovery_shift) + Bitwise:lshift(upgrade_lvl, FirstAidKitBase.upgrade_lvl_shift)

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "FirstAidKitBase", pos, rot, bits)
		else
			local unit = FirstAidKitBase.spawn(pos, rot, bits, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

-- Lines 186-199
function PlayerEquipment:use_armor_kit()
	-- Lines 187-197
	local function redirect()
		if Network:is_client() then
			managers.network:session():send_to_host("used_deployable")
		else
			managers.network:session():local_peer():set_used_deployable(true)
		end

		managers.statistics:use_armor_bag()
		MenuCallbackHandler:_update_outfit_information()
		self._unit:event_listener():call("on_use_armor_bag")
	end

	return true, redirect
end

-- Lines 201-204
function PlayerEquipment:use_armor_kit_dropin_penalty()
	MenuCallbackHandler:_update_outfit_information()

	return true
end

-- Lines 206-231
function PlayerEquipment:use_bodybags_bag()
	local ray = self:valid_shape_placement("bodybags_bag")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		PlayerStandard.say_line(self, "s13")
		managers.mission:call_global_event("player_deploy_bodybagsbag")
		managers.statistics:use_body_bag()

		local amount_upgrade_lvl = 0

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "BodyBagsBagBase", pos, rot, amount_upgrade_lvl)
		else
			local unit = BodyBagsBagBase.spawn(pos, rot, amount_upgrade_lvl, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

-- Lines 234-254
function PlayerEquipment:use_grenade_crate()
	local ray = self:valid_shape_placement("grenade_crate")

	if ray then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		managers.statistics:use_body_bag()

		local amount_upgrade_lvl = 0

		if Network:is_client() then
			managers.network:session():send_to_host("place_deployable_bag", "GrenadeCrateDeployableBase", pos, rot, amount_upgrade_lvl)
		else
			local unit = GrenadeCrateDeployableBase.spawn(pos, rot, amount_upgrade_lvl, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end

-- Lines 257-332
function PlayerEquipment:use_ecm_jammer()
	if self._ecm_jammer_placement_requested then
		return
	end

	local ray = self:valid_look_at_placement()

	if ray then
		local attach_unit = ray.unit
		local attach_sync_unit, attach_sync_unit_id = nil

		if attach_unit:id() ~= -1 then
			attach_sync_unit = attach_unit
			attach_sync_unit_id = ""
		else
			local attach_unit_key = attach_unit:key()

			-- Lines 273-281
			local function verify_id_for_sync(id)
				local world_unit = managers.worlddefinition:get_unit(id)

				if alive(world_unit) and world_unit:key() == attach_unit_key then
					return id
				end
			end

			local attach_unit_id = attach_unit:unit_data().unit_id
			attach_sync_unit_id = attach_unit_id ~= 0 and verify_id_for_sync(attach_unit_id) or verify_id_for_sync(attach_unit:editor_id()) or nil

			if type(attach_sync_unit_id) == "number" then
				attach_sync_unit_id = tostring(attach_sync_unit_id) .. "ISNUMBER"
			end
		end

		if attach_sync_unit or attach_sync_unit_id then
			managers.mission:call_global_event("player_deploy_ecmjammer")
			managers.statistics:use_ecm_jammer()

			local attach_body = ray.body
			local world_pos = ray.position
			local world_rot = Rotation()

			mrotation.set_look_at(world_rot, ray.normal, math.UP)

			local relative_pos = mvector3.copy(world_pos)

			mvector3.subtract(relative_pos, attach_body:position())

			local relative_rot = attach_body:rotation()

			mrotation.invert(relative_rot)
			mvector3.rotate_with(relative_pos, relative_rot)
			mrotation.multiply(relative_rot, world_rot)

			relative_rot = Rotation(relative_rot:yaw(), relative_rot:pitch(), relative_rot:roll())
			local sync_body_index = attach_unit:get_body_index(attach_body:name())
			local duration_multiplier = managers.player:upgrade_level("ecm_jammer", "duration_multiplier", 0) + managers.player:upgrade_level("ecm_jammer", "duration_multiplier_2", 0) + 1

			if Network:is_client() then
				self._ecm_jammer_placement_requested = true

				managers.network:session():send_to_host("request_place_ecm_jammer", attach_sync_unit, attach_sync_unit_id, sync_body_index, mvector3.copy(world_pos), world_rot, relative_pos, relative_rot, duration_multiplier)
			else
				local unit = ECMJammerBase.spawn(world_pos, world_rot, duration_multiplier, self._unit, managers.network:session():local_peer():id())

				unit:base():set_active(true)
				unit:base():link_attachment(attach_body, relative_pos, relative_rot)
				managers.network:session():send_to_peers_synched("sync_deployable_attachment", unit, attach_sync_unit, attach_sync_unit_id, sync_body_index, relative_pos, relative_rot)
			end
		else
			Application:error("[PlayerEquipment:use_ecm_jammer] Attach unit is not networked and cannot be found in world definition, preventing placement. Unit id: " .. tostring(attach_unit:unit_data().unit_id) .. " | Editor id: " .. tostring(attach_unit:editor_id()) .. " | Unit:", inspect(attach_unit))
		end

		return true
	end

	return false
end

-- Lines 334-336
function PlayerEquipment:from_server_ecm_jammer_placement_result()
	self._ecm_jammer_placement_requested = nil
end

-- Lines 338-350
function PlayerEquipment:_spawn_dummy(dummy_name, pos, rot)
	if alive(self._dummy_unit) then
		return self._dummy_unit
	end

	self._dummy_unit = World:spawn_unit(Idstring(dummy_name), pos, rot)

	for i = 0, self._dummy_unit:num_bodies() - 1 do
		self._dummy_unit:body(i):set_enabled(false)
	end

	return self._dummy_unit
end

-- Lines 352-401
function PlayerEquipment:valid_shape_placement(equipment_id, equipment_data)
	local from = self._unit:movement():m_head_pos()
	local to = from + self._unit:movement():m_head_rot():y() * 220
	local ray = self._unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {}, "ray_type", "equipment_placement")
	local valid = ray and true or false

	if ray then
		local pos = ray.position
		local rot = self._unit:movement():m_head_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		if not alive(self._dummy_unit) then
			self._dummy_unit = World:spawn_unit(Idstring(equipment_data.dummy_unit), pos, rot)

			self:_disable_contour(self._dummy_unit)
		end

		self._dummy_unit:set_position(pos)
		self._dummy_unit:set_rotation(rot)

		valid = valid and math.dot(ray.normal, math.UP) > 0.25
		local find_start_pos, find_end_pos, find_radius = nil

		if equipment_id == "ammo_bag" then
			find_start_pos = pos + math.UP * 20
			find_end_pos = pos + math.UP * 21
			find_radius = 12
		elseif equipment_id == "doctor_bag" then
			find_start_pos = pos + math.UP * 22
			find_end_pos = pos + math.UP * 28
			find_radius = 15
		else
			find_start_pos = pos + math.UP * 30
			find_end_pos = pos + math.UP * 40
			find_radius = 17
		end

		local bodies = self._dummy_unit:find_bodies("intersect", "capsule", find_start_pos, find_end_pos, find_radius, managers.slot:get_mask("trip_mine_placeables") + 14 + 25)

		for _, body in ipairs(bodies) do
			if body:unit() ~= self._dummy_unit and body:has_ray_type(Idstring("body")) then
				valid = false

				break
			end
		end
	end

	if alive(self._dummy_unit) then
		self._dummy_unit:set_enabled(valid)
	end

	return valid and ray
end

-- Lines 404-421
function PlayerEquipment:_can_place(eq_id)
	if eq_id == "sentry_gun" then
		local equipment_data = managers.player:selected_equipment()

		if not equipment_data then
			return false
		end

		local min_ammo_cost = SentryGunBase.MIN_DEPLOYEMENT_COST
		local inventory = self._unit:inventory()

		for _, weapon in pairs(inventory:available_selections()) do
			if weapon.unit:base():get_ammo_ratio() < min_ammo_cost then
				managers.hint:show_hint("sentry_not_enough_ammo_to_place")

				return false
			end
		end
	end

	return true
end

-- Lines 424-442
function PlayerEquipment:_sentry_gun_ammo_cost(sentry_uid)
	local equipment_data = managers.player:selected_equipment()

	if not equipment_data then
		return
	end

	local equipment_tweak_data = tweak_data.equipments[equipment_data.equipment]

	if not equipment_tweak_data.ammo_cost then
		return
	end

	local deployement_cost = SentryGunBase.DEPLOYEMENT_COST[managers.player:upgrade_value("sentry_gun", "cost_reduction", 1)]
	local inventory = self._unit:inventory()
	local hud = managers.hud
	self._sentry_ammo_cost = self._sentry_ammo_cost or {}
	self._sentry_ammo_cost[sentry_uid] = self._sentry_ammo_cost[sentry_uid] or {
		{},
		{}
	}

	for index, weapon in pairs(inventory:available_selections()) do
		local ammo_taken = weapon.unit:base():remove_ammo(deployement_cost)
		self._sentry_ammo_cost[sentry_uid][index] = ammo_taken

		hud:set_ammo_amount(index, weapon.unit:base():ammo_info())
	end
end

-- Lines 444-450
function PlayerEquipment:get_sentry_deployement_cost(sentry_uid)
	if self._sentry_ammo_cost and self._sentry_ammo_cost[sentry_uid] then
		return self._sentry_ammo_cost[sentry_uid]
	end

	return nil
end

-- Lines 452-456
function PlayerEquipment:remove_sentry_deployement_cost(sentry_uid)
	if self._sentry_ammo_cost and self._sentry_ammo_cost[sentry_uid] then
		self._sentry_ammo_cost[sentry_uid] = nil
	end
end

-- Lines 458-500
function PlayerEquipment:use_sentry_gun(selected_index, unit_idstring_index)
	if self._sentrygun_placement_requested then
		return
	end

	local ray = self:valid_shape_placement()

	if ray and self:_can_place("sentry_gun") then
		local pos = ray.position
		local rot = self:_m_deploy_rot()
		rot = Rotation(rot:yaw(), 0, 0)

		managers.statistics:use_sentry_gun()

		local ammo_level = managers.player:upgrade_value("sentry_gun", "extra_ammo_multiplier", 1)
		local armor_multiplier = 1 + managers.player:upgrade_value("sentry_gun", "armor_multiplier", 1) - 1 + managers.player:upgrade_value("sentry_gun", "armor_multiplier2", 1) - 1
		local can_switch_fire_mode = managers.player:has_category_upgrade("sentry_gun", "ap_bullets")
		local equipment_name = managers.player:equipment_in_slot(selected_index)
		local fire_mode_index = can_switch_fire_mode and managers.player:get_equipment_setting(equipment_name, "fire_mode") or 1

		if Network:is_client() then
			managers.network:session():send_to_host("place_sentry_gun", pos, rot, selected_index, self._unit, unit_idstring_index, ammo_level, fire_mode_index)

			self._sentrygun_placement_requested = true

			return false
		else
			local shield = managers.player:has_category_upgrade("sentry_gun", "shield")
			local sentry_gun_unit, spread_level, rot_level = SentryGunBase.spawn(self._unit, pos, rot, managers.network:session():local_peer():id(), false, unit_idstring_index)

			if sentry_gun_unit then
				self:_sentry_gun_ammo_cost(sentry_gun_unit:id())

				local fire_rate_reduction = managers.player:upgrade_value("sentry_gun", "fire_rate_reduction", 1)

				managers.network:session():send_to_peers_synched("from_server_sentry_gun_place_result", managers.network:session():local_peer():id(), selected_index, sentry_gun_unit, rot_level, spread_level, shield, ammo_level, fire_mode_index)
				sentry_gun_unit:event_listener():call("on_setup", true)
				sentry_gun_unit:base():post_setup(fire_mode_index)
			else
				return false
			end
		end

		return true
	end

	return false
end

-- Lines 503-507
function PlayerEquipment:use_flash_grenade()
	self._grenade_name = "units/weapons/flash_grenade/flash_grenade"

	return true, "throw_grenade"
end

-- Lines 509-512
function PlayerEquipment:use_smoke_grenade()
	self._grenade_name = "units/weapons/smoke_grenade/smoke_grenade"

	return true, "throw_grenade"
end

-- Lines 514-517
function PlayerEquipment:use_frag_grenade()
	self._grenade_name = "units/weapons/frag_grenade/frag_grenade"

	return true, "throw_grenade"
end

-- Lines 520-532
function PlayerEquipment:throw_flash_grenade()
	if not self._grenade_name then
		Application:error("Tried to throw a grenade with no name")
	end

	local from = self._unit:movement():m_head_pos()
	local to = from + self._unit:movement():m_head_rot():y() * 35 + Vector3(0, 0, 0)
	local unit = ProjectileBase.spawn(self._grenade_name, to, Rotation())

	unit:base():throw({
		dir = self._unit:movement():m_head_rot():y(),
		owner = self._unit
	})

	self._grenade_name = nil
end

-- Lines 534-562
function PlayerEquipment:throw_projectile()
	local projectile_entry = managers.blackmarket:equipped_projectile()
	local projectile_data = tweak_data.blackmarket.projectiles[projectile_entry]
	local from = self._unit:movement():m_head_pos()
	local pos = from + self._unit:movement():m_head_rot():y() * 30 + Vector3(0, 0, 0)
	local dir = self._unit:movement():m_head_rot():y()
	local say_line = projectile_data.throw_shout or "g43"

	if say_line and say_line ~= true then
		self._unit:sound():play(say_line, nil, true)
	end

	local projectile_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_entry)

	if not projectile_data.client_authoritative then
		if Network:is_client() then
			managers.network:session():send_to_host("request_throw_projectile", projectile_index, pos, dir)
		else
			ProjectileBase.throw_projectile(projectile_entry, pos, dir, managers.network:session():local_peer():id())
			managers.player:verify_grenade(managers.network:session():local_peer():id())
		end
	else
		ProjectileBase.throw_projectile(projectile_entry, pos, dir, managers.network:session():local_peer():id())
		managers.player:verify_grenade(managers.network:session():local_peer():id())
	end

	managers.player:on_throw_grenade()
end

-- Lines 564-593
function PlayerEquipment:throw_grenade()
	local grenade_name = managers.blackmarket:equipped_grenade()
	local grenade_tweak = tweak_data.blackmarket.projectiles[grenade_name]

	if grenade_tweak.client_authoritative then
		return self:throw_projectile()
	end

	local from = self._unit:movement():m_head_pos()
	local pos = from + self._unit:movement():m_head_rot():y() * 30 + Vector3(0, 0, 0)
	local dir = self._unit:movement():m_head_rot():y()

	if not grenade_tweak.no_shouting then
		self._unit:sound():play("g43", nil, true)
	end

	local grenade_index = tweak_data.blackmarket:get_index_from_projectile_id(grenade_name)

	if Network:is_client() then
		managers.network:session():send_to_host("request_throw_projectile", grenade_index, pos, dir)
	else
		ProjectileBase.throw_projectile(grenade_name, pos, dir, managers.network:session():local_peer():id())
		managers.player:verify_grenade(managers.network:session():local_peer():id())
	end

	managers.player:on_throw_grenade()
end

-- Lines 597-601
function PlayerEquipment:use_duck()
	local soundsource = SoundDevice:create_source("duck")

	soundsource:post_event("footstep_walk")

	return true
end

-- Lines 605-610
function PlayerEquipment:from_server_sentry_gun_place_result(sentry_gun_id)
	if self._sentrygun_placement_requested then
		self:_sentry_gun_ammo_cost(sentry_gun_id)
	end

	self._sentrygun_placement_requested = nil
end

-- Lines 614-619
function PlayerEquipment:destroy()
	if alive(self._dummy_unit) then
		World:delete_unit(self._dummy_unit)

		self._dummy_unit = nil
	end
end

if _G.IS_VR then
	require("lib/units/beings/player/PlayerEquipmentVR")
end
