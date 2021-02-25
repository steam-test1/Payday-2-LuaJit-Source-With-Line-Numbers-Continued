core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

FriendsDialog = FriendsDialog or class(BaseDialog)

-- Lines 8-14
function FriendsDialog:done_callback()
	if self._data.callback_func then
		self._data.callback_func()
	end

	self:fade_out_close()
end
