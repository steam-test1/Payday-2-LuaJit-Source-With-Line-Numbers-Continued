core:module("SystemMenuManager")
core:import("CoreDebug")

BaseDialog = BaseDialog or class()

-- Lines: 8 to 16
function BaseDialog:init(manager, data)
	self._manager = manager
	self._data = data or {}
end

-- Lines: 18 to 19
function BaseDialog:id()
	return self._data.id
end

-- Lines: 22 to 23
function BaseDialog:priority()
	return self._data.priority or 0
end

-- Lines: 26 to 27
function BaseDialog:get_platform_id()
	return managers.user:get_platform_id(self._data.user_index) or 0
end

-- Lines: 30 to 31
function BaseDialog:is_generic()
	return self._data.is_generic
end

-- Lines: 34 to 35
function BaseDialog:fade_in()
end

-- Lines: 37 to 39
function BaseDialog:fade_out_close()
	self:close()
end

-- Lines: 41 to 43
function BaseDialog:fade_out()
	self:close()
end

-- Lines: 45 to 46
function BaseDialog:force_close()
end

-- Lines: 48 to 50
function BaseDialog:close()
	self._manager:event_dialog_closed(self)
end

-- Lines: 52 to 53
function BaseDialog:is_closing()
	return false
end

-- Lines: 56 to 58
function BaseDialog:show()
	Application:error("[SystemMenuManager] Unable to display dialog since the logic for it hasn't been implemented.")

	return false
end

-- Lines: 61 to 62
function BaseDialog:_get_ws()
	return self._ws
end

-- Lines: 65 to 66
function BaseDialog:_get_controller()
	return self._controller
end

-- Lines: 69 to 70
function BaseDialog:to_string()
	return string.format("Class: %s, Id: %s, User index: %s", CoreDebug.class_name(getmetatable(self), _M), tostring(self._data.id), tostring(self._data.user_index))
end

-- Lines: 73 to 74
function BaseDialog:blocks_exec()
	return true
end

