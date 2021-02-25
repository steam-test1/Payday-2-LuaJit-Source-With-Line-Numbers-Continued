core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

SelectStorageDialog = SelectStorageDialog or class(BaseDialog)

-- Lines 8-10
function SelectStorageDialog:content_type()
	return self._data.content_type or 1
end

-- Lines 12-14
function SelectStorageDialog:min_bytes()
	return self._data.min_bytes or 0
end

-- Lines 16-18
function SelectStorageDialog:auto_select()
	return self._data.auto_select
end

-- Lines 20-26
function SelectStorageDialog:done_callback(success, result)
	if self._data.callback_func then
		self._data.callback_func(success, result)
	end

	self:fade_out_close()
end

-- Lines 28-31
function SelectStorageDialog:to_string()
	return string.format("%s, Content type: %s, Min bytes: %s, Auto select: %s", tostring(BaseDialog.to_string(self)), tostring(self._data.content_type), tostring(self._data.min_bytes), tostring(self._data.auto_select))
end
