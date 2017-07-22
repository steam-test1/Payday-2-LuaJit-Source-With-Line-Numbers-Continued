core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")

KeyboardInputDialog = KeyboardInputDialog or class(BaseDialog)

-- Lines: 8 to 9
function KeyboardInputDialog:title()
	return self._data.title or ""
end

-- Lines: 12 to 13
function KeyboardInputDialog:text()
	return self._data.text or ""
end

-- Lines: 16 to 17
function KeyboardInputDialog:input_text()
	return self._data.input_text
end

-- Lines: 20 to 21
function KeyboardInputDialog:input_type()
	return self._data.input_type or "default"
end

-- Lines: 24 to 25
function KeyboardInputDialog:max_count()
	return self._data.max_count
end

-- Lines: 28 to 29
function KeyboardInputDialog:filter()
	return self._data.filter
end

-- Lines: 32 to 38
function KeyboardInputDialog:done_callback(success, input_text)
	if self._data.callback_func then
		self._data.callback_func(success, input_text)
	end

	self:fade_out_close()
end

-- Lines: 40 to 42
function KeyboardInputDialog:to_string()
	return string.format("%s, Title: %s, Text: %s, Input text: %s, Max count: %s, Filter: %s", tostring(BaseDialog.to_string(self)), tostring(self._data.title), tostring(self._data.text), tostring(self._data.input_text), tostring(self._data.max_count), tostring(self._data.filter))
end

return
