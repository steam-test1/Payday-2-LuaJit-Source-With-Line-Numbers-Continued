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

-- Lines 38-56
function Pickup:delete_unit()
	local unit = self._unit

	if Network:is_server() or unit:id() == -1 then
		World:delete_unit(unit)
	else
		unit:set_visible(false)
		self:set_active(false)

		local int_ext = unit:interaction()

		if int_ext then
			int_ext:set_active(false)
		end

		unit:set_enabled(false)
	end
end

-- Lines 58-62
function Pickup:save(data)
	local state = {
		active = self._active
	}
	data.Pickup = state
end

-- Lines 64-69
function Pickup:load(data)
	local state = data.Pickup

	if state then
		self:set_active(state.active)
	end
end

-- Lines 71-72
function Pickup:sync_net_event(event, peer)
end

-- Lines 74-75
function Pickup:destroy(unit)
end
