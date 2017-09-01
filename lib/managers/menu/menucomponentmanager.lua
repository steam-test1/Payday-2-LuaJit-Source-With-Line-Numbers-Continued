require("lib/managers/menu/MenuGuiComponent")
require("lib/managers/menu/MenuGuiComponentGeneric")
require("lib/managers/menu/SkillTreeGui")
require("lib/managers/menu/InfamyTreeGui")
require("lib/managers/menu/BlackMarketGui")
require("lib/managers/menu/InventoryList")
require("lib/managers/menu/MissionBriefingGui")
require("lib/managers/menu/StageEndScreenGui")
require("lib/managers/menu/LootDropScreenGUI")
require("lib/managers/menu/CrimeNetContractGui")
require("lib/managers/menu/CrimeNetFiltersGui")
require("lib/managers/menu/CrimeNetCasinoGui")
require("lib/managers/menu/MenuSceneGui")
require("lib/managers/menu/PlayerProfileGuiObject")
require("lib/managers/menu/IngameContractGui")
require("lib/managers/menu/IngameWaitingGui")
require("lib/managers/menu/IngameManualGui")
require("lib/managers/menu/PrePlanningMapGui")
require("lib/managers/menu/GameInstallingGui")
require("lib/managers/menu/PlayerInventoryGui")
require("lib/managers/hud/HUDLootScreen")
require("lib/managers/menu/SkillTreeGuiNew")
require("lib/managers/menu/MultiProfileItemGui")
require("lib/managers/menu/CustomSafehouseGui")
require("lib/managers/menu/items/CustomSafehouseGuiItem")
require("lib/managers/menu/items/CustomSafehouseHeisterInteractionDaily")
require("lib/managers/menu/pages/CustomSafehouseGuiPageMap")
require("lib/managers/menu/pages/CustomSafehouseGuiPageDaily")
require("lib/managers/menu/pages/CustomSafehouseGuiPageTrophies")
require("lib/managers/menu/MutatorsListGui")
require("lib/managers/menu/pages/MutatorsCategoryPage")
require("lib/managers/menu/NewHeistsGui")
require("lib/managers/menu/CrimeSpreeMenuComponent")
require("lib/managers/menu/CrimeSpreeContractMenuComponent")
require("lib/managers/menu/CrimeSpreeMissionsMenuComponent")
require("lib/managers/menu/CrimeSpreeDetailsMenuComponent")
require("lib/managers/menu/CrimeSpreeRewardsMenuComponent")
require("lib/managers/menu/CrimeSpreeModifierDetailsPage")
require("lib/managers/menu/CrimeSpreeRewardsDetailsPage")
require("lib/managers/menu/CrimeSpreeModifiersMenuComponent")
require("lib/utils/gui/GUIObjectWrapper")
require("lib/utils/gui/FineText")
require("lib/managers/menu/CrimeSpreeForcedModifiersMenuComponent")
require("lib/managers/menu/CrimeSpreeGageAssetsItem")
require("lib/managers/menu/CrimeSpreeMissionEndOptions")
require("lib/managers/menu/StageEndScreenTabCrimeSpree")
require("lib/managers/menu/IngameContractGuiCrimeSpree")
require("lib/managers/menu/CrimeSpreeContractBoxGui")
require("lib/managers/menu/LobbyCharacterData")
require("lib/managers/menu/CrewManagementGui")
require("lib/managers/menu/PromotionalMenuGui")
require("lib/managers/menu/PromotionalWeaponPreviewGui")
require("lib/managers/menu/RaidMenuGui")

MenuComponentManager = MenuComponentManager or class()

-- Lines: 96 to 234
function MenuComponentManager:init()
	self._ws = managers.gui_data:create_saferect_workspace()
	self._fullscreen_ws = managers.gui_data:create_fullscreen_16_9_workspace()
	self._main_panel = self._ws:panel():panel()
	self._requested_textures = {}
	self._block_texture_requests = false
	self._REFRESH_FRIENDS_TIME = 5
	self._refresh_friends_t = TimerManager:main():time() + self._REFRESH_FRIENDS_TIME
	self._sound_source = SoundDevice:create_source("MenuComponentManager")
	self._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(self, self, "resolution_changed"))
	self._request_done_clbk_func = callback(self, self, "_request_done_callback")
	self._preplanning_saved_draws = {}
	local is_installing, install_progress = managers.dlc:is_installing()
	self._is_game_installing = is_installing
	self._crimenet_enabled = not is_installing
	self._crimenet_offline_enabled = not is_installing
	self._generated = self._generated or {}
	self._active_components = {
		news = {
			create = callback(self, self, "_create_newsfeed_gui"),
			close = callback(self, self, "close_newsfeed_gui")
		},
		profile = {
			create = callback(self, self, "_create_profile_gui"),
			close = callback(self, self, "_disable_profile_gui")
		},
		friends = {
			create = callback(self, self, "_create_friends_gui"),
			close = callback(self, self, "_disable_friends_gui")
		},
		chats = {
			create = callback(self, self, "_create_chat_gui"),
			close = callback(self, self, "_disable_chat_gui")
		},
		lobby_chats = {
			create = callback(self, self, "_create_lobby_chat_gui"),
			close = callback(self, self, "hide_lobby_chat_gui")
		},
		crimenet_chats = {
			create = callback(self, self, "_create_crimenet_chats_gui"),
			close = callback(self, self, "hide_crimenet_chat_gui")
		},
		preplanning_chats = {
			create = callback(self, self, "_create_preplanning_chats_gui"),
			close = callback(self, self, "hide_preplanning_chat_gui")
		},
		contract = {
			create = callback(self, self, "_create_contract_gui"),
			close = callback(self, self, "_disable_contract_gui")
		},
		server_info = {
			create = callback(self, self, "_create_server_info_gui"),
			close = callback(self, self, "_disable_server_info_gui")
		},
		debug_strings = {
			create = callback(self, self, "_create_debug_strings_gui"),
			close = callback(self, self, "_disable_debug_strings_gui")
		},
		debug_fonts = {
			create = callback(self, self, "_create_debug_fonts_gui"),
			close = callback(self, self, "_disable_debug_fonts_gui")
		},
		skilltree = {
			create = callback(self, self, "_create_skilltree_gui"),
			close = callback(self, self, "close_skilltree_gui")
		},
		infamytree = {
			create = callback(self, self, "_create_infamytree_gui"),
			close = callback(self, self, "close_infamytree_gui")
		},
		crimenet = {
			create = callback(self, self, "_create_crimenet_gui"),
			close = callback(self, self, "close_crimenet_gui")
		},
		crimenet_contract = {
			create = callback(self, self, "_create_crimenet_contract_gui"),
			close = callback(self, self, "close_crimenet_contract_gui")
		},
		crimenet_filters = {
			create = callback(self, self, "_create_crimenet_filters_gui"),
			close = callback(self, self, "close_crimenet_filters_gui")
		},
		crimenet_casino = {
			create = callback(self, self, "_create_crimenet_casino_gui"),
			close = callback(self, self, "close_crimenet_casino_gui")
		},
		lootdrop_casino = {
			create = callback(self, self, "_create_lootdrop_casino_gui"),
			close = callback(self, self, "close_lootdrop_casino_gui")
		},
		blackmarket = {
			create = callback(self, self, "_create_blackmarket_gui"),
			close = callback(self, self, "close_blackmarket_gui")
		},
		mission_briefing = {
			create = callback(self, self, "_create_mission_briefing_gui"),
			close = callback(self, self, "_hide_mission_briefing_gui")
		},
		stage_endscreen = {
			create = callback(self, self, "_create_stage_endscreen_gui"),
			close = callback(self, self, "_hide_stage_endscreen_gui")
		},
		lootdrop = {
			create = callback(self, self, "_create_lootdrop_gui"),
			close = callback(self, self, "_hide_lootdrop_gui")
		},
		menuscene_info = {
			create = callback(self, self, "_create_menuscene_info_gui"),
			close = callback(self, self, "_close_menuscene_info_gui")
		},
		player_profile = {
			create = callback(self, self, "_create_player_profile_gui"),
			close = callback(self, self, "close_player_profile_gui")
		},
		ingame_contract = {
			create = callback(self, self, "_create_ingame_contract_gui"),
			close = callback(self, self, "close_ingame_contract_gui")
		},
		ingame_waiting = {
			create = callback(self, self, "_create_ingame_waiting_gui"),
			close = callback(self, self, "close_ingame_waiting_gui")
		},
		ingame_manual = {
			create = callback(self, self, "_create_ingame_manual_gui"),
			close = callback(self, self, "close_ingame_manual_gui")
		},
		inventory_list = {
			create = callback(self, self, "_create_inventory_list_gui"),
			close = callback(self, self, "close_inventory_list_gui")
		},
		preplanning_map = {
			create = callback(self, self, "create_preplanning_map_gui"),
			close = callback(self, self, "close_preplanning_map_gui")
		},
		game_installing = {
			create = callback(self, self, "create_game_installing_gui"),
			close = callback(self, self, "close_game_installing_gui")
		},
		inventory = {
			create = callback(self, self, "create_inventory_gui"),
			close = callback(self, self, "close_inventory_gui")
		},
		skilltree_new = {
			create = callback(self, self, "_create_skilltree_new_gui"),
			close = callback(self, self, "close_skilltree_new_gui")
		},
		custom_safehouse = {
			create = callback(self, self, "create_custom_safehouse_gui"),
			close = callback(self, self, "close_custom_safehouse_gui")
		},
		custom_safehouse_no_input = {
			create = callback(self, self, "disable_custom_safehouse_input"),
			close = callback(self, self, "enable_custom_safehouse_input")
		},
		custom_safehouse_primaries = {
			create = callback(self, self, "create_custom_safehouse_primaries"),
			close = callback(self, self, "close_custom_safehouse_primaries")
		},
		custom_safehouse_secondaries = {
			create = callback(self, self, "create_custom_safehouse_secondaries"),
			close = callback(self, self, "close_custom_safehouse_secondaries")
		},
		new_heists = {
			create = callback(self, self, "create_new_heists_gui"),
			close = callback(self, self, "close_new_heists_gui")
		},
		mutators_list = {
			create = callback(self, self, "create_mutators_list_gui"),
			close = callback(self, self, "close_mutators_list_gui")
		},
		crimenet_crime_spree_contract = {
			create = callback(self, self, "create_crime_spree_contract_gui"),
			close = callback(self, self, "close_crime_spree_contract_gui")
		},
		crime_spree_missions = {
			create = callback(self, self, "create_crime_spree_missions_gui"),
			close = callback(self, self, "close_crime_spree_missions_gui")
		},
		crime_spree_details = {
			create = callback(self, self, "create_crime_spree_details_gui"),
			close = callback(self, self, "close_crime_spree_details_gui")
		},
		crime_spree_modifiers = {
			create = callback(self, self, "create_crime_spree_modifiers_gui"),
			close = callback(self, self, "close_crime_spree_modifiers_gui")
		},
		crime_spree_forced_modifiers = {
			create = callback(self, self, "create_crime_spree_forced_modifiers_gui"),
			close = callback(self, self, "close_crime_spree_forced_modifiers_gui")
		},
		crime_spree_forced_modifiers_dummy = {create = callback(self, self, "check_crime_spree_forced_modifiers")},
		crime_spree_rewards = {
			create = callback(self, self, "create_crime_spree_rewards_gui"),
			close = callback(self, self, "close_crime_spree_rewards_gui")
		},
		crime_spree_mission_end = {
			create = callback(self, self, "create_crime_spree_mission_end_gui"),
			close = callback(self, self, "close_crime_spree_mission_end_gui")
		},
		debug_quicklaunch = {
			create = callback(self, self, "create_debug_quicklaunch_gui"),
			close = callback(self, self, "close_debug_quicklaunch_gui")
		},
		crew_management = {
			create = callback(self, self, "create_crew_management_gui"),
			close = callback(self, self, "close_crew_management_gui")
		},
		raid_menu = {
			create = callback(self, self, "create_raid_menu_gui"),
			close = callback(self, self, "close_raid_menu_gui")
		},
		raid_weapons_menu = {
			create = callback(self, self, "create_raid_weapons_menu_gui"),
			close = callback(self, self, "close_raid_weapons_menu_gui")
		},
		raid_preorder_menu = {
			create = callback(self, self, "create_raid_preorder_menu_gui"),
			close = callback(self, self, "close_raid_preorder_menu_gui")
		},
		raid_special_menu = {
			create = callback(self, self, "create_raid_special_menu_gui"),
			close = callback(self, self, "close_raid_special_menu_gui")
		},
		raid_weapon_preview = {
			create = callback(self, self, "create_raid_weapon_preview_gui"),
			close = callback(self, self, "close_raid_weapon_preview_gui")
		}
	}
	self._alive_components = {}
end

-- Lines: 236 to 237
function MenuComponentManager:save(data)
end

-- Lines: 239 to 241
function MenuComponentManager:load(data)
	self:on_whisper_mode_changed()
end

-- Lines: 247 to 262
function MenuComponentManager:register_component(id, component, priority)
	for i, comp_data in ipairs(self._alive_components) do
		if comp_data.id == id then
			return false
		end
	end

	table.insert(self._alive_components, {
		id = id,
		component = component,
		priority = priority or 0
	})
	table.sort(self._alive_components, function (a, b)
		return a.priority < b.priority
	end)
end

-- Lines: 264 to 271
function MenuComponentManager:unregister_component(id)
	for i, comp_data in ipairs(self._alive_components) do
		if comp_data.id == id then
			table.remove(self._alive_components, i)

			return true
		end
	end

	return false
end

-- Lines: 274 to 280
function MenuComponentManager:run_on_all_live_components(func, ...)
	for idx, comp_data in ipairs(self._alive_components) do
		if comp_data.component[func] then
			comp_data.component[func](comp_data.component, ...)
		end
	end
end

-- Lines: 282 to 291
function MenuComponentManager:run_return_on_all_live_components(func, ...)
	for idx, comp_data in ipairs(self._alive_components) do
		if comp_data.component[func] then
			local data = {comp_data.component[func](comp_data.component, ...)}

			if data[1] ~= nil then
				return true, data
			end
		end
	end

	return nil
end

-- Lines: 296 to 298
function MenuComponentManager:create_component_callback(class_name, component_name)
	local key = class_name

	return {
		create = callback(self, self, "_generated_create", {
			class_name,
			component_name
		}),
		close = callback(self, self, "_generated_close", component_name)
	}
end

-- Lines: 301 to 309
function MenuComponentManager:_generated_create(params, node)
	if not node then
		return
	end

	local class_name, component_name = unpack(params)
	self._generated[component_name] = self._generated[component_name] or _G[class_name]:new(self._ws, self._fullscreen_ws, node)

	self:register_component(component_name, self._generated[component_name])
end

-- Lines: 311 to 318
function MenuComponentManager:_generated_close(component_name)
	local current = self._generated[component_name]

	if current then
		current:close()

		self._generated[component_name] = nil

		self:unregister_component(component_name)
	end
end

-- Lines: 322 to 331
function MenuComponentManager:get_controller_input_bool(button)
	if not managers.menu or not managers.menu:active_menu() then
		return
	end

	local controller = managers.menu:active_menu().input:get_controller_class()

	if managers.menu:active_menu().input:get_accept_input() then
		return controller:get_input_bool(button)
	end
end

-- Lines: 333 to 349
function MenuComponentManager:_setup_controller_input()
	if not self._controller_connected then
		self._left_axis_vector = Vector3()
		self._right_axis_vector = Vector3()

		self._fullscreen_ws:connect_controller(managers.menu:active_menu().input:get_controller(), true)
		self._fullscreen_ws:panel():axis_move(callback(self, self, "_axis_move"))

		self._controller_connected = true

		if SystemInfo:platform() == Idstring("WIN32") then
			self._fullscreen_ws:connect_keyboard(Input:keyboard())
			self._fullscreen_ws:panel():key_press(callback(self, self, "key_press_controller_support"))
		end
	end
end

-- Lines: 351 to 365
function MenuComponentManager:_destroy_controller_input()
	if self._controller_connected then
		self._fullscreen_ws:disconnect_all_controllers()

		if alive(self._fullscreen_ws:panel()) then
			self._fullscreen_ws:panel():axis_move(nil)
		end

		self._controller_connected = nil

		if SystemInfo:platform() == Idstring("WIN32") then
			self._fullscreen_ws:disconnect_keyboard()
			self._fullscreen_ws:panel():key_press(nil)
		end
	end
