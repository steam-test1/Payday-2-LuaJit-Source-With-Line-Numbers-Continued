core:module("CoreFreeFlightModifier")

FreeFlightModifier = FreeFlightModifier or class()

-- Lines: 5 to 10
function FreeFlightModifier:init(name, values, index, callback)
	self._name = assert(name)
	self._values = assert(values)
	self._index = assert(index)
	self._callback = callback
end

-- Lines: 12 to 17
function FreeFlightModifier:step_up()
	self._index = math.clamp(self._index + 1, 1, #self._values)

	if self._callback then
		self._callback(self:value())
	end
end

-- Lines: 19 to 24
function FreeFlightModifier:step_down()
	self._index = math.clamp(self._index - 1, 1, #self._values)

	if self._callback then
		self._callback(self:value())
	end
end

-- Lines: 26 to 27
function FreeFlightModifier:name_value()
	return string.format("%10.10s %7.2f", self._name, self._values[self._index])
end

-- Lines: 30 to 31
function FreeFlightModifier:value()
	return self._values[self._index]
end

