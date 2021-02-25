core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

PlayerDialog = PlayerDialog or class(BaseDialog)

-- Lines 8-14
function PlayerDialog:done_callback()
	if self._data.callback_func then
		self._data.callback_func()
	end

	self:fade_out_close()
end

-- Lines 16-18
function PlayerDialog:player_id()
	return self._data.player_id
end

-- Lines 20-23
function PlayerDialog:to_string()
	return string.format("%s, Player id: %s", tostring(BaseDialog.to_string(self)), tostring(self._data.player_id))
end
