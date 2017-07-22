TemporaryPropertyManager = TemporaryPropertyManager or class()

-- Lines: 6 to 8
function TemporaryPropertyManager:init()
	self._properties = {}
end

-- Lines: 10 to 12
function TemporaryPropertyManager:activate_property(prop, time, value)
	self._properties[prop] = {
		value,
		Application:time() + time
	}
end

-- Lines: 14 to 21
function TemporaryPropertyManager:get_property(prop, default)
	local time = Application:time()

	if self._properties[prop] and time <= self._properties[prop][2] then
		return self._properties[prop][1]
	elseif self._properties[prop] then
		self._properties[prop] = nil
	end

	return default
end

-- Lines: 24 to 31
function TemporaryPropertyManager:add_to_property(prop, time, value)
	if not self:has_active_property(prop) then
		self:activate_property(prop, time, value)
	else
		self._properties[prop][1] = self._properties[prop][1] + value
		self._properties[prop][2] = self._properties[prop][2] + time
	end
end

-- Lines: 33 to 39
function TemporaryPropertyManager:mul_to_property(prop, time, value)
	if not self:has_active_property(prop) then
		self:activate_property(prop, time, value)
	else
		self._properties[prop][1] = self._properties[prop][1] * value
	end
end

-- Lines: 41 to 45
function TemporaryPropertyManager:set_time(prop, time)
	if self:has_active_property(prop) then
		self._properties[prop][2] = Application:time() + time
	end
end

-- Lines: 47 to 57
function TemporaryPropertyManager:has_active_property(prop)
	local time = Application:time()

	if self._properties[prop] then
		-- Nothing
	end

	if self._properties[prop] and time <= self._properties[prop][2] then
		return true
	elseif self._properties[prop] then
		self._properties[prop] = nil
	end

	return false
end

-- Lines: 60 to 64
function TemporaryPropertyManager:remove_property(prop)
	if self._properties[prop] then
		self._properties[prop] = nil
	end
end

return
