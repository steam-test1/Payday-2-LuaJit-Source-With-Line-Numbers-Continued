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
require("lib/managers/menu/AchievementListGui")
require("lib/managers/menu/StoryMissionsGui")
require("lib/managers/menu/CrimeNetSidebarGui")
require("lib/managers/menu/PromotionalMenuGui")
require("lib/managers/menu/PromotionalWeaponPreviewGui")
require("lib/managers/menu/RaidMenuGui")
require("lib/managers/menu/ContractBrokerGui")

MenuComponentManager = MenuComponentManager or class()

-- Lines: 96 to 246
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
		achievement_list = self:create_component_callback("AchievementListGui", "achievement_list"),
		story_missions = {
			create = callback(self, self, "create_story_missions_gui"),
			close = callback(self, self, "close_story_missions_gui")
		},
		crimenet_sidebar = {
			create = callback(self, self, "create_crimenet_sidebar_gui"),
			close = callback(self, self, "close_crimenet_sidebar_gui")
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
		},
		contract_broker = {
			create = callback(self, self, "create_contract_broker_gui"),
			close = callback(self, self, "close_contract_broker_gui")
		}
	}
	self._alive_components = {}

	if _G.IS_VR and managers.menu._is_start_menu then
		local vr_bg = self._fullscreen_ws:panel():bitmap({
			texture = "guis/dlcs/vr/textures/pd2/bg",
			name = "vr_bg",
			layer = -2
		})
		local h = self._fullscreen_ws:panel():h()
		local dh = h / vr_bg:texture_height()

		vr_bg:set_size(vr_bg:texture_width() * dh, h)
	end
end

-- Lines: 248 to 249
function MenuComponentManager:save(data)
end

-- Lines: 251 to 253
function MenuComponentManager:load(data)
	self:on_whisper_mode_changed()
end

-- Lines: 259 to 274
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

-- Lines: 276 to 283
function MenuComponentManager:unregister_component(id)
	for i, comp_data in ipairs(self._alive_components) do
		if comp_data.id == id then
			table.remove(self._alive_components, i)

			return true
		end
	end

	return false
end

-- Lines: 286 to 292
function MenuComponentManager:run_on_all_live_components(func, ...)
	for idx, comp_data in ipairs(self._alive_components) do
		if comp_data.component[func] then
			comp_data.component[func](comp_data.component, ...)
		end
	end
end

-- Lines: 294 to 303
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

-- Lines: 308 to 310
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

-- Lines: 313 to 321
function MenuComponentManager:_generated_create(params, node)
	if not node then
		return
	end

	local class_name, component_name = unpack(params)
	self._generated[component_name] = self._generated[component_name] or _G[class_name]:new(self._ws, self._fullscreen_ws, node)

	self:register_component(component_name, self._generated[component_name])
end

-- Lines: 323 to 330
function MenuComponentManager:_generated_close(component_name)
	local current = self._generated[component_name]

	if current then
		current:close()

		self._generated[component_name] = nil

		self:unregister_component(component_name)
	end
end

-- Lines: 334 to 343
function MenuComponentManager:get_controller_input_bool(button)
	if not managers.menu or not managers.menu:active_menu() then
		return
	end

	local controller = managers.menu:active_menu().input:get_controller_class()

	if managers.menu:active_menu().input:get_accept_input() then
		return controller:get_input_bool(button)
	end
end

-- Lines: 345 to 361
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

-- Lines: 363 to 377
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

-- Lines: 379 to 398
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

-- Lines: 400 to 401
function MenuComponentManager:saferect_ws()
	return self._ws
end

-- Lines: 404 to 405
function MenuComponentManager:fullscreen_ws()
	return self._fullscreen_ws
end

-- Lines: 408 to 415
function MenuComponentManager:resolution_changed()
	managers.gui_data:layout_workspace(self._ws)
	managers.gui_data:layout_fullscreen_16_9_workspace(self._fullscreen_ws)

	if self._tcst then
		managers.gui_data:layout_fullscreen_16_9_workspace(self._tcst)
	end
end

-- Lines: 417 to 423
function MenuComponentManager:_axis_move(o, axis_name, axis_vector, controller)
	if axis_name == Idstring("left") then
		mvector3.set(self._left_axis_vector, axis_vector)
	elseif axis_name == Idstring("right") then
		mvector3.set(self._right_axis_vector, axis_vector)
	end
end

-- Lines: 425 to 453
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

-- Lines: 457 to 499
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

-- Lines: 503 to 507
function MenuComponentManager:on_job_updated()
	if self._contract_gui then
		self._contract_gui:refresh()
	end
end

-- Lines: 519 to 603
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

-- Lines: 605 to 613
function MenuComponentManager:get_left_controller_axis()
	if managers.menu:is_pc_controller() or not self._left_axis_vector then
		return 0, 0
	end

	local x = mvector3.x(self._left_axis_vector)
	local y = mvector3.y(self._left_axis_vector)

	return x, y
end

-- Lines: 616 to 624
function MenuComponentManager:get_right_controller_axis()
	if managers.menu:is_pc_controller() or not self._right_axis_vector then
		return 0, 0
	end

	local x = mvector3.x(self._right_axis_vector)
	local y = mvector3.y(self._right_axis_vector)

	return x, y
end

-- Lines: 629 to 639
function MenuComponentManager:accept_input(accept)
	if not self._weapon_text_box then
		return
	end

	if not accept then
		self._weapon_text_box:release_scroll_bar()
	end

	self:run_on_all_live_components("accept_input", accept)
end

-- Lines: 642 to 710
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

	if self._crimenet_gui and self._crimenet_gui:enabled() and self._crimenet_gui:input_focus() then
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

-- Lines: 712 to 747
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

-- Lines: 749 to 784
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

-- Lines: 788 to 846
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

-- Lines: 848 to 906
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

-- Lines: 908 to 966
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

-- Lines: 969 to 1027
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

-- Lines: 1030 to 1105
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

-- Lines: 1107 to 1181
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

-- Lines: 1183 to 1258
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

-- Lines: 1260 to 1298
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

-- Lines: 1300 to 1375
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

-- Lines: 1377 to 1390
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

