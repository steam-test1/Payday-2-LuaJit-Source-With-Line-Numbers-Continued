PropertyManager = PropertyManager or class()

-- Lines 6-8
function PropertyManager:init()
	self._properties = {}
end

-- Lines 10-16
function PropertyManager:add_to_property(prop, value)
	if not self._properties[prop] then
		self._properties[prop] = value
	else
		self._properties[prop] = self._properties[prop] + value
	end
end

-- Lines 18-24
function PropertyManager:mul_to_property(prop, value)
	if not self._properties[prop] then
		self._properties[prop] = value
	else
		self._properties[prop] = self._properties[prop] * value
	end
end

-- Lines 26-28
function PropertyManager:set_property(prop, value)
	self._properties[prop] = value
end

-- Lines 30-35
function PropertyManager:get_property(prop, default)
	if self._properties[prop] then
		return self._properties[prop]
	end

	return default
end

-- Lines 37-42
function PropertyManager:has_property(prop)
	if self._properties[prop] then
		return true
	end

	return false
end

-- Lines 44-48
function PropertyManager:remove_property(prop)
	if self._properties[prop] then
		self._properties[prop] = nil
	end
end
