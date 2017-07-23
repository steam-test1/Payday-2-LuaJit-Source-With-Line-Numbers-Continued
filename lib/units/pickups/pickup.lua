Pickup = Pickup or class()

-- Lines: 5 to 12
function Pickup:init(unit)
	if not Network:is_server() and unit:slot() == 23 then
		unit:set_slot(20)
	end

	self._unit = unit
	self._active = true
end

-- Lines: 14 to 16
function Pickup:sync_pickup()
	self:consume()
end

-- Lines: 18 to 20
function Pickup:_pickup()
	Application:error("Pickup didn't have a _pickup() function!")
end

-- Lines: 22 to 27
function Pickup:pickup(unit)
	if not self._active then
		return
	end

	return self:_pickup(unit)
end

-- Lines: 30 to 32
function Pickup:consume()
	self:delete_unit()
end

-- Lines: 34 to 36
function Pickup:set_active(active)
	self._active = active
end

-- Lines: 38 to 40
function Pickup:delete_unit()
	World:delete_unit(self._unit)
end

-- Lines: 42 to 46
function Pickup:save(data)
	local state = {active = self._active}
	data.Pickup = state
end

-- Lines: 48 to 53
function Pickup:load(data)
	local state = data.Pickup

	if state then
		self:set_active(state.active)
	end
end

-- Lines: 55 to 56
function Pickup:sync_net_event(event, peer)
end

-- Lines: 58 to 59
function Pickup:destroy(unit)
end

