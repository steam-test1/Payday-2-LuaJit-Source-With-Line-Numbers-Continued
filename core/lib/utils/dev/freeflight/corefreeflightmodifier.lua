core:module("CoreFreeFlightModifier")

FreeFlightModifier = FreeFlightModifier or class()

-- Lines 5-10
function FreeFlightModifier:init(name, values, index, callback)
	self._name = assert(name)
	self._values = assert(values)
	self._index = assert(index)
	self._callback = callback
end

-- Lines 12-17
function FreeFlightModifier:step_up()
	self._index = math.clamp(self._index + 1, 1, #self._values)

	if self._callback then
		self._callback(self:value())
	end
end

-- Lines 19-24
function FreeFlightModifier:step_down()
	self._index = math.clamp(self._index - 1, 1, #self._values)

	if self._callback then
		self._callback(self:value())
	end
end

-- Lines 26-28
function FreeFlightModifier:name_value()
	return string.format("%10.10s %7.2f", self._name, self._values[self._index])
end

-- Lines 30-32
function FreeFlightModifier:value()
	return self._values[self._index]
end