-- Lines: 1393 to 1717
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

	if self._profile_gui then
		if self._profile_gui:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._profile_gui:check_minimize(x, y) then
				local minimized_data = {
					text = "PROFILE",
					help_text = "MAXIMIZE PROFILE WINDOW"
				}

				self._profile_gui:set_minimized(true, minimized_data)

				return true
			end

			if self._profile_gui:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._profile_gui:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._profile_gui:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._contract_gui then
		if self._contract_gui:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._contract_gui:check_minimize(x, y) then
				local minimized_data = {
					text = "CONTRACT",
					help_text = "MAXIMIZE CONTRACT WINDOW"
				}

				self._contract_gui:set_minimized(true, minimized_data)

				return true
			end

			if self._contract_gui:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._contract_gui:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._contract_gui:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._server_info_gui then
		if self._server_info_gui:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._server_info_gui:check_minimize(x, y) then
				local minimized_data = {
					text = "SERVER INFO",
					help_text = "MAXIMIZE SERVER INFO WINDOW"
				}

				self._server_info_gui:set_minimized(true, minimized_data)

				return true
			end

			if self._server_info_gui:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._server_info_gui:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._server_info_gui:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._lobby_profile_gui then
		if self._lobby_profile_gui:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._lobby_profile_gui:check_minimize(x, y) then
				return true
			end

			if self._lobby_profile_gui:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._lobby_profile_gui:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._lobby_profile_gui:mouse_wheel_up(x, y) then
			return true
		end
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

	if self._view_character_profile_gui then
		if self._view_character_profile_gui:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._view_character_profile_gui:check_minimize(x, y) then
				return true
			end

			if self._view_character_profile_gui:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._view_character_profile_gui:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._view_character_profile_gui:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._test_profile1 then
		if self._test_profile1:check_grab_scroll_bar(x, y) then
			return true
		end

		if self._test_profile2:check_grab_scroll_bar(x, y) then
			return true
		end

		if self._test_profile3:check_grab_scroll_bar(x, y) then
			return true
		end

		if self._test_profile4:check_grab_scroll_bar(x, y) then
			return true
		end
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

	if self._friends_book then
		if self._friends_book:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._friends_book:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._friends_book:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._friends_book:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._debug_strings_book then
		if self._debug_strings_book:mouse_pressed(button, x, y) then
			return true
		end

		if button == Idstring("0") then
			if self._debug_strings_book:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._debug_strings_book:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._debug_strings_book:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._weapon_text_box then
		if button == Idstring("0") then
			if self._weapon_text_box:check_close(x, y) then
				self:close_weapon_box()

				return true
			end

			if self._weapon_text_box:check_minimize(x, y) then
				self._weapon_text_box:set_visible(false)

				self._weapon_text_minimized_id = self:add_minimized({
					text = "WEAPON",
					callback = callback(self, self, "_maximize_weapon_box")
				})

				return true
			end

			if self._weapon_text_box:check_grab_scroll_bar(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel down") then
			if self._weapon_text_box:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._weapon_text_box:mouse_wheel_up(x, y) then
			return true
		end
	end

	if self._player_inventory_gui and self._player_inventory_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._crimenet_contract_gui then
		if button == Idstring("mouse wheel down") then
			if self._crimenet_contract_gui:mouse_wheel_down(x, y) then
				return true
			end
		elseif button == Idstring("mouse wheel up") and self._crimenet_contract_gui:mouse_wheel_up(x, y) then
			return true
		end
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

-- Lines: 1719 to 1730
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

-- Lines: 1732 to 1743
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

-- Lines: 1745 to 1845
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

	if self._test_profile1 then
		if self._test_profile1:release_scroll_bar() then
			return true
		end

		if self._test_profile2:release_scroll_bar() then
			return true
		end

		if self._test_profile3:release_scroll_bar() then
			return true
		end

		if self._test_profile4:release_scroll_bar() then
			return true
		end
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

-- Lines: 1847 to 2100
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

-- Lines: 2104 to 2108
function MenuComponentManager:peer_outfit_updated(peer_id)
	if self._contract_gui then
		self._contract_gui:refresh()
	end
end

-- Lines: 2110 to 2120
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

-- Lines: 2123 to 2128
function MenuComponentManager:_create_crimenet_contract_gui(node)
	self:close_crimenet_contract_gui()

	self._crimenet_contract_gui = CrimeNetContractGui:new(self._ws, self._fullscreen_ws, node)

	self:disable_crimenet()
end

-- Lines: 2130 to 2137
function MenuComponentManager:close_crimenet_contract_gui(...)
	if self._crimenet_contract_gui then
		self._crimenet_contract_gui:close()

		self._crimenet_contract_gui = nil

		self:enable_crimenet()
	end
end

-- Lines: 2139 to 2143
function MenuComponentManager:set_crimenet_contract_difficulty_id(difficulty_id)
	if self._crimenet_contract_gui then
		self._crimenet_contract_gui:set_difficulty_id(difficulty_id)
	end
end

-- Lines: 2148 to 2153
function MenuComponentManager:_create_crimenet_filters_gui(node)
	self:close_crimenet_filters_gui()

	self._crimenet_filters_gui = CrimeNetFiltersGui:new(self._ws, self._fullscreen_ws, node)

	self:disable_crimenet()
end

-- Lines: 2155 to 2162
function MenuComponentManager:close_crimenet_filters_gui(...)
	if self._crimenet_filters_gui then
		self._crimenet_filters_gui:close()

		self._crimenet_filters_gui = nil

		self:enable_crimenet()
	end
end

-- Lines: 2166 to 2171
function MenuComponentManager:_create_crimenet_casino_gui(node)
	self:close_crimenet_casino_gui()

	self._crimenet_casino_gui = CrimeNetCasinoGui:new(self._ws, self._fullscreen_ws, node)

	self:disable_crimenet()
end

-- Lines: 2173 to 2180
function MenuComponentManager:close_crimenet_casino_gui(...)
	if self._crimenet_casino_gui then
		self._crimenet_casino_gui:close()

		self._crimenet_casino_gui = nil

		self:enable_crimenet()
	end
end

-- Lines: 2182 to 2186
function MenuComponentManager:can_afford()
	if self._crimenet_casino_gui then
		self._crimenet_casino_gui:can_afford()
	end
end

-- Lines: 2189 to 2193
function MenuComponentManager:_create_crimenet_gui(...)
	if not self._crimenet_gui then
		self._crimenet_gui = CrimeNetGui:new(self._ws, self._fullscreen_ws, ...)
	end
end

-- Lines: 2195 to 2200
function MenuComponentManager:start_crimenet_job()
	self:enable_crimenet()

	if self._crimenet_gui then
		self._crimenet_gui:start_job()
	end
end

-- Lines: 2202 to 2204
function MenuComponentManager:enable_crimenet()
	self._set_crimenet_enabled = self._set_crimenet_enabled == nil and true
end

-- Lines: 2206 to 2208
function MenuComponentManager:disable_crimenet()
	self._set_crimenet_enabled = self._set_crimenet_enabled == nil and false
end

-- Lines: 2210 to 2214
function MenuComponentManager:update_crimenet_gui(t, dt)
	if self._crimenet_gui then
		self._crimenet_gui:update(t, dt)
	end
end

-- Lines: 2216 to 2218
function MenuComponentManager:update_crimenet_job(...)
	self._crimenet_gui:update_job(...)
end

-- Lines: 2220 to 2222
function MenuComponentManager:feed_crimenet_job_timer(...)
	self._crimenet_gui:feed_timer(...)
end

-- Lines: 2224 to 2228
function MenuComponentManager:update_crimenet_server_job(...)
	if self._crimenet_gui then
		self._crimenet_gui:update_server_job(...)
	end
end

-- Lines: 2230 to 2232
function MenuComponentManager:feed_crimenet_server_timer(...)
	self._crimenet_gui:feed_server_timer(...)
end

-- Lines: 2234 to 2238
function MenuComponentManager:criment_goto_lobby(...)
	if self._crimenet_gui then
		self._crimenet_gui:goto_lobby(...)
	end
end

-- Lines: 2240 to 2244
function MenuComponentManager:set_crimenet_players_online(amount)
	if self._crimenet_gui then
		self._crimenet_gui:set_players_online(amount)
	end
end

-- Lines: 2246 to 2250
function MenuComponentManager:add_crimenet_gui_preset_job(id)
	if self._crimenet_gui then
		self._crimenet_gui:add_preset_job(id)
	end
end

-- Lines: 2252 to 2256
function MenuComponentManager:add_crimenet_server_job(...)
	if self._crimenet_gui then
		self._crimenet_gui:add_server_job(...)
	end
end

-- Lines: 2258 to 2262
function MenuComponentManager:remove_crimenet_gui_job(id)
	if self._crimenet_gui then
		self._crimenet_gui:remove_job(id)
	end
end

-- Lines: 2264 to 2268
function MenuComponentManager:set_crimenet_gui_getting_hacked(hacked)
	if self._crimenet_gui then
		self._crimenet_gui:set_getting_hacked(hacked)
	end
end

-- Lines: 2270 to 2271
function MenuComponentManager:has_crimenet_gui()
	return not not self._crimenet_gui
end

-- Lines: 2274 to 2275
function MenuComponentManager:has_blackmarket_gui()
	return not not self._blackmarket_gui
end

-- Lines: 2279 to 2284
function MenuComponentManager:close_crimenet_gui()
	if self._crimenet_gui then
		self._crimenet_gui:close()

		self._crimenet_gui = nil
	end
end

-- Lines: 2287 to 2308
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

-- Lines: 2320 to 2329
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

-- Lines: 2332 to 2345
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

-- Lines: 2347 to 2360
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

-- Lines: 2362 to 2375
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

-- Lines: 2377 to 2390
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

-- Lines: 2392 to 2421
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

-- Lines: 2423 to 2446
function MenuComponentManager:add_game_chat()
	if SystemInfo:platform() == Idstring("WIN32") then
		self._game_chat_gui = ChatGui:new(self._ws)

		if self._game_chat_params then
			self._game_chat_gui:set_params(self._game_chat_params)

			self._game_chat_params = nil
		end
	end
end

-- Lines: 2448 to 2455
function MenuComponentManager:set_max_lines_game_chat(max_lines)
	if self._game_chat_gui then
		self._game_chat_gui:set_max_lines(max_lines)
	else
		self._game_chat_params = self._game_chat_params or {}
		self._game_chat_params.max_lines = max_lines
	end
end

-- Lines: 2457 to 2465
function MenuComponentManager:pre_set_game_chat_leftbottom(from_left, from_bottom)
	if self._game_chat_gui then
		self._game_chat_gui:set_leftbottom(from_left, from_bottom)
	else
		self._game_chat_params = self._game_chat_params or {}
		self._game_chat_params.left = from_left
		self._game_chat_params.bottom = from_bottom
	end
end

-- Lines: 2467 to 2476
function MenuComponentManager:remove_game_chat()
	if not self._chat_book then
		return
	end

	self._chat_book:remove_page("Game")
end

-- Lines: 2478 to 2482
function MenuComponentManager:hide_lobby_chat_gui()
	if self._game_chat_gui and self._lobby_chat_gui_active then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2484 to 2488
function MenuComponentManager:hide_crimenet_chat_gui()
	if self._game_chat_gui and self._crimenet_chat_gui_active then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2490 to 2494
function MenuComponentManager:hide_preplanning_chat_gui()
	if self._game_chat_gui and self._preplanning_chat_gui_active then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2496 to 2500
function MenuComponentManager:hide_game_chat_gui()
	if self._game_chat_gui then
		self._game_chat_gui:hide()
	end
end

-- Lines: 2502 to 2506
function MenuComponentManager:show_game_chat_gui()
	if self._game_chat_gui then
		self._game_chat_gui:show()
	end
end

-- Lines: 2508 to 2509
function MenuComponentManager:input_focut_game_chat_gui()
	return self._game_chat_gui and self._game_chat_gui:input_focus() == true
end

-- Lines: 2512 to 2516
function MenuComponentManager:_disable_chat_gui()
	if self._game_chat_gui and not self._lobby_chat_gui_active and not self._crimenet_chat_gui_active and not self._preplanning_chat_gui_active then
		self._game_chat_gui:set_enabled(false)
	end
end

-- Lines: 2518 to 2533
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

-- Lines: 2535 to 2539
function MenuComponentManager:set_crimenet_chat_gui(state)
	if self._game_chat_gui then
		self._game_chat_gui:set_crimenet_chat(state)
	end
end

-- Lines: 2542 to 2551
function MenuComponentManager:_create_friends_gui()
	if SystemInfo:platform() == Idstring("WIN32") then
		if self._friends_book then
			self._friends_book:set_enabled(true)

			return
		end

		self:create_friends_gui()
	end
end

-- Lines: 2553 to 2565
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

-- Lines: 2567 to 2571
function MenuComponentManager:_update_friends_gui()
	if self._friends_gui then
		self._friends_gui:update_friends()
	end
end

-- Lines: 2573 to 2577
function MenuComponentManager:_disable_friends_gui()
	if self._friends_book then
		self._friends_book:set_enabled(false)
	end
end

-- Lines: 2580 to 2589
function MenuComponentManager:close_friends_gui()
	if self._friends_gui then
		self._friends_gui = nil
	end

	if self._friends_book then
		self._friends_book:close()

		self._friends_book = nil
	end
end

-- Lines: 2593 to 2600
function MenuComponentManager:_contract_gui_class()
	if managers.crime_spree:is_active() then
		return CrimeSpreeContractBoxGui
	else
		return ContractBoxGui
	end

	return ContractBoxGui
end

-- Lines: 2603 to 2610
function MenuComponentManager:_create_contract_gui()
	if self._contract_gui then
		self._contract_gui:set_enabled(true)

		return
	end

	self:create_contract_gui()
end

-- Lines: 2612 to 2620
function MenuComponentManager:create_contract_gui()
	self:close_contract_gui()

	self._contract_gui = self:_contract_gui_class():new(self._ws, self._fullscreen_ws)
	local peers_state = managers.menu:get_all_peers_state() or {}

	for i = 1, tweak_data.max_players, 1 do
		self._contract_gui:update_character_menu_state(i, peers_state[i])
	end
end

-- Lines: 2622 to 2626
function MenuComponentManager:update_contract_character(peer_id)
	if self._contract_gui then
		self._contract_gui:update_character(peer_id)
	end
end

-- Lines: 2628 to 2633
function MenuComponentManager:update_contract_character_menu_state(peer_id, state)
	if self._contract_gui then
		self._contract_gui:update_character_menu_state(peer_id, state)
		self._contract_gui:update_bg_state(peer_id, state)
	end
end

-- Lines: 2635 to 2641
function MenuComponentManager:show_contract_character(state)
	if self._contract_gui then
		for i = 1, tweak_data.max_players, 1 do
			self._contract_gui:set_character_panel_alpha(i, state and 1 or 0.4)
		end
	end
end

-- Lines: 2643 to 2645
function MenuComponentManager:_disable_contract_gui()
	self:close_contract_gui()
end

-- Lines: 2647 to 2658
function MenuComponentManager:close_contract_gui()
	if self._contract_gui then
		self._contract_gui:close()

		self._contract_gui = nil

		if _G.IS_VR then
			managers.menu_scene:clear_character_text_panels()
		end
	end
end

-- Lines: 2661 to 2663
function MenuComponentManager:_create_skilltree_new_gui(node)
	self:create_skilltree_new_gui(node)
end

-- Lines: 2664 to 2669
function MenuComponentManager:create_skilltree_new_gui(node)
	self:close_skilltree_new_gui()

	self._skilltree_gui = NewSkillTreeGui:new(self._ws, self._fullscreen_ws, node)
	self._new_skilltree_gui_active = true

	self:enable_skilltree_gui()
end

-- Lines: 2671 to 2677
function MenuComponentManager:close_skilltree_new_gui()
	if self._skilltree_gui and not self._old_skilltree_gui_active then
		self._skilltree_gui:close()

		self._skilltree_gui = nil
		self._new_skilltree_gui_active = nil
	end
end

-- Lines: 2686 to 2688
function MenuComponentManager:_create_skilltree_gui(node)
	self:create_skilltree_gui(node)
end

-- Lines: 2689 to 2694
function MenuComponentManager:create_skilltree_gui(node)
	self:close_skilltree_gui()

	self._skilltree_gui = SkillTreeGui:new(self._ws, self._fullscreen_ws, node)
	self._old_skilltree_gui_active = true

	self:enable_skilltree_gui()
end

-- Lines: 2696 to 2702
function MenuComponentManager:close_skilltree_gui()
	if self._skilltree_gui and not self._new_skilltree_gui_active then
		self._skilltree_gui:close()

		self._skilltree_gui = nil
		self._old_skilltree_gui_active = nil
	end
end

-- Lines: 2704 to 2708
function MenuComponentManager:enable_skilltree_gui()
	if self._skilltree_gui then
		self._skilltree_gui:enable()
	end
end

-- Lines: 2710 to 2714
function MenuComponentManager:disable_skilltree_gui()
	if self._skilltree_gui then
		self._skilltree_gui:disable()
	end
end

-- Lines: 2716 to 2720
function MenuComponentManager:on_tier_unlocked(...)
	if self._skilltree_gui then
		self._skilltree_gui:on_tier_unlocked(...)
	end
end

-- Lines: 2722 to 2726
function MenuComponentManager:on_points_spent(...)
	if self._skilltree_gui then
		self._skilltree_gui:on_points_spent(...)
	end
end

-- Lines: 2728 to 2732
function MenuComponentManager:on_skilltree_reset(...)
	if self._skilltree_gui then
		self._skilltree_gui:on_skilltree_reset(...)
	end
end

-- Lines: 2734 to 2736
function MenuComponentManager:_create_infamytree_gui()
	self:create_infamytree_gui()
end

-- Lines: 2737 to 2740
function MenuComponentManager:create_infamytree_gui(node)
	self:close_infamytree_gui()

	self._infamytree_gui = InfamyTreeGui:new(self._ws, self._fullscreen_ws, node)
end

-- Lines: 2742 to 2747
function MenuComponentManager:close_infamytree_gui()
	if self._infamytree_gui then
		self._infamytree_gui:close()

		self._infamytree_gui = nil
	end
end

-- Lines: 2750 to 2752
function MenuComponentManager:_create_inventory_list_gui(node)
	self:create_inventory_list_gui(node)
end

-- Lines: 2754 to 2757
function MenuComponentManager:create_inventory_list_gui(node)
	self:close_inventory_list_gui()

	self._inventory_list_gui = InventoryList:new(self._ws, self._fullscreen_ws, node)
end

-- Lines: 2759 to 2764
function MenuComponentManager:close_inventory_list_gui()
	if self._inventory_list_gui then
		self._inventory_list_gui:close()

		self._inventory_list_gui = nil
	end
end

-- Lines: 2767 to 2769
function MenuComponentManager:_create_blackmarket_gui(node)
	self:create_blackmarket_gui(node)
end

-- Lines: 2770 to 2781
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

-- Lines: 2783 to 2787
function MenuComponentManager:set_blackmarket_tab_positions()
	if self._blackmarket_gui then
		self._blackmarket_gui:set_tab_positions()
	end
end

-- Lines: 2789 to 2793
function MenuComponentManager:reload_blackmarket_gui()
	if self._blackmarket_gui and not self._blackmarket_gui:in_setup() then
		self._blackmarket_gui:reload()
	end
end

-- Lines: 2795 to 2800
function MenuComponentManager:close_blackmarket_gui()
	if self._blackmarket_gui then
		self._blackmarket_gui:close()

		self._blackmarket_gui = nil
	end
end

-- Lines: 2802 to 2806
function MenuComponentManager:set_blackmarket_enabled(enabled)
	if self._blackmarket_gui then
		self._blackmarket_gui:set_enabled(enabled)
	end
end

-- Lines: 2808 to 2810
function MenuComponentManager:set_blackmarket_disable_fetching(disabled)
	self._blackmarket_disable_fetching = disabled
end

-- Lines: 2812 to 2813
function MenuComponentManager:blackmarket_fetching_disable()
	return self._blackmarket_disable_fetching
end

-- Lines: 2816 to 2820
function MenuComponentManager:hide_blackmarket_gui()
	if self._blackmarket_gui then
		self._blackmarket_gui:hide()
	end
end

-- Lines: 2822 to 2826
function MenuComponentManager:show_blackmarket_gui()
	if self._blackmarket_gui then
		self._blackmarket_gui:show()
	end
end

-- Lines: 2828 to 2832
function MenuComponentManager:get_bonus_stats_blackmarket_gui(cosmetic_id, weapon_id, bonus)
	if self._blackmarket_gui then
		return self._blackmarket_gui:get_bonus_stats(cosmetic_id, weapon_id, bonus)
	end
end

-- Lines: 2836 to 2837
function MenuComponentManager:custom_safehouse_gui()
	return self._custom_safehouse_gui
end

-- Lines: 2840 to 2846
function MenuComponentManager:create_custom_safehouse_gui(node)
	if not node then
		return
	end

	self._custom_safehouse_gui = self._custom_safehouse_gui or CustomSafehouseGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("custom_safehouse_gui", self._custom_safehouse_gui)
end

-- Lines: 2848 to 2854
function MenuComponentManager:close_custom_safehouse_gui()
	if self._custom_safehouse_gui then
		self._custom_safehouse_gui:close()

		self._custom_safehouse_gui = nil

		self:unregister_component("custom_safehouse_gui")
	end
end

-- Lines: 2856 to 2863
function MenuComponentManager:disable_custom_safehouse_input(node)
	if not self._custom_safehouse_gui then
		return
	end

	self._custom_safehouse_page = self._custom_safehouse_gui._active_page
	self._custom_safehouse_gui._selected_page = nil
end

-- Lines: 2865 to 2871
function MenuComponentManager:enable_custom_safehouse_input()
	if not self._custom_safehouse_gui then
		return
	end

	self._custom_safehouse_gui:set_active_page(self._custom_safehouse_page or 1)
end

-- Lines: 2876 to 2877
function MenuComponentManager:mutators_list_gui()
	return self._mutators_list_gui
end

-- Lines: 2880 to 2886
function MenuComponentManager:create_mutators_list_gui(node)
	if not node then
		return
	end

	self._mutators_list_gui = self._mutators_list_gui or MutatorsListGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("mutators_list_gui", self._mutators_list_gui)
end

-- Lines: 2888 to 2894
function MenuComponentManager:close_mutators_list_gui()
	if self._mutators_list_gui then
		self._mutators_list_gui:close()

		self._mutators_list_gui = nil

		self:unregister_component("mutators_list_gui")
	end
end

-- Lines: 2898 to 2906
function MenuComponentManager:_create_server_info_gui()
	if self._server_info_gui then
		self:close_server_info_gui()
	end

	self:create_server_info_gui()
end

-- Lines: 2908 to 2912
function MenuComponentManager:create_server_info_gui()
	self:close_server_info_gui()

	self._server_info_gui = ServerStatusBoxGui:new(self._ws)

	self._server_info_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 2914 to 2918
function MenuComponentManager:_disable_server_info_gui()
	if self._server_info_gui then
		self._server_info_gui:set_enabled(false)
	end
end

-- Lines: 2920 to 2925
function MenuComponentManager:close_server_info_gui()
	if self._server_info_gui then
		self._server_info_gui:close()

		self._server_info_gui = nil
	end
end

-- Lines: 2927 to 2931
function MenuComponentManager:set_server_info_state(state)
	if self._server_info_gui then
		self._server_info_gui:set_server_info_state(state)
	end
end

-- Lines: 2934 to 2936
function MenuComponentManager:_create_mission_briefing_gui(node)
	self:create_mission_briefing_gui(node)
end

-- Lines: 2938 to 2954
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

-- Lines: 2956 to 2958
function MenuComponentManager:_hide_mission_briefing_gui()
	self:hide_mission_briefing_gui()
end

-- Lines: 2960 to 2964
function MenuComponentManager:hide_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:hide()
	end
end

-- Lines: 2966 to 2970
function MenuComponentManager:show_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:show()
	end
end

-- Lines: 2972 to 2982
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

-- Lines: 2983 to 2990
function MenuComponentManager:update_mission_briefing_tab_positions()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:update_tab_positions()

		self._mission_briefing_update_tab_wanted = nil
	else
		self._mission_briefing_update_tab_wanted = true
	end
end

-- Lines: 2992 to 3001
function MenuComponentManager:on_whisper_mode_changed()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:on_whisper_mode_changed()

		local hud = managers.hud:get_mission_briefing_hud()

		if hud then
			hud:on_whisper_mode_changed()
		end
	end
end

-- Lines: 3003 to 3007
function MenuComponentManager:set_mission_briefing_description(text_id)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:set_description_text_id(text_id)
	end
end

-- Lines: 3009 to 3013
function MenuComponentManager:on_ready_pressed_mission_briefing_gui(ready)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:on_ready_pressed(ready)
	end
end

-- Lines: 3015 to 3019
function MenuComponentManager:disable_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:set_enabled(false)
	end
end

-- Lines: 3021 to 3025
function MenuComponentManager:unlock_asset_mission_briefing_gui(asset_id)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:unlock_asset(asset_id)
	end
end

-- Lines: 3028 to 3032
function MenuComponentManager:unlock_gage_asset_mission_briefing_gui(asset_id)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:unlock_gage_asset(asset_id)
	end
end

-- Lines: 3035 to 3039
function MenuComponentManager:set_slot_outfit_mission_briefing_gui(slot, criminal_name, outfit)
	if self._mission_briefing_gui then
		self._mission_briefing_gui:set_slot_outfit(slot, criminal_name, outfit)
	end
end

-- Lines: 3041 to 3045
function MenuComponentManager:create_asset_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:create_asset_tab()
	end
end

-- Lines: 3047 to 3051
function MenuComponentManager:close_asset_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:close_asset()
	end
end

-- Lines: 3053 to 3057
function MenuComponentManager:flash_ready_mission_briefing_gui()
	if self._mission_briefing_gui then
		self._mission_briefing_gui:flash_ready()
	end
end

-- Lines: 3060 to 3062
function MenuComponentManager:_create_lootdrop_gui()
	self:create_lootdrop_gui()
end

-- Lines: 3064 to 3072
function MenuComponentManager:create_lootdrop_gui()
	if not self._lootdrop_gui then
		self._lootdrop_gui = LootDropScreenGui:new(self._ws, self._fullscreen_ws, managers.hud:get_lootscreen_hud(), self._saved_lootdrop_state)
		self._saved_lootdrop_state = nil
	end

	self:show_lootdrop_gui()
end

-- Lines: 3074 to 3080
function MenuComponentManager:set_lootdrop_state(state)
	if self._lootdrop_gui then
		self._lootdrop_gui:set_state(state)
	else
		self._saved_lootdrop_state = state
	end
end

-- Lines: 3082 to 3084
function MenuComponentManager:_hide_lootdrop_gui()
	self:hide_lootdrop_gui()
end

-- Lines: 3086 to 3090
function MenuComponentManager:hide_lootdrop_gui()
	if self._lootdrop_gui then
		self._lootdrop_gui:hide()
	end
end

-- Lines: 3092 to 3096
function MenuComponentManager:show_lootdrop_gui()
	if self._lootdrop_gui then
		self._lootdrop_gui:show()
	end
end

-- Lines: 3098 to 3103
function MenuComponentManager:close_lootdrop_gui()
	if self._lootdrop_gui then
		self._lootdrop_gui:close()

		self._lootdrop_gui = nil
	end
end

-- Lines: 3105 to 3110
function MenuComponentManager:lootdrop_is_now_active()
	if self._lootdrop_gui then
		self._lootdrop_gui._panel:show()
		self._lootdrop_gui._fullscreen_panel:show()
	end
end

-- Lines: 3114 to 3116
function MenuComponentManager:_create_lootdrop_casino_gui(node)
	self:create_lootdrop_casino_gui(node)
end

-- Lines: 3118 to 3188
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

-- Lines: 3190 to 3205
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

-- Lines: 3207 to 3208
function MenuComponentManager:check_lootdrop_casino_done()
	return self._lootdrop_casino_gui:card_chosen()
end

-- Lines: 3213 to 3215
function MenuComponentManager:_create_stage_endscreen_gui()
	self:create_stage_endscreen_gui()
end

-- Lines: 3220 to 3240
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

-- Lines: 3243 to 3245
function MenuComponentManager:_hide_stage_endscreen_gui()
	self:hide_stage_endscreen_gui()
end

-- Lines: 3248 to 3252
function MenuComponentManager:hide_stage_endscreen_gui()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:hide()
	end
end

-- Lines: 3255 to 3259
function MenuComponentManager:show_stage_endscreen_gui()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:show()
	end
end

-- Lines: 3261 to 3266
function MenuComponentManager:close_stage_endscreen_gui()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:close()

		self._stage_endscreen_gui = nil
	end
end

-- Lines: 3268 to 3275
function MenuComponentManager:show_endscreen_cash_summary()
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:show_cash_summary()
	else
		self._endscreen_predata = self._endscreen_predata or {}
		self._endscreen_predata.cash_summary = true
	end
end

-- Lines: 3276 to 3284
function MenuComponentManager:feed_endscreen_statistics(data)
	if self._stage_endscreen_gui then
		self._stage_endscreen_gui:feed_statistics(data)
	else
		self._endscreen_predata = self._endscreen_predata or {}
		self._endscreen_predata.stats = data
	end
end

-- Lines: 3287 to 3294
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

-- Lines: 3298 to 3304
function MenuComponentManager:_create_menuscene_info_gui(node)
	self:_close_menuscene_info_gui()

	if not self._menuscene_info_gui then
		self._menuscene_info_gui = MenuSceneGui:new(self._ws, self._fullscreen_ws, node)
	end
end

-- Lines: 3306 to 3311
function MenuComponentManager:_close_menuscene_info_gui()
	if self._menuscene_info_gui then
		self._menuscene_info_gui:close()

		self._menuscene_info_gui = nil
	end
end

-- Lines: 3315 to 3317
function MenuComponentManager:_create_player_profile_gui()
	self:create_player_profile_gui()
end

-- Lines: 3319 to 3322
function MenuComponentManager:create_player_profile_gui()
	self:close_player_profile_gui()

	self._player_profile_gui = PlayerProfileGuiObject:new(self._ws)
end

-- Lines: 3324 to 3328
function MenuComponentManager:refresh_player_profile_gui()
	if self._player_profile_gui then
		self:create_player_profile_gui()
	end
end

-- Lines: 3330 to 3339
function MenuComponentManager:close_player_profile_gui()
	if self._player_profile_gui then
		self._player_profile_gui:close()

		self._player_profile_gui = nil
	end
end

-- Lines: 3343 to 3345
function MenuComponentManager:_create_ingame_manual_gui()
	self:create_ingame_manual_gui()
end

-- Lines: 3347 to 3351
function MenuComponentManager:create_ingame_manual_gui()
	self:close_ingame_manual_gui()

	self._ingame_manual_gui = IngameManualGui:new(self._ws, self._fullscreen_ws)

	self._ingame_manual_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 3353 to 3360
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

-- Lines: 3362 to 3367
function MenuComponentManager:close_ingame_manual_gui()
	if self._ingame_manual_gui then
		self._ingame_manual_gui:close()

		self._ingame_manual_gui = nil
	end
end

-- Lines: 3371 to 3373
function MenuComponentManager:_create_ingame_contract_gui()
	self:create_ingame_contract_gui()
end

-- Lines: 3375 to 3388
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

-- Lines: 3390 to 3398
function MenuComponentManager:close_ingame_contract_gui()
	if self._ingame_contract_gui then
		self._ingame_contract_gui:close()

		self._ingame_contract_gui = nil

		self:unregister_component("ingame_contract")
	end
end

-- Lines: 3403 to 3405
function MenuComponentManager:_create_ingame_waiting_gui()
	self:create_ingame_waiting_gui()
end

-- Lines: 3407 to 3416
function MenuComponentManager:create_ingame_waiting_gui()
	if not Network:is_server() then
		return
	end

	self:close_ingame_waiting_gui()

	self._ingame_waiting_gui = IngameWaitingGui:new(self._ws)

	self._ingame_waiting_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
	self:register_component("ingame_waiting", self._ingame_waiting_gui)
end

-- Lines: 3418 to 3424
function MenuComponentManager:close_ingame_waiting_gui()
	if self._ingame_waiting_gui then
		self._ingame_waiting_gui:close()

		self._ingame_waiting_gui = nil

		self:unregister_component("ingame_waiting")
	end
end

-- Lines: 3427 to 3433
function MenuComponentManager:_create_profile_gui()
	if self._profile_gui then
		self._profile_gui:set_enabled(true)

		return
	end

	self:create_profile_gui()
end

-- Lines: 3435 to 3439
function MenuComponentManager:create_profile_gui()
	self:close_profile_gui()

	self._profile_gui = ProfileBoxGui:new(self._ws)

	self._profile_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

-- Lines: 3441 to 3445
function MenuComponentManager:_disable_profile_gui()
	if self._profile_gui then
		self._profile_gui:set_enabled(false)
	end
end

-- Lines: 3447 to 3456
function MenuComponentManager:close_profile_gui()
	if self._profile_gui then
		self._profile_gui:close()

		self._profile_gui = nil
	end
end

-- Lines: 3458 to 3464
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

-- Lines: 3466 to 3477
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

-- Lines: 3480 to 3485
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

-- Lines: 3487 to 3496
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

-- Lines: 3499 to 3505
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

-- Lines: 3507 to 3516
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

-- Lines: 3520 to 3561
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

-- Lines: 3564 to 3682
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

-- Lines: 3686 to 3691
function MenuComponentManager:create_game_installing_gui()
	if self._game_installing then
		return
	end

	self:_create_game_installing_gui()
end

-- Lines: 3692 to 3697
function MenuComponentManager:_create_game_installing_gui()
	self:close_game_installing_gui()

	if not MenuCallbackHandler:is_installed() then
		self._game_installing = GameInstallingGui:new(self._ws)
	end
end

-- Lines: 3699 to 3734
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

-- Lines: 3736 to 3741
function MenuComponentManager:close_game_installing_gui()
	if self._game_installing then
		self._game_installing:close()

		self._game_installing = nil
	end
end

-- Lines: 3788 to 3790
function MenuComponentManager:create_inventory_gui(node)
	self:_create_inventory_gui(node)
end

-- Lines: 3792 to 3800
function MenuComponentManager:_create_inventory_gui(node)
	self:close_inventory_gui()

	self._player_inventory_gui = PlayerInventoryGui:new(self._ws, self._fullscreen_ws, node)
	local active_menu = managers.menu:active_menu()

	if active_menu then
		active_menu.input:set_force_input(true)
	end
end

-- Lines: 3802 to 3812
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

-- Lines: 3815 to 3820
function MenuComponentManager:_create_newsfeed_gui()
	if self._newsfeed_gui then
		return
	end

	self:create_newsfeed_gui()
end

-- Lines: 3821 to 3826
function MenuComponentManager:create_newsfeed_gui()
	self:close_newsfeed_gui()

	if SystemInfo:platform() == Idstring("WIN32") then
		self._newsfeed_gui = NewsFeedGui:new(self._ws)
	end
end

-- Lines: 3828 to 3832
function MenuComponentManager:_update_newsfeed_gui(t, dt)
	if self._newsfeed_gui then
		self._newsfeed_gui:update(t, dt)
	end
end

-- Lines: 3834 to 3839
function MenuComponentManager:close_newsfeed_gui()
	if self._newsfeed_gui then
		self._newsfeed_gui:close()

		self._newsfeed_gui = nil
	end
end

-- Lines: 3844 to 3859
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

-- Lines: 3861 to 3862
function MenuComponentManager:_create_preplanning_map_gui(node)
	return PrePlanningMapGui:new(self._ws, self._fullscreen_ws, node)
end

-- Lines: 3865 to 3866
function MenuComponentManager:is_preplanning_enabled()
	return self._preplanning_map and self._preplanning_map:enabled()
end

-- Lines: 3869 to 3877
function MenuComponentManager:close_preplanning_map_gui()
	self:_close_preplanning_map_gui()

	if self._preplanning_map then
		local active_menu = managers.menu:active_menu()

		if active_menu then
			active_menu.input:set_force_input(false)
		end
	end
end

-- Lines: 3879 to 3889
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

-- Lines: 3891 to 3895
function MenuComponentManager:_close_preplanning_map_gui()
	if self._preplanning_map then
		self._preplanning_map:disable()
	end
end

-- Lines: 3897 to 3901
function MenuComponentManager:preplanning_flash_error(...)
	if self._preplanning_map then
		self._preplanning_map:flash_error(...)
	end
end

-- Lines: 3903 to 3907
function MenuComponentManager:set_preplanning_category_filter(category)
	if self._preplanning_map then
		self._preplanning_map:set_category_filter(category)
	end
end

-- Lines: 3909 to 3913
function MenuComponentManager:set_preplanning_type_filter(type)
	if self._preplanning_map then
		self._preplanning_map:set_type_filter(type)
	end
end

-- Lines: 3915 to 3919
function MenuComponentManager:get_preplanning_filter()
	if self._preplanning_map then
		return self._preplanning_map:current_type_filter()
	end
end

-- Lines: 3921 to 3925
function MenuComponentManager:set_preplanning_selected_element_item(item)
	if self._preplanning_map then
		return self._preplanning_map:set_selected_element_item(item)
	end
end

-- Lines: 3927 to 3931
function MenuComponentManager:set_preplanning_map_position_to_item(item)
	if self._preplanning_map then
		return self._preplanning_map:set_map_position_to_item(item)
	end
end

-- Lines: 3933 to 3937
function MenuComponentManager:set_preplanning_map_position(x, y, location)
	if self._preplanning_map then
		return self._preplanning_map:set_map_position(x, y, location)
	end
end

-- Lines: 3939 to 3943
function MenuComponentManager:update_preplanning_element(type, id)
	if self._preplanning_map then
		return self._preplanning_map:update_element(type, id)
	end
end

-- Lines: 3945 to 3949
function MenuComponentManager:preplanning_post_event(event, listener_clbk)
	if self._preplanning_map then
		return self._preplanning_map:post_event(event, listener_clbk)
	end
end

-- Lines: 3951 to 3955
function MenuComponentManager:preplanning_stop_event()
	if self._preplanning_map then
		return self._preplanning_map:stop_event()
	end
end

-- Lines: 3957 to 3961
function MenuComponentManager:preplanning_start_custom_talk(id)
	if self._preplanning_map then
		return self._preplanning_map:start_custom_talk(id)
	end
end

-- Lines: 3963 to 3967
function MenuComponentManager:toggle_preplanning_drawing(peer_id)
	if self._preplanning_map then
		return self._preplanning_map:toggle_drawing(peer_id)
	end
end

-- Lines: 3969 to 3990
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

-- Lines: 3992 to 3998
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

-- Lines: 4000 to 4010
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

-- Lines: 4012 to 4027
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

-- Lines: 4029 to 4048
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

-- Lines: 4050 to 4063
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

-- Lines: 4065 to 4069
function MenuComponentManager:_set_preplanning_drawings(peer_draw_lines, peer_draw_line_index)
	self._preplanning_map:set_drawings(peer_draw_lines, peer_draw_line_index)

	self._preplanning_peer_draw_lines = nil
	self._preplanning_peer_draw_line_index = nil
end

-- Lines: 4072 to 4076
function MenuComponentManager:hide_preplanning_drawboard()
	if self._preplanning_map then
		self._preplanning_map:hide_drawboard()
	end
end

-- Lines: 4078 to 4082
function MenuComponentManager:set_preplanning_drawboard(x, y)
	if self._preplanning_map then
		self._preplanning_map:set_drawboard_button_position(x, y)
	end
end

-- Lines: 4084 to 4088
function MenuComponentManager:get_game_chat_button_shape()
	if self._game_chat_gui then
		return self._game_chat_gui:get_chat_button_shape()
	end
end

-- Lines: 4092 to 4096
function MenuComponentManager:set_blackmarket_tradable_loaded(error)
	if self._blackmarket_gui then
		self._blackmarket_gui:set_tradable_loaded(error)
	end
end

-- Lines: 4099 to 4106
function MenuComponentManager:_create_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:set_enabled(true)

		return
	end

	self:create_debug_fonts_gui()
end

-- Lines: 4108 to 4111
function MenuComponentManager:create_debug_fonts_gui()
	self:close_debug_fonts_gui()

	self._debug_fonts_gui = DebugDrawFonts:new(self._fullscreen_ws)
end

-- Lines: 4113 to 4117
function MenuComponentManager:_disable_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:set_enabled(false)
	end
end

-- Lines: 4119 to 4124
function MenuComponentManager:close_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:close()

		self._debug_fonts_gui = nil
	end
end

-- Lines: 4133 to 4134
function MenuComponentManager:toggle_debug_fonts_gui()
end

-- Lines: 4136 to 4140
function MenuComponentManager:reload_debug_fonts_gui()
	if self._debug_fonts_gui then
		self._debug_fonts_gui:reload()
	end
end

-- Lines: 4143 to 4150
function MenuComponentManager:_create_debug_strings_gui()
	if self._debug_strings_book then
		self._debug_strings_book:set_enabled(true)

		return
	end

	self:create_debug_strings_gui()
end

-- Lines: 4152 to 4166
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

-- Lines: 4174 to 4178
function MenuComponentManager:_disable_debug_strings_gui()
	if self._debug_strings_book then
		self._debug_strings_book:set_enabled(false)
	end
end

-- Lines: 4185 to 4190
function MenuComponentManager:close_debug_strings_gui()
	if self._debug_strings_book then
		self._debug_strings_book:close()

		self._debug_strings_book = nil
	end
end

-- Lines: 4194 to 4198
function MenuComponentManager:_maximize_weapon_box(data)
	self._weapon_text_box:set_visible(true)

	self._weapon_text_minimized_id = nil

	self:remove_minimized(data.id)
end

-- Lines: 4200 to 4237
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

-- Lines: 4240 to 4247
function MenuComponentManager:_layout_minimized()
	local x = 0

	for i, data in ipairs(self._minimized_list) do
		data.panel:set_x(x)
		data.top_line:set_x(x)

		x = x + data.panel:w() + 2
	end
end

-- Lines: 4249 to 4260
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

-- Lines: 4263 to 4280
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

-- Lines: 4282 to 4321
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

-- Lines: 4324 to 4337
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

-- Lines: 4342 to 4343
function MenuComponentManager:retrieve_texture(texture)
	return TextureCache:retrieve(texture, "NORMAL")
end

-- Lines: 4347 to 4401
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

-- Lines: 4404 to 4407
function MenuComponentPostEventInstance:init(sound_source)
	self._sound_source = sound_source
	self._post_event = false
end

-- Lines: 4409 to 4418
function MenuComponentPostEventInstance:post_event(event)
	if alive(self._post_event) then
		self._post_event:stop()
	end

	self._post_event = false
	self._post_event = alive(self._sound_source) and self._sound_source:post_event(event)
end

-- Lines: 4420 to 4425
function MenuComponentPostEventInstance:stop_event()
	if alive(self._post_event) then
		self._post_event:stop()
	end

	self._post_event = false
end

-- Lines: 4427 to 4431
function MenuComponentManager:new_post_event_instance()
	local event_instance = MenuComponentPostEventInstance:new(self._sound_source)
	self._unique_event_instances = self._unique_event_instances or {}

	table.insert(self._unique_event_instances, event_instance)

	return event_instance
end

-- Lines: 4435 to 4449
function MenuComponentManager:post_event(event, unique)
	if _G.IS_VR then
		managers.menu:post_event_vr(event)
	end

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

-- Lines: 4452 to 4458
function MenuComponentManager:stop_event()
	print("MenuComponentManager:stop_event()")

	if alive(self._post_event) then
		self._post_event:stop()

		self._post_event = nil
	end
end

-- Lines: 4460 to 4515
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

-- Lines: 4517 to 4542
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


	-- Lines: 4524 to 4540
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

-- Lines: 4544 to 4619
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


		-- Lines: 4554 to 4558
		local function one_frame_hide(o)
			o:hide()
			coroutine.yield()
			o:show()
		end

		b:animate(one_frame_hide)
	end

	local o = self._tcst:panel():children()[1]


	-- Lines: 4599 to 4615
	local function animate_fade(o)
		local black = o:child("black")

		over(0.5, function (p)
			black:set_alpha(1 - p)
		end)
	end

	o:stop()
	o:animate(animate_fade)
end

-- Lines: 4622 to 4643
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

-- Lines: 4645 to 4650
function MenuComponentManager:destroy_test_gui()
	if alive(Global.test_gui) then
		managers.gui_data:destroy_workspace(Global.test_gui)

		Global.test_gui = nil
	end
end

-- Lines: 4655 to 4657
function MenuComponentManager:create_custom_safehouse_primaries(node)
	self:create_ingame_custom_safehouse_menu(node, "primaries")
end

-- Lines: 4659 to 4661
function MenuComponentManager:create_custom_safehouse_secondaries(node)
	self:create_ingame_custom_safehouse_menu(node, "secondaries")
end

-- Lines: 4664 to 4727
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

-- Lines: 4729 to 4731
function MenuComponentManager:close_custom_safehouse_primaries()
	self:close_custom_safehouse_menu("primaries")
end

-- Lines: 4733 to 4735
function MenuComponentManager:close_custom_safehouse_secondaries()
	self:close_custom_safehouse_menu("secondaries")
end

-- Lines: 4737 to 4738
function MenuComponentManager:close_custom_safehouse_menu(category)
end

-- Lines: 4740 to 4746
function MenuComponentManager:create_new_heists_gui(node)
	if not node then
		return
	end

	self._new_heists_gui = self._new_heists_gui or NewHeistsGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("new_heists", self._new_heists_gui)
end

-- Lines: 4748 to 4754
function MenuComponentManager:close_new_heists_gui()
	if self._new_heists_gui then
		self._new_heists_gui:close()

		self._new_heists_gui = nil

		self:unregister_component("new_heists")
	end
end

-- Lines: 4760 to 4767
function MenuComponentManager:create_crime_spree_contract_gui(node)
	if not node then
		return
	end

	self._crime_spree_contract_menu_comp = self._crime_spree_contract_menu_comp or CrimeSpreeContractMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crimenet_crime_spree_contract", self._crime_spree_contract_menu_comp)
	self:disable_crimenet()
end

-- Lines: 4769 to 4776
function MenuComponentManager:close_crime_spree_contract_gui(node)
	if self._crime_spree_contract_menu_comp then
		self._crime_spree_contract_menu_comp:close()

		self._crime_spree_contract_menu_comp = nil

		self:unregister_component("crimenet_crime_spree_contract")
		self:enable_crimenet()
	end
end

-- Lines: 4780 to 4786
function MenuComponentManager:create_crime_spree_missions_gui(node)
	if not node or not managers.crime_spree:is_active() then
		return
	end

	self._crime_spree_missions = self._crime_spree_missions or CrimeSpreeMissionsMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_missions", self._crime_spree_missions)
end

-- Lines: 4788 to 4794
function MenuComponentManager:close_crime_spree_missions_gui(node)
	if self._crime_spree_missions then
		self._crime_spree_missions:close()

		self._crime_spree_missions = nil

		self:unregister_component("crime_spree_missions")
	end
end

-- Lines: 4796 to 4797
function MenuComponentManager:crime_spree_missions_gui()
	return self._crime_spree_missions
end

-- Lines: 4802 to 4808
function MenuComponentManager:create_crime_spree_details_gui(node)
	if not node or not managers.crime_spree:is_active() then
		return
	end

	self._crime_spree_details = self._crime_spree_details or CrimeSpreeDetailsMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_details", self._crime_spree_details)
end

-- Lines: 4810 to 4816
function MenuComponentManager:close_crime_spree_details_gui(node)
	if self._crime_spree_details then
		self._crime_spree_details:close()

		self._crime_spree_details = nil

		self:unregister_component("crime_spree_details")
	end
end

-- Lines: 4818 to 4825
function MenuComponentManager:refresh_crime_spree_details_gui()
	local node = nil

	if self._crime_spree_details then
		node = self._crime_spree_details._node
	end

	self:close_crime_spree_details_gui(node)
	self:create_crime_spree_details_gui(node)
end

-- Lines: 4827 to 4828
function MenuComponentManager:crime_spree_details_gui()
	return self._crime_spree_details
end

-- Lines: 4833 to 4839
function MenuComponentManager:create_crime_spree_modifiers_gui(node)
	if not node then
		return
	end

	self._crime_spree_modifiers = self._crime_spree_modifiers or CrimeSpreeModifiersMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_modifiers", self._crime_spree_modifiers)
end

-- Lines: 4841 to 4847
function MenuComponentManager:close_crime_spree_modifiers_gui(node)
	if self._crime_spree_modifiers then
		self._crime_spree_modifiers:close()

		self._crime_spree_modifiers = nil

		self:unregister_component("crime_spree_modifiers")
	end
end

-- Lines: 4849 to 4850
function MenuComponentManager:crime_spree_modifiers()
	return self._crime_spree_modifiers
end

-- Lines: 4855 to 4857
function MenuComponentManager:check_crime_spree_forced_modifiers(node)
	managers.crime_spree:check_forced_modifiers()
end

-- Lines: 4859 to 4866
function MenuComponentManager:create_crime_spree_forced_modifiers_gui(node)
	if not node then
		return
	end

	self._crime_spree_forced_modifiers = self._crime_spree_forced_modifiers or CrimeSpreeForcedModifiersMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_forced_modifiers", self._crime_spree_forced_modifiers)
end

-- Lines: 4868 to 4874
function MenuComponentManager:close_crime_spree_forced_modifiers_gui(node)
	if self._crime_spree_forced_modifiers then
		self._crime_spree_forced_modifiers:close()

		self._crime_spree_forced_modifiers = nil

		self:unregister_component("crime_spree_forced_modifiers")
	end
end

-- Lines: 4876 to 4877
function MenuComponentManager:crime_spree_forced_modifiers()
	return self._crime_spree_forced_modifiers
end

-- Lines: 4882 to 4888
function MenuComponentManager:create_crime_spree_rewards_gui(node)
	if not node then
		return
	end

	self._crime_spree_rewards = self._crime_spree_rewards or CrimeSpreeRewardsMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_rewards", self._crime_spree_rewards)
end

-- Lines: 4890 to 4896
function MenuComponentManager:close_crime_spree_rewards_gui(node)
	if self._crime_spree_rewards then
		self._crime_spree_rewards:close()

		self._crime_spree_rewards = nil

		self:unregister_component("crime_spree_rewards")
	end
end

-- Lines: 4900 to 4906
function MenuComponentManager:create_crime_spree_mission_end_gui(node)
	if not node or not managers.crime_spree:is_active() then
		return
	end

	self._crime_spree_mission_end = self._crime_spree_mission_end or CrimeSpreeMissionEndOptions:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crime_spree_mission_end", self._crime_spree_mission_end)
end

-- Lines: 4908 to 4914
function MenuComponentManager:close_crime_spree_mission_end_gui(node)
	if self._crime_spree_mission_end then
		self._crime_spree_mission_end:close()

		self._crime_spree_mission_end = nil

		self:unregister_component("crime_spree_mission_end")
	end
end

-- Lines: 4916 to 4917
function MenuComponentManager:crime_spree_mission_end_gui()
	return self._crime_spree_mission_end
end

-- Lines: 4933 to 4934
function MenuComponentManager:create_debug_quicklaunch_gui(node)
end

-- Lines: 4945 to 4946
function MenuComponentManager:close_debug_quicklaunch_gui()
end

-- Lines: 4951 to 4957
function MenuComponentManager:create_crew_management_gui(node)
	if not node then
		return
	end

	self._crew_management_gui = self._crew_management_gui or CrewManagementGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crew_management", self._crew_management_gui)
end

-- Lines: 4959 to 4965
function MenuComponentManager:close_crew_management_gui()
	if self._crew_management_gui then
		self._crew_management_gui:close()

		self._crew_management_gui = nil

		self:unregister_component("crew_management")
	end
end

-- Lines: 4989 to 4993
function MenuComponentManager:create_story_missions_gui(node)
	self:close_story_missions_gui()

	self._story_missions_gui = StoryMissionsGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("story_missions", self._story_missions_gui)
end

-- Lines: 4995 to 5001
function MenuComponentManager:close_story_missions_gui()
	if self._story_missions_gui then
		self._story_missions_gui:close()

		self._story_missions_gui = nil

		self:unregister_component("story_missions")
	end
end

-- Lines: 5003 to 5004
function MenuComponentManager:story_missions_gui()
	return self._story_missions_gui
end

-- Lines: 5009 to 5013
function MenuComponentManager:create_crimenet_sidebar_gui(node)
	self:close_crimenet_sidebar_gui()

	self._crimenet_sidebar_gui = CrimeNetSidebarGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("crimenet_sidebar", self._crimenet_sidebar_gui)
end

-- Lines: 5015 to 5021
function MenuComponentManager:close_crimenet_sidebar_gui()
	if self._crimenet_sidebar_gui then
		self._crimenet_sidebar_gui:close()

		self._crimenet_sidebar_gui = nil

		self:unregister_component("crimenet_sidebar")
	end
end

-- Lines: 5023 to 5024
function MenuComponentManager:crimenet_sidebar_gui()
	return self._crimenet_sidebar_gui
end

-- Lines: 5031 to 5035
function MenuComponentManager:create_raid_menu_gui(node)
	self:close_raid_menu_gui()

	self._raid_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid")

	self:register_component("raid_menu", self._raid_menu_gui)
end

-- Lines: 5037 to 5043
function MenuComponentManager:close_raid_menu_gui()
	if self._raid_menu_gui then
		self._raid_menu_gui:close()

		self._raid_menu_gui = nil

		self:unregister_component("raid_menu")
	end
end

-- Lines: 5045 to 5046
function MenuComponentManager:raid_menu_gui()
	return self._raid_menu_gui
end

-- Lines: 5051 to 5055
function MenuComponentManager:create_raid_weapons_menu_gui(node)
	self:close_raid_weapons_menu_gui()

	self._raid_weapons_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid_weapons")

	self:register_component("raid_weapons_menu", self._raid_weapons_menu_gui)
end

-- Lines: 5057 to 5063
function MenuComponentManager:close_raid_weapons_menu_gui()
	if self._raid_weapons_menu_gui then
		self._raid_weapons_menu_gui:close()

		self._raid_weapons_menu_gui = nil

		self:unregister_component("raid_weapons_menu")
	end
end

-- Lines: 5065 to 5066
function MenuComponentManager:raid_weapons_menu_gui()
	return self._raid_weapons_menu_gui
end

-- Lines: 5071 to 5075
function MenuComponentManager:create_raid_preorder_menu_gui(node)
	self:close_raid_preorder_menu_gui()

	self._raid_preorder_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid_preorder")

	self:register_component("raid_preorder_menu", self._raid_preorder_menu_gui)
end

-- Lines: 5077 to 5083
function MenuComponentManager:close_raid_preorder_menu_gui()
	if self._raid_preorder_menu_gui then
		self._raid_preorder_menu_gui:close()

		self._raid_preorder_menu_gui = nil

		self:unregister_component("raid_preorder_menu")
	end
end

-- Lines: 5085 to 5086
function MenuComponentManager:raid_preorder_menu_gui()
	return self._raid_preorder_menu_gui
end

-- Lines: 5091 to 5095
function MenuComponentManager:create_raid_special_menu_gui(node)
	self:close_raid_special_menu_gui()

	self._raid_special_menu_gui = RaidMenuGui:new(self._ws, self._fullscreen_ws, node, "raid_special")

	self:register_component("raid_special_menu", self._raid_special_menu_gui)
end

-- Lines: 5097 to 5103
function MenuComponentManager:close_raid_special_menu_gui()
	if self._raid_special_menu_gui then
		self._raid_special_menu_gui:close()

		self._raid_special_menu_gui = nil

		self:unregister_component("raid_special_menu")
	end
end

-- Lines: 5105 to 5106
function MenuComponentManager:raid_special_menu_gui()
	return self._raid_special_menu_gui
end

-- Lines: 5111 to 5115
function MenuComponentManager:create_raid_weapon_preview_gui(node)
	self:close_raid_weapon_preview_gui()

	self._raid_weapon_preview_gui = PromotionalWeaponPreviewGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("raid_weapon_preview", self._raid_weapon_preview_gui)
end

-- Lines: 5117 to 5123
function MenuComponentManager:close_raid_weapon_preview_gui()
	if self._raid_weapon_preview_gui then
		self._raid_weapon_preview_gui:close()

		self._raid_weapon_preview_gui = nil

		self:unregister_component("raid_weapon_preview")
	end
end

-- Lines: 5125 to 5126
function MenuComponentManager:raid_weapon_preview_gui()
	return self._raid_weapon_preview_gui
end

-- Lines: 5134 to 5138
function MenuComponentManager:create_contract_broker_gui(node)
	self:close_contract_broker_gui()

	self._contract_broker_gui = ContractBrokerGui:new(self._ws, self._fullscreen_ws, node)

	self:register_component("contract_broker", self._contract_broker_gui)
end

-- Lines: 5140 to 5146
function MenuComponentManager:close_contract_broker_gui()
	if self._contract_broker_gui then
		self._contract_broker_gui:close()

		self._contract_broker_gui = nil

		self:unregister_component("contract_broker")
	end
end

-- Lines: 5148 to 5149
function MenuComponentManager:contract_broker_gui()
	return self._contract_broker_gui
end

