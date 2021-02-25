CriminalsManager = CriminalsManager or class()
CriminalsManager.MAX_NR_TEAM_AI = 3
CriminalsManager.MAX_NR_CRIMINALS = 4
CriminalsManager.EVENTS = {
	"on_criminal_added",
	"on_criminal_removed"
}

-- Lines 11-44
function CriminalsManager:init()
	self._listener_holder = EventListenerHolder:new()

	self:_create_characters()

	self._loadout_map = {}
	self._loadout_slots = {}

	for i = 1, CriminalsManager.MAX_NR_TEAM_AI do
		self._loadout_slots[i] = {}
	end
end

-- Lines 46-54
function CriminalsManager:_create_characters()
	self._characters = {}

	for _, character in ipairs(tweak_data.criminals.characters) do
		local static_data = deep_clone(character.static_data)
		local character_data = {
			peer_id = 0,
			taken = false,
			name = character.name,
			static_data = static_data,
			data = {},
			visual_state = {}
		}

		table.insert(self._characters, character_data)
	end
end

-- Lines 58-61
function CriminalsManager:event_listener()
	self._listener_holder = self._listener_holder or EventListenerHolder:new()

	return self._listener_holder
end

-- Lines 63-65
function CriminalsManager:add_listener(key, events, clbk)
	self:event_listener():add(key, events, clbk)
end

-- Lines 67-69
function CriminalsManager:remove_listener(key)
	self:event_listener():remove(key)
end

-- Lines 73-76
function CriminalsManager.convert_old_to_new_character_workname(workname)
	local t = {
		spanish = "chains",
		russian = "dallas",
		german = "wolf",
		american = "hoxton"
	}

	return t[workname] or workname
end

-- Lines 78-81
function CriminalsManager.convert_new_to_old_character_workname(workname)
	local t = {
		hoxton = "american",
		wolf = "german",
		dallas = "russian",
		chains = "spanish"
	}

	return t[workname] or workname
end

-- Lines 83-85
function CriminalsManager.character_names()
	return tweak_data.criminals.character_names
end

-- Lines 87-89
function CriminalsManager.get_num_characters()
	return #tweak_data.criminals.character_names
end

-- Lines 91-93
function CriminalsManager.character_workname_by_peer_id(peer_id)
	return CriminalsManager.character_names()[peer_id]
end

-- Lines 95-100
function CriminalsManager:on_simulation_ended()
	for id, data in pairs(self._characters) do
		self:_remove(id)
	end

	self._listener_holder = EventListenerHolder:new()
end

-- Lines 104-106
function CriminalsManager:local_character_name()
	return self._local_character
end

-- Lines 108-110
function CriminalsManager:characters()
	return self._characters
end

-- Lines 114-120
function CriminalsManager:get_any_unit()
	for id, data in pairs(self._characters) do
		if data.taken and alive(data.unit) and data.unit:id() ~= -1 then
			return data.unit
		end
	end
end

-- Lines 124-158
function CriminalsManager:get_valid_player_spawn_pos_rot(peer_id)
	local server_unit = managers.network:session():local_peer():unit()

	if alive(server_unit) then
		return self:_get_unit_pos_rot(server_unit, true)
	end

	for u_key, u_data in pairs(managers.groupai:state():all_player_criminals()) do
		if u_data and alive(u_data.unit) then
			return self:_get_unit_pos_rot(u_data.unit, true)
		end
	end

	if self._last_valid_player_spawn_pos_rot then
		return self._last_valid_player_spawn_pos_rot
	end

	for u_key, u_data in pairs(managers.groupai:state():all_AI_criminals()) do
		if u_data and alive(u_data.unit) then
			return self:_get_unit_pos_rot(u_data.unit, false)
		end
	end

	return nil
end

-- Lines 160-184
function CriminalsManager:_get_unit_pos_rot(unit, check_zipline)
	if check_zipline then
		local zipline_unit = unit:movement():zipline_unit()

		if zipline_unit then
			unit = zipline_unit
		end
	end

	if unit:movement() then
		local state = unit:movement():current_state_name()

		if state == "jerry1" or state == "jerry2" then
			return nil
		end
	end

	if unit:in_slot(managers.slot:get_mask("players")) and not unit:base().is_husk_player then
		local rot = unit:camera():rotation()

		return {
			unit:position(),
			Rotation(rot:yaw())
		}
	else
		return {
			unit:position(),
			Rotation(unit:rotation():yaw())
		}
	end
end

-- Lines 188-190
function CriminalsManager:on_last_valid_player_spawn_point_updated(unit)
	self._last_valid_player_spawn_pos_rot = self:_get_unit_pos_rot(unit, true)
end

