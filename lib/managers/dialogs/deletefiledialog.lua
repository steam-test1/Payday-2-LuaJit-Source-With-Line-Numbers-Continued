core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

DeleteFileDialog = DeleteFileDialog or class(BaseDialog)

-- Lines: 8 to 14
function DeleteFileDialog:done_callback(success)
	if self._data.callback_func then
		self._data.callback_func(success)
	end

	self:fade_out_close()
end

