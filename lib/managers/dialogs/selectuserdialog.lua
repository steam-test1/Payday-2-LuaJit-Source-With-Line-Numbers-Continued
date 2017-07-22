core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

SelectUserDialog = SelectUserDialog or class(BaseDialog)

-- Lines: 8 to 9
function SelectUserDialog:count()
	return self._data.count or 1
end

-- Lines: 12 to 18
function SelectUserDialog:done_callback()
	if self._data.callback_func then
		self._data.callback_func()
	end

	self:fade_out_close()
end

-- Lines: 20 to 22
function SelectUserDialog:to_string()
	return string.format("%s, Count: %s", tostring(BaseDialog.to_string(self)), tostring(self._data.count))
end

return
