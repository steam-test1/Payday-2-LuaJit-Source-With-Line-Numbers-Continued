core:module("CoreLocalizationManager")
core:import("CoreClass")
core:import("CoreEvent")

LocalizationManager = LocalizationManager or CoreClass.class()

-- Lines: 66 to 86
function LocalizationManager:init()
	Localizer:set_post_processor(CoreEvent.callback(self, self, "_localizer_post_process"))

	self._default_macros = {}

	self:set_default_macro("NL", "\n")
	self:set_default_macro("EMPTY", "")

	local platform_id = SystemInfo:platform()

	if platform_id == Idstring("X360") then
		self._platform = "X360"
	elseif platform_id == Idstring("PS3") then
		self._platform = "PS3"
	elseif platform_id == Idstring("XB1") then
		self._platform = "X360"
	elseif platform_id == Idstring("PS4") then
		self._platform = "PS3"
	else
		self._platform = "WIN32"
	end
end

-- Lines: 94 to 96
function LocalizationManager:add_default_macro(macro, value)
	self:set_default_macro(macro, value)
end

-- Lines: 110 to 116
function LocalizationManager:set_default_macro(macro, value)
	if not self._default_macros then
		self._default_macros = {}
	end

	self._default_macros[macro] = tostring(value)
end

-- Lines: 118 to 119
function LocalizationManager:get_default_macro(macro)
	return self._default_macros[macro]
end

-- Lines: 134 to 135
function LocalizationManager:exists(string_id)
	return Localizer:exists(Idstring(string_id))
end

-- Lines: 160 to 178
function LocalizationManager:text(string_id, macros)
	local return_string = "ERROR: " .. string_id
	local str_id = nil

	if not string_id or string_id == "" then
		return_string = ""
	elseif self:exists(string_id .. "_" .. self._platform) then
		str_id = string_id .. "_" .. self._platform
	elseif self:exists(string_id) then
		str_id = string_id
	end

	if str_id then
		self._macro_context = macros
		return_string = Localizer:lookup(Idstring(str_id))
		self._macro_context = nil
	end

	return return_string
end

-- Lines: 182 to 183
function LocalizationManager:format_text(text_string)
	return self:_localizer_post_process(self:_text_localize(text_string, "@", ";"))
end

-- Lines: 196 to 222
function LocalizationManager:_localizer_post_process(string)
	local localized_string = string
	local macros = {}

	if type(self._macro_context) ~= "table" then
		self._macro_context = {}
	end

	for k, v in pairs(self._default_macros) do
		macros[k] = v
	end

	for k, v in pairs(self._macro_context) do
		macros[k] = tostring(v)
	end

	if self._pre_process_func then
		self._pre_process_func(macros)
	end

	return self:_text_macroize(localized_string, macros)
end

-- Lines: 225 to 227
function LocalizationManager:_text_localize(text)

	-- Lines: 225 to 226
	local function func(id)
		return self:exists(id) and self:text(id) or false
	end

	return self:_text_format(text, "@", ";", func)
end

-- Lines: 230 to 232
function LocalizationManager:_text_macroize(text, macros)

	-- Lines: 230 to 231
	local function func(word)
		return macros[word] or false
	end

	return self:_text_format(text, "$", ";", func)
end

-- Lines: 235 to 245
function LocalizationManager:_text_format(text, X, Y, func)
	local match_string = "%b" .. X .. Y

	return string.gsub(text, match_string, function (word)
		local id = string.sub(word, 2, -2)
		local value = func(id)

		if value then
			return value
		end

		return X .. self:_text_format(id, X, Y, func) .. Y
	end)
end

return
