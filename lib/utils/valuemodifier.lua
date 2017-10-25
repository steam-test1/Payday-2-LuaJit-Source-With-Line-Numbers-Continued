ValueModifier = ValueModifier or class()

-- Lines: 5 to 7
function ValueModifier:init()
	self._modifiers = {}
end

-- Lines: 9 to 14
function ValueModifier:add_modifier(type, callback)
	local key = {}
	local modifiers = self._modifiers[type] or {}
	self._modifiers[type] = modifiers
	modifiers[key] = callback

	return key
end

-- Lines: 17 to 25
function ValueModifier:remove_modifier(type, key)
	local modifiers = self._modifiers[type] or {}

	if not modifiers then
		return
	end

	modifiers[key] = nil
end

-- Lines: 27 to 37
function ValueModifier:modify_value(type, base_value, ...)
	local modifiers = self._modifiers[type]
	local new_value = base_value

	if modifiers then
		for _, callback in pairs(modifiers) do
			new_value = new_value + (callback(base_value, ...) or 0)
		end
	end

	return new_value
end

