core:module("CoreFreeFlightAction")

FreeFlightAction = FreeFlightAction or class()

-- Lines: 6 to 9
function FreeFlightAction:init(name, callback)
	self._name = assert(name)
	self._callback = assert(callback)
end

-- Lines: 11 to 13
function FreeFlightAction:do_action()
	self._callback()
end

-- Lines: 15 to 16
function FreeFlightAction:reset()
end

-- Lines: 18 to 19
function FreeFlightAction:name()
	return self._name
end
FreeFlightActionToggle = FreeFlightActionToggle or class()

-- Lines: 25 to 31
function FreeFlightActionToggle:init(name1, name2, callback1, callback2)
	self._name1 = assert(name1)
	self._name2 = assert(name2)
	self._callback1 = assert(callback1)
	self._callback2 = assert(callback2)
	self._toggle = 1
end

-- Lines: 33 to 41
function FreeFlightActionToggle:do_action()
	if self._toggle == 1 then
		self._toggle = 2

		self._callback1()
	else
		self._toggle = 1

		self._callback2()
	end
end

-- Lines: 43 to 47
function FreeFlightActionToggle:reset()
	if self._toggle == 2 then
		self:do_action()
	end
end

-- Lines: 49 to 55
function FreeFlightActionToggle:name()
	if self._toggle == 1 then
		return self._name1
	else
		return self._name2
	end
end

return