-- Lines 194-236
function CriminalsManager:_remove(id)
	local char_data = self._characters[id]

	if char_data.name == self._local_character then
		self._local_character = nil
	end

	if char_data.unit then
		managers.hud:remove_mugshot_by_character_name(char_data.name)

		if not char_data.data.ai and alive(char_data.unit) then
			self:on_last_valid_player_spawn_point_updated(char_data.unit)
		end
	else
		managers.hud:remove_teammate_panel_by_name_id(char_data.name)
	end

	if not char_data.data.ai then
		managers.trade:on_player_criminal_removed(char_data.name)
	end

	if char_data.safe_loaded_assets then
		local ids_unit = Idstring("unit")

		for type, asset_ids in pairs(char_data.safe_loaded_assets) do
			managers.dyn_resource:unload(ids_unit, asset_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE, false)
		end
	end

	char_data.taken = false
	char_data.unit = nil
	char_data.peer_id = 0
	char_data.data = {}
	char_data.safe_loaded_assets = nil

	self:event_listener():call("on_criminal_removed", char_data)

	if Network:is_server() then
		call_on_next_update(callback(self, self, "_reassign_loadouts"), "CriminalsManager:_reassign_loadouts")
	end
end

-- Lines 240-323
function CriminalsManager:add_character(name, unit, peer_id, ai, ai_loadout)
	print("[CriminalsManager]:add_character", name, unit, peer_id, ai)

	local character = self:character_by_name(name)

	if character then
		if character.taken then
			Application:error("[CriminalsManager:set_character] Error: Trying to take a unit slot that has already been taken!")
			Application:stack_dump()
			Application:error("[CriminalsManager:set_character] -----")
			self:remove_character_by_name(name)
		end

		character.taken = true
		character.unit = unit
		character.peer_id = peer_id
		character.data.ai = ai or false

		if ai_loadout then
			unit:base():set_loadout(ai_loadout)
		end

		character.data.mask_id = managers.blackmarket:get_real_mask_id(ai_loadout and ai_loadout.mask or character.static_data.ai_mask_id, nil, name)

		if Network:is_server() and ai_loadout then
			local crafted = managers.blackmarket:get_crafted_category_slot("masks", ai_loadout and ai_loadout.mask_slot)
			character.data.mask_blueprint = crafted and crafted.blueprint
		end

		character.data.mask_blueprint = character.data.mask_blueprint or ai_loadout and ai_loadout.mask_blueprint
		character.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(character.data.mask_id, nil, name)

		if not ai and unit then
			local mask_id = managers.network:session():peer(peer_id):mask_id()
			character.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(mask_id, peer_id)
			character.data.mask_id = managers.blackmarket:get_real_mask_id(mask_id, peer_id)
			character.data.mask_blueprint = managers.network:session():peer(peer_id):mask_blueprint()
		end

		managers.hud:remove_mugshot_by_character_name(name)

		if unit then
			character.data.mugshot_id = managers.hud:add_mugshot_by_unit(unit)

			if unit:base().is_local_player then
				self._local_character = name

				managers.hud:reset_player_hpbar()
			end

			unit:sound():set_voice(character.static_data.voice)
		else
			character.data.mugshot_id = managers.hud:add_mugshot_without_unit(name, ai, peer_id, ai and managers.localization:text("menu_" .. name) or managers.network:session():peer(peer_id):name())
		end
	end

	self:event_listener():call("on_criminal_added", name, unit, peer_id, ai)
	managers.sync:send_all_synced_units_to(peer_id)
end

-- Lines 325-343
function CriminalsManager:safe_load_asset(character, asset_name, type)
	local ids_unit = Idstring("unit")
	local asset_ids = Idstring(asset_name)

	managers.dyn_resource:load(ids_unit, asset_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)

	character.safe_loaded_assets = character.safe_loaded_assets or {}
	local old_asset_ids = character.safe_loaded_assets[type]

	if old_asset_ids then
		managers.dyn_resource:unload(ids_unit, old_asset_ids, managers.dyn_resource.DYN_RESOURCES_PACKAGE, false)
	end

	character.safe_loaded_assets[type] = asset_ids
end

