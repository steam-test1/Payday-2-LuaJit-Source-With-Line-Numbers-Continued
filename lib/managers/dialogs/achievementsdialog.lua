core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

AchievementsDialog = AchievementsDialog or class(BaseDialog)

-- Lines: 8 to 14
function AchievementsDialog:done_callback()
	if self._data.callback_func then
		self._data.callback_func()
	end

	self:fade_out_close()
end

return
