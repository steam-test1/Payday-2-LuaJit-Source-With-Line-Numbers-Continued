core:module("SystemMenuManager")
core:import("CoreDebug")

BaseDialog = BaseDialog or class()

-- Lines 8-16
function BaseDialog:init(manager, data)
	self._manager = manager
	self._data = data or {}
end

-- Lines 18-20
function BaseDialog:id()
	return self._data.id
end

-- Lines 22-24
function BaseDialog:priority()
	return self._data.priority or 0
end

-- Lines 26-28
function BaseDialog:get_platform_id()
	return managers.user:get_platform_id(self._data.user_index) or 0
end

-- Lines 30-32
function BaseDialog:is_generic()
	return self._data.is_generic
end

-- Lines 34-35
function BaseDialog:fade_in()
end

-- Lines 37-39
function BaseDialog:fade_out_close()
	self:close()
end

-- Lines 41-43
function BaseDialog:fade_out()
	self:close()
end

-- Lines 45-46
function BaseDialog:force_close()
end

-- Lines 48-50
function BaseDialog:close()
	self._manager:event_dialog_closed(self)
end

-- Lines 52-54
function BaseDialog:is_closing()
	return false
end

-- Lines 56-59
function BaseDialog:show()
	Application:error("[SystemMenuManager] Unable to display dialog since the logic for it hasn't been implemented.")

	return false
end

-- Lines 61-63
function BaseDialog:_get_ws()
	return self._ws
end

-- Lines 65-67
function BaseDialog:_get_controller()
	return self._controller
end

-- Lines 69-71
function BaseDialog:to_string()
	return string.format("Class: %s, Id: %s, User index: %s", CoreDebug.class_name(getmetatable(self), _M), tostring(self._data.id), tostring(self._data.user_index))
end

-- Lines 73-75
function BaseDialog:blocks_exec()
	return true
end
