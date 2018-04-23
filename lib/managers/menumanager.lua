core:import("CoreMenuManager")
core:import("CoreMenuCallbackHandler")
require("lib/managers/menu/MenuInput")
require("lib/managers/menu/MenuRenderer")
require("lib/managers/menu/MenuLobbyRenderer")
require("lib/managers/menu/MenuPauseRenderer")
require("lib/managers/menu/MenuKitRenderer")
require("lib/managers/menu/MenuHiddenRenderer")
require("lib/managers/menu/items/MenuItemColumn")
require("lib/managers/menu/items/MenuItemLevel")
require("lib/managers/menu/items/MenuItemChallenge")
require("lib/managers/menu/items/MenuItemKitSlot")
require("lib/managers/menu/items/MenuItemUpgrade")
require("lib/managers/menu/items/MenuItemMultiChoice")
require("lib/managers/menu/items/MenuItemToggle")
require("lib/managers/menu/items/MenuItemChat")
require("lib/managers/menu/items/MenuItemGenerics")
require("lib/managers/menu/items/MenuItemFriend")
require("lib/managers/menu/items/MenuItemCustomizeController")
require("lib/managers/menu/items/MenuItemInput")
require("lib/managers/menu/items/MenuItemTextBox")
require("lib/managers/menu/items/MenuItemDummy")
require("lib/managers/menu/nodes/MenuNodeTable")
require("lib/managers/menu/nodes/MenuNodeServerList")
require("lib/managers/menu/items/MenuItemCrimeSpreeItem")
core:import("CoreEvent")

MenuManager = MenuManager or class(CoreMenuManager.Manager)
MenuCallbackHandler = MenuCallbackHandler or class(CoreMenuCallbackHandler.CallbackHandler)

require("lib/managers/MenuManagerPD2")
require("lib/managers/menu/MenuManagerCrimeSpreeCallbacks")

MenuManager.IS_NORTH_AMERICA = SystemInfo:platform() == Idstring("WIN32") or Application:is_northamerica()
MenuManager.ONLINE_AGE = (SystemInfo:platform() == Idstring("PS3") or SystemInfo:platform() == Idstring("PS4")) and MenuManager.IS_NORTH_AMERICA and 17 or 18

require("lib/managers/MenuManagerDialogs")
require("lib/managers/MenuManagerDebug")

-- Lines: 47 to 256
function MenuManager:init(is_start_menu)
	MenuManager.super.init(self)

	self._is_start_menu = is_start_menu
	self._active = false
	self._debug_menu_enabled = Global.DEBUG_MENU_ON or Application:production_build()
	Global.debug_contour_enabled = nil

	self:create_controller()

	if is_start_menu then
		local menu_main = {
			input = "MenuInput",
			name = "menu_main",
			renderer = "MenuRenderer",
			id = "start_menu",
			content_file = "gamedata/menus/start_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(menu_main)

		if _G.IS_VR then
			local menu_data = self._registered_menus.menu_main.data
			local lobby_parameters = menu_data:get_node("lobby"):parameters()
			lobby_parameters.scene_state = "lobby_vr"
		end
	else
		local menu_pause = {
			input = "MenuInput",
			name = "menu_pause",
			renderer = "MenuPauseRenderer",
			id = "pause_menu",
			content_file = "gamedata/menus/pause_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(menu_pause)

		local kit_menu = {
			input = "MenuInput",
			name = "kit_menu",
			renderer = "MenuKitRenderer",
			id = "kit_menu",
			content_file = "gamedata/menus/kit_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(kit_menu)

		local mission_end_menu = {
			input = "MenuInput",
			name = "mission_end_menu",
			renderer = "MenuHiddenRenderer",
			id = "mission_end_menu",
			content_file = "gamedata/menus/mission_end_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(mission_end_menu)

		local loot_menu = {
			input = "MenuInput",
			name = "loot_menu",
			renderer = "MenuHiddenRenderer",
			id = "loot_menu",
			content_file = "gamedata/menus/loot_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(loot_menu)

		local custom_safehouse_menu = {
			input = "MenuInput",
			name = "custom_safehouse_menu",
			renderer = "MenuHiddenRenderer",
			id = "custom_safehouse_menu",
			content_file = "gamedata/menus/custom_safehouse_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(custom_safehouse_menu)

		local heister_interact_menu = {
			input = "MenuInput",
			name = "heister_interact_menu",
			renderer = "MenuHiddenRenderer",
			id = "heister_interact_menu",
			content_file = "gamedata/menus/heister_interact_menu",
			callback_handler = MenuCallbackHandler:new()
		}

		self:register_menu(heister_interact_menu)
	end

	self._controller:add_trigger("toggle_menu", callback(self, self, "toggle_menu_state"))

	if MenuCallbackHandler:is_pc_controller() and MenuCallbackHandler:is_not_steam_controller() then
		self._controller:add_trigger("toggle_chat", callback(self, self, "toggle_chatinput"))
	end

	if SystemInfo:platform() == Idstring("WIN32") then
		self._controller:add_trigger("push_to_talk", callback(self, self, "push_to_talk", true))
		self._controller:add_release_trigger("push_to_talk", callback(self, self, "push_to_talk", false))
	end

	self._active_changed_callback_handler = CoreEvent.CallbackEventHandler:new()

	managers.user:add_setting_changed_callback("brightness", callback(self, self, "brightness_changed"), true)
	managers.user:add_setting_changed_callback("camera_sensitivity_x", callback(self, self, "camera_sensitivity_x_changed"), true)
	managers.user:add_setting_changed_callback("camera_sensitivity_y", callback(self, self, "camera_sensitivity_y_changed"), true)
	managers.user:add_setting_changed_callback("camera_zoom_sensitivity_x", callback(self, self, "camera_sensitivity_x_changed"), true)
	managers.user:add_setting_changed_callback("camera_zoom_sensitivity_y", callback(self, self, "camera_sensitivity_y_changed"), true)
	managers.user:add_setting_changed_callback("rumble", callback(self, self, "rumble_changed"), true)
	managers.user:add_setting_changed_callback("invert_camera_x", callback(self, self, "invert_camera_x_changed"), true)
	managers.user:add_setting_changed_callback("invert_camera_y", callback(self, self, "invert_camera_y_changed"), true)
	managers.user:add_setting_changed_callback("southpaw", callback(self, self, "southpaw_changed"), true)
	managers.user:add_setting_changed_callback("subtitle", callback(self, self, "subtitle_changed"), true)
	managers.user:add_setting_changed_callback("music_volume", callback(self, self, "music_volume_changed"), true)
	managers.user:add_setting_changed_callback("sfx_volume", callback(self, self, "sfx_volume_changed"), true)
	managers.user:add_setting_changed_callback("voice_volume", callback(self, self, "voice_volume_changed"), true)
	managers.user:add_setting_changed_callback("use_lightfx", callback(self, self, "lightfx_changed"), true)
	managers.user:add_setting_changed_callback("effect_quality", callback(self, self, "effect_quality_changed"), true)
	managers.user:add_setting_changed_callback("dof_setting", callback(self, self, "dof_setting_changed"), true)
	managers.user:add_setting_changed_callback("chromatic_setting", callback(self, self, "chromatic_setting_changed"), true)
	managers.user:add_setting_changed_callback("fps_cap", callback(self, self, "fps_limit_changed"), true)
	managers.user:add_setting_changed_callback("net_packet_throttling", callback(self, self, "net_packet_throttling_changed"), true)
	managers.user:add_setting_changed_callback("net_forwarding", callback(self, self, "net_forwarding_changed"), true)
	managers.user:add_setting_changed_callback("net_use_compression", callback(self, self, "net_use_compression_changed"), true)
	managers.user:add_setting_changed_callback("flush_gpu_command_queue", callback(self, self, "flush_gpu_command_queue_changed"), true)
	managers.user:add_setting_changed_callback("use_thq_weapon_parts", callback(self, self, "use_thq_weapon_parts_changed"), true)
	managers.user:add_active_user_state_changed_callback(callback(self, self, "on_user_changed"))
	managers.user:add_storage_changed_callback(callback(self, self, "on_storage_changed"))
	managers.savefile:add_active_changed_callback(callback(self, self, "safefile_manager_active_changed"))

	self._delayed_open_savefile_menu_callback = nil
	self._save_game_callback = nil

	self:brightness_changed(nil, nil, managers.user:get_setting("brightness"))
	self:effect_quality_changed(nil, nil, managers.user:get_setting("effect_quality"))
	self:fps_limit_changed(nil, nil, managers.user:get_setting("fps_cap"))
	self:net_packet_throttling_changed(nil, nil, managers.user:get_setting("net_packet_throttling"))
	self:net_forwarding_changed(nil, nil, managers.user:get_setting("net_forwarding"))
	self:net_use_compression_changed(nil, nil, managers.user:get_setting("net_use_compression"))
	self:flush_gpu_command_queue_changed(nil, nil, managers.user:get_setting("flush_gpu_command_queue"))
	self:invert_camera_y_changed("invert_camera_y", nil, managers.user:get_setting("invert_camera_y"))
	self:southpaw_changed("southpaw", nil, managers.user:get_setting("southpaw"))
	self:dof_setting_changed("dof_setting", nil, managers.user:get_setting("dof_setting"))
	self:chromatic_setting_changed("chromatic_setting", nil, managers.user:get_setting("chromatic_setting"))
	managers.system_menu:add_active_changed_callback(callback(self, self, "system_menu_active_changed"))

	self._sound_source = SoundDevice:create_source("MenuManager")

	managers.user:add_setting_changed_callback("video_ao", callback(self, self, "video_ao_changed"), true)
	self:video_ao_changed(nil, nil, managers.user:get_setting("video_ao"))
	managers.user:add_setting_changed_callback("parallax_mapping", callback(self, self, "parallax_mapping_changed"), true)
	self:parallax_mapping_changed(nil, nil, managers.user:get_setting("parallax_mapping"))
	managers.user:add_setting_changed_callback("video_aa", callback(self, self, "video_aa_changed"), true)
	self:video_aa_changed(nil, nil, managers.user:get_setting("video_aa"))
	managers.user:add_setting_changed_callback("workshop", callback(self, self, "workshop_changed"), true)
	self:workshop_changed(nil, nil, managers.user:get_setting("workshop"))
end

-- Lines: 258 to 259
function MenuManager:init_finalize()
end

-- Lines: 262 to 264
function MenuManager:post_event(event)
	local event = self._sound_source:post_event(event)
end

-- Lines: 266 to 268
function MenuManager:_cb_matchmake_found_game(game_id, created)
	print("_cb_matchmake_found_game", game_id, created)
end

-- Lines: 270 to 286
function MenuManager:_cb_matchmake_player_joined(player_info)
	print("_cb_matchmake_player_joined")

	if managers.network.group:is_group_leader() then
		-- Nothing
	end
end

-- Lines: 288 to 291
function MenuManager:destroy()
	MenuManager.super.destroy(self)
	self:destroy_controller()
end

-- Lines: 293 to 295
function MenuManager:set_delayed_open_savefile_menu_callback(callback_func)
	self._delayed_open_savefile_menu_callback = callback_func
end

-- Lines: 297 to 299
function MenuManager:set_save_game_callback(callback_func)
	self._save_game_callback = callback_func
end

-- Lines: 301 to 312
function MenuManager:system_menu_active_changed(active)
	local active_menu = self:active_menu()

	if not active_menu then
		return
	end

	if active then
		active_menu.logic:accept_input(false)
	else
		active_menu.renderer:disable_input(0.01)
	end
end

-- Lines: 314 to 327
function MenuManager:set_and_send_sync_state(state)
	if not managers.network or not managers.network:session() then
		return
	end

	local index = tweak_data:menu_sync_state_to_index(state)

	if index then
		self:_set_peer_sync_state(managers.network:session():local_peer():id(), state)
		managers.network:session():send_to_peers_loaded("set_menu_sync_state_index", index)
	end
end

-- Lines: 329 to 338
function MenuManager:_set_peer_sync_state(peer_id, state)
	Application:debug("MenuManager: " .. peer_id .. " sync state is now", state)

	self._peers_state = self._peers_state or {}
	self._peers_state[peer_id] = state

	if managers.menu_scene then
		managers.menu_scene:set_lobby_character_menu_state(peer_id, state)
	end
end

-- Lines: 340 to 343
function MenuManager:set_peer_sync_state_index(peer_id, index)
	local state = tweak_data:index_to_menu_sync_state(index)

	self:_set_peer_sync_state(peer_id, state)
end

-- Lines: 345 to 346
function MenuManager:get_all_peers_state()
	return self._peers_state
end

-- Lines: 349 to 350
function MenuManager:get_peer_state(peer_id)
	return self._peers_state and self._peers_state[peer_id]
end

-- Lines: 353 to 356
function MenuManager:_node_selected(menu_name, node)
	managers.vote:message_vote()
	self:set_and_send_sync_state(node and node:parameters().sync_state)
end

-- Lines: 358 to 364
function MenuManager:active_menu(node_name, parameter_list)
	local active_menu = self._open_menus[#self._open_menus]

	if active_menu then
		return active_menu
	end
end

-- Lines: 366 to 369
function MenuManager:open_menu(menu_name, position, ...)
	MenuManager.super.open_menu(self, menu_name, position, ...)
	self:activate()
end

-- Lines: 371 to 376
function MenuManager:open_node(node_name, parameter_list)
	local active_menu = self._open_menus[#self._open_menus]

	if active_menu then
		active_menu.logic:select_node(node_name, true, unpack(parameter_list or {}))
	end
end

-- Lines: 378 to 384
function MenuManager:back(queue, skip_nodes)
	local active_menu = self._open_menus[#self._open_menus]

	if active_menu then
		active_menu.input:back(queue, skip_nodes)
	end
end

-- Lines: 386 to 392
function MenuManager:force_back(queue, skip_nodes)
	local active_menu = self._open_menus[#self._open_menus]

	if active_menu then
		active_menu.input:force_back(queue, skip_nodes)
	end
end

-- Lines: 394 to 402
function MenuManager:close_menu(menu_name)
	self:post_event("menu_exit")

	if Global.game_settings.single_player and menu_name == "menu_pause" then
		Application:set_pause(false)
		self:post_event("game_resume")
		SoundDevice:set_rtpc("ingame_sound", 1)
	end

	MenuManager.super.close_menu(self, menu_name)
end

-- Lines: 404 to 407
function MenuManager:_menu_closed(menu_name)
	MenuManager.super._menu_closed(self, menu_name)
	self:deactivate()
end

-- Lines: 409 to 420
function MenuManager:close_all_menus()
	local names = {}

	for _, menu in pairs(self._open_menus) do
		table.insert(names, menu.name)
	end

	for _, name in ipairs(names) do
		self:close_menu(name)
	end

	if managers.menu_component then
		managers.menu_component:close()
	end
end

-- Lines: 422 to 428
function MenuManager:is_open(menu_name)
	for _, menu in ipairs(self._open_menus) do
		if menu.name == menu_name then
			return true
		end
	end

	return false
end

-- Lines: 431 to 437
function MenuManager:is_in_root(menu_name)
	for _, menu in ipairs(self._open_menus) do
		if menu.name == menu_name then
			return #menu.renderer._node_gui_stack == 1
		end
	end

	return false
end

-- Lines: 440 to 441
function MenuManager:is_pc_controller()
	return self:active_menu() and self:active_menu().input and self:active_menu().input._controller and self:active_menu().input._controller.TYPE == "pc" or managers.controller:get_default_wrapper_type() == "pc" or self:is_steam_controller()
end

-- Lines: 444 to 445
function MenuManager:is_steam_controller()
	return self:active_menu() and self:active_menu().input and self:active_menu().input._controller and self:active_menu().input._controller.TYPE == "steam" or managers.controller:get_default_wrapper_type() == "steam"
end

-- Lines: 448 to 493
function MenuManager:toggle_menu_state()
	if self._is_start_menu then
		return
	end

	if self._heister_interaction then
		return
	end

	if managers.hud:chat_focus() then
		return
	end

	if (not Application:editor() or Global.running_simulation) and not managers.system_menu:is_active() then
		if self:is_open("menu_pause") then
			if not self:is_pc_controller() or self:is_in_root("menu_pause") then
				self:close_menu("menu_pause")
				managers.savefile:save_setting(true)
			end
		elseif (not self:active_menu() or #self:active_menu().logic._node_stack == 1 or not managers.menu:active_menu().logic:selected_node() or managers.menu:active_menu().logic:selected_node():parameters().allow_pause_menu) and managers.menu_component:input_focus() ~= 1 then
			self:open_menu("menu_pause")

			if Global.game_settings.single_player then
				Application:set_pause(true)
				self:post_event("game_pause_in_game_menu")
				SoundDevice:set_rtpc("ingame_sound", 0)

				local player_unit = managers.player:player_unit()

				if alive(player_unit) and player_unit:movement():current_state().update_check_actions_paused then
					player_unit:movement():current_state():update_check_actions_paused()
				end
			end
		end
	end
end

-- Lines: 495 to 499
function MenuManager:push_to_talk(enabled)
	if managers.network and managers.network.voice_chat then
		managers.network.voice_chat:set_recording(enabled)
	end
end

-- Lines: 501 to 522
function MenuManager:toggle_chatinput()
	if Global.game_settings.single_player or Application:editor() then
		return
	end

	if SystemInfo:platform() ~= Idstring("WIN32") then
		return
	end

	if self:active_menu() then
		return
	end

	if not managers.network:session() then
		return
	end

	if managers.hud then
		managers.hud:toggle_chatinput()

		return true
	end
end

-- Lines: 524 to 529
function MenuManager:set_slot_voice(peer, peer_id, active)
	local kit_menu = managers.menu:get_menu("kit_menu")

	if kit_menu and kit_menu.renderer:is_open() then
		kit_menu.renderer:set_slot_voice(peer, peer_id, active)
	end
end

-- Lines: 531 to 544
function MenuManager:create_controller()
	if not self._controller then
		self._controller = managers.controller:create_controller("MenuManager", nil, false)
		local setup = self._controller:get_setup()
		local look_connection = setup:get_connection("look")
		self._look_multiplier = look_connection:get_multiplier()

		if not managers.savefile:is_active() then
			self._controller:enable()
		end
	end
end

-- Lines: 546 to 547
function MenuManager:get_controller()
	return self._controller
end

-- Lines: 550 to 568
function MenuManager:safefile_manager_active_changed(active)
	if self._controller then
		if active then
			self._controller:disable()
		else
			self._controller:enable()
		end
	end

	if not active then
		if self._delayed_open_savefile_menu_callback then
			self._delayed_open_savefile_menu_callback()
		end

		if self._save_game_callback then
			self._save_game_callback()
		end
	end
end

-- Lines: 570 to 575
function MenuManager:destroy_controller()
	if self._controller then
		self._controller:destroy()

		self._controller = nil
	end
end

-- Lines: 577 to 583
function MenuManager:activate()
	if #self._open_menus == 1 then
		managers.rumble:set_enabled(false)
		self._active_changed_callback_handler:dispatch(true)

		self._active = true
	end
end

-- Lines: 586 to 592
function MenuManager:deactivate()
	if #self._open_menus == 0 then
		managers.rumble:set_enabled(managers.user:get_setting("rumble"))
		self._active_changed_callback_handler:dispatch(false)

		self._active = false
	end
end

-- Lines: 595 to 596
function MenuManager:is_active()
	return self._active
end

-- Lines: 600 to 602
function MenuManager:add_active_changed_callback(callback_func)
	self._active_changed_callback_handler:add(callback_func)
end

-- Lines: 603 to 605
function MenuManager:remove_active_changed_callback(callback_func)
	self._active_changed_callback_handler:remove(callback_func)
end

-- Lines: 608 to 612
function MenuManager:video_ao_changed(name, old_value, new_value)
	if managers.environment_controller then
		managers.environment_controller:set_ao_setting(new_value)
	end
end

-- Lines: 616 to 620
function MenuManager:parallax_mapping_changed(name, old_value, new_value)
	if managers.environment_controller then
		managers.environment_controller:set_parallax_setting(new_value)
	end
end

-- Lines: 624 to 628
function MenuManager:video_aa_changed(name, old_value, new_value)
	if managers.environment_controller then
		managers.environment_controller:set_aa_setting(new_value)
	end
end

-- Lines: 632 to 636
function MenuManager:workshop_changed(name, old_value, new_value)
	if managers.workshop then
		managers.workshop:set_enabled(new_value)
	end
end

-- Lines: 639 to 642
function MenuManager:brightness_changed(name, old_value, new_value)
	local brightness = math.clamp(new_value, _G.tweak_data.menu.MIN_BRIGHTNESS, _G.tweak_data.menu.MAX_BRIGHTNESS)

	Application:set_brightness(brightness)
end

-- Lines: 646 to 648
function MenuManager:effect_quality_changed(name, old_value, new_value)
	World:effect_manager():set_quality(new_value)
end

-- Lines: 652 to 693
function MenuManager:set_mouse_sensitivity(zoomed)
	local zoom_sense = zoomed
	local sense_x, sense_y = nil

	if zoom_sense then
		sense_x = managers.user:get_setting("camera_zoom_sensitivity_x")
		sense_y = managers.user:get_setting("camera_zoom_sensitivity_y")
	else
		sense_x = managers.user:get_setting("camera_sensitivity_x")
		sense_y = managers.user:get_setting("camera_sensitivity_y")
	end

	if zoomed and managers.user:get_setting("enable_fov_based_sensitivity") and alive(managers.player:player_unit()) then
		local state = managers.player:player_unit():movement():current_state()

		if alive(state._equipped_unit) then
			local fov = managers.user:get_setting("fov_multiplier")
			local scale = (((state._equipped_unit:base():zoom() or 65) * (fov + 1)) / 2) / (65 * fov)
			sense_x = sense_x * scale
			sense_y = sense_y * scale
		end
	end

	local multiplier = Vector3()

	mvector3.set_x(multiplier, sense_x * self._look_multiplier.x)
	mvector3.set_y(multiplier, sense_y * self._look_multiplier.y)
	self._controller:get_setup():get_connection("look"):set_multiplier(multiplier)
	managers.controller:rebind_connections()
end

-- Lines: 695 to 713
function MenuManager:camera_sensitivity_x_changed(name, old_value, new_value)
	local setup = self._controller:get_setup()
	local look_connection = setup:get_connection("look")
	local look_multiplier = Vector3()

	mvector3.set(look_multiplier, look_connection:get_multiplier())
	mvector3.set_x(look_multiplier, self._look_multiplier.x * new_value)
	look_connection:set_multiplier(look_multiplier)
	managers.controller:rebind_connections()

	if alive(managers.player:player_unit()) then
		local plr_state = managers.player:player_unit():movement():current_state()
		local weapon_id = alive(plr_state._equipped_unit) and plr_state._equipped_unit:base():get_name_id()
		local stances = tweak_data.player.stances[weapon_id] or tweak_data.player.stances.default

		self:set_mouse_sensitivity(plr_state:in_steelsight() and stances.steelsight.zoom_fov)
	else
		self:set_mouse_sensitivity(false)
	end
end

-- Lines: 715 to 733
function MenuManager:camera_sensitivity_y_changed(name, old_value, new_value)
	local setup = self._controller:get_setup()
	local look_connection = setup:get_connection("look")
	local look_multiplier = Vector3()

	mvector3.set(look_multiplier, look_connection:get_multiplier())
	mvector3.set_y(look_multiplier, self._look_multiplier.y * new_value)
	look_connection:set_multiplier(look_multiplier)
	managers.controller:rebind_connections()

	if alive(managers.player:player_unit()) then
		local plr_state = managers.player:player_unit():movement():current_state()
		local weapon_id = alive(plr_state._equipped_unit) and plr_state._equipped_unit:base():get_name_id()
		local stances = tweak_data.player.stances[weapon_id] or tweak_data.player.stances.default

		self:set_mouse_sensitivity(plr_state:in_steelsight() and stances.steelsight.zoom_fov)
	else
		self:set_mouse_sensitivity(false)
	end
end

-- Lines: 735 to 756
function MenuManager:camera_sensitivity_changed(name, old_value, new_value)
	if self:is_console() then
		local setup = self._controller:get_setup()
		local look_connection = setup:get_connection("look")
		local look_mutliplier = new_value * self._look_multiplier

		look_connection:set_multiplier(look_mutliplier)
		managers.controller:rebind_connections()

		return
	end

	if alive(managers.player:player_unit()) then
		local plr_state = managers.player:player_unit():movement():current_state()
		local weapon_id = alive(plr_state._equipped_unit) and plr_state._equipped_unit:base():get_name_id()
		local stances = tweak_data.player.stances[weapon_id] or tweak_data.player.stances.default

		self:set_mouse_sensitivity(plr_state:in_steelsight() and stances.steelsight.zoom_fov)
	else
		self:set_mouse_sensitivity(false)
	end
end

-- Lines: 760 to 762
function MenuManager:rumble_changed(name, old_value, new_value)
	managers.rumble:set_enabled(new_value)
end

-- Lines: 764 to 778
function MenuManager:invert_camera_x_changed(name, old_value, new_value)
	local setup = self._controller:get_setup()
	local look_connection = setup:get_connection("look")
	local look_inversion = look_connection:get_inversion_unmodified()
	look_inversion = new_value and look_inversion:with_x(-1) or look_inversion:with_x(1)

	look_connection:set_inversion(look_inversion)
	managers.controller:rebind_connections()
end

-- Lines: 780 to 794
function MenuManager:invert_camera_y_changed(name, old_value, new_value)
	local setup = self._controller:get_setup()
	local look_connection = setup:get_connection("look")
	local look_inversion = look_connection:get_inversion_unmodified()
	look_inversion = new_value and look_inversion:with_y(-1) or look_inversion:with_y(1)

	look_connection:set_inversion(look_inversion)
	managers.controller:rebind_connections()
end

-- Lines: 796 to 849
function MenuManager:southpaw_changed(name, old_value, new_value)
	if self._controller.TYPE ~= "xbox360" and self._controller.TYPE ~= "ps3" and self._controller.TYPE ~= "xb1" and self._controller.TYPE ~= "ps4" then
		return
	end

	local setup = self._controller:get_setup()
	local look_connection = setup:get_connection("look")
	local move_connection = setup:get_connection("move")
	local look_input_name_list = look_connection:get_input_name_list()
	local move_input_name_list = move_connection:get_input_name_list()

	if new_value then
		move_connection:set_input_name_list({"right"})
		look_connection:set_input_name_list({"left"})
	else
		move_connection:set_input_name_list({"left"})
		look_connection:set_input_name_list({"right"})
	end

	managers.controller:rebind_connections()
end

-- Lines: 851 to 853
function MenuManager:dof_setting_changed(name, old_value, new_value)
	managers.environment_controller:set_dof_setting(new_value)
end

-- Lines: 855 to 857
function MenuManager:chromatic_setting_changed(name, old_value, new_value)
	managers.environment_controller:set_chromatic_enabled(new_value == "standard")
end

-- Lines: 859 to 864
function MenuManager:fps_limit_changed(name, old_value, new_value)
	if SystemInfo:platform() ~= Idstring("WIN32") then
		return
	end

	setup:set_fps_cap(new_value)
end

-- Lines: 866 to 870
function MenuManager:net_packet_throttling_changed(name, old_value, new_value)
	if managers.network then
		managers.network:set_packet_throttling_enabled(new_value)
	end
end

-- Lines: 872 to 875
function MenuManager:net_forwarding_changed(name, old_value, new_value)
	print("[Network:set_forwarding_enabled]", new_value)
	Network:set_forwarding_enabled(new_value)
end

-- Lines: 877 to 879
function MenuManager:net_use_compression_changed(name, old_value, new_value)
	Network:set_use_compression(new_value)
end

-- Lines: 881 to 884
function MenuManager:flush_gpu_command_queue_changed(name, old_value, new_value)
	RenderSettings.flush_gpu_command_queue = new_value
end

-- Lines: 887 to 902
function MenuManager:use_thq_weapon_parts_changed(name, old_value, new_value)
	if managers.weapon_factory then
		managers.weapon_factory:set_use_thq_weapon_parts(managers.user:get_setting("use_thq_weapon_parts"))
	end

	if not game_state_machine or game_state_machine:current_state_name() ~= "menu_main" then
		return
	end

	if managers.network and managers.network:session() then
		for _, peer in ipairs(managers.network:session():peers()) do
			peer:force_reload_outfit()
		end
	end
end

-- Lines: 904 to 906
function MenuManager:subtitle_changed(name, old_value, new_value)
	managers.subtitle:set_visible(new_value)
end

-- Lines: 909 to 913
function MenuManager:music_volume_changed(name, old_value, new_value)
	local tweak = _G.tweak_data.menu
	local percentage = (new_value - tweak.MIN_MUSIC_VOLUME) / (tweak.MAX_MUSIC_VOLUME - tweak.MIN_MUSIC_VOLUME)

	managers.music:set_volume(percentage)
end

-- Lines: 915 to 921
function MenuManager:sfx_volume_changed(name, old_value, new_value)
	local tweak = _G.tweak_data.menu
	local percentage = (new_value - tweak.MIN_SFX_VOLUME) / (tweak.MAX_SFX_VOLUME - tweak.MIN_SFX_VOLUME)

	SoundDevice:set_rtpc("option_sfx_volume", percentage * 100)
	managers.video:volume_changed(percentage)
end

-- Lines: 923 to 927
function MenuManager:voice_volume_changed(name, old_value, new_value)
	if managers.network and managers.network.voice_chat then
		managers.network.voice_chat:set_volume(new_value)
	end
end

-- Lines: 929 to 933
function MenuManager:lightfx_changed(name, old_value, new_value)
	if managers.network and managers.network.account then
		managers.network.account:set_lightfx()
	end
end

-- Lines: 936 to 938
function MenuManager:set_debug_menu_enabled(enabled)
	self._debug_menu_enabled = enabled
end

-- Lines: 939 to 940
function MenuManager:debug_menu_enabled()
	return self._debug_menu_enabled
end

-- Lines: 944 to 958
function MenuManager:add_back_button(new_node)
	new_node:delete_item("back")

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		text_id = "menu_back",
		back = true,
		previous_node = true
	}
	local new_item = new_node:create_item(nil, params)

	new_node:add_item(new_item)
end

-- Lines: 961 to 963
function MenuManager:reload()
	self:_recompile(managers.database:root_path() .. "assets\\guis\\")
end

-- Lines: 965 to 982
function MenuManager:_recompile(dir)
	local source_files = self:_source_files(dir)
	local t = {
		target_db_name = "all",
		send_idstrings = false,
		verbose = false,
		platform = string.lower(SystemInfo:platform():s()),
		source_root = managers.database:root_path() .. "/assets",
		target_db_root = Application:base_path() .. "assets",
		source_files = source_files
	}

	Application:data_compile(t)
	DB:reload()
	managers.database:clear_all_cached_indices()

	for _, file in ipairs(source_files) do
		PackageManager:reload(managers.database:entry_type(file):id(), managers.database:entry_path(file):id())
	end
end

-- Lines: 984 to 996
function MenuManager:_source_files(dir)
	local files = {}
	local entry_path = managers.database:entry_path(dir) .. "/"

	for _, file in ipairs(SystemFS:list(dir)) do
		table.insert(files, entry_path .. file)
	end

	for _, sub_dir in ipairs(SystemFS:list(dir, true)) do
		for _, file in ipairs(SystemFS:list(dir .. "/" .. sub_dir)) do
			table.insert(files, entry_path .. sub_dir .. "/" .. file)
		end
	end

	return files
end

-- Lines: 999 to 1010
function MenuManager:progress_resetted()
	local dialog_data = {
		title = "Dr Evil",
		text = "HAHA, your progress is gone!"
	}
	local no_button = {
		text = "Doh!",
		callback_func = callback(self, self, "_dialog_progress_resetted_ok")
	}
	dialog_data.button_list = {no_button}

	managers.system_menu:show(dialog_data)
end

-- Lines: 1012 to 1013
function MenuManager:_dialog_progress_resetted_ok()
end

-- Lines: 1015 to 1016
function MenuManager:is_console()
	return self:is_ps3() or self:is_x360() or self:is_ps4() or self:is_xb1()
end

-- Lines: 1019 to 1020
function MenuManager:is_ps3()
	return SystemInfo:platform() == Idstring("PS3")
end

-- Lines: 1023 to 1024
function MenuManager:is_ps4()
	return SystemInfo:platform() == Idstring("PS4")
end

-- Lines: 1028 to 1029
function MenuManager:is_x360()
	return SystemInfo:platform() == Idstring("X360")
end

-- Lines: 1032 to 1033
function MenuManager:is_xb1()
	return SystemInfo:platform() == Idstring("XB1")
end

-- Lines: 1036 to 1037
function MenuManager:is_na()
	return MenuManager.IS_NORTH_AMERICA
end

-- Lines: 1041 to 1061
function MenuManager:check_vr_dlc()
	local result = managers.dlc:chk_vr_dlc()
end

-- Lines: 1064 to 1123
function MenuManager:open_sign_in_menu(cb)
	if self:is_ps3() then
		managers.network.matchmake:register_callback("found_game", callback(self, self, "_cb_matchmake_found_game"))
		managers.network.matchmake:register_callback("player_joined", callback(self, self, "_cb_matchmake_player_joined"))
		self:open_ps3_sign_in_menu(cb)
	elseif self:is_ps4() then
		managers.network.matchmake:register_callback("found_game", callback(self, self, "_cb_matchmake_found_game"))
		managers.network.matchmake:register_callback("player_joined", callback(self, self, "_cb_matchmake_player_joined"))

		if PSN:is_fetching_status() then
			self:show_fetching_status_dialog({cancel_func = function ()
				PSN:fetch_cancel()
			end})

			
			-- Lines: 1076 to 1077
			local function f()
				self:open_ps4_sign_in_menu(cb)
			end

			PSN:set_matchmaking_callback("fetch_status", f)
			PSN:fetch_status()
		else
			self:open_ps4_sign_in_menu(cb)
		end
	elseif self:is_x360() then
		if managers.network.account:signin_state() == "signed in" and managers.user:check_privilege(nil, "multiplayer_sessions") then
			self:open_x360_sign_in_menu(cb)
		else
			self:show_err_not_signed_in_dialog()
		end
	elseif self:is_xb1() then
		self._queued_privilege_check_cb = nil

		managers.system_menu:close("fetching_status")

		if managers.network.account:signin_state() == "signed in" then
			if managers.user:check_privilege(nil, "multiplayer_sessions", callback(self, self, "_check_privilege_callback")) then
				self:show_fetching_status_dialog({cancel_func = function ()
					self._queued_privilege_check_cb = nil
				end})

				self._queued_privilege_check_cb = cb
			else
				self:show_err_not_signed_in_dialog()
			end
		else
			self:show_err_not_signed_in_dialog()
		end
	elseif managers.network.account:signin_state() == "signed in" then
		cb(true)
	else
		self:show_err_not_signed_in_dialog()
	end
end

-- Lines: 1125 to 1138
function MenuManager:_check_privilege_callback(is_success)
	if self._queued_privilege_check_cb then
		local cb = self._queued_privilege_check_cb

		managers.system_menu:close("fetching_status")

		self._queued_privilege_check_cb = nil

		if is_success then
			self:open_xb1_sign_in_menu(cb)
		else
			self:show_err_not_signed_in_dialog()
		end
	end
end

-- Lines: 1140 to 1161
function MenuManager:open_ps3_sign_in_menu(cb)
	local success = true

	if managers.network.account:signin_state() == "not signed in" then
		managers.network.account:show_signin_ui()

		if managers.network.account:signin_state() == "signed in" then
			print("SIGNED IN")

			if #PSN:get_world_list() == 0 then
				managers.network.matchmake:getting_world_list()
			end

			success = self:_enter_online_menus()
		else
			success = false
		end
	else
		if #PSN:get_world_list() == 0 then
			managers.network.matchmake:getting_world_list()
			PSN:init_matchmaking()
		end

		success = self:_enter_online_menus()
	end

	cb(success)
end

-- Lines: 1163 to 1198
function MenuManager:open_ps4_sign_in_menu(cb)
	if managers.system_menu:is_active_by_id("fetching_status") then
		managers.system_menu:close("fetching_status")
	end

	local success = true

	if PSN:needs_update() then
		Global.boot_invite = nil
		success = false

		self:show_err_new_patch()
	elseif not PSN:cable_connected() then
		self:show_internet_connection_required()

		success = false
	elseif managers.network.account:signin_state() == "not signed in" then
		managers.network.account:show_signin_ui()

		if managers.network.account:signin_state() == "signed in" then
			print("SIGNED IN")

			if #PSN:get_world_list() == 0 then
				managers.network.matchmake:getting_world_list()
			end

			success = self:_enter_online_menus()
		else
			success = false
		end
	elseif PSN:user_age() < MenuManager.ONLINE_AGE and PSN:parental_control_settings_active() then
		Global.boot_invite = nil
		success = false

		self:show_err_under_age()
	else
		if #PSN:get_world_list() == 0 then
			managers.network.matchmake:getting_world_list()
			PSN:init_matchmaking()
		end

		success = self:_enter_online_menus()
	end

	cb(success)
end

-- Lines: 1201 to 1204
function MenuManager:open_x360_sign_in_menu(cb)
	local success = self:_enter_online_menus_x360()

	cb(success)
end

-- Lines: 1206 to 1209
function MenuManager:open_xb1_sign_in_menu(cb)
	local success = self:_enter_online_menus_xb1()

	cb(success)
end

-- Lines: 1213 to 1224
function MenuManager:external_enter_online_menus()
	if self:is_ps3() then
		self:_enter_online_menus()
	elseif self:is_ps4() then
		self:_enter_online_menus_ps4()
	elseif self:is_x360() then
		self:_enter_online_menus_x360()
	elseif self:is_xb1() then
		self:_enter_online_menus_xb1()
	end
end

-- Lines: 1226 to 1250
function MenuManager:_enter_online_menus()
	if PSN:user_age() < MenuManager.ONLINE_AGE and PSN:parental_control_settings_active() then
		Global.boot_invite = nil

		self:show_err_under_age()

		return false
	else
		local res = PSN:check_plus()

		if res == 1 then
			managers.platform:set_presence("Signed_in")
			print("voice chat from enter_online_menus")
			managers.network:ps3_determine_voice(false)
			managers.network.voice_chat:check_status_information()
			PSN:set_online_callback(callback(self, self, "ps3_disconnect"))

			return true
		elseif res ~= 2 then
			self:show_err_not_signed_in_dialog()
		end
	end

	return false
end

-- Lines: 1253 to 1260
function MenuManager:_enter_online_menus_ps4()
	managers.platform:set_presence("Signed_in")
	print("voice chat from enter_online_menus_ps4")
	managers.network:ps3_determine_voice(false)
	managers.network.voice_chat:check_status_information()
	PSN:set_online_callback(callback(self, self, "ps3_disconnect"))
end

-- Lines: 1263 to 1268
function MenuManager:_enter_online_menus_x360()
	managers.platform:set_presence("Signed_in")
	managers.user:on_entered_online_menus()

	return true
end

-- Lines: 1271 to 1276
function MenuManager:_enter_online_menus_xb1()
	managers.platform:set_presence("Signed_in")
	managers.user:on_entered_online_menus()

	return true
end

-- Lines: 1281 to 1291
function MenuManager:psn_disconnected()
	if managers.network:session() then
		managers.network:queue_stop_network()
		managers.platform:set_presence("Idle")
		managers.network.matchmake:leave_game()
		managers.network.friends:psn_disconnected()
		managers.network.voice_chat:destroy_voice(true)
		self:exit_online_menues()
	end

	self:show_mp_disconnected_internet_dialog({})
end

-- Lines: 1294 to 1303
function MenuManager:steam_disconnected()
	if managers.network:session() then
		managers.network:queue_stop_network()
		managers.platform:set_presence("Idle")
		managers.network.matchmake:leave_game()
		managers.network.voice_chat:destroy_voice(true)
		self:exit_online_menues()
	end

	self:show_mp_disconnected_internet_dialog({})
end

-- Lines: 1305 to 1316
function MenuManager:xbox_disconnected()
	print("xbox_disconnected()")

	if managers.network:session() or managers.user:is_online_menu() then
		managers.network:queue_stop_network()
		managers.platform:set_presence("Idle")
		managers.network.matchmake:leave_game()
		managers.network.voice_chat:destroy_voice(true)
	end

	self:exit_online_menues()
	managers.user:on_exit_online_menus()
	self:show_mp_disconnected_internet_dialog({})
end

-- Lines: 1319 to 1337
function MenuManager:ps3_disconnect(connected)
	if not connected then
		managers.network:queue_stop_network()
		managers.platform:set_presence("Idle")
		managers.network.matchmake:leave_game()
		managers.network.matchmake:psn_disconnected()
		managers.network.friends:psn_disconnected()
		managers.network.voice_chat:destroy_voice(true)
		self:show_disconnect_message(true)
	end

	if managers.menu_component then
		-- Nothing
	end
end

-- Lines: 1339 to 1367
function MenuManager:show_disconnect_message(requires_signin)
	if self._showing_disconnect_message then
		return
	end

	if self:is_ps3() then
		PS3:abort_display_keyboard()
	end

	self:exit_online_menues()

	self._showing_disconnect_message = true

	self:show_mp_disconnected_internet_dialog({ok_func = function ()
		self._showing_disconnect_message = nil
	end})
end

-- Lines: 1370 to 1377
function MenuManager:created_lobby()
	Global.game_settings.single_player = false

	managers.network:host_game()
	Network:set_multiplayer(true)
	Network:set_server()
	self:on_enter_lobby()
end

-- Lines: 1380 to 1412
function MenuManager:exit_online_menues()
	local must_show_controller_disconnect = nil

	if Global.controller_manager.connect_controller_dialog_visible then
		must_show_controller_disconnect = true

		managers.controller:_close_controller_changed_dialog(true)
	end

	managers.system_menu:force_close_all()
	self:_close_lobby_menu_components()

	if self:active_menu() then
		self:close_menu(self:active_menu().name)
	end

	self:open_menu("menu_main")

	if not managers.menu:is_pc_controller() then
		-- Nothing
	end

	if must_show_controller_disconnect then
		managers.controller:_show_controller_changed_dialog()
	end
end

-- Lines: 1414 to 1422
function MenuManager:leave_online_menu()
	if self:is_ps3() or self:is_ps4() then
		PSN:set_online_callback(callback(self, self, "refresh_player_profile_gui"))
	end

	if self:is_x360() or self:is_xb1() then
		managers.user:on_exit_online_menus()
	end
end

-- Lines: 1424 to 1428
function MenuManager:refresh_player_profile_gui()
	if managers.menu_component then
		managers.menu_component:refresh_player_profile_gui()
	end
end

-- Lines: 1430 to 1436
function MenuManager:_close_lobby_menu_components()
	managers.menu_scene:hide_all_lobby_characters()
	managers.menu_component:remove_game_chat()
	managers.menu_component:close_lobby_profile_gui()
	managers.menu_component:close_contract_gui()
	managers.menu_component:close_chat_gui()
end

-- Lines: 1439 to 1467
function MenuManager:on_leave_lobby()
	local skip_destroy_matchmaking = self:is_ps3() or self:is_ps4()

	managers.network:prepare_stop_network(skip_destroy_matchmaking)

	if self:is_x360() or self:is_xb1() then
		managers.user:on_exit_online_menus()
	end

	managers.platform:set_rich_presence("Idle")
	managers.menu:close_menu("menu_main")
	managers.menu:open_menu("menu_main")
	managers.network.matchmake:leave_game()
	managers.network.voice_chat:destroy_voice()
	self:_close_lobby_menu_components()

	if Global.game_settings.difficulty == "overkill_145" and managers.experience:current_level() < 145 then
		Global.game_settings.difficulty = "overkill"
	end

	managers.job:deactivate_current_job()
	managers.gage_assignment:deactivate_assignments()
	managers.crime_spree:on_left_lobby()
end

-- Lines: 1469 to 1519
function MenuManager:show_global_success(node)
	local node_gui = nil

	if not node then
		local stack = managers.menu:active_menu().renderer._node_gui_stack
		node_gui = stack[#stack]

		if not node_gui.set_mini_info then
			print("No mini info to set!")

			return
		end
	end

	if not managers.network.account.get_win_ratio then
		if node_gui then
			node_gui:set_mini_info("")
		end

		return
	end

	local rate = managers.network.account:get_win_ratio(Global.game_settings.difficulty, Global.game_settings.level_id)

	if not rate then
		if node_gui then
			node_gui:set_mini_info("")
		end

		return
	end

	rate = rate * 100
	local rate_str = nil
	rate_str = rate >= 10 and string.format("%.0f", rate) or string.format("%.1f", rate)
	local diff_str = string.upper(managers.localization:text("menu_difficulty_" .. Global.game_settings.difficulty))
	local heist_str = string.upper(managers.localization:text(tweak_data.levels[Global.game_settings.level_id].name_id))
	rate_str = managers.localization:text("menu_global_success", {
		COUNT = rate_str,
		HEIST = heist_str,
		DIFFICULTY = diff_str
	})

	if node then
		node.mini_info = rate_str
	else
		node_gui:set_mini_info(rate_str)
	end
end

-- Lines: 1521 to 1527
function MenuManager:change_theme(theme)
	managers.user:set_setting("menu_theme", theme)

	for _, menu in ipairs(self._open_menus) do
		menu.renderer:refresh_theme()
	end
end

-- Lines: 1533 to 1545
function MenuManager:on_storage_changed(old_user_data, user_data)
	if old_user_data and old_user_data.storage_id and user_data and user_data.signin_state ~= "not_signed_in" and not old_user_data.has_signed_out and managers.user:get_platform_id() == user_data.platform_id and not self:is_xb1() then
		self:show_storage_removed_dialog()
		print("!!!!!!!!!!!!!!!!!!! STORAGE LOST")
		managers.savefile:break_loading_sequence()

		if game_state_machine:current_state().on_storage_changed then
			game_state_machine:current_state():on_storage_changed(old_user_data, user_data)
		end
	end
end

-- Lines: 1550 to 1559
function MenuManager:on_user_changed(old_user_data, user_data)
	if old_user_data and (old_user_data.signin_state ~= "not_signed_in" or not old_user_data.username) then
		print("MenuManager:on_user_changed(), clear save data")

		if game_state_machine:current_state().on_user_changed then
			game_state_machine:current_state():on_user_changed(old_user_data, user_data)
		end

		self:reset_all_loaded_data()
	end
end

-- Lines: 1561 to 1566
function MenuManager:reset_all_loaded_data()
	self:do_clear_progress()
	managers.user:reset_setting_map()
	managers.statistics:reset()
	managers.achievment:on_user_signout()
end

-- Lines: 1568 to 1604
function MenuManager:do_clear_progress()
	managers.skilltree:reset()
	managers.experience:reset()
	managers.money:reset()
	managers.blackmarket:reset()
	managers.dlc:on_reset_profile()
	managers.mission:on_reset_profile()
	managers.job:reset_job_heat()
	managers.job:reset_ghost_bonus()
	managers.infamy:reset()
	managers.gage_assignment:reset()
	managers.crimenet:reset_seed()
	managers.custom_safehouse:reset()
	managers.tango:reset()
	managers.generic_side_jobs:reset()
	managers.story:reset_all()

	if Global.game_settings.difficulty == "overkill_145" then
		Global.game_settings.difficulty = "overkill"
	end

	managers.user:set_setting("mask_set", "clowns")

	if SystemInfo:distribution() == Idstring("STEAM") then
		managers.statistics:publish_level_to_steam()
	end
end

-- Lines: 1607 to 1621
function MenuManager:on_user_sign_out()
	print("MenuManager:on_user_sign_out()")

	if managers.network:session() then
		managers.network:queue_stop_network()
		managers.platform:set_presence("Idle")

		if managers.network:session():_local_peer_in_lobby() then
			managers.network.matchmake:leave_game()
		else
			managers.network.matchmake:destroy_game()
		end

		managers.network.voice_chat:destroy_voice(true)
	end
end

-- Lines: 1627 to 1630
function MenuCallbackHandler:init()
	MenuCallbackHandler.super.init(self)

	self._sound_source = SoundDevice:create_source("MenuCallbackHandler")
end

-- Lines: 1632 to 1635
function MenuCallbackHandler:trial_buy()
	print("[MenuCallbackHandler:trial_buy]")
	managers.dlc:buy_full_game()
end

-- Lines: 1637 to 1640
function MenuCallbackHandler:dlc_buy_pc()
	print("[MenuCallbackHandler:dlc_buy_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1642 to 1649
function MenuCallbackHandler:dlc_buy_gage_pack_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1651 to 1658
function MenuCallbackHandler:dlc_buy_big_bank_pc()
	print("[MenuCallbackHandler:dlc_buy_big_bank_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1660 to 1667
function MenuCallbackHandler:dlc_buy_gage_pack_historical_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_historical_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1669 to 1676
function MenuCallbackHandler:dlc_buy_hl_miami_pc()
	print("[MenuCallbackHandler:dlc_buy_hl_miami_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1678 to 1685
function MenuCallbackHandler:dlc_buy_gage_pack_assault_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_assault_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1687 to 1694
function MenuCallbackHandler:dlc_buy_gage_pack_shotgun_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_shotgun_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1696 to 1703
function MenuCallbackHandler:dlc_buy_gage_pack_snp_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_snp_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1705 to 1712
function MenuCallbackHandler:dlc_buy_gage_pack_jobs_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_jobs_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1714 to 1721
function MenuCallbackHandler:dlc_buy_gage_pack_lmg_pc()
	print("[MenuCallbackHandler:dlc_buy_gage_pack_lmg_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1723 to 1730
function MenuCallbackHandler:dlc_buy_armadillo_pc()
	print("[MenuCallbackHandler:dlc_buy_armadillo_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1732 to 1739
function MenuCallbackHandler:dlc_buy_character_pack_clover_pc()
	print("[MenuCallbackHandler:dlc_buy_character_pack_clover_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1741 to 1748
function MenuCallbackHandler:dlc_buy_character_pack_dragan_pc()
	print("[MenuCallbackHandler:dlc_buy_character_pack_dragan_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1750 to 1757
function MenuCallbackHandler:dlc_buy_hope_diamond_pc()
	print("[MenuCallbackHandler:dlc_buy_hope_diamond_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1759 to 1766
function MenuCallbackHandler:dlc_buy_the_bomb_pc()
	print("[MenuCallbackHandler:dlc_buy_the_bomb_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1768 to 1775
function MenuCallbackHandler:dlc_buy_akm4_pack_pc()
	print("[MenuCallbackHandler:dlc_buy_akm4_pack_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1777 to 1784
function MenuCallbackHandler:dlc_buy_overkill_pack_pc()
	print("[MenuCallbackHandler:dlc_buy_overkill_pack_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1786 to 1793
function MenuCallbackHandler:dlc_buy_complete_overkill_pack_pc()
	print("[MenuCallbackHandler:dlc_buy_complete_overkill_pack_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1795 to 1802
function MenuCallbackHandler:dlc_buy_bbq_pc()
	print("[MenuCallbackHandler:dlc_buy_bbq_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1804 to 1811
function MenuCallbackHandler:dlc_buy_west_pc()
	print("[MenuCallbackHandler:dlc_buy_west_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1813 to 1820
function MenuCallbackHandler:dlc_buy_arena_pc()
	print("[MenuCallbackHandler:dlc_buy_arena_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1822 to 1829
function MenuCallbackHandler:dlc_buy_character_pack_sokol_pc()
	print("[MenuCallbackHandler:dlc_buy_character_pack_sokol_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1831 to 1838
function MenuCallbackHandler:dlc_buy_kenaz_pc()
	print("[MenuCallbackHandler:dlc_buy_kenaz_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1840 to 1847
function MenuCallbackHandler:dlc_buy_turtles_pc()
	print("[MenuCallbackHandler:dlc_buy_turtles_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1849 to 1856
function MenuCallbackHandler:dlc_buy_dragon_pc()
	print("[MenuCallbackHandler:dlc_buy_dragon_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1858 to 1865
function MenuCallbackHandler:dlc_buy_steel_pc()
	print("[MenuCallbackHandler:dlc_buy_steel_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1867 to 1874
function MenuCallbackHandler:dlc_buy_berry_pc()
	print("[MenuCallbackHandler:dlc_buy_berry_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1877 to 1884
function MenuCallbackHandler:dlc_buy_peta_pc()
	print("[MenuCallbackHandler:dlc_buy_peta_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1888 to 1895
function MenuCallbackHandler:dlc_buy_pal_pc()
	print("[MenuCallbackHandler:dlc_buy_pal_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1899 to 1906
function MenuCallbackHandler:dlc_buy_coco_pc()
	print("[MenuCallbackHandler:dlc_buy_coco_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1910 to 1917
function MenuCallbackHandler:dlc_buy_opera_pc()
	print("[MenuCallbackHandler:dlc_buy_opera_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1921 to 1928
function MenuCallbackHandler:dlc_buy_wild_pc()
	print("[MenuCallbackHandler:dlc_buy_wild_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1932 to 1939
function MenuCallbackHandler:dlc_buy_born_pc()
	print("[MenuCallbackHandler:dlc_buy_born_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1943 to 1950
function MenuCallbackHandler:dlc_buy_pim_pc()
	print("[MenuCallbackHandler:dlc_buy_pim_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1954 to 1961
function MenuCallbackHandler:dlc_buy_tango_pc()
	print("[MenuCallbackHandler:dlc_buy_tango_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1965 to 1972
function MenuCallbackHandler:dlc_buy_friend_pc()
	print("[MenuCallbackHandler:dlc_buy_friend_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1976 to 1983
function MenuCallbackHandler:dlc_buy_chico_pc()
	print("[MenuCallbackHandler:dlc_buy_chico_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1987 to 1994
function MenuCallbackHandler:dlc_buy_rvd_pc()
	print("[MenuCallbackHandler:dlc_buy_rvd_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 1998 to 2005
function MenuCallbackHandler:dlc_buy_spa_pc()
	print("[MenuCallbackHandler:dlc_buy_spa_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 2009 to 2016
function MenuCallbackHandler:dlc_buy_grv_pc()
	print("[MenuCallbackHandler:dlc_buy_grv_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 2020 to 2027
function MenuCallbackHandler:dlc_buy_amp_pc()
	print("[MenuCallbackHandler:dlc_buy_amp_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 2031 to 2038
function MenuCallbackHandler:dlc_buy_mp2_pc()
	print("[MenuCallbackHandler:dlc_buy_mp2_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 2053 to 2060
function MenuCallbackHandler:dlc_buy_max_pc()
	print("[MenuCallbackHandler:dlc_buy_max_pc]")
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 2064 to 2066
function MenuCallbackHandler:dlc_buy_ecp_pc()
	Steam:overlay_activate("store", 758420)
end

-- Lines: 2069 to 2072
function MenuCallbackHandler:dlc_buy_ps3()
	print("[MenuCallbackHandler:dlc_buy_ps3]")
	managers.dlc:buy_product("dlc1")
end

-- Lines: 2074 to 2075
function MenuCallbackHandler:has_full_game()
	return managers.dlc:has_full_game()
end

-- Lines: 2078 to 2079
function MenuCallbackHandler:is_trial()
	return managers.dlc:is_trial()
end

-- Lines: 2082 to 2083
function MenuCallbackHandler:is_not_trial()
	return not self:is_trial()
end

-- Lines: 2086 to 2087
function MenuCallbackHandler:has_preorder()
	return managers.dlc:is_dlc_unlocked("preorder")
end

-- Lines: 2090 to 2091
function MenuCallbackHandler:not_has_preorder()
	return not managers.dlc:is_dlc_unlocked("preorder")
end

-- Lines: 2094 to 2095
function MenuCallbackHandler:has_all_dlcs()
	return true
end

-- Lines: 2098 to 2106
function MenuCallbackHandler:is_overlay_enabled()
	if SystemInfo:platform() ~= Idstring("WIN32") then
		return false
	end

	return true
end

-- Lines: 2110 to 2115
function MenuCallbackHandler:is_installed()
	if SystemInfo:platform() == Idstring("WIN32") then
		return true
	end

	local is_installing, install_progress = managers.dlc:is_installing()

	return not is_installing
end

-- Lines: 2118 to 2120
function MenuCallbackHandler:show_game_is_installing_menu()
	managers.menu:show_game_is_installing_menu()
end

-- Lines: 2122 to 2123
function MenuCallbackHandler:bang_active()
	return true
end

-- Lines: 2133 to 2135
function MenuCallbackHandler:choice_crimenet_lobby_job_plan(item)
	Global.game_settings.job_plan = item:value()
end

-- Lines: 2137 to 2141
function MenuCallbackHandler:choice_lobby_job_plan(item)
	Global.game_settings.job_plan = item:value()

	self:update_matchmake_attributes()
	self:_on_host_setting_updated()
end

-- Lines: 2153 to 2154
function MenuCallbackHandler:_on_host_setting_updated()
end

-- Lines: 2156 to 2166
function MenuCallbackHandler:choice_job_plan_filter(item)
	local job_plan_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("job_plan") == job_plan_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("job_plan", job_plan_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_tactic", job_plan_filter)
end

-- Lines: 2170 to 2240
function MenuCallbackHandler:is_dlc_latest_locked(check_dlc)
	local dlcs = {
		"ecp",
		"max",
		"mp2",
		"amp",
		"grv",
		"rvd",
		"spa",
		"friend",
		"chico",
		"tango",
		"pim",
		"born",
		"wild",
		"opera",
		"pal",
		"peta",
		"berry",
		"steel",
		"dragon",
		"turtles",
		"character_pack_sokol",
		"kenaz",
		"arena",
		"west",
		"bbq",
		"overkill_pack",
		"akm4_pack",
		"character_pack_dragan",
		"the_bomb",
		"character_pack_clover",
		"hope_diamond",
		"gage_pack_historical",
		"hl_miami",
		"gage_pack_assault",
		"gage_pack_shotgun",
		"big_bank",
		"gage_pack_snp",
		"gage_pack_jobs",
		"gage_pack_lmg",
		"gage_pack",
		"armored_transport"
	}
	local has_dlc = nil

	for _, dlc in ipairs(dlcs) do
		has_dlc = managers.dlc:is_dlc_unlocked(dlc)

		if not has_dlc then
			return dlc == check_dlc
		end
	end

	return false
end

-- Lines: 2244 to 2248
function MenuCallbackHandler:visible_callback_armored_transport(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("armored_transport")
end

-- Lines: 2252 to 2256
function MenuCallbackHandler:visible_callback_gage_pack(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack")
end

-- Lines: 2260 to 2264
function MenuCallbackHandler:visible_callback_gage_pack_lmg(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack_lmg")
end

-- Lines: 2268 to 2272
function MenuCallbackHandler:visible_callback_gage_pack_jobs(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack_jobs")
end

-- Lines: 2276 to 2280
function MenuCallbackHandler:visible_callback_gage_pack_snp(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack_snp")
end

-- Lines: 2284 to 2288
function MenuCallbackHandler:visible_callback_gage_pack_shotgun(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack_shotgun")
end

-- Lines: 2292 to 2296
function MenuCallbackHandler:visible_callback_gage_pack_assault(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack_assault")
end

-- Lines: 2300 to 2304
function MenuCallbackHandler:visible_callback_hl_miami(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("hl_miami")
end

-- Lines: 2308 to 2312
function MenuCallbackHandler:visible_callback_big_bank(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("big_bank")
end

-- Lines: 2316 to 2320
function MenuCallbackHandler:visible_callback_gage_pack_historical(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("gage_pack_historical")
end

-- Lines: 2324 to 2328
function MenuCallbackHandler:visible_callback_character_pack_clover(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("character_pack_clover")
end

-- Lines: 2332 to 2336
function MenuCallbackHandler:visible_callback_character_pack_dragan(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("character_pack_dragan")
end

-- Lines: 2340 to 2344
function MenuCallbackHandler:visible_callback_hope_diamond(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("hope_diamond")
end

-- Lines: 2348 to 2352
function MenuCallbackHandler:visible_callback_the_bomb(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("the_bomb")
end

-- Lines: 2356 to 2360
function MenuCallbackHandler:visible_callback_akm4_pack(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("akm4_pack")
end

-- Lines: 2364 to 2368
function MenuCallbackHandler:visible_callback_overkill_pack(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("overkill_pack")
end

-- Lines: 2372 to 2376
function MenuCallbackHandler:visible_callback_complete_overkill_pack(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("complete_overkill_pack")
end

-- Lines: 2380 to 2384
function MenuCallbackHandler:visible_callback_bbq(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("bbq")
end

-- Lines: 2388 to 2392
function MenuCallbackHandler:visible_callback_west(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("west")
end

-- Lines: 2396 to 2400
function MenuCallbackHandler:visible_callback_arena(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("arena")
end

-- Lines: 2404 to 2408
function MenuCallbackHandler:visible_callback_character_pack_sokol(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("character_pack_sokol")
end

-- Lines: 2412 to 2416
function MenuCallbackHandler:visible_callback_kenaz(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("kenaz")
end

-- Lines: 2420 to 2424
function MenuCallbackHandler:visible_callback_turtles(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("turtles")
end

-- Lines: 2428 to 2432
function MenuCallbackHandler:visible_callback_dragon(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("dragon")
end

-- Lines: 2436 to 2440
function MenuCallbackHandler:visible_callback_steel(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("steel")
end

-- Lines: 2444 to 2448
function MenuCallbackHandler:visible_callback_berry(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("berry")
end

-- Lines: 2453 to 2457
function MenuCallbackHandler:visible_callback_peta(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("peta")
end

-- Lines: 2462 to 2466
function MenuCallbackHandler:visible_callback_pal(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("pal")
end

-- Lines: 2482 to 2486
function MenuCallbackHandler:visible_callback_opera(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("opera")
end

-- Lines: 2491 to 2495
function MenuCallbackHandler:visible_callback_born(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("born")
end

-- Lines: 2500 to 2504
function MenuCallbackHandler:visible_callback_wild(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("wild")
end

-- Lines: 2509 to 2513
function MenuCallbackHandler:visible_callback_pim(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("pim")
end

-- Lines: 2518 to 2522
function MenuCallbackHandler:visible_callback_tango(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("tango")
end

-- Lines: 2527 to 2531
function MenuCallbackHandler:visible_callback_friend(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("friend")
end

-- Lines: 2536 to 2540
function MenuCallbackHandler:visible_callback_chico(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("chico")
end

-- Lines: 2545 to 2549
function MenuCallbackHandler:visible_callback_rvd(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("rvd")
end

-- Lines: 2554 to 2558
function MenuCallbackHandler:visible_callback_spa(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("spa")
end

-- Lines: 2563 to 2567
function MenuCallbackHandler:visible_callback_grv(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("grv")
end

-- Lines: 2572 to 2576
function MenuCallbackHandler:visible_callback_amp(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("amp")
end

-- Lines: 2581 to 2585
function MenuCallbackHandler:visible_callback_mp2(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("mp2")
end

-- Lines: 2599 to 2603
function MenuCallbackHandler:visible_callback_max(item)
	item:set_parameter("text_id", "menu_dlc_buy_ue")
	item:set_parameter("help_id", "menu_dlc_buy_ue_help")

	return self:is_dlc_latest_locked("max")
end

-- Lines: 2607 to 2608
function MenuCallbackHandler:visible_callback_ecp(item)
	return self:is_dlc_latest_locked("ecp")
end

-- Lines: 2624 to 2625
function MenuCallbackHandler:not_has_all_dlcs()
	return not self:has_all_dlcs()
end

-- Lines: 2628 to 2629
function MenuCallbackHandler:reputation_check(data)
	return data:value() <= managers.experience:current_level()
end

-- Lines: 2632 to 2633
function MenuCallbackHandler:non_overkill_145(data)
	return true
end

-- Lines: 2636 to 2637
function MenuCallbackHandler:to_be_continued()
	return true
end

-- Lines: 2640 to 2641
function MenuCallbackHandler:is_level_145()
	return managers.experience:current_level() >= 145
end

-- Lines: 2644 to 2645
function MenuCallbackHandler:is_level_100()
	return managers.experience:current_level() >= 100
end

-- Lines: 2648 to 2649
function MenuCallbackHandler:is_level_50()
	return managers.experience:current_level() >= 50
end

-- Lines: 2652 to 2653
function MenuCallbackHandler:is_win32()
	return SystemInfo:platform() == Idstring("WIN32")
end

-- Lines: 2660 to 2661
function MenuCallbackHandler:is_actually_win32()
	return SystemInfo:platform() == Idstring("WIN32")
end

-- Lines: 2666 to 2667
function MenuCallbackHandler:is_win32_pc()
	return SystemInfo:platform() == Idstring("WIN32") and not self:is_vr()
end

-- Lines: 2673 to 2674
function MenuCallbackHandler:is_steam()
	return SystemInfo:distribution() == Idstring("STEAM")
end

-- Lines: 2677 to 2678
function MenuCallbackHandler:is_fullscreen()
	return managers.viewport:is_fullscreen()
end

-- Lines: 2681 to 2682
function MenuCallbackHandler:voice_enabled()
	return self:is_ps3() or self:is_win32() and managers.network and managers.network.voice_chat and managers.network.voice_chat:enabled()
end

-- Lines: 2685 to 2686
function MenuCallbackHandler:customize_controller_enabled()
	return true
end

-- Lines: 2689 to 2690
function MenuCallbackHandler:is_win32_not_lan()
	return SystemInfo:platform() == Idstring("WIN32") and not Global.game_settings.playing_lan
end

-- Lines: 2693 to 2694
function MenuCallbackHandler:is_console()
	return self:is_ps3() or self:is_x360() or self:is_ps4() or self:is_xb1()
end

-- Lines: 2697 to 2698
function MenuCallbackHandler:is_ps3()
	return SystemInfo:platform() == Idstring("PS3")
end

-- Lines: 2701 to 2702
function MenuCallbackHandler:is_ps4()
	return SystemInfo:platform() == Idstring("PS4")
end

-- Lines: 2705 to 2706
function MenuCallbackHandler:is_x360()
	return SystemInfo:platform() == Idstring("X360")
end

-- Lines: 2709 to 2710
function MenuCallbackHandler:is_xb1()
	return SystemInfo:platform() == Idstring("XB1")
end

-- Lines: 2713 to 2714
function MenuCallbackHandler:is_not_xb1()
	return not self:is_xb1()
end

-- Lines: 2717 to 2718
function MenuCallbackHandler:is_not_x360()
	return not self:is_x360()
end

-- Lines: 2721 to 2722
function MenuCallbackHandler:is_not_xbox()
	return not self:is_x360()
end

-- Lines: 2725 to 2726
function MenuCallbackHandler:is_not_x360_or_xb1()
	return not self:is_x360() and not self:is_xb1()
end

-- Lines: 2729 to 2730
function MenuCallbackHandler:is_not_nextgen()
	return not self:is_xb1() and not self:is_ps4()
end

-- Lines: 2733 to 2734
function MenuCallbackHandler:is_na()
	return MenuManager.IS_NORTH_AMERICA
end

-- Lines: 2737 to 2738
function MenuCallbackHandler:has_dropin()
	return NetworkManager.DROPIN_ENABLED
end

-- Lines: 2742 to 2743
function MenuCallbackHandler:is_server()
	return Network:is_server()
end

-- Lines: 2746 to 2747
function MenuCallbackHandler:is_not_server()
	return not self:is_server()
end

-- Lines: 2750 to 2751
function MenuCallbackHandler:is_online()
	return managers.network.account:signin_state() == "signed in"
end

-- Lines: 2754 to 2755
function MenuCallbackHandler:is_singleplayer()
	return Global.game_settings.single_player
end

-- Lines: 2758 to 2759
function MenuCallbackHandler:is_multiplayer()
	return not Global.game_settings.single_player
end

-- Lines: 2768 to 2769
function MenuCallbackHandler:is_modded_client()
	return rawget(_G, "BLT") ~= nil
end

-- Lines: 2777 to 2778
function MenuCallbackHandler:is_not_modded_client()
	return rawget(_G, "BLT") == nil
end

-- Lines: 2782 to 2800
function MenuCallbackHandler:build_mods_list()
	local mods = {}

	if self:is_modded_client() then
		local BLT = rawget(_G, "BLT")

		if BLT and BLT.Mods and BLT.Mods then
			for _, mod in ipairs(BLT.Mods:Mods()) do
				local data = {
					mod:GetName(),
					mod:GetId()
				}

				table.insert(mods, data)
			end
		end
	end

	return mods
end

-- Lines: 2805 to 2806
function MenuCallbackHandler:is_prof_job()
	return managers.job:is_current_job_professional()
end

-- Lines: 2809 to 2810
function MenuCallbackHandler:is_normal_job()
	return not self:is_prof_job()
end

-- Lines: 2813 to 2814
function MenuCallbackHandler:is_not_max_rank()
	return managers.experience:current_rank() < #tweak_data.infamy.ranks
end

-- Lines: 2817 to 2818
function MenuCallbackHandler:can_become_infamous()
	return self:is_level_100() and self:is_not_max_rank()
end

-- Lines: 2821 to 2822
function MenuCallbackHandler:singleplayer_restart()
	return self:is_singleplayer() and self:has_full_game() and self:is_normal_job() and not managers.job:stage_success()
end

-- Lines: 2825 to 2826
function MenuCallbackHandler:kick_player_visible()
	return self:is_server() and self:is_multiplayer() and managers.platform:presence() ~= "Mission_end" and managers.vote:option_host_kick()
end

-- Lines: 2829 to 2830
function MenuCallbackHandler:kick_vote_visible()
	return self:is_multiplayer() and managers.platform:presence() ~= "Mission_end" and managers.vote:option_vote_kick()
end

-- Lines: 2833 to 2839
function MenuCallbackHandler:_restart_level_visible()
	if not self:is_multiplayer() or self:is_prof_job() or managers.job:stage_success() then
		return false
	end

	local state = game_state_machine:current_state_name()

	return state ~= "ingame_waiting_for_players" and state ~= "ingame_lobby_menu" and state ~= "empty"
end

-- Lines: 2842 to 2843
function MenuCallbackHandler:restart_level_visible()
	return self:is_server() and self:_restart_level_visible() and managers.vote:option_host_restart()
end

-- Lines: 2846 to 2847
function MenuCallbackHandler:restart_vote_visible()
	return self:_restart_level_visible() and managers.vote:option_vote_restart()
end

-- Lines: 2850 to 2859
function MenuCallbackHandler:abort_mission_visible()
	if not self:is_not_editor() or not self:is_server() or not self:is_multiplayer() then
		return false
	end

	if game_state_machine:current_state_name() == "disconnected" then
		return false
	end

	return true
end

-- Lines: 2863 to 2864
function MenuCallbackHandler:is_custom_safehouse_unlocked()
	return managers.custom_safehouse:unlocked()
end

-- Lines: 2868 to 2869
function MenuCallbackHandler:lobby_exist()
	return managers.network.matchmake.lobby_handler
end

-- Lines: 2872 to 2873
function MenuCallbackHandler:hidden()
	return false
end

-- Lines: 2876 to 2877
function MenuCallbackHandler:chat_visible()
	return SystemInfo:platform() == Idstring("WIN32")
end

-- Lines: 2881 to 2882
function MenuCallbackHandler:is_pc_controller()
	return managers.menu:is_pc_controller()
end

-- Lines: 2886 to 2887
function MenuCallbackHandler:is_not_pc_controller()
	return not self:is_pc_controller()
end

-- Lines: 2890 to 2891
function MenuCallbackHandler:is_steam_controller()
	return managers.menu:is_steam_controller()
end

-- Lines: 2894 to 2895
function MenuCallbackHandler:is_not_steam_controller()
	return not self:is_steam_controller()
end

-- Lines: 2898 to 2899
function MenuCallbackHandler:is_not_editor()
	return not Application:editor()
end

-- Lines: 2909 to 2910
function MenuCallbackHandler:is_vr()
	return _G.IS_VR
end

-- Lines: 2914 to 2916
function MenuCallbackHandler:show_credits()
	game_state_machine:change_state_by_name("menu_credits")
end

-- Lines: 2919 to 2920
function MenuCallbackHandler:can_load_game()
	return not Application:editor() and not Network:multiplayer()
end

-- Lines: 2923 to 2924
function MenuCallbackHandler:can_save_game()
	return not Application:editor() and not Network:multiplayer()
end

-- Lines: 2927 to 2928
function MenuCallbackHandler:is_not_multiplayer()
	return not Network:multiplayer()
end

-- Lines: 2932 to 2933
function MenuCallbackHandler:is_not_crime_spree()
	return not self:is_crime_spree()
end

-- Lines: 2940 to 2941
function MenuCallbackHandler:is_crime_spree()
	return managers.crime_spree:is_active()
end

-- Lines: 2945 to 2946
function MenuCallbackHandler:debug_menu_enabled()
	return managers.menu:debug_menu_enabled()
end

-- Lines: 2950 to 2953
function MenuCallbackHandler:leave_online_menu()
	managers.menu:leave_online_menu()
end

-- Lines: 2955 to 2956
function MenuCallbackHandler:has_peer_1()
	return not not managers.network:session() and managers.network:session():peer(1)
end

-- Lines: 2959 to 2960
function MenuCallbackHandler:has_peer_2()
	return not not managers.network:session() and managers.network:session():peer(2)
end

-- Lines: 2963 to 2964
function MenuCallbackHandler:has_peer_3()
	return not not managers.network:session() and managers.network:session():peer(3)
end

-- Lines: 2967 to 2968
function MenuCallbackHandler:has_peer_4()
	return not not managers.network:session() and managers.network:session():peer(4)
end

-- Lines: 2972 to 2978
function MenuCallbackHandler:on_visit_forum()
	if not MenuCallbackHandler:is_overlay_enabled() then
		managers.menu:show_enable_steam_overlay()

		return
	end

	Steam:overlay_activate("url", "http://forums.steampowered.com/forums/forumdisplay.php?f=1225")
end

-- Lines: 2980 to 2986
function MenuCallbackHandler:on_visit_gamehub()
	if not MenuCallbackHandler:is_overlay_enabled() then
		managers.menu:show_enable_steam_overlay()

		return
	end

	Steam:overlay_activate("url", "http://steamcommunity.com/app/218620")
end

-- Lines: 2988 to 2990
function MenuCallbackHandler:on_buy_dlc1()
	Steam:overlay_activate("url", tweak_data.gui.store_page)
end

-- Lines: 2992 to 2999
function MenuCallbackHandler:on_account_picker()
	print("MenuCallbackHandler:on_account_picker()")

	
	-- Lines: 2994 to 2997
	local function confirm_cb()
		
		-- Lines: 2994 to 2995
		local function f(...)
			print("result", ...)
		end

		managers.system_menu:show_select_user({
			count = 1,
			callback_func = f
		})
	end

	managers.menu:show_account_picker_dialog({yes_func = confirm_cb})
end

-- Lines: 3001 to 3004
function MenuCallbackHandler:on_menu_option_help()
	print("MenuCallbackHandler:on_menu_option_help()")
	XboxLive:show_help_ui()
end

-- Lines: 3006 to 3022
function MenuCallbackHandler:quit_game()
	local dialog_data = {
		title = managers.localization:text("dialog_warning_title"),
		text = managers.localization:text("dialog_are_you_sure_you_want_to_quit")
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "_dialog_quit_yes")
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = callback(self, self, "_dialog_quit_no"),
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

-- Lines: 3024 to 3043
function MenuCallbackHandler:_dialog_quit_yes()
	self:_dialog_save_progress_backup_no()
end

-- Lines: 3045 to 3046
function MenuCallbackHandler:_dialog_quit_no()
end

-- Lines: 3048 to 3051
function MenuCallbackHandler:_dialog_save_progress_backup_yes()
	managers.savefile:save_progress("local_hdd")
	setup:quit()
end

-- Lines: 3053 to 3055
function MenuCallbackHandler:_dialog_save_progress_backup_no()
	setup:quit()
end

-- Lines: 3057 to 3063
function MenuCallbackHandler:chk_dlc_content_updated()
	if SystemInfo:platform() ~= Idstring("XB1") and managers.dlc then
		managers.dlc:chk_content_updated()
	end
end

-- Lines: 3065 to 3071
function MenuCallbackHandler:chk_dlc_content_updated_xb1()
	if SystemInfo:platform() == Idstring("XB1") and managers.dlc then
		managers.dlc:chk_content_updated()
	end
end

-- Lines: 3074 to 3091
function MenuCallbackHandler:toggle_ready(item)
	local ready = item:value() == "on"

	if not managers.network:session() then
		return
	end

	managers.network:session():local_peer():set_waiting_for_player_ready(ready)
	managers.network:session():chk_send_local_player_ready()

	if managers.menu:active_menu() and managers.menu:active_menu().renderer and managers.menu:active_menu().renderer.set_ready_items_enabled then
		managers.menu:active_menu().renderer:set_ready_items_enabled(not ready)
	end

	managers.network:session():on_set_member_ready(managers.network:session():local_peer():id(), ready, true, false)
end

-- Lines: 3093 to 3098
function MenuCallbackHandler:change_nr_players(item)
	local nr_players = item:value()
	Global.nr_players = nr_players

	managers.player:set_nr_players(nr_players)
end

-- Lines: 3101 to 3104
function MenuCallbackHandler:toggle_rumble(item)
	local rumble = item:value() == "on"

	managers.user:set_setting("rumble", rumble)
end

-- Lines: 3106 to 3109
function MenuCallbackHandler:invert_camera_horisontally(item)
	local invert = item:value() == "on"

	managers.user:set_setting("invert_camera_x", invert)
end

-- Lines: 3111 to 3114
function MenuCallbackHandler:invert_camera_vertically(item)
	local invert = item:value() == "on"

	managers.user:set_setting("invert_camera_y", invert)
end

-- Lines: 3116 to 3119
function MenuCallbackHandler:toggle_southpaw(item)
	local southpaw = item:value() == "on"

	managers.user:set_setting("southpaw", southpaw)
end

-- Lines: 3121 to 3124
function MenuCallbackHandler:toggle_dof_setting(item)
	local dof_setting = item:value() == "on"

	managers.user:set_setting("dof_setting", dof_setting and "standard" or "none")
end

-- Lines: 3126 to 3129
function MenuCallbackHandler:toggle_chromatic_setting(item)
	local chromatic_setting = item:value() == "on"

	managers.user:set_setting("chromatic_setting", chromatic_setting and "standard" or "none")
end

-- Lines: 3131 to 3134
function MenuCallbackHandler:hold_to_steelsight(item)
	local hold = item:value() == "on"

	managers.user:set_setting("hold_to_steelsight", hold)
end

-- Lines: 3136 to 3139
function MenuCallbackHandler:hold_to_run(item)
	local hold = item:value() == "on"

	managers.user:set_setting("hold_to_run", hold)
end

-- Lines: 3141 to 3144
function MenuCallbackHandler:hold_to_duck(item)
	local hold = item:value() == "on"

	managers.user:set_setting("hold_to_duck", hold)
end

-- Lines: 3146 to 3161
function MenuCallbackHandler:toggle_fullscreen(item)
	local fullscreen = item:value() == "on"

	if managers.viewport:is_fullscreen() == fullscreen then
		return
	end

	managers.viewport:set_fullscreen(fullscreen)
	managers.menu:show_accept_gfx_settings_dialog(function ()
		managers.viewport:set_fullscreen(not fullscreen)
		item:set_value(not fullscreen and "on" or "off")
		self:refresh_node()
	end)
	self:refresh_node()
end

-- Lines: 3163 to 3166
function MenuCallbackHandler:toggle_subtitle(item)
	local subtitle = item:value() == "on"

	managers.user:set_setting("subtitle", subtitle)
end

-- Lines: 3168 to 3171
function MenuCallbackHandler:toggle_hit_indicator(item)
	local on = item:value() == "on"

	managers.user:set_setting("hit_indicator", on)
end

-- Lines: 3173 to 3176
function MenuCallbackHandler:toggle_objective_reminder(item)
	local on = item:value() == "on"

	managers.user:set_setting("objective_reminder", on)
end

-- Lines: 3178 to 3181
function MenuCallbackHandler:toggle_aim_assist(item)
	local on = item:value() == "on"

	managers.user:set_setting("aim_assist", on)
end

-- Lines: 3184 to 3187
function MenuCallbackHandler:toggle_sticky_aim(item)
	local on = item:value() == "on"

	managers.user:set_setting("sticky_aim", on)
end

-- Lines: 3197 to 3200
function MenuCallbackHandler:toggle_voicechat(item)
	local vchat = item:value() == "on"

	managers.user:set_setting("voice_chat", vchat)
end

-- Lines: 3202 to 3205
function MenuCallbackHandler:toggle_push_to_talk(item)
	local vchat = item:value() == "on"

	managers.user:set_setting("push_to_talk", vchat)
end

-- Lines: 3208 to 3211
function MenuCallbackHandler:toggle_team_AI(item)
	Global.game_settings.team_ai = item:value() == "on"

	managers.groupai:state():on_criminal_team_AI_enabled_state_changed()
end

-- Lines: 3213 to 3221
function MenuCallbackHandler:toggle_coordinates(item)
	Global.debug_show_coords = item:value() == "on"

	if Global.debug_show_coords then
		managers.hud:debug_show_coordinates()
	else
		managers.hud:debug_hide_coordinates()
	end
end

-- Lines: 3223 to 3226
function MenuCallbackHandler:toggle_net_throttling(item)
	local state = item:value() == "on"

	managers.user:set_setting("net_packet_throttling", state, nil)
end

-- Lines: 3228 to 3231
function MenuCallbackHandler:toggle_net_forwarding(item)
	local state = item:value() == "on"

	managers.user:set_setting("net_forwarding", state, nil)
end

-- Lines: 3233 to 3237
function MenuCallbackHandler:toggle_net_use_compression(item)
	local state = item:value() == "on"

	print("[MenuCallbackHandler:toggle_net_use_compression]", state)
	managers.user:set_setting("net_use_compression", state, nil)
end

-- Lines: 3239 to 3254
function MenuCallbackHandler:change_resolution(item)
	local old_resolution = RenderSettings.resolution

	if item:parameters().resolution == old_resolution then
		return
	end

	managers.viewport:set_resolution(item:parameters().resolution)
	managers.viewport:set_aspect_ratio(item:parameters().resolution.x / item:parameters().resolution.y)

	
	-- Lines: 3248 to 3251
	local function on_decline()
		managers.viewport:set_resolution(old_resolution)
		managers.viewport:set_aspect_ratio(old_resolution.x / old_resolution.y)
	end

	managers.menu:show_accept_gfx_settings_dialog(on_decline)
end

-- Lines: 3258 to 3269
function MenuCallbackHandler:toggle_throwable_contour(item)
	local state = item:value() == "on"

	managers.user:set_setting("throwable_contour", state, nil)

	local throwables = World:find_units_quick("all", 20)

	for _, unit in ipairs(throwables) do
		if alive(unit) and unit:base() and unit:base().reload_contour then
			unit:base():reload_contour()
		end
	end
end

-- Lines: 3272 to 3283
function MenuCallbackHandler:toggle_ammo_contour(item)
	local state = item:value() == "on"

	managers.user:set_setting("ammo_contour", state, nil)

	local pickups = World:find_units_quick("all", 23)

	for _, unit in ipairs(pickups) do
		if alive(unit) and unit:pickup() and unit:pickup().reload_contour then
			unit:pickup():reload_contour()
		end
	end
end

-- Lines: 3287 to 3289
function MenuCallbackHandler:toggle_mute_heist_vo(item)
	managers.user:set_setting("mute_heist_vo", item:value() == "on", nil)
end

-- Lines: 3298 to 3301
function MenuCallbackHandler:choice_test(item)
	local test = item:value()

	print("MenuCallbackHandler", test)
end

-- Lines: 3303 to 3322
function MenuCallbackHandler:choice_premium_contact(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	managers.menu:active_menu().logic:selected_node():parameters().listed_contact = string.gsub(item:value(), "#", "")
	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
	end
end

-- Lines: 3324 to 3341
function MenuCallbackHandler:choice_controller_type(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	managers.menu:active_menu().logic:selected_node():parameters().controller_category = item:value()
	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
	end
end

-- Lines: 3343 to 3354
function MenuCallbackHandler:choice_max_lobbies_filter(item)
	if not managers.crimenet then
		return
	end

	local max_server_jobs_filter = item:value()

	managers.network.matchmake:set_lobby_return_count(max_server_jobs_filter)
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_max_servers", max_server_jobs_filter)
end

-- Lines: 3356 to 3366
function MenuCallbackHandler:choice_distance_filter(item)
	local dist_filter = item:value()

	if managers.network.matchmake:distance_filter() == dist_filter then
		return
	end

	managers.network.matchmake:set_distance_filter(dist_filter)
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_distance", dist_filter)
end

-- Lines: 3368 to 3385
function MenuCallbackHandler:choice_difficulty_filter(item)
	local diff_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("difficulty") == diff_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("difficulty", diff_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_difficulty", diff_filter)
	managers.crimenet:update_difficulty_filter()
end

-- Lines: 3387 to 3397
function MenuCallbackHandler:choice_job_id_filter(item)
	local job_id_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("job_id") == job_id_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("job_id", job_id_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_contract", job_id_filter)
end

-- Lines: 3399 to 3409
function MenuCallbackHandler:choice_new_servers_only(item)
	local num_players_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("num_players") == num_players_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("num_players", num_players_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_new_servers_only", num_players_filter)
end

-- Lines: 3411 to 3421
function MenuCallbackHandler:choice_kick_option(item)
	local kicking_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("kick_option") == kicking_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("kick_option", kicking_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_kick", kicking_filter)
end

-- Lines: 3423 to 3429
function MenuCallbackHandler:choice_job_appropriate_filter(item)
	local diff_appropriate = item:value()
	Global.game_settings.search_appropriate_jobs = diff_appropriate == "on" and true or false

	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_level_appopriate", diff_appropriate == "on" and true or false)
end

-- Lines: 3432 to 3437
function MenuCallbackHandler:choice_allow_safehouses_filter(item)
	local allow_safehouses = item:value() == "on" and true or false
	Global.game_settings.allow_search_safehouses = allow_safehouses

	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_safehouses", allow_safehouses)
end

-- Lines: 3441 to 3446
function MenuCallbackHandler:choice_mutated_lobbies_filter(item)
	local allow_mutators = item:value() == "on" and true or false
	Global.game_settings.search_mutated_lobbies = allow_mutators

	managers.user:set_setting("crimenet_filter_mutators", allow_mutators)
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

-- Lines: 3450 to 3455
function MenuCallbackHandler:choice_modded_lobbies_filter(item)
	local allow_modded = item:value() == "on" and true or false
	Global.game_settings.search_modded_lobbies = allow_modded

	managers.user:set_setting("crimenet_filter_modded", allow_modded)
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

-- Lines: 3458 to 3462
function MenuCallbackHandler:chocie_one_down_filter(item)
	local allow_one_down = item:value() == "on" and true or false
	Global.game_settings.search_one_down_lobbies = allow_one_down

	managers.user:set_setting("crimenet_filter_one_down", allow_one_down)
end

-- Lines: 3464 to 3474
function MenuCallbackHandler:choice_server_state_lobby(item)
	local state_filter = item:value()

	if managers.network.matchmake:get_lobby_filter("state") == state_filter then
		return
	end

	managers.network.matchmake:add_lobby_filter("state", state_filter, "equal")
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
	managers.user:set_setting("crimenet_filter_in_lobby", state_filter)
end

-- Lines: 3476 to 3478
function MenuCallbackHandler:save_crimenet_filters()
	managers.savefile:save_setting(true)
end

-- Lines: 3480 to 3486
function MenuCallbackHandler:refresh_node(item)
	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
	end
end

-- Lines: 3488 to 3494
function MenuCallbackHandler:open_contract_node(item)
	local job_tweak = tweak_data.narrative:job_data(item:parameters().id)
	local is_professional = job_tweak and job_tweak.professional or false
	local is_competitive = job_tweak and job_tweak.competitive or false
	self._temp_job_data = job_tweak

	managers.menu:open_node(Global.game_settings.single_player and "crimenet_contract_singleplayer" or "crimenet_contract_host", {{
		customize_contract = true,
		job_id = item:parameters().id,
		difficulty = is_professional and "hard" or "normal",
		difficulty_id = is_professional and 3 or 2,
		professional = is_professional,
		competitive = is_competitive,
		contract_visuals = job_tweak.contract_visuals
	}})
end

-- Lines: 3496 to 3530
function MenuCallbackHandler:is_contract_difficulty_allowed(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node():parameters().menu_component_data then
		return false
	end

	local job_data = managers.menu:active_menu().logic:selected_node():parameters().menu_component_data

	if not job_data.job_id then
		return false
	end

	if job_data.professional and item:value() < 3 then
		return false
	end

	if not job_data.professional and item:value() > 5 then
		-- Nothing
	end

	local job_jc = tweak_data.narrative:job_data(job_data.job_id).jc
	local difficulty_jc = (item:value() - 2) * 10
	local plvl = managers.experience:current_level()
	local prank = managers.experience:current_rank()
	local level_lock = tweak_data.difficulty_level_locks[item:value()] or 0
	local is_not_level_locked = prank >= 1 or level_lock <= plvl

	return is_not_level_locked and math.clamp(job_jc + difficulty_jc, 0, 100) <= managers.job:get_max_jc_for_player()
end

-- Lines: 3533 to 3545
function MenuCallbackHandler:buy_crimenet_contract(item, node)
	local job_data = item:parameters().gui_node.node:parameters().menu_component_data

	if not managers.money:can_afford_buy_premium_contract(job_data.job_id, job_data.difficulty_id or 3) then
		return
	end

	local params = {
		contract_fee = managers.experience:cash_string(managers.money:get_cost_of_premium_contract(job_data.job_id, job_data.difficulty_id or 3)),
		offshore = managers.experience:cash_string(managers.money:offshore()),
		yes_func = callback(self, self, "_buy_crimenet_contract", item, node)
	}

	managers.menu:show_confirm_buy_premium_contract(params)
end

-- Lines: 3547 to 3567
function MenuCallbackHandler:_buy_crimenet_contract(item, node)
	local job_data = item:parameters().gui_node.node:parameters().menu_component_data

	if not managers.money:can_afford_buy_premium_contract(job_data.job_id, job_data.difficulty_id or 3) then
		return
	end

	managers.money:on_buy_premium_contract(job_data.job_id, job_data.difficulty_id or 3)
	managers.job:on_buy_job(job_data.job_id, job_data.difficulty_id or 3)
	managers.menu:active_menu().logic:navigate_back(true)
	managers.menu:active_menu().logic:navigate_back(true)
	self._sound_source:post_event("item_buy")

	if Global.game_settings.single_player then
		MenuCallbackHandler:start_single_player_job(job_data)
	else
		MenuCallbackHandler:start_job(job_data)
	end

	MenuCallbackHandler:save_progress()
end

-- Lines: 3569 to 3574
function MenuCallbackHandler:crimenet_casino_secured_cards()
	local card1 = managers.menu:active_menu().logic:selected_node():item("secure_card_1"):value() == "on" and 1 or 0
	local card2 = managers.menu:active_menu().logic:selected_node():item("secure_card_2"):value() == "on" and 1 or 0
	local card3 = managers.menu:active_menu().logic:selected_node():item("secure_card_3"):value() == "on" and 1 or 0

	return card1 + card2 + card3
end

-- Lines: 3577 to 3581
function MenuCallbackHandler:crimenet_casino_update(item)
	if item:enabled() then
		self:refresh_node()
	end
end

-- Lines: 3583 to 3594
function MenuCallbackHandler:crimenet_casino_safe_card1(item)
	if managers.menu:active_menu().logic:selected_node():item("secure_card_1"):enabled() then
		if managers.menu:active_menu().logic:selected_node():item("secure_card_2"):value() == "on" then
			managers.menu:active_menu().logic:selected_node():item("secure_card_1"):set_value("on")
		end

		managers.menu:active_menu().logic:selected_node():item("secure_card_2"):set_value("off")
		managers.menu:active_menu().logic:selected_node():item("secure_card_3"):set_value("off")
		self:refresh_node()
	end
end

-- Lines: 3596 to 3607
function MenuCallbackHandler:crimenet_casino_safe_card2(item)
	if managers.menu:active_menu().logic:selected_node():item("secure_card_2"):enabled() then
		if managers.menu:active_menu().logic:selected_node():item("secure_card_3"):value() == "on" then
			managers.menu:active_menu().logic:selected_node():item("secure_card_2"):set_value("on")
		end

		managers.menu:active_menu().logic:selected_node():item("secure_card_1"):set_value("on")
		managers.menu:active_menu().logic:selected_node():item("secure_card_3"):set_value("off")
		self:refresh_node()
	end
end

-- Lines: 3609 to 3616
function MenuCallbackHandler:crimenet_casino_safe_card3(item)
	if managers.menu:active_menu().logic:selected_node():item("secure_card_3"):enabled() then
		managers.menu:active_menu().logic:selected_node():item("secure_card_1"):set_value("on")
		managers.menu:active_menu().logic:selected_node():item("secure_card_2"):set_value("on")
		self:refresh_node()
	end
end

-- Lines: 3618 to 3619
function MenuCallbackHandler:not_customize_contract(item)
	return not self:customize_contract(item)
end

-- Lines: 3622 to 3636
function MenuCallbackHandler:customize_contract(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node():parameters().menu_component_data then
		return false
	end

	return managers.menu:active_menu().logic:selected_node():parameters().menu_component_data.customize_contract
end

-- Lines: 3639 to 3665
function MenuCallbackHandler:change_contract_difficulty(item)
	managers.menu_component:set_crimenet_contract_difficulty_id(item:value())

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local job_data = item:parameters().gui_node.node:parameters().menu_component_data

	if not job_data or not job_data.job_id then
		return false
	end

	local buy_contract_item = managers.menu:active_menu().logic:selected_node():item("buy_contract")

	if not buy_contract_item then
		return false
	end

	local can_afford = managers.money:can_afford_buy_premium_contract(job_data.job_id, job_data.difficulty_id or 3)
	buy_contract_item:parameters().text_id = can_afford and "menu_cn_premium_buy_accept" or "menu_cn_premium_cannot_buy"

	buy_contract_item:set_enabled(can_afford)
	self:refresh_node()
end

-- Lines: 3667 to 3669
function MenuCallbackHandler:choice_crimenet_one_down(item)
	managers.menu_component:set_crimenet_contract_one_down(item:value() == "on")
end

-- Lines: 3671 to 3679
function MenuCallbackHandler:choice_difficulty_filter_ps3(item)
	local diff_filter = item:value()

	if managers.network.matchmake:difficulty_filter() == diff_filter then
		return
	end

	managers.network.matchmake:set_difficulty_filter(diff_filter)
	managers.network.matchmake:start_search_lobbys(managers.network.matchmake:searching_friends_only())
end

-- Lines: 3683 to 3708
function MenuCallbackHandler:choice_lobby_difficulty(item)
	local difficulty = item:value()
	Global.game_settings.difficulty = difficulty

	if managers.menu:active_menu().renderer.update_difficulty then
		managers.menu:active_menu().renderer:update_difficulty()
	end

	if difficulty == "overkill_145" and Global.game_settings.reputation_permission < 145 then
		local item_reputation_permission = managers.menu:active_menu().logic:selected_node():item("lobby_reputation_permission")

		if item_reputation_permission and item_reputation_permission:visible() then
			item_reputation_permission:set_value(145)
			item_reputation_permission:trigger()
		end
	end

	managers.menu:show_global_success()
	self:update_matchmake_attributes()
end

-- Lines: 3710 to 3713
function MenuCallbackHandler:lobby_start_campaign(item)
	MenuCallbackHandler:choice_lobby_campaign(item)
	MenuCallbackHandler:start_the_game()
end

-- Lines: 3715 to 3718
function MenuCallbackHandler:lobby_create_campaign(item)
	MenuCallbackHandler:choice_lobby_campaign(item)
	MenuCallbackHandler:create_lobby(item)
end

-- Lines: 3720 to 3740
function MenuCallbackHandler:choice_lobby_campaign(item)
	if not item:enabled() then
		return
	end

	Global.game_settings.level_id = item:parameter("level_id")

	MenuManager.refresh_level_select(managers.menu:active_menu().logic:selected_node(), true)

	if managers.menu:active_menu().renderer.update_level_id then
		managers.menu:active_menu().renderer:update_level_id(Global.game_settings.level_id)
	end

	if managers.menu:active_menu().renderer.update_difficulty then
		managers.menu:active_menu().renderer:update_difficulty()
	end

	managers.menu:show_global_success()
	self:update_matchmake_attributes()
end

-- Lines: 3742 to 3748
function MenuCallbackHandler:choice_lobby_mission(item)
	if not item:enabled() then
		return
	end

	Global.game_settings.mission = item:value()
end

-- Lines: 3751 to 3756
function MenuCallbackHandler:choice_friends_only(item)
	local choice_friends_only = item:value() == "on"
	Global.game_settings.search_friends_only = choice_friends_only

	managers.user:set_setting("crimenet_filter_friends_only", choice_friends_only)
end

-- Lines: 3759 to 3765
function MenuCallbackHandler:choice_lobby_permission(item)
	local permission = item:value()
	local level_id = item:value()
	Global.game_settings.permission = permission

	self:update_matchmake_attributes()
	self:_on_host_setting_updated()
end

-- Lines: 3767 to 3787
function MenuCallbackHandler:choice_lobby_reputation_permission(item)
	local reputation_permission = item:value()
	Global.game_settings.reputation_permission = reputation_permission

	self:update_matchmake_attributes()
	self:_on_host_setting_updated()
end

-- Lines: 3790 to 3797
function MenuCallbackHandler:choice_team_ai(item)
	Global.game_settings.team_ai = item:value() ~= 0
	Global.game_settings.team_ai_option = item:value()
end

-- Lines: 3800 to 3815
function MenuCallbackHandler:choice_drop_in(item)
	local choice_drop_in = item:value()
	Global.game_settings.drop_in_allowed = choice_drop_in ~= 0
	Global.game_settings.drop_in_option = choice_drop_in

	self:update_matchmake_attributes()

	if managers.network:session() then
		managers.network:session():chk_server_joinable_state()
	end

	self:_on_host_setting_updated()
end

-- Lines: 3819 to 3821
function MenuCallbackHandler:choice_kicking_option(item)
	Global.game_settings.kick_option = item:value()
end

-- Lines: 3823 to 3826
function MenuCallbackHandler:choice_crimenet_lobby_permission(item)
	local permission = item:value()
	Global.game_settings.permission = permission
end

-- Lines: 3828 to 3831
function MenuCallbackHandler:choice_crimenet_lobby_reputation_permission(item)
	local reputation_permission = item:value()
	Global.game_settings.reputation_permission = reputation_permission
end

-- Lines: 3834 to 3842
function MenuCallbackHandler:choice_crimenet_team_ai(item)
	Global.game_settings.team_ai = item:value() ~= 0
	Global.game_settings.team_ai_option = item:value()

	self:_on_host_setting_updated()
end

-- Lines: 3844 to 3847
function MenuCallbackHandler:choice_crimenet_auto_kick(item)
	Global.game_settings.auto_kick = item:value() == "on"

	self:_on_host_setting_updated()
end

-- Lines: 3850 to 3853
function MenuCallbackHandler:choice_allow_modded_players(item)
	Global.game_settings.allow_modded_players = item:value() == "on"

	self:_on_host_setting_updated()
end

-- Lines: 3857 to 3869
function MenuCallbackHandler:choice_crimenet_drop_in(item)
	local choice_drop_in = item:value()
	Global.game_settings.drop_in_allowed = choice_drop_in ~= 0
	Global.game_settings.drop_in_option = choice_drop_in

	if managers.network:session() then
		managers.network:session():chk_server_joinable_state()
	end
end

-- Lines: 3872 to 3885
function MenuCallbackHandler:accept_crimenet_contract(item, node)
	managers.menu:active_menu().logic:navigate_back(true)

	local job_data = item:parameters().gui_node.node:parameters().menu_component_data

	if job_data.server then
		managers.crime_spree:join_server(job_data)
		managers.network.matchmake:join_server_with_check(job_data.room_id, false, job_data)
	elseif Global.game_settings.single_player then
		MenuCallbackHandler:start_single_player_job(job_data)
	else
		MenuCallbackHandler:start_job(job_data)
	end
end

-- Lines: 3887 to 3889
function MenuCallbackHandler:kit_menu_ready()
	managers.menu:close_menu("kit_menu")
end

-- Lines: 3891 to 3893
function MenuCallbackHandler:set_lan_game()
	Global.game_settings.playing_lan = true
end

-- Lines: 3895 to 3897
function MenuCallbackHandler:set_not_lan_game()
	Global.game_settings.playing_lan = nil
end

-- Lines: 3899 to 3930
function MenuCallbackHandler:get_matchmake_attributes()
	local level_id = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
	local difficulty_id = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	local permission_id = tweak_data:permission_to_index(Global.game_settings.permission)
	local min_lvl = Global.game_settings.reputation_permission or 0
	local drop_in = Global.game_settings.drop_in_option
	local job_id = tweak_data.narrative:get_index_from_job_id(managers.job:current_real_job_id())
	local attributes = {numbers = {
		level_id + 1000 * job_id,
		difficulty_id,
		permission_id,
		[6] = drop_in,
		[7] = min_lvl
	}}

	if self:is_win32() then
		local kick_option = Global.game_settings.kick_option
		attributes.numbers[8] = kick_option
		local job_class = managers.job:calculate_job_class(managers.job:current_real_job_id(), difficulty_id)
		attributes.numbers[9] = job_class
		local job_plan = Global.game_settings.job_plan

		if tweak_data.quickplay.stealth_levels[managers.job:current_real_job_id()] then
			job_plan = 2
		end

		attributes.numbers[10] = job_plan
	end

	return attributes
end

-- Lines: 3934 to 3936
function MenuCallbackHandler:update_matchmake_attributes()
	managers.network.matchmake:set_server_attributes(self:get_matchmake_attributes())
end

-- Lines: 3938 to 3940
function MenuCallbackHandler:create_lobby()
	managers.network.matchmake:create_lobby(self:get_matchmake_attributes())
end

-- Lines: 3944 to 3949
function MenuCallbackHandler:play_single_player()
	Global.game_settings.single_player = true

	managers.network:host_game()
	Network:set_server()
end

-- Lines: 3951 to 3956
function MenuCallbackHandler:play_online_game()
	Global.game_settings.single_player = false

	if managers.network.matchmake and managers.network.matchmake.load_user_filters then
		managers.network.matchmake:load_user_filters()
	end
end

-- Lines: 3964 to 3972
function MenuCallbackHandler:play_safehouse(params)
	
	-- Lines: 3959 to 3965
	local function yes_func()
		self:play_single_player()

		Global.mission_manager.has_played_tutorial = true

		self:start_single_player_job({
			difficulty = "normal",
			job_id = "safehouse"
		})
	end

	if params.skip_question then
		yes_func()

		return
	end

	managers.menu:show_play_safehouse_question({yes_func = yes_func})
end

-- Lines: 3975 to 3982
function MenuCallbackHandler:play_short_heist(item)
	Global.game_settings.team_ai = true
	Global.game_settings.team_ai_option = 2

	self:play_single_player()
	self:start_single_player_job({
		difficulty = "normal",
		job_id = item and item:parameters().job or "short"
	})
end

-- Lines: 3985 to 4030
function MenuCallbackHandler:_increase_infamous(yes_clbk)
	managers.menu_scene:destroy_infamy_card()

	if managers.experience:current_level() < 100 or #tweak_data.infamy.ranks <= managers.experience:current_rank() then
		return
	end

	local rank = managers.experience:current_rank() + 1

	managers.experience:reset()
	managers.experience:set_current_rank(rank)

	local offshore_cost = Application:digest_value(tweak_data.infamy.ranks[rank], false)

	if offshore_cost > 0 then
		managers.money:deduct_from_total(managers.money:total())
		managers.money:deduct_from_offshore(offshore_cost)
	end

	managers.skilltree:infamy_reset()
	managers.blackmarket:reset_equipped()

	if managers.menu_component then
		managers.menu_component:refresh_player_profile_gui()
	end

	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
		logic:select_item("crimenet")
	end

	managers.savefile:save_progress()
	managers.savefile:save_setting(true)
	managers.menu:post_event("infamous_player_join_stinger")

	if yes_clbk then
		yes_clbk()
	end

	if SystemInfo:distribution() == Idstring("STEAM") then
		managers.statistics:publish_level_to_steam()
	end
end

-- Lines: 4032 to 4061
function MenuCallbackHandler:become_infamous(params)
	if not self:can_become_infamous() then
		return
	end

	local infamous_cost = Application:digest_value(tweak_data.infamy.ranks[managers.experience:current_rank() + 1], false)
	local yes_clbk = params and params.yes_clbk or false
	local no_clbk = params and params.no_clbk
	local params = {
		cost = managers.experience:cash_string(infamous_cost),
		free = infamous_cost == 0
	}

	if infamous_cost <= managers.money:offshore() and managers.experience:current_level() >= 100 then
		
		-- Lines: 4047 to 4052
		function params.yes_func()
			local rank = managers.experience:current_rank() + 1

			managers.menu:open_node("blackmarket_preview_node", {{back_callback = callback(MenuCallbackHandler, MenuCallbackHandler, "_increase_infamous", yes_clbk)}})
			managers.menu:post_event("infamous_stinger_level_" .. (rank < 10 and "0" or "") .. tostring(rank))
			managers.menu_scene:spawn_infamy_card(rank)
		end
	end

	
	-- Lines: 4054 to 4058
	function params.no_func()
		if no_clbk then
			no_clbk()
		end
	end

	managers.menu:show_confirm_become_infamous(params)
end

-- Lines: 4064 to 4066
function MenuCallbackHandler:toggle_adaptive_quality(item)
	managers.user:set_setting("adaptive_quality", item:value() == "on")
end

-- Lines: 4068 to 4070
function MenuCallbackHandler:toggle_window_zoom(item)
	managers.user:set_setting("window_zoom", item:value() == "on")
end

-- Lines: 4074 to 4076
function MenuCallbackHandler:choice_choose_video_adapter(item)
	managers.viewport:set_adapter_index(item:value())
end

-- Lines: 4081 to 4101
function MenuCallbackHandler:apply_and_save_render_settings()
	
	-- Lines: 4079 to 4082
	local function func()
		Application:apply_render_settings()
		Application:save_render_settings()
	end

	local fullscreen_ws = managers.menu_component and managers.menu_component._fullscreen_ws

	if false and alive(fullscreen_ws) then
		local black_overlay = fullscreen_ws:panel():panel({layer = tweak_data.gui.MOUSE_LAYER - 1})

		black_overlay:rect({color = Color.black})
		black_overlay:text({
			vertical = "center",
			halign = "center",
			font_size = 50,
			align = "center",
			valign = "center",
			text = managers.localization:to_upper_text("menu_apply_render_settings"),
			font = tweak_data.menu.pd2_large_font
		})
		black_overlay:animate(function (o)
			coroutine.yield()
			coroutine.yield()
			func()
			over(0.05, function (p)
				black_overlay:set_alpha(1 - p)
			end)
			fullscreen_ws:panel():remove(black_overlay)
		end)
	else
		func()
	end
end

-- Lines: 4103 to 4107
function MenuCallbackHandler:choice_choose_texture_quality(item)
	RenderSettings.texture_quality_default = item:value()

	MenuCallbackHandler:apply_and_save_render_settings()
end

-- Lines: 4109 to 4113
function MenuCallbackHandler:choice_choose_shadow_quality(item)
	RenderSettings.shadow_quality_default = item:value()

	MenuCallbackHandler:apply_and_save_render_settings()
end

-- Lines: 4115 to 4117
function MenuCallbackHandler:toggle_gpu_flush_setting(item)
	managers.user:set_setting("flush_gpu_command_queue", item:value() == "on")
end

-- Lines: 4119 to 4123
function MenuCallbackHandler:choice_choose_anisotropic(item)
	RenderSettings.max_anisotropy = item:value()

	MenuCallbackHandler:apply_and_save_render_settings()
end

-- Lines: 4125 to 4128
function MenuCallbackHandler:choice_fps_cap(item)
	setup:set_fps_cap(item:value())
	managers.user:set_setting("fps_cap", item:value())
end

-- Lines: 4130 to 4135
function MenuCallbackHandler:choice_choose_color_grading(item)
	managers.user:set_setting("video_color_grading", item:value())

	if managers.environment_controller then
		managers.environment_controller:refresh_render_settings()
	end
end

-- Lines: 4137 to 4139
function MenuCallbackHandler:choice_choose_menu_theme(item)
	managers.menu:change_theme(item:value())
end

-- Lines: 4142 to 4144
function MenuCallbackHandler:choice_corpse_limit(item)
	managers.user:set_setting("corpse_limit", item:value())
end

-- Lines: 4148 to 4150
function MenuCallbackHandler:choice_choose_ao(item)
	managers.user:set_setting("video_ao", item:value())
end

-- Lines: 4154 to 4156
function MenuCallbackHandler:toggle_parallax(item)
	managers.user:set_setting("parallax_mapping", item:value() == "on")
end

-- Lines: 4160 to 4162
function MenuCallbackHandler:choice_choose_aa(item)
	managers.user:set_setting("video_aa", item:value())
end

-- Lines: 4166 to 4168
function MenuCallbackHandler:toggle_workshop(item)
	managers.user:set_setting("workshop", item:value() == "on")
end

-- Lines: 4171 to 4177
function MenuCallbackHandler:choice_choose_anti_alias(item)
	managers.user:set_setting("video_anti_alias", item:value())

	if managers.environment_controller then
		managers.environment_controller:refresh_render_settings()
	end
end

-- Lines: 4179 to 4181
function MenuCallbackHandler:choice_choose_anim_lod(item)
	managers.user:set_setting("video_animation_lod", item:value())
end

-- Lines: 4183 to 4185
function MenuCallbackHandler:toggle_vsync(item)
	managers.viewport:set_vsync(item:value() == "on")
end

-- Lines: 4188 to 4190
function MenuCallbackHandler:toggle_use_thq_weapon_parts(item)
	managers.user:set_setting("use_thq_weapon_parts", item:value() == "on")
end

-- Lines: 4192 to 4198
function MenuCallbackHandler:toggle_streaks(item)
	managers.user:set_setting("video_streaks", item:value() == "on")

	if managers.environment_controller then
		managers.environment_controller:refresh_render_settings()
	end
end

-- Lines: 4200 to 4206
function MenuCallbackHandler:toggle_light_adaption(item)
	managers.user:set_setting("light_adaption", item:value() == "on")

	if managers.environment_controller then
		managers.environment_controller:refresh_render_settings()
	end
end

-- Lines: 4209 to 4211
function MenuCallbackHandler:toggle_lightfx(item)
	managers.user:set_setting("use_lightfx", item:value() == "on")
end

-- Lines: 4213 to 4215
function MenuCallbackHandler:choice_max_streaming_chunk(item)
	managers.user:set_setting("max_streaming_chunk", item:value())
end

-- Lines: 4217 to 4224
function MenuCallbackHandler:set_fov_multiplier(item)
	local fov_multiplier = item:value()

	managers.user:set_setting("fov_multiplier", fov_multiplier)

	if alive(managers.player:player_unit()) then
		managers.player:player_unit():movement():current_state():update_fov_external()
	end
end

-- Lines: 4227 to 4243
function MenuCallbackHandler:set_fov_standard(item)
	return

	local fov = item:value()

	managers.user:set_setting("fov_standard", fov)

	local item_fov_zoom = managers.menu:active_menu().logic:selected_node():item("fov_zoom")

	if fov < item_fov_zoom:value() then
		item_fov_zoom:set_value(fov)
		item_fov_zoom:trigger()
	end

	if alive(managers.player:player_unit()) then
		local plr_state = managers.player:player_unit():movement():current_state()
		local stance = plr_state:in_steelsight() and "steelsight" or plr_state._state_data.ducking and "crouched" or "standard"

		plr_state._camera_unit:base():set_stance_fov_instant(stance)
	end
end

-- Lines: 4245 to 4261
function MenuCallbackHandler:set_fov_zoom(item)
	return

	local fov = item:value()

	managers.user:set_setting("fov_zoom", fov)

	local item_fov_standard = managers.menu:active_menu().logic:selected_node():item("fov_standard")

	if item_fov_standard:value() < fov then
		item_fov_standard:set_value(fov)
		item_fov_standard:trigger()
	end

	if alive(managers.player:player_unit()) then
		local plr_state = managers.player:player_unit():movement():current_state()
		local stance = plr_state:in_steelsight() and "steelsight" or plr_state._state_data.ducking and "crouched" or "standard"

		plr_state._camera_unit:base():set_stance_fov_instant(stance)
	end
end

-- Lines: 4263 to 4265
function MenuCallbackHandler:toggle_headbob(item)
	managers.user:set_setting("use_headbob", item:value() == "on")
end

-- Lines: 4267 to 4269
function MenuCallbackHandler:on_stage_success()
	managers.mission:on_stage_success()
end

-- Lines: 4271 to 4273
function MenuCallbackHandler:lobby_start_the_game()
	MenuCallbackHandler:start_the_game()
end

-- Lines: 4275 to 4300
function MenuCallbackHandler:leave_lobby()
	if game_state_machine:current_state_name() == "ingame_lobby_menu" then
		self:end_game()

		return
	end

	local dialog_data = {
		title = managers.localization:text("dialog_warning_title"),
		text = managers.localization:text("dialog_are_you_sure_you_want_leave"),
		id = "leave_lobby"
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "_dialog_leave_lobby_yes")
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = callback(self, self, "_dialog_leave_lobby_no"),
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)

	return true
end

-- Lines: 4304 to 4315
function MenuCallbackHandler:_dialog_leave_lobby_yes()
	if managers.network:session() then
		managers.network:session():local_peer():set_in_lobby(false)
		managers.network:session():send_to_peers("set_peer_left")
	end

	managers.crime_spree:disable_crime_spree_gamemode()
	managers.menu:on_leave_lobby()
end

-- Lines: 4317 to 4318
function MenuCallbackHandler:_dialog_leave_lobby_no()
end

-- Lines: 4337 to 4341
function MenuCallbackHandler:connect_to_host_rpc(item)
	
	-- Lines: 4321 to 4338
	local function f(res)
		if res == "JOINED_LOBBY" then
			self:on_enter_lobby()
		elseif res == "JOINED_GAME" then
			local level_id = tweak_data.levels:get_level_name_from_world_name(item:parameters().level_name)

			managers.network:session():load_level(item:parameters().level_name, nil, nil, nil, level_id, nil)
		elseif res == "KICKED" then
			managers.menu:show_peer_kicked_dialog()
		elseif res == "BANNED" then
			managers.menu:show_peer_banned_dialog()
		else
			Application:error("[MenuCallbackHandler:connect_to_host_rpc] FAILED TO START MULTIPLAYER!")
		end
	end

	managers.network:join_game_at_host_rpc(item:parameters().rpc, f)
end

-- Lines: 4343 to 4360
function MenuCallbackHandler:host_multiplayer(item)
	managers.network:host_game()

	local level_id = item:parameters().level_id
	local level_name = level_id and tweak_data.levels[level_id].world_name
	level_id = level_id or tweak_data.levels:get_level_name_from_world_name(item:parameters().level)
	level_name = level_name or item:parameters().level or "bank"
	Global.game_settings.level_id = level_id

	managers.network:session():load_level(level_name, nil, nil, nil, level_id)
end

-- Lines: 4371 to 4374
function MenuCallbackHandler:join_multiplayer()
	
	-- Lines: 4363 to 4372
	local function f(new_host_rpc)
		if new_host_rpc then
			managers.menu:active_menu().logic:refresh_node("select_host")
		end
	end

	managers.network:discover_hosts(f)
end

-- Lines: 4376 to 4385
function MenuCallbackHandler:find_lan_games()
	if self:is_win32() then
		
		-- Lines: 4378 to 4382
		local function f(new_host_rpc)
			if new_host_rpc then
				managers.menu:active_menu().logic:refresh_node("play_lan")
			end
		end

		managers.network:discover_hosts(f)
	end
end

-- Lines: 4387 to 4389
function MenuCallbackHandler:find_online_games_with_friends()
	self:_find_online_games(true)
end

-- Lines: 4391 to 4393
function MenuCallbackHandler:find_online_games()
	self:_find_online_games()
end

-- Lines: 4395 to 4453
function MenuCallbackHandler:_find_online_games(friends_only)
	if self:is_win32() then
		
		-- Lines: 4397 to 4402
		local function f(info)
			print("info in function")
			print(inspect(info))
			managers.network.matchmake:search_lobby_done()
			managers.menu:active_menu().logic:refresh_node("play_online", true, info, friends_only)
		end

		managers.network.matchmake:register_callback("search_lobby", f)
		managers.network.matchmake:search_lobby(friends_only)

		
		-- Lines: 4408 to 4419
		local function usrs_f(success, amount)
			print("usrs_f", success, amount)

			if success then
				local stack = managers.menu:active_menu().renderer._node_gui_stack
				local node_gui = stack[#stack]

				if node_gui.set_mini_info then
					node_gui:set_mini_info(managers.localization:text("menu_players_online", {COUNT = amount}))
				end
			end
		end

		Steam:sa_handler():concurrent_users_callback(usrs_f)
		Steam:sa_handler():get_concurrent_users()
	end

	if self:is_ps3() or self:is_ps4() then
		if #PSN:get_world_list() == 0 then
			return
		end

		
		-- Lines: 4432 to 4437
		local function f(info_list)
			print("info_list in function")
			print(inspect(info_list))
			managers.network.matchmake:search_lobby_done()
			managers.menu:active_menu().logic:refresh_node("play_online", true, info_list, friends_only)
		end

		managers.network.matchmake:register_callback("search_lobby", f)
		managers.network.matchmake:start_search_lobbys(friends_only)
	end
end

-- Lines: 4458 to 4460
function MenuCallbackHandler:connect_to_lobby(item)
	managers.network.matchmake:join_server_with_check(item:parameters().room_id)
end

-- Lines: 4466 to 4471
function MenuCallbackHandler:stop_multiplayer()
	Global.game_settings.single_player = false

	if managers.network:session() and managers.network:session():local_peer():id() == 1 then
		managers.network:stop_network(true)
	end
end

-- Lines: 4475 to 4476
function MenuCallbackHandler:find_friends()
end

-- Lines: 4479 to 4488
function MenuCallbackHandler:invite_friends()
	if managers.network.matchmake.lobby_handler then
		if MenuCallbackHandler:is_overlay_enabled() then
			Steam:overlay_activate("invite", managers.network.matchmake.lobby_handler:id())
		else
			managers.menu:show_enable_steam_overlay()
		end
	end
end

-- Lines: 4492 to 4497
function MenuCallbackHandler:invite_friend(item)
	if item:parameters().signin_status ~= "signed_in" then
		return
	end

	managers.network.matchmake:send_join_invite(item:parameters().friend)
end

-- Lines: 4510 to 4513
function MenuCallbackHandler:invite_friends_X360()
	local platform_id = managers.user:get_platform_id()

	XboxLive:show_friends_ui(platform_id)
end

-- Lines: 4515 to 4520
function MenuCallbackHandler:invite_friends_XB1()
	if managers.network.matchmake._session then
		local platform_id = managers.user:get_platform_id()

		XboxLive:invite_friends_ui(platform_id, managers.network.matchmake._session)
	end
end

-- Lines: 4523 to 4526
function MenuCallbackHandler:invite_xbox_live_party()
	local platform_id = managers.user:get_platform_id()

	XboxLive:show_party_ui(platform_id)
end

-- Lines: 4529 to 4531
function MenuCallbackHandler:invite_friends_ps4()
	PSN:invite_friends()
end

-- Lines: 4533 to 4538
function MenuCallbackHandler:view_invites()
	print("View invites")
	print(PSN:display_message_invitation())
end

-- Lines: 4541 to 4542
function MenuCallbackHandler:waiting_players_visible(item)
	return #managers.wait:list_of_waiting() > 0
end

-- Lines: 4545 to 4547
function MenuCallbackHandler:show_waiting_players(item)
	managers.wait:spawn_all_waiting()
end

-- Lines: 4550 to 4556
function MenuCallbackHandler:kick_player(item)
	if managers.vote:option_host_kick() then
		managers.vote:message_host_kick(item:parameters().peer)
	elseif managers.vote:option_vote_kick() then
		managers.vote:kick(item:parameters().peer:id())
	end
end

-- Lines: 4558 to 4572
function MenuCallbackHandler:mute_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:mute_player(item:parameters().peer, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end

	if managers.chat then
		if item:value() == "on" then
			managers.chat:mute_peer(item:parameters().peer)
		else
			managers.chat:unmute_peer(item:parameters().peer)
		end
	end
end

-- Lines: 4574 to 4579
function MenuCallbackHandler:mute_xbox_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:set_muted(item:parameters().xuid, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

-- Lines: 4581 to 4586
function MenuCallbackHandler:mute_xb1_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:set_muted(item:parameters().xuid, item:value() == "on")
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

-- Lines: 4588 to 4593
function MenuCallbackHandler:mute_ps4_player(item)
	if managers.network.voice_chat then
		managers.network.voice_chat:mute_player(item:value() == "on", item:parameters().peer)
		item:parameters().peer:set_muted(item:value() == "on")
	end
end

-- Lines: 4596 to 4621
function MenuCallbackHandler:restart_level(item)
	if not managers.vote:available() or managers.vote:is_restarting() then
		return
	end

	local dialog_data = {
		title = managers.localization:text("dialog_mp_restart_level_title"),
		text = managers.localization:text(managers.vote:option_vote_restart() and "dialog_mp_restart_level_message" or "dialog_mp_restart_level_host_message")
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = function ()
			if managers.vote:option_vote_restart() then
				managers.vote:restart()
			else
				managers.vote:restart_auto()
			end
		end
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

-- Lines: 4623 to 4625
function MenuCallbackHandler:view_gamer_card(item)
	XboxLive:show_gamer_card_ui(managers.user:get_platform_id(), item:parameters().xuid)
end

-- Lines: 4627 to 4629
function MenuCallbackHandler:save_settings()
	managers.savefile:save_setting(true)
end

-- Lines: 4631 to 4633
function MenuCallbackHandler:save_progress()
	managers.savefile:save_progress()
end

-- Lines: 4635 to 4640
function MenuCallbackHandler:debug_level_jump(item)
	local param_map = item:parameters()

	managers.network:host_game()

	local level_id = tweak_data.levels:get_level_name_from_world_name(param_map.level)

	managers.network:session():load_level(param_map.level, param_map.mission, param_map.world_setting, param_map.level_class_name, level_id, nil)
end

-- Lines: 4642 to 4653
function MenuCallbackHandler:save_game(item)
	if not managers.savefile:is_active() then
		local param_map = item:parameters()

		managers.savefile:save_game(param_map.slot, false)

		if managers.savefile:is_active() then
			managers.menu:set_save_game_callback(callback(self, self, "save_game_callback"))
		else
			self:save_game_callback()
		end
	end
end

-- Lines: 4655 to 4658
function MenuCallbackHandler:save_game_callback()
	managers.menu:set_save_game_callback(nil)
	managers.menu:back()
end

-- Lines: 4662 to 4699
function MenuCallbackHandler:start_the_game()
	local mutators_manager = managers.mutators

	if mutators_manager and mutators_manager:should_delay_game_start() then
		if not mutators_manager:_check_all_peers_are_ready() then
			mutators_manager:use_start_the_game_initial_delay()
		end

		mutators_manager:send_mutators_notification_to_clients(mutators_manager:delay_lobby_time())
		managers.menu:open_node("start_the_game_countdown")

		return
	end

	if self._game_started then
		return
	end

	self._game_started = true
	local level_id = Global.game_settings.level_id
	local level_name = level_id and tweak_data.levels[level_id].world_name

	if Global.boot_invite then
		Global.boot_invite.used = true
		Global.boot_invite.pending = false
	end

	local mission = Global.game_settings.mission ~= "none" and Global.game_settings.mission or nil
	local world_setting = Global.game_settings.world_setting

	managers.network:session():load_level(level_name, mission, world_setting, nil, level_id)
end

-- Lines: 4702 to 4704
function MenuCallbackHandler:cancel_start_the_game_countdown()
	managers.mutators:start_the_game_countdown_cancelled()
end

-- Lines: 4707 to 4716
function MenuCallbackHandler:restart_game(item)
	managers.menu:show_restart_game_dialog({yes_func = function ()
		if managers.job:stage_success() then
			print("No restart after stage success")

			return
		end

		managers.game_play_central:restart_the_game()
	end})
end

-- Lines: 4718 to 4729
function MenuCallbackHandler:set_music_volume(item)
	local volume = item:value()
	local old_volume = managers.user:get_setting("music_volume")

	managers.user:set_setting("music_volume", volume)

	if old_volume < volume then
		self._sound_source:post_event("slider_increase")
	elseif volume < old_volume then
		self._sound_source:post_event("slider_decrease")
	end
end

-- Lines: 4731 to 4742
function MenuCallbackHandler:set_sfx_volume(item)
	local volume = item:value()
	local old_volume = managers.user:get_setting("sfx_volume")

	managers.user:set_setting("sfx_volume", volume)

	if old_volume < volume then
		self._sound_source:post_event("slider_increase")
	elseif volume < old_volume then
		self._sound_source:post_event("slider_decrease")
	end
end

-- Lines: 4744 to 4755
function MenuCallbackHandler:set_voice_volume(item)
	local volume = item:value()
	local old_volume = managers.user:get_setting("voice_volume")

	managers.user:set_setting("voice_volume", volume)

	if old_volume < volume then
		self._sound_source:post_event("slider_increase")
	elseif volume < old_volume then
		self._sound_source:post_event("slider_decrease")
	end
end

-- Lines: 4757 to 4760
function MenuCallbackHandler:set_brightness(item)
	local brightness = item:value()

	managers.user:set_setting("brightness", brightness)
end

-- Lines: 4762 to 4766
function MenuCallbackHandler:set_effect_quality(item)
	local effect_quality = item:value()

	managers.user:set_setting("effect_quality", effect_quality)
end

-- Lines: 4768 to 4780
function MenuCallbackHandler:_update_linked_sliders(linked_sliders, value)
	local triggers = {}

	for _, item in ipairs(linked_sliders) do
		local slider = managers.menu:active_menu().logic:selected_node():item(item)

		if slider and slider:visible() and math.abs(value - slider:value()) > 0.001 then
			slider:set_value(value)
			table.insert(triggers, slider)
		end
	end

	for _, slider in ipairs(triggers) do
		slider:trigger()
	end
end

-- Lines: 4782 to 4793
function MenuCallbackHandler:set_camera_sensitivity(item)
	local value = item:value()

	managers.user:set_setting("camera_sensitivity", value)

	if not managers.user:get_setting("enable_camera_zoom_sensitivity") then
		local item_other_sens = managers.menu:active_menu().logic:selected_node():item("camera_zoom_sensitivity")

		if item_other_sens and item_other_sens:visible() and math.abs(value - item_other_sens:value()) > 0.001 then
			item_other_sens:set_value(value)
			item_other_sens:trigger()
		end
	end
end

-- Lines: 4795 to 4801
function MenuCallbackHandler:set_camera_sensitivity_x(item)
	local value = item:value()

	managers.user:set_setting("camera_sensitivity_x", value)

	if not managers.user:get_setting("enable_camera_sensitivity_separate") then
		self:_update_linked_sliders({
			"camera_sensitivity_vertical",
			"camera_zoom_sensitivity_horizontal",
			"camera_zoom_sensitivity_vertical"
		}, value)
	end
end

-- Lines: 4803 to 4809
function MenuCallbackHandler:set_camera_sensitivity_y(item)
	local value = item:value()

	managers.user:set_setting("camera_sensitivity_y", value)

	if not managers.user:get_setting("enable_camera_sensitivity_separate") then
		self:_update_linked_sliders({
			"camera_sensitivity_horizontal",
			"camera_zoom_sensitivity_horizontal",
			"camera_zoom_sensitivity_vertical"
		}, value)
	end
end

-- Lines: 4811 to 4818
function MenuCallbackHandler:toggle_camera_sensitivity_separate(item)
	local value = item:value() == "on"

	managers.user:set_setting("enable_camera_sensitivity_separate", value)
end

-- Lines: 4820 to 4831
function MenuCallbackHandler:set_camera_zoom_sensitivity(item)
	local value = item:value()

	managers.user:set_setting("camera_zoom_sensitivity", value)

	if not managers.user:get_setting("enable_camera_zoom_sensitivity") then
		local item_other_sens = managers.menu:active_menu().logic:selected_node():item("camera_sensitivity")

		if item_other_sens and item_other_sens:visible() and math.abs(value - item_other_sens:value()) > 0.001 then
			item_other_sens:set_value(value)
			item_other_sens:trigger()
		end
	end
end

-- Lines: 4833 to 4840
function MenuCallbackHandler:set_camera_zoom_sensitivity_x(item)
	local value = item:value()

	managers.user:set_setting("camera_zoom_sensitivity_x", value)

	if not managers.user:get_setting("enable_camera_sensitivity_separate") then
		self:_update_linked_sliders({
			"camera_sensitivity_horizontal",
			"camera_sensitivity_vertical",
			"camera_zoom_sensitivity_vertical"
		}, value)
	end
end

-- Lines: 4842 to 4849
function MenuCallbackHandler:set_camera_zoom_sensitivity_y(item)
	local value = item:value()

	managers.user:set_setting("camera_zoom_sensitivity_y", value)

	if not managers.user:get_setting("enable_camera_sensitivity_separate") then
		self:_update_linked_sliders({
			"camera_sensitivity_horizontal",
			"camera_sensitivity_vertical",
			"camera_zoom_sensitivity_horizontal"
		}, value)
	end
end

-- Lines: 4851 to 4861
function MenuCallbackHandler:toggle_zoom_sensitivity(item)
	local value = item:value() == "on"

	managers.user:set_setting("enable_camera_zoom_sensitivity", value)

	if value == false then
		local item_sens = managers.menu:active_menu().logic:selected_node():item("camera_sensitivity")
		local item_sens_zoom = managers.menu:active_menu().logic:selected_node():item("camera_zoom_sensitivity")

		item_sens_zoom:set_value(item_sens:value())
		item_sens_zoom:trigger()
	end
end

-- Lines: 4863 to 4866
function MenuCallbackHandler:toggle_fov_based_zoom(item)
	local value = item:value() == "on"

	managers.user:set_setting("enable_fov_based_sensitivity", value)
end

-- Lines: 4868 to 4869
function MenuCallbackHandler:is_current_resolution(item)
	return item:name() == string.format("%d x %d", RenderSettings.resolution.x, RenderSettings.resolution.y)
end

-- Lines: 4873 to 4889
function MenuCallbackHandler:end_game()
	local dialog_data = {
		title = managers.localization:text("dialog_warning_title"),
		text = managers.localization:text("dialog_are_you_sure_you_want_to_leave_game")
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "_dialog_end_game_yes")
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = callback(self, self, "_dialog_end_game_no"),
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

-- Lines: 4891 to 4921
function MenuCallbackHandler:_dialog_end_game_yes()
	managers.platform:set_playing(false)
	managers.job:clear_saved_ghost_bonus()
	managers.statistics:stop_session({quit = true})
	managers.savefile:save_progress()
	managers.job:deactivate_current_job()
	managers.gage_assignment:deactivate_assignments()
	managers.custom_safehouse:flush_completed_trophies()
	managers.crime_spree:on_left_lobby()

	if Network:multiplayer() then
		Network:set_multiplayer(false)
		managers.network:session():send_to_peers("set_peer_left")
		managers.network:queue_stop_network()
	end

	managers.network.matchmake:destroy_game()
	managers.network.voice_chat:destroy_voice()
	managers.groupai:state():set_AI_enabled(false)
	managers.menu:post_event("menu_exit")
	managers.menu:close_menu("menu_pause")
	setup:load_start_menu()
end

-- Lines: 4926 to 4929
function MenuCallbackHandler:leave_safehouse()
	
	-- Lines: 4924 to 4927
	local function yes_func()
		Global.load_crime_net = true

		self:_dialog_end_game_yes()
	end

	managers.menu:show_leave_safehouse_dialog({yes_func = yes_func})
end

-- Lines: 4931 to 4939
function MenuCallbackHandler:leave_mission()
	if game_state_machine:current_state_name() ~= "disconnected" then
		if self:is_singleplayer() then
			setup:load_start_menu()
		else
			self:load_start_menu_lobby()
		end
	end
end

-- Lines: 4941 to 4952
function MenuCallbackHandler:abort_mission()
	if game_state_machine:current_state_name() == "disconnected" then
		return
	end

	
	-- Lines: 4946 to 4950
	local function yes_func()
		if game_state_machine:current_state_name() ~= "disconnected" then
			self:load_start_menu_lobby()
		end
	end

	managers.menu:show_abort_mission_dialog({yes_func = yes_func})
end

-- Lines: 4954 to 4985
function MenuCallbackHandler:load_start_menu_lobby()
	managers.job:clear_saved_ghost_bonus()
	managers.job:stop_sounds()
	managers.experience:mission_xp_clear()
	managers.custom_safehouse:flush_completed_trophies()
	managers.network:session():load_lobby()
end

-- Lines: 4987 to 4988
function MenuCallbackHandler:_dialog_end_game_no()
end

-- Lines: 4990 to 4993
function MenuCallbackHandler:_reset_mainmusic()
	managers.music:post_event("stop_all_music")
	managers.music:post_event(managers.music:jukebox_menu_track("mainmenu"))
end

-- Lines: 4995 to 5009
function MenuCallbackHandler:show_steam_controller_binding_panel()
	if MenuCallbackHandler:is_not_steam_controller() then
		return
	end

	local controller = managers.controller:get_default_controller()

	if controller then
		if controller:show_binding_panel() then
			-- Nothing
		elseif MenuCallbackHandler:is_overlay_enabled() then
			managers.menu:show_requires_big_picture()
		else
			managers.menu:show_enable_steam_overlay()
		end
	end
end

-- Lines: 5011 to 5024
function MenuCallbackHandler:set_default_options()
	local params = {
		text = managers.localization:text("dialog_default_options_message"),
		callback = function ()
			managers.user:reset_setting_map()
			managers.music:jukebox_set_defaults()
			self:_reset_mainmusic()

			if Global.crimenet then
				Global.crimenet.quickplay = {}
			end

			managers.mutators:reset_all_mutators()
		end
	}

	managers.menu:show_default_option_dialog(params)
end

-- Lines: 5026 to 5032
function MenuCallbackHandler:set_default_control_options()
	local params = {
		text = managers.localization:text("dialog_default_controls_options_message"),
		callback = function ()
			managers.user:reset_controls_setting_map()
			self:refresh_node()
		end
	}

	managers.menu:show_default_option_dialog(params)
end

-- Lines: 5034 to 5055
function MenuCallbackHandler:set_default_video_options()
	local params = {
		text = managers.localization:text("dialog_default_video_options_message"),
		callback = function ()
			managers.user:reset_video_setting_map()
			managers.viewport:reset_viewport_settings()
			Application:reset_render_settings({
				"anti_aliasing",
				"max_anisotropy",
				"shadow_quality",
				"shadow_quality_default",
				"texture_quality_default"
			})
			self:refresh_node()
		end
	}

	managers.menu:show_default_option_dialog(params)
end

-- Lines: 5057 to 5063
function MenuCallbackHandler:set_default_sound_options()
	local params = {
		text = managers.localization:text("dialog_default_sound_options_message"),
		callback = function ()
			managers.user:reset_sound_setting_map()
			managers.music:jukebox_set_defaults()
			self:refresh_node()
			self:_reset_mainmusic()
		end
	}

	managers.menu:show_default_option_dialog(params)
end

-- Lines: 5065 to 5071
function MenuCallbackHandler:set_default_network_options()
	local params = {
		text = managers.localization:text("dialog_default_network_options_message"),
		callback = function ()
			managers.user:reset_network_setting_map()
			self:refresh_node()
		end
	}

	managers.menu:show_default_option_dialog(params)
end

-- Lines: 5073 to 5075
function MenuCallbackHandler:resume_game()
	managers.menu:close_menu("menu_pause")
end

-- Lines: 5078 to 5081
function MenuManager:on_heister_interaction()
	self:open_menu("heister_interact_menu")

	self._heister_interaction = true
end

-- Lines: 5083 to 5092
function MenuManager:on_resume_heister_interaction()
	self:close_menu("heister_interact_menu")

	self._heister_interaction = false
	local player_unit = managers.player:player_unit()

	if alive(player_unit) and player_unit:movement():current_state().update_check_actions_paused then
		player_unit:movement():current_state():update_check_actions_paused()
	end
end

-- Lines: 5094 to 5096
function MenuCallbackHandler:heister_interaction_resume_game()
	managers.menu:on_resume_heister_interaction()
end

-- Lines: 5099 to 5100
function MenuCallbackHandler:change_upgrade(menu_item)
end

-- Lines: 5102 to 5110
function MenuCallbackHandler:delayed_open_savefile_menu(item)
	if not self._delayed_open_savefile_menu_callback then
		if managers.savefile:is_active() then
			managers.menu:set_delayed_open_savefile_menu_callback(callback(self, self, "open_savefile_menu", item))
		else
			self:open_savefile_menu(item)
		end
	end
end

-- Lines: 5112 to 5117
function MenuCallbackHandler:open_savefile_menu(item)
	managers.menu:set_delayed_open_savefile_menu_callback(nil)

	local parameter_map = item:parameters()

	managers.menu:open_node(parameter_map.delayed_node, {parameter_map})
end

-- Lines: 5119 to 5121
function MenuCallbackHandler:hide_huds()
	managers.hud:set_disabled()
end

-- Lines: 5123 to 5129
function MenuCallbackHandler:toggle_hide_huds(item)
	if item:value() == "on" then
		managers.hud:set_disabled()
	else
		managers.hud:set_enabled()
	end
end

-- Lines: 5131 to 5133
function MenuCallbackHandler:toggle_mission_fading_debug_enabled(item)
	managers.mission:set_fading_debug_enabled(item:value() == "off")
end

-- Lines: 5135 to 5137
function MenuCallbackHandler:menu_back()
	managers.menu:back()
end

-- Lines: 5139 to 5155
function MenuCallbackHandler:clear_progress()
	local dialog_data = {
		title = managers.localization:text("dialog_warning_title"),
		text = managers.localization:text("dialog_are_you_sure_you_want_to_clear_progress")
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "_dialog_clear_progress_yes")
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = callback(self, self, "_dialog_clear_progress_no"),
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

-- Lines: 5157 to 5172
function MenuCallbackHandler:_dialog_clear_progress_yes()
	managers.menu:do_clear_progress()

	if managers.menu_component then
		managers.menu_component:refresh_player_profile_gui()
	end

	managers.savefile:save_progress()
	managers.savefile:save_setting(true)
end

-- Lines: 5174 to 5175
function MenuCallbackHandler:_dialog_clear_progress_no()
end

-- Lines: 5177 to 5193
function MenuCallbackHandler:set_default_controller(item)
	local params = {
		text = managers.localization:text("dialog_use_default_keys_message"),
		callback = function ()
			managers.controller:load_settings("settings/controller_settings")
			managers.controller:clear_user_mod(item:parameters().category, MenuCustomizeControllerCreator.CONTROLS_INFO)

			local logic = managers.menu:active_menu().logic

			if logic then
				logic:refresh_node()
			end
		end
	}

	managers.menu:show_default_option_dialog(params)
end

-- Lines: 5195 to 5198
function MenuCallbackHandler:choice_button_layout_category(item)
	local node_gui = managers.menu:active_menu().renderer:active_node_gui()

	node_gui:set_current_category(item:value())
end

-- Lines: 5200 to 5223
function MenuCallbackHandler:debug_goto_custody()
	local player = managers.player:player_unit()

	if not alive(player) then
		return
	end

	if managers.player:current_state() ~= "bleed_out" then
		managers.player:set_player_state("bleed_out")
	end

	if managers.player:current_state() ~= "fatal" then
		managers.player:set_player_state("fatal")
	end

	managers.player:force_drop_carry()
	managers.statistics:downed({death = true})
	IngameFatalState.on_local_player_dead()
	game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
	player:character_damage():set_invulnerable(true)
	player:character_damage():set_health(0)
	player:base():_unregister()
	player:base():set_slot(player, 0)
end
MenuUpgrades = MenuUpgrades or class()

-- Lines: 5230 to 5275
function MenuUpgrades:modify_node(node, up, ...)
	local new_node = up and node or deep_clone(node)
	local tree = new_node:parameters().tree
	local first_locked = true

	for i, upgrade_id in ipairs(tweak_data.upgrades.progress[tree]) do
		local title = managers.upgrades:title(upgrade_id) or managers.upgrades:name(upgrade_id)
		local subtitle = managers.upgrades:subtitle(upgrade_id)
		local params = {
			localize = "false",
			step = i,
			tree = tree,
			name = upgrade_id,
			upgrade_id = upgrade_id,
			text_id = string.upper(title and subtitle or title),
			topic_text = subtitle and title and string.upper(title)
		}

		if tweak_data.upgrades.visual.upgrade[upgrade_id] and not tweak_data.upgrades.visual.upgrade[upgrade_id].base and i <= managers.upgrades:progress_by_tree(tree) then
			params.callback = "toggle_visual_upgrade"
		end

		if managers.upgrades:is_locked(i) and first_locked then
			first_locked = false

			new_node:add_item(new_node:create_item({type = "MenuItemUpgrade"}, {
				upgrade_lock = true,
				name = "upgrade_lock",
				localize = "false",
				text_id = managers.localization:text("menu_upgrades_locked", {LEVEL = managers.upgrades:get_level_from_step(i)})
			}))
		end

		local new_item = new_node:create_item({type = "MenuItemUpgrade"}, params)

		new_node:add_item(new_item)
	end

	managers.menu:add_back_button(new_node)

	return new_node
end

-- Lines: 5278 to 5289
function MenuCallbackHandler:toggle_visual_upgrade(item)
	managers.upgrades:toggle_visual_weapon_upgrade(item:parameters().upgrade_id)
	managers.upgrades:setup_current_weapon()

	if managers.upgrades:visual_weapon_upgrade_active(item:parameters().upgrade_id) then
		self._sound_source:post_event("box_tick")
	else
		self._sound_source:post_event("box_untick")
	end

	print("Toggled", item:parameters().upgrade_id)
end
InviteFriendsPSN = InviteFriendsPSN or class()

-- Lines: 5297 to 5313
function InviteFriendsPSN:modify_node(node, up)
	local new_node = up and node or deep_clone(node)

	
	-- Lines: 5304 to 5306
	local function f2(friends)
		managers.menu:active_menu().logic:refresh_node("invite_friends", true, friends)
	end

	managers.network.friends:register_callback("get_friends_done", f2)
	managers.network.friends:register_callback("status_change", function ()
	end)
	managers.network.friends:get_friends(new_node)

	return new_node
end

-- Lines: 5317 to 5347
function InviteFriendsPSN:refresh_node(node, friends)
	for i, friend in ipairs(friends) do
		if i < 103 then
			local name = tostring(friend._name)
			local signin_status = friend._signin_status
			local item = node:item(name)

			if not item then
				local params = {
					callback = "invite_friend",
					localize = "false",
					name = name,
					friend = friend._id,
					text_id = utf8.to_upper(friend._name),
					signin_status = signin_status
				}
				local new_item = node:create_item({type = "MenuItemFriend"}, params)

				node:add_item(new_item)
			elseif item:parameters().signin_status ~= signin_status then
				item:parameters().signin_status = signin_status
			end
		end
	end

	return node
end

-- Lines: 5380 to 5388
function InviteFriendsPSN:update_node(node)
	if self._update_friends_t and Application:time() < self._update_friends_t then
		return
	end

	self._update_friends_t = Application:time() + 2

	managers.network.friends:get_friends()
end
InviteFriendsSTEAM = InviteFriendsSTEAM or class()

-- Lines: 5496 to 5497
function InviteFriendsSTEAM:modify_node(node, up)
	return node
end

-- Lines: 5500 to 5501
function InviteFriendsSTEAM:refresh_node(node, friend)
	return node
end

-- Lines: 5504 to 5505
function InviteFriendsSTEAM:update_node(node)
end
PauseMenu = PauseMenu or class()

-- Lines: 5510 to 5524
function PauseMenu:modify_node(node)
	local item = node:item("restart_vote")

	if item then
		item:set_enabled(managers.vote:available())
		item:set_parameter("help_id", managers.vote:help_text() or "")
	end

	if managers.vote:is_restarting() then
		item = node:item("restart_level")

		if item then
			item:set_enabled(false)
		end
	end

	return node
end

-- Lines: 5527 to 5528
function PauseMenu:refresh_node(node)
	return self:modify_node(node)
end
KickPlayer = KickPlayer or class()

-- Lines: 5534 to 5563
function KickPlayer:modify_node(node, up)
	node:clean_items()

	if managers.network:session() then
		for _, peer in pairs(managers.network:session():peers()) do
			local params = {
				localize = false,
				localize_help = false,
				callback = "kick_player",
				to_upper = false,
				name = peer:name(),
				text_id = peer:name() .. " (" .. (peer:rank() > 0 and managers.experience:rank_string(peer:rank()) .. "-" or "") .. (peer:level() or "") .. ")",
				rpc = peer:rpc(),
				peer = peer,
				help_id = peer:is_host() and managers.localization:text("menu_vote_kick_is_host") or managers.vote:option_vote_kick() and managers.vote:help_text() or ""
			}
			local new_item = node:create_item(nil, params)

			if peer:is_host() or managers.vote:option_vote_kick() and not managers.vote:available() then
				new_item:set_enabled(false)
			end

			node:add_item(new_item)
		end
	end

	managers.menu:add_back_button(node)

	return node
end

-- Lines: 5566 to 5567
function KickPlayer:refresh_node(node)
	return self:modify_node(node)
end
MutePlayer = MutePlayer or class()

-- Lines: 5573 to 5603
function MutePlayer:modify_node(node, up)
	local new_node = deep_clone(node)

	if managers.network:session() then
		for _, peer in pairs(managers.network:session():peers()) do
			local params = {
				callback = "mute_player",
				localize = "false",
				to_upper = false,
				name = peer:name(),
				text_id = peer:name() .. " (" .. (peer:rank() > 0 and managers.experience:rank_string(peer:rank()) .. "-" or "") .. (peer:level() or "") .. ")",
				rpc = peer:rpc(),
				peer = peer
			}
			local data = {
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "on",
					s_w = 24,
					s_h = 24,
					s_x = 24,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 24,
					s_icon = "guis/textures/menu_tickbox"
				},
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "off",
					s_w = 24,
					s_h = 24,
					s_x = 0,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 0,
					s_icon = "guis/textures/menu_tickbox"
				},
				type = "CoreMenuItemToggle.ItemToggle"
			}
			local new_item = node:create_item(data, params)

			new_item:set_value(peer:is_muted() and "on" or "off")
			new_node:add_item(new_item)
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MutePlayerX360 = MutePlayerX360 or class()

-- Lines: 5608 to 5640
function MutePlayerX360:modify_node(node, up)
	local new_node = deep_clone(node)

	if managers.network:session() then
		for _, peer in pairs(managers.network:session():peers()) do
			local params = {
				localize = "false",
				to_upper = false,
				callback = "mute_xbox_player",
				name = peer:name(),
				text_id = peer:name(),
				rpc = peer:rpc(),
				peer = peer,
				xuid = peer:xuid()
			}
			local data = {
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "on",
					s_w = 24,
					s_h = 24,
					s_x = 24,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 24,
					s_icon = "guis/textures/menu_tickbox"
				},
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "off",
					s_w = 24,
					s_h = 24,
					s_x = 0,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 0,
					s_icon = "guis/textures/menu_tickbox"
				},
				type = "CoreMenuItemToggle.ItemToggle"
			}
			local new_item = node:create_item(data, params)

			new_item:set_value(peer:is_muted() and "on" or "off")
			new_node:add_item(new_item)
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MutePlayerXB1 = MutePlayerXB1 or class()

-- Lines: 5645 to 5677
function MutePlayerXB1:modify_node(node, up)
	local new_node = deep_clone(node)

	if managers.network:session() then
		for _, peer in pairs(managers.network:session():peers()) do
			local params = {
				localize = "false",
				to_upper = false,
				callback = "mute_xb1_player",
				name = peer:name(),
				text_id = peer:name(),
				rpc = peer:rpc(),
				peer = peer,
				xuid = peer:xuid()
			}
			local data = {
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "on",
					s_w = 24,
					s_h = 24,
					s_x = 24,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 24,
					s_icon = "guis/textures/menu_tickbox"
				},
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "off",
					s_w = 24,
					s_h = 24,
					s_x = 0,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 0,
					s_icon = "guis/textures/menu_tickbox"
				},
				type = "CoreMenuItemToggle.ItemToggle"
			}
			local new_item = node:create_item(data, params)

			new_item:set_value(peer:is_muted() and "on" or "off")
			new_node:add_item(new_item)
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MutePlayerPS4 = MutePlayerPS4 or class()

-- Lines: 5682 to 5714
function MutePlayerPS4:modify_node(node, up)
	local new_node = deep_clone(node)

	if managers.network:session() then
		for _, peer in pairs(managers.network:session():peers()) do
			local params = {
				callback = "mute_ps4_player",
				localize = "false",
				to_upper = false,
				name = peer:name(),
				text_id = peer:name(),
				rpc = peer:rpc(),
				peer = peer
			}
			local data = {
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "on",
					s_w = 24,
					s_h = 24,
					s_x = 24,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 24,
					s_icon = "guis/textures/menu_tickbox"
				},
				{
					w = 24,
					y = 0,
					h = 24,
					s_y = 24,
					value = "off",
					s_w = 24,
					s_h = 24,
					s_x = 0,
					_meta = "option",
					icon = "guis/textures/menu_tickbox",
					x = 0,
					s_icon = "guis/textures/menu_tickbox"
				},
				type = "CoreMenuItemToggle.ItemToggle"
			}
			local new_item = node:create_item(data, params)

			new_item:set_value(peer:is_muted() and "on" or "off")
			new_node:add_item(new_item)
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
ViewGamerCard = ViewGamerCard or class()

-- Lines: 5720 to 5741
function ViewGamerCard:modify_node(node, up)
	local new_node = deep_clone(node)

	if managers.network:session() then
		for _, peer in pairs(managers.network:session():peers()) do
			local params = {
				localize = "false",
				to_upper = false,
				callback = "view_gamer_card",
				name = peer:name(),
				text_id = peer:name(),
				xuid = peer:xuid()
			}
			local new_item = node:create_item(nil, params)

			new_node:add_item(new_item)
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MenuPSNHostBrowser = MenuPSNHostBrowser or class()

-- Lines: 5748 to 5751
function MenuPSNHostBrowser:modify_node(node, up)
	local new_node = up and node or deep_clone(node)

	return new_node
end

-- Lines: 5754 to 5760
function MenuPSNHostBrowser:update_node(node)
	if #PSN:get_world_list() == 0 then
		return
	end

	managers.network.matchmake:start_search_lobbys(managers.network.matchmake:searching_friends_only())
end

-- Lines: 5762 to 5797
function MenuPSNHostBrowser:add_filter(node)
	if node:item("difficulty_filter") then
		return
	end

	local params = {
		visible_callback = "is_ps3",
		name = "difficulty_filter",
		callback = "choice_difficulty_filter_ps3",
		text_id = "menu_diff_filter",
		help_id = "menu_diff_filter_help",
		filter = true
	}
	local data_node = {
		{
			value = 0,
			text_id = "menu_all",
			_meta = "option"
		},
		{
			value = 1,
			text_id = "menu_difficulty_easy",
			_meta = "option"
		},
		{
			value = 2,
			text_id = "menu_difficulty_normal",
			_meta = "option"
		},
		{
			value = 3,
			text_id = "menu_difficulty_hard",
			_meta = "option"
		},
		{
			value = 4,
			text_id = "menu_difficulty_overkill",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}

	if managers.experience:current_level() >= 145 then
		table.insert(data_node, {
			value = 5,
			text_id = "menu_difficulty_overkill_145",
			_meta = "option"
		})
	end

	local new_item = node:create_item(data_node, params)

	new_item:set_value(managers.network.matchmake:difficulty_filter())
	node:add_item(new_item)
end

-- Lines: 5804 to 5910
function MenuPSNHostBrowser:refresh_node(node, info_list, friends_only)
	local new_node = node

	if not friends_only then
		self:add_filter(new_node)
	end

	if not info_list then
		return new_node
	end

	local dead_list = {}

	for _, item in ipairs(node:items()) do
		if not item:parameters().filter then
			dead_list[item:parameters().name] = true
		end
	end

	for _, info in ipairs(info_list) do
		local room_list = info.room_list
		local attribute_list = info.attribute_list

		for i, room in ipairs(room_list) do
			local name_str = tostring(room.owner_id)
			local friend_str = room.friend_id and tostring(room.friend_id)
			local attributes_numbers = attribute_list[i].numbers

			if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
				dead_list[name_str] = nil
				local host_name = name_str
				local level_id = attributes_numbers and tweak_data.levels:get_level_name_from_index(attributes_numbers[1] % 1000)
				local name_id = level_id and tweak_data.levels[level_id] and tweak_data.levels[level_id].name_id or "N/A"
				local level_name = name_id and managers.localization:text(name_id) or "LEVEL NAME ERROR"
				local difficulty = attributes_numbers and tweak_data:index_to_difficulty(attributes_numbers[2]) or "N/A"
				local state_string_id = attributes_numbers and tweak_data:index_to_server_state(attributes_numbers[4]) or nil
				local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "N/A"
				local state = attributes_numbers or "N/A"
				local item = new_node:item(name_str)
				local num_plrs = attributes_numbers and attributes_numbers[8] or 1

				if not item then
					local params = {
						localize = "false",
						callback = "connect_to_lobby",
						name = name_str,
						text_id = name_str,
						room_id = room.room_id,
						columns = {
							string.upper(friend_str or host_name),
							string.upper(level_name),
							string.upper(state_name),
							tostring(num_plrs) .. "/4 "
						},
						level_name = level_id or "N/A",
						real_level_name = level_name,
						level_id = level_id,
						state_name = state_name,
						difficulty = difficulty,
						host_name = host_name,
						state = state,
						num_plrs = num_plrs
					}
					local new_item = new_node:create_item({type = "ItemServerColumn"}, params)

					new_node:add_item(new_item)
				else
					if item:parameters().real_level_name ~= level_name then
						item:parameters().columns[2] = string.upper(level_name)
						item:parameters().level_name = level_id
						item:parameters().level_id = level_id
						item:parameters().real_level_name = level_name
					end

					if item:parameters().state ~= state then
						item:parameters().columns[3] = state_name
						item:parameters().state = state
						item:parameters().state_name = state_name
					end

					if item:parameters().difficulty ~= difficulty then
						item:parameters().difficulty = difficulty
					end

					if item:parameters().room_id ~= room.room_id then
						item:parameters().room_id = room.room_id
					end

					if item:parameters().num_plrs ~= num_plrs then
						item:parameters().num_plrs = num_plrs
						item:parameters().columns[4] = tostring(num_plrs) .. "/4 "
					end
				end
			end
		end
	end

	for name, _ in pairs(dead_list) do
		new_node:delete_item(name)
	end

	return new_node
end
MenuSTEAMHostBrowser = MenuSTEAMHostBrowser or class()

-- Lines: 5917 to 5919
function MenuSTEAMHostBrowser:modify_node(node, up)
	local new_node = up and node or deep_clone(node)

	return new_node
end

-- Lines: 5927 to 5929
function MenuSTEAMHostBrowser:update_node(node)
	managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
end

-- Lines: 5932 to 5986
function MenuSTEAMHostBrowser:add_filter(node)
	if node:item("server_filter") then
		return
	end

	local params = {
		visible_callback = "is_pc_controller",
		name = "server_filter",
		callback = "choice_distance_filter",
		text_id = "menu_dist_filter",
		help_id = "menu_dist_filter_help",
		filter = true
	}
	local data_node = {
		{
			value = 0,
			text_id = "menu_dist_filter_close",
			_meta = "option"
		},
		{
			value = 1,
			text_id = "menu_dist_filter_default",
			_meta = "option"
		},
		{
			value = 2,
			text_id = "menu_dist_filter_far",
			_meta = "option"
		},
		{
			value = 3,
			text_id = "menu_dist_filter_worldwide",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_value(managers.network.matchmake:distance_filter())
	node:add_item(new_item)

	local params = {
		visible_callback = "is_pc_controller",
		name = "difficulty_filter",
		callback = "choice_difficulty_filter",
		text_id = "menu_diff_filter",
		help_id = "menu_diff_filter_help",
		filter = true
	}
	local data_node = {
		{
			value = 0,
			text_id = "menu_all",
			_meta = "option"
		},
		{
			value = 1,
			text_id = "menu_difficulty_easy",
			_meta = "option"
		},
		{
			value = 2,
			text_id = "menu_difficulty_normal",
			_meta = "option"
		},
		{
			value = 3,
			text_id = "menu_difficulty_hard",
			_meta = "option"
		},
		{
			value = 4,
			text_id = "menu_difficulty_overkill",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}

	if managers.experience:current_level() >= 145 then
		table.insert(data_node, {
			value = 5,
			text_id = "menu_difficulty_overkill_145",
			_meta = "option"
		})
	end

	local new_item = node:create_item(data_node, params)

	new_item:set_value(managers.network.matchmake:difficulty_filter())
	node:add_item(new_item)
end

-- Lines: 5989 to 6107
function MenuSTEAMHostBrowser:refresh_node(node, info, friends_only)
	local new_node = node

	if not friends_only then
		self:add_filter(new_node)
	end

	if not info then
		managers.menu:add_back_button(new_node)

		return new_node
	end

	local room_list = info.room_list
	local attribute_list = info.attribute_list
	local dead_list = {}

	for _, item in ipairs(node:items()) do
		if not item:parameters().back and not item:parameters().filter and not item:parameters().pd2_corner then
			dead_list[item:parameters().room_id] = true
		end
	end

	for i, room in ipairs(room_list) do
		local name_str = tostring(room.owner_name)
		local attributes_numbers = attribute_list[i].numbers
		local attributes_mutators = attribute_list[i].mutators

		if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers, nil, attributes_mutators) then
			dead_list[room.room_id] = nil
			local host_name = name_str
			local level_id = tweak_data.levels:get_level_name_from_index(attributes_numbers[1] % 1000)
			local name_id = level_id and tweak_data.levels[level_id] and tweak_data.levels[level_id].name_id
			local level_name = name_id and managers.localization:text(name_id) or "LEVEL NAME ERROR"
			local difficulty = tweak_data:index_to_difficulty(attributes_numbers[2])
			local state_string_id = tweak_data:index_to_server_state(attributes_numbers[4])
			local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "blah"
			local state = attributes_numbers[4]
			local num_plrs = attributes_numbers[5]
			local item = new_node:item(room.room_id)

			if not item then
				print("ADD", name_str)

				local params = {
					localize = "false",
					callback = "connect_to_lobby",
					name = room.room_id,
					text_id = name_str,
					room_id = room.room_id,
					columns = {
						utf8.to_upper(host_name),
						utf8.to_upper(level_name),
						utf8.to_upper(state_name),
						tostring(num_plrs) .. "/4 "
					},
					level_name = level_id,
					real_level_name = level_name,
					level_id = level_id,
					state_name = state_name,
					difficulty = difficulty,
					host_name = host_name,
					state = state,
					num_plrs = num_plrs
				}
				local new_item = new_node:create_item({type = "ItemServerColumn"}, params)

				new_node:add_item(new_item)
			else
				if item:parameters().real_level_name ~= level_name then
					item:parameters().columns[2] = utf8.to_upper(level_name)
					item:parameters().level_name = level_id
					item:parameters().level_id = level_id
					item:parameters().real_level_name = level_name
				end

				if item:parameters().state ~= state then
					item:parameters().columns[3] = state_name
					item:parameters().state = state
					item:parameters().state_name = state_name
				end

				if item:parameters().difficulty ~= difficulty then
					item:parameters().difficulty = difficulty
				end

				if item:parameters().room_id ~= room.room_id then
					item:parameters().room_id = room.room_id
				end

				if item:parameters().num_plrs ~= num_plrs then
					item:parameters().num_plrs = num_plrs
					item:parameters().columns[4] = tostring(num_plrs) .. "/4 "
				end
			end
		end
	end

	for name, _ in pairs(dead_list) do
		new_node:delete_item(name)
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MenuLANHostBrowser = MenuLANHostBrowser or class()

-- Lines: 6117 to 6119
function MenuLANHostBrowser:modify_node(node, up)
	local new_node = up and node or deep_clone(node)

	return new_node
end

-- Lines: 6122 to 6175
function MenuLANHostBrowser:refresh_node(node)
	local new_node = node
	local hosts = managers.network:session():discovered_hosts()

	for _, host_data in ipairs(hosts) do
		local host_rpc = host_data.rpc
		local name_str = host_data.host_name .. ", " .. host_rpc:to_string()
		local level_id = tweak_data.levels:get_level_name_from_world_name(host_data.level_name)
		local name_id = level_id and tweak_data.levels[level_id] and tweak_data.levels[level_id].name_id
		local level_name = name_id and managers.localization:text(name_id) or host_data.level_name
		local state_name = host_data.state == 1 and managers.localization:text("menu_lobby_server_state_in_lobby") or managers.localization:text("menu_lobby_server_state_in_game")
		local item = new_node:item(name_str)

		if not item then
			local params = {
				localize = "false",
				callback = "connect_to_host_rpc",
				name = name_str,
				text_id = name_str,
				columns = {
					string.upper(host_data.host_name),
					string.upper(level_name),
					string.upper(state_name)
				},
				rpc = host_rpc,
				level_name = host_data.level_name,
				real_level_name = level_name,
				level_id = level_id,
				state_name = state_name,
				difficulty = host_data.difficulty,
				host_name = host_data.host_name,
				state = host_data.state
			}
			local new_item = new_node:create_item({type = "ItemServerColumn"}, params)

			new_node:add_item(new_item)
		else
			if item:parameters().real_level_name ~= level_name then
				item:parameters().columns[2] = string.upper(level_name)
				item:parameters().level_name = host_data.level_name
				item:parameters().real_level_name = level_name
			end

			if item:parameters().state ~= host_data.state then
				item:parameters().columns[3] = state_name
				item:parameters().state = host_data.state
			end

			if item:parameters().difficulty ~= host_data.difficulty then
				item:parameters().difficulty = host_data.difficulty
			end
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MenuMPHostBrowser = MenuMPHostBrowser or class()

-- Lines: 6182 to 6187
function MenuMPHostBrowser:modify_node(node, up)
	local new_node = up and node or deep_clone(node)

	managers.menu:add_back_button(new_node)

	return new_node
end

-- Lines: 6190 to 6255
function MenuMPHostBrowser:refresh_node(node)
	local new_node = node
	local hosts = managers.network:session():discovered_hosts()
	local j = 1

	for _, host_data in ipairs(hosts) do
		local host_rpc = host_data.rpc
		local name_str = host_data.host_name .. ", " .. host_rpc:to_string()
		local level_id = tweak_data.levels:get_level_name_from_world_name(host_data.level_name)
		local name_id = level_id and tweak_data.levels[level_id] and tweak_data.levels[level_id].name_id
		local level_name = name_id and managers.localization:text(name_id) or host_data.level_name
		local state_name = host_data.state == 1 and managers.localization:text("menu_lobby_server_state_in_lobby") or managers.localization:text("menu_lobby_server_state_in_game")
		local item = new_node:item(name_str)

		if not item then
			local params = {
				localize = "false",
				callback = "connect_to_host_rpc",
				name = name_str,
				text_id = name_str,
				columns = {
					string.upper(host_data.host_name),
					string.upper(level_name),
					string.upper(state_name)
				},
				rpc = host_rpc,
				level_name = host_data.level_name,
				real_level_name = level_name,
				level_id = level_id,
				state_name = state_name,
				difficulty = host_data.difficulty,
				host_name = host_data.host_name,
				state = host_data.state
			}
			local new_item = new_node:create_item({type = "ItemServerColumn"}, params)

			new_node:add_item(new_item)
		else
			if item:parameters().real_level_name ~= level_name then
				print("Update level_name - ", level_name)

				item:parameters().columns[2] = string.upper(level_name)
				item:parameters().level_name = host_data.level_name
				item:parameters().real_level_name = level_name
			end

			if item:parameters().state ~= host_data.state then
				item:parameters().columns[3] = state_name
				item:parameters().state = host_data.state
			end

			if item:parameters().difficulty ~= host_data.difficulty then
				item:parameters().difficulty = host_data.difficulty
			end
		end

		j = j + 1
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MenuResolutionCreator = MenuResolutionCreator or class()

-- Lines: 6261 to 6288
function MenuResolutionCreator:modify_node(node)
	local new_node = deep_clone(node)

	if SystemInfo:platform() == Idstring("WIN32") then
		for _, res in ipairs(RenderSettings.modes) do
			local res_string = string.format("%d x %d", res.x, res.y)

			if not new_node:item(res_string) then
				local params = {
					callback = "change_resolution",
					localize = "false",
					icon = "guis/textures/scrollarrow",
					icon_rotation = 90,
					icon_visible_callback = "is_current_resolution",
					name = res_string,
					text_id = res_string,
					resolution = res
				}
				local new_item = new_node:create_item(nil, params)

				new_node:add_item(new_item)
			end
		end
	end

	managers.menu:add_back_button(new_node)

	return new_node
end
MenuSoundCreator = MenuSoundCreator or class()

-- Lines: 6292 to 6338
function MenuSoundCreator:modify_node(node)
	local music_item = node:item("music_volume")

	if music_item then
		music_item:set_min(_G.tweak_data.menu.MIN_MUSIC_VOLUME)
		music_item:set_max(_G.tweak_data.menu.MAX_MUSIC_VOLUME)
		music_item:set_step(_G.tweak_data.menu.MUSIC_CHANGE)
		music_item:set_value(managers.user:get_setting("music_volume"))
	end

	local sfx_item = node:item("sfx_volume")

	if sfx_item then
		sfx_item:set_min(_G.tweak_data.menu.MIN_SFX_VOLUME)
		sfx_item:set_max(_G.tweak_data.menu.MAX_SFX_VOLUME)
		sfx_item:set_step(_G.tweak_data.menu.SFX_CHANGE)
		sfx_item:set_value(managers.user:get_setting("sfx_volume"))
	end

	local voice_item = node:item("voice_volume")

	if voice_item then
		voice_item:set_min(_G.tweak_data.menu.MIN_VOICE_VOLUME)
		voice_item:set_max(_G.tweak_data.menu.MAX_VOICE_VOLUME)
		voice_item:set_step(_G.tweak_data.menu.VOICE_CHANGE)
		voice_item:set_value(managers.user:get_setting("voice_volume"))
	end

	local option_value = "on"
	local st_item = node:item("toggle_voicechat")

	if st_item then
		if not managers.user:get_setting("voice_chat") then
			option_value = "off"
		end

		st_item:set_value(option_value)
	end

	option_value = "on"
	local st_item = node:item("toggle_push_to_talk")

	if st_item then
		if not managers.user:get_setting("push_to_talk") then
			option_value = "off"
		end

		st_item:set_value(option_value)
	end

	return node
end

-- Lines: 6341 to 6343
function MenuSoundCreator:refresh_node(node)
	self:modify_node(node)
end

-- Lines: 6347 to 6408
function MenuManager.refresh_level_select(node, verify_dlc_owned)
	if verify_dlc_owned and tweak_data.levels[Global.game_settings.level_id].dlc then
		local dlcs = string.split(managers.dlc:dlcs_string(), " ")

		if not table.contains(dlcs, tweak_data.levels[Global.game_settings.level_id].dlc) then
			Global.game_settings.level_id = "bank"
		end
	end

	local min_difficulty = 0

	for _, item in ipairs(node:items()) do
		local level_id = item:parameter("level_id")

		if level_id then
			if level_id == Global.game_settings.level_id then
				min_difficulty = tonumber(item:parameter("difficulty"))
			elseif item:visible() then
				-- Nothing
			end
		end
	end

	Global.game_settings.difficulty = min_difficulty < tweak_data:difficulty_to_index(Global.game_settings.difficulty) and Global.game_settings.difficulty or tweak_data:index_to_difficulty(min_difficulty)
	local item_difficulty = node:item("lobby_difficulty")

	if item_difficulty then
		for i, option in ipairs(item_difficulty:options()) do
			option:parameters().exclude = tonumber(option:parameters().difficulty) < min_difficulty
		end

		item_difficulty:set_value(Global.game_settings.difficulty)
	end

	local lobby_mission_item = node:item("lobby_mission")
	local mission_data = tweak_data.levels[Global.game_settings.level_id].mission_data

	if lobby_mission_item then
		print("lobby_mission_item")

		local params = {
			callback = "choice_lobby_mission",
			name = "lobby_mission",
			localize = "false",
			text_id = "menu_choose_mission"
		}
		local data_node = {type = "MenuItemMultiChoice"}

		if mission_data then
			for _, data in ipairs(mission_data) do
				table.insert(data_node, {
					localize = false,
					_meta = "option",
					text_id = data.mission,
					value = data.mission
				})
			end
		else
			table.insert(data_node, {
				value = "none",
				text_id = "none",
				localize = false,
				_meta = "option"
			})
		end

		lobby_mission_item:init(data_node, params)
		lobby_mission_item:set_callback_handler(MenuCallbackHandler:new())
		lobby_mission_item:set_value(data_node[1].value)
	end

	Global.game_settings.mission = mission_data and mission_data[1] and mission_data[1].mission or "none"
end
MenuPSNPlayerProfileInitiator = MenuPSNPlayerProfileInitiator or class()

-- Lines: 6411 to 6415
function MenuPSNPlayerProfileInitiator:modify_node(node)
	if (managers.menu:is_ps3() or managers.menu:is_ps4()) and not managers.network:session() then
		PSN:set_online_callback(callback(managers.menu, managers.menu, "refresh_player_profile_gui"))
	end

	return node
end
GlobalSuccessRateInitiator = GlobalSuccessRateInitiator or class()

-- Lines: 6419 to 6421
function GlobalSuccessRateInitiator:modify_node(node)
	managers.menu:show_global_success(node)

	return node
end
LobbyOptionInitiator = LobbyOptionInitiator or class()

-- Lines: 6426 to 6509
function LobbyOptionInitiator:modify_node(node)
	MenuManager.refresh_level_select(node, Network:is_server())

	local item_permission_campaign = node:item("lobby_permission")

	if item_permission_campaign then
		item_permission_campaign:set_value(Global.game_settings.permission)
	end

	local item_lobby_drop_in_option = node:item("lobby_drop_in_option")

	if item_lobby_drop_in_option then
		item_lobby_drop_in_option:set_value(Global.game_settings.drop_in_option)
	end

	local item_lobby_toggle_ai = node:item("toggle_ai")

	if item_lobby_toggle_ai then
		item_lobby_toggle_ai:set_value(Global.game_settings.team_ai and Global.game_settings.team_ai_option or 0)
	end

	local item_lobby_toggle_auto_kick = node:item("toggle_auto_kick")

	if item_lobby_toggle_auto_kick then
		item_lobby_toggle_auto_kick:set_value(Global.game_settings.auto_kick and "on" or "off")
	end

	local item_lobby_toggle_modded_players = node:item("toggle_allow_modded_players")

	if item_lobby_toggle_modded_players then
		item_lobby_toggle_modded_players:set_value(Global.game_settings.allow_modded_players and "on" or "off")
	end

	local character_item = node:item("choose_character")

	if character_item then
		local value = managers.network:session() and managers.network:session():local_peer():character() or "random"

		character_item:set_value(value)
	end

	local reputation_permission_item = node:item("lobby_reputation_permission")

	if reputation_permission_item then
		reputation_permission_item:set_value(Global.game_settings.reputation_permission)
	end

	local item_lobby_job_plan = node:item("lobby_job_plan")

	if item_lobby_job_plan then
		item_lobby_job_plan:set_value(Global.game_settings.job_plan or -1)

		if tweak_data.quickplay.stealth_levels[managers.job:current_real_job_id()] then
			local stealth_option = nil

			for _, option in ipairs(item_lobby_job_plan:options()) do
				if option:value() == 2 then
					stealth_option = option

					break
				end
			end

			item_lobby_job_plan:clear_options()
			item_lobby_job_plan:add_option(stealth_option)
		end
	end

	return node
end
VerifyLevelOptionInitiator = VerifyLevelOptionInitiator or class()

-- Lines: 6513 to 6515
function VerifyLevelOptionInitiator:modify_node(node)
	MenuManager.refresh_level_select(node, true)

	return node
end
MenuCustomizeControllerCreator = MenuCustomizeControllerCreator or class()
MenuCustomizeControllerCreator.CONTROLS = {
	"move",
	"primary_attack",
	"secondary_attack",
	"primary_choice1",
	"primary_choice2",
	"switch_weapon",
	"reload",
	"weapon_gadget",
	"weapon_firemode",
	"throw_grenade",
	"run",
	"jump",
	"duck",
	"melee",
	"interact",
	"interact_secondary",
	"use_item",
	"toggle_chat",
	"push_to_talk",
	"cash_inspect",
	"deploy_bipod",
	"change_equipment",
	"drive",
	"hand_brake",
	"vehicle_change_camera",
	"vehicle_rear_camera",
	"vehicle_shooting_stance",
	"vehicle_exit",
	"toggle_hud",
	"drop_in_accept",
	"drop_in_return",
	"drop_in_kick"
}
MenuCustomizeControllerCreator.AXIS_ORDERED = {
	move = {
		"up",
		"down",
		"left",
		"right"
	},
	drive = {
		"accelerate",
		"brake",
		"turn_left",
		"turn_right"
	}
}
MenuCustomizeControllerCreator.CONTROLS_INFO = {}
MenuCustomizeControllerCreator.CONTROLS_INFO.move = {
	hidden = true,
	category = "normal"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.up = {
	category = "normal",
	text_id = "menu_button_move_forward"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.down = {
	category = "normal",
	text_id = "menu_button_move_back"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.left = {
	category = "normal",
	text_id = "menu_button_move_left"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.right = {
	category = "normal",
	text_id = "menu_button_move_right"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.primary_attack = {
	category = "normal",
	text_id = "menu_button_fire_weapon"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.secondary_attack = {
	category = "normal",
	text_id = "menu_button_aim_down_sight"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.primary_choice1 = {
	category = "normal",
	text_id = "menu_button_weapon_slot1"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.primary_choice2 = {
	category = "normal",
	text_id = "menu_button_weapon_slot2"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.switch_weapon = {
	category = "normal",
	text_id = "menu_button_switch_weapon"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.reload = {
	category = "normal",
	text_id = "menu_button_reload"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.weapon_gadget = {
	category = "normal",
	text_id = "menu_button_weapon_gadget"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.run = {
	category = "normal",
	text_id = "menu_button_sprint"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.jump = {
	category = "normal",
	text_id = "menu_button_jump"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.duck = {
	category = "normal",
	text_id = "menu_button_crouch"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.melee = {
	category = "normal",
	text_id = "menu_button_melee"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.interact = {
	category = "normal",
	text_id = "menu_button_shout"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.interact_secondary = {
	category = "normal",
	text_id = "menu_button_shout_secondary"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.use_item = {
	category = "normal",
	text_id = "menu_button_deploy"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.toggle_chat = {
	category = "normal",
	text_id = "menu_button_chat_message"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.push_to_talk = {
	category = "normal",
	text_id = "menu_button_push_to_talk"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.continue = {
	category = "normal",
	text_id = "menu_button_continue"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.throw_grenade = {
	category = "normal",
	text_id = "menu_button_throwable"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.weapon_firemode = {
	category = "normal",
	text_id = "menu_button_weapon_firemode"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.cash_inspect = {
	category = "normal",
	text_id = "menu_button_cash_inspect"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.deploy_bipod = {
	category = "normal",
	text_id = "menu_button_deploy_bipod"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.change_equipment = {
	category = "normal",
	text_id = "menu_button_change_equipment"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.toggle_hud = {
	category = "normal",
	text_id = "menu_button_toggle_hud"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.drive = {
	hidden = true,
	category = "vehicle"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.accelerate = {
	category = "vehicle",
	text_id = "menu_button_accelerate"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.brake = {
	category = "vehicle",
	text_id = "menu_button_brake"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.turn_left = {
	category = "vehicle",
	text_id = "menu_button_turn_left"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.turn_right = {
	category = "vehicle",
	text_id = "menu_button_turn_right"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.hand_brake = {
	category = "vehicle",
	text_id = "menu_button_handbrake"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.vehicle_change_camera = {
	category = "vehicle",
	text_id = "menu_button_vehicle_change_camera"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.vehicle_rear_camera = {
	category = "vehicle",
	text_id = "menu_button_vehicle_rear_camera"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.vehicle_shooting_stance = {
	category = "vehicle",
	text_id = "menu_button_vehicle_shooting_stance",
	block = {"normal"}
}
MenuCustomizeControllerCreator.CONTROLS_INFO.vehicle_exit = {
	category = "vehicle",
	text_id = "menu_button_vehicle_exit"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.drop_in_accept = {
	category = "normal",
	text_id = "menu_button_drop_in_accept"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.drop_in_return = {
	category = "normal",
	text_id = "menu_button_drop_in_return"
}
MenuCustomizeControllerCreator.CONTROLS_INFO.drop_in_kick = {
	category = "normal",
	text_id = "menu_button_drop_in_kick"
}

-- Lines: 6592 to 6599
function MenuCustomizeControllerCreator.controls_info_by_category(category)
	local t = {}

	for _, name in ipairs(MenuCustomizeControllerCreator.CONTROLS) do
		if MenuCustomizeControllerCreator.CONTROLS_INFO[name].category == category then
			table.insert(t, name)
		end
	end

	return t
end

-- Lines: 6602 to 6604
function MenuCustomizeControllerCreator:modify_node(original_node, data)
	local node = original_node

	return self:setup_node(node)
end

-- Lines: 6607 to 6609
function MenuCustomizeControllerCreator:refresh_node(node)
	self:setup_node(node)

	return node
end

-- Lines: 6613 to 6689
function MenuCustomizeControllerCreator:setup_node(node)
	local new_node = node
	local controller_category = node:parameters().controller_category or "normal"

	node:clean_items()

	local params = {
		callback = "choice_controller_type",
		name = "controller_type",
		text_id = "menu_controller_type"
	}
	local data_node = {type = "MenuItemMultiChoice"}

	table.insert(data_node, {
		value = "normal",
		text_id = "menu_controller_normal",
		_meta = "option"
	})
	table.insert(data_node, {
		value = "vehicle",
		text_id = "menu_controller_vehicle",
		_meta = "option"
	})

	local new_item = node:create_item(data_node, params)

	new_item:set_value(controller_category)
	node:add_item(new_item)

	local connections = managers.controller:get_settings(managers.controller:get_default_wrapper_type()):get_connection_map()

	for _, name in ipairs(self.controls_info_by_category(controller_category)) do
		local name_id = name
		local connection = connections[name]

		if connection._btn_connections then
			local ordered = self.AXIS_ORDERED[name]

			for _, btn_name in ipairs(ordered) do
				local btn_connection = connection._btn_connections[btn_name]

				if btn_connection then
					local name_id = name
					local params = {
						localize = "false",
						name = btn_name,
						connection_name = name,
						text_id = utf8.to_upper(managers.localization:text(self.CONTROLS_INFO[btn_name].text_id)),
						binding = btn_connection.name,
						axis = connection._name,
						button = btn_name
					}
					local new_item = new_node:create_item({type = "MenuItemCustomizeController"}, params)

					new_node:add_item(new_item)
				end
			end
		else
			local params = {
				localize = "false",
				name = name_id,
				connection_name = name,
				text_id = utf8.to_upper(managers.localization:text(self.CONTROLS_INFO[name].text_id)),
				binding = connection:get_input_name_list()[1],
				button = name
			}
			local new_item = new_node:create_item({type = "MenuItemCustomizeController"}, params)

			new_node:add_item(new_item)
		end
	end

	local params = {
		callback = "set_default_controller",
		name = "set_default_controller",
		text_id = "menu_set_default_controller",
		category = controller_category
	}
	local new_item = new_node:create_item(nil, params)

	new_node:add_item(new_item)
	managers.menu:add_back_button(new_node)

	return new_node
end
MenuCrimeNetContractInitiator = MenuCrimeNetContractInitiator or class()

-- Lines: 6694 to 6773
function MenuCrimeNetContractInitiator:modify_node(original_node, data)
	local node = deep_clone(original_node)

	if Global.game_settings.single_player then
		node:item("toggle_ai"):set_value(Global.game_settings.team_ai and Global.game_settings.team_ai_option or 0)
	elseif data.smart_matchmaking then
		-- Nothing
	elseif not data.server then
		node:item("lobby_job_plan"):set_value(Global.game_settings.job_plan)
		node:item("lobby_kicking_option"):set_value(Global.game_settings.kick_option)
		node:item("lobby_permission"):set_value(Global.game_settings.permission)
		node:item("lobby_reputation_permission"):set_value(Global.game_settings.reputation_permission)
		node:item("lobby_drop_in_option"):set_value(Global.game_settings.drop_in_option)
		node:item("toggle_ai"):set_value(Global.game_settings.team_ai and Global.game_settings.team_ai_option or 0)
		node:item("toggle_auto_kick"):set_value(Global.game_settings.auto_kick and "on" or "off")
		node:item("toggle_allow_modded_players"):set_value(Global.game_settings.allow_modded_players and "on" or "off")

		if tweak_data.quickplay.stealth_levels[data.job_id] then
			local job_plan_item = node:item("lobby_job_plan")
			local stealth_option = nil

			for _, option in ipairs(job_plan_item:options()) do
				if option:value() == 2 then
					stealth_option = option

					break
				end
			end

			job_plan_item:clear_options()
			job_plan_item:add_option(stealth_option)
		end
	end

	if data.customize_contract then
		node:set_default_item_name("buy_contract")

		local job_data = data

		if job_data and job_data.job_id then
			local buy_contract_item = node:item("buy_contract")

			if buy_contract_item then
				local can_afford = managers.money:can_afford_buy_premium_contract(job_data.job_id, job_data.difficulty_id or 3)
				buy_contract_item:parameters().text_id = can_afford and "menu_cn_premium_buy_accept" or "menu_cn_premium_cannot_buy"
				buy_contract_item:parameters().disabled_color = Color(1, 0.6, 0.2, 0.2)

				buy_contract_item:set_enabled(can_afford)
			end
		end

		node:item("toggle_one_down"):set_value("off")
	end

	if tweak_data.narrative:is_job_locked(data.job_id) then
		node:item("accept_contract"):set_enabled(false)
	end

	if data and data.back_callback then
		table.insert(node:parameters().back_callback, data.back_callback)
	end

	node:parameters().menu_component_data = data

	return node
end

-- Lines: 6776 to 6794
function MenuCallbackHandler:set_contact_info(item)
	local parameters = item:parameters() or {}
	local id = parameters.name
	local name_id = parameters.text_id
	local files = parameters.files
	local sub_text = parameters.sub_text
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.set_contact_info and active_node_gui:get_contact_info() ~= item:name() then
		active_node_gui:set_contact_info(id, name_id, files, 1, sub_text)
	end

	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
	end
end

-- Lines: 6796 to 6802
function MenuCallbackHandler:is_current_contact_info(item)
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.get_contact_info then
		return active_node_gui:get_contact_info() == item:name()
	end

	return false
end
MenuCrimeNetContactInfoInitiator = MenuCrimeNetContactInfoInitiator or class()
MenuCrimeNetContactInfoInitiator.TWEAK_DATA = tweak_data.gui.crime_net.codex
MenuCrimeNetContactInfoInitiator.COUNT_ITEMS = true
MenuCrimeNetContactInfoInitiator.ALLOW_IMAGES = false
MenuCrimeNetContactInfoInitiator.USE_SUBTEXT = false
MenuCrimeNetContactInfoInitiator.DEFAULT_ITEM = "bain"

-- Lines: 6811 to 6897
function MenuCrimeNetContactInfoInitiator:modify_node(original_node, data)
	local node = original_node
	local codex_data = {}
	local contacts = {}

	for _, codex_d in ipairs(self.TWEAK_DATA) do
		local codex = {}
		local codex_string = managers.localization:to_upper_text(codex_d.name_id)
		codex.id = codex_d.id
		codex.name_localized = codex_string .. (self.COUNT_ITEMS and " (" .. tostring(#codex_d) .. ")" or "")

		for _, info_data in ipairs(codex_d) do
			local data = {
				id = info_data.id,
				name_localized = managers.localization:to_upper_text(info_data.name_id),
				files = {},
				sub_text = self.USE_SUBTEXT and codex_string or nil
			}

			for page, file_data in ipairs(info_data) do
				local file = {
					desc_localized = file_data.desc_id and managers.localization:text(file_data.desc_id) or "",
					post_event = file_data.post_event,
					videos = file_data.videos and deep_clone(file_data.videos) or {},
					lock = file_data.lock,
					icon = file_data.icon,
					icon_rect = file_data.icon_rect
				}

				if file_data.video then
					table.insert(file.videos, file_data.video)
				end

				if self.ALLOW_IMAGES then
					file.images = file_data.images and deep_clone(file_data.images) or {}

					if file_data.image then
						table.insert(file.images, file_data.image)
					end
				end

				table.insert(data.files, file)
			end

			table.insert(codex, data)
		end

		table.insert(codex_data, codex)
	end

	node:clean_items()

	for i, codex in ipairs(codex_data) do
		self:create_divider(node, codex.id, codex.name_localized, nil, tweak_data.screen_colors.text)

		for i, info_data in ipairs(codex) do
			self:create_item(node, info_data)
		end

		self:create_divider(node, i)
	end

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		pd2_corner = "true",
		text_id = "menu_back",
		gui_node_custom = "true",
		align = "left",
		last_item = "true",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name(self.DEFAULT_ITEM)
	node:select_item(self.DEFAULT_ITEM)

	return node
end

-- Lines: 6900 to 6901
function MenuCrimeNetContactInfoInitiator:refresh_node(node)
	return node
end

-- Lines: 6905 to 6920
function MenuCrimeNetContactInfoInitiator:create_divider(node, id, text_id, size, color)
	local params = {
		localize = "false",
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 6922 to 6952
function MenuCrimeNetContactInfoInitiator:create_item(node, contact)
	local text_id = contact.name_localized
	local sub_text = contact.sub_text
	local files = contact.files
	local video_id = contact.video
	local color_ranges = nil
	local params = {
		localize = "false",
		callback = "set_contact_info",
		name = contact.id,
		text_id = text_id,
		color_ranges = color_ranges,
		files = files,
		sub_text = sub_text,
		icon = contact.icon or "guis/textures/scrollarrow",
		icon_rotation = contact.icon_rotation or 270,
		icon_visible_callback = contact.icon_visible_callback or "is_current_contact_info",
		hightlight_color = contact.hightlight_color,
		row_item_color = contact.row_item_color,
		disabled_color = contact.disabled_color,
		marker_color = contact.marker_color
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end
MenuCrimeNetContactShortInitiator = MenuCrimeNetContactShortInitiator or class()

-- Lines: 7090 to 7129
function MenuCrimeNetContactShortInitiator:modify_node(original_node, data)
	local node = original_node

	node:clean_items()

	for _, job_data in ipairs(tweak_data.narrative.tutorials) do
		local heist_tweak = tweak_data.narrative.jobs[job_data.job]
		local info_data = {
			id = job_data.job,
			text = managers.localization:to_upper_text(heist_tweak.name_id),
			enabled = true
		}

		self:create_item(node, info_data)
	end

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		pd2_corner = "true",
		text_id = "menu_back",
		gui_node_custom = "true",
		align = "left",
		last_item = "true",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name(self.DEFAULT_ITEM)
	node:select_item(self.DEFAULT_ITEM)

	return node
end

-- Lines: 7132 to 7133
function MenuCrimeNetContactShortInitiator:refresh_node(node)
	return node
end

-- Lines: 7137 to 7152
function MenuCrimeNetContactShortInitiator:create_divider(node, id, text_id, size, color)
	local params = {
		localize = "false",
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 7154 to 7169
function MenuCrimeNetContactShortInitiator:create_item(node, data)
	local params = {
		callback = "play_short_heist",
		localize = "false",
		name = data.id,
		text_id = data.text,
		job = data.id
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(data.enabled)
	node:add_item(new_item)
end

-- Lines: 7174 to 7193
function MenuCallbackHandler:play_chill_combat(item)
	if managers.job:has_active_job() then
		self:_dialog_leave_lobby_yes()
	end

	local node = item:parameters().gui_node
	local job_data = {
		job_id = "chill_combat",
		difficulty = node:get_difficulty(),
		one_down = node:get_one_down()
	}

	node:remove_blur()

	if Global.game_settings.single_player then
		MenuCallbackHandler:start_single_player_job(job_data)
	else
		MenuCallbackHandler:start_job(job_data)
	end
end

-- Lines: 7195 to 7199
function MenuCallbackHandler:ignore_chill_combat(item)
	item:parameters().gui_node:remove_blur()
	managers.custom_safehouse:ignore_raid()
	managers.menu:back()
end

-- Lines: 7201 to 7203
function MenuCallbackHandler:_on_chill_change_difficulty(item)
	item:parameters().gui_node:set_difficulty(item._options[item._current_index]:value())
end

-- Lines: 7205 to 7207
function MenuCallbackHandler:_on_chill_change_one_down(item)
	item:parameters().gui_node:set_one_down(item:value() == "on")
end
MenuCrimeNetContactChillInitiator = MenuCrimeNetContactChillInitiator or class()

-- Lines: 7210 to 7301
function MenuCrimeNetContactChillInitiator:modify_node(original_node, data)
	local node = original_node

	node:clean_items()

	local params = {
		callback = "_on_chill_change_difficulty",
		name = "difficulty",
		text_id = "menu_lobby_difficulty_title",
		help_id = "menu_diff_help",
		filter = true
	}
	local data_node = {
		{
			value = "normal",
			text_id = "menu_difficulty_normal",
			_meta = "option"
		},
		{
			value = "hard",
			text_id = "menu_difficulty_hard",
			_meta = "option"
		},
		{
			value = "overkill",
			text_id = "menu_difficulty_very_hard",
			_meta = "option"
		},
		{
			value = "overkill_145",
			text_id = "menu_difficulty_overkill",
			_meta = "option"
		},
		{
			value = "easy_wish",
			text_id = "menu_difficulty_easy_wish",
			_meta = "option"
		},
		{
			value = "overkill_290",
			text_id = "menu_difficulty_apocalypse",
			_meta = "option"
		},
		{
			value = "sm_wish",
			text_id = "menu_difficulty_sm_wish",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		callback = "_on_chill_change_one_down",
		name = "toggle_one_down",
		text_id = "menu_toggle_one_down"
	}
	data_node = {
		{
			w = "24",
			y = "0",
			h = "24",
			s_y = "24",
			value = "on",
			s_w = "24",
			s_h = "24",
			s_x = "24",
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = "24",
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = "24",
			y = "0",
			h = "24",
			s_y = "24",
			value = "off",
			s_w = "24",
			s_h = "24",
			s_x = "0",
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = "0",
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "CoreMenuItemToggle.ItemToggle"
	}
	new_item = node:create_item(data_node, params)

	new_item:set_value("off")
	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		callback = "play_chill_combat",
		name = "CustomSafeHouseDefendBtn",
		align = "left",
		text_id = "menu_cn_chill_combat_defend"
	}
	data_node = {}
	new_item = node:create_item(data_node, params)

	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		callback = "ignore_chill_combat",
		name = "CustomSafeHouseIgnoreBtn",
		align = "left",
		text_id = "menu_cn_chill_combat_ignore_defend"
	}
	data_node = {}
	new_item = node:create_item(data_node, params)

	new_item:set_enabled(true)
	node:add_item(new_item)

	params = {
		visible_callback = "is_pc_controller",
		name = "back",
		last_item = "true",
		text_id = "menu_back",
		align = "left",
		previous_node = "true"
	}
	data_node = {}
	new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name(self.DEFAULT_ITEM)
	node:select_item(self.DEFAULT_ITEM)

	return node
end

-- Lines: 7304 to 7305
function MenuCrimeNetContactChillInitiator:refresh_node(node)
	return node
end

-- Lines: 7309 to 7310
function MenuCrimeNetContactChillInitiator:create_divider(node, id, text_id, size, color)
end

-- Lines: 7312 to 7313
function MenuCrimeNetContactChillInitiator:create_item(node, data)
end
MenuJukeboxInitiator = MenuJukeboxInitiator or class()

-- Lines: 7322 to 7388
function MenuJukeboxInitiator:modify_node(node, data)
	if not node:item("choose_jukebox_your_choice") then
		local track_list, track_locked = managers.music:jukebox_music_tracks()
		local option_data = {type = "MenuItemMultiChoiceWithIcon"}

		for _, track_name in ipairs(track_list) do
			if not track_locked[track_name] then
				table.insert(option_data, {
					_meta = "option",
					text_id = "menu_jukebox_" .. track_name,
					value = track_name
				})
			end
		end

		local params = {
			callback = "jukebox_track_selection",
			name = "choose_jukebox_your_choice",
			text_id = "",
			icon = tweak_data.hud_icons:get_icon_data("jukebox_playing_icon")
		}
		local item = node:create_item(option_data, params)

		item:set_enabled(false)
		node:add_item(item)
	end

	local track_name = managers.localization:text("menu_jukebox_playlist_heist")
	local job_data = Global.job_manager.current_job

	if job_data then
		local track = managers.music:jukebox_heist_specific()
		track_name = track == "all" and track_name .. " (" .. managers.localization:text("menu_jukebox_playlist_all") .. ")" or track == "playlist" and track_name .. " (" .. managers.localization:text("menu_jukebox_random_heist_playlist") .. ")" or track_name .. " (" .. managers.localization:text("menu_jukebox_" .. track) .. ")"
	end

	node:item("toggle_jukebox_playlist_heist"):set_parameter("localize", "false")
	node:item("toggle_jukebox_playlist_heist"):set_parameter("text_id", track_name)

	if Network:is_server() then
		if Global.music_manager.loadout_selection == "server" then
			Global.music_manager.loadout_selection = nil
		end

		node:item("toggle_jukebox_server_choice"):set_enabled(false)
	end

	if not Global.music_manager.loadout_selection then
		node:item("toggle_jukebox_playlist_all"):set_value("on")
	elseif Global.music_manager.loadout_selection == "global" then
		node:item("toggle_jukebox_playlist_global"):set_value("on")
	elseif Global.music_manager.loadout_selection == "heist" then
		node:item("toggle_jukebox_playlist_heist"):set_value("on")
	elseif Global.music_manager.loadout_selection == "server" then
		node:item("toggle_jukebox_server_choice"):set_value("on")
	else
		node:item("toggle_jukebox_your_choice"):set_value("on")

		local selection = node:item("choose_jukebox_your_choice")

		selection:set_enabled(true)
		selection:set_value(Global.music_manager.loadout_selection)
	end

	return node
end
MenuJukeboxHeistPlaylist = MenuJukeboxHeistPlaylist or class()

-- Lines: 7395 to 7437
function MenuJukeboxHeistPlaylist:modify_node(node, data)
	managers.menu_component:show_contract_character(false)
	node:clean_items()

	local data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "MenuItemToggleWithIcon"
	}
	local item = nil
	local track_list, track_locked = managers.music:jukebox_music_tracks()

	for _, track_name in pairs(track_list) do
		local locked = track_locked[track_name]
		local params = {
			callback = "jukebox_option_heist_playlist",
			name = track_name,
			text_id = "menu_jukebox_" .. track_name,
			help_id = locked and "menu_jukebox_locked_" .. locked,
			disabled_color = tweak_data.screen_colors.important_1,
			icon = tweak_data.hud_icons:get_icon_data("jukebox_playing_icon")
		}
		item = node:create_item(data, params)

		if locked then
			item:set_value("off")
			item:set_enabled(false)
		else
			item:set_value(managers.music:playlist_contains(track_name) and "on" or "off")
		end

		node:add_item(item)
	end

	managers.menu:add_back_button(node)

	return node
end
MenuJukeboxHeistTracks = MenuJukeboxHeistTracks or class()

-- Lines: 7444 to 7512
function MenuJukeboxHeistTracks:modify_node(node, data)
	managers.menu_component:show_contract_character(false)
	node:clean_items()

	local track_list, track_locked = managers.music:jukebox_music_tracks()
	local option_data = {type = "MenuItemMultiChoiceWithIcon"}

	table.insert(option_data, {
		value = "all",
		text_id = "menu_jukebox_playlist_all",
		_meta = "option"
	})
	table.insert(option_data, {
		value = "playlist",
		text_id = "menu_jukebox_random_heist_playlist",
		_meta = "option"
	})

	for _, track_name in pairs(track_list) do
		if not track_locked[track_name] then
			table.insert(option_data, {
				_meta = "option",
				text_id = "menu_jukebox_" .. track_name,
				value = track_name
			})
		end
	end

	local track_list = {}
	local unique_jobs = {}

	for _, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
		local job_tweak = tweak_data.narrative:job_data(job_id)

		if self:_have_music(job_id) and not table.contains(unique_jobs, job_tweak.name_id) then
			local text_id, color_ranges = tweak_data.narrative:create_job_name(job_id, true)
			local days = #tweak_data.narrative:job_chain(job_id)

			table.insert(unique_jobs, job_tweak.name_id)

			if days > 1 then
				for i = 1, days, 1 do
					table.insert(track_list, {
						job_id = job_id,
						name_id = job_tweak.name_id,
						day = i,
						sort_id = text_id,
						text_id = text_id .. " - " .. managers.localization:text("menu_jukebox_heist_day", {day = i}),
						color_ranges = color_ranges
					})
				end
			else
				table.insert(track_list, {
					job_id = job_id,
					name_id = job_tweak.name_id,
					sort_id = text_id,
					text_id = text_id,
					color_ranges = color_ranges
				})
			end
		end
	end

	table.sort(track_list, function (x, y)
		return x.sort_id == y.sort_id and x.text_id < y.text_id or x.sort_id < y.sort_id
	end)
	table.insert(track_list, {
		name_id = "escape",
		job_id = "escape",
		text_id = managers.localization:text("menu_jukebox_heist_escape")
	})

	for _, track_data in pairs(track_list) do
		local heist_name = track_data.name_id .. (track_data.day and track_data.day or "")
		local params = {
			localize = "false",
			align = "left",
			callback = "jukebox_option_heist_tracks",
			text_offset = 100,
			name = heist_name,
			text_id = track_data.text_id,
			color_ranges = track_data.color_ranges,
			heist_job = track_data.job_id,
			heist_days = track_data.day,
			icon = tweak_data.hud_icons:get_icon_data("jukebox_playing_icon")
		}
		local item = node:create_item(option_data, params)

		item:set_value(managers.music:track_attachment(heist_name) or "all")
		node:add_item(item)
	end

	managers.menu:add_back_button(node)

	return node
end

-- Lines: 7515 to 7538
function MenuJukeboxHeistTracks:_have_music(job_id)
	local job_tweak = tweak_data.narrative.jobs[job_id]

	if not job_tweak or job_tweak.contact == "tests" or job_tweak.wrapped_to_job then
		return false
	end

	if job_tweak.job_wrapper then
		for _, wrapped_job in ipairs(job_tweak.job_wrapper) do
			for _, level_data in ipairs(tweak_data.narrative.jobs[wrapped_job].chain) do
				if tweak_data.levels[level_data.level_id].music ~= "no_music" then
					return true
				end
			end
		end
	else
		for _, level_data in ipairs(job_tweak.chain) do
			if tweak_data.levels[level_data.level_id].music ~= "no_music" then
				return true
			end
		end
	end

	return false
end
MenuJukeboxMenuPlaylist = MenuJukeboxMenuPlaylist or class()

-- Lines: 7545 to 7587
function MenuJukeboxMenuPlaylist:modify_node(node, data)
	managers.menu_component:show_contract_character(false)
	node:clean_items()

	local data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "MenuItemToggleWithIcon"
	}
	local item = nil
	local track_list, track_locked = managers.music:jukebox_menu_tracks()

	for _, track_name in pairs(track_list) do
		local locked = track_locked[track_name]
		local params = {
			callback = "jukebox_option_menu_playlist",
			name = track_name,
			text_id = "menu_jukebox_screen_" .. track_name,
			help_id = locked and "menu_jukebox_locked_" .. locked,
			disabled_color = tweak_data.screen_colors.important_1,
			icon = tweak_data.hud_icons:get_icon_data("jukebox_playing_icon")
		}
		item = node:create_item(data, params)

		if locked then
			item:set_value("off")
			item:set_enabled(false)
		else
			item:set_value(managers.music:playlist_menu_contains(track_name) and "on" or "off")
		end

		node:add_item(item)
	end

	managers.menu:add_back_button(node)

	return node
end
MenuJukeboxMenuTracks = MenuJukeboxMenuTracks or class()

-- Lines: 7594 to 7631
function MenuJukeboxMenuTracks:modify_node(node, data)
	managers.menu_component:show_contract_character(false)
	node:clean_items()

	local track_list, track_locked = managers.music:jukebox_menu_tracks()
	local option_data = {type = "MenuItemMultiChoiceWithIcon"}

	table.insert(option_data, {
		value = "all",
		text_id = "menu_jukebox_playlist_all",
		_meta = "option"
	})
	table.insert(option_data, {
		value = "playlist",
		text_id = "menu_jukebox_random_menu_playlist",
		_meta = "option"
	})

	for _, track_name in pairs(track_list) do
		if not track_locked[track_name] then
			table.insert(option_data, {
				_meta = "option",
				text_id = "menu_jukebox_screen_" .. track_name,
				value = track_name
			})
		end
	end

	local menu_options = {
		"mainmenu",
		"loadout",
		"heistresult",
		"heistlost",
		"heistfinish",
		"credits"
	}

	for _, track_name in pairs(menu_options) do
		local params = {
			callback = "jukebox_option_menu_tracks",
			text_offset = 100,
			align = "left",
			name = track_name,
			text_id = "menu_jukebox_screen_" .. track_name,
			icon = tweak_data.hud_icons:get_icon_data("jukebox_playing_icon")
		}
		local item = node:create_item(option_data, params)

		item:set_value(managers.music:track_attachment(track_name))
		node:add_item(item)
	end

	managers.menu:add_back_button(node)

	return node
end
MenuPrePlanningInitiator = MenuPrePlanningInitiator or class(MenuCrimeNetContactInfoInitiator)

-- Lines: 7638 to 7652
function MenuPrePlanningInitiator:modify_node(node, item_name, selected_item)
	node:clean_items()

	local name = node:parameters().name
	local func_name = "modifiy_node_" .. tostring(name)

	if self[func_name] then
		node, selected_item = self[func_name](self, node, item_name, selected_item)
	end

	if selected_item then
		node:set_default_item_name(selected_item)
		node:select_item(selected_item)
	end

	return node
end

-- Lines: 7657 to 7697
function MenuPrePlanningInitiator:create_info_items(node, params, selected_item)
	self:create_divider(node, "info_div", nil, nil, nil)

	params.enabled = true

	self:create_divider(node, "cat_info", managers.localization:text("menu_pp_sub_info"), nil, tweak_data.screen_colors.text)

	if managers.preplanning:has_current_custom_points() then
		params.name = "custom_points"
		params.callback = "open_preplanning_custom_item"
		params.text_id = managers.localization:text("menu_pp_extra_info")
		params.tooltip.texture = tweak_data.preplanning.gui.custom_icons_path
		params.tooltip.texture_rect = tweak_data.preplanning:get_custom_texture_rect(45)
		params.tooltip.name = params.text_id
		params.tooltip.desc = managers.localization:text("menu_pp_extra_info_desc")
		params.tooltip.errors = {}

		self:create_item(node, params)
	end

	params.name = "preplanning_help"
	params.callback = "open_preplanning_help"
	params.text_id = managers.localization:text("menu_item_preplanning_help")
	params.tooltip = {
		texture = tweak_data.preplanning.gui.custom_icons_path,
		texture_rect = tweak_data.preplanning:get_custom_texture_rect(45),
		name = params.text_id,
		desc = managers.localization:text("menu_item_preplanning_help_desc")
	}

	self:create_item(node, params)

	return node, selected_item
end

-- Lines: 7700 to 7752
function MenuPrePlanningInitiator:modifiy_node_view_only(node, item_name, selected_item)
	local subgroups = managers.preplanning:get_mission_element_subgroups()

	if not subgroups then
		return node, nil
	end

	node:parameters().current_viewing = true
	local params = {
		localize = "false",
		tooltip = {texture = tweak_data.preplanning.gui.type_icons_path}
	}
	local finished_preplan = managers.preplanning:get_finished_preplan()
	local type_data, location_data, data = nil

	for i = 1, #tweak_data.preplanning.location_groups, 1 do
		data = finished_preplan[i]

		if data then
			self:create_divider(node, "sub_" .. tostring(i), managers.localization:text(data.name_id), nil, tweak_data.screen_colors.text)

			for index = 1, #tweak_data.preplanning.location_groups, 1 do
				if data[index] then
					location_data = data[index]

					for id, type in pairs(location_data) do
						type_data = tweak_data:get_raw_value("preplanning", "types", type) or {}
						params.name = id
						params.text_id = managers.preplanning:get_type_name(type)
						params.tooltip.texture_rect = tweak_data.preplanning:get_type_texture_rect(type_data.icon)
						params.tooltip.name = params.text_id
						params.tooltip.desc = managers.preplanning:get_type_desc(type)

						self:create_item(node, params)

						selected_item = selected_item or params.name
					end
				end
			end
		end
	end

	self:create_info_items(node, params, selected_item)

	return node, selected_item
end

-- Lines: 7755 to 7779
function MenuPrePlanningInitiator:set_locks_to_param(params, key, index)
	local data = tweak_data:get_raw_value("preplanning", key, index) or {}
	local enabled = params.enabled ~= false
	params.tooltip = params.tooltip or {}
	params.tooltip.errors = params.tooltip.errors or {}

	if data.dlc_lock then
		local dlc_unlocked = managers.dlc:is_dlc_unlocked(data.dlc_lock)

		if not dlc_unlocked then
			local error_text_id = tweak_data:get_raw_value("lootdrop", "global_values", data.dlc_lock, "unlock_id")

			table.insert(params.tooltip.errors, managers.localization:to_upper_text(error_text_id))

			enabled = false
		end
	elseif data.upgrade_lock then
		local upgrade_unlocked = managers.player:has_category_upgrade(data.upgrade_lock.category, data.upgrade_lock.upgrade)

		if not upgrade_unlocked then
			table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_asset_lock_" .. data.upgrade_lock.upgrade))

			enabled = false
		end
	end

	params.enabled = enabled
	params.ignore_disabled = true
end

-- Lines: 7781 to 7833
function MenuPrePlanningInitiator:modifiy_node_preplanning(node, item_name, selected_item)
	if not managers.preplanning:can_edit_preplan() then
		return self:modifiy_node_view_only(node, item_name, selected_item)
	end

	local subgroups = managers.preplanning:get_mission_element_subgroups()

	if not subgroups then
		return node, nil
	end

	local params = {
		localize = "false",
		tooltip = {texture = tweak_data.preplanning.gui.type_icons_path}
	}
	local type_data, first_type, category_data = nil

	for i, data in ipairs(subgroups) do
		if #data.subgroup > 0 then
			self:create_divider(node, "cat_" .. tostring(i), managers.localization:text(data.name_id), nil, tweak_data.screen_colors.text)

			params.callback = data.callback

			for index, category in ipairs(data.subgroup) do
				first_type = managers.preplanning:get_first_type_in_category(category)
				type_data = tweak_data:get_raw_value("preplanning", "types", first_type) or {}
				params.name = category
				params.text_id = managers.preplanning:get_category_name(category)
				params.tooltip.texture_rect = tweak_data.preplanning:get_type_texture_rect(type_data.icon)
				params.tooltip.name = params.text_id
				params.tooltip.desc = managers.preplanning:get_category_desc(category)
				params.tooltip.errors = {}
				params.enabled = true

				self:set_locks_to_param(params, "categories", category)
				self:create_item(node, params)

				selected_item = selected_item or params.name
			end

			if i ~= #subgroups then
				self:create_divider(node, "end_" .. tostring(i), nil, nil, nil)
			end
		end
	end

	self:create_info_items(node, params, selected_item)

	return node, selected_item
end

-- Lines: 7838 to 7901
function MenuPrePlanningInitiator:modifiy_node_preplanning_category(node, item_name, selected_item)
	node:parameters().current_category = item_name or node:parameters().current_category
	local current_category = node:parameters().current_category

	if not current_category then
		return node, nil
	end

	self:create_divider(node, 1, managers.preplanning:get_category_name(current_category), nil, tweak_data.screen_colors.text)

	local types = managers.preplanning:types_with_mission_elements(current_category)

	if not types or #types == 0 then
		return node, nil
	end

	local category_data = tweak_data:get_raw_value("preplanning", "categories", current_category) or {}
	local params = {
		enabled = true,
		localize = "false",
		callback = "open_preplanning_type_item",
		tooltip = {texture = tweak_data.preplanning.gui.type_icons_path}
	}
	local type_data, can_place, error_num, enabled = nil
	local peer_id = managers.network:session():local_peer():id()

	for i, type in ipairs(types) do
		type_data = tweak_data:get_raw_value("preplanning", "types", type) or {}
		params.name = type
		params.text_id = managers.preplanning:get_type_name(type)
		params.tooltip.texture_rect = tweak_data.preplanning:get_type_texture_rect(type_data.icon)
		params.tooltip.name = params.text_id
		params.tooltip.desc = managers.preplanning:get_type_desc(type)
		params.tooltip.errors = {}
		enabled = true
		can_place, error_num = managers.preplanning:can_reserve_mission_element(type, peer_id)

		if not can_place then
			enabled = false

			if error_num == 1 then
				table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_not_enough_money"))
			elseif error_num == 2 then
				table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_not_enough_budget"))
			elseif error_num == 3 then
				table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_type_disabled"))
			elseif error_num == 4 then
				table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_cap_reached"))
			else
				table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_unknown"))
			end
		end

		params.enabled = enabled

		self:set_locks_to_param(params, "types", type)
		self:create_item(node, params)

		selected_item = selected_item or params.name
	end

	return node, selected_item
end

-- Lines: 7906 to 8042
function MenuPrePlanningInitiator:modifiy_node_preplanning_type(node, item_name, selected_item)
	node:parameters().current_type = item_name or node:parameters().current_type
	local current_type = node:parameters().current_type

	if not current_type then
		return node, nil
	end

	local params = {
		localize = "false",
		callback = "reserve_preplanning_mission_element_by_item"
	}
	local mission_elements = managers.preplanning:get_mission_elements_by_type(current_type)
	local locations = managers.preplanning:sort_mission_elements_into_locations(mission_elements)

	self:create_divider(node, 1, managers.preplanning:get_type_name(current_type), nil, tweak_data.screen_colors.text)

	local peer_id = managers.network:session():local_peer():id()
	local can_place, error_num = managers.preplanning:can_reserve_mission_element(current_type, peer_id)
	local reserved, reserved_type, type_data, enabled, dlc_lock, upgrade_lock, last_location_index = nil

	for index = 1, #tweak_data.preplanning.location_groups, 1 do
		if locations[index] then
			last_location_index = index
		end
	end

	last_location_index = last_location_index or 1

	for index = 1, #tweak_data.preplanning.location_groups, 1 do
		local elements = locations[index]

		if elements then
			self:create_divider(node, "div_" .. tostring(index), managers.preplanning:get_location_name_by_index(index), nil, tweak_data.screen_colors.text)

			for i, data in ipairs(elements) do
				params.name = data.element:id()
				params.text_id = managers.preplanning:get_element_name(data.element)
				params.index = data.index
				type_data = tweak_data:get_raw_value("preplanning", "types", current_type) or {}
				params.tooltip = {
					name = managers.localization:text("menu_pp_reserve_type", {type = managers.preplanning:get_type_name(current_type)}),
					desc = managers.preplanning:get_type_desc(current_type),
					texture = tweak_data.preplanning.gui.type_icons_path,
					texture_rect = tweak_data.preplanning:get_type_texture_rect(type_data.icon),
					errors = {}
				}
				dlc_lock = data.element:value("dlc_lock")
				upgrade_lock = data.element:value("upgrade_lock")
				enabled = true

				if dlc_lock and dlc_lock ~= "none" then
					local dlc_unlocked = managers.dlc:is_dlc_unlocked(dlc_lock)

					if not dlc_unlocked then
						local error_text_id = tweak_data:get_raw_value("lootdrop", "global_values", type_data.dlc_lock, "unlock_id")

						table.insert(params.tooltip.errors, managers.localization:to_upper_text(error_text_id))

						enabled = false
					end
				elseif upgrade_lock and upgrade_lock ~= "none" then
					local upgrade_unlocked = managers.player:has_category_upgrade("player", upgrade_lock)

					if not upgrade_unlocked then
						table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_asset_lock_" .. upgrade_lock))

						enabled = false
					end
				end

				reserved = managers.preplanning:get_reserved_mission_element(data.element:id())

				if not reserved and enabled and not can_place then
					enabled = false

					if error_num == 1 then
						table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_not_enough_money"))

						params.flash_money = true
					elseif error_num == 2 then
						table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_not_enough_budget"))

						params.flash_budget = true
					elseif error_num == 3 then
						table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_type_disabled"))
					elseif error_num == 4 then
						table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_cap_reached"))
					else
						table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_unknown"))
					end
				end

				params.enabled = enabled

				self:set_locks_to_param(params, "types", current_type)

				if reserved then
					reserved_type = reserved.pack[1]
					type_data = tweak_data:get_raw_value("preplanning", "types", reserved_type) or {}
					params.enabled = true
					params.tooltip.texture = tweak_data.preplanning.gui.type_icons_path
					params.tooltip.texture_rect = tweak_data.preplanning:get_type_texture_rect(type_data.icon)
					params.tooltip.menu_color = tweak_data.chat_colors[reserved.peer_id] or tweak_data.chat_colors[#tweak_data.chat_colors]

					if enabled and (reserved.peer_id == peer_id or Network:is_server() and managers.preplanning.server_master_planner) then
						params.tooltip.name = managers.localization:text("menu_pp_unreserve_type", {type = managers.preplanning:get_type_name(reserved_type)})
					else
						params.tooltip.name = managers.preplanning:get_type_name(reserved_type)
						params.enabled = false
					end

					params.tooltip.desc = managers.preplanning:get_type_desc(reserved_type)
					params.tooltip.errors = {}
					params.callback = "unreserve_preplanning_mission_element_by_item"
				else
					if not enabled then
						params.tooltip.name = managers.preplanning:get_type_name(current_type)
					end

					params.callback = "reserve_preplanning_mission_element_by_item"
				end

				self:create_item(node, params)

				selected_item = selected_item or params.name
			end

			if index ~= last_location_index then
				self:create_divider(node, "end_" .. tostring(index), nil, nil, nil)
			end
		end
	end

	return node, selected_item
end

-- Lines: 8047 to 8127
function MenuPrePlanningInitiator:modifiy_node_preplanning_plan(node, item_name, selected_item)
	node:parameters().current_plan = item_name or node:parameters().current_plan
	local current_plan = node:parameters().current_plan

	if not current_plan then
		return node, nil
	end

	node:parameters().current_category = node:parameters().current_plan

	self:create_divider(node, 1, managers.preplanning:get_category_name(current_plan), nil, tweak_data.screen_colors.text)

	local types = managers.preplanning:types_with_mission_elements(current_plan)

	if not types or #types == 0 then
		return node
	end

	local category_data = tweak_data.preplanning.categories[current_plan]
	local params = {
		enabled = false,
		localize = "false",
		callback = "vote_preplanning_mission_element_by_item",
		tooltip = {texture = tweak_data.preplanning.gui.type_icons_path}
	}
	local type_data = nil

	for _, type in pairs(types) do
		type_data = tweak_data:get_raw_value("preplanning", "types", type) or {}
		local enabled = true
		params.post_event = type_data.post_event
		params.tooltip.errors = {}

		if not managers.preplanning:can_vote_on_plan(type) then
			table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_pp_err_not_enough_budget"))

			params.flash_budget = true
			enabled = false
		elseif type_data.dlc_lock then
			local dlc_unlocked = managers.dlc:is_dlc_unlocked(type_data.dlc_lock)

			if not dlc_unlocked then
				local error_text_id = tweak_data:get_raw_value("lootdrop", "global_values", type_data.dlc_lock, "unlock_id")

				table.insert(params.tooltip.errors, managers.localization:to_upper_text(error_text_id))

				enabled = false
			end
		elseif type_data.upgrade_lock then
			local upgrade_unlocked = managers.player:has_category_upgrade(type_data.upgrade_lock.category, type_data.upgrade_lock.upgrade) and enabled or false

			if not upgrade_unlocked then
				table.insert(params.tooltip.errors, managers.localization:to_upper_text("menu_asset_lock_" .. type_data.upgrade_lock.upgrade))

				enabled = false
			end
		elseif not managers.money:can_afford_preplanning_type(type) then
			-- Nothing
		end

		params.enabled = enabled
		local mission_elements = managers.preplanning:get_mission_elements_by_type(type)

		for index, element in ipairs(mission_elements) do
			params.name = element:id()
			params.text_id = managers.preplanning:get_type_name(type)

			if #mission_elements > 1 then
				params.text_id = params.text_id .. " - " .. managers.preplanning:get_element_name(element)
			end

			params.index = index
			params.type = type
			params.tooltip.texture_rect = tweak_data.preplanning:get_type_texture_rect(type_data.icon)
			params.tooltip.name = params.text_id
			params.tooltip.desc = managers.preplanning:get_type_desc(type)
			params.votes = managers.preplanning:get_votes_on_element(category_data.plan, type, index)

			self:create_item(node, params)

			selected_item = selected_item or params.name
		end
	end

	return node, selected_item
end

-- Lines: 8132 to 8182
function MenuPrePlanningInitiator:modifiy_node_preplanning_custom(node, item_name, selected_item)
	node:parameters().current_custom = item_name or node:parameters().current_custom
	local current_custom = node:parameters().current_custom

	if not current_custom then
		return node, nil
	end

	node:parameters().current_category = node:parameters().current_custom

	self:create_divider(node, 1, managers.localization:text("menu_pp_extra_info"), nil, tweak_data.screen_colors.text)

	local params = {
		callback = "pressed_preplanning_custom_point",
		name = "test",
		localize = "false",
		text_id = "TEST"
	}
	local current_custom_points = managers.preplanning:get_current_custom_points()
	local last_custom_point_index = nil

	for index = 1, #tweak_data.preplanning.location_groups, 1 do
		if current_custom_points[index] then
			last_custom_point_index = index
		end
	end

	last_custom_point_index = last_custom_point_index or 1

	for index = 1, #tweak_data.preplanning.location_groups, 1 do
		local custom_points = current_custom_points[index]

		if custom_points then
			self:create_divider(node, "div_" .. tostring(index), managers.preplanning:get_location_name_by_index(index), nil, tweak_data.screen_colors.text)

			for i, custom_point in pairs(custom_points) do
				params.name = tostring(index) .. "_" .. tostring(i)
				params.text_id = custom_point.text_id and managers.localization:text(custom_point.text_id) or " "
				params.post_event = custom_point.post_event

				self:create_item(node, params)

				selected_item = selected_item or params.name
			end

			if index ~= last_custom_point_index then
				self:create_divider(node, "end_" .. tostring(index), nil, nil, nil)
			end
		end
	end

	return node, selected_item
end

-- Lines: 8188 to 8190
function MenuPrePlanningInitiator:refresh_node(node)
	local selected_item_name = node:selected_item() and node:selected_item():name()

	return self:modify_node(node, nil, selected_item_name)
end

-- Lines: 8193 to 8199
function MenuPrePlanningInitiator:create_item(node, params)
	local data_node = {}
	local new_item = node:create_item(data_node, deep_clone(params))

	new_item:set_enabled(params.enabled == nil or not not params.enabled)
	node:add_item(new_item)

	return new_item
end

-- Lines: 8206 to 8209
function MenuCallbackHandler:open_preplanning_plan_item(item)
	managers.menu:open_node("preplanning_plan", {item:name()})
end

-- Lines: 8212 to 8215
function MenuCallbackHandler:open_preplanning_category_item(item)
	managers.menu:open_node("preplanning_category", {item:name()})
end

-- Lines: 8218 to 8221
function MenuCallbackHandler:open_preplanning_custom_item(item)
	managers.menu:open_node("preplanning_custom", {item:name()})
end

-- Lines: 8224 to 8227
function MenuCallbackHandler:open_preplanning_type_item(item)
	managers.menu:open_node("preplanning_type", {item:name()})
end

-- Lines: 8232 to 8266
function MenuCallbackHandler:open_preplanning_to_type(category, type, item_name)
	local logic = managers.menu:active_menu() and managers.menu:active_menu().logic
	local node_name = logic and logic:selected_node() and logic:selected_node():parameters().name
	local in_main = false

	if node_name == "preplanning" then
		in_main = true
	elseif node_name == "preplanning_category" then
		if logic:selected_node():parameters().current_category ~= category then
			managers.menu:back(false)

			in_main = true
		end
	elseif node_name == "preplanning_type" then
		if logic:selected_node():parameters().current_type ~= type then
			local current_category = tweak_data:get_raw_value("preplanning", "types", logic:selected_node():parameters().current_type, "category")

			if current_category ~= category then
				managers.menu:back(false)

				in_main = true
			end

			managers.menu:back(false)
		end
	elseif node_name == "preplanning_plan" then
		managers.menu:back(false)

		in_main = true
	elseif node_name == "preplanning_custom" then
		managers.menu:back(false)

		in_main = true
	end

	if in_main then
		managers.menu:open_node("preplanning_category", {
			category,
			false
		})
	end

	managers.menu:open_node("preplanning_type", {
		type,
		item_name
	})
end

-- Lines: 8268 to 8288
function MenuCallbackHandler:open_preplanning_to_plan(plan, item_name)
	local logic = managers.menu:active_menu() and managers.menu:active_menu().logic
	local node_name = logic and logic:selected_node() and logic:selected_node():parameters().name

	if node_name == "preplanning" then
		-- Nothing
	elseif node_name == "preplanning_category" then
		managers.menu:back(false)
	elseif node_name == "preplanning_type" then
		managers.menu:back(false)
		managers.menu:back(false)
	elseif node_name == "preplanning_plan" then
		if logic:selected_node():parameters().current_plan ~= plan then
			managers.menu:back(false)
		end
	elseif node_name == "preplanning_custom" then
		managers.menu:back(false)
	end

	print(plan, item_name)
	managers.menu:open_node("preplanning_plan", {
		plan,
		item_name
	})
end

-- Lines: 8290 to 8292
function MenuCallbackHandler:stop_preplanning_post_event()
	managers.menu_component:preplanning_stop_event()
end

-- Lines: 8294 to 8299
function MenuCallbackHandler:pressed_preplanning_custom_point(item)
	if item:parameters().post_event then
		managers.menu_component:preplanning_post_event(item:parameters().post_event, item:name())
		managers.menu_component:preplanning_start_custom_talk(item:name())
	end
end

-- Lines: 8301 to 8307
function MenuCallbackHandler:set_preplanning_custom_filter(item)
	if item and item:enabled() then
		print("AAAAAAAAAAAAA ", item:name())
	end
end

-- Lines: 8309 to 8314
function MenuCallbackHandler:set_preplanning_category_filter(item)
	if item and item:enabled() then
		managers.menu_component:set_preplanning_category_filter(item:name())
		managers.menu:open_node("preplanning_category", {
			item:name(),
			false
		})
	end
end

-- Lines: 8316 to 8321
function MenuCallbackHandler:set_preplanning_type_filter(item)
	if item and item:enabled() then
		managers.menu_component:set_preplanning_type_filter(item:name())
		managers.menu:open_node("preplanning_type", {
			false,
			item:name()
		})
	end
end

-- Lines: 8323 to 8337
function MenuCallbackHandler:vote_preplanning_mission_element_by_item(item)
	if item then
		if item:enabled() then
			managers.preplanning:vote_on_plan(item:parameters().type, item:name())

			local post_event = tweak_data:get_raw_value("preplanning", "types", item:parameters().type, "post_event")

			if post_event then
				managers.menu_component:preplanning_post_event(post_event)
			else
				managers.menu_component:preplanning_stop_event()
			end
		else
			managers.menu_component:preplanning_flash_error(item:name(), item:parameters().flash_budget, item:parameters().flash_money)
		end
	end
end

-- Lines: 8339 to 8345
function MenuCallbackHandler:vote_preplanning_mission_element_by_id(id)
	local logic = managers.menu:active_menu() and managers.menu:active_menu().logic
	local item = logic and logic:selected_node() and logic:selected_node():item(id)

	if item then
		MenuCallbackHandler:vote_preplanning_mission_element_by_item(item)
	end
end

-- Lines: 8349 to 8350
function MenuCallbackHandler:select_preplanning_mission_element_by_item(item)
end

-- Lines: 8353 to 8356
function MenuCallbackHandler:reserve_preplanning_mission_element(type, id)
	print("[reserve_preplanning_mission_element]", "type", type, "id", id)
	managers.preplanning:reserve_mission_element(type, id)
end

-- Lines: 8358 to 8371
function MenuCallbackHandler:reserve_preplanning_mission_element_by_item(item)
	if item then
		if item:enabled() then
			local logic = managers.menu:active_menu() and managers.menu:active_menu().logic
			local type = logic and logic:selected_node() and logic:selected_node():parameters().current_type

			if type then
				MenuCallbackHandler:reserve_preplanning_mission_element(type, item:name())
			end
		else
			managers.menu_component:preplanning_flash_error(item:name(), item:parameters().flash_budget, item:parameters().flash_money)
		end
	end
end

-- Lines: 8373 to 8379
function MenuCallbackHandler:reserve_preplanning_mission_element_by_id(id)
	local logic = managers.menu:active_menu() and managers.menu:active_menu().logic
	local item = logic and logic:selected_node() and logic:selected_node():item(id)

	if item then
		MenuCallbackHandler:reserve_preplanning_mission_element_by_item(item)
	end
end

-- Lines: 8383 to 8386
function MenuCallbackHandler:unreserve_preplanning_mission_element(id)
	print("[unreserve_preplanning_mission_element]", "id", id)
	managers.preplanning:unreserve_mission_element(id)
end

-- Lines: 8388 to 8392
function MenuCallbackHandler:unreserve_preplanning_mission_element_by_item(item)
	if item and item:enabled() then
		MenuCallbackHandler:unreserve_preplanning_mission_element(item:name())
	end
end

-- Lines: 8394 to 8401
function MenuCallbackHandler:unreserve_preplanning_mission_element_by_id(id)
	local logic = managers.menu:active_menu() and managers.menu:active_menu().logic
	local item = logic and logic:selected_node() and logic:selected_node():item(id)

	if item then
		MenuCallbackHandler:unreserve_preplanning_mission_element_by_item(item)
	end
end

-- Lines: 8405 to 8417
function MenuCallbackHandler:swap_preplanning_mission_element_by_id(id)
	local logic = managers.menu:active_menu().logic

	if logic then
		if not logic:selected_node() then
			return false
		end

		local type = logic:selected_node():parameters().current_type

		assert(type and id, "[MenuCallbackHandler:swap_preplanning_mission_element_by_id] Mission element is missing!", "type", type, "id", id)
		MenuCallbackHandler:unreserve_preplanning_mission_element(id)
		MenuCallbackHandler:reserve_preplanning_mission_element(type, id)
	end
end

-- Lines: 8420 to 8424
function MenuCallbackHandler:swap_preplanning_mission_element_by_item(item)
	if item and item:enabled() then
		MenuCallbackHandler:swap_preplanning_mission_element_by_id(item:name())
	end
end

-- Lines: 8426 to 8437
function MenuCallbackHandler:select_preplanning_item_by_id(id)
	local logic = managers.menu:active_menu().logic

	if logic then
		if not logic:selected_node() then
			return false
		end

		if not logic:selected_node():selected_item() or logic:selected_node():selected_item():name() ~= id then
			logic:select_item(id, true)
		end
	end
end

-- Lines: 8439 to 8440
function MenuCallbackHandler:chk_preplanning_type(item)
	return managers.menu_component:get_preplanning_filter() == item:name()
end

-- Lines: 8443 to 8444
function MenuCallbackHandler:chk_preplanning_point(item)
	return false
end

-- Lines: 8448 to 8450
function MenuCallbackHandler:clear_preplanning_category_filter()
	managers.menu_component:set_preplanning_category_filter(false)
end

-- Lines: 8452 to 8454
function MenuCallbackHandler:clear_preplanning_type_filter()
	managers.menu_component:set_preplanning_type_filter(false)
end

-- Lines: 8458 to 8460
function MenuCallbackHandler:open_preplanning_help(item)
	managers.menu:show_preplanning_help()
end

-- Lines: 8462 to 8464
function MenuCallbackHandler:open_preplanning_drawboard_item(item)
	managers.menu:open_node("preplanning_drawboard")
end

-- Lines: 8466 to 8469
function MenuCallbackHandler:toggle_preplanning_drawing(item)
	local peer_id = tonumber(item:name())

	managers.menu_component:toggle_preplanning_drawing(peer_id)
end

-- Lines: 8473 to 8488
function MenuCallbackHandler:_jukebox_disable_items(selected_item)
	local your_choice = managers.menu:active_menu().logic:selected_node():item("toggle_jukebox_your_choice")
	local items = {}

	table.insert(items, managers.menu:active_menu().logic:selected_node():item("toggle_jukebox_playlist_all"))
	table.insert(items, managers.menu:active_menu().logic:selected_node():item("toggle_jukebox_playlist_global"))
	table.insert(items, managers.menu:active_menu().logic:selected_node():item("toggle_jukebox_playlist_heist"))
	table.insert(items, managers.menu:active_menu().logic:selected_node():item("toggle_jukebox_server_choice"))
	table.insert(items, your_choice)

	for _, item in ipairs(items) do
		item:set_value(item == selected_item and "on" or "off")
	end

	managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice"):set_enabled(selected_item == your_choice)
end

-- Lines: 8490 to 8498
function MenuCallbackHandler:jukebox_playlist_all(item)
	if item:enabled() then
		self:_jukebox_disable_items(item)

		Global.music_manager.loadout_selection = nil

		managers.music:track_listen_start("stop_all_music")
		managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice"):set_icon_visible(false)
	end
end

-- Lines: 8500 to 8508
function MenuCallbackHandler:jukebox_playlist_global(item)
	if item:enabled() then
		self:_jukebox_disable_items(item)

		Global.music_manager.loadout_selection = "global"

		managers.music:track_listen_start("stop_all_music")
		managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice"):set_icon_visible(false)
	end
end

-- Lines: 8510 to 8518
function MenuCallbackHandler:jukebox_playlist_heist(item)
	if item:enabled() then
		self:_jukebox_disable_items(item)

		Global.music_manager.loadout_selection = "heist"

		managers.music:track_listen_start("stop_all_music")
		managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice"):set_icon_visible(false)
	end
end

-- Lines: 8520 to 8528
function MenuCallbackHandler:jukebox_server_choice(item)
	if item:enabled() then
		self:_jukebox_disable_items(item)

		Global.music_manager.loadout_selection = "server"

		managers.music:track_listen_start("stop_all_music")
		managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice"):set_icon_visible(false)
	end
end

-- Lines: 8530 to 8535
function MenuCallbackHandler:jukebox_your_choice(item)
	if item:enabled() then
		self:_jukebox_disable_items(item)

		Global.music_manager.loadout_selection = managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice"):value()
	end
end

-- Lines: 8537 to 8549
function MenuCallbackHandler:jukebox_track_selection(item)
	local track = item:value()
	Global.music_manager.loadout_selection = track

	if track ~= "all" and track ~= "playlist" then
		managers.music:track_listen_start("music_heist_assault", track)
		managers.menu_component:on_ready_pressed_mission_briefing_gui(false)
		item:set_icon_visible(true)
	else
		managers.music:track_listen_stop()
		item:set_icon_visible(false)
	end
end

-- Lines: 8551 to 8582
function MenuCallbackHandler:jukebox_option_heist_tracks(item)
	local track = item:value()
	local job = item:parameters().heist_job

	if job == "escape" then
		managers.music:track_attachment_add(job, track)
	else
		local job_tweak = tweak_data.narrative.jobs[job]

		if not job_tweak then
			return
		end

		local day = item:parameters().heist_days and item:parameters().heist_days or ""

		managers.music:track_attachment_add(job_tweak.name_id .. day, track)
	end

	local item_list = managers.menu:active_menu().logic:selected_node():items()

	for _, item_data in ipairs(item_list) do
		if item_data.set_icon_visible then
			item_data:set_icon_visible(false)
		end
	end

	if track ~= "all" and track ~= "playlist" then
		managers.music:track_listen_start("music_heist_assault", track)
		item:set_icon_visible(true)
	else
		managers.music:track_listen_stop()
	end

	managers.savefile:setting_changed()
end

-- Lines: 8584 to 8616
function MenuCallbackHandler:jukebox_option_heist_playlist(item)
	local tracks_list = managers.music:jukebox_music_tracks()
	local empty_list = true

	for _, track_name in pairs(tracks_list) do
		if managers.menu:active_menu().logic:selected_node():item(track_name):value() == "on" then
			empty_list = false

			break
		end
	end

	local item_list = managers.menu:active_menu().logic:selected_node():items()

	for _, item_data in ipairs(item_list) do
		if item_data.set_icon_visible then
			item_data:set_icon_visible(false)
		end
	end

	if empty_list then
		item:set_value("on")
	else
		if item:value() == "on" then
			managers.music:playlist_add(item:name())
			managers.music:track_listen_start("music_heist_assault", item:name())
			item:set_icon_visible(true)
		else
			managers.music:playlist_remove(item:name())
			managers.music:track_listen_stop()
		end

		managers.savefile:setting_changed()
	end
end

-- Lines: 8618 to 8650
function MenuCallbackHandler:jukebox_option_menu_playlist(item)
	local tracks_list = managers.music:jukebox_menu_tracks()
	local empty_list = true

	for _, track_name in pairs(tracks_list) do
		if managers.menu:active_menu().logic:selected_node():item(track_name):value() == "on" then
			empty_list = false

			break
		end
	end

	local item_list = managers.menu:active_menu().logic:selected_node():items()

	for _, item_data in ipairs(item_list) do
		if item_data.set_icon_visible then
			item_data:set_icon_visible(false)
		end
	end

	if empty_list then
		item:set_value("on")
	else
		if item:value() == "on" then
			managers.music:playlist_menu_add(item:name())
			managers.music:track_listen_start(item:name())
			item:set_icon_visible(true)
		else
			managers.music:playlist_menu_remove(item:name())
			managers.music:track_listen_stop()
		end

		managers.savefile:setting_changed()
	end
end

-- Lines: 8652 to 8671
function MenuCallbackHandler:jukebox_option_menu_tracks(item)
	local track = item:value()
	local item_list = managers.menu:active_menu().logic:selected_node():items()

	for _, item_data in ipairs(item_list) do
		if item_data.set_icon_visible then
			item_data:set_icon_visible(false)
		end
	end

	managers.music:track_attachment_add(item:name(), track)

	if track ~= "all" and track ~= "playlist" then
		managers.music:track_listen_start(track)
		item:set_icon_visible(true)
	else
		managers.music:track_listen_stop()
	end

	managers.savefile:setting_changed()
end

-- Lines: 8673 to 8675
function MenuCallbackHandler:jukebox_options_enter(item)
	managers.music:post_event("stop_all_music")
end

-- Lines: 8677 to 8681
function MenuCallbackHandler:jukebox_option_back(item)
	managers.music:track_listen_stop()
	managers.music:post_event(managers.music:jukebox_menu_track("mainmenu"))
	managers.menu_component:show_contract_character(true)
end
MenuCrimeNetGageAssignmentInitiator = MenuCrimeNetGageAssignmentInitiator or class(MenuCrimeNetContactInfoInitiator)

-- Lines: 8690 to 8751
function MenuCrimeNetGageAssignmentInitiator:modify_node(original_node, data)
	local node = original_node

	node:clean_items()
	self:create_divider(node, 1, managers.localization:text("menu_gage_assignment_div_menu"), nil, tweak_data.screen_colors.text)
	self:create_item(node, {
		id = "_introduction",
		name_localized = managers.localization:text("menu_gage_assignment_introduction_title")
	})
	self:create_item(node, {
		id = "_summary",
		name_localized = managers.localization:text("menu_gage_assignment_summary_title")
	})

	if SystemInfo:platform() ~= Idstring("XB1") then
		self:create_item(node, {
			id = "_video",
			name_localized = managers.localization:text("menu_gage_assignment_video_title")
		})
	end

	self:create_divider(node, 2)
	self:create_divider(node, 3, managers.localization:text("menu_gage_assignment_div_packages"), nil, tweak_data.screen_colors.text)

	local node_data = {}

	for assignment, data in pairs(tweak_data.gage_assignment:get_assignments()) do
		table.insert(node_data, {
			id = assignment,
			name_localized = managers.localization:text(data.name_id),
			aquire = data.aquire or 1
		})
	end

	table.sort(node_data, function (x, y)
		return x.aquire < y.aquire
	end)

	for assignment, data in ipairs(node_data) do
		self:create_item(node, data)
	end

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		pd2_corner = "true",
		text_id = "menu_back",
		gui_node_custom = "true",
		align = "left",
		last_item = "true",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	if not managers.gage_assignment:visited_gage_crimenet() then
		node:set_default_item_name("_introduction")
		node:select_item("_introduction")
		managers.menu:active_menu().logic:trigger_item(false, node:item("_introduction"))
		managers.gage_assignment:visit_gage_crimenet()
	else
		node:set_default_item_name("_summary")
		node:select_item("_summary")
		managers.menu:active_menu().logic:trigger_item(false, node:item("_summary"))
	end

	managers.gage_assignment:dialog_show_completed_assignments()

	return node
end
MenuCrimeNetSpecialInitiator = MenuCrimeNetSpecialInitiator or class()
MenuCrimeNetSpecialInitiator.job_callback = nil
MenuCrimeNetSpecialInitiator.choose_any_job = nil

-- Lines: 8758 to 8760
function MenuCrimeNetSpecialInitiator:modify_node(original_node, data)
	local node = original_node

	return self:setup_node(node)
end

-- Lines: 8763 to 8765
function MenuCrimeNetSpecialInitiator:refresh_node(node)
	self:setup_node(node)

	return node
end

-- Lines: 8768 to 8940
function MenuCrimeNetSpecialInitiator:setup_node(node)
	local listed_contact = node:parameters().listed_contact

	MenuCallbackHandler:chk_dlc_content_updated()

	if not listed_contact then
		for _, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
			local job_tweak = tweak_data.narrative:job_data(job_id)

			if job_tweak.contact then
				if job_tweak.contact == "bain" then
					listed_contact = "bain"

					break
				else
					listed_contact = job_tweak.contact
				end
			end
		end
	end

	node:clean_items()

	if not node:item("divider_end") then
		if self.pre_create_clbk then
			self:pre_create_clbk(node)
		end

		local max_jc = managers.job:get_max_jc_for_player()
		local jobs = {}
		local contacts = {}

		for index, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
			local job_tweak = tweak_data.narrative:job_data(job_id)
			local contact = job_tweak.contact
			local contact_tweak = tweak_data.narrative.contacts[contact]

			if contact then
				local allow_contact = true
				allow_contact = not table.contains(contacts, contact) and (not contact_tweak or not contact_tweak.hidden)

				if allow_contact then
					table.insert(contacts, contact)
				end

				jobs[contact] = jobs[contact] or {}
				local dlc = job_tweak.dlc
				dlc = not dlc or managers.dlc:is_dlc_unlocked(dlc)

				if not tweak_data.narrative:is_wrapped_to_job(job_id) then
					table.insert(jobs[contact], {
						id = job_id,
						enabled = self.choose_any_job or dlc and (job_tweak.jc or 0) + (job_tweak.professional and 10 or 0) <= max_jc
					})
				end
			end
		end

		table.sort(contacts, function (x, y)
			return x < y
		end)

		for _, contracts in pairs(jobs) do
			table.sort(contracts, function (x, y)
				if x.enabled ~= y.enabled then
					return x.enabled
				end

				local job_tweak_x = tweak_data.narrative:job_data(x.id)
				local job_tweak_y = tweak_data.narrative:job_data(y.id)
				local string_x = managers.localization:to_upper_text(job_tweak_x.name_id)
				local string_y = managers.localization:to_upper_text(job_tweak_y.name_id)
				local ids_x = Idstring(string_x)
				local ids_y = Idstring(string_y)

				if ids_x ~= ids_y then
					return string_x < string_y
				end

				if job_tweak_x.jc ~= job_tweak_y.jc then
					return job_tweak_x.jc <= job_tweak_y.jc
				end

				return false
			end)
		end

		local params = {
			callback = "choice_premium_contact",
			name = "contact_filter",
			filter = true,
			text_id = "menu_contact_filter"
		}
		local data_node = {type = "MenuItemMultiChoice"}
		local num_contact = 0

		for index, contact in ipairs(contacts) do
			if jobs[contact] then
				num_contact = num_contact + 1
			end
		end

		if num_contact > 1 then
			table.insert(data_node, {
				text_id = "",
				no_text = true,
				_meta = "option",
				value = contacts[#contacts] .. "#"
			})
		end

		for index, contact in ipairs(contacts) do
			if jobs[contact] then
				table.insert(data_node, {
					_meta = "option",
					text_id = tweak_data.narrative.contacts[contact].name_id,
					value = contact
				})
			end
		end

		if num_contact > 1 then
			table.insert(data_node, {
				text_id = "",
				no_text = true,
				_meta = "option",
				value = contacts[1] .. "#"
			})
		end

		local new_item = node:create_item(data_node, params)

		new_item:set_value(listed_contact)
		node:add_item(new_item)
		self:create_divider(node, "1")
		self:create_divider(node, "title", self.contract_divider_id or "menu_cn_premium_buy_title", nil, tweak_data.screen_colors.text)

		if jobs[listed_contact] then
			for _, contract in pairs(jobs[listed_contact]) do
				self:create_job(node, contract)
			end
		end

		if self.post_create_clbk then
			self:post_create_clbk(node)
		end

		self:create_divider(node, "end")
	end

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		last_item = "true",
		text_id = "menu_back",
		align = "right",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name(self.default_item or "contact_filter")
	node:select_item(self.default_item or "contact_filter")

	return node
end

-- Lines: 8944 to 8958
function MenuCrimeNetSpecialInitiator:create_divider(node, id, text_id, size, color)
	local params = {
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 8960 to 9048
function MenuCrimeNetSpecialInitiator:create_job(node, contract)
	local id = contract.id
	local enabled = contract.enabled
	local text_id, color_ranges = tweak_data.narrative:create_job_name(id)
	local help_id = ""
	local ghostable = managers.job:is_job_ghostable(id)

	if ghostable then
		text_id = text_id .. " " .. managers.localization:get_default_macro("BTN_GHOST")
	end

	if not enabled then
		local job_tweak = tweak_data.narrative:job_data(id)
		local player_stars = managers.experience:level_to_stars()
		local max_jc = managers.job:get_max_jc_for_player()
		local job_tweak = tweak_data.narrative:job_data(id)
		local jc_lock = math.clamp(job_tweak.jc, 0, 100)
		local min_stars = #tweak_data.narrative.STARS

		for i, d in ipairs(tweak_data.narrative.STARS) do
			if jc_lock <= d.jcs[1] then
				min_stars = i

				break
			end
		end

		local level_lock = (min_stars - 1) * 10
		local pass_dlc = not job_tweak.dlc or managers.dlc:is_dlc_unlocked(job_tweak.dlc)
		local pass_level = min_stars <= player_stars

		if not pass_dlc then
			local locks = job_tweak.gui_locks
			local unlock_id = ""

			if locks then
				local dlc = locks.dlc
				local achievement = locks.achievement
				local saved_job_value = locks.saved_job_value
				local level = locks.level

				if dlc and not managers.dlc:is_dlc_unlocked(dlc) then
					-- Nothing
				elseif achievement and managers.achievment:get_info(achievement) and not managers.achievment:get_info(achievement).awarded then
					text_id = text_id .. "  " .. managers.localization:to_upper_text("menu_bm_achievement_locked_" .. tostring(achievement))
				end
			end
		elseif not pass_level then
			-- Nothing
		end
	end

	local params = {
		localize = "false",
		customize_contract = "true",
		name = "job_" .. id,
		text_id = text_id,
		color_ranges = color_ranges,
		callback = enabled and (self.job_callback or "open_contract_node"),
		disabled_color = tweak_data.screen_colors.important_1,
		id = id
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(enabled)
	node:add_item(new_item)
end
MenuReticleSwitchInitiator = MenuReticleSwitchInitiator or class(MenuCrimeNetSpecialInitiator)

-- Lines: 9052 to 9054
function MenuReticleSwitchInitiator:modify_node(original_node, data)
	local node = original_node

	return self:setup_node(node, data)
end

-- Lines: 9057 to 9153
function MenuReticleSwitchInitiator:setup_node(node, data)
	node:clean_items()

	data = data or node:parameters().menu_component_data
	local part_id = data.name
	local slot = data.slot
	local category = data.category
	local color_index, type_index = managers.blackmarket:get_part_texture_switch_data(category, slot, part_id)

	if not node:item("divider_end") then
		local params = {
			callback = "update_weapon_texture_switch",
			name = "reticle_type",
			filter = true,
			text_id = "menu_reticle_type"
		}
		local data_node = {type = "MenuItemMultiChoice"}
		local pass_dlc = nil

		for index, reticle_data in ipairs(tweak_data.gui.weapon_texture_switches.types.sight) do
			pass_dlc = not reticle_data.dlc or managers.dlc:is_dlc_unlocked(reticle_data.dlc)

			table.insert(data_node, {
				_meta = "option",
				text_id = reticle_data.name_id,
				value = index,
				color = not pass_dlc and tweak_data.screen_colors.important_1
			})
		end

		local new_item = node:create_item(data_node, params)

		node:add_item(new_item)
		new_item:set_value(type_index)

		local params = {
			callback = "update_weapon_texture_switch",
			name = "reticle_color",
			filter = true,
			text_id = "menu_reticle_color"
		}
		local data_node = {type = "MenuItemMultiChoice"}

		for index, color_data in ipairs(tweak_data:get_raw_value("gui", "weapon_texture_switches", "color_indexes") or {}) do
			pass_dlc = not color_data.dlc or managers.dlc:is_dlc_unlocked(color_data.dlc)

			table.insert(data_node, {
				_meta = "option",
				text_id = "menu_recticle_color_" .. color_data.color,
				value = index,
				color = not pass_dlc and tweak_data.screen_colors.important_1
			})
		end

		local new_item = node:create_item(data_node, params)

		node:add_item(new_item)
		new_item:set_value(color_index)
		self:create_divider(node, "end", nil, 256)
	end

	local enabled = MenuCallbackHandler:is_reticle_applicable(node)
	local params = {
		callback = "set_weapon_texture_switch",
		name = "confirm",
		text_id = "dialog_apply",
		align = "right",
		enabled = enabled,
		disabled_color = tweak_data.screen_colors.important_1
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	local params = {
		last_item = "true",
		name = "back",
		text_id = "dialog_cancel",
		align = "right",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name("reticle_type")
	node:select_item("reticle_type")

	node:parameters().menu_component_data = data
	node:parameters().set_blackmarket_enabled = false

	return node
end

-- Lines: 9156 to 9165
function MenuReticleSwitchInitiator:refresh_node(node, data)
	local confirm = node:item("confirm")
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.update_item_dlc_locks then
		local enabled = active_node_gui:update_item_dlc_locks()

		confirm:set_enabled(enabled)
	end
end

-- Lines: 9167 to 9168
function MenuReticleSwitchInitiator:create_multichoice()
end

-- Lines: 9170 to 9190
function MenuCallbackHandler:is_reticle_applicable(node)
	local type = node:item("reticle_type"):value()
	local color = node:item("reticle_color"):value()
	local type_data = tweak_data:get_raw_value("gui", "weapon_texture_switches", "types", "sight", type)
	local color_data = tweak_data:get_raw_value("gui", "weapon_texture_switches", "color_indexes", color)
	local type_dlc = type_data and type_data.dlc or false
	local color_dlc = color_data and color_data.dlc or false
	local pass_type = not type_dlc or managers.dlc:is_dlc_unlocked(type_dlc)
	local pass_color = not color_dlc or managers.dlc:is_dlc_unlocked(color_dlc)

	return pass_type and pass_color
end

-- Lines: 9193 to 9225
function MenuCallbackHandler:update_weapon_texture_switch(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local node = managers.menu:active_menu().logic:selected_node()
	local color = node:item("reticle_color"):value()
	local type = node:item("reticle_type"):value()
	local data = node:parameters().menu_component_data
	local part_id = data.name
	local data_string = tostring(color) .. " " .. tostring(type)
	local texture = managers.blackmarket:get_texture_switch_from_data(data_string, part_id)
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.set_reticle_texture and texture and active_node_gui:get_recticle_texture_ids() ~= Idstring(texture) then
		active_node_gui:set_reticle_texture(texture)
	end

	local logic = managers.menu:active_menu().logic

	if logic then
		logic:refresh_node()
	end
end

-- Lines: 9227 to 9259
function MenuCallbackHandler:set_weapon_texture_switch(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local node = managers.menu:active_menu().logic:selected_node()

	if not MenuCallbackHandler:is_reticle_applicable(node) then
		return
	end

	local color = node:item("reticle_color"):value()
	local type = node:item("reticle_type"):value()
	local data = node:parameters().menu_component_data
	local part_id = data.name
	local slot = data.slot
	local category = data.category
	local data_string = tostring(color) .. " " .. tostring(type)

	managers.blackmarket:set_part_texture_switch(category, slot, part_id, data_string)
	managers.menu:back()
end
MenuCrimeNetCasinoInitiator = MenuCrimeNetCasinoInitiator or class()

-- Lines: 9263 to 9273
function MenuCrimeNetCasinoInitiator:modify_node(original_node, data)
	local node = deep_clone(original_node)

	if data and data.back_callback then
		table.insert(node:parameters().back_callback, data.back_callback)
	end

	self:_create_items(node)

	node:parameters().menu_component_data = data

	return node
end

-- Lines: 9276 to 9287
function MenuCrimeNetCasinoInitiator:refresh_node(node)
	local options = {
		preferred = node:item("preferred_item"):value(),
		infamous = node:item("increase_infamous"):value(),
		card1 = node:item("secure_card_1"):value(),
		card2 = node:item("secure_card_2"):value(),
		card3 = node:item("secure_card_3"):value()
	}

	node:clean_items()
	self:_create_items(node, options)

	return node
end

-- Lines: 9290 to 9291
function MenuCallbackHandler:casino_betting_visible()
	return true
end

-- Lines: 9326 to 9517
function MenuCrimeNetCasinoInitiator:_create_items(node, options)
	local visible_callback = "casino_betting_visible"
	local preferred_data = {
		{
			value = "none",
			text_id = "menu_casino_option_prefer_none",
			_meta = "option"
		},
		{
			value = "weapon_mods",
			text_id = "menu_casino_stat_weapon_mods",
			_meta = "option"
		},
		{
			value = "masks",
			text_id = "menu_casino_stat_masks",
			_meta = "option"
		},
		{
			value = "materials",
			text_id = "menu_casino_stat_materials",
			_meta = "option"
		},
		{
			value = "textures",
			text_id = "menu_casino_stat_textures",
			_meta = "option"
		},
		{
			value = "colors",
			text_id = "menu_casino_stat_colors",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}
	local preferred_params = {
		name = "preferred_item",
		callback = "crimenet_casino_update",
		text_id = "",
		visible_callback = visible_callback
	}
	local preferred_item = node:create_item(preferred_data, preferred_params)

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 1) then
		preferred_item:set_value("none")
		preferred_item:set_enabled(false)
	else
		preferred_item:set_value(options and options.preferred or "none")
	end

	node:add_item(preferred_item)

	local infamous_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "CoreMenuItemToggle.ItemToggle"
	}
	local infamous_params = {
		name = "increase_infamous",
		callback = "crimenet_casino_update",
		text_id = "menu_casino_option_infamous_title",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback
	}
	local infamous_items = {
		textures = true,
		colors = false,
		materials = true,
		weapon_mods = false,
		masks = true
	}
	local preferred_value = preferred_item:value()
	local infamous_item = node:create_item(infamous_data, infamous_params)

	infamous_item:set_enabled(infamous_items[preferred_value])

	if not infamous_item:enabled() then
		infamous_item:set_value("off")
	else
		infamous_item:set_value(options and options.infamous or "off")
	end

	node:add_item(infamous_item)
	self:create_divider(node, "casino_divider_securecards")

	local card1_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "CoreMenuItemToggle.ItemToggle"
	}
	local card1_params = {
		name = "secure_card_1",
		callback = "crimenet_casino_safe_card1",
		text_id = "menu_casino_option_safecard1",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback
	}

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 1) then
		card1_params.disabled_color = Color(1, 0.6, 0.2, 0.2)
		card1_params.text_id = managers.localization:to_upper_text("menu_casino_option_safecard1") .. " - " .. managers.localization:to_upper_text("menu_casino_option_safecard_lock", {level = tweak_data:get_value("casino", "secure_card_level", 1)})
		card1_params.localize = "false"
	end

	local card1_item = node:create_item(card1_data, card1_params)

	card1_item:set_value(preferred_item:value() ~= "none" and options and options.card1 or "off")

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 1) then
		card1_item:set_enabled(false)
	else
		card1_item:set_enabled(preferred_item:value() ~= "none")
	end

	node:add_item(card1_item)

	local card2_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "CoreMenuItemToggle.ItemToggle"
	}
	local card2_params = {
		name = "secure_card_2",
		callback = "crimenet_casino_safe_card2",
		text_id = "menu_casino_option_safecard2",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback
	}

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 2) then
		card2_params.disabled_color = Color(1, 0.6, 0.2, 0.2)
		card2_params.text_id = managers.localization:to_upper_text("menu_casino_option_safecard2") .. " - " .. managers.localization:to_upper_text("menu_casino_option_safecard_lock", {level = tweak_data:get_value("casino", "secure_card_level", 2)})
		card2_params.localize = "false"
	end

	local card2_item = node:create_item(card2_data, card2_params)

	card2_item:set_value(preferred_item:value() ~= "none" and options and options.card2 or "off")

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 2) then
		card2_item:set_enabled(false)
	else
		card2_item:set_enabled(preferred_item:value() ~= "none")
	end

	node:add_item(card2_item)

	local card3_data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "CoreMenuItemToggle.ItemToggle"
	}
	local card3_params = {
		name = "secure_card_3",
		callback = "crimenet_casino_safe_card3",
		text_id = "menu_casino_option_safecard3",
		icon_by_text = true,
		disabled_color = Color(0.25, 1, 1, 1),
		visible_callback = visible_callback
	}

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 3) then
		card3_params.disabled_color = Color(1, 0.6, 0.2, 0.2)
		card3_params.text_id = managers.localization:to_upper_text("menu_casino_option_safecard3") .. " - " .. managers.localization:to_upper_text("menu_casino_option_safecard_lock", {level = tweak_data:get_value("casino", "secure_card_level", 3)})
		card3_params.localize = "false"
	end

	local card3_item = node:create_item(card3_data, card3_params)

	card3_item:set_value(preferred_item:value() ~= "none" and options and options.card3 or "off")

	if managers.experience:current_level() < tweak_data:get_value("casino", "secure_card_level", 3) then
		card3_item:set_enabled(false)
	else
		card3_item:set_enabled(preferred_item:value() ~= "none")
	end

	node:add_item(card3_item)
	self:create_divider(node, "casino_cost")

	local increase_infamous = infamous_item:value() == "on"
	local secured_cards = (card1_item:value() == "on" and 1 or 0) + (card2_item:value() == "on" and 1 or 0) + (card3_item:value() == "on" and 1 or 0)

	if options then
		managers.menu:active_menu().renderer:selected_node():set_update_values(preferred_item:value(), secured_cards, increase_infamous, infamous_item:enabled(), card1_item:enabled())
		managers.menu_component:can_afford()
	end
end

-- Lines: 9519 to 9534
function MenuCrimeNetCasinoInitiator:create_divider(node, id, text_id, size, color)
	local params = {
		visible_callback = "casino_betting_visible",
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end
MenuCrimeNetCasinoLootdropInitiator = MenuCrimeNetCasinoLootdropInitiator or class()

-- Lines: 9538 to 9546
function MenuCrimeNetCasinoLootdropInitiator:modify_node(original_node, data)
	local node = deep_clone(original_node)

	if data and data.back_callback then
		table.insert(node:parameters().back_callback, data.back_callback)
	end

	node:parameters().menu_component_data = data

	return node
end
MenuCrimeNetFiltersInitiator = MenuCrimeNetFiltersInitiator or class()

-- Lines: 9551 to 9603
function MenuCrimeNetFiltersInitiator:modify_node(original_node, data)
	local node = original_node

	node:item("toggle_friends_only"):set_value(Global.game_settings.search_friends_only and "on" or "off")

	if MenuCallbackHandler:is_win32() then
		local matchmake_filters = managers.network.matchmake:lobby_filters()

		node:item("toggle_new_servers_only"):set_value(matchmake_filters.num_players and matchmake_filters.num_players.value or -1)
		node:item("toggle_server_state_lobby"):set_value(matchmake_filters.state and matchmake_filters.state.value or -1)
		node:item("toggle_job_appropriate_lobby"):set_value(Global.game_settings.search_appropriate_jobs and "on" or "off")
		node:item("toggle_allow_safehouses"):set_value(Global.game_settings.allow_search_safehouses and "on" or "off")
		node:item("toggle_mutated_lobby"):set_value(Global.game_settings.search_mutated_lobbies and "on" or "off")
		node:item("toggle_modded_lobby"):set_value(Global.game_settings.search_modded_lobbies and "on" or "off")
		node:item("toggle_one_down_lobby"):set_value(Global.game_settings.search_one_down_lobbies and "on" or "off")
		node:item("max_lobbies_filter"):set_value(managers.network.matchmake:get_lobby_return_count())
		node:item("server_filter"):set_value(managers.network.matchmake:distance_filter())
		node:item("difficulty_filter"):set_value(matchmake_filters.difficulty and matchmake_filters.difficulty.value or -1)
		node:item("job_plan_filter"):set_value(matchmake_filters.job_plan and matchmake_filters.job_plan.value or -1)
		node:item("gamemode_filter"):set_value(Global.game_settings.gamemode_filter or GamemodeStandard.id)
		node:item("max_spree_difference_filter"):set_value(Global.game_settings.crime_spree_max_lobby_diff or -1)

		local job_id_filter = node:item("job_id_filter")

		if job_id_filter then
			job_id_filter:set_value(managers.network.matchmake:get_lobby_filter("job_id") or -1)
		end

		local kick_option_filter = node:item("kick_option_filter")

		if kick_option_filter then
			kick_option_filter:set_value(managers.network.matchmake:get_lobby_filter("kick_option") or -1)
		end

		self:add_filters(node)
	end

	self:update_node(node)

	if data and data.back_callback then
		table.insert(node:parameters().back_callback, data.back_callback)
	end

	node:parameters().menu_component_data = data

	return node
end

-- Lines: 9606 to 9633
function MenuCrimeNetFiltersInitiator:update_node(node)
	if MenuCallbackHandler:is_win32() then
		local not_friends_only = not Global.game_settings.search_friends_only

		node:item("toggle_new_servers_only"):set_enabled(not_friends_only)
		node:item("toggle_server_state_lobby"):set_enabled(not_friends_only)
		node:item("toggle_job_appropriate_lobby"):set_enabled(not_friends_only)
		node:item("toggle_mutated_lobby"):set_enabled(not_friends_only)
		node:item("max_lobbies_filter"):set_enabled(not_friends_only)
		node:item("server_filter"):set_enabled(not_friends_only)
		node:item("kick_option_filter"):set_enabled(not_friends_only)
		node:item("job_id_filter"):set_enabled(not_friends_only)
		node:item("job_plan_filter"):set_enabled(not_friends_only)
		node:item("toggle_job_appropriate_lobby"):set_visible(self:is_standard())
		node:item("toggle_allow_safehouses"):set_visible(self:is_standard())
		node:item("toggle_mutated_lobby"):set_visible(self:is_standard())
		node:item("toggle_one_down_lobby"):set_visible(self:is_standard())
		node:item("difficulty_filter"):set_visible(self:is_standard())
		node:item("job_id_filter"):set_visible(self:is_standard())
		node:item("max_spree_difference_filter"):set_visible(self:is_crime_spree())
	end
end

-- Lines: 9636 to 9637
function MenuCrimeNetFiltersInitiator:is_standard()
	return not Global.game_settings or not Global.game_settings.gamemode_filter or Global.game_settings.gamemode_filter == GamemodeStandard.id
end

-- Lines: 9640 to 9641
function MenuCrimeNetFiltersInitiator:is_crime_spree()
	return Global.game_settings and Global.game_settings.gamemode_filter == GamemodeCrimeSpree.id
end

-- Lines: 9645 to 9648
function MenuCrimeNetFiltersInitiator:refresh_node(node)
	self:modify_node(node, {})
	self:update_node(node)
end

-- Lines: 9651 to 9756
function MenuCrimeNetFiltersInitiator:add_filters(node)
	if node:item("divider_end") then
		return
	end

	local params = {
		visible_callback = "is_multiplayer is_win32",
		name = "job_id_filter",
		callback = "choice_job_id_filter",
		text_id = "menu_job_id_filter",
		filter = true
	}
	local data_node = {
		{
			value = -1,
			text_id = "menu_any",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}

	for index, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
		local job_tweak = tweak_data.narrative.jobs[job_id]
		local contact = job_tweak.contact
		local contact_tweak = tweak_data.narrative.contacts[contact]
		local allow = not job_tweak.wrapped_to_job and contact ~= "tests" and (not job_tweak or not job_tweak.hidden)

		if allow then
			local text_id, color_data = tweak_data.narrative:create_job_name(job_id)
			local params = {
				localize = false,
				_meta = "option",
				text_id = text_id,
				value = index
			}

			for count, color in ipairs(color_data) do
				params["color" .. count] = color.color
				params["color_start" .. count] = color.start
				params["color_stop" .. count] = color.stop
			end

			table.insert(data_node, params)
		end
	end

	local new_item = node:create_item(data_node, params)

	new_item:set_value(managers.network.matchmake:get_lobby_filter("job_id") or -1)
	node:add_item(new_item)

	local params = {
		visible_callback = "is_multiplayer is_win32",
		name = "kick_option_filter",
		callback = "choice_kick_option",
		text_id = "menu_kicking_allowed_filter",
		filter = true
	}
	local data_node = {
		{
			value = -1,
			text_id = "menu_any",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}
	local kick_filters = {
		{
			value = 1,
			text_id = "menu_kick_server"
		},
		{
			value = 2,
			text_id = "menu_kick_vote"
		},
		{
			value = 0,
			text_id = "menu_kick_disabled"
		}
	}

	for index, filter in ipairs(kick_filters) do
		table.insert(data_node, {
			_meta = "option",
			text_id = filter.text_id,
			value = filter.value
		})
	end

	local new_item = node:create_item(data_node, params)

	new_item:set_value(managers.network.matchmake:get_lobby_filter("kick_option") or -1)
	node:add_item(new_item)

	local params = {
		size = 8,
		name = "divider_end",
		no_text = true
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	local params = {
		callback = "_reset_filters",
		name = "reset_filters",
		align = "right",
		text_id = "dialog_reset_filters"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	self:modify_node(node, {})
end

-- Lines: 9758 to 9764
function MenuCallbackHandler:_reset_filters(item)
	if managers.network.matchmake.reset_filters then
		managers.network.matchmake:reset_filters()
		managers.network.matchmake:search_lobby(managers.network.matchmake:search_friends_only())
		self:refresh_node(item)
	end
end
MenuMutatorOptionsInitiator = MenuMutatorOptionsInitiator or class(MenuCrimeNetSpecialInitiator)

-- Lines: 9768 to 9770
function MenuMutatorOptionsInitiator:modify_node(original_node, data)
	local node = original_node

	return self:setup_node(node, data)
end

-- Lines: 9774 to 9817
function MenuMutatorOptionsInitiator:setup_node(node, mutator)
	node:clean_items()

	mutator = mutator or node:parameters()._mutator
	local default_item = mutator:setup_options_gui(node)

	self:create_divider(node, "end", nil, 16)

	local params = {
		callback = "reset_mutator",
		name = "reset",
		text_id = "menu_mutators_reset",
		align = "right",
		disabled_color = tweak_data.screen_colors.important_1,
		mutator = mutator
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	local params = {
		callback = "save_mutator_options",
		name = "back",
		last_item = "true",
		text_id = "dialog_accept",
		align = "right"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	node:parameters()._mutator = mutator

	if default_item then
		node:set_default_item_name(default_item:parameters().name)
		node:select_item(default_item:parameters().name)
	end

	return node
end

-- Lines: 9821 to 9822
function MenuMutatorOptionsInitiator:refresh_node(node, data)
end

-- Lines: 9824 to 9826
function MenuCallbackHandler:reset_mutator(item)
	item:parameters().mutator:reset_to_default()
end

-- Lines: 9830 to 9840
function MenuCallbackHandler:save_mutator_options(item)
	local mutator = item:parameters().gui_node.node:parameters()._mutator

	if mutator then
		managers.mutators:set_enabled(mutator, true)
	end

	managers.menu:back()
	managers.menu_component:mutators_list_gui():refresh()
	self:_update_mutators_info()
end

-- Lines: 9843 to 9848
function MenuCallbackHandler:_update_mutators_info()
	if Network:is_server() then
		managers.network.matchmake:set_server_attributes(self:get_matchmake_attributes())
		managers.mutators:update_lobby_info()
	end
end
MenuLobbyCountdownInitiator = MenuLobbyCountdownInitiator or class(MenuCrimeNetSpecialInitiator)

-- Lines: 9853 to 9855
function MenuLobbyCountdownInitiator:modify_node(original_node, data)
	local node = original_node

	return self:setup_node(node, data)
end

-- Lines: 9859 to 9878
function MenuLobbyCountdownInitiator:setup_node(node, mutator)
	node:clean_items()

	local params = {
		last_item = "true",
		name = "back",
		text_id = "dialog_cancel",
		align = "right",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name("back")
	node:select_item("back")

	return node
end

-- Lines: 9882 to 9883
function MenuLobbyCountdownInitiator:refresh_node(node, data)
end
MenuCrimeNetSmartmatchmakeInitiator = MenuCrimeNetSmartmatchmakeInitiator or class()

-- Lines: 9890 to 9905
function MenuCrimeNetSmartmatchmakeInitiator:modify_node(original_node, data)
	local node = original_node

	self:add_filters(node)

	if data and data.back_callback then
		table.insert(node:parameters().back_callback, data.back_callback)
	end

	node:parameters().menu_component_data = data

	return node
end

-- Lines: 9908 to 9964
function MenuCrimeNetSmartmatchmakeInitiator:add_filters(node)
	if node:item("divider_end") then
		return
	end

	local params = {
		visible_callback = "is_multiplayer",
		name = "job_id_filter",
		filter = true,
		text_id = "menu_smm_job_id"
	}
	local data_node = {
		{
			value = -1,
			text_id = "menu_any",
			_meta = "option"
		},
		type = "MenuItemMultiChoice"
	}

	for index, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
		if not tweak_data.narrative.jobs[job_id].wrapped_to_job and tweak_data.narrative.jobs[job_id].contact ~= "wip" then
			local text_id, color_data = tweak_data.narrative:create_job_name(job_id)
			local params = {
				localize = false,
				_meta = "option",
				text_id = text_id,
				value = index
			}

			for count, color in ipairs(color_data) do
				params["color" .. count] = color.color
				params["color_start" .. count] = color.start
				params["color_stop" .. count] = color.stop
			end

			table.insert(data_node, params)
		end
	end

	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	local params = {
		size = 8,
		name = "divider_end",
		no_text = true
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 9966 to 9999
function MenuCallbackHandler:start_smart_matchmaking(item)
	if item:name() == "quick_join" then
		local jobs = managers.crimenet:get_jobs_by_player_stars()
		local random_job = jobs[math.random(#jobs)]

		print("[MenuCallbackHandler:start_smart_matchmaking] QUICK JOIN", "difficulty_filter", random_job.difficulty_id, "job_id_filter", random_job.job_id)
		managers.network.matchmake:join_by_smartmatch(-1, random_job.difficulty_id)
	else
		managers.menu:active_menu().logic:navigate_back(true)

		local job_data = item:parameters().gui_node.node:parameters().menu_component_data
		local difficulty_filter = job_data.difficulty_id
		local job_id_filter = job_data.job_id

		print("[MenuCallbackHandler:start_smart_matchmaking] SEARCH", "difficulty_filter", difficulty_filter, "job_id_filter", job_id_filter)
		managers.network.matchmake:join_by_smartmatch(job_id_filter, difficulty_filter)
	end
end

-- Lines: 10001 to 10005
function MenuCallbackHandler:open_contract_smart_matchmaking_node(item)
	local job_tweak = tweak_data.narrative:job_data(item:parameters().id)
	local is_professional = job_tweak and job_tweak.professional or false

	managers.menu:open_node("crimenet_join_smart_matchmaking", {{
		smart_matchmaking = true,
		job_id = item:parameters().id,
		difficulty = is_professional and "hard" or "normal",
		difficulty_id = is_professional and 3 or 2,
		professional = is_professional
	}})
end
MenuCrimeNetSmartMatchmakingInitiator = MenuCrimeNetSmartMatchmakingInitiator or class(MenuCrimeNetSpecialInitiator)
MenuCrimeNetSmartMatchmakingInitiator.job_callback = "open_contract_smart_matchmaking_node"
MenuCrimeNetSmartMatchmakingInitiator.choose_any_job = true
MenuCrimeNetSmartMatchmakingInitiator.contract_divider_id = "menu_cn_smart_matchmaking_divider_title"

-- Lines: 10014 to 10028
function MenuCrimeNetSmartMatchmakingInitiator:pre_create_clbk(node)
	local params = {
		callback = "start_smart_matchmaking",
		name = "quick_join",
		text_id = "menu_cn_quick_join"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	self:create_divider(node, "smart")
end
MenuOptionInitiator = MenuOptionInitiator or class()

-- Lines: 10031 to 10064
function MenuOptionInitiator:modify_node(node)
	local node_name = node:parameters().name

	if node_name == "resolution" then
		return self:modify_resolution(node)
	elseif node_name == "video" then
		return self:modify_video(node)
	elseif node_name == "adv_video" then
		return self:modify_adv_video(node)
	elseif node_name == "controls" then
		return self:modify_controls(node)
	elseif node_name == "debug" then
		return self:modify_debug_options(node)
	elseif node_name == "options" then
		return self:modify_options(node)
	elseif node_name == "network_options" then
		return self:modify_network_options(node)
	elseif node_name == "gameplay_options" then
		return self:modify_gameplay_options(node)
	elseif node_name == "user_interface_options" then
		return self:modify_user_interface_options(node)
	elseif node_name == "vr_options" then
		return self:modify_vr_options(node)
	end
end

-- Lines: 10066 to 10068
function MenuOptionInitiator:refresh_node(node)
	self:modify_node(node)
end

-- Lines: 10070 to 10076
function MenuOptionInitiator:modify_resolution(node)
	if SystemInfo:platform() == Idstring("WIN32") then
		local res_name = string.format("%d x %d", RenderSettings.resolution.x, RenderSettings.resolution.y)

		node:set_default_item_name(res_name)
	end

	return node
end

-- Lines: 10079 to 10169
function MenuOptionInitiator:modify_adv_video(node)
	node:item("toggle_vsync"):set_value(RenderSettings.v_sync and "on" or "off")

	if node:item("choose_streaks") then
		node:item("choose_streaks"):set_value(managers.user:get_setting("video_streaks") and "on" or "off")
	end

	if node:item("choose_light_adaption") then
		node:item("choose_light_adaption"):set_value(managers.user:get_setting("light_adaption") and "on" or "off")
	end

	if node:item("choose_anti_alias") then
		node:item("choose_anti_alias"):set_value(managers.user:get_setting("video_anti_alias"))
	end

	node:item("choose_anim_lod"):set_value(managers.user:get_setting("video_animation_lod"))
	node:item("use_lightfx"):set_value(managers.user:get_setting("use_lightfx") and "on" or "off")
	node:item("choose_texture_quality"):set_value(RenderSettings.texture_quality_default)
	node:item("choose_shadow_quality"):set_value(RenderSettings.shadow_quality_default)
	node:item("choose_anisotropic"):set_value(RenderSettings.max_anisotropy)

	if node:item("fov_multiplier") then
		node:item("fov_multiplier"):set_value(managers.user:get_setting("fov_multiplier"))
	end

	node:item("choose_gpu_flush"):set_value(managers.user:get_setting("flush_gpu_command_queue") and "on" or "off")
	node:item("choose_fps_cap"):set_value(managers.user:get_setting("fps_cap"))
	node:item("use_headbob"):set_value(managers.user:get_setting("use_headbob") and "on" or "off")
	node:item("max_streaming_chunk"):set_value(managers.user:get_setting("max_streaming_chunk"))

	if node:item("toggle_use_thq_weapon_parts") then
		node:item("toggle_use_thq_weapon_parts"):set_value(managers.user:get_setting("use_thq_weapon_parts") and "on" or "off")
	end

	local toggle_hide_huds = node:item("toggle_hide_huds") or node:item("toggle_hide_huds_xb1") or node:item("toggle_hide_huds_ps4")

	if toggle_hide_huds then
		toggle_hide_huds:set_value(Global.hud_disabled and "on" or "off")
	end

	local option_value = "off"
	local dof_setting_item = node:item("toggle_dof")

	if dof_setting_item then
		if managers.user:get_setting("dof_setting") ~= "none" then
			option_value = "on"
		end

		dof_setting_item:set_value(option_value)
	end

	option_value = "off"
	local chromatic_setting_item = node:item("toggle_chromatic")

	if chromatic_setting_item then
		if managers.user:get_setting("chromatic_setting") ~= "none" then
			option_value = "on"
		end

		chromatic_setting_item:set_value(option_value)
	end

	if node:item("choose_ao") then
		node:item("choose_ao"):set_value(managers.user:get_setting("video_ao"))
	end

	if node:item("toggle_parallax") then
		node:item("toggle_parallax"):set_value(managers.user:get_setting("parallax_mapping") and "on" or "off")
	end

	if node:item("choose_aa") then
		node:item("choose_aa"):set_value(managers.user:get_setting("video_aa"))
	end

	node:item("choose_corpse_limit"):set_value(managers.user:get_setting("corpse_limit"))

	local color_grading_item = node:item("choose_color_grading")

	if color_grading_item then
		if #color_grading_item:options() == 0 then
			for id, data in ipairs(tweak_data.color_grading) do
				local option = CoreMenuItemOption.ItemOption:new(data)

				color_grading_item:add_option(option)
			end
		end

		color_grading_item:set_value(managers.user:get_setting("video_color_grading"))
	end

	local toggle_adaptive_quality = node:item("toggle_adaptive_quality")

	if toggle_adaptive_quality then
		toggle_adaptive_quality:set_value(managers.user:get_setting("adaptive_quality") and "on" or "off")
	end

	return node
end

-- Lines: 10173 to 10253
function MenuOptionInitiator:modify_video(node)
	local adapter_item = node:item("choose_video_adapter")

	if adapter_item and adapter_item:visible() then
		adapter_item:clear_options()

		for i = 0, RenderSettings.adapter_count - 1, 1 do
			local option = CoreMenuItemOption.ItemOption:new({
				localize = false,
				_meta = "option",
				text_id = "" .. i + 1,
				value = i
			})

			adapter_item:add_option(option)
		end

		adapter_item:visible()
		adapter_item:set_value(RenderSettings.adapter_index)
		adapter_item:set_enabled(managers.viewport:is_fullscreen())
	end

	local option_value = "off"
	local fs_item = node:item("toggle_fullscreen")

	if fs_item then
		if managers.viewport:is_fullscreen() then
			option_value = "on"
		end

		fs_item:set_value(option_value)
	end

	option_value = "off"
	local st_item = node:item("toggle_subtitle")

	if st_item then
		if managers.user:get_setting("subtitle") then
			option_value = "on"
		end

		st_item:set_value(option_value)
	end

	option_value = "off"
	local hit_indicator_item = node:item("toggle_hit_indicator")

	if hit_indicator_item then
		if managers.user:get_setting("hit_indicator") then
			option_value = "on"
		end

		hit_indicator_item:set_value(option_value)
	end

	option_value = "off"
	local objective_reminder_item = node:item("toggle_objective_reminder")

	if objective_reminder_item then
		if managers.user:get_setting("objective_reminder") then
			option_value = "on"
		end

		objective_reminder_item:set_value(option_value)
	end

	local br_item = node:item("brightness")

	if br_item then
		br_item:set_min(_G.tweak_data.menu.MIN_BRIGHTNESS)
		br_item:set_max(_G.tweak_data.menu.MAX_BRIGHTNESS)
		br_item:set_step(_G.tweak_data.menu.BRIGHTNESS_CHANGE)

		option_value = managers.user:get_setting("brightness")

		br_item:set_value(option_value)
	end

	if node:item("fov_multiplier") then
		node:item("fov_multiplier"):set_value(managers.user:get_setting("fov_multiplier"))
	end

	local effect_quality_item = node:item("effect_quality")

	if effect_quality_item then
		option_value = managers.user:get_setting("effect_quality")

		effect_quality_item:set_value(option_value)
	end

	local toggle_hide_huds = node:item("toggle_hide_huds") or node:item("toggle_hide_huds_xb1") or node:item("toggle_hide_huds_ps4")

	if toggle_hide_huds then
		toggle_hide_huds:set_value(Global.hud_disabled and "on" or "off")
	end

	local toggle_window_zoom = node:item("toggle_window_zoom")

	if toggle_window_zoom then
		toggle_window_zoom:set_value(managers.user:get_setting("window_zoom") and "on" or "off")
	end

	return node
end

-- Lines: 10257 to 10416
function MenuOptionInitiator:modify_controls(node)
	local option_value = "off"
	local rumble_item = node:item("toggle_rumble")

	if rumble_item then
		if managers.user:get_setting("rumble") then
			option_value = "on"
		end

		rumble_item:set_value(option_value)
	end

	option_value = "off"
	local inv_cam_horizontally_item = node:item("toggle_invert_camera_horisontally")

	if inv_cam_horizontally_item then
		if managers.user:get_setting("invert_camera_x") then
			option_value = "on"
		end

		inv_cam_horizontally_item:set_value(option_value)
	end

	option_value = "off"
	local inv_cam_vertically_item = node:item("toggle_invert_camera_vertically")

	if inv_cam_vertically_item then
		if managers.user:get_setting("invert_camera_y") then
			option_value = "on"
		end

		inv_cam_vertically_item:set_value(option_value)
	end

	option_value = "off"
	local southpaw_item = node:item("toggle_southpaw")

	if southpaw_item then
		if managers.user:get_setting("southpaw") then
			option_value = "on"
		end

		southpaw_item:set_value(option_value)
	end

	option_value = "off"
	local hold_to_steelsight_item = node:item("toggle_hold_to_steelsight")

	if hold_to_steelsight_item then
		if managers.user:get_setting("hold_to_steelsight") then
			option_value = "on"
		end

		hold_to_steelsight_item:set_value(option_value)
	end

	option_value = "off"
	local hold_to_run_item = node:item("toggle_hold_to_run")

	if hold_to_run_item then
		if managers.user:get_setting("hold_to_run") then
			option_value = "on"
		end

		hold_to_run_item:set_value(option_value)
	end

	option_value = "off"
	local hold_to_duck_item = node:item("toggle_hold_to_duck")

	if hold_to_duck_item then
		if managers.user:get_setting("hold_to_duck") then
			option_value = "on"
		end

		hold_to_duck_item:set_value(option_value)
	end

	option_value = "off"
	local aim_assist_item = node:item("toggle_aim_assist")

	if aim_assist_item then
		if managers.user:get_setting("aim_assist") then
			option_value = "on"
		end

		aim_assist_item:set_value(option_value)
	end

	option_value = "off"
	local sticky_aim_item = node:item("toggle_sticky_aim")

	if sticky_aim_item then
		if managers.user:get_setting("sticky_aim") then
			option_value = "on"
		end

		sticky_aim_item:set_value(option_value)
	end

	local cs_item = node:item("camera_sensitivity")

	if cs_item then
		cs_item:set_min(tweak_data.player.camera.MIN_SENSITIVITY)
		cs_item:set_max(tweak_data.player.camera.MAX_SENSITIVITY)
		cs_item:set_step((tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 0.1)
		cs_item:set_value(managers.user:get_setting("camera_sensitivity"))
	end

	local cs_item = node:item("camera_sensitivity_horizontal")

	if cs_item then
		cs_item:set_min(tweak_data.player.camera.MIN_SENSITIVITY)
		cs_item:set_max(tweak_data.player.camera.MAX_SENSITIVITY)
		cs_item:set_step((tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 0.05)
		cs_item:set_value(managers.user:get_setting("camera_sensitivity_x"))
	end

	local cs_item = node:item("camera_sensitivity_vertical")

	if cs_item then
		cs_item:set_min(tweak_data.player.camera.MIN_SENSITIVITY)
		cs_item:set_max(tweak_data.player.camera.MAX_SENSITIVITY)
		cs_item:set_step((tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 0.05)
		cs_item:set_value(managers.user:get_setting("camera_sensitivity_y"))
	end

	local czs_item = node:item("camera_zoom_sensitivity")

	if czs_item then
		czs_item:set_min(tweak_data.player.camera.MIN_SENSITIVITY)
		czs_item:set_max(tweak_data.player.camera.MAX_SENSITIVITY)
		czs_item:set_step((tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 0.05)
		czs_item:set_value(managers.user:get_setting("camera_zoom_sensitivity"))
	end

	local czs_item = node:item("camera_zoom_sensitivity_horizontal")

	if czs_item then
		czs_item:set_min(tweak_data.player.camera.MIN_SENSITIVITY)
		czs_item:set_max(tweak_data.player.camera.MAX_SENSITIVITY)
		czs_item:set_step((tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 0.05)
		czs_item:set_value(managers.user:get_setting("camera_zoom_sensitivity_x"))
	end

	local czs_item = node:item("camera_zoom_sensitivity_vertical")

	if czs_item then
		czs_item:set_min(tweak_data.player.camera.MIN_SENSITIVITY)
		czs_item:set_max(tweak_data.player.camera.MAX_SENSITIVITY)
		czs_item:set_step((tweak_data.player.camera.MAX_SENSITIVITY - tweak_data.player.camera.MIN_SENSITIVITY) * 0.05)
		czs_item:set_value(managers.user:get_setting("camera_zoom_sensitivity_y"))
	end

	local cs_item = node:item("toggle_zoom_sensitivity")

	if cs_item then
		cs_item:set_value(managers.user:get_setting("enable_camera_zoom_sensitivity") and "on" or "off")
	end

	local cs_item = node:item("toggle_camera_sensitivity_separate")

	if cs_item then
		cs_item:set_value(managers.user:get_setting("enable_camera_sensitivity_separate") and "on" or "off")
	end

	local cs_item = node:item("toggle_fov_based_zoom")

	if cs_item then
		cs_item:set_value(managers.user:get_setting("enable_fov_based_sensitivity") and "on" or "off")
	end

	return node
end

-- Lines: 10421 to 10457
function MenuOptionInitiator:modify_gameplay_options(node)
	local option_value = "off"
	local throwable_contour = node:item("toggle_throwable_contour")

	if throwable_contour then
		if managers.user:get_setting("throwable_contour") then
			option_value = "on"
		end

		throwable_contour:set_value(option_value)
	end

	option_value = "off"
	local ammo_contour = node:item("toggle_ammo_contour")

	if ammo_contour then
		if managers.user:get_setting("ammo_contour") then
			option_value = "on"
		end

		ammo_contour:set_value(option_value)
	end

	local mute_heist_vo = node:item("toggle_mute_heist_vo")

	if mute_heist_vo then
		mute_heist_vo:set_value(managers.user:get_setting("mute_heist_vo") and "on" or "off")
	end

	return node
end

-- Lines: 10463 to 10484
function MenuOptionInitiator:modify_user_interface_options(node)
	local controller_hint_box = node:item("toggle_controller_hint")
	local controller_hint_setting = managers.user:get_setting("loading_screen_show_controller")

	if controller_hint_box then
		controller_hint_box:set_value(controller_hint_setting and "on" or "off")
	end

	local loading_hints_box = node:item("toggle_loading_hints")
	local loading_hints_setting = managers.user:get_setting("loading_screen_show_hints")

	if loading_hints_box then
		loading_hints_box:set_value(loading_hints_setting and "on" or "off")
	end

	local vr_descs_box = node:item("toggle_vr_descs")
	local vr_descs_setting = managers.user:get_setting("show_vr_descs")

	if vr_descs_box then
		vr_descs_box:set_value(vr_descs_setting and "on" or "off")
	end

	return node
end

-- Lines: 10606 to 10607
function MenuOptionInitiator:modify_debug_options(node)
	return node
end

-- Lines: 10614 to 10627
function MenuOptionInitiator:modify_options(node)
	if _G.IS_VR then
		node:set_default_item_name("video")
	else
		node:set_default_item_name("controls")
	end

	if node:item("toggle_workshop") then
		node:item("toggle_workshop"):set_value(managers.user:get_setting("workshop") and "on" or "off")
	end

	return node
end

-- Lines: 10632 to 10651
function MenuOptionInitiator:modify_network_options(node)
	local toggle_throttling_item = node:item("toggle_throttling")

	if toggle_throttling_item then
		local toggle_throttling_value = managers.user:get_setting("net_packet_throttling") and "on" or "off"

		toggle_throttling_item:set_value(toggle_throttling_value)
	end

	local toggle_net_forwarding_item = node:item("toggle_net_forwarding")

	if toggle_net_forwarding_item then
		local toggle_net_forwarding_value = managers.user:get_setting("net_forwarding") and "on" or "off"

		toggle_net_forwarding_item:set_value(toggle_net_forwarding_value)
	end

	local net_use_compression_item = node:item("toggle_net_use_compression")

	if net_use_compression_item then
		local net_use_compression_value = managers.user:get_setting("net_use_compression") and "on" or "off"

		net_use_compression_item:set_value(net_use_compression_value)
	end

	return node
end
SkillSwitchInitiator = SkillSwitchInitiator or class()

-- Lines: 10656 to 10698
function SkillSwitchInitiator:modify_node(node, data)
	node:clean_items()

	local hightlight_color, row_item_color, callback = nil

	self:create_divider(node, "title", "menu_st_skill_switch_title_name", nil, tweak_data.screen_colors.text)

	for skill_switch, data in ipairs(Global.skilltree_manager.skill_switches) do
		hightlight_color, row_item_color, callback = nil
		local unlocked = data.unlocked
		local can_unlock = managers.skilltree:can_unlock_skill_switch(skill_switch)

		if unlocked then
			if managers.skilltree:get_selected_skill_switch() == skill_switch then
				hightlight_color = tweak_data.screen_colors.text
				row_item_color = tweak_data.screen_colors.text
				callback = "menu_back"
			else
				hightlight_color = tweak_data.screen_colors.button_stage_2
				row_item_color = tweak_data.screen_colors.button_stage_3
				callback = "set_active_skill_switch"
			end
		elseif can_unlock then
			hightlight_color = tweak_data.screen_colors.button_stage_2
			row_item_color = tweak_data.screen_colors.button_stage_3
			callback = "unlock_skill_switch"
		else
			hightlight_color = tweak_data.screen_colors.important_1
			row_item_color = tweak_data.screen_colors.important_2
		end

		self:create_item(node, {
			localize = false,
			name = skill_switch,
			text_id = data.unlocked and managers.skilltree:get_skill_switch_name(skill_switch, true) or managers.localization:to_upper_text("menu_st_locked_skill_switch"),
			enabled = unlocked or can_unlock,
			disabled_color = row_item_color,
			callback = callback,
			hightlight_color = hightlight_color,
			row_item_color = row_item_color
		})
	end

	self:create_divider(node, "back_div")
	self:add_back_button(node)
	node:set_default_item_name(1)

	return node
end

-- Lines: 10701 to 10708
function SkillSwitchInitiator:refresh_node(node, data)
	local selected_item = node:selected_item() and node:selected_item():name()
	node = self:modify_node(node, data)

	if selected_item then
		node:select_item(selected_item)
	end

	return node
end

-- Lines: 10711 to 10717
function SkillSwitchInitiator:create_item(node, params)
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(params.enabled)
	node:add_item(new_item)
end

-- Lines: 10719 to 10733
function SkillSwitchInitiator:create_divider(node, id, text_id, size, color)
	local params = {
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 10735 to 10750
function SkillSwitchInitiator:add_back_button(node)
	node:delete_item("back")

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		text_id = "menu_back",
		align = "right",
		previous_node = true
	}
	local new_item = node:create_item(nil, params)

	node:add_item(new_item)
end

-- Lines: 10753 to 10784
function MenuCallbackHandler:unlock_skill_switch(item)
	local spending_cost = managers.money:get_unlock_skill_switch_spending_cost(item:parameters().name)
	local offshore_cost = managers.money:get_unlock_skill_switch_offshore_cost(item:parameters().name)
	local dialog_data = {title = managers.localization:text("dialog_unlock_skill_switch_title")}
	local cost_text = ""
	cost_text = spending_cost ~= 0 and offshore_cost ~= 0 and managers.localization:text("dialog_unlock_skill_switch_spending_offshore", {
		spending = managers.experience:cash_string(spending_cost),
		offshore = managers.experience:cash_string(offshore_cost)
	}) or spending_cost ~= 0 and managers.localization:text("dialog_unlock_skill_switch_spending", {spending = managers.experience:cash_string(spending_cost)}) or offshore_cost ~= 0 and managers.localization:text("dialog_unlock_skill_switch_offshore", {offshore = managers.experience:cash_string(offshore_cost)}) or managers.localization:text("dialog_unlock_skill_switch_free")
	dialog_data.text = managers.localization:text("dialog_unlock_skill_switch", {cost_text = cost_text})
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = function ()
			managers.skilltree:on_skill_switch_unlocked(item:parameters().name)
			self:refresh_node()
		end
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = function ()
			self:refresh_node()
		end,
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

-- Lines: 10786 to 10789
function MenuCallbackHandler:set_active_skill_switch(item)
	managers.skilltree:switch_skills(item:parameters().name)
	self:refresh_node()
end

-- Lines: 10794 to 10795
function MenuCallbackHandler:has_installed_mods()
	return not self:is_console() and table.size(DB:mods()) > 0
end
ModMenuCreator = ModMenuCreator or class()

-- Lines: 10799 to 10803
function ModMenuCreator:modify_node(original_node, data)
	local node = original_node

	self:create_mod_menu(node)

	return node
end

-- Lines: 10807 to 10862
function ModMenuCreator:create_mod_menu(node)
	node:clean_items()

	local sorted_mods = {}
	local mods = {}
	local conflicted_content = {}
	local modded_content = {}

	
	-- Lines: 10816 to 10817
	local function id_key(path)
		return Idstring(path):key()
	end

	for mod_name, mod_data in pairs(DB:mods()) do
		table.insert(sorted_mods, mod_name)

		mods[mod_name] = {
			content = {},
			conflicted = {}
		}

		for _, path in ipairs(mod_data.files or {}) do
			table.insert(mods[mod_name].content, path)

			modded_content[id_key(path)] = modded_content[id_key(path)] or {}

			table.insert(modded_content[id_key(path)], mod_name)

			if #modded_content[id_key(path)] == 2 then
				conflicted_content[id_key(path)] = modded_content[id_key(path)]
			end
		end

		table.sort(mods[mod_name].content)
	end

	for idk, conflicted_mods in pairs(conflicted_content) do
		for _, mod_name in ipairs(conflicted_mods) do
			mods[mod_name].conflicted[idk] = conflicted_mods
		end
	end

	table.sort(sorted_mods)

	local list_of_mods = {}
	local mod_item = nil

	for _, mod_name in ipairs(sorted_mods) do
		local conflicts = table.size(mods[mod_name].conflicted) > 0
		mod_item = self:create_item(node, {
			localize = false,
			enabled = true,
			name = mod_name,
			text_id = mod_name,
			hightlight_color = conflicts and tweak_data.screen_colors.important_1,
			row_item_color = conflicts and tweak_data.screen_colors.important_2
		})
	end

	self:add_back_button(node)

	node:parameters().mods = mods
	node:parameters().sorted_mods = sorted_mods
	node:parameters().conflicted_content = conflicted_content
	node:parameters().modded_content = modded_content
end

-- Lines: 10864 to 10878
function ModMenuCreator:create_divider(node, id, text_id, size, color)
	local params = {
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 10880 to 10886
function ModMenuCreator:create_item(node, params)
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(params.enabled)
	node:add_item(new_item)
end

-- Lines: 10888 to 10897
function ModMenuCreator:create_toggle(node, params)
	local data_node = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "MenuItemToggleWithIcon"
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_enabled(params.enabled)
	node:add_item(new_item)

	return new_item
end

-- Lines: 10900 to 10913
function ModMenuCreator:add_back_button(node)
	node:delete_item("back")

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		text_id = "menu_back",
		back = true,
		previous_node = true
	}
	local new_item = node:create_item(nil, params)

	node:add_item(new_item)
end

-- Lines: 10916 to 10917
function MenuCallbackHandler:save_mod_changes(node)
end

-- Lines: 10919 to 10925
function MenuCallbackHandler:mod_option_toggle_enabled(item)
	print("mod_option_toggle_enabled", "mod", item:name(), "status", item:value())

	local enabled = item:value() == "on"

	DB:set_mod_enabled(item:name(), enabled)
end
MenuCrimeNetChallengeInitiator = MenuCrimeNetChallengeInitiator or class(MenuCrimeNetGageAssignmentInitiator)

-- Lines: 10930 to 10953
function MenuCrimeNetChallengeInitiator:modify_node(original_node, data)
	local node, first_item = self:setup_node(original_node)

	if not managers.challenge:visited_crimenet() then
		node:set_default_item_name("_introduction")
		node:select_item("_introduction")
		managers.menu:active_menu().logic:trigger_item(false, node:item("_introduction"))
		managers.challenge:visit_crimenet()
	else
		node:set_default_item_name("_summary")
		node:select_item("_summary")
		managers.menu:active_menu().logic:trigger_item(false, node:item("_summary"))
	end

	return node
end

-- Lines: 10956 to 10973
function MenuCrimeNetChallengeInitiator:refresh_node(node)
	local _, first_item = self:setup_node(node)

	if not node:selected_item() or not node:item(node:selected_item():name()) then
		node:set_default_item_name("_summary")
		node:select_item("_summary")
		managers.menu:active_menu().logic:trigger_item(false, node:item("_summary"))
	end

	return node
end

-- Lines: 10976 to 10982
function MenuCallbackHandler:is_current_challenge(item)
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.get_contact_info then
		return active_node_gui:get_contact_info() == item:name() or managers.challenge:is_challenge_completed(item:name()) or managers.challenge:is_challenge_rewarded(item:name())
	end

	return false
end

-- Lines: 10985 to 11099
function MenuCrimeNetChallengeInitiator:setup_node(node)
	node:clean_items()
	self:create_divider(node, 1, managers.localization:text("menu_gage_assignment_div_menu"), nil, tweak_data.screen_colors.text)
	self:create_item(node, {
		id = "_introduction",
		name_localized = managers.localization:text("menu_challenge_introduction_title")
	})
	self:create_item(node, {
		id = "_summary",
		name_localized = managers.localization:text("menu_challenge_summary_title")
	})
	self:create_divider(node, 2)

	local first_item = nil

	if not managers.challenge:is_retrieving() and managers.challenge:is_validated() then
		local challenges = {}
		local categories = {}
		local category = nil
		local current_timestamp = managers.challenge:get_timestamp()
		local timestamp, interval, expire_timestamp, expire_time = nil

		for assignment, data in pairs(managers.challenge:get_all_active_challenges()) do
			timestamp = data.timestamp
			interval = data.interval
			expire_timestamp = interval + timestamp
			expire_time = expire_timestamp - current_timestamp

			if expire_time >= 0 then
				category = data.category or "daily"

				table.insert(categories, category)

				challenges[category] = challenges[category] or {}

				table.insert(challenges[category], data)
			end
		end

		categories = table.list_union(categories)

		table.sort(categories, function (x, y)
			return challenges[x][1].interval < challenges[y][1].interval
		end)

		local node_data = nil
		local selected_item = node:selected_item() and node:selected_item():name()

		for _, category in ipairs(categories) do
			self:create_divider(node, category, managers.localization:text("menu_challenge_div_cat_" .. category), nil, tweak_data.screen_colors.text)

			node_data = {}
			local hightlight_color, row_item_color, marker_color, icon, icon_rotation, icon_visible_callback = nil

			for assignment, challenge in ipairs(challenges[category]) do
				hightlight_color = challenge.rewarded and tweak_data.screen_colors.text:with_alpha(0.5) or challenge.completed and tweak_data.screen_colors.challenge_completed_color
				row_item_color = challenge.rewarded and tweak_data.screen_colors.text:with_alpha(0.5) or challenge.completed and tweak_data.screen_colors.challenge_completed_color
				marker_color = challenge.rewarded and tweak_data.screen_colors.text:with_alpha(0.5) or challenge.completed and tweak_data.screen_colors.challenge_completed_color:with_alpha(0.15)
				icon = selected_item ~= challenge.id and (challenge.rewarded and "guis/textures/menu_singletick" or challenge.completed and "guis/textures/pd2/icon_reward") or nil
				icon_rotation = selected_item ~= challenge.id and (challenge.rewarded and 360 or challenge.completed and 360) or nil
				icon_visible_callback = "is_current_challenge"

				table.insert(node_data, {
					name_localized = challenge.name_s or managers.localization:text(challenge.name_id),
					interval = challenge.interval,
					id = challenge.id,
					completed = challenge.completed,
					hightlight_color = hightlight_color,
					row_item_color = row_item_color,
					marker_color = marker_color,
					icon = icon,
					icon_rotation = icon_rotation,
					icon_visible_callback = icon_visible_callback
				})
			end

			table.sort(node_data, function (x, y)
				if x.completed ~= y.completed then
					return x.completed
				end

				if x.interval ~= y.interval then
					return x.interval < y.interval
				end

				return x.name_localized < y.name_localized
			end)

			for assignment, data in ipairs(node_data) do
				self:create_item(node, data)

				first_item = first_item or data.id
			end
		end
	else
		self:create_divider(node, "retrieving", managers.localization:text("menu_challenge_still_retrieving"), nil, tweak_data.screen_colors.text)
	end

	local params = {
		visible_callback = "is_pc_controller",
		name = "back",
		pd2_corner = "true",
		text_id = "menu_back",
		gui_node_custom = "true",
		align = "left",
		last_item = "true",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	first_item = first_item or "back"

	return node, first_item
end

-- Lines: 11102 to 11117
function MenuCallbackHandler:update_challenge_menu_node()
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	if managers.menu:active_menu().logic:selected_node():parameters().name ~= "crimenet_contract_challenge" then
		return false
	end

	MenuCallbackHandler:refresh_node()
end

-- Lines: 11119 to 11141
function MenuCallbackHandler:give_challenge_reward(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	local id = item:parameters().name
	local rewards = managers.challenge:on_give_rewards(id)

	if rewards then
		managers.menu:active_menu().logic:refresh_node()

		for _, reward in ipairs(rewards) do
			if reward.choose_weapon_reward then
				managers.menu:open_node("choose_weapon_reward")
			end
		end
	end
end
MenuChooseWeaponRewardInitiator = MenuChooseWeaponRewardInitiator or class()

-- Lines: 11145 to 11270
function MenuChooseWeaponRewardInitiator:modify_node(original_node, data)
	local node = original_node

	if data and data.reward_data then
		node:parameters().reward_data = data.reward_data
	end

	local all_dlc_data = Global.dlc_manager.all_dlc_data
	local weapon_tweak = tweak_data.weapon
	local x_id, y_id, x_level, y_level, x_unlocked, y_unlocked, x_skill, y_skill, x_gv, y_gv, x_sn, y_sn = nil
	local primaries = managers.blackmarket:get_weapon_category("primaries")
	local secondaries = managers.blackmarket:get_weapon_category("secondaries")
	local items = {}

	
	-- Lines: 11168 to 11169
	local function chk_unlocked_func(weapon)
		return not not weapon.unlocked
	end

	
	-- Lines: 11172 to 11179
	local function chk_dlc_func(weapon)
		x_id = weapon.weapon_id
		x_gv = weapon_tweak[x_id].global_value

		if all_dlc_data[x_gv] and all_dlc_data[x_gv].app_id and not managers.dlc:is_dlc_unlocked(x_gv) then
			return false
		end

		return true
	end

	
	-- Lines: 11182 to 11184
	local function chk_dropable_func(weapon)
		local loot_table = managers.blackmarket:get_lootdropable_mods_by_weapon_id(weapon.weapon_id, nil, true)

		return loot_table and #loot_table > 0 or false
	end

	
	-- Lines: 11187 to 11188
	local function chk_parent_func(weapon)
		return weapon_tweak[weapon.weapon_id] and not weapon_tweak[weapon.weapon_id].parent_weapon_id
	end

	local loot_table, data = nil

	for i, category_data in ipairs({
		primaries,
		secondaries
	}) do
		for _, weapon_data in ipairs(category_data) do
			if chk_dlc_func(weapon_data) and chk_parent_func(weapon_data) then
				loot_table = managers.blackmarket:get_lootdropable_mods_by_weapon_id(weapon_data.weapon_id, nil, true)

				if #loot_table > 0 then
					data = deep_clone(weapon_data)
					data.loot_table = loot_table

					for _, category in ipairs(weapon_tweak[weapon_data.weapon_id].categories) do
						category = tweak_data.gui.buy_weapon_category_groups[category] or category
						items[category] = items[category] or {}

						table.insert(items[category], data)
					end
				end
			end
		end
	end

	
	-- Lines: 11212 to 11246
	local function sort_func(x, y)
		x_unlocked = x.unlocked
		y_unlocked = y.unlocked

		if x_unlocked ~= y_unlocked then
			return x_unlocked
		end

		x_id = x.weapon_id
		y_id = y.weapon_id
		x_gv = weapon_tweak[x_id].global_value
		y_gv = weapon_tweak[y_id].global_value
		x_sn = x_gv and tweak_data.lootdrop.global_values[x_gv].sort_number or 0
		y_sn = y_gv and tweak_data.lootdrop.global_values[y_gv].sort_number or 0

		if x_sn ~= y_sn then
			return x_sn < y_sn
		end

		x_skill = x.skill_based
		y_skill = y.skill_based

		if x_skill ~= y_skill then
			return y_skill
		end

		x_level = x.level or 0
		y_level = y.level or 0

		if x_level ~= y_level then
			return x_level < y_level
		end

		return x_id < y_id
	end

	local category_list = {}

	for category, data in pairs(items) do
		table.sort(data, sort_func)
		table.insert(category_list, category)
	end

	table.sort(category_list)

	node:parameters().first_weapons = {}

	for index, category in ipairs(category_list) do
		node:parameters().first_weapons[category] = items[category][1].weapon_id
	end

	node:parameters().category_list = category_list
	node:parameters().weapon_items = items
	node = self:setup_node(node)

	node:set_default_item_name("choose_weapon_category")
	node:select_item("choose_weapon_category")

	return node
end

-- Lines: 11273 to 11275
function MenuChooseWeaponRewardInitiator:refresh_node(node)
	self:setup_node(node)

	return node
end

-- Lines: 11278 to 11430
function MenuChooseWeaponRewardInitiator:setup_node(node)
	local listed_category = node:parameters().listed_category or "assault_rifle"
	local listed_weapon = node:parameters().listed_weapon or "amcar"
	local listed_global_value = node:parameters().listed_global_value or "all"
	node:parameters().listed_global_value = listed_global_value
	node:parameters().listed_weapon = listed_weapon
	node:parameters().listed_category = listed_category
	node:parameters().block_back = true
	node:parameters().clicked_category = false

	node:clean_items()

	if not node:item("divider_end") then
		local category_list = node:parameters().category_list
		local items = node:parameters().weapon_items
		local params = {
			callback = "choice_challenge_choose_weapon_category",
			name = "choose_weapon_category",
			text_id = "menu_challenge_choose_weapon_category",
			text_offset = 75,
			filter = true
		}
		local data_node = {type = "MenuItemMultiChoice"}

		table.insert(data_node, {
			text_id = "",
			no_text = true,
			localize = false,
			_meta = "option",
			value = category_list[#category_list] .. "#"
		})

		for index, category in ipairs(category_list) do
			table.insert(data_node, {
				localize = false,
				_meta = "option",
				text_id = managers.localization:to_upper_text("menu_" .. category),
				value = category
			})

			node:parameters().first_weapons[category] = items[category][1].weapon_id
		end

		table.insert(data_node, {
			text_id = "",
			no_text = true,
			localize = false,
			_meta = "option",
			value = category_list[1] .. "#"
		})

		local new_item = node:create_item(data_node, params)

		new_item:set_value(listed_category)
		node:add_item(new_item)

		local current_weapon_data = nil
		local params = {
			callback = "choice_challenge_choose_weapon",
			name = "choose_weapon",
			text_id = "menu_challenge_choose_weapon",
			text_offset = 75,
			filter = true
		}
		local data_node = {type = "MenuItemMultiChoice"}

		table.insert(data_node, {
			text_id = "",
			no_text = true,
			localize = false,
			_meta = "option",
			value = items[listed_category][#items[listed_category]].weapon_id .. "#"
		})

		for index, weapon_data in ipairs(items[listed_category]) do
			table.insert(data_node, {
				localize = false,
				_meta = "option",
				text_id = managers.weapon_factory:get_weapon_name_by_weapon_id(weapon_data.weapon_id),
				value = weapon_data.weapon_id
			})

			if weapon_data.weapon_id == listed_weapon then
				current_weapon_data = weapon_data
			end
		end

		table.insert(data_node, {
			text_id = "",
			no_text = true,
			localize = false,
			_meta = "option",
			value = items[listed_category][1].weapon_id .. "#"
		})

		local new_item = node:create_item(data_node, params)

		new_item:set_value(listed_weapon)
		node:add_item(new_item)

		local weapon_data = current_weapon_data or {}
		local global_values = {}

		for _, data in pairs(weapon_data.loot_table or {}) do
			table.insert(global_values, data[2])
		end

		global_values = table.list_union(global_values)
		local x_sn, y_sn = nil

		
		-- Lines: 11358 to 11372
		local function sort_func(x, y)
			if x == "normal" then
				return true
			elseif y == "normal" then
				return false
			end

			x_sn = tweak_data.lootdrop.global_values[x].sort_number or 0
			y_sn = tweak_data.lootdrop.global_values[y].sort_number or 0

			if x_sn ~= y_sn then
				return x_sn < y_sn
			end

			return x < y
		end

		table.sort(global_values, sort_func)

		local params = {
			callback = "choice_challenge_choose_global_value",
			name = "choose_global_value",
			text_id = "menu_challenge_choose_global_value",
			text_offset = 75,
			filter = true
		}
		local data_node = {type = "MenuItemMultiChoice"}

		if #global_values > 1 then
			table.insert(data_node, {
				text_id = "",
				no_text = true,
				localize = false,
				_meta = "option",
				value = global_values[#global_values] .. "#"
			})
		end

		local gv_all_text_id = #global_values == 1 and tweak_data:get_raw_value("lootdrop", "global_values", global_values[1], "name_id") or "menu_challenge_global_value_all"

		table.insert(data_node, {
			value = "all",
			localize = false,
			_meta = "option",
			text_id = managers.localization:text(gv_all_text_id)
		})

		if #global_values > 1 then
			for index, global_value in ipairs(global_values) do
				table.insert(data_node, {
					localize = false,
					_meta = "option",
					text_id = managers.localization:text(tweak_data:get_raw_value("lootdrop", "global_values", global_value, "name_id")),
					value = global_value
				})
			end

			table.insert(data_node, {
				text_id = "",
				no_text = true,
				localize = false,
				_meta = "option",
				value = "all#"
			})
		end

		node:parameters().listed_global_value = table.contains(global_values, listed_global_value) and listed_global_value or "all"
		listed_global_value = node:parameters().listed_global_value
		local new_item = node:create_item(data_node, params)

		new_item:set_value(listed_global_value)
		node:add_item(new_item)
		self:create_divider(node, "divider_end", nil, 32)

		local params = {
			callback = "choice_challenge_get_weapon_mod_reward",
			name = "get_weapon_mod_reward",
			halign = "right",
			text_id = "menu_challenge_get_weapon_mod_reward",
			align = "right",
			filter = true
		}
		local data_node = {}
		local new_item = node:create_item(data_node, params)

		node:add_item(new_item)
	end

	return node
end

-- Lines: 11434 to 11450
function MenuChooseWeaponRewardInitiator:create_divider(node, id, text_id, size, color, align)
	local params = {
		name = "divider_" .. id,
		no_text = not text_id,
		text_id = text_id,
		size = size or 8,
		color = color,
		halign = align,
		align = align
	}
	local data_node = {type = "MenuItemDivider"}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
end

-- Lines: 11452 to 11473
function MenuCallbackHandler:choice_challenge_choose_weapon_category(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local node = managers.menu:active_menu().logic:selected_node()
	node:parameters().listed_category = string.gsub(item:value(), "#", "")

	if string.find(item:value(), "#") then
		item:set_value(string.gsub(item:value(), "#", ""))
	end

	node:parameters().clicked_category = true
	node:parameters().listed_weapon = node:parameters().first_weapons[item:value()]

	MenuCallbackHandler:refresh_node()
end

-- Lines: 11475 to 11494
function MenuCallbackHandler:choice_challenge_choose_weapon(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	if managers.menu:active_menu().logic:selected_node():parameters().clicked_category then
		return false
	end

	managers.menu:active_menu().logic:selected_node():parameters().listed_weapon = string.gsub(item:value(), "#", "")

	if string.find(item:value(), "#") then
		item:set_value(string.gsub(item:value(), "#", ""))
	end

	MenuCallbackHandler:refresh_node()
end

-- Lines: 11496 to 11516
function MenuCallbackHandler:choice_challenge_choose_global_value(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	if managers.menu:active_menu().logic:selected_node():parameters().clicked_category then
		return false
	end

	managers.menu:active_menu().logic:selected_node():parameters().listed_global_value = string.gsub(item:value(), "#", "")

	if string.find(item:value(), "#") then
		item:set_value(string.gsub(item:value(), "#", ""))
	end

	MenuCallbackHandler:refresh_node()
end

-- Lines: 11518 to 11555
function MenuCallbackHandler:choice_challenge_get_weapon_mod_reward(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local reward = {}
	local params = managers.menu:active_menu().logic:selected_node():parameters()

	if params.listed_weapon then
		if params.reward_data then
			print("managers.challenge:set_as_rewarded", unpack(params.reward_data))
			managers.challenge:set_as_rewarded(unpack(params.reward_data))
		end

		local weapon_id = managers.menu:active_menu().logic:selected_node():parameters().listed_weapon
		local global_value = managers.menu:active_menu().logic:selected_node():parameters().listed_global_value
		local entry = MenuCallbackHandler:roll_challenge_give_weapon_mod(weapon_id, global_value)
		managers.menu:active_menu().logic:selected_node():parameters().listed_weapon = nil

		if entry then
			reward.amount = 1
			reward.item_entry = entry[1]
			reward.type_items = "weapon_mods"
		end
	end

	managers.menu:active_menu().logic:selected_node():parameters().block_back = false

	managers.menu:back()
	managers.menu:show_challenge_reward(reward)
end

-- Lines: 11557 to 11569
function MenuCallbackHandler:roll_challenge_give_weapon_mod(weapon_id, global_value)
	local loot_table, limited_loot_table = managers.blackmarket:get_lootdropable_mods_by_weapon_id(weapon_id, global_value, true)
	local my_loot_table = #limited_loot_table > 0 and limited_loot_table or loot_table

	if #my_loot_table > 0 then
		local entry = my_loot_table[math.random(#my_loot_table)]

		managers.blackmarket:add_to_inventory(entry[2] or "normal", "weapon_mods", entry[1])
		print("[MenuCallbackHandler:roll_challenge_give_weapon_mod] Drop", entry[2] or "normal", "weapon_mods", entry[1])

		return entry
	end
end
MenuCustomizeGadgetInitiator = MenuCustomizeGadgetInitiator or class(MenuCrimeNetSpecialInitiator)

-- Lines: 11575 to 11577
function MenuCustomizeGadgetInitiator:modify_node(original_node, data)
	local node = original_node

	return self:setup_node(node, data)
end

-- Lines: 11581 to 11733
function MenuCustomizeGadgetInitiator:setup_node(node, data)
	node:clean_items()

	data = data or node:parameters().menu_component_data
	local part_id = data.name
	local slot = data.slot
	local category = data.category
	local mod_td = tweak_data.weapon.factory.parts[part_id]
	local show_laser = mod_td.sub_type == "laser"
	local show_flashlight = mod_td.sub_type == "flashlight"

	if mod_td.adds then
		for _, part_id in ipairs(mod_td.adds) do
			local sub_type = tweak_data.weapon.factory.parts[part_id].sub_type
			show_laser = sub_type == "laser" or false
			show_flashlight = sub_type == "flashlight" or false
		end
	end

	if not node:item("divider_end") then
		if show_laser then
			self:create_slider(node, {
				max = 360,
				name = "laser_hue",
				min = 0,
				callback = "set_gadget_laser_hue",
				step = 5,
				text_id = "bm_menu_laser_hue",
				show_value = true
			})
			self:create_slider(node, {
				min = 0,
				name = "laser_sat",
				max = 1,
				callback = "set_gadget_laser_sat",
				step = 0.02,
				text_id = "bm_menu_laser_sat",
				default_value = 1,
				show_value = true
			})
			self:create_slider(node, {
				name = "laser_val",
				max = 1,
				callback = "set_gadget_laser_val",
				step = 0.02,
				text_id = "bm_menu_laser_val",
				default_value = 1,
				show_value = true,
				min = tweak_data.custom_colors.defaults.laser_alpha
			})
			self:create_divider(node, "laser_divider", nil, 64)
		end

		if show_flashlight then
			self:create_slider(node, {
				max = 360,
				name = "flashlight_hue",
				min = 0,
				callback = "set_gadget_flashlight_hue",
				step = 5,
				text_id = "bm_menu_flashlight_hue",
				show_value = true
			})
			self:create_slider(node, {
				min = 0,
				name = "flashlight_sat",
				max = 1,
				callback = "set_gadget_flashlight_sat",
				step = 0.02,
				text_id = "bm_menu_flashlight_sat",
				default_value = 1,
				show_value = true
			})
			self:create_slider(node, {
				min = 0,
				name = "flashlight_val",
				max = 1,
				callback = "set_gadget_flashlight_val",
				step = 0.02,
				text_id = "bm_menu_flashlight_val",
				default_value = 1,
				show_value = true
			})
			self:create_divider(node, "flashlight_divider", nil, 64)
		end
	end

	local enabled = false
	local params = {
		callback = "set_gadget_customize_params",
		name = "confirm",
		text_id = "dialog_apply",
		align = "right",
		enabled = enabled,
		disabled_color = tweak_data.screen_colors.important_1
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	local params = {
		last_item = "true",
		name = "back",
		text_id = "dialog_cancel",
		align = "right",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	if show_laser then
		node:set_default_item_name("laser_hue")
		node:select_item("laser_hue")
	elseif show_flashlight then
		node:set_default_item_name("flashlight_hue")
		node:select_item("flashlight_hue")
	end

	node:parameters().menu_component_data = data
	node:parameters().set_blackmarket_enabled = false
	local l_hue = node:item("laser_hue")
	local l_sat = node:item("laser_sat")
	local l_val = node:item("laser_val")
	local f_hue = node:item("flashlight_hue")
	local f_sat = node:item("flashlight_sat")
	local f_val = node:item("flashlight_val")
	local part_id = data.name
	local colors = managers.blackmarket:get_part_custom_colors(data.category, data.slot, data.name)

	if colors and colors.laser and l_hue and l_sat and l_val then
		local h, s, v = rgb_to_hsv(colors.laser.r, colors.laser.g, colors.laser.b)

		l_hue:set_value(h)
		l_sat:set_value(s)
		l_val:set_value(v)
	end

	if colors and colors.flashlight and f_hue and f_sat and f_val then
		local h, s, v = rgb_to_hsv(colors.flashlight.r, colors.flashlight.g, colors.flashlight.b)

		f_hue:set_value(h)
		f_sat:set_value(s)
		f_val:set_value(v)
	end

	return node
end

-- Lines: 11737 to 11746
function MenuCustomizeGadgetInitiator:refresh_node(node, data)
	local confirm = node:item("confirm")
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.update_item_dlc_locks then
		local enabled = active_node_gui:update_item_dlc_locks()

		confirm:set_enabled(enabled)
	end
end

-- Lines: 11748 to 11762
function MenuCustomizeGadgetInitiator:create_slider(node, params)
	local data_node = {
		type = "CoreMenuItemSlider.ItemSlider",
		show_value = params.show_value,
		min = params.min,
		max = params.max,
		step = params.step,
		show_value = params.show_value
	}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	if params.default_value ~= nil then
		new_item:set_value(params.default_value)
	end

	return new_item
end

-- Lines: 11765 to 11767
function MenuCallbackHandler:set_gadget_laser_hue()
	self:update_gadget_customization()
end

-- Lines: 11769 to 11771
function MenuCallbackHandler:set_gadget_laser_sat()
	self:update_gadget_customization()
end

-- Lines: 11773 to 11775
function MenuCallbackHandler:set_gadget_laser_val()
	self:update_gadget_customization()
end

-- Lines: 11777 to 11779
function MenuCallbackHandler:set_gadget_flashlight_hue()
	self:update_gadget_customization()
end

-- Lines: 11781 to 11783
function MenuCallbackHandler:set_gadget_flashlight_sat()
	self:update_gadget_customization()
end

-- Lines: 11785 to 11787
function MenuCallbackHandler:set_gadget_flashlight_val()
	self:update_gadget_customization()
end

-- Lines: 11789 to 11808
function MenuCallbackHandler:update_gadget_customization(item)
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local node = managers.menu:active_menu().logic:selected_node()
	local data = node:parameters().menu_component_data
	local part_id = data.name
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.update_node_colors then
		active_node_gui:update_node_colors()
	end
end

-- Lines: 11810 to 11835
function MenuCallbackHandler:set_gadget_customize_params()
	if not managers.menu:active_menu() then
		return false
	end

	if not managers.menu:active_menu().logic then
		return false
	end

	if not managers.menu:active_menu().logic:selected_node() then
		return false
	end

	local node = managers.menu:active_menu().logic:selected_node()
	local data = node:parameters().menu_component_data
	local part_id = data.name
	local slot = data.slot
	local category = data.category
	local colors = {}
	local active_node_gui = managers.menu:active_menu().renderer:active_node_gui()

	if active_node_gui and active_node_gui.update_node_colors then
		colors = active_node_gui:update_node_colors()
	end

	managers.blackmarket:set_part_custom_colors(category, slot, part_id, colors)
	managers.menu:back()
end

if _G.IS_VR then
	require("lib/managers/MenuManagerVR")
end

