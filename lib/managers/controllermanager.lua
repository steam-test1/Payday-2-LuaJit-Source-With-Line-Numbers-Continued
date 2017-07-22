core:module("ControllerManager")
core:import("CoreControllerManager")
core:import("CoreClass")

ControllerManager = ControllerManager or class(CoreControllerManager.ControllerManager)

-- Lines: 8 to 18
function ControllerManager:init(path, default_settings_path)
	default_settings_path = "settings/controller_settings"
	path = default_settings_path
	self._menu_mode_enabled = 0

	ControllerManager.super.init(self, path, default_settings_path)
end

-- Lines: 20 to 24
function ControllerManager:update(t, dt)
	ControllerManager.super.update(self, t, dt)
	self:_poll_reconnected_controller()
end

-- Lines: 26 to 45
function ControllerManager:_poll_reconnected_controller()
	if SystemInfo:platform() == Idstring("XB1") and Global.controller_manager.connect_controller_dialog_visible then
		local active_xuid = XboxLive:current_user()
		local nr_controllers = Input:num_controllers()

		for i_controller = 0, nr_controllers - 1, 1 do
			local controller = Input:controller(i_controller)

			if controller:type() == "xb1_controller" and (controller:down(12) or controller:pressed(12)) and controller:user_xuid() == active_xuid then
				self:_close_controller_changed_dialog()
				self:replace_active_controller(i_controller, controller)
			end
		end
	end
end

-- Lines: 47 to 52
function ControllerManager:controller_mod_changed()
	if not Global.controller_manager.user_mod then
		Global.controller_manager.user_mod = managers.user:get_setting("controller_mod")

		self:load_user_mod()
	end
end

-- Lines: 54 to 64
function ControllerManager:set_user_mod(connection_name, params)
	Global.controller_manager.user_mod = Global.controller_manager.user_mod or {}

	if params.axis then
		Global.controller_manager.user_mod[connection_name] = Global.controller_manager.user_mod[connection_name] or {axis = params.axis}
		Global.controller_manager.user_mod[connection_name][params.button] = params
	else
		Global.controller_manager.user_mod[connection_name] = params
	end

	managers.user:set_setting("controller_mod_type", managers.controller:get_default_wrapper_type())
	managers.user:set_setting("controller_mod", Global.controller_manager.user_mod, true)
end

-- Lines: 66 to 78
function ControllerManager:clear_user_mod(category, CONTROLS_INFO)
	Global.controller_manager.user_mod = Global.controller_manager.user_mod or {}
	local names = table.map_keys(Global.controller_manager.user_mod)

	for _, name in ipairs(names) do
		if CONTROLS_INFO[name] and CONTROLS_INFO[name].category == category then
			Global.controller_manager.user_mod[name] = nil
		end
	end

	managers.user:set_setting("controller_mod_type", managers.controller:get_default_wrapper_type())
	managers.user:set_setting("controller_mod", Global.controller_manager.user_mod, true)
	self:load_user_mod()
end

-- Lines: 80 to 99
function ControllerManager:load_user_mod()
	if Global.controller_manager.user_mod then
		local connections = managers.controller:get_settings(managers.user:get_setting("controller_mod_type")):get_connection_map()

		for connection_name, params in pairs(Global.controller_manager.user_mod) do
			if params.axis and connections[params.axis] then
				for button, button_params in pairs(params) do
					if type(button_params) == "table" and button_params.button and connections[params.axis]._btn_connections[button_params.button] then
						connections[params.axis]._btn_connections[button_params.button].name = button_params.connection
					end
				end
			elseif params.button and connections[params.button] then
				connections[params.button]:set_controller_id(params.controller_id)
				connections[params.button]:set_input_name_list({params.connection})
			end
		end

		self:rebind_connections()
	end
end

-- Lines: 101 to 107
function ControllerManager:init_finalize()
	managers.user:add_setting_changed_callback("controller_mod", callback(self, self, "controller_mod_changed"), true)

	if Global.controller_manager.user_mod then
		self:load_user_mod()
	end

	self:_check_dialog()
