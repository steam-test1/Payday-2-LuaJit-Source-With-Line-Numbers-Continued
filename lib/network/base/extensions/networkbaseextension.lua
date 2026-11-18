NetworkBaseExtension = NetworkBaseExtension or class()

-- Lines 3-5
function NetworkBaseExtension:init(unit)
	self._unit = unit
end

-- Lines 9-11
function NetworkBaseExtension:send(func, ...)
	managers.network:send_to_peers_synched(func, self._unit, ...)
end

-- Lines 15-17
function NetworkBaseExtension:send_to_host(func, ...)
	managers.network:send_to_host(func, self._unit, ...)
end

-- Lines 21-26
function NetworkBaseExtension:send_to_unit(params)
	local peer = managers.network:get_peer_by_unit_safe(self._unit)

	if peer then
		managers.network:send_to_peer(peer, unpack(params))
	end
end

-- Lines 30-32
function NetworkBaseExtension:peer()
	return managers.network:get_peer_by_unit_safe(self._unit)
end
