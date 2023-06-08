require("lib/states/GameState")
require("lib/utils/gui/Blackborders")
require("lib/utils/accelbyte/Telemetry")
require("lib/utils/accelbyte/LoginEntitlement")

local base64 = require("lib/utils/base64")
local json = require("lib/utils/accelbyte/json")
MenuTitlescreenState = MenuTitlescreenState or class(GameState)

-- Lines 11-22
function MenuTitlescreenState:init(game_state_machine, setup)
	GameState.init(self, "menu_titlescreen", game_state_machine)

	if setup then
		self:setup()
	end
end

local is_ps3 = SystemInfo:platform() == Idstring("PS3")
local is_ps4 = SystemInfo:platform() == Idstring("PS4")
local is_xb1 = SystemInfo:platform() == Idstring("XB1")
local is_x360 = SystemInfo:platform() == Idstring("X360")
local is_win32 = SystemInfo:platform() == Idstring("WIN32")
local is_steam = SystemInfo:distribution() == Idstring("STEAM")
local is_epic = SystemInfo:distribution() == Idstring("EPIC")
local is_mm_eos = SystemInfo:matchmaking() == Idstring("MM_EPIC")

-- Lines 32-83
function MenuTitlescreenState:setup()
	local res = RenderSettings.resolution
	self._workspace = managers.gui_data:create_saferect_workspace()

	self._workspace:hide()
	managers.gui_data:layout_workspace(self._workspace)

	self._full_workspace = managers.gui_data:create_fullscreen_workspace()

	self._full_workspace:hide()
	BlackBorders:new(self._full_workspace:panel())

	local bitmap = self._workspace:panel():bitmap({
		texture = "guis/textures/menu_title_screen",
		layer = 1
	})

	bitmap:set_center(self._workspace:panel():w() / 2, self._workspace:panel():h() / 2)
	self._full_workspace:panel():rect({
		layer = 0,
		visible = false,
		color = Color.black
	})

	local text_id = (is_ps3 or is_x360 or is_ps4 or is_xb1) and "menu_press_start" or "menu_visit_forum3"
	local text = self._workspace:panel():text({
		vertical = "bottom",
		align = "center",
		layer = 2,
		text = managers.localization:text(text_id),
		font = tweak_data.menu.pd2_large_font,
		font_size = tweak_data.menu.topic_font_size,
		color = Color.white,
		w = self._workspace:panel():w(),
		h = self._workspace:panel():h()
	})
	self._text = text

	text:set_bottom(self._workspace:panel():h() / 1.25)

	self._controller_list = {}

	for index = 1, managers.controller:get_wrapper_count() do
		self._controller_list[index] = managers.controller:create_controller("title_" .. index, index, false)

		if is_win32 and self._controller_list[index]:get_type() == "xbox360" then
			self._controller_list[index]:add_connect_changed_callback(callback(self, self, "_update_pc_xbox_controller_connection", {
				text_gui = text,
				text_id = text_id
			}))
		end
	end

	if is_win32 then
		self:_update_pc_xbox_controller_connection({
			text_gui = text,
			text_id = text_id
		})
	end

	self:reset_attract_video()
end

-- Lines 85-98
function MenuTitlescreenState:_update_pc_xbox_controller_connection(params)
	local text_string = managers.localization:to_upper_text(params.text_id)
	local added_text = nil

	for _, controller in pairs(self._controller_list) do
		if controller:get_type() == "xbox360" and controller:connected() then
			text_string = text_string .. "\n" .. managers.localization:to_upper_text("menu_or_press_any_xbox_button")

			break
		end
	end

	params.text_gui:set_text(text_string)
end

-- Lines 100-147
function MenuTitlescreenState:at_enter()
	if not self._controller_list then
		self:setup()
		Application:stack_dump_error("Shouldn't enter title more than once. Except when toggling freeflight.")
	end

	managers.menu:input_enabled(false)

	for index, controller in ipairs(self._controller_list) do
		controller:enable()
	end

	managers.overlay_effect:play_effect({
		sustain = 0.1,
		fade_in = 0,
		blend_mode = "normal",
		fade_out = 0.4,
		color = Color.black
	})
	managers.menu_scene:setup_camera()

	if _G.IS_VR then
		managers.menu_scene:set_scene_template("title")
	else
		managers.menu_scene:set_scene_template("lobby")
	end

	self._workspace:show()
	self._full_workspace:show()
	managers.user:set_index(nil)
	managers.controller:set_default_wrapper_index(nil)

	self._clbk_game_has_music_control_callback = callback(self, self, "clbk_game_has_music_control")

	managers.platform:add_event_callback("media_player_control", self._clbk_game_has_music_control_callback)

	if is_epic and EpicMM:logged_on() then
		print("[ABC] Epic logged on before titlescreen, checking ownership")
		managers.dlc:check_ownerships()

		self._wait_on_dlcs = true
	end

	self:reset_attract_video()
end

-- Lines 149-151
function MenuTitlescreenState:get_video_volume()
	return (managers.user:get_setting("sfx_volume") or 100) / 100
end

