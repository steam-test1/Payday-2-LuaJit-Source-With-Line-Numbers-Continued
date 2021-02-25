core:module("CoreSessionStateInSessionEnd")
core:import("CoreSessionStateInit")

InSessionEnd = InSessionEnd or class()

-- Lines 6-10
function InSessionEnd:init(session)
	assert(session)

	self._session = session

	self._session._session_handler:session_ended()
end

-- Lines 12-13
function InSessionEnd:destroy()
end

-- Lines 15-17
function InSessionEnd:transition()
	return CoreSessionStateInit
end