end

-- Lines: 109 to 124
function ControllerManager:default_controller_connect_change(connected)
	ControllerManager.super.default_controller_connect_change(self, connected)

	if Global.controller_manager.default_wrapper_index and not connected and not self:_controller_changed_dialog_active() then
		self:_show_controller_changed_dialog()
	end
end

-- Lines: 127 to 131
function ControllerManager:_check_dialog()
	if Global.controller_manager.connect_controller_dialog_visible and not self:_controller_changed_dialog_active() then
		self:_show_controller_changed_dialog()
	end
end

-- Lines: 133 to 134
function ControllerManager:_controller_changed_dialog_active()
	return managers.system_menu:is_active_by_id("connect_controller_dialog") and true or false
end

-- Lines: 138 to 159
function ControllerManager:_show_controller_changed_dialog()
	if self:_controller_changed_dialog_active() then
		return
	end

	Global.controller_manager.connect_controller_dialog_visible = true
	local data = {
		callback_func = callback(self, self, "connect_controller_dialog_callback"),
		title = managers.localization:text("dialog_connect_controller_title"),
		text = managers.localization:text("dialog_connect_controller_text", {NR = Global.controller_manager.default_wrapper_index or 1})
	}

	if SystemInfo:platform() == Idstring("XB1") then
		data.no_buttons = true
	else
		data.button_list = {{text = managers.localization:text("dialog_ok")}}
	end

	data.id = "connect_controller_dialog"
	data.force = true

	managers.system_menu:show(data)
end

-- Lines: 161 to 166
function ControllerManager:_change_mode(mode)
	self:change_default_wrapper_mode(mode)
end

-- Lines: 168 to 182
function ControllerManager:set_menu_mode_enabled(enabled)
	if SystemInfo:platform() == Idstring("WIN32") then
		self._menu_mode_enabled = self._menu_mode_enabled or 0
		self._menu_mode_enabled = self._menu_mode_enabled + (enabled and 1 or -1)

		if self:get_menu_mode_enabled() then
			self:_change_mode("menu")
		else
			self:set_ingame_mode()
		end

		if self._menu_mode_enabled < 0 then
			Application:error("[ControllerManager:set_menu_mode_enabled] Controller menu mode counter reached negative refs!")
		end
	end
end

-- Lines: 184 to 185
function ControllerManager:get_menu_mode_enabled()
	return self._menu_mode_enabled and self._menu_mode_enabled > 0
end

-- Lines: 188 to 198
function ControllerManager:set_ingame_mode(mode)
	if SystemInfo:platform() == Idstring("WIN32") and not self:get_menu_mode_enabled() then
		self:_change_mode(self._ingame_mode)
	end
end

-- Lines: 209 to 215
function ControllerManager:_close_controller_changed_dialog(hard)
	if Global.controller_manager.connect_controller_dialog_visible or self:_controller_changed_dialog_active() then
		print("[ControllerManager:_close_controller_changed_dialog] closing")
		managers.system_menu:close("connect_controller_dialog", hard)
		self:connect_controller_dialog_callback()
	end
end

-- Lines: 219 to 226
function ControllerManager:connect_controller_dialog_callback()
	Global.controller_manager.connect_controller_dialog_visible = nil
end

-- Lines: 228 to 242
function ControllerManager:get_mouse_controller()
	local index = Global.controller_manager.default_wrapper_index or self:get_preferred_default_wrapper_index()
	local wrapper_class = self._wrapper_class_map and self._wrapper_class_map[index]

	if wrapper_class and wrapper_class.TYPE == "steam" then
		local controller_index = self._wrapper_to_controller_list[index][1]
		local controller = Input:controller(controller_index)
		local index = Global.controller_manager.default_wrapper_index or self:get_preferred_default_wrapper_index()
		local wrapper_class = self._wrapper_class_map[index]

		return controller
	end

	return Input:mouse()
end

CoreClass.override_class(CoreControllerManager.ControllerManager, ControllerManager)

return