-- Lines 153-157
function MenuTitlescreenState:clbk_game_has_music_control(status)
	if alive(self._attract_video_gui) then
		self._attract_video_gui:set_volume_gain(status and self:get_video_volume() or 0)
	end
end

-- Lines 160-258
function MenuTitlescreenState:update(t, dt)
	if self._waiting_for_loaded_savegames then
		if is_mm_eos and self._waiting_on_connection == nil and not EpicMM:logged_on() then
			self._waiting_on_connection = 10

			self._text:set_text(managers.localization:to_upper_text("menu_connect_eos"))

			return
		end

		if is_mm_eos and self._waiting_on_connection and EpicMM:logged_on() then
			self._waiting_on_connection = nil
		end

		if self._waiting_on_connection and self._waiting_on_connection ~= true then
			self._waiting_on_connection = self._waiting_on_connection - dt

			if self._waiting_on_connection < 0 then
				self._waiting_on_connection = true

				managers.menu:show_eos_no_connect_dialog({
					play_offline_func = function ()
						self._waiting_on_connection = false
					end,
					quit_func = function ()
						_G.setup:quit()
					end,
					wait_func = function ()
						self._waiting_on_connection = nil
					end
				})

				return
			end
		end

		if not managers.savefile:is_in_loading_sequence() and not self._user_has_changed and not self._waiting_on_connection then
			self._text:hide()
			self:_load_savegames_done()
			Telemetry:on_login()
			Telemetry:on_login_screen_passed()
			Entitlement:CheckAndVerifyUserEntitlement()
		end

		return
	else
		self._user_has_changed = nil
	end

	self:check_confirm_pressed()

	if managers.system_menu:is_active() then
		self:reset_attract_video()
	else
		self._controller_index = self:get_start_pressed_controller_index()

		if self._controller_index then
			if is_xb1 then
				local controller_wrapper = self._controller_list[self._controller_index]
				local xb1_ctrl = controller_wrapper:get_controller_map().xb1pad
				local xuid = xb1_ctrl:user_xuid()

				managers.controller:set_default_wrapper_index(self._controller_index)
				managers.user:set_index(xuid)
			else
				managers.controller:set_default_wrapper_index(self._controller_index)
				managers.user:set_index(self._controller_index)
			end

			managers.user:check_user(callback(self, self, "check_user_callback"), true)

			if managers.dlc:has_corrupt_data() and not Global.corrupt_dlc_msg_shown then
				Global.corrupt_dlc_msg_shown = true

				print("[MenuTitlescreenState:update] showing corrupt_DLC")
				managers.menu:show_corrupt_dlc()
			end

			if is_epic and not EpicMM:logged_on() then
				self._text:set_text(managers.localization:to_upper_text("menu_connect_eos"))
			end
		elseif not self:check_attract_video() and self:is_attract_video_delay_done() then
			self:play_attract_video()
		end
	end
end

