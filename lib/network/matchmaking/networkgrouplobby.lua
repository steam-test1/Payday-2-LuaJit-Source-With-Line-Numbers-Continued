NetworkGroupLobby = NetworkGroupLobby or class()

-- Lines 3-7
function NetworkGroupLobby:init()
end

-- Lines 9-15
function NetworkGroupLobby:_server_timed_out(rpc)
end

-- Lines 27-29
function NetworkGroupLobby:is_invite_changing_control()
	return self._invite_changing_control
end
