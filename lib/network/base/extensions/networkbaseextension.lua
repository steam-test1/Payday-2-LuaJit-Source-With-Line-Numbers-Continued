NetworkBaseExtension = NetworkBaseExtension or class()

-- Lines: 3 to 5
function NetworkBaseExtension:init(unit)
	self._unit = unit
end

-- Lines: 9 to 13
function NetworkBaseExtension:send(func, ...)
	if managers.network:session() then
		managers.network:session():send_to_peers_synched(func, self._unit, ...)
	end
end

-- Lines: 17 to 21
function NetworkBaseExtension:send_to_host(func, ...)
	if managers.network:session() then
		managers.network:session():send_to_host(func, self._unit, ...)
	end
end

-- Lines: 25 to 32
function NetworkBaseExtension:send_to_unit(params)
	if managers.network:session() then
		local peer = managers.network:session():peer_by_unit(self._unit)

		if peer then
			managers.network:session():send_to_peer(peer, unpack(params))
		end
	end
end

-- Lines: 36 to 40
function NetworkBaseExtension:peer()
	if managers.network:session() then
		return managers.network:session():peer_by_unit(self._unit)
	end
end