-- Lines 345-430
function CriminalsManager:update_character_visual_state(character_name, visual_state)
	local character = self:character_by_name(character_name)

	if not character or not character.taken or not alive(character.unit) then
		return
	end

	visual_state = visual_state or {}
	local unit = character.unit
	local is_local_peer = visual_state.is_local_peer or character.visual_state.is_local_peer or false
	local visual_seed = visual_state.visual_seed or character.visual_state.visual_seed or CriminalsManager.get_new_visual_seed()
	local mask_id = visual_state.mask_id or character.visual_state.mask_id
	local armor_id = visual_state.armor_id or character.visual_state.armor_id or "level_1"
	local armor_skin = visual_state.armor_skin or character.visual_state.armor_skin or "none"
	local player_style = self:active_player_style() or managers.blackmarket:get_default_player_style()
	local suit_variation = nil
	local user_player_style = visual_state.player_style or character.visual_state.player_style or managers.blackmarket:get_default_player_style()

	if not self:is_active_player_style_locked() and user_player_style ~= managers.blackmarket:get_default_player_style() then
		player_style = user_player_style
		suit_variation = visual_state.suit_variation or character.visual_state.suit_variation or "default"
	end

	local glove_id = visual_state.glove_id or character.visual_state.glove_id or managers.blackmarket:get_default_glove_id()
	local character_visual_state = {
		is_local_peer = is_local_peer,
		visual_seed = visual_seed,
		player_style = player_style,
		suit_variation = suit_variation,
		glove_id = glove_id,
		mask_id = mask_id,
		armor_id = armor_id,
		armor_skin = armor_skin
	}

	-- Lines 392-394
	local function get_value_string(value)
		return is_local_peer and tostring(value) or "third_" .. tostring(value)
	end

	if player_style then
		local unit_name = tweak_data.blackmarket:get_player_style_value(player_style, character_name, get_value_string("unit"))

		if unit_name then
			self:safe_load_asset(character, unit_name, "player_style")
		end
	end

	if glove_id then
		local unit_name = tweak_data.blackmarket:get_glove_value(glove_id, character_name, "unit", player_style, suit_variation)

		if unit_name then
			self:safe_load_asset(character, unit_name, "glove_id")
		end
	end

	CriminalsManager.set_character_visual_state(unit, character_name, character_visual_state)

	character.visual_state = {
		is_local_peer = is_local_peer,
		visual_seed = visual_seed,
		player_style = user_player_style,
		suit_variation = suit_variation,
		glove_id = glove_id,
		mask_id = mask_id,
		armor_id = armor_id,
		armor_skin = armor_skin
	}
end

