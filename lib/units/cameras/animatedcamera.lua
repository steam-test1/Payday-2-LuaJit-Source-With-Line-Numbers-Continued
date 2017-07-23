AnimatedCamera = AnimatedCamera or class()

-- Lines: 3 to 6
function AnimatedCamera:init(unit)
	self._unit = unit
end

-- Lines: 13 to 14
function AnimatedCamera:update(unit, t, dt)
end

-- Lines: 16 to 18
function AnimatedCamera:set_position(pos)
	self._unit:set_position(pos)
end

-- Lines: 20 to 22
function AnimatedCamera:set_rotation(rot)
	self._unit:set_rotation(rot)
end

-- Lines: 24 to 25
function AnimatedCamera:position(pos)
	return self._unit:position()
end

-- Lines: 28 to 29
function AnimatedCamera:rotation(pos)
	return self._unit:rotation()
end

-- Lines: 32 to 34
function AnimatedCamera:play_redirect(redirect_name)
	local result = self._unit:play_redirect(redirect_name)

	return result ~= "" and result
end

-- Lines: 37 to 39
function AnimatedCamera:play_state(state_name)
	local result = self._unit:play_state(state_name)

	return result ~= "" and result
end

-- Lines: 42 to 43
function AnimatedCamera:destroy()
end

