core:module("CoreSessionStateInSessionStarted")
core:import("CoreSessionStateQuitSession")
core:import("CoreSessionStateInSessionEnd")

InSessionStarted = InSessionStarted or class()

-- Lines: 7 to 11
function InSessionStarted:init(session)
	assert(session)

	self._session = session

	self._session._session_handler:session_started()
end

-- Lines: 13 to 14
function InSessionStarted:destroy()
end

-- Lines: 16 to 25
function InSessionStarted:transition()
	if self.session_state._quit_session_requester:is_requested() then
		return CoreSessionStateQuitSession.Quit, self._session
	end

	if self._end_session then
		return CoreSessionStateInSessionEnd.InSessionEnd, self._session
	end
end

-- Lines: 27 to 29
function InSessionStarted:end_session()
	self._end_session = true
end

return
