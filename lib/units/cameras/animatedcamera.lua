AnimatedCamera = AnimatedCamera or class()

-- Lines 3-6
function AnimatedCamera:init(unit)
	self._unit = unit
end

-- Lines 13-14
function AnimatedCamera:update(unit, t, dt)
end

-- Lines 16-18
function AnimatedCamera:set_position(pos)
	self._unit:set_position(pos)
end

-- Lines 20-22
function AnimatedCamera:set_rotation(rot)
	self._unit:set_rotation(rot)
end

-- Lines 24-26
function AnimatedCamera:position(pos)
	return self._unit:position()
end

-- Lines 28-30
function AnimatedCamera:rotation(pos)
	return self._unit:rotation()
end

-- Lines 32-35
function AnimatedCamera:play_redirect(redirect_name)
	local result = self._unit:play_redirect(redirect_name)

	return result ~= "" and result
end

-- Lines 37-40
function AnimatedCamera:play_state(state_name)
	local result = self._unit:play_state(state_name)

	return result ~= "" and result
end

-- Lines 42-43
function AnimatedCamera:destroy()
end
