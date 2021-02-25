Pickup = Pickup or class()

-- Lines 3-12
function Pickup:init(unit)
	if not Network:is_server() and unit:slot() == 23 then
		unit:set_slot(20)
	end

	self._unit = unit
	self._active = true
end

-- Lines 14-16
function Pickup:sync_pickup()
	self:consume()
end

-- Lines 18-20
function Pickup:_pickup()
	Application:error("Pickup didn't have a _pickup() function!")
end

-- Lines 22-28
function Pickup:pickup(unit)
	if not self._active then
		return
	end

	return self:_pickup(unit)
end

-- Lines 30-32
function Pickup:consume()
	self:delete_unit()
end

-- Lines 34-36
function Pickup:set_active(active)
	self._active = active
end

-- Lines 38-40
function Pickup:delete_unit()
	World:delete_unit(self._unit)
end

-- Lines 42-46
function Pickup:save(data)
	local state = {
		active = self._active
	}
	data.Pickup = state
end

-- Lines 48-53
function Pickup:load(data)
	local state = data.Pickup

	if state then
		self:set_active(state.active)
	end
end

-- Lines 55-56
function Pickup:sync_net_event(event, peer)
end

-- Lines 58-59
function Pickup:destroy(unit)
end