-- Lines 432-650
function CriminalsManager.set_character_visual_state(unit, character_name, visual_state)
	print("[CriminalsManager.set_character_visual_state]", unit, character_name, inspect(visual_state))

	local is_local_peer = visual_state.is_local_peer
	local visual_seed = visual_state.visual_seed
	local player_style = visual_state.player_style
	local suit_variation = visual_state.suit_variation
	local glove_id = visual_state.glove_id
	local mask_id = visual_state.mask_id
	local armor_id = visual_state.armor_id
	local armor_skin = visual_state.armor_skin

	if not alive(unit) then
		return
	end

	if _G.IS_VR and unit:camera() then
		return
	end

	if unit:camera() and alive(unit:camera():camera_unit()) and unit:camera():camera_unit():damage() then
		unit = unit:camera():camera_unit()
	end

	local unit_damage = unit:damage()

	if not unit_damage then
		return
	end

	if unit:inventory() and unit:inventory().mask_visibility and not unit:inventory():mask_visibility() then
		mask_id = nil
	end

	-- Lines 471-482
	local function run_sequence_safe(sequence, sequence_unit)
		if not sequence then
			return
		end

		local sequence_unit_damage = (sequence_unit or unit):damage()

		if sequence_unit_damage and sequence_unit_damage:has_sequence(sequence) then
			sequence_unit_damage:run_sequence_simple(sequence)
		else
			Application:error("[set_character_visual_state] Missing sequence:", sequence, "Character:", character_name, "Unit: ", unit:name())
		end
	end

	-- Lines 484-486
	local function get_value_string(value)
		return is_local_peer and tostring(value) or "third_" .. tostring(value)
	end

	local time_seed = math.random(os.time())

	math.randomseed(visual_seed)
	math.random()
	math.random()
	math.random()

	local material = managers.blackmarket:character_material_by_character_name(character_name)
	local material_config = material and (is_local_peer and material.fps or material.npc)

	if not is_local_peer and material_config and armor_skin ~= "none" then
		material_config = material_config .. "_cc"
	end

	if material_config then
		unit_damage:set_variable("var_material_config", material_config)
	end

	local body_replacement = tweak_data.blackmarket:get_player_style_value(player_style, character_name, get_value_string("body_replacement")) or {}

	unit_damage:set_variable("var_head_replace", body_replacement.head and 1 or 0)
	unit_damage:set_variable("var_body_replace", body_replacement.body and 1 or 0)

	local gloves_unit_name = tweak_data.blackmarket:get_glove_value(glove_id, character_name, "unit", player_style, suit_variation)
	local replace_character_hands = gloves_unit_name or gloves_unit_name == false and body_replacement.hands

	unit_damage:set_variable("var_hands_replace", replace_character_hands and 1 or 0)
	unit_damage:set_variable("var_arms_replace", body_replacement.arms and 1 or 0)
	unit_damage:set_variable("var_vest_replace", body_replacement.vest and 1 or 0)
	unit_damage:set_variable("var_armor_replace", body_replacement.armor and 1 or 0)

	local material_sequence = managers.blackmarket:character_sequence_by_character_name(character_name)

	run_sequence_safe(material_sequence)

	if not is_local_peer then
		local armor_sequence = tweak_data.blackmarket.armors[armor_id] and tweak_data.blackmarket.armors[armor_id].sequence

		run_sequence_safe(armor_sequence)
	end

	local mask_data = tweak_data.blackmarket.masks[mask_id]

	if not is_local_peer and mask_data then
		if mask_data.skip_mask_on_sequence then
			local mask_off_sequence = managers.blackmarket:character_mask_off_sequence_by_character_name(character_name)

			run_sequence_safe(mask_off_sequence)
		else
			local mask_on_sequence = managers.blackmarket:character_mask_on_sequence_by_character_name(character_name)

			run_sequence_safe(mask_on_sequence)
		end
	end

	if unit:spawn_manager() then
		unit:spawn_manager():remove_unit("char_mesh")

		local unit_name = tweak_data.blackmarket:get_player_style_value(player_style, character_name, get_value_string("unit"))
		local char_mesh_unit = nil

		if unit_name then
			unit:spawn_manager():spawn_and_link_unit("_char_joint_names", "char_mesh", unit_name)

			char_mesh_unit = unit:spawn_manager():get_unit("char_mesh")
		end

		if alive(char_mesh_unit) then
			char_mesh_unit:unit_data().original_material_config = char_mesh_unit:material_config()
			local unit_sequence = tweak_data.blackmarket:get_suit_variation_value(player_style, suit_variation, character_name, get_value_string("sequence"))

			if unit_sequence then
				run_sequence_safe(unit_sequence, char_mesh_unit)
			else
				unit_sequence = tweak_data.blackmarket:get_player_style_value(player_style, character_name, get_value_string("sequence"))

				run_sequence_safe(unit_sequence, char_mesh_unit)
			end

			local variation_material_config = tweak_data.blackmarket:get_suit_variation_value(player_style, suit_variation, character_name, get_value_string("material"))
			local wanted_config_ids = variation_material_config and Idstring(variation_material_config) or char_mesh_unit:unit_data().original_material_config

			if wanted_config_ids and char_mesh_unit:material_config() ~= wanted_config_ids then
				managers.dyn_resource:change_material_config(wanted_config_ids, char_mesh_unit, true)
			end

			char_mesh_unit:set_enabled(unit:enabled())
		end

		unit:spawn_manager():remove_unit("char_gloves")

		local char_gloves_unit = nil

		if gloves_unit_name then
			unit:spawn_manager():spawn_and_link_unit("_char_joint_names", "char_gloves", gloves_unit_name)

			char_gloves_unit = unit:spawn_manager():get_unit("char_gloves")
		end

		if alive(char_gloves_unit) then
			if not is_local_peer then
				char_gloves_unit:unit_data().original_material_config = char_gloves_unit:material_config()
				local third_material_config = tweak_data.blackmarket:get_glove_value(glove_id, character_name, "third_material", player_style, suit_variation)
				local wanted_config_ids = third_material_config and Idstring(third_material_config) or char_gloves_unit:unit_data().original_material_config

				if wanted_config_ids and char_gloves_unit:material_config() ~= wanted_config_ids then
					managers.dyn_resource:change_material_config(wanted_config_ids, char_gloves_unit, true)
				end
			end

			local unit_sequence = tweak_data.blackmarket:get_glove_value(glove_id, character_name, "sequence", player_style, suit_variation)

			run_sequence_safe(unit_sequence, char_gloves_unit)
			char_gloves_unit:set_enabled(unit:enabled())
		end

		unit:spawn_manager():remove_unit("char_glove_adapter")

		local adapter_tweak = tweak_data.blackmarket.glove_adapter

		if not table.contains(adapter_tweak.player_style_exclude_list, player_style) and adapter_tweak.unit then
			unit:spawn_manager():spawn_and_link_unit("_char_joint_names", "char_glove_adapter", adapter_tweak.unit)

			local glove_adapter_unit = unit:spawn_manager():get_unit("char_glove_adapter")

			if alive(glove_adapter_unit) then
				local new_character_name = CriminalsManager.convert_old_to_new_character_workname(character_name)

				run_sequence_safe(adapter_tweak.character_sequence[new_character_name], glove_adapter_unit)

				if not is_local_peer then
					glove_adapter_unit:unit_data().original_material_config = glove_adapter_unit:material_config()
					local third_material_config = adapter_tweak.third_material
					local wanted_config_ids = third_material_config and Idstring(third_material_config) or glove_adapter_unit:unit_data().original_material_config

					if wanted_config_ids and glove_adapter_unit:material_config() ~= wanted_config_ids then
						managers.dyn_resource:change_material_config(wanted_config_ids, glove_adapter_unit, true)
					end
				end
			end
		end
	end

	if unit:armor_skin() and unit:armor_skin().set_armor_id then
		unit:armor_skin():set_armor_id(armor_id)
		unit:armor_skin():set_cosmetics_data(armor_skin, true)
	end

	if unit:interaction() then
		unit:interaction():refresh_material()
	end

	if unit:contour() then
		unit:contour():update_materials()
	end

	math.randomseed(time_seed)
	math.random()
	math.random()
	math.random()
