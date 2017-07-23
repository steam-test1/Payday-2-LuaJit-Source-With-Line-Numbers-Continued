core:module("SystemMenuManager")
require("lib/managers/dialogs/DeleteFileDialog")

PS3DeleteFileDialog = PS3DeleteFileDialog or class(DeleteFileDialog)

-- Lines: 7 to 14
function PS3DeleteFileDialog:show()
	self._manager:event_dialog_shown(self)
	self:done_callback(true)

	return true
end

