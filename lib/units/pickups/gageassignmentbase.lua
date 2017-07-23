GageAssignmentBase = GageAssignmentBase or class(Pickup)

-- Lines: 3 to 8
function GageAssignmentBase:init(unit)
	assert(managers.gage_assignment, "GageAssignmentManager not yet created!")
	GageAssignmentBase.super.init(self, unit)
	managers.gage_assignment:on_unit_spawned(unit)
end

-- Lines: 10 to 30
function GageAssignmentBase:sync_pickup(peer)
	if not alive(self._unit) then
		return
	end

	if not managers.gage_assignment:is_unit_an_assignment(self._unit) then
		if Network:is_server() then
			self:consume()
		end

		return
	end

	self._picked_up = true

	managers.gage_assignment:on_unit_interact(self._unit, self._assignment)

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", peer and peer:id() or 1)
		self:show_pickup_msg(peer and peer:id() or 1)
		self:consume()
	end
end

-- Lines: 32 to 46
function GageAssignmentBase:_pickup(unit)
	if self._picked_up then
		return
	end

	if not alive(unit) or not alive(self._unit) then
		return
	end

	if Network:is_server() then
		self:sync_pickup()
	else
		managers.network:session():send_to_host("sync_pickup", self._unit)
	end

	return true
end

-- Lines: 49 to 55
function GageAssignmentBase:show_pickup_msg(peer_id)
	local peer = managers.network:session() and managers.network:session():peer(peer_id or 1)

	if peer then
		managers.gage_assignment:present_progress(self._assignment, peer:name())
	end
end

-- Lines: 57 to 63
function GageAssignmentBase:sync_net_event(event_id)
	if Network:is_client() then
		local peer_id = event_id or 1

		self:sync_pickup()
		self:show_pickup_msg(peer_id)
	end
end

-- Lines: 65 to 66
function GageAssignmentBase:assignment()
	return self._assignment
end

-- Lines: 69 to 73
function GageAssignmentBase:delete_unit()
	if alive(self._unit) then
		self._unit:set_slot(0)
	end
end

-- Lines: 75 to 76
function GageAssignmentBase:interact_blocked()
	return false
end