end

-- Lines 652-659
function CriminalsManager.get_new_visual_seed()
	return math.random(0, 32767)
end

-- Lines 661-667
function CriminalsManager:update_visual_states()
	for _, character in ipairs(self:characters()) do
		if character.taken and alive(character.unit) then
			self:update_character_visual_state(character.name)
		end
	end
end

-- Lines 680-691
function CriminalsManager:set_active_player_style(player_style, sync)
	self._player_style = tweak_data.blackmarket.player_styles[player_style] and player_style or nil

	if self._player_style == "none" then
		self._player_style = nil
	end

	self:update_visual_states()

	if sync and Network:is_server() then
		-- Nothing
	end
end

-- Lines 693-704
function CriminalsManager:active_player_style()
	if self._player_style then
		return self._player_style
	end

	local current_level = managers.job and managers.job:current_level_id()

	if current_level then
		return tweak_data.levels[current_level] and tweak_data.levels[current_level].player_style or "none"
	end

	return "none"
end

-- Lines 707-714
function CriminalsManager:set_active_player_style_locked(locked, sync)
	self._player_style_locked = locked

	self:update_visual_states()

	if sync and Network:is_server() then
		-- Nothing
	end
end

-- Lines 716-727
function CriminalsManager:is_active_player_style_locked()
	if self._player_style_locked then
		return true
	end

	local current_level = managers.job and managers.job:current_level_id()

	if current_level then
		return tweak_data.levels[current_level] and tweak_data.levels[current_level].player_style_locked or false
	end

	return false
end

-- Lines 732-811
function CriminalsManager:set_unit(name, unit, ai_loadout)
	print("[CriminalsManager]:set_unit", name, unit)

	local character = self:character_by_name(name)

	if character then
		if not character.taken then
			Application:error("[CriminalsManager:set_character] Error: Trying to set a unit on a slot that has not been taken!")
			Application:stack_dump()

			return
		end

		character.unit = unit

		managers.hud:remove_mugshot_by_character_name(character.name)

		character.data.mugshot_id = managers.hud:add_mugshot_by_unit(unit)
		character.data.mask_id = managers.blackmarket:get_real_mask_id(ai_loadout and ai_loadout.mask or character.static_data.ai_mask_id, nil, name)

		if Network:is_server() and ai_loadout then
			local crafted = managers.blackmarket:get_crafted_category_slot("masks", ai_loadout and ai_loadout.mask_slot)
			character.data.mask_blueprint = crafted and crafted.blueprint
		end

		character.data.mask_blueprint = character.data.mask_blueprint or ai_loadout and ai_loadout.mask_blueprint
		character.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(character.data.mask_id, nil, name)

		if not character.data.ai then
			local peer = managers.network:session():peer(character.peer_id)
			local mask_id = peer:mask_id()
			character.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(mask_id, character.peer_id)
			character.data.mask_id = managers.blackmarket:get_real_mask_id(mask_id, character.peer_id)
			character.data.mask_blueprint = peer:mask_blueprint()
		end

		if unit:base().is_local_player then
			self._local_character = name

			managers.hud:reset_player_hpbar()
		end

		unit:sound():set_voice(character.static_data.voice)
	end

	if ai_loadout then
		local vis = unit:inventory()._mask_visibility

		unit:base():set_loadout(ai_loadout)
		unit:inventory():preload_mask()
		unit:inventory():set_mask_visibility(not vis)
		unit:inventory():set_mask_visibility(vis)

		if Network:is_server() then
			unit:movement():add_weapons()
		end
	end
end