end

-- Lines: 367 to 386
function MenuComponentManager:key_press_controller_support(o, k)
	if not MenuCallbackHandler:can_toggle_chat() then
		return
	end

	local toggle_chat = Idstring(managers.controller:get_settings("pc"):get_connection("toggle_chat"):get_input_name_list()[1])

	if k == toggle_chat then
		if self._game_chat_gui and self._game_chat_gui:enabled() then
			self._game_chat_gui:open_page()

			return
		end

		if managers.hud and not managers.hud:chat_focus() and managers.menu:toggle_chatinput() then
			managers.hud:set_chat_skip_first(true)
		end

		return
	end
end

-- Lines: 388 to 389
function MenuComponentManager:saferect_ws()
	return self._ws
end

-- Lines: 392 to 393
function MenuComponentManager:fullscreen_ws()
	return self._fullscreen_ws
end

-- Lines: 396 to 403
function MenuComponentManager:resolution_changed()
	managers.gui_data:layout_workspace(self._ws)
	managers.gui_data:layout_fullscreen_16_9_workspace(self._fullscreen_ws)

	if self._tcst then
		managers.gui_data:layout_fullscreen_16_9_workspace(self._tcst)
	end
end

-- Lines: 405 to 411
function MenuComponentManager:_axis_move(o, axis_name, axis_vector, controller)
	if axis_name == Idstring("left") then
		mvector3.set(self._left_axis_vector, axis_vector)
	elseif axis_name == Idstring("right") then
		mvector3.set(self._right_axis_vector, axis_vector)
	end
end

-- Lines: 413 to 441
function MenuComponentManager:set_active_components(components, node)
	if not alive(self._ws) or not alive(self._fullscreen_ws) then
		return
	end

	local to_close = {}

	for component, callbacks in pairs(self._active_components) do
		if callbacks.close then
			to_close[component] = true
		end
	end

	for _, component in ipairs(components) do
		if self._active_components[component] then
			to_close[component] = nil

			self._active_components[component].create(node)
		end
	end

	for component, _ in pairs(to_close) do
		self._active_components[component]:close()
	end

	if not managers.menu:is_pc_controller() then
		self:_setup_controller_input()
	end
end

