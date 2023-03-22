local ids_lod = Idstring("lod")
local ids_lod1 = Idstring("lod1")
local ids_ik_aim = Idstring("ik_aim")
CopBase = CopBase or class(UnitBase)
CopBase._anim_lods = {
	{
		2,
		500,
		100,
		5000
	},
	{
		2,
		0,
		100,
		1
	},
	{
		3,
		0,
		100,
		1
	}
}
CopBase._material_translation_map = {}
local character_path = ""
local char_map = tweak_data.character.character_map()

for _, data in pairs(char_map) do
	for _, character in ipairs(data.list) do
		character_path = data.path .. character .. "/" .. character
		CopBase._material_translation_map[tostring(Idstring(character_path):key())] = Idstring(character_path .. "_contour")
		CopBase._material_translation_map[tostring(Idstring(character_path .. "_contour"):key())] = Idstring(character_path)
	end
end

-- Lines 30-53
function CopBase:init(unit)
	UnitBase.init(self, unit, false)

	self._unit = unit
	self._char_tweak = tweak_data.character[self._tweak_table]

	self:_set_tags(self._char_tweak.tags)

	self._visibility_state = true
	self._foot_obj_map = {
		right = self._unit:get_object(Idstring("RightToeBase")),
		left = self._unit:get_object(Idstring("LeftToeBase"))
	}
	self._is_in_original_material = true
	self._buffs = {}
	self._original_tweak_table = self._tweak_table
	self._original_stats_name = self._stats_name
end

-- Lines 57-81
function CopBase:post_init()
	self._ext_movement = self._unit:movement()
	self._ext_anim = self._unit:anim_data()

	self:set_anim_lod(1)

	self._lod_stage = 1

	self._ext_movement:post_init(true)
	self._unit:brain():post_init()
	managers.enemy:register_enemy(self._unit)

	self._allow_invisible = true

	self:_chk_spawn_gear()
	self:enable_leg_arm_hitbox()

	if self._post_init_change_tweak_name then
		local new_tweak_name = self._post_init_change_tweak_name
		self._post_init_change_tweak_name = nil

		self:change_char_tweak(new_tweak_name)
	end
end

-- Lines 83-89
function CopBase:enable_leg_arm_hitbox()
	if self._unit:damage() and self._unit:damage():has_sequence("leg_arm_hitbox") then
		self._unit:damage():run_sequence_simple("leg_arm_hitbox")
	else
		Application:error("Unit " .. tostring(self._unit) .. " has no 'leg_arm_hitbox' sequence! Leg and arm hitboxes will not be enabled.")
	end
end

-- Lines 93-122
function CopBase:_chk_spawn_gear()
	local tweak = managers.job:current_level_data()

	if tweak and tweak.is_christmas_heist then
		if self._tweak_table == "spooc" then
			self._headwear_unit = safe_spawn_unit("units/payday2/characters/ene_acc_spook_santa_hat/ene_acc_spook_santa_hat", Vector3(), Rotation())
		end

		if self._headwear_unit then
			local align_obj_name = Idstring("Head")
			local align_obj = self._unit:get_object(align_obj_name)

			self._unit:link(align_obj_name, self._headwear_unit, self._headwear_unit:orientation_object():name())
		end
	end
end

-- Lines 126-136
function CopBase:_set_tags(tags)
	local tag_type = type(tags)

	if tag_type == "table" then
		self._tags = table.list_to_set(clone(tags))
	elseif tag_type == "string" then
		self._tags = {
			tags
		}
	else
		self._tags = nil
	end
end

-- Lines 138-140
function CopBase:has_tag(tag)
	return self._tags and self._tags[tag] or false
end

-- Lines 142-156
function CopBase:has_all_tags(tags)
	local my_tags = self._tags

	if not my_tags then
		return false
	end

	for _, tag in pairs(tags) do
		if not my_tags[tag] then
			return false
		end
	end

	return true
end

-- Lines 158-172
function CopBase:has_any_tag(tags)
	local my_tags = self._tags

	if not my_tags then
		return false
	end

	for _, tag in pairs(tags) do
		if my_tags[tag] then
			return true
		end
	end

	return false
end

-- Lines 176-206
function CopBase:default_weapon_name(selection_name)
	local weap_ids = tweak_data.character.weap_ids
	local weap_unit_names = tweak_data.character.weap_unit_names

	if selection_name and self._default_weapons then
		local weapon_id = self._default_weapons[selection_name]

		if weapon_id then
			for i_weap_id, weap_id in ipairs(weap_ids) do
				if weapon_id == weap_id then
					return weap_unit_names[i_weap_id]
				end
			end

			Application:error("[CopBase:default_weapon_name] No weapon unit name in CharacterTweakData with id '" .. weapon_id .. "' with selection '" .. selection_name .. "' for unit:", self._unit)
		end
	end

	local default_weapon_id = self._default_weapon_id

	for i_weap_id, weap_id in ipairs(weap_ids) do
		if default_weapon_id == weap_id then
			return weap_unit_names[i_weap_id]
		end
	end

	Application:error("[CopBase:default_weapon_name] No weapon unit name in CharacterTweakData with default weapon id '" .. default_weapon_id .. "' for unit:", self._unit)