-- Lines 813-831
function CriminalsManager:set_data(name)
	print("[CriminalsManager]:set_data", name)

	for id, data in pairs(self._characters) do
		if data.name == name then
			if not data.taken then
				return
			end

			if not data.data.ai then
				local mask_id = managers.network:session():peer(data.peer_id):mask_id()
				data.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(mask_id, data.peer_id)
				data.data.mask_id = managers.blackmarket:get_real_mask_id(mask_id, data.peer_id)
				data.data.mask_blueprint = managers.network:session():peer(data.peer_id):mask_blueprint()
			end

			break
		end
	end
end

-- Lines 835-843
function CriminalsManager:is_taken(name)
	for _, data in pairs(self._characters) do
		if name == data.name then
			return data.taken
		end
	end

	return false
end

-- Lines 847-853
function CriminalsManager:character_name_by_peer_id(peer_id)
	for _, data in pairs(self._characters) do
		if data.taken and peer_id == data.peer_id then
			return data.name
		end
	end
end

-- Lines 857-865
function CriminalsManager:character_color_id_by_peer_id(peer_id)
	local workname = self.character_workname_by_peer_id(peer_id)

	return self:character_color_id_by_name(workname)
end

-- Lines 869-879
function CriminalsManager:character_color_id_by_unit(unit)
	local search_key = unit:key()

	for id, data in pairs(self._characters) do
		if data.unit and data.taken and search_key == data.unit:key() then
			if data.data.ai then
				return #tweak_data.chat_colors
			end

			return data.peer_id
		end
	end
end

-- Lines 881-894
function CriminalsManager:character_color_id_by_name(name)
	for id, data in pairs(self._characters) do
		if name == data.name then
			return data.static_data.color_id
		end
	end
end

-- Lines 898-919
function CriminalsManager:character_by_name(name)
	local character_name = CriminalsManager.convert_new_to_old_character_workname(name)

	for _, character in pairs(self._characters) do
		if character_name == character.name then
			return character
		end
	end

	return false
end

-- Lines 921-933
function CriminalsManager:character_by_peer_id(peer_id)
	for _, character in pairs(self._characters) do
		if peer_id == character.peer_id then
			return character
		end
	end

	return false
end

-- Lines 935-956
function CriminalsManager:character_by_unit(unit)
	local search_key = unit:key()

	for _, character in pairs(self._characters) do
		if alive(character.unit) and character.unit:key() == search_key then
			return character
		end
	end

	return false
end

-- Lines 960-969
function CriminalsManager:has_character_by_name(name)
	local character_name = CriminalsManager.convert_new_to_old_character_workname(name)

	for _, character in pairs(self._characters) do
		if character_name == character.name then
			return true
		end
	end

	return false
end

-- Lines 971-979
function CriminalsManager:has_character_by_peer_id(peer_id)
	for _, character in pairs(self._characters) do
		if peer_id == character.peer_id then
			return true
		end
	end

	return false
end

-- Lines 981-990
function CriminalsManager:has_character_by_unit(unit)
	local search_key = unit and unit:key()

	for _, character in pairs(self._characters) do
		if alive(character.unit) and character.unit:key() == search_key then
			return true
		end
	end

	return false
end

-- Lines 994-999
function CriminalsManager:character_data_by_name(name)
	local character = self:character_by_name(name)

	if character and character.taken then
		return character.data
	end
end

-- Lines 1001-1006
function CriminalsManager:character_data_by_peer_id(peer_id)
	local character = self:character_by_peer_id(peer_id)

	if character and character.taken then
		return character.data
	end
end

-- Lines 1008-1013
function CriminalsManager:character_data_by_unit(unit)
	local character = self:character_by_unit(unit)

	if character and character.taken then
		return character.data
	end
end

-- Lines 1017-1022
function CriminalsManager:character_static_data_by_name(name)
	local character = self:character_by_name(name)

	if character then
		return character.static_data
	end
end

-- Lines 1026-1031
function CriminalsManager:character_unit_by_name(name)
	local character = self:character_by_name(name)

	if character and character.taken then
		return character.unit
	end
end

-- Lines 1033-1038
function CriminalsManager:character_unit_by_peer_id(peer_id)
	local character = self:character_by_peer_id(peer_id)

	if character and character.taken then
		return character.unit
	end
end

-- Lines 1042-1047
function CriminalsManager:character_taken_by_name(name)
	local character = self:character_by_name(name)

	if character then
		return character.taken
	end
end

-- Lines 1050-1055
function CriminalsManager:character_peer_id_by_name(name)
	local character = self:character_by_name(name)

	if character and character.taken then
		return character.peer_id
	end
end

