NetworkGroupLobby = NetworkGroupLobby or class()

-- Lines: 6 to 7
function NetworkGroupLobby:init()
end

-- Lines: 14 to 15
function NetworkGroupLobby:_server_timed_out(rpc)
end

-- Lines: 27 to 28
function NetworkGroupLobby:is_invite_changing_control()
	return self._invite_changing_control
end