end

-- Lines 210-212
function CopBase:visibility_state()
	return self._visibility_state
end

-- Lines 216-218
function CopBase:lod_stage()
	return self._lod_stage
end

-- Lines 222-224
function CopBase:set_allow_invisible(allow)
	self._allow_invisible = allow
end

-- Lines 228-280
function CopBase:set_visibility_state(stage)
	local state = stage and true

	if not state and not self._allow_invisible then
		state = true
		stage = 1
	end

	if self._lod_stage == stage then
		return
	end

	local inventory = self._unit:inventory()
	local weapon = inventory and inventory.get_weapon and inventory:get_weapon()

	if weapon then
		weapon:base():set_flashlight_light_lod_enabled(stage ~= 2 and not not stage)
	end

	if self._visibility_state ~= state then
		local unit = self._unit

		if inventory then
			inventory:set_visibility_state(state)
		end

		unit:set_visible(state)

		if self._headwear_unit then
			self._headwear_unit:set_visible(state)
		end

		if state or self._ext_anim.can_freeze and self._ext_anim.upper_body_empty then
			unit:set_animatable_enabled(ids_lod, state)
			unit:set_animatable_enabled(ids_ik_aim, state)
		end

		self._visibility_state = state
	end

	if state then
		self:set_anim_lod(stage)
		self._unit:movement():enable_update(true)

		if stage == 1 then
			self._unit:set_animatable_enabled(ids_lod1, true)
		elseif self._lod_stage == 1 then
			self._unit:set_animatable_enabled(ids_lod1, false)
		end
	end

	self._lod_stage = stage

	self:chk_freeze_anims()
end

-- Lines 284-286
function CopBase:set_anim_lod(stage)
	self._unit:set_animation_lod(unpack(self._anim_lods[stage]))
end

-- Lines 290-292
function CopBase:on_death_exit()
	self._unit:set_animations_enabled(false)
end

-- Lines 296-324
function CopBase:chk_freeze_anims()
	if (not self._lod_stage or self._lod_stage > 1) and self._ext_anim.can_freeze and self._ext_anim.upper_body_empty then
		if not self._anims_frozen then
			self._anims_frozen = true

			self._unit:set_animations_enabled(false)
			self._ext_movement:on_anim_freeze(true)
		end
	elseif self._anims_frozen then
		self._anims_frozen = nil

		self._unit:set_animations_enabled(true)
		self._ext_movement:on_anim_freeze(false)
	end
end

-- Lines 329-337
function CopBase:anim_act_clbk(unit, anim_act, send_to_action)
	if send_to_action then
		unit:movement():on_anim_act_clbk(anim_act)
	elseif unit:unit_data().mission_element then
		unit:unit_data().mission_element:event(anim_act, unit)
	end
end

-- Lines 341-373
function CopBase:save(save_data)
	local my_save_data = {}

	if self._unit:interaction() and self._unit:interaction().tweak_data == "hostage_trade" then
		my_save_data.is_hostage_trade = true
	elseif self._unit:interaction() and self._unit:interaction().tweak_data == "hostage_convert" then
		my_save_data.is_hostage_convert = true
	end

	local buffs = {}

	for name, buff_list in pairs(self._buffs) do
		buffs[name] = {
			_total = buff_list._total
		}
	end

	if next(buffs) then
		my_save_data.buffs = buffs
	end

	if self._tweak_table ~= self._original_tweak_table then
		my_save_data.tweak_name_swap = self._tweak_table
	end

	if self._stats_name ~= self._original_stats_name then
		my_save_data.stats_name_swap = self._stats_name
	end

	if next(my_save_data) then
		save_data.base = my_save_data
	end
end

-- Lines 377-404
function CopBase:load(load_data)
	local my_load_data = load_data.base

	if not my_load_data then
		return
	end

	if my_load_data.is_hostage_trade then
		CopLogicTrade.hostage_trade(self._unit, true, false)
	elseif my_load_data.is_hostage_convert then
		self._unit:interaction():set_tweak_data("hostage_convert")
	end

	if my_load_data.buffs then
		self._buffs = my_load_data.buffs
	end

	if my_load_data.tweak_name_swap and my_load_data.tweak_name_swap ~= self._tweak_table then
		self._post_init_change_tweak_name = my_load_data.tweak_name_swap
	end

	if my_load_data.stats_name_swap and my_load_data.stats_name_swap ~= self._stats_name then
		self:change_stats_name(my_load_data.stats_name_swap)
	end
end