-- Lines 1057-1062
function CriminalsManager:character_peer_id_by_unit(unit)
	local character = self:character_by_unit(unit)

	if character and character.taken then
		return character.peer_id
	end
end

-- Lines 1066-1096
function CriminalsManager:get_free_character_name()
	local preferred = managers.blackmarket:preferred_henchmen()

	for _, name in ipairs(preferred) do
		local data = table.find_value(self._characters, function (val)
			return val.name == name
		end)

		if data and not data.taken then
			print("chosen", name)

			return name
		end
	end

	local available = {}

	for id, data in pairs(self._characters) do
		local taken = data.taken
		local level_blocked = self:is_character_as_AI_level_blocked(data.name)
		local character_name = CriminalsManager.convert_old_to_new_character_workname(data.name)
		local character_table = tweak_data.blackmarket.characters[character_name] or tweak_data.blackmarket.characters.locked[character_name]
		local dlc_unlocked = not character_table or not character_table.dlc or managers.dlc:is_dlc_unlocked(character_table.dlc)

		if not taken and not level_blocked and dlc_unlocked then
			table.insert(available, data.name)
		end
	end

	if #available > 0 then
		return available[math.random(#available)]
	end
end

-- Lines 1100-1109
function CriminalsManager:get_num_player_criminals()
	local num = 0

	for id, data in pairs(self._characters) do
		if data.taken and not data.data.ai then
			num = num + 1
		end
	end

	return num
end

-- Lines 1113-1137
function CriminalsManager:on_peer_left(peer_id)
	for id, data in pairs(self._characters) do
		local char_dmg = alive(data.unit) and data.unit:character_damage()

		if char_dmg and char_dmg.get_paused_counter_name_by_peer then
			local counter_name = char_dmg:get_paused_counter_name_by_peer(peer_id)

			if counter_name then
				if counter_name == "downed" then
					char_dmg:unpause_downed_timer(peer_id)
				elseif counter_name == "arrested" then
					char_dmg:unpause_arrested_timer(peer_id)
				elseif counter_name == "bleed_out" then
					char_dmg:unpause_bleed_out(peer_id)
				else
					Application:stack_dump_error("Unknown counter name \"" .. tostring(counter_name) .. "\" by peer id " .. tostring(peer_id))
				end

				local interact_ext = data.unit:interaction()

				if interact_ext then
					interact_ext:set_waypoint_paused(false)
				end

				managers.network:session():send_to_peers_synched("interaction_set_waypoint_paused", data.unit, false)
			end
		end
	end
end

-- Lines 1141-1153
function CriminalsManager:remove_character_by_unit(unit)
	if type_name(unit) ~= "Unit" then
		return
	end

	local rem_u_key = unit:key()

	for id, data in pairs(self._characters) do
		if data.unit and data.taken and rem_u_key == data.unit:key() then
			self:_remove(id)

			return
		end
	end
end

-- Lines 1157-1164
function CriminalsManager:remove_character_by_peer_id(peer_id)
	for id, data in pairs(self._characters) do
		if data.taken and peer_id == data.peer_id then
			self:_remove(id)

			return
		end
	end
end

-- Lines 1168-1175
function CriminalsManager:remove_character_by_name(name)
	for id, data in pairs(self._characters) do
		if data.taken and name == data.name then
			self:_remove(id)

			return
		end
	end
end

-- Lines 1179-1189
function CriminalsManager:character_name_by_unit(unit)
	if type_name(unit) ~= "Unit" then
		return nil
	end

	local search_key = unit:key()

	for id, data in pairs(self._characters) do
		if data.unit and data.taken and search_key == data.unit:key() then
			return data.name
		end
	end
end

-- Lines 1193-1199
function CriminalsManager:character_name_by_panel_id(panel_id)
	for id, data in pairs(self._characters) do
		if data.taken and data.data.panel_id == panel_id then
			return data.name
		end
	end
end

-- Lines 1203-1213
function CriminalsManager:character_static_data_by_unit(unit)
	if type_name(unit) ~= "Unit" then
		return nil
	end

	local search_key = unit:key()

	for id, data in pairs(self._characters) do
		if data.unit and data.taken and search_key == data.unit:key() then
			return data.static_data
		end
	end
end

-- Lines 1217-1225
function CriminalsManager:nr_AI_criminals()
	local nr_AI_criminals = 0

	for i, char_data in pairs(self._characters) do
		if char_data.data.ai then
			nr_AI_criminals = nr_AI_criminals + 1
		end
	end

	return nr_AI_criminals
end

-- Lines 1227-1235
function CriminalsManager:nr_taken_criminals()
	local nr_taken_criminals = 0

	for i, char_data in pairs(self._characters) do
		if char_data.taken then
			nr_taken_criminals = nr_taken_criminals + 1
		end
	end

	return nr_taken_criminals
end

-- Lines 1239-1247
function CriminalsManager:is_character_as_AI_level_blocked(name)
	if not Global.game_settings.level_id then
		return false
	end

	local block_AIs = tweak_data.levels[Global.game_settings.level_id].block_AIs

	return block_AIs and block_AIs[name] or false
end

-- Lines 1251-1271
function CriminalsManager:get_team_ai_character(index)
	Global.team_ai = Global.team_ai or {}
	index = index or 1
	local char_name = nil

	if managers.job and managers.job:on_first_stage() and not managers.job:interupt_stage() or not Global.team_ai[index] then
		char_name = self:get_free_character_name()
		Global.team_ai[index] = char_name
	else
		char_name = Global.team_ai[index]

		while self:character_taken_by_name(char_name) do
			if Global.team_ai[index + 1] then
				Global.team_ai[index] = Global.team_ai[index + 1]
				Global.team_ai[index + 1] = nil
			else
				Global.team_ai[index] = self:get_free_character_name()
			end

			char_name = Global.team_ai[index]
		end
	end

	return char_name
end

-- Lines 1274-1288
function CriminalsManager:save_current_character_names()
	Global.team_ai = Global.team_ai or {}

	for _, char_data in pairs(self._characters) do
		if char_data.data and (char_data.data.ai or char_data.taken and alive(char_data.unit) and not char_data.unit:base().is_local_player) then
			Global.team_ai[char_data.data.panel_id] = char_data.name
		end
	end
end

-- Lines 1292-1327
function CriminalsManager:_reserve_loadout_for(char)
	print("[CriminalsManager]._reserve_loadout_for", char)

	local char_index = char

	if type(char) == "string" then
		for id, data in pairs(self._characters) do
			if data.name == char then
				char_index = id

				break
			end
		end
	end

	local my_char = self._characters[char_index]
	local slot = self._loadout_map[my_char.name]
	slot = slot and self._loadout_slots[slot]

	if slot and slot.char_index == char_index then
		self._loadout_slots[self._loadout_map[my_char.name]].char_index = nil
	end

	for i = 1, managers.criminals.MAX_NR_TEAM_AI do
		local data = self._loadout_slots[i]
		local char_data = data and self._characters[data.char_index]

		if not char_data or not char_data.data.ai or not char_data.taken or data.char_index == char_index then
			local slot = self._loadout_slots[i]
			slot.char_index = char_index
			self._loadout_map[self._characters[char_index].name] = i

			return managers.blackmarket:henchman_loadout(i, true)
		end
	end

	debug_pause("Failed to reserve loadout!")

	return managers.blackmarket:henchman_loadout(1, true)
end

-- Lines 1331-1368
function CriminalsManager:_reassign_loadouts()
	local current_taken = {}
	local remove_from_index = 1

	for i = 1, managers.criminals.MAX_NR_TEAM_AI do
		local data = self._loadout_slots[i]
		local char_data = data and self._characters[data.char_index]
		local taken_by_ai = char_data and char_data.data.ai and char_data.taken
		current_taken[i] = taken_by_ai and char_data or false

		if current_taken[i] then
			remove_from_index = remove_from_index + 1
		end
	end

	local to_reassign = {}

	for i = remove_from_index, managers.criminals.MAX_NR_TEAM_AI do
		local data = current_taken[i]

		if data and alive(data.unit) then
			table.insert(to_reassign, data)

			local index = self._loadout_map[data.name]

			if index then
				self._loadout_slots[index] = {}
			end

			self._loadout_map[data.name] = nil
		end
	end

	local loadout, visual_seed = nil
	local team_id = tweak_data.levels:get_default_team_ID("player")

	for k, v in pairs(to_reassign) do
		loadout = self:_reserve_loadout_for(v.name)
		visual_seed = v.visual_state.visual_seed or CriminalsManager.get_new_visual_seed()

		managers.groupai:state():set_unit_teamAI(v.unit, v.name, team_id, visual_seed, loadout)
		managers.network:session():send_to_peers_synched("set_unit", v.unit, v.name, managers.blackmarket:henchman_loadout_string_from_loadout(loadout), 0, 0, tweak_data.levels:get_default_team_ID("player"), visual_seed)
	end
end

-- Lines 1372-1374
function CriminalsManager:get_loadout_string_for(char_name)
	return managers.blackmarket:henchman_loadout_string(self:get_loadout_for(char_name))
end

-- Lines 1376-1380
function CriminalsManager:get_loadout_for(char_name)
	local index = self._loadout_map[char_name] or 1

	return managers.blackmarket:henchman_loadout(index, true)
end
