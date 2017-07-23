core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

MarketplaceDialog = MarketplaceDialog or class(BaseDialog)

-- Lines: 8 to 14
function MarketplaceDialog:done_callback()
	if self._data.callback_func then
		self._data.callback_func()
	end

	self:fade_out_close()
end

-- Lines: 16 to 17
function MarketplaceDialog:item_type()
	return self._data.item_type
end

-- Lines: 20 to 21
function MarketplaceDialog:item_id()
	return self._data.item_id
end

-- Lines: 24 to 26
function MarketplaceDialog:to_string()
	return string.format("%s, Item type: %s, Item id: %s", tostring(BaseDialog.to_string(self)), tostring(self._data.item_type), tostring(self._data.item_id))
end