-- Lines 408-422
function CopBase:swap_material_config(material_applied_clbk)
	local new_material = self._material_translation_map[self._loading_material_key or tostring(self._unit:material_config():key())]

	if new_material then
		self._loading_material_key = new_material:key()
		self._is_in_original_material = not self._is_in_original_material

		self._unit:set_material_config(new_material, true, material_applied_clbk and callback(self, self, "on_material_applied", material_applied_clbk), 100)

		if not material_applied_clbk then
			self:on_material_applied()
		end
	else
		print("[CopBase:swap_material_config] fail", self._unit:material_config(), self._unit)
		Application:stack_dump()
	end
end

-- Lines 426-440
function CopBase:on_material_applied(material_applied_clbk)
	if not alive(self._unit) then
		return
	end

	self._loading_material_key = nil

	if self._unit:interaction() then
		self._unit:interaction():refresh_material()
	end

	if material_applied_clbk then
		material_applied_clbk()
	end
end

-- Lines 444-446
function CopBase:is_in_original_material()
	return self._is_in_original_material
end

-- Lines 450-454
function CopBase:set_material_state(original)
	if original and not self._is_in_original_material or not original and self._is_in_original_material then
		self:swap_material_config()
	end
end

-- Lines 458-460
function CopBase:char_tweak_name()
	return self._tweak_table
end

-- Lines 462-464
function CopBase:char_tweak()
	return self._char_tweak
end

-- Lines 468-471
function CopBase:melee_weapon()
	return self._melee_weapon_table or self._char_tweak.melee_weapon or "weapon"
end

-- Lines 475-487
function CopBase:pre_destroy(unit)
	if alive(self._headwear_unit) then
		self._headwear_unit:set_slot(0)

		self._headwear_unit = nil
	end

	unit:brain():pre_destroy(unit)
	self._ext_movement:pre_destroy()
	self._unit:inventory():pre_destroy()
	UnitBase.pre_destroy(self, unit)

	self._tweak_data_listener_holder = nil
end

-- Lines 492-504
function CopBase:_refresh_buff_total(name)
	local buff_list = self._buffs[name]
	local sum = 0

	for _, buff in pairs(buff_list.buffs) do
		sum = sum + buff
	end

	buff_list._total = sum

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_enemy_buff", self._unit, name, math.round(buff_list._total * 1000))
	end
end

-- Lines 506-509
function CopBase:_sync_buff_total(name, total)
	self._buffs[name] = self._buffs[name] or {}
	self._buffs[name]._total = total * 0.001
end

-- Lines 511-532
function CopBase:add_buff(name, value)
	if not Network:is_server() then
		return
	end

	local buff_list = self._buffs[name]

	if not buff_list then
		buff_list = {
			_next_id = 1,
			buffs = {}
		}
		self._buffs[name] = buff_list
	end

	local buff_list = self._buffs[name]
	local id = buff_list._next_id
	buff_list.buffs[id] = value
	buff_list._next_id = id + 1

	self:_refresh_buff_total(name)

	return id
end

-- Lines 534-548
function CopBase:remove_buff_by_id(name, id)
	if not Network:is_server() then
		return
	end

	local buff_list = self._buffs[name]

	if not buff_list then
		return
	end

	buff_list.buffs[id] = nil

	self:_refresh_buff_total(name)
end

-- Lines 550-561
function CopBase:get_total_buff(name)
	local buff_list = self._buffs[name]

	if not buff_list then
		return 0
	end

	if buff_list and buff_list._total then
		return buff_list._total
	end

	return 0
end

-- Lines 567-574
function CopBase:add_tweak_data_changed_listener(key, clbk)
	if not self._tweak_data_listener_holder then
		self._tweak_data_listener_holder = ListenerHolder:new()
	end

	self._tweak_data_listener_holder:add(key, clbk)
end

-- Lines 576-589
function CopBase:remove_tweak_data_changed_listener(key)
	if not self._tweak_data_listener_holder then
		return
	end

	self._tweak_data_listener_holder:remove(key)

	if self._tweak_data_listener_holder:is_empty() then
		self._tweak_data_listener_holder = nil
	end
end

-- Lines 591-595
function CopBase:_chk_call_tweak_data_changed_listeners(...)
	if self._tweak_data_listener_holder then
		self._tweak_data_listener_holder:call(...)
	end
end

-- Lines 599-631
function CopBase:change_char_tweak(new_tweak_name)
	local new_tweak_data = tweak_data.character[new_tweak_name]

	if not new_tweak_data then
		return
	end

	if new_tweak_name == self._tweak_table then
		return
	end

	local old_tweak_data = self._char_tweak
	self._tweak_table = new_tweak_name
	self._char_tweak = new_tweak_data

	self:_set_tags(new_tweak_data.tags)
	self:_chk_call_tweak_data_changed_listeners(old_tweak_data, new_tweak_data)
end

-- Lines 633-654
function CopBase:change_stats_name(new_stats_name)
	if not new_stats_name or new_stats_name == self._stats_name then
		return
	end

	self._stats_name = new_stats_name
end