-- Lines 260-299
function MenuTitlescreenState:get_start_pressed_controller_index()
	if _G.IS_VR then
		for index, controller in ipairs(self._controller_list) do
			if controller._default_controller_id == "vr" and controller:get_any_input_pressed() then
				return index
			end
		end

		return nil
	end

	for index, controller in ipairs(self._controller_list) do
		if is_ps4 or is_xb1 then
			if controller:get_input_pressed("confirm") then
				return index
			end
		elseif is_ps3 or is_x360 then
			if controller:get_input_pressed("start") then
				return index
			end
		else
			if controller:get_any_input_pressed() then
				return index
			end

			if controller._default_controller_id == "keyboard" and (#Input:keyboard():pressed_list() > 0 or #Input:mouse():pressed_list() > 0) then
				return index
			end
		end
	end

	return nil
end

-- Lines 301-308
function MenuTitlescreenState:get_first_keyboard_controller_index()
	for index, controller in ipairs(self._controller_list) do
		if controller._default_controller_id == "keyboard" then
			return index
		end
	end

	return nil
end

-- Lines 310-334
function MenuTitlescreenState:check_confirm_pressed()
	for index, controller in ipairs(self._controller_list) do
		if controller:get_input_pressed("confirm") then
			print("check_confirm_pressed")

			local active, dialog = managers.system_menu:is_active_by_id("invite_join_message")

			if active then
				print("close")
				dialog:button_pressed_callback()
			end

			local active, dialog = managers.system_menu:is_active_by_id("user_changed")

			if active then
				print("close user_changed")
				dialog:button_pressed_callback()
			end

			local active, dialog = managers.system_menu:is_active_by_id("inactive_user_accepted_invite")

			if active then
				print("close inactive_user_accepted_invite")
				dialog:button_pressed_callback()
			end
		end
	end
end

-- Lines 336-357
function MenuTitlescreenState:check_user_callback(success)
	managers.dlc:on_signin_complete()

	if success then
		managers.user:check_storage(callback(self, self, "check_storage_callback"), true)
	else
		local dialog_data = {
			title = managers.localization:text("dialog_warning_title"),
			text = managers.localization:text("dialog_skip_signin_warning")
		}
		local yes_button = {
			text = managers.localization:text("dialog_yes"),
			callback_func = callback(self, self, "continue_without_saving_yes_callback")
		}
		local no_button = {
			text = managers.localization:text("dialog_no"),
			callback_func = callback(self, self, "continue_without_saving_no_callback")
		}
		dialog_data.button_list = {
			yes_button,
			no_button
		}

		managers.system_menu:show(dialog_data)
	end
end

-- Lines 359-383
function MenuTitlescreenState:check_storage_callback(success)
	if success then
		self._waiting_for_loaded_savegames = true
	else
		local dialog_data = {
			title = managers.localization:text("dialog_warning_title"),
			text = managers.localization:text("dialog_skip_storage_warning")
		}
		local yes_button = {
			text = managers.localization:text("dialog_yes"),
			callback_func = callback(self, self, "continue_without_saving_yes_callback")
		}
		local no_button = {
			text = managers.localization:text("dialog_no"),
			callback_func = callback(self, self, "continue_without_saving_no_callback")
		}
		dialog_data.button_list = {
			yes_button,
			no_button
		}

		managers.system_menu:show(dialog_data)
	end
end

-- Lines 385-389
function MenuTitlescreenState:_load_savegames_done()
	local sound_source = SoundDevice:create_source("MenuTitleScreen")

	sound_source:post_event("menu_enter")
	self:gsm():change_state_by_name("menu_main")
end

-- Lines 391-394
function MenuTitlescreenState:continue_without_saving_yes_callback()
	self:gsm():change_state_by_name("menu_main")
end

-- Lines 396-399
function MenuTitlescreenState:continue_without_saving_no_callback()
	managers.user:set_index(nil)
	managers.controller:set_default_wrapper_index(nil)
end

-- Lines 401-413
function MenuTitlescreenState:check_attract_video()
	if alive(self._attract_video_gui) then
		if self._attract_video_gui:loop_count() > 0 or self:is_any_input_pressed() then
			self:reset_attract_video()
		else
			return true
		end
	elseif self:is_any_input_pressed() then
		self:reset_attract_video()
	end

	return false
end

-- Lines 415-423
function MenuTitlescreenState:is_any_input_pressed()
	for _, controller in ipairs(self._controller_list) do
		if controller:get_any_input_pressed() then
			return true
		end
	end

	return false
end

-- Lines 425-433
function MenuTitlescreenState:reset_attract_video()
	self._attract_video_time = TimerManager:main():time()

	if alive(self._attract_video_gui) then
		self._attract_video_gui:stop()
		self._full_workspace:panel():remove(self._attract_video_gui)

		self._attract_video_gui = nil
	end
end

-- Lines 435-437
function MenuTitlescreenState:is_attract_video_delay_done()
	return TimerManager:main():time() > self._attract_video_time + _G.tweak_data.states.title.ATTRACT_VIDEO_DELAY
end

-- Lines 439-461
function MenuTitlescreenState:play_attract_video()
	self:reset_attract_video()

	local screen_width = self._full_workspace:width()
	local screen_height = self._full_workspace:height()
	local src_width, src_height = managers.gui_data:get_base_res()
	local dest_width, dest_height = nil

	if src_width / src_height > screen_width / screen_height then
		dest_width = screen_width
		dest_height = src_height * dest_width / src_width
	else
		dest_height = screen_height
		dest_width = src_width * dest_height / src_height
	end

	local x = (screen_width - dest_width) / 2
	local y = (screen_height - dest_height) / 2
	self._attract_video_gui = self._full_workspace:panel():video({
		video = "movies/attract",
		x = x,
		y = y,
		width = dest_width,
		height = dest_height,
		layer = tweak_data.gui.ATTRACT_SCREEN_LAYER
	})

	self._attract_video_gui:play()
	self._attract_video_gui:set_volume_gain(managers.music:has_music_control() and self:get_video_volume() or 0)
end

-- Lines 463-495
function MenuTitlescreenState:at_exit()
	managers.platform:remove_event_callback("media_player_control", self._clbk_game_has_music_control_callback)
	setup:add_end_frame_callback(function ()
		if alive(self._workspace) then
			managers.gui_data:destroy_workspace(self._workspace)

			self._workspace = nil
		end

		if alive(self._full_workspace) then
			managers.gui_data:destroy_workspace(self._full_workspace)

			self._full_workspace = nil
		end
	end)

	if self._controller_list then
		for _, controller in ipairs(self._controller_list) do
			controller:destroy()
		end

		self._controller_list = nil
	end

	managers.menu:input_enabled(true)
	managers.user:set_active_user_state_change_quit(true)
	managers.system_menu:init_finalize()
end

-- Lines 497-504
function MenuTitlescreenState:on_user_changed(old_user_data, user_data)
	print("MenuTitlescreenState:on_user_changed")

	if old_user_data and old_user_data.signin_state ~= "not_signed_in" and self._waiting_for_loaded_savegames then
		self._user_has_changed = true
	end
end

-- Lines 506-511
function MenuTitlescreenState:on_storage_changed(old_user_data, user_data)
	print("MenuTitlescreenState:on_storage_changed")

	if self._waiting_for_loaded_savegames then
		self._waiting_for_loaded_savegames = nil
	end
end