-- Lines: 445 to 487
function MenuComponentManager:make_color_text(text_object, color)
	local text = text_object:text()
	local text_dissected = utf8.characters(text)
	local idsp = Idstring("#")
	local start_ci = {}
	local end_ci = {}
	local first_ci = true

	for i, c in ipairs(text_dissected) do
		if Idstring(c) == idsp then
			local next_c = text_dissected[i + 1]

			if next_c and Idstring(next_c) == idsp then
				if first_ci then
					table.insert(start_ci, i)
				else
					table.insert(end_ci, i)
				end

				first_ci = not first_ci
			end
		end
	end

	if #start_ci ~= #end_ci then
		-- Nothing
	else
		for i = 1, #start_ci, 1 do
			start_ci[i] = start_ci[i] - ((i - 1) * 4 + 1)
			end_ci[i] = end_ci[i] - (i * 4 - 1)
		end
	end

	text = string.gsub(text, "##", "")

	text_object:set_text(text)
	text_object:clear_range_color(1, utf8.len(text))

	if #start_ci ~= #end_ci then
		Application:error("CrimeNetGui:make_color_text: Not even amount of ##'s in text", #start_ci, #end_ci)
	else
		for i = 1, #start_ci, 1 do
			text_object:set_range_color(start_ci[i], end_ci[i], color or tweak_data.screen_colors.resource)
		end
	end
end

-- Lines: 491 to 495
function MenuComponentManager:on_job_updated()
	if self._contract_gui then
		self._contract_gui:refresh()
	end
end

-- Lines: 507 to 591
function MenuComponentManager:update(t, dt)
	if self._set_crimenet_enabled == true then
		if self._crimenet_gui then
			self._crimenet_gui:enable_crimenet()
		end

		self._set_crimenet_enabled = nil
	elseif self._set_crimenet_enabled == false then
		if self._crimenet_gui then
			self._crimenet_gui:disable_crimenet()
		end

		self._set_crimenet_enabled = nil
	end

	if self._mission_briefing_update_tab_wanted then
		self:update_mission_briefing_tab_positions()
	end

	self:_update_newsfeed_gui(t, dt)
	self:_update_game_installing_gui(t, dt)

	if self._refresh_friends_t < t then
		self:_update_friends_gui()

		self._refresh_friends_t = t + self._REFRESH_FRIENDS_TIME
	end

	if self._lobby_profile_gui then
		self._lobby_profile_gui:update(t, dt)
	end

	if self._profile_gui then
		self._profile_gui:update(t, dt)
	end

	if self._view_character_profile_gui then
		self._view_character_profile_gui:update(t, dt)
	end

	if self._contract_gui then
		self._contract_gui:update(t, dt)
	end

	if self._menuscene_info_gui then
		self._menuscene_info_gui:update(t, dt)
	end

	if self._skilltree_gui then
		self._skilltree_gui:update(t, dt)
	end

	if self._crimenet_contract_gui then
		self._crimenet_contract_gui:update(t, dt)
	end

	if self._lootdrop_gui then
		self._lootdrop_gui:update(t, dt)
	end

	if self._lootdrop_casino_gui then
		self._lootdrop_casino_gui:update(t, dt)
	end

	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:update(t, dt)
	end

	if self._mission_briefing_gui then
		self._mission_briefing_gui:update(t, dt)
	end

	if self._ingame_manual_gui then
		self._ingame_manual_gui:update(t, dt)
	end

	if self._preplanning_map then
		self._preplanning_map:update(t, dt)
	end

	if self._blackmarket_gui then
		self._blackmarket_gui:update(t, dt)
	end

	self:run_on_all_live_components("update", t, dt)
end

-- Lines: 593 to 601
function MenuComponentManager:get_left_controller_axis()
	if managers.menu:is_pc_controller() or not self._left_axis_vector then
		return 0, 0
	end

	local x = mvector3.x(self._left_axis_vector)
	local y = mvector3.y(self._left_axis_vector)

	return x, y
end

-- Lines: 604 to 612
function MenuComponentManager:get_right_controller_axis()
	if managers.menu:is_pc_controller() or not self._right_axis_vector then
		return 0, 0
	end

	local x = mvector3.x(self._right_axis_vector)
	local y = mvector3.y(self._right_axis_vector)

	return x, y
end

-- Lines: 617 to 627
function MenuComponentManager:accept_input(accept)
	if not self._weapon_text_box then
		return
	end

	if not accept then
		self._weapon_text_box:release_scroll_bar()
	end

	self:run_on_all_live_components("accept_input", accept)
end

-- Lines: 630 to 702
function MenuComponentManager:input_focus()
	if managers.blackmarket and managers.blackmarket:is_preloading_weapons() then
		return true
	end

	if managers.system_menu and managers.system_menu:is_active() and not managers.system_menu:is_closing() then
		return true
	end

	if self._game_chat_gui then
		local input_focus = self._game_chat_gui:input_focus()

		if input_focus == true then
			return true
		elseif input_focus == 1 then
			return 1
		end
	end

	if self._skilltree_gui then
		local input_focus = self._skilltree_gui:input_focus()

		if input_focus then
			return input_focus
		end
	end

	if self._infamytree_gui and self._infamytree_gui:input_focus() then
		return 1
	end

	if self:is_preplanning_enabled() then
		return self._preplanning_map:input_focus()
	end

	if self._blackmarket_gui then
		return self._blackmarket_gui:input_focus()
	end

	if self._mission_briefing_gui then
		return self._mission_briefing_gui:input_focus()
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:input_focus() ~= nil then
		return self._stage_endscreen_gui:input_focus()
	end

	if self._lootdrop_casino_gui then
		return self._lootdrop_casino_gui:input_focus()
	end

	if self._lootdrop_gui then
		return self._lootdrop_gui:input_focus()
	end

	if self._crimenet_gui then
		return self._crimenet_gui:input_focus()
	end

	if self._ingame_manual_gui then
		return self._ingame_manual_gui:input_focus()
	end

	if self._player_inventory_gui then
		return self._player_inventory_gui:input_focus()
	end

	local used, values = self:run_return_on_all_live_components("input_focus")

	if used then
		return unpack(values)
	end
end

-- Lines: 704 to 739
function MenuComponentManager:scroll_up()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if not self._weapon_text_box then
		return
	end

	self._weapon_text_box:scroll_up()

	if self._mission_briefing_gui and self._mission_briefing_gui:scroll_up() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:scroll_up() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:scroll_up() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:scroll_up() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("scroll_up")

	if used then
		return unpack(values)
	end
end

-- Lines: 741 to 776
function MenuComponentManager:scroll_down()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if not self._weapon_text_box then
		return
	end

	self._weapon_text_box:scroll_down()

	if self._mission_briefing_gui and self._mission_briefing_gui:scroll_down() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:scroll_down() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:scroll_down() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:scroll_down() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("scroll_down")

	if used then
		return unpack(values)
	end
end

-- Lines: 780 to 838
function MenuComponentManager:move_up()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:move_up() then
		return true
	end

	if self._infamytree_gui and self._infamytree_gui:move_up() then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:move_up() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:move_up() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:move_up() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:move_up() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:move_up() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:move_up() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("move_up")

	if used then
		return unpack(values)
	end
end

-- Lines: 840 to 898
function MenuComponentManager:move_down()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:move_down() then
		return true
	end

	if self._infamytree_gui and self._infamytree_gui:move_down() then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:move_down() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:move_down() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:move_down() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:move_down() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:move_down() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:move_down() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("move_down")

	if used then
		return unpack(values)
	end
end

-- Lines: 900 to 958
function MenuComponentManager:move_left()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:move_left() then
		return true
	end

	if self._infamytree_gui and self._infamytree_gui:move_left() then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:move_left() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:move_left() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:move_left() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:move_left() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:move_left() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:move_left() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("move_left")

	if used then
		return unpack(values)
	end
end

-- Lines: 961 to 1019
function MenuComponentManager:move_right()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:move_right() then
		return true
	end

	if self._infamytree_gui and self._infamytree_gui:move_right() then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:move_right() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:move_right() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:move_right() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:move_right() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:move_right() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:move_right() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("move_right")

	if used then
		return unpack(values)
	end
end

-- Lines: 1022 to 1097
function MenuComponentManager:next_page()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:next_page(true) then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:next_page() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:next_page() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:next_page() then
		return true
	end

	if self._crimenet_gui and self._crimenet_gui:next_page() then
		return true
	end

	if self:is_preplanning_enabled() and self._preplanning_map:next_page() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:next_page() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:next_page() then
		return true
	end

	if self._ingame_manual_gui and self._ingame_manual_gui:next_page() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:next_page() then
		return true
	end

	if self._crimenet_contract_gui and self._crimenet_contract_gui:next_page() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("next_page")

	if used then
		return unpack(values)
	end
end

-- Lines: 1099 to 1173
function MenuComponentManager:previous_page()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:previous_page(true) then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:previous_page() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:previous_page() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:previous_page() then
		return true
	end

	if self._crimenet_gui and self._crimenet_gui:previous_page() then
		return true
	end

	if self:is_preplanning_enabled() and self._preplanning_map:previous_page() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:previous_page() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:previous_page() then
		return true
	end

	if self._ingame_manual_gui and self._ingame_manual_gui:previous_page() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:previous_page() then
		return true
	end

	if self._crimenet_contract_gui and self._crimenet_contract_gui:previous_page() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("previous_page")

	if used then
		return unpack(values)
	end
end

-- Lines: 1175 to 1250
function MenuComponentManager:confirm_pressed()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:confirm_pressed() then
		return true
	end

	if self._infamytree_gui and self._infamytree_gui:confirm_pressed() then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:confirm_pressed() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:confirm_pressed() then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:confirm_pressed() then
		return true
	end

	if self._crimenet_gui and self._crimenet_gui:confirm_pressed() then
		return true
	end

	if self:is_preplanning_enabled() and self._preplanning_map:confirm_pressed() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:confirm_pressed() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:confirm_pressed() then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:confirm_pressed() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("confirm_pressed")

	if used then
		return unpack(values)
	end
end

-- Lines: 1252 to 1290
function MenuComponentManager:back_pressed()
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:back_pressed() then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:back_pressed() then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:back_pressed() then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:back_pressed() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("back_pressed")

	if used then
		return unpack(values)
	end
end

-- Lines: 1292 to 1367
function MenuComponentManager:special_btn_pressed(...)
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._game_chat_gui and self._game_chat_gui:special_btn_pressed(...) then
		return true
	end

	if self._preplanning_map and self._preplanning_map:special_btn_pressed(...) then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:special_btn_pressed(...) then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:special_btn_pressed(...) then
		return true
	end

	if self._crimenet_contract_gui and self._crimenet_contract_gui:special_btn_pressed(...) then
		return true
	end

	if self._crimenet_gui and self._crimenet_gui:special_btn_pressed(...) then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:special_btn_pressed(...) then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:special_btn_pressed(...) then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:special_btn_pressed(...) then
		return true
	end

	if self._crimenet_casino_gui and self._crimenet_casino_gui:special_btn_pressed(...) then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:special_btn_pressed(...) then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:special_btn_pressed(...) then
		return true
	end

	local used, values = self:run_return_on_all_live_components("special_btn_pressed", ...)

	if used then
		return unpack(values)
	end
end

-- Lines: 1369 to 1382
function MenuComponentManager:special_btn_released(...)
	if self._game_chat_gui and self._game_chat_gui:input_focus() == true then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:special_btn_released(...) then
		return true
	end

	local used, values = self:run_return_on_all_live_components("special_btn_released", ...)

	if used then
		return unpack(values)
	end
end

-- Lines: 1385 to 1709
function MenuComponentManager:mouse_pressed(o, button, x, y)
	if self._game_chat_gui and self._game_chat_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._infamytree_gui and self._infamytree_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._blackmarket_gui and self._blackmarket_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._newsfeed_gui and self._newsfeed_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._profile_gui and (button ~= Idstring("0") or self._profile_gui:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._profile_gui:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._profile_gui:mouse_wheel_up(x, y) then
		return true
	end

	if self._contract_gui and (button ~= Idstring("0") or self._contract_gui:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._contract_gui:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._contract_gui:mouse_wheel_up(x, y) then
		return true
	end

	if self._server_info_gui and (button ~= Idstring("0") or self._server_info_gui:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._server_info_gui:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._server_info_gui:mouse_wheel_up(x, y) then
		return true
	end

	if self._lobby_profile_gui and (button ~= Idstring("0") or self._lobby_profile_gui:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._lobby_profile_gui:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._lobby_profile_gui:mouse_wheel_up(x, y) then
		return true
	end

	if self._mission_briefing_gui and self._mission_briefing_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._stage_endscreen_gui and self._stage_endscreen_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._lootdrop_gui and self._lootdrop_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._lootdrop_casino_gui and self._lootdrop_casino_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._crimenet_casino_gui and self._crimenet_casino_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._view_character_profile_gui and (button ~= Idstring("0") or self._view_character_profile_gui:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._view_character_profile_gui:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._view_character_profile_gui:mouse_wheel_up(x, y) then
		return true
	end

	if self._test_profile1 and self._test_profile4:check_grab_scroll_bar(x, y) then
		return true
	end

	if self._crimenet_contract_gui and self._crimenet_contract_gui:mouse_pressed(o, button, x, y) then
		return true
	end

	if self:is_preplanning_enabled() and self._preplanning_map:mouse_pressed(button, x, y) then
		return true
	end

	if self._minimized_list and button == Idstring("0") then
		for i, data in ipairs(self._minimized_list) do
			if data.panel:inside(x, y) then
				data:callback()

				break
			end
		end
	end

	if self._friends_book and (button ~= Idstring("0") or self._friends_book:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._friends_book:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._friends_book:mouse_wheel_up(x, y) then
		return true
	end

	if self._debug_strings_book and (button ~= Idstring("0") or self._debug_strings_book:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._debug_strings_book:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._debug_strings_book:mouse_wheel_up(x, y) then
		return true
	end

	if self._weapon_text_box and (button ~= Idstring("0") or self._weapon_text_box:check_grab_scroll_bar(x, y)) and (button ~= Idstring("mouse wheel down") or self._weapon_text_box:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._weapon_text_box:mouse_wheel_up(x, y) then
		return true
	end

	if self._player_inventory_gui and self._player_inventory_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._crimenet_contract_gui and (button ~= Idstring("mouse wheel down") or self._crimenet_contract_gui:mouse_wheel_down(x, y)) and button == Idstring("mouse wheel up") and self._crimenet_contract_gui:mouse_wheel_up(x, y) then
		return true
	end

	local used, values = nil

	if button == Idstring("mouse wheel down") then
		used, values = self:run_return_on_all_live_components("mouse_wheel_down", x, y)
	elseif button == Idstring("mouse wheel up") then
		used, values = self:run_return_on_all_live_components("mouse_wheel_up", x, y)
	else
		used, values = self:run_return_on_all_live_components("mouse_pressed", button, x, y)
	end

	if used then
		return unpack(values)
	end

	if self._crimenet_gui and self._crimenet_gui:mouse_pressed(o, button, x, y) then
		return true
	end
end

-- Lines: 1711 to 1722
function MenuComponentManager:mouse_clicked(o, button, x, y)
	if self._blackmarket_gui then
		return self._blackmarket_gui:mouse_clicked(o, button, x, y)
	end

	if self._skilltree_gui then
		return self._skilltree_gui:mouse_clicked(o, button, x, y)
	end

	local used, values = self:run_return_on_all_live_components("mouse_clicked", o, button, x, y)

	if used then
		return unpack(values)
	end
end

-- Lines: 1724 to 1735
function MenuComponentManager:mouse_double_click(o, button, x, y)
	if self._blackmarket_gui then
		return self._blackmarket_gui:mouse_double_click(o, button, x, y)
	end

	if self._skilltree_gui then
		return self._skilltree_gui:mouse_double_click(o, button, x, y)
	end

	local used, values = self:run_return_on_all_live_components("mouse_double_click", o, button, x, y)

	if used then
		return unpack(values)
	end
end

-- Lines: 1737 to 1837
function MenuComponentManager:mouse_released(o, button, x, y)
	if self._game_chat_gui and self._game_chat_gui:mouse_released(o, button, x, y) then
		return true
	end

	if self._crimenet_gui and self._crimenet_gui:mouse_released(o, button, x, y) then
		return true
	end

	if self:is_preplanning_enabled() and self._preplanning_map:mouse_released(button, x, y) then
		return true
	end

	if self._blackmarket_gui then
		return self._blackmarket_gui:mouse_released(button, x, y)
	end

	if self._friends_book and self._friends_book:release_scroll_bar() then
		return true
	end

	if self._skilltree_gui and self._skilltree_gui:mouse_released(button, x, y) then
		return true
	end

	if self._debug_strings_book and self._debug_strings_book:release_scroll_bar() then
		return true
	end

	if self._chat_book then
		local used, pointer = self._chat_book:release_scroll_bar()

		if used then
			return true, pointer
		end
	end

	if self._profile_gui and self._profile_gui:release_scroll_bar() then
		return true
	end

	if self._contract_gui and self._contract_gui:release_scroll_bar() then
		return true
	end

	if self._server_info_gui and self._server_info_gui:release_scroll_bar() then
		return true
	end

	if self._lobby_profile_gui and self._lobby_profile_gui:release_scroll_bar() then
		return true
	end

	if self._view_character_profile_gui and self._view_character_profile_gui:release_scroll_bar() then
		return true
	end

	if self._test_profile1 and self._test_profile4:release_scroll_bar() then
		return true
	end

	if self._weapon_text_box and self._weapon_text_box:release_scroll_bar() then
		return true
	end

	local used, values = self:run_return_on_all_live_components("mouse_released", o, button, x, y)

	if used then
		return unpack(values)
	else
		return false
	end
end

-- Lines: 1839 to 2092
function MenuComponentManager:mouse_moved(o, x, y)
	local wanted_pointer = "arrow"

	if self._game_chat_gui then
		local used, pointer = self._game_chat_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._skilltree_gui then
		local used, pointer = self._skilltree_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._infamytree_gui then
		local used, pointer = self._infamytree_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._blackmarket_gui then
		local used, pointer = self._blackmarket_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._crimenet_contract_gui then
		local used, pointer = self._crimenet_contract_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self:is_preplanning_enabled() then
		local used, pointer = self._preplanning_map:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._friends_book then
		local used, pointer = self._friends_book:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._friends_book:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._debug_strings_book then
		local used, pointer = self._debug_strings_book:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._debug_strings_book:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._profile_gui then
		local used, pointer = self._profile_gui:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._profile_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._contract_gui then
		local used, pointer = self._contract_gui:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._contract_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._server_info_gui then
		local used, pointer = self._server_info_gui:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._server_info_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._backdrop_gui then
		local used, pointer = self._backdrop_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._mission_briefing_gui then
		local used, pointer = self._mission_briefing_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._stage_endscreen_gui then
		local used, pointer = self._stage_endscreen_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._lootdrop_gui then
		local used, pointer = self._lootdrop_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._lootdrop_casino_gui then
		local used, pointer = self._lootdrop_casino_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._crimenet_casino_gui then
		local used, pointer = self._crimenet_casino_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._lobby_profile_gui then
		local used, pointer = self._lobby_profile_gui:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._lobby_profile_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._view_character_profile_gui then
		local used, pointer = self._view_character_profile_gui:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._view_character_profile_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._test_profile1 then
		local used, pointer = self._test_profile1:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._test_profile2:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._test_profile3:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end

		local used, pointer = self._test_profile4:moved_scroll_bar(x, y)

		if used then
			return true, pointer
		end
	end

	if self._newsfeed_gui then
		local used, pointer = self._newsfeed_gui:mouse_moved(x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._minimized_list then
		for i, data in ipairs(self._minimized_list) do
			if data.mouse_over ~= data.panel:inside(x, y) then
				data.mouse_over = data.panel:inside(x, y)

				data.text:set_font(data.mouse_over and tweak_data.menu.default_font_no_outline_id or Idstring(tweak_data.menu.default_font))
				data.text:set_color(data.mouse_over and Color.black or Color.white)
				data.selected:set_visible(data.mouse_over)
				data.help_text:set_visible(data.mouse_over)
			end

			data.help_text:set_position(x + 12, y + 12)
		end
	end

	if self._weapon_text_box and self._weapon_text_box:moved_scroll_bar(x, y) then
		return true, wanted_pointer
	end

	if self._player_inventory_gui then
		local used, pointer = self._player_inventory_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	local used, values = self:run_return_on_all_live_components("mouse_moved", o, x, y)

	if used then
		local _, pointer = unpack(values)

		return true, pointer or wanted_pointer
	end

	if self._crimenet_gui then
		local used, pointer = self._crimenet_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	return false, wanted_pointer
end

-- Lines: 2096 to 2100
function MenuComponentManager:peer_outfit_updated(peer_id)
	if self._contract_gui then
		self._contract_gui:refresh()
	end
end

-- Lines: 2102 to 2112
function MenuComponentManager:on_peer_removed(peer, reason)
	if self._lootdrop_gui then
		self._lootdrop_gui:on_peer_removed(peer, reason)
	end

	if self._lootdrop_casino_gui then
		self._lootdrop_casino_gui:on_peer_removed(peer, reason)
	end

	if self._contract_gui then
		self._contract_gui:refresh()
	end
end

-- Lines: 2115 to 2120
function MenuComponentManager:_create_crimenet_contract_gui(node)
	self:close_crimenet_contract_gui()

	self._crimenet_contract_gui = CrimeNetContractGui:new(self._ws, self._fullscreen_ws, node)

	self:disable_crimenet()
end

-- Lines: 2122 to 2129
function MenuComponentManager:close_crimenet_contract_gui(...)
	if self._crimenet_contract_gui then
		self._crimenet_contract_gui:close()

		self._crimenet_contract_gui = nil

		self:enable_crimenet()
	end
end

-- Lines: 2131 to 2135
function MenuComponentManager:set_crimenet_contract_difficulty_id(difficulty_id)
	if self._crimenet_contract_gui then
		self._crimenet_contract_gui:set_difficulty_id(difficulty_id)
	end
end

-- Lines: 2140 to 2145
function MenuComponentManager:_create_crimenet_filters_gui(node)
	self:close_crimenet_filters_gui()

	self._crimenet_filters_gui = CrimeNetFiltersGui:new(self._ws, self._fullscreen_ws, node)

	self:disable_crimenet()
end

-- Lines: 2147 to 2154
function MenuComponentManager:close_crimenet_filters_gui(...)
	if self._crimenet_filters_gui then
		self._crimenet_filters_gui:close()

		self._crimenet_filters_gui = nil

		self:enable_crimenet()
	end
end

-- Lines: 2158 to 2163
function MenuComponentManager:_create_crimenet_casino_gui(node)
	self:close_crimenet_casino_gui()

	self._crimenet_casino_gui = CrimeNetCasinoGui:new(self._ws, self._fullscreen_ws, node)

	self:disable_crimenet()
end

-- Lines: 2165 to 2172
function MenuComponentManager:close_crimenet_casino_gui(...)
	if self._crimenet_casino_gui then
		self._crimenet_casino_gui:close()

		self._crimenet_casino_gui = nil

		self:enable_crimenet()
	end
end

-- Lines: 2174 to 2178
function MenuComponentManager:can_afford()
	if self._crimenet_casino_gui then
		self._crimenet_casino_gui:can_afford()
	end
end

-- Lines: 2181 to 2185
function MenuComponentManager:_create_crimenet_gui(...)
	if not self._crimenet_gui then
		self._crimenet_gui = CrimeNetGui:new(self._ws, self._fullscreen_ws, ...)
	end
end

-- Lines: 2187 to 2192
function MenuComponentManager:start_crimenet_job()
	self:enable_crimenet()

	if self._crimenet_gui then
		self._crimenet_gui:start_job()
	end
end

-- Lines: 2194 to 2196
function MenuComponentManager:enable_crimenet()
	self._set_crimenet_enabled = self._set_crimenet_enabled == nil and true
end

-- Lines: 2198 to 2200
function MenuComponentManager:disable_crimenet()
	self._set_crimenet_enabled = self._set_crimenet_enabled == nil and false
end

-- Lines: 2202 to 2206
function MenuComponentManager:update_crimenet_gui(t, dt)
	if self._crimenet_gui then
		self._crimenet_gui:update(t, dt)
	end
end

-- Lines: 2208 to 2210
function MenuComponentManager:update_crimenet_job(...)
	self._crimenet_gui:update_job(...)
end

-- Lines: 2212 to 2214
function MenuComponentManager:feed_crimenet_job_timer(...)
	self._crimenet_gui:feed_timer(...)
end

-- Lines: 2216 to 2220
function MenuComponentManager:update_crimenet_server_job(...)
	if self._crimenet_gui then
		self._crimenet_gui:update_server_job(...)
	end
end

-- Lines: 2222 to 2224
function MenuComponentManager:feed_crimenet_server_timer(...)
	self._crimenet_gui:feed_server_timer(...)
end

-- Lines: 2226 to 2230
function MenuComponentManager:criment_goto_lobby(...)
	if self._crimenet_gui then
		self._crimenet_gui:goto_lobby(...)
	end
end

-- Lines: 2232 to 2236
function MenuComponentManager:set_crimenet_players_online(amount)
	if self._crimenet_gui then
		self._crimenet_gui:set_players_online(amount)
	end
end

-- Lines: 2238 to 2242
function MenuComponentManager:add_crimenet_gui_preset_job(id)
	if self._crimenet_gui then
		self._crimenet_gui:add_preset_job(id)
	end
end

-- Lines: 2244 to 2248
function MenuComponentManager:add_crimenet_server_job(...)
	if self._crimenet_gui then
		self._crimenet_gui:add_server_job(...)
	end
end

-- Lines: 2250 to 2254
function MenuComponentManager:remove_crimenet_gui_job(id)
	if self._crimenet_gui then
		self._crimenet_gui:remove_job(id)
	end
end

-- Lines: 2256 to 2260
function MenuComponentManager:set_crimenet_gui_getting_hacked(hacked)
	if self._crimenet_gui then
		self._crimenet_gui:set_getting_hacked(hacked)
	end
end

-- Lines: 2262 to 2263
function MenuComponentManager:has_crimenet_gui()
	return not not self._crimenet_gui
end

-- Lines: 2266 to 2267
function MenuComponentManager:has_blackmarket_gui()
	return not not self._blackmarket_gui
end

-- Lines: 2271 to 2276
function MenuComponentManager:close_crimenet_gui()
	if self._crimenet_gui then
		self._crimenet_gui:close()

		self._crimenet_gui = nil
	end
end

-- Lines: 2279 to 2300
function MenuComponentManager:create_weapon_box(w_id, params)
	local title = managers.localization:text(tweak_data.weapon[w_id].name_id)
	local text = managers.localization:text(tweak_data.weapon[w_id].description_id)
	local stats_list = {
		{
			text = "DAMAGE: 32(+6)",
			current = 32,
			total = 50,
			type = "bar"
		},
		{
			h = 2,
			type = "empty"
		},
		{
			text = "RELOAD SPEED: 4(-2)",
			current = 4,
			total = 20,
			type = "bar"
		},
		{
			h = 2,
			type = "empty"
		},
		{
			text = "RECOIL: 8 (+0)",
			current = 8,
			total = 10,
			type = "bar"
		},
		{
			h = 2,
			type = "empty"
		},
		{
			type = "condition",
			value = params.condition or 19
		},
		{
			h = 10,
			type = "empty"
		},
		{
			type = "mods",
			list = {
				"SHORTENED BARREL",
				"SPEEDHOLSTER SLING",
				"ONMILTE TRITIUM SIGHTS"
			}
		},
		{
			h = 10,
			type = "empty"
		}
	}

	if self._weapon_text_box then
		self._weapon_text_box:recreate_text_box(self._ws, title, text, {stats_list = stats_list}, {
			no_close_legend = true,
			use_minimize_legend = true,
			type = "weapon_stats"
		})
	else
		self._weapon_text_box = TextBoxGui:new(self._ws, title, text, {stats_list = stats_list}, {
			no_close_legend = true,
			use_minimize_legend = true,
			type = "weapon_stats"
		})
	end
end

-- Lines: 2312 to 2321
function MenuComponentManager:close_weapon_box()
	if self._weapon_text_box then
		self._weapon_text_box:close()
	end

	self._weapon_text_box = nil

	if self._weapon_text_minimized_id then
		self:remove_minimized(self._weapon_text_minimized_id)

		self._weapon_text_minimized_id = nil
	end
end

-- Lines: 2324 to 2337
function MenuComponentManager:_create_chat_gui()
	if SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_multiplayer() and managers.network:session() then
		self._preplanning_chat_gui_active = false
		self._lobby_chat_gui_active = false
		self._crimenet_chat_gui_active = false

		if self._game_chat_gui then
			self:show_game_chat_gui()
		else
			self:add_game_chat()
		end

		self._game_chat_gui:set_params(self._saved_game_chat_params or "default")

		self._saved_game_chat_params = nil
	end
end

-- Lines: 2339 to 2352
function MenuComponentManager:_create_lobby_chat_gui()
	if SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_multiplayer() and managers.network:session() then
		self._preplanning_chat_gui_active = false
		self._lobby_chat_gui_active = true
		self._crimenet_chat_gui_active = false

		if self._game_chat_gui then
			self:show_game_chat_gui()
		else
			self:add_game_chat()
		end

		self._game_chat_gui:set_params(self._saved_game_chat_params or "lobby")

		self._saved_game_chat_params = nil
	end
end

-- Lines: 2354 to 2367
function MenuComponentManager:_create_crimenet_chats_gui()
	if SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_multiplayer() and managers.network:session() then
		self._preplanning_chat_gui_active = false
		self._crimenet_chat_gui_active = true
		self._lobby_chat_gui_active = false

		if self._game_chat_gui then
			self:show_game_chat_gui()
		else
			self:add_game_chat()
		end

		self._game_chat_gui:set_params(self._saved_game_chat_params or "crimenet")

		self._saved_game_chat_params = nil
	end
end

-- Lines: 2369 to 2382
function MenuComponentManager:_create_preplanning_chats_gui()
	if SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_multiplayer() and managers.network:session() then
		self._preplanning_chat_gui_active = true
		self._crimenet_chat_gui_active = false
		self._lobby_chat_gui_active = false

		if self._game_chat_gui then
			self:show_game_chat_gui()
		else
			self:add_game_chat()
		end

		self._game_chat_gui:set_params(self._saved_game_chat_params or "preplanning")

		self._saved_game_chat_params = nil
	end
end

-- Lines: 2384 to 2413
function MenuComponentManager:create_chat_gui()
	self:close_chat_gui()

	local config = {
		w = 540,
		use_minimize_legend = true,
		h = 220,
		header_type = "fit",
		no_close_legend = true,
		x = 290
	}
	self._chat_book = BookBoxGui:new(self._ws, nil, config)

	self._chat_book:set_layer(8)

	local global_gui = ChatGui:new(self._ws, "Global", "")

	global_gui:set_channel_id(ChatManager.GLOBAL)
	global_gui:set_layer(self._chat_book:layer())
	self._chat_book:add_page("Global", global_gui, false)
	self._chat_book:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 2415 to 2438
function MenuComponentManager:add_game_chat()
	if SystemInfo:platform() == Idstring("WIN32") then
		self._game_chat_gui = ChatGui:new(self._ws)

		if self._game_chat_params then
			self._game_chat_gui:set_params(self._game_chat_params)

			self._game_chat_params = nil
		end
	end
end

-- Lines: 2440 to 2447
function MenuComponentManager:set_max_lines_game_chat(max_lines)
	if self._game_chat_gui then
		self._game_chat_gui:set_max_lines(max_lines)
	else
		self._game_chat_params = self._game_chat_params or {}
		self._game_chat_params.max_lines = max_lines
	end
end

-- Lines: 2449 to 2457
function MenuComponentManager:pre_set_game_chat_leftbottom(from_left, from_bottom)
	if self._game_chat_gui then
		self._game_chat_gui:set_leftbottom(from_left, from_bottom)
	else
		self._game_chat_params = self._game_chat_params or {}
		self._game_chat_params.left = from_left
		self._game_chat_params.bottom = from_bottom
	end
end

-- Lines: 2459 to 2468
function MenuComponentManager:remove_game_chat()
	if not self._chat_book then
		return
	end

	self._chat_book:remove_page("Game")
end

-- Lines: 2470 to 2474
function MenuComponentManager:hide_lobby_chat_gui()
	if self._game_chat_gui and self._lobby_chat_gui_active then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2476 to 2480
function MenuComponentManager:hide_crimenet_chat_gui()
	if self._game_chat_gui and self._crimenet_chat_gui_active then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2482 to 2486
function MenuComponentManager:hide_preplanning_chat_gui()
	if self._game_chat_gui and self._preplanning_chat_gui_active then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2488 to 2492
function MenuComponentManager:hide_game_chat_gui()
	if self._game_chat_gui then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2494 to 2498
function MenuComponentManager:show_game_chat_gui()
	if self._game_chat_gui then
		self._game_chat_gui:show()
	end
end

-- Lines: 2500 to 2501
function MenuComponentManager:input_focut_game_chat_gui()
	return self._game_chat_gui and self._game_chat_gui:input_focus() == true
end

-- Lines: 2504 to 2508
function MenuComponentManager:_disable_chat_gui()
	if self._game_chat_gui and not self._lobby_chat_gui_active and not self._crimenet_chat_gui_active and not self._preplanning_chat_gui_active then
		self._game_chat_gui:set_enabled(false)
	end
end

-- Lines: 2510 to 2525
function MenuComponentManager:close_chat_gui()
	if self._game_chat_gui then
		self._game_chat_gui:close()

		self._game_chat_gui = nil
	end

	if self._chat_book_minimized_id then
		self:remove_minimized(self._chat_book_minimized_id)

		self._chat_book_minimized_id = nil
	end

	self._game_chat_bottom = nil
	self._lobby_chat_gui_active = nil
	self._crimenet_chat_gui_active = nil
	self._preplanning_chat_gui_active = nil
end

-- Lines: 2527 to 2531
function MenuComponentManager:set_crimenet_chat_gui(state)
	if self._game_chat_gui then
		self._game_chat_gui:set_crimenet_chat(state)
	end
end

-- Lines: 2534 to 2543
function MenuComponentManager:_create_friends_gui()
	if SystemInfo:platform() == Idstring("WIN32") then
		if self._friends_book then
			self._friends_book:set_enabled(true)

			return
		end

		self:create_friends_gui()
	end
end

-- Lines: 2545 to 2557
function MenuComponentManager:create_friends_gui()
	self:close_friends_gui()

	self._friends_book = BookBoxGui:new(self._ws, nil, {
		no_close_legend = true,
		no_scroll_legend = true
	})
	self._friends_gui = FriendsBoxGui:new(self._ws, "Friends", "")
	self._friends2_gui = FriendsBoxGui:new(self._ws, "Test", "", nil, nil, "recent")
	self._friends3_gui = FriendsBoxGui:new(self._ws, "Test", "")

	self._friends_book:add_page("Friends", self._friends_gui, true)
	self._friends_book:add_page("Recent Players", self._friends2_gui)
	self._friends_book:add_page("Clan", self._friends3_gui)
	self._friends_book:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 2559 to 2563
function MenuComponentManager:_update_friends_gui()
	if self._friends_gui then
		self._friends_gui:update_friends()
	end
end

-- Lines: 2565 to 2569
function MenuComponentManager:_disable_friends_gui()
	if self._friends_book then
		self._friends_book:set_enabled(false)
	end
end

-- Lines: 2572 to 2581
function MenuComponentManager:close_friends_gui()
	if self._friends_gui then
		self._friends_gui = nil
	end

	if self._friends_book then
		self._friends_book:close()

		self._friends_book = nil
	end
end

-- Lines: 2585 to 2592
function MenuComponentManager:_contract_gui_class()
	if managers.crime_spree:is_active() then
		return CrimeSpreeContractBoxGui
	else
		return ContractBoxGui
	end

	return ContractBoxGui
end

-- Lines: 2595 to 2602
function MenuComponentManager:_create_contract_gui()
	if self._contract_gui then
		self._contract_gui:set_enabled(true)

		return
	end

	self:create_contract_gui()
end

-- Lines: 2604 to 2612
function MenuComponentManager:create_contract_gui()
	self:close_contract_gui()

	self._contract_gui = self:_contract_gui_class():new(self._ws, self._fullscreen_ws)
	local peers_state = managers.menu:get_all_peers_state() or {}

	for i = 1, tweak_data.max_players, 1 do
		self._contract_gui:update_character_menu_state(i, peers_state[i])
	end
end

-- Lines: 2614 to 2618
function MenuComponentManager:update_contract_character(peer_id)
	if self._contract_gui then
		self._contract_gui:update_character(peer_id)
	end
end

-- Lines: 2620 to 2625
function MenuComponentManager:update_contract_character_menu_state(peer_id, state)
	if self._contract_gui then
		self._contract_gui:update_character_menu_state(peer_id, state)
		self._contract_gui:update_bg_state(peer_id, state)
	end
end

-- Lines: 2627 to 2633
function MenuComponentManager:show_contract_character(state)
	if self._contract_gui then
		for i = 1, tweak_data.max_players, 1 do
			self._contract_gui:set_character_panel_alpha(i, state and 1 or 0.4)
		end
	end
end

-- Lines: 2635 to 2637
function MenuComponentManager:_disable_contract_gui()
	self:close_contract_gui()
end

-- Lines: 2639 to 2644
function MenuComponentManager:close_contract_gui()
	if self._contract_gui then
		self._contract_gui:close()

		self._contract_gui = nil
	end
end

-- Lines: 2647 to 2649
function MenuComponentManager:_create_skilltree_new_gui(node)
	self:create_skilltree_new_gui(node)
end

-- Lines: 2650 to 2655
function MenuComponentManager:create_skilltree_new_gui(node)
	self:close_skilltree_new_gui()

	self._skilltree_gui = NewSkillTreeGui:new(self._ws, self._fullscreen_ws, node)
	self._new_skilltree_gui_active = true

	self:enable_skilltree_gui()
end

-- Lines: 2657 to 2663
function MenuComponentManager:close_skilltree_new_gui()
	if self._skilltree_gui and not self._old_skilltree_gui_active then
		self._skilltree_gui:close()

		self._skilltree_gui = nil
		self._new_skilltree_gui_active = nil
	end
end

-- Lines: 2672 to 2674
function MenuComponentManager:_create_skilltree_gui(node)
	self:create_skilltree_gui(node)
end

-- Lines: 2675 to 2680
function MenuComponentManager:create_skilltree_gui(node)
	self:close_skilltree_gui()

	self._skilltree_gui = SkillTreeGui:new(self._ws, self._fullscreen_ws, node)
	self._old_skilltree_gui_active = true

	self:enable_skilltree_gui()
end

-- Lines: 2682 to 2688
function MenuComponentManager:close_skilltree_gui()
	if self._skilltree_gui and not self._new_skilltree_gui_active then
		self._skilltree_gui:close()

		self._skilltree_gui = nil
		self._old_skilltree_gui_active = nil
	end
end

-- Lines: 2690 to 2694
function MenuComponentManager:enable_skilltree_gui()
	if self._skilltree_gui then
		self._skilltree_gui:enable()
	end
end

-- Lines: 2696 to 2700
function MenuComponentManager:disable_skilltree_gui()
	if self._skilltree_gui then
		self._skilltree_gui:disable()
	end
end

-- Lines: 2702 to 2706
function MenuComponentManager:on_tier_unlocked(...)
	if self._skilltree_gui then
		self._skilltree_gui:on_tier_unlocked(...)
	end
end

-- Lines: 2708 to 2712
function MenuComponentManager:on_points_spent(...)
	if self._skilltree_gui then
		self._skilltree_gui:on_points_spent(...)
	end
end

-- Lines: 2714 to 2718
function MenuComponentManager:on_skilltree_reset(...)
	if self._skilltree_gui then
		self._skilltree_gui:on_skilltree_reset(...)
	end
end

-- Lines: 2720 to 2722
function MenuComponentManager:_create_infamytree_gui()
	self:create_infamytree_gui()
end

-- Lines: 2723 to 2726
function MenuComponentManager:create_infamytree_gui(node)
	self:close_infamytree_gui()

	self._infamytree_gui = InfamyTreeGui:new(self._ws, self._fullscreen_ws, node)
end

-- Lines: 2728 to 2733
function MenuComponentManager:close_infamytree_gui()
	if self._infamytree_gui then
		self._infamytree_gui:close()

		self._infamytree_gui = nil
	end
end

-- Lines: 2736 to 2738
function MenuComponentManager:_create_inventory_list_gui(node)
	self:create_inventory_list_gui(node)
end

-- Lines: 2740 to 2743
function MenuComponentManager:create_inventory_list_gui(node)
	self:close_inventory_list_gui()

	self._inventory_list_gui = InventoryList:new(self._ws, self._fullscreen_ws, node)
end

-- Lines: 2745 to 2750
function MenuComponentManager:close_inventory_list_gui()
	if self._inventory_list_gui then
		self._inventory_list_gui:close()

		self._inventory_list_gui = nil
	end
end

-- Lines: 2753 to 2755
function MenuComponentManager:_create_blackmarket_gui(node)
	self:create_blackmarket_gui(node)
end

-- Lines: 2756 to 2767
function MenuComponentManager:create_blackmarket_gui(node)
	if not node then
		return
	end

	if node:parameters().set_blackmarket_enabled == nil then
		self:close_blackmarket_gui()
	end

	self._blackmarket_gui = self._blackmarket_gui or BlackMarketGui:new(self._ws, self._fullscreen_ws, node)

	if node:parameters().set_blackmarket_enabled ~= nil then
		self._blackmarket_gui:set_enabled(node:parameters().set_blackmarket_enabled)
	end
end

-- Lines: 2769 to 2773
function MenuComponentManager:set_blackmarket_tab_positions()
	if self._blackmarket_gui then
		self._blackmarket_gui:set_tab_positions()
	end
end

-- Lines: 2775 to 2779
function MenuComponentManager:reload_blackmarket_gui()
	if self._blackmarket_gui and not self._blackmarket_gui:in_setup() then
		self._blackmarket_gui:reload()
	end
end

-- Lines: 2781 to 2786
function MenuComponentManager:close_blackmarket_gui()
	if self._blackmarket_gui then
		self._blackmarket_gui:close()

		self._blackmarket_gui = nil
	end
end

-- Lines: 2788 to 2792
function MenuComponentManager:set_blackmarket_enabled(enabled)
	if self._blackmarket_gui then
		self._blackmarket_gui:set_enabled(enabled)
	end
end

-- Lines: 2794 to 2796
function MenuComponentManager:set_blackmarket_disable_fetching(disabled)
	self._blackmarket_disable_fetching = disabled
end

-- Lines: 2798 to 2799
function MenuComponentManager:blackmarket_fetching_disable()
	return self._blackmarket_disable_fetching
end

-- Lines: 2802 to 2806
function MenuComponentManager:hide_blackmarket_gui()
	if self._blackmarket_gui then
		self._blackmarket_gui:hide()
	end
end

-- Lines: 2808 to 2812
function MenuComponentManager:show_blackmarket_gui()
	if self._blackmarket_gui then
		self._blackmarket_gui:show()
	end
end

-- Lines: 2814 to 2818
function MenuComponentManager:get_bonus_stats_blackmarket_gui(cosmetic_id, weapon_id, bonus)
	if self._blackmarket_gui then
		return self._blackmarket_gui:get_bonus_stats(cosmetic_id, weapon_id, bonus)
	end
end

-- Lines: 2822 to 2823
function MenuComponentManager:custom_safehouse_gui()
	return self._custom_safehouse_gui
end

-- Lines: 2826 to 2832
function MenuComponentManager:create_custom_safehouse_gui(node)
	if not node then
		return
	end

	self._custom_safehouse_gui = self._custom_safehouse_gui or CustomSafehouseGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("custom_safehouse_gui", self._custom_safehouse_gui)
end

-- Lines: 2834 to 2840
function MenuComponentManager:close_custom_safehouse_gui()
	if self._custom_safehouse_gui then
		self._custom_safehouse_gui:close()

		self._custom_safehouse_gui = nil

		self:unregister_component("custom_safehouse_gui")
	end
end

-- Lines: 2842 to 2849
function MenuComponentManager:disable_custom_safehouse_input(node)
	if not self._custom_safehouse_gui then
		return
	end

	self._custom_safehouse_page = self._custom_safehouse_gui._active_page
	self._custom_safehouse_gui._selected_page = nil
end

-- Lines: 2851 to 2857
function MenuComponentManager:enable_custom_safehouse_input()
	if not self._custom_safehouse_gui then
		return
	end

	self._custom_safehouse_gui:set_active_page(self._custom_safehouse_page or 1)
end

-- Lines: 2862 to 2863
function MenuComponentManager:mutators_list_gui()
	return self._mutators_list_gui
end

-- Lines: 2866 to 2872
function MenuComponentManager:create_mutators_list_gui(node)
	if not node then
		return
	end

	self._mutators_list_gui = self._mutators_list_gui or MutatorsListGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("mutators_list_gui", self._mutators_list_gui)
end

-- Lines: 2874 to 2880
function MenuComponentManager:close_mutators_list_gui()
	if self._mutators_list_gui then
		self._mutators_list_gui:close()

		self._mutators_list_gui = nil

		self:unregister_component("mutators_list_gui")
	end
end

-- Lines: 2884 to 2892
function MenuComponentManager:_create_server_info_gui()
	if self._server_info_gui then
		self:close_server_info_gui()
	end

	self:create_server_info_gui()
end

-- Lines: 2894 to 2898
function MenuComponentManager:create_server_info_gui()
	self:close_server_info_gui()

	self._server_info_gui = ServerStatusBoxGui:new(self._ws)

	self._server_info_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 2900 to 2904
function MenuComponentManager:_disable_server_info_gui()
	if self._server_info_gui then
		self._server_info_gui:set_enabled(false)
	end
end

-- Lines: 2906 to 2911
function MenuComponentManager:close_server_info_gui()
	if self._server_info_gui then
		self._server_info_gui:close()

		self._server_info_gui = nil
	end
end

-- Lines: 2913 to 2917
function MenuComponentManager:set_server_info_state(state)
	if self._server_info_gui then
		self._server_info_gui:set_server_info_state(state)
	end
end

-- Lines: 2920 to 2922
function MenuComponentManager:_create_mission_briefing_gui(node)
	self:create_mission_briefing_gui(node)
end

-- Lines: 2924 to 2940
function MenuComponentManager:create_mission_briefing_gui(node)
	if Global.load_start_menu then
		return
	end

	if not self._mission_briefing_gui then
		self._mission_briefing_gui = MissionBriefingGui:new(self._ws, self._fullscreen_ws, node)

		if managers.groupai and managers.groupai:state() and not self._whisper_listener then
			self._whisper_listener = "MenuComponentManager_whisper_mode"

			managers.groupai:state():add_listener(self._whisper_listener, {"whisper_mode"}, callback(self, self, "on_whisper_mode_changed"))
		end
	else
		self._mission_briefing_gui:reload_loadout()
	end

	self._mission_briefing_gui:show()
end

-- Lines: 2942 to 2944
function MenuComponentManager:_hide_mission_briefing_gui()
	self:hide_mission_briefing_gui()
end

-- Lines: 2946 to 2950
function MenuComponentManager:hide_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:hide()
	end
end

-- Lines: 2952 to 2956
function MenuComponentManager:show_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:show()
	end
end

-- Lines: 2958 to 2968
function MenuComponentManager:close_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:close()

		self._mission_briefing_gui = nil

		if self._whisper_listener then
			managers.groupai:state():remove_listener(self._whisper_listener)

			self._whisper_listener = nil
		end
	end
end

-- Lines: 2969 to 2976
function MenuComponentManager:update_mission_briefing_tab_positions()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:update_tab_positions()

		self._mission_briefing_update_tab_wanted = nil
	else
		self._mission_briefing_update_tab_wanted = true
	end
end

-- Lines: 2978 to 2987
function MenuComponentManager:on_whisper_mode_changed()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:on_whisper_mode_changed()

		local hud = managers.hud:get_mission_briefing_hud()

		if hud then
			hud:on_whisper_mode_changed()
		end
	end
end

-- Lines: 2989 to 2993
function MenuComponentManager:set_mission_briefing_description(text_id)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:set_description_text_id(text_id)
	end
end

-- Lines: 2995 to 2999
function MenuComponentManager:on_ready_pressed_mission_briefing_gui(ready)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:on_ready_pressed(ready)
	end
end

-- Lines: 3001 to 3005
function MenuComponentManager:disable_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:set_enabled(false)
	end
end

-- Lines: 3007 to 3011
function MenuComponentManager:unlock_asset_mission_briefing_gui(asset_id)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:unlock_asset(asset_id)
	end
end

-- Lines: 3014 to 3018
function MenuComponentManager:unlock_gage_asset_mission_briefing_gui(asset_id)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:unlock_gage_asset(asset_id)
	end
end

-- Lines: 3021 to 3025
function MenuComponentManager:set_slot_outfit_mission_briefing_gui(slot, criminal_name, outfit)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:set_slot_outfit(slot, criminal_name, outfit)
	end
end

-- Lines: 3027 to 3031
function MenuComponentManager:create_asset_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:create_asset_tab()
	end
end

-- Lines: 3033 to 3037
function MenuComponentManager:close_asset_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:close_asset()
	end
end

-- Lines: 3039 to 3043
function MenuComponentManager:flash_ready_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:flash_ready()
	end
end

-- Lines: 3046 to 3048
function MenuComponentManager:_create_lootdrop_gui()
	self:create_lootdrop_gui()
end

-- Lines: 3050 to 3058
function MenuComponentManager:create_lootdrop_gui()
	if not self._lootdrop_gui then
		self._lootdrop_gui = LootDropScreenGui:new(self._ws, self._fullscreen_ws, managers.hud:get_lootscreen_hud(), self._saved_lootdrop_state)
		self._saved_lootdrop_state = nil
	end

	self:show_lootdrop_gui()
end

-- Lines: 3060 to 3066
function MenuComponentManager:set_lootdrop_state(state)
	if self._lootdrop_gui then
		self._lootdrop_gui:set_state(state)
	else
		self._saved_lootdrop_state = state
	end
end

-- Lines: 3068 to 3070
function MenuComponentManager:_hide_lootdrop_gui()
	self:hide_lootdrop_gui()
end

-- Lines: 3072 to 3076
function MenuComponentManager:hide_lootdrop_gui()
	if self._lootdrop_gui then
		self._lootdrop_gui:hide()
	end
end

-- Lines: 3078 to 3082
function MenuComponentManager:show_lootdrop_gui()
	if self._lootdrop_gui then
		self._lootdrop_gui:show()
	end
end

-- Lines: 3084 to 3089
function MenuComponentManager:close_lootdrop_gui()
	if self._lootdrop_gui then
		self._lootdrop_gui:close()

		self._lootdrop_gui = nil
	end
end

-- Lines: 3091 to 3096
function MenuComponentManager:lootdrop_is_now_active()
	if self._lootdrop_gui then
		self._lootdrop_gui._panel:show()
		self._lootdrop_gui._fullscreen_panel:show()
	end
end

-- Lines: 3100 to 3102
function MenuComponentManager:_create_lootdrop_casino_gui(node)
	self:create_lootdrop_casino_gui(node)
end

-- Lines: 3104 to 3174
function MenuComponentManager:create_lootdrop_casino_gui(node)
	if not self._lootdrop_casino_gui then
		local casino_data = node:parameters().menu_component_data or {}
		local card_secured = casino_data.secure_cards or 0
		local card_drops = {math.random(3) <= card_secured and casino_data.preferred_item}

		if card_drops[1] then
			card_secured = card_secured - 1 or card_secured
		end

		card_drops[2] = card_secured == 2 and managers.lootdrop:specific_fake_loot_pc(casino_data.preferred_item) or card_secured == 1 and card_secured == math.random(3) and managers.lootdrop:specific_fake_loot_pc(casino_data.preferred_item)

		if card_drops[2] then
			card_secured = card_secured - 1 or card_secured
		end

		card_drops[3] = card_secured > 0 and managers.lootdrop:specific_fake_loot_pc(casino_data.preferred_item)
		local skip_types = {
			xp = true,
			cash = true
		}
		local setup_lootdrop_data = {
			preferred_type = casino_data.preferred_item,
			preferred_type_drop = card_drops[1],
			preferred_chance = tweak_data:get_value("casino", "prefer_chance"),
			increase_infamous = casino_data.increase_infamous and tweak_data:get_value("casino", "infamous_chance"),
			skip_types = skip_types,
			disable_difficulty = true,
			max_pcs = 1
		}
		local new_lootdrop_data = {}

		managers.lootdrop:new_make_drop(new_lootdrop_data, setup_lootdrop_data)

		local global_values = {
			infamous = 4,
			exceptional = 3,
			superior = 2,
			normal = 1
		}
		local peer = managers.network:session() and managers.network:session():local_peer() or false
		local global_value = global_values[new_lootdrop_data.global_value] or 1
		local item_category = new_lootdrop_data.type_items
		local item_id = new_lootdrop_data.item_entry
		local max_pc = new_lootdrop_data.total_stars
		local item_pc = new_lootdrop_data.joker and 0 or math.ceil(new_lootdrop_data.item_payclass / 10)
		skip_types.weapon_mods = not managers.lootdrop:can_drop_weapon_mods() and true or nil
		local card_left_pc = card_drops[2] or managers.lootdrop:new_fake_loot_pc(nil, skip_types)
		local card_right_pc = card_drops[3] or managers.lootdrop:new_fake_loot_pc(nil, skip_types)
		local lootdrop_data = {
			peer,
			new_lootdrop_data.global_value,
			item_category,
			item_id,
			max_pc,
			item_pc,
			card_left_pc,
			card_right_pc
		}
		local selected_card = {[peer and peer:id() or 1] = 2}
		local parent_layer = managers.menu:active_menu() and managers.menu:active_menu().renderer:selected_node() and managers.menu:active_menu().renderer:selected_node():layer() or 100
		self._lootscreen_casino_hud = HUDLootScreen:new(nil, self._fullscreen_ws, nil, selected_card)

		self._lootscreen_casino_hud:set_layer(parent_layer + 1)
		self._lootscreen_casino_hud:show()

		self._lootdrop_casino_gui = CasinoLootDropScreenGui:new(self._ws, self._fullscreen_ws, self._lootscreen_casino_hud)

		self._lootdrop_casino_gui:set_layer(parent_layer + 1)
		self._lootscreen_casino_hud:make_cards(peer, max_pc, card_left_pc, card_right_pc)
		self._lootscreen_casino_hud:make_lootdrop(lootdrop_data)

		if not managers.menu:is_pc_controller() then
			managers.menu:active_menu().input:deactivate_controller_mouse()
		end
	end

	if self._lootdrop_casino_gui then
		self:disable_crimenet()
		self._lootdrop_casino_gui:show()
	end
end

-- Lines: 3176 to 3191
function MenuComponentManager:close_lootdrop_casino_gui()
	if self._lootdrop_casino_gui then
		self._lootdrop_casino_gui:close()

		self._lootdrop_casino_gui = nil

		self:enable_crimenet()
	end

	if self._lootscreen_casino_hud then
		self._lootscreen_casino_hud:close()

		self._lootscreen_casino_hud = nil

		if not managers.menu:is_pc_controller() then
			managers.menu:active_menu().input:activate_controller_mouse()
		end
	end
end

-- Lines: 3193 to 3194
function MenuComponentManager:check_lootdrop_casino_done()
	return self._lootdrop_casino_gui:card_chosen()
end

-- Lines: 3199 to 3201
function MenuComponentManager:_create_stage_endscreen_gui()
	self:create_stage_endscreen_gui()
end

-- Lines: 3206 to 3226
function MenuComponentManager:create_stage_endscreen_gui()
	if not self._stage_endscreen_gui then
		self._stage_endscreen_gui = StageEndScreenGui:new(self._ws, self._fullscreen_ws)
	end

	game_state_machine:current_state():set_continue_button_text()
	self._stage_endscreen_gui:show()

	if self._endscreen_predata then
		if self._endscreen_predata.cash_summary then
			self:show_endscreen_cash_summary()
		end

		if self._endscreen_predata.stats then
			self:feed_endscreen_statistics(self._endscreen_predata.stats)
		end

		if self._endscreen_predata.continue then
			self:set_endscreen_continue_button_text(self._endscreen_predata.continue[1], self._endscreen_predata.continue[2])
		end

		self._endscreen_predata = nil
	end
end

-- Lines: 3229 to 3231
function MenuComponentManager:_hide_stage_endscreen_gui()
	self:hide_stage_endscreen_gui()
end

-- Lines: 3234 to 3238
function MenuComponentManager:hide_stage_endscreen_gui()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:hide()
	end
end

-- Lines: 3241 to 3245
function MenuComponentManager:show_stage_endscreen_gui()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:show()
	end
end

-- Lines: 3247 to 3252
function MenuComponentManager:close_stage_endscreen_gui()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:close()

		self._stage_endscreen_gui = nil
	end
end

-- Lines: 3254 to 3261
function MenuComponentManager:show_endscreen_cash_summary()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:show_cash_summary()
	else
		self._endscreen_predata = self._endscreen_predata or {}
		self._endscreen_predata.cash_summary = true
	end
end

-- Lines: 3262 to 3270
function MenuComponentManager:feed_endscreen_statistics(data)
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:feed_statistics(data)
	else
		self._endscreen_predata = self._endscreen_predata or {}
		self._endscreen_predata.stats = data
	end
end

-- Lines: 3273 to 3280
function MenuComponentManager:set_endscreen_continue_button_text(text, not_clickable)
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:set_continue_button_text(text, not_clickable)
	else
		self._endscreen_predata = self._endscreen_predata or {}
		self._endscreen_predata.continue = {
			text,
			not_clickable
		}
	end
end

-- Lines: 3284 to 3290
function MenuComponentManager:_create_menuscene_info_gui(node)
	self:_close_menuscene_info_gui()

	if not self._menuscene_info_gui then
		self._menuscene_info_gui = MenuSceneGui:new(self._ws, self._fullscreen_ws, node)
	end
end

-- Lines: 3292 to 3297
function MenuComponentManager:_close_menuscene_info_gui()
	if self._menuscene_info_gui then
		self._menuscene_info_gui:close()

		self._menuscene_info_gui = nil
	end
end

-- Lines: 3301 to 3303
function MenuComponentManager:_create_player_profile_gui()
	self:create_player_profile_gui()
end

-- Lines: 3305 to 3308
function MenuComponentManager:create_player_profile_gui()
	self:close_player_profile_gui()

	self._player_profile_gui = PlayerProfileGuiObject:new(self._ws)
end

-- Lines: 3310 to 3314
function MenuComponentManager:refresh_player_profile_gui()
	if self._player_profile_gui then
		self:create_player_profile_gui()
	end
end

-- Lines: 3316 to 3325
function MenuComponentManager:close_player_profile_gui()
	if self._player_profile_gui then
		self._player_profile_gui:close()

		self._player_profile_gui = nil
	end
end

-- Lines: 3329 to 3331
function MenuComponentManager:_create_ingame_manual_gui()
	self:create_ingame_manual_gui()
end

-- Lines: 3333 to 3337
function MenuComponentManager:create_ingame_manual_gui()
	self:close_ingame_manual_gui()

	self._ingame_manual_gui = IngameManualGui:new(self._ws, self._fullscreen_ws)

	self._ingame_manual_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 3339 to 3346
function MenuComponentManager:ingame_manual_texture_done(texture_ids)
	if self._ingame_manual_gui then
		self._ingame_manual_gui:create_page(texture_ids)
	else
		local destroy_me = self._ws:panel():bitmap({
			w = 0,
			h = 0,
			visible = false,
			texture = texture_ids
		})

		destroy_me:parent():remove(destroy_me)
	end
end

-- Lines: 3348 to 3353
function MenuComponentManager:close_ingame_manual_gui()
	if self._ingame_manual_gui then
		self._ingame_manual_gui:close()

		self._ingame_manual_gui = nil
	end
end

-- Lines: 3357 to 3359
function MenuComponentManager:_create_ingame_contract_gui()
	self:create_ingame_contract_gui()
end

-- Lines: 3361 to 3374
function MenuComponentManager:create_ingame_contract_gui()
	self:close_ingame_contract_gui()

	if managers.crime_spree:is_active() then
		self._ingame_contract_gui = IngameContractGuiCrimeSpree:new(self._ws)

		self:register_component("ingame_contract", self._ingame_contract_gui)
	else
		self._ingame_contract_gui = IngameContractGui:new(self._ws)
	end

	self._ingame_contract_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 3376 to 3384
function MenuComponentManager:close_ingame_contract_gui()
	if self._ingame_contract_gui then
		self._ingame_contract_gui:close()

		self._ingame_contract_gui = nil

		self:unregister_component("ingame_contract")
	end
end

-- Lines: 3389 to 3391
function MenuComponentManager:_create_ingame_waiting_gui()
	self:create_ingame_waiting_gui()
end

-- Lines: 3393 to 3402
function MenuComponentManager:create_ingame_waiting_gui()
	if not Network:is_server() then
		return
	end

	self:close_ingame_waiting_gui()

	self._ingame_waiting_gui = IngameWaitingGui:new(self._ws)

	self._ingame_waiting_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
	self:register_component("ingame_waiting", self._ingame_waiting_gui)
end

-- Lines: 3404 to 3410
function MenuComponentManager:close_ingame_waiting_gui()
	if self._ingame_waiting_gui then
		self._ingame_waiting_gui:close()

		self._ingame_waiting_gui = nil

		self:unregister_component("ingame_waiting")
	end
end

-- Lines: 3413 to 3419
function MenuComponentManager:_create_profile_gui()
	if self._profile_gui then
		self._profile_gui:set_enabled(true)

		return
	end

	self:create_profile_gui()
end

-- Lines: 3421 to 3425
function MenuComponentManager:create_profile_gui()
	self:close_profile_gui()

	self._profile_gui = ProfileBoxGui:new(self._ws)

	self._profile_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 3427 to 3431
function MenuComponentManager:_disable_profile_gui()
	if self._profile_gui then
		self._profile_gui:set_enabled(false)
	end
end

-- Lines: 3433 to 3442
function MenuComponentManager:close_profile_gui()
	if self._profile_gui then
		self._profile_gui:close()

		self._profile_gui = nil
	end
end

-- Lines: 3444 to 3450
function MenuComponentManager:create_test_profiles()
	self:close_test_profiles()

	self._test_profile1 = ProfileBoxGui:new(self._ws)

	self._test_profile1:set_title("")
	self._test_profile1:set_use_minimize_legend(false)

	self._test_profile2 = ProfileBoxGui:new(self._ws)

	self._test_profile2:set_title("")
	self._test_profile2:set_use_minimize_legend(false)

	self._test_profile3 = ProfileBoxGui:new(self._ws)

	self._test_profile3:set_title("")
	self._test_profile3:set_use_minimize_legend(false)

	self._test_profile4 = ProfileBoxGui:new(self._ws)

	self._test_profile4:set_title("")
	self._test_profile4:set_use_minimize_legend(false)
end

-- Lines: 3452 to 3463
function MenuComponentManager:close_test_profiles()
	if self._test_profile1 then
		self._test_profile1:close()

		self._test_profile1 = nil

		self._test_profile2:close()

		self._test_profile2 = nil

		self._test_profile3:close()

		self._test_profile3 = nil

		self._test_profile4:close()

		self._test_profile4 = nil
	end
end

-- Lines: 3466 to 3471
function MenuComponentManager:create_lobby_profile_gui(peer_id, x, y)
	self:close_lobby_profile_gui()

	self._lobby_profile_gui = LobbyProfileBoxGui:new(self._ws, nil, nil, nil, {
		h = 160,
		x = x,
		y = y
	}, peer_id)

	self._lobby_profile_gui:set_title(nil)
	self._lobby_profile_gui:set_use_minimize_legend(false)
end

-- Lines: 3473 to 3482
function MenuComponentManager:close_lobby_profile_gui()
	if self._lobby_profile_gui then
		self._lobby_profile_gui:close()

		self._lobby_profile_gui = nil
	end

	if self._lobby_profile_gui_minimized_id then
		self:remove_minimized(self._lobby_profile_gui_minimized_id)

		self._lobby_profile_gui_minimized_id = nil
	end
end

-- Lines: 3485 to 3491
function MenuComponentManager:create_view_character_profile_gui(user, x, y)
	self:close_view_character_profile_gui()

	self._view_character_profile_gui = ViewCharacterProfileBoxGui:new(self._ws, nil, nil, nil, {
		w = 360,
		x = 837,
		h = 160,
		y = 100
	}, user)

	self._view_character_profile_gui:set_title(nil)
	self._view_character_profile_gui:set_use_minimize_legend(false)
end

-- Lines: 3493 to 3502
function MenuComponentManager:close_view_character_profile_gui()
	if self._view_character_profile_gui then
		self._view_character_profile_gui:close()

		self._view_character_profile_gui = nil
	end

	if self._view_character_profile_gui_minimized_id then
		self:remove_minimized(self._view_character_profile_gui_minimized_id)

		self._view_character_profile_gui_minimized_id = nil
	end
end

-- Lines: 3506 to 3547
function MenuComponentManager:get_texture_from_mod_type(type, sub_type, gadget, silencer, is_auto, equipped, mods, types, is_a_path)
	local texture = nil

	if is_a_path then
		texture = type
	elseif silencer then
		texture = "guis/textures/pd2/blackmarket/inv_mod_silencer"
	elseif type == "gadget" then
		texture = "guis/textures/pd2/blackmarket/inv_mod_" .. (gadget or "flashlight")
	elseif type == "upper_reciever" or type == "lower_reciever" then
		texture = "guis/textures/pd2/blackmarket/inv_mod_custom"
	elseif type == "custom" then
		texture = "guis/textures/pd2/blackmarket/inv_mod_" .. (sub_type or is_auto and "autofire" or "singlefire")
	elseif type == "sight" then
		texture = "guis/textures/pd2/blackmarket/inv_mod_scope"
	elseif type == "ammo" then
		if equipped then
			texture = "guis/textures/pd2/blackmarket/inv_mod_" .. tostring(sub_type or type)
		elseif mods and #mods > 0 then
			local weapon_factory_tweak_data = tweak_data.weapon.factory.parts
			local part_id = mods[1][1]
			type = weapon_factory_tweak_data[part_id].type
			sub_type = weapon_factory_tweak_data[part_id].sub_type
			texture = "guis/textures/pd2/blackmarket/inv_mod_" .. tostring(sub_type or type)
		end

		texture = "guis/textures/pd2/blackmarket/inv_mod_" .. tostring(sub_type or type)
	elseif type == "bonus" then
		if equipped then
			texture = "guis/textures/pd2/blackmarket/inv_mod_" .. tostring(sub_type or type)
		else
			texture = "guis/textures/pd2/blackmarket/inv_mod_bonus"
		end

		texture = "guis/textures/pd2/blackmarket/inv_mod_" .. tostring(sub_type or type)
	else
		texture = type == "vertical_grip" and "guis/textures/pd2/blackmarket/inv_mod_vertical_grip" or "guis/textures/pd2/blackmarket/inv_mod_" .. type
	end

	return texture
end

-- Lines: 3550 to 3668
function MenuComponentManager:create_weapon_mod_icon_list(weapon, category, factory_id, slot)
	local icon_list = {}
	local mods_all = managers.blackmarket:get_dropable_mods_by_weapon_id(weapon)
	local crafted = managers.blackmarket:get_crafted_category(category)[slot]
	local cosmetics_ids = managers.blackmarket:get_cosmetics_by_weapon_id(weapon)

	if table.size(mods_all) > 0 then
		local weapon_factory_tweak_data = tweak_data.weapon.factory.parts
		local mods_equip = deep_clone(managers.blackmarket:get_weapon_blueprint(category, slot))
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)

		for _, default_part in ipairs(default_blueprint) do
			table.delete(mods_equip, default_part)
		end

		local mods = {}
		local mods_sorted = {}
		local types = {}
		local type = nil

		if not crafted or not crafted.customize_locked then
			for id, data in pairs(mods_all) do
				mods[id] = mods[id] or {}

				for _, mod in ipairs(data) do
					table.insert(mods[id], clone(mod))
				end

				table.insert(mods_sorted, id)

				types[id] = true
			end
		end

		for _, data in pairs(mods) do
			local sort_td = tweak_data.blackmarket.weapon_mods
			local x_td, y_td, x_pc, y_pc = nil

			table.sort(data, function (x, y)
				x_td = sort_td[x[1]]
				y_td = sort_td[y[1]]
				x_pc = x_td.value or x_td.pc or x_td.pcs and x_td.pcs[1] or 10
				y_pc = y_td.value or y_td.pc or y_td.pcs and y_td.pcs[1] or 10
				x_pc = x_pc + (x[2] and tweak_data.lootdrop.global_values[x[2]].sort_number or 0)
				y_pc = y_pc + (y[2] and tweak_data.lootdrop.global_values[y[2]].sort_number or 0)

				return x_pc < y_pc or x_pc == y_pc and x[1] < y[1]
			end)
		end

		table.sort(mods_sorted, function (x, y)
			return y < x
		end)

		if table.size(cosmetics_ids) > 0 then
			types.weapon_cosmetics = true

			table.insert(mods_sorted, "weapon_cosmetics")
		end

		if crafted.cosmetics and crafted.cosmetics.bonus then
			local bonuses = tweak_data.economy:get_bonus_icons(tweak_data.blackmarket.weapon_skins[crafted.cosmetics.id].bonus)
			types.weapon_skin_bonuses = {}

			for _, texture_path in ipairs(bonuses) do
				table.insert(types.weapon_skin_bonuses, texture_path)
				table.insert(mods_sorted, texture_path)
			end
		end

		for _, name in pairs(mods_sorted) do
			local gadget, silencer, equipped, sub_type = nil
			local is_auto = tweak_data.weapon[weapon] and tweak_data.weapon[weapon].FIRE_MODE == "auto"
			local weapon_skin_bonus = false

			if types.weapon_skin_bonuses and table.contains(types.weapon_skin_bonuses, name) then
				equipped = not managers.job:is_current_job_competitive() and not managers.weapon_factory:has_perk("bonus", crafted.factory_id, crafted.blueprint)
				weapon_skin_bonus = true
			elseif name == "weapon_cosmetics" then
				equipped = not not managers.blackmarket:get_weapon_cosmetics(category, slot)
			else
				for _, name_equip in pairs(mods_equip) do
					if name == weapon_factory_tweak_data[name_equip].type then
						equipped = true
						sub_type = weapon_factory_tweak_data[name_equip].sub_type

						if name == "gadget" then
							gadget = sub_type
						end

						if sub_type == "silencer" then
							silencer = true

							break
						end

						silencer = false
						silencer = true

						break
					end
				end
			end

			local texture = self:get_texture_from_mod_type(name, sub_type, gadget, silencer, is_auto, equipped, mods[name], types, weapon_skin_bonus)

			if texture then
				if DB:has(Idstring("texture"), texture) then
					table.insert(icon_list, {
						texture = texture,
						equipped = equipped,
						type = name,
						weapon_skin_bonus = weapon_skin_bonus
					})
				else
					Application:error("[MenuComponentManager:create_weapon_mod_icon_list]", "Missing texture for weapon mod icon", texture)
				end
			end
		end
	end

	return icon_list
end

-- Lines: 3672 to 3677
function MenuComponentManager:create_game_installing_gui()
	if self._game_installing then
		return
	end

	self:_create_game_installing_gui()
end

-- Lines: 3678 to 3683
function MenuComponentManager:_create_game_installing_gui()
	self:close_game_installing_gui()

	if not MenuCallbackHandler:is_installed() then
		self._game_installing = GameInstallingGui:new(self._ws)
	end
end

-- Lines: 3685 to 3720
function MenuComponentManager:_update_game_installing_gui(t, dt)
	if not self._crimenet_enabled or not self._crimenet_offline_enabled then
		local is_installing, install_progress = managers.dlc:is_installing()

		if self._game_installing then
			self._game_installing:update(install_progress)
		end

		self._is_game_installing = is_installing

		if not self._is_game_installing and managers.menu:active_menu() then
			local logic = managers.menu:active_menu().logic

			if logic then
				local node = logic:get_node("main")

				if node then
					local crimenet = node:item("crimenet")

					if crimenet then
						crimenet:set_enabled(true)

						self._crimenet_enabled = true
					end

					local crimenet_offline = node:item("crimenet_offline")

					if crimenet_offline then
						crimenet_offline:set_enabled(true)

						self._crimenet_offline_enabled = true
					end
				else
					self._crimenet_enabled = true
					self._crimenet_offline_enabled = true
				end
			end

			self:close_game_installing_gui()
		end
	end
end

-- Lines: 3722 to 3727
function MenuComponentManager:close_game_installing_gui()
	if self._game_installing then
		self._game_installing:close()

		self._game_installing = nil
	end
end

-- Lines: 3774 to 3776
function MenuComponentManager:create_inventory_gui(node)
	self:_create_inventory_gui(node)
end

-- Lines: 3778 to 3786
function MenuComponentManager:_create_inventory_gui(node)
	self:close_inventory_gui()

	self._player_inventory_gui = PlayerInventoryGui:new(self._ws, self._fullscreen_ws, node)
	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end
end

-- Lines: 3788 to 3798
function MenuComponentManager:close_inventory_gui()
	if self._player_inventory_gui then
		self._player_inventory_gui:close()

		self._player_inventory_gui = nil
		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

-- Lines: 3801 to 3806
function MenuComponentManager:_create_newsfeed_gui()
	if self._newsfeed_gui then
		return
	end

	self:create_newsfeed_gui()
end

-- Lines: 3807 to 3812
function MenuComponentManager:create_newsfeed_gui()
	self:close_newsfeed_gui()

	if SystemInfo:platform() == Idstring("WIN32") then
		self._newsfeed_gui = NewsFeedGui:new(self._ws)
	end
end

-- Lines: 3814 to 3818
function MenuComponentManager:_update_newsfeed_gui(t, dt)
	if self._newsfeed_gui then
		self._newsfeed_gui:update(t, dt)
	end
end

-- Lines: 3820 to 3825
function MenuComponentManager:close_newsfeed_gui()
	if self._newsfeed_gui then
		self._newsfeed_gui:close()

		self._newsfeed_gui = nil
	end
end

-- Lines: 3830 to 3845
function MenuComponentManager:create_preplanning_map_gui(node)
	self._preplanning_map = self._preplanning_map or self:_create_preplanning_map_gui(node)

	self._preplanning_map:set_active_node(node)

	if self._preplanning_peer_draw_lines and self._preplanning_peer_draw_line_index then
		self:_set_preplanning_drawings(self._preplanning_peer_draw_lines, self._preplanning_peer_draw_line_index)
	end

	if #self._preplanning_saved_draws > 0 then
		self:_set_preplanning_saved_draws(self._preplanning_saved_draws)
	end

	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end
end

-- Lines: 3847 to 3848
function MenuComponentManager:_create_preplanning_map_gui(node)
	return PrePlanningMapGui:new(self._ws, self._fullscreen_ws, node)
end

-- Lines: 3851 to 3852
function MenuComponentManager:is_preplanning_enabled()
	return self._preplanning_map and self._preplanning_map:enabled()
end

-- Lines: 3855 to 3863
function MenuComponentManager:close_preplanning_map_gui()
	self:_close_preplanning_map_gui()

	if self._preplanning_map then
		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

-- Lines: 3865 to 3875
function MenuComponentManager:kill_preplanning_map_gui()
	if self._preplanning_map then
		if Network:is_server() then
			local peer_draw_lines, peer_draw_line_index = self._preplanning_map:get_drawings()
			self._preplanning_peer_draw_lines = peer_draw_lines
			self._preplanning_peer_draw_line_index = peer_draw_line_index
		end

		self._preplanning_map:close()

		self._preplanning_map = nil
	end
end

-- Lines: 3877 to 3881
function MenuComponentManager:_close_preplanning_map_gui()
	if self._preplanning_map then
		self._preplanning_map:disable()
	end
end

-- Lines: 3883 to 3887
function MenuComponentManager:preplanning_flash_error(...)
	if self._preplanning_map then
		self._preplanning_map:flash_error(...)
	end
end

-- Lines: 3889 to 3893
function MenuComponentManager:set_preplanning_category_filter(category)
	if self._preplanning_map then
		self._preplanning_map:set_category_filter(category)
	end
end

-- Lines: 3895 to 3899
function MenuComponentManager:set_preplanning_type_filter(type)
	if self._preplanning_map then
		self._preplanning_map:set_type_filter(type)
	end
end

-- Lines: 3901 to 3905
function MenuComponentManager:get_preplanning_filter()
	if self._preplanning_map then
		return self._preplanning_map:current_type_filter()
	end
end

-- Lines: 3907 to 3911
function MenuComponentManager:set_preplanning_selected_element_item(item)
	if self._preplanning_map then
		return self._preplanning_map:set_selected_element_item(item)
	end
end

-- Lines: 3913 to 3917
function MenuComponentManager:set_preplanning_map_position_to_item(item)
	if self._preplanning_map then
		return self._preplanning_map:set_map_position_to_item(item)
	end
end

-- Lines: 3919 to 3923
function MenuComponentManager:set_preplanning_map_position(x, y, location)
	if self._preplanning_map then
		return self._preplanning_map:set_map_position(x, y, location)
	end
end

-- Lines: 3925 to 3929
function MenuComponentManager:update_preplanning_element(type, id)
	if self._preplanning_map then
		return self._preplanning_map:update_element(type, id)
	end
end

-- Lines: 3931 to 3935
function MenuComponentManager:preplanning_post_event(event, listener_clbk)
	if self._preplanning_map then
		return self._preplanning_map:post_event(event, listener_clbk)
	end
end

-- Lines: 3937 to 3941
function MenuComponentManager:preplanning_stop_event()
	if self._preplanning_map then
		return self._preplanning_map:stop_event()
	end
end

-- Lines: 3943 to 3947
function MenuComponentManager:preplanning_start_custom_talk(id)
	if self._preplanning_map then
		return self._preplanning_map:start_custom_talk(id)
	end
end

-- Lines: 3949 to 3953
function MenuComponentManager:toggle_preplanning_drawing(peer_id)
	if self._preplanning_map then
		return self._preplanning_map:toggle_drawing(peer_id)
	end
end

-- Lines: 3955 to 3976
function MenuComponentManager:sync_preplanning_draw_event(peer_id, event_id, var1, var2)
	if self._preplanning_map then
		if event_id == 1 then
			self._preplanning_map:sync_start_drawing(peer_id, var1, var2)
		elseif event_id == 2 then
			self._preplanning_map:sync_end_drawing(peer_id)
		elseif event_id == 3 then
			self._preplanning_map:sync_undo_drawing(peer_id)
		elseif event_id == 4 then
			self._preplanning_map:sync_erase_drawing(peer_id)
		elseif event_id == 5 then
			local server_peer = managers.network and managers.network:session() and managers.network:session():server_peer()

			if server_peer and server_peer:id() == peer_id then
				for i = 1, managers.criminals.MAX_NR_CRIMINALS, 1 do
					self._preplanning_map:sync_erase_drawing(i)
				end
			end
		end
	else
		table.insert(self._preplanning_saved_draws, {
			peer_id,
			event_id,
			var1,
			var2,
			clbk = "sync_preplanning_draw_event"
		})
	end
end

-- Lines: 3978 to 3984
function MenuComponentManager:sync_preplanning_draw_point(peer_id, x, y)
	if self._preplanning_map then
		return self._preplanning_map:sync_draw_point(peer_id, x, y)
	else
		table.insert(self._preplanning_saved_draws, {
			peer_id,
			x,
			y,
			clbk = "sync_preplanning_draw_point"
		})
	end
end

-- Lines: 3986 to 3996
function MenuComponentManager:clear_preplanning_draws(peer_id)
	if self._preplanning_map then
		self._preplanning_map:sync_erase_drawing(peer_id)
	else
		for i = #self._preplanning_saved_draws, 1, -1 do
			if self._preplanning_saved_draws[i][1] == peer_id then
				table.remove(self._preplanning_saved_draws, i)
			end
		end
	end
end

-- Lines: 3998 to 4013
function MenuComponentManager:preplanning_sync_save(data)
	if not data then
		return
	end

	if self._preplanning_map then
		local peer_draw_lines, peer_draw_line_index = self._preplanning_map:get_drawings()
		data.peer_draw_lines = peer_draw_lines
		data.peer_draw_line_index = peer_draw_line_index
	elseif self._preplanning_peer_draw_lines and self._preplanning_peer_draw_line_index then
		data.peer_draw_lines = self._preplanning_peer_draw_lines
		data.peer_draw_line_index = self._preplanning_peer_draw_line_index
	else
		data.preplanning_saved_draws = self._preplanning_saved_draws
	end
end

-- Lines: 4015 to 4034
function MenuComponentManager:preplanning_sync_load(data)
	if not data then
		return
	end

	if self._preplanning_map then
		if data.preplanning_saved_draws then
			self:_set_preplanning_saved_draws(data.preplanning_saved_draws)
		elseif data.peer_draw_lines and data.peer_draw_line_index then
			self:_set_preplanning_drawings(data.peer_draw_lines, data.peer_draw_line_index)
		end
	elseif data.preplanning_saved_draws then
		self._preplanning_saved_draws = data.preplanning_saved_draws
	elseif data.peer_draw_lines and data.peer_draw_line_index then
		self._preplanning_peer_draw_lines = data.peer_draw_lines
		self._preplanning_peer_draw_line_index = data.peer_draw_line_index
	end
end

-- Lines: 4036 to 4049
function MenuComponentManager:_set_preplanning_saved_draws(preplanning_saved_draws)
	local clbk, vars = nil

	for _, draw_data in ipairs(preplanning_saved_draws) do
		clbk = draw_data.clbk

		if clbk and self[clbk] then
			vars = {}

			for _, var in ipairs(draw_data) do
				table.insert(vars, var)
			end

			self[clbk](self, unpack(vars))
		end
	end

	self._preplanning_saved_draws = {}
end

-- Lines: 4051 to 4055
function MenuComponentManager:_set_preplanning_drawings(peer_draw_lines, peer_draw_line_index)
	self._preplanning_map:set_drawings(peer_draw_lines, peer_draw_line_index)

	self._preplanning_peer_draw_lines = nil
	self._preplanning_peer_draw_line_index = nil
end

-- Lines: 4058 to 4062
function MenuComponentManager:hide_preplanning_drawboard()
	if self._preplanning_map then
		self._preplanning_map:hide_drawboard()
	end
end

-- Lines: 4064 to 4068
function MenuComponentManager:set_preplanning_drawboard(x, y)
	if self._preplanning_map then
		self._preplanning_map:set_drawboard_button_position(x, y)
	end
end

-- Lines: 4070 to 4074
function MenuComponentManager:get_game_chat_button_shape()
	if self._game_chat_gui then
		return self._game_chat_gui:get_chat_button_shape()
	end
end

-- Lines: 4078 to 4082
function MenuComponentManager:set_blackmarket_tradable_loaded(error)
	if self._blackmarket_gui then
		self._blackmarket_gui:set_tradable_loaded(error)
	end
end

-- Lines: 4085 to 4092
function MenuComponentManager:_create_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:set_enabled(true)

		return
	end

	self:create_debug_fonts_gui()
end

-- Lines: 4094 to 4097
function MenuComponentManager:create_debug_fonts_gui()
	self:close_debug_fonts_gui()

	self._debug_fonts_gui = DebugDrawFonts:new(self._fullscreen_ws)
end

-- Lines: 4099 to 4103
function MenuComponentManager:_disable_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:set_enabled(false)
	end
end

-- Lines: 4105 to 4110
function MenuComponentManager:close_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:close()

		self._debug_fonts_gui = nil
	end
end

-- Lines: 4119 to 4120
function MenuComponentManager:toggle_debug_fonts_gui()
end

-- Lines: 4122 to 4126
function MenuComponentManager:reload_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:reload()
	end
end

-- Lines: 4129 to 4136
function MenuComponentManager:_create_debug_strings_gui()
	if self._debug_strings_book then
		self._debug_strings_book:set_enabled(true)

		return
	end

	self:create_debug_strings_gui()
end

-- Lines: 4138 to 4152
function MenuComponentManager:create_debug_strings_gui()
	self:close_debug_strings_gui()

	self._debug_strings_book = BookBoxGui:new(self._ws, nil, {
		no_close_legend = true,
		no_scroll_legend = true,
		h = 612,
		w = 1088
	})

	self._debug_strings_book._info_box:close()

	self._debug_strings_book._info_box = nil

	for i, file_name in ipairs({
		"debug",
		"blackmarket",
		"challenges",
		"hud",
		"atmospheric_text",
		"subtitles",
		"heist",
		"menu",
		"savefile",
		"system_text",
		"systemmenu",
		"wip"
	}) do
		local gui = DebugStringsBoxGui:new(self._ws, "file", "", nil, nil, "strings/" .. file_name)

		self._debug_strings_book:add_page(file_name, gui, i == 1)
	end

	self._debug_strings_book:add_background()
	self._debug_strings_book:set_layer(tweak_data.gui.DIALOG_LAYER)
	self._debug_strings_book:set_centered()
end

-- Lines: 4160 to 4164
function MenuComponentManager:_disable_debug_strings_gui()
	if self._debug_strings_book then
		self._debug_strings_book:set_enabled(false)
	end
end

-- Lines: 4171 to 4176
function MenuComponentManager:close_debug_strings_gui()
	if self._debug_strings_book then
		self._debug_strings_book:close()

		self._debug_strings_book = nil
	end
end

-- Lines: 4180 to 4184
function MenuComponentManager:_maximize_weapon_box(data)
	self._weapon_text_box:set_visible(true)

	self._weapon_text_minimized_id = nil

	self:remove_minimized(data.id)
end

-- Lines: 4186 to 4223
function MenuComponentManager:add_minimized(config)
	self._minimized_list = self._minimized_list or {}
	self._minimized_id = (self._minimized_id or 0) + 1
	local panel = self._main_panel:panel({
		w = 100,
		h = 20,
		layer = tweak_data.gui.MENU_COMPONENT_LAYER
	})
	local text = nil

	if config.text then
		text = panel:text({
			vertical = "center",
			hvertical = "center",
			halign = "left",
			font_size = 22,
			align = "center",
			layer = 2,
			text = config.text,
			font = tweak_data.menu.default_font
		})

		text:set_center_y(panel:center_y())

		local _, _, w, h = text:text_rect()

		text:set_size(w + 8, h)
		panel:set_size(w + 8, h)
	end

	local help_text = panel:parent():text({
		halign = "left",
		vertical = "center",
		hvertical = "center",
		align = "left",
		visible = false,
		layer = 3,
		text = config.help_text or "CLICK TO MAXIMIZE WEAPON INFO",
		font = tweak_data.menu.small_font,
		font_size = tweak_data.menu.small_font_size,
		color = Color.white
	})

	help_text:set_shape(help_text:text_rect())

	local unselected = panel:bitmap({
		texture = "guis/textures/menu_unselected",
		layer = 0
	})

	unselected:set_h((64 * panel:h()) / 32)
	unselected:set_center_y(panel:center_y())

	local selected = panel:bitmap({
		texture = "guis/textures/menu_selected",
		visible = false,
		layer = 1
	})

	selected:set_h((64 * panel:h()) / 32)
	selected:set_center_y(panel:center_y())
	panel:set_bottom(self._main_panel:h() - CoreMenuRenderer.Renderer.border_height)

	local top_line = panel:parent():bitmap({
		texture = "guis/textures/headershadow",
		layer = 1,
		visible = false,
		w = panel:w()
	})

	top_line:set_bottom(panel:top())
	table.insert(self._minimized_list, {
		mouse_over = false,
		id = self._minimized_id,
		panel = panel,
		selected = selected,
		text = text,
		help_text = help_text,
		top_line = top_line,
		callback = config.callback
	})
	self:_layout_minimized()

	return self._minimized_id
end

-- Lines: 4226 to 4233
function MenuComponentManager:_layout_minimized()
	local x = 0

	for i, data in ipairs(self._minimized_list) do
		data.panel:set_x(x)
		data.top_line:set_x(x)

		x = x + data.panel:w() + 2
	end
end

-- Lines: 4235 to 4246
function MenuComponentManager:remove_minimized(id)
	for i, data in ipairs(self._minimized_list) do
		if data.id == id then
			data.help_text:parent():remove(data.help_text)
			data.top_line:parent():remove(data.top_line)
			self._main_panel:remove(data.panel)
			table.remove(self._minimized_list, i)

			break
		end
	end

	self:_layout_minimized()
end

-- Lines: 4249 to 4266
function MenuComponentManager:_request_done_callback(texture_ids)
	local key = texture_ids:key()
	local entry = self._requested_textures[key]

	if not entry then
		return
	end

	local clbks = {}

	for index, owner_data in pairs(entry.owners) do
		table.insert(clbks, owner_data.clbk)

		owner_data.clbk = nil
	end

	for _, clbk in pairs(clbks) do
		clbk(texture_ids)
	end
end

-- Lines: 4268 to 4307
function MenuComponentManager:request_texture(texture, done_cb)
	if self._block_texture_requests then
		debug_pause(string.format("[MenuComponentManager:request_texture] Requesting texture is blocked! %s", texture))

		return false
	end

	local texture_ids = Idstring(texture)

	if not DB:has(Idstring("texture"), texture_ids) then
		Application:error(string.format("[MenuComponentManager:request_texture] No texture entry named \"%s\" in database.", texture))

		return false
	end

	local key = texture_ids:key()
	local entry = self._requested_textures[key]

	if not entry then
		entry = {
			next_index = 1,
			owners = {},
			texture_ids = texture_ids
		}
		self._requested_textures[key] = entry
	end

	local index = entry.next_index
	entry.owners[index] = {clbk = done_cb}
	local next_index = index + 1

	while entry.owners[next_index] do
		if index == next_index then
			debug_pause("[MenuComponentManager:request_texture] overflow!")
		end

		next_index = next_index + 1

		if next_index == 10000 then
			next_index = 1
		end
	end

	entry.next_index = next_index

	TextureCache:request(texture_ids, "NORMAL", callback(self, self, "_request_done_callback"), 100)

	return index
end

-- Lines: 4310 to 4323
function MenuComponentManager:unretrieve_texture(texture, index)
	local texture_ids = Idstring(texture)
	local key = texture_ids:key()
	local entry = self._requested_textures[key]

	if entry and entry.owners[index] then
		entry.owners[index] = nil

		if not next(entry.owners) then
			self._requested_textures[key] = nil
		end

		TextureCache:unretrieve(texture_ids)
	end
end

-- Lines: 4328 to 4329
function MenuComponentManager:retrieve_texture(texture)
	return TextureCache:retrieve(texture, "NORMAL")
end

-- Lines: 4333 to 4387
function MenuComponentManager:add_colors_to_text_object(text_object, ...)
	local text = text_object:text()
	local unchanged_text = text
	local colors = {...}
	local default_color = #colors == 1 and colors[1] or tweak_data.screen_colors.text
	local start_ci, end_ci, first_ci = nil
	local text_dissected = utf8.characters(text)
	local idsp = Idstring("#")
	start_ci = {}
	end_ci = {}
	first_ci = true

	for i, c in ipairs(text_dissected) do
		if Idstring(c) == idsp then
			local next_c = text_dissected[i + 1]

			if next_c and Idstring(next_c) == idsp then
				if first_ci then
					table.insert(start_ci, i)
				else
					table.insert(end_ci, i)
				end

				first_ci = not first_ci
			end
		end
	end

	if #start_ci ~= #end_ci then
		-- Nothing
	else
		for i = 1, #start_ci, 1 do
			start_ci[i] = start_ci[i] - ((i - 1) * 4 + 1)
			end_ci[i] = end_ci[i] - (i * 4 - 1)
		end
	end

	text = string.gsub(text, "##", "")

	text_object:set_text(text)

	if colors then
		text_object:clear_range_color(1, utf8.len(text))

		if #start_ci ~= #end_ci then
			Application:error("[MenuComponentManager:color_text_object]: Missing '#' in text:", unchanged_text, #start_ci, #end_ci)
		else
			for i = 1, #start_ci, 1 do
				text_object:set_range_color(start_ci[i], end_ci[i], colors[i] or default_color)
			end
		end
	end
end
MenuComponentPostEventInstance = MenuComponentPostEventInstance or class()

-- Lines: 4390 to 4393
function MenuComponentPostEventInstance:init(sound_source)
	self._sound_source = sound_source
	self._post_event = false
end

-- Lines: 4395 to 4404
function MenuComponentPostEventInstance:post_event(event)
	if alive(self._post_event) then
		self._post_event:stop()
	end

	self._post_event = false
	self._post_event = alive(self._sound_source) and self._sound_source:post_event(event)
end

-- Lines: 4406 to 4411
function MenuComponentPostEventInstance:stop_event()
	if alive(self._post_event) then
		self._post_event:stop()
	end

	self._post_event = false
end

-- Lines: 4413 to 4417
function MenuComponentManager:new_post_event_instance()
	local event_instance = MenuComponentPostEventInstance:new(self._sound_source)
	self._unique_event_instances = self._unique_event_instances or {}

	table.insert(self._unique_event_instances, event_instance)

	return event_instance
end

-- Lines: 4420 to 4430
function MenuComponentManager:post_event(event, unique)
	if alive(self._post_event) then
		self._post_event:stop()

		self._post_event = nil
	end

	local post_event = self._sound_source:post_event(event)

	if unique then
		self._post_event = post_event
	end

	return post_event
end

-- Lines: 4433 to 4439
function MenuComponentManager:stop_event()
	print("MenuComponentManager:stop_event()")

	if alive(self._post_event) then
		self._post_event:stop()

		self._post_event = nil
	end
end

-- Lines: 4441 to 4496
function MenuComponentManager:close()
	print("[MenuComponentManager:close]")

	for _, component in pairs(self._active_components) do
		if component.close then
			component:close()
		end
	end

	self:close_friends_gui()
	self:close_profile_gui()
	self:close_contract_gui()
	self:close_server_info_gui()
	self:close_chat_gui()
	self:close_stage_endscreen_gui()
	self:close_lootdrop_gui()
	self:close_mission_briefing_gui()
	self:close_debug_fonts_gui()
	self:kill_preplanning_map_gui()

	self._active_components = {}

	if self._resolution_changed_callback_id then
		managers.viewport:remove_resolution_changed_func(self._resolution_changed_callback_id)
	end

	if alive(self._sound_source) then
		self._sound_source:stop()
	end

	self:_destroy_controller_input()

	if self._requested_textures then
		for key, entry in pairs(self._requested_textures) do
			TextureCache:unretrieve(entry.texture_ids)
		end
	end

	self._requested_textures = {}
	self._block_texture_requests = true

	if alive(self._ws) then
		managers.gui_data:destroy_workspace(self._ws)

		self._ws = nil
	end

	if alive(self._fullscreen_ws) then
		managers.gui_data:destroy_workspace(self._fullscreen_ws)

		self._fullscreen_ws = nil
	end
end

-- Lines: 4498 to 4523
function MenuComponentManager:play_transition(run_in_pause)
	if self._transition_panel then
		self._transition_panel:parent():remove(self._transition_panel)
	end

	self._transition_panel = self._fullscreen_ws:panel():panel({
		layer = 10000,
		name = "transition_panel"
	})

	self._transition_panel:rect({
		name = "fade1",
		valign = "scale ",
		halign = "scale",
		color = Color.black
	})


	-- Lines: 4505 to 4521
	local function animate_transition(o)
		local fade1 = o:child("fade1")
		local seconds = 0.5
		local t = 0
		local dt, p = nil

		while t < seconds do
			dt = coroutine.yield()

			if dt == 0 and run_in_pause then
				dt = TimerManager:main():delta_time()
			end

			t = t + dt
			p = t / seconds

			fade1:set_alpha(1 - p)
		end
	end

	self._transition_panel:animate(animate_transition)
end

-- Lines: 4525 to 4600
function MenuComponentManager:test_camera_shutter_tech()
	if not self._tcst then
		self._tcst = managers.gui_data:create_fullscreen_16_9_workspace()
		local o = self._tcst:panel():panel({layer = 10000})
		local b = o:rect({
			valign = "scale",
			name = "black",
			halign = "scale",
			layer = 5,
			color = Color.black
		})


		-- Lines: 4535 to 4539
		local function one_frame_hide(o)
			o:hide()
			coroutine.yield()
			o:show()
		end

		b:animate(one_frame_hide)
	end

	local o = self._tcst:panel():children()[1]


	-- Lines: 4580 to 4596
	local function animate_fade(o)
		local black = o:child("black")

		over(0.5, function (p)
			black:set_alpha(1 - p)
		end)
	end

	o:stop()
	o:animate(animate_fade)
end

-- Lines: 4603 to 4624
function MenuComponentManager:create_test_gui()
	if alive(Global.test_gui) then
		managers.gui_data:destroy_workspace(Global.test_gui)

		Global.test_gui = nil
	end

	Global.test_gui = managers.gui_data:create_fullscreen_16_9_workspace()
	local panel = Global.test_gui:panel()
	local bg = panel:rect({
		layer = 1000,
		color = Color.black
	})
	local size = 48
	local x = 0

	for i = 3, 3, 1 do
		local bitmap = panel:bitmap({
			texture = "guis/dlcs/big_bank/textures/pd2/pre_planning/mezzanine_test",
			name = "bitmap",
			rotation = 360,
			render_template = "TextDistanceField",
			layer = 1001
		})

		bitmap:set_size(bitmap:texture_width() * i, bitmap:texture_height() * i)
		bitmap:set_position(x, 0)

		x = bitmap:right() + 10
	end
end

-- Lines: 4626 to 4631
function MenuComponentManager:destroy_test_gui()
	if alive(Global.test_gui) then
		managers.gui_data:destroy_workspace(Global.test_gui)

		Global.test_gui = nil
	end
end

-- Lines: 4636 to 4638
function MenuComponentManager:create_custom_safehouse_primaries(node)
	self:create_ingame_custom_safehouse_menu(node, "primaries")
end

-- Lines: 4640 to 4642
function MenuComponentManager:create_custom_safehouse_secondaries(node)
	self:create_ingame_custom_safehouse_menu(node, "secondaries")
end

-- Lines: 4645 to 4708
function MenuComponentManager:create_ingame_custom_safehouse_menu(node, category)
	if not node then
		return
	end

	category = category or "primaries"
	local crafted_category = managers.blackmarket:get_crafted_category(category) or {}
	local new_node_data = {category = category}
	local rows = tweak_data.gui.WEAPON_ROWS_PER_PAGE or 3
	local columns = tweak_data.gui.WEAPON_COLUMNS_PER_PAGE or 3
	local max_pages = tweak_data.gui.MAX_WEAPON_PAGES or 8
	local items_per_page = rows * columns
	local item_data, selected_tab = nil

	for page = 1, max_pages, 1 do
		local index = 1
		local start_i = 1 + items_per_page * (page - 1)
		item_data = {}

		for i = start_i, items_per_page * page, 1 do
			item_data[index] = i
			index = index + 1

			if crafted_category[i] and crafted_category[i].equipped then
				selected_tab = page
			end
		end

		local name_id = managers.localization:to_upper_text("bm_menu_page", {page = tostring(page)})
		local data = {
			prev_node_data = false,
			allow_buy = false,
			allow_sell = false,
			allow_preview = false,
			on_create_func_name = "populate_weapon_category_new",
			allow_modify = false,
			equip_immediately = false,
			allow_skinning = false,
			name = category,
			category = category,
			start_i = start_i,
			name_localized = name_id,
			on_create_data = item_data,
			identifier = BlackMarketGui.identifiers.weapon,
			override_slots = {
				columns,
				rows
			}
		}

		table.insert(new_node_data, data)
	end

	new_node_data.can_move_over_tabs = true
	new_node_data.selected_tab = selected_tab
	new_node_data.scroll_tab_anywhere = true
	new_node_data.topic_id = "bm_menu_" .. category
	new_node_data.topic_params = {weapon_category = managers.localization:text("bm_menu_weapons")}

	managers.menu:open_node("blackmarket_node", {new_node_data})
end

-- Lines: 4710 to 4712
function MenuComponentManager:close_custom_safehouse_primaries()
	self:close_custom_safehouse_menu("primaries")
end

-- Lines: 4714 to 4716
function MenuComponentManager:close_custom_safehouse_secondaries()
	self:close_custom_safehouse_menu("secondaries")
end

-- Lines: 4718 to 4719
function MenuComponentManager:close_custom_safehouse_menu(category)
end

-- Lines: 4721 to 4727
function MenuComponentManager:create_new_heists_gui(node)
	if not node then
		return
	end

	self._new_heists_gui = self._new_heists_gui or NewHeistsGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("new_heists", self._new_heists_gui)
end

-- Lines: 4729 to 4735
function MenuComponentManager:close_new_heists_gui()
	if self._new_heists_gui then
		self._new_heists_gui:close()

		self._new_heists_gui = nil

		self:unregister_component("new_heists")
	end
end

-- Lines: 4741 to 4748
function MenuComponentManager:create_crime_spree_contract_gui(node)
	if not node then
		return
	end

	self._crime_spree_contract_menu_comp = self._crime_spree_contract_menu_comp or CrimeSpreeContractMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crimenet_crime_spree_contract", self._crime_spree_contract_menu_comp)
	self:disable_crimenet()
end

-- Lines: 4750 to 4757
function MenuComponentManager:close_crime_spree_contract_gui(node)
	if self._crime_spree_contract_menu_comp then
		self._crime_spree_contract_menu_comp:close()

		self._crime_spree_contract_menu_comp = nil

		self:unregister_component("crimenet_crime_spree_contract")
		self:enable_crimenet()
	end
end

-- Lines: 4761 to 4767
function MenuComponentManager:create_crime_spree_missions_gui(node)
	if not node or not managers.crime_spree:is_active() then
		return
	end

	self._crime_spree_missions = self._crime_spree_missions or CrimeSpreeMissionsMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_missions", self._crime_spree_missions)
end

-- Lines: 4769 to 4775
function MenuComponentManager:close_crime_spree_missions_gui(node)
	if self._crime_spree_missions then
		self._crime_spree_missions:close()

		self._crime_spree_missions = nil

		self:unregister_component("crime_spree_missions")
	end
end

-- Lines: 4777 to 4778
function MenuComponentManager:crime_spree_missions_gui()
	return self._crime_spree_missions
end

-- Lines: 4783 to 4789
function MenuComponentManager:create_crime_spree_details_gui(node)
	if not node or not managers.crime_spree:is_active() then
		return
	end

	self._crime_spree_details = self._crime_spree_details or CrimeSpreeDetailsMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_details", self._crime_spree_details)
end

-- Lines: 4791 to 4797
function MenuComponentManager:close_crime_spree_details_gui(node)
	if self._crime_spree_details then
		self._crime_spree_details:close()

		self._crime_spree_details = nil

		self:unregister_component("crime_spree_details")
	end
end

-- Lines: 4799 to 4806
function MenuComponentManager:refresh_crime_spree_details_gui()
	local node = nil

	if self._crime_spree_details then
		node = self._crime_spree_details._node
	end

	self:close_crime_spree_details_gui(node)
	self:create_crime_spree_details_gui(node)
end

-- Lines: 4808 to 4809
function MenuComponentManager:crime_spree_details_gui()
	return self._crime_spree_details
end

-- Lines: 4814 to 4820
function MenuComponentManager:create_crime_spree_modifiers_gui(node)
	if not node then
		return
	end

	self._crime_spree_modifiers = self._crime_spree_modifiers or CrimeSpreeModifiersMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_modifiers", self._crime_spree_modifiers)
end

-- Lines: 4822 to 4828
function MenuComponentManager:close_crime_spree_modifiers_gui(node)
	if self._crime_spree_modifiers then
		self._crime_spree_modifiers:close()

		self._crime_spree_modifiers = nil

		self:unregister_component("crime_spree_modifiers")
	end
end

-- Lines: 4830 to 4831
function MenuComponentManager:crime_spree_modifiers()
	return self._crime_spree_modifiers
end

-- Lines: 4836 to 4838
function MenuComponentManager:check_crime_spree_forced_modifiers(node)
	managers.crime_spree:check_forced_modifiers()
end

-- Lines: 4840 to 4847
function MenuComponentManager:create_crime_spree_forced_modifiers_gui(node)
	if not node then
		return
	end

	self._crime_spree_forced_modifiers = self._crime_spree_forced_modifiers or CrimeSpreeForcedModifiersMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_forced_modifiers", self._crime_spree_forced_modifiers)
end

-- Lines: 4849 to 4855
function MenuComponentManager:close_crime_spree_forced_modifiers_gui(node)
	if self._crime_spree_forced_modifiers then
		self._crime_spree_forced_modifiers:close()

		self._crime_spree_forced_modifiers = nil

		self:unregister_component("crime_spree_forced_modifiers")
	end
end

-- Lines: 4857 to 4858
function MenuComponentManager:crime_spree_forced_modifiers()
	return self._crime_spree_forced_modifiers
end

-- Lines: 4863 to 4869
function MenuComponentManager:create_crime_spree_rewards_gui(node)
	if not node then
		return
	end

	self._crime_spree_rewards = self._crime_spree_rewards or CrimeSpreeRewardsMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_rewards", self._crime_spree_rewards)
end

-- Lines: 4871 to 4877
function MenuComponentManager:close_crime_spree_rewards_gui(node)
	if self._crime_spree_rewards then
		self._crime_spree_rewards:close()

		self._crime_spree_rewards = nil

		self:unregister_component("crime_spree_rewards")
	end
end

-- Lines: 4881 to 4887
function MenuComponentManager:create_crime_spree_mission_end_gui(node)
	if not node or not managers.crime_spree:is_active() then
		return
	end

	self._crime_spree_mission_end = self._crime_spree_mission_end or CrimeSpreeMissionEndOptions:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_mission_end", self._crime_spree_mission_end)
end

-- Lines: 4889 to 4895
function MenuComponentManager:close_crime_spree_mission_end_gui(node)
	if self._crime_spree_mission_end then
		self._crime_spree_mission_end:close()

		self._crime_spree_mission_end = nil

		self:unregister_component("crime_spree_mission_end")
	end
end

-- Lines: 4897 to 4898
function MenuComponentManager:crime_spree_mission_end_gui()
	return self._crime_spree_mission_end
end

-- Lines: 4912 to 4913
function MenuComponentManager:create_debug_quicklaunch_gui(node)
end

-- Lines: 4922 to 4923
function MenuComponentManager:close_debug_quicklaunch_gui()
end

-- Lines: 4928 to 4934
function MenuComponentManager:create_crew_management_gui(node)
	if not node then
		return
	end

	self._crew_management_gui = self._crew_management_gui or CrewManagementGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crew_management", self._crew_management_gui)
end

-- Lines: 4936 to 4942
function MenuComponentManager:close_crew_management_gui()
	if self._crew_management_gui then
		self._crew_management_gui:close()

		self._crew_management_gui = nil

		self:unregister_component("crew_management")
	end
end

-- Lines: 5008 to 5012
function MenuComponentManager:create_raid_menu_gui(node)
	self:close_raid_menu_gui()

	self._raid_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid")

	self:register_component("raid_menu", self._raid_menu_gui)
end

-- Lines: 5014 to 5020
function MenuComponentManager:close_raid_menu_gui()
	if self._raid_menu_gui then
		self._raid_menu_gui:close()

		self._raid_menu_gui = nil

		self:unregister_component("raid_menu")
	end
end

-- Lines: 5022 to 5023
function MenuComponentManager:raid_menu_gui()
	return self._raid_menu_gui
end

-- Lines: 5028 to 5032
function MenuComponentManager:create_raid_weapons_menu_gui(node)
	self:close_raid_weapons_menu_gui()

	self._raid_weapons_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid_weapons")

	self:register_component("raid_weapons_menu", self._raid_weapons_menu_gui)
end

-- Lines: 5034 to 5040
function MenuComponentManager:close_raid_weapons_menu_gui()
	if self._raid_weapons_menu_gui then
		self._raid_weapons_menu_gui:close()

		self._raid_weapons_menu_gui = nil

		self:unregister_component("raid_weapons_menu")
	end
end

-- Lines: 5042 to 5043
function MenuComponentManager:raid_weapons_menu_gui()
	return self._raid_weapons_menu_gui
end

-- Lines: 5048 to 5052
function MenuComponentManager:create_raid_preorder_menu_gui(node)
	self:close_raid_preorder_menu_gui()

	self._raid_preorder_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid_preorder")

	self:register_component("raid_preorder_menu", self._raid_preorder_menu_gui)
end

-- Lines: 5054 to 5060
function MenuComponentManager:close_raid_preorder_menu_gui()
	if self._raid_preorder_menu_gui then
		self._raid_preorder_menu_gui:close()

		self._raid_preorder_menu_gui = nil

		self:unregister_component("raid_preorder_menu")
	end
end

-- Lines: 5062 to 5063
function MenuComponentManager:raid_preorder_menu_gui()
	return self._raid_preorder_menu_gui
end

-- Lines: 5068 to 5072
function MenuComponentManager:create_raid_special_menu_gui(node)
	self:close_raid_special_menu_gui()

	self._raid_special_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid_special")

	self:register_component("raid_special_menu", self._raid_special_menu_gui)
end

-- Lines: 5074 to 5080
function MenuComponentManager:close_raid_special_menu_gui()
	if self._raid_special_menu_gui then
		self._raid_special_menu_gui:close()

		self._raid_special_menu_gui = nil

		self:unregister_component("raid_special_menu")
	end
end

-- Lines: 5082 to 5083
function MenuComponentManager:raid_special_menu_gui()
	return self._raid_special_menu_gui
end

-- Lines: 5088 to 5092
function MenuComponentManager:create_raid_weapon_preview_gui(node)
	self:close_raid_weapon_preview_gui()

	self._raid_weapon_preview_gui = PromotionalWeaponPreviewGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("raid_weapon_preview", self._raid_weapon_preview_gui)
end

-- Lines: 5094 to 5100
function MenuComponentManager:close_raid_weapon_preview_gui()
	if self._raid_weapon_preview_gui then
		self._raid_weapon_preview_gui:close()

		self._raid_weapon_preview_gui = nil

		self:unregister_component("raid_weapon_preview")
	end
end

-- Lines: 5102 to 5103
function MenuComponentManager:raid_weapon_preview_gui()
	return self._raid_weapon_preview_gui
end

