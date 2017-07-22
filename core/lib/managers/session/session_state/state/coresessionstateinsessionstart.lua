core:module("CoreSessionStateInSession")
core:import("CoreSessionStateInSessionStarted")

InSessionStart = InSessionStart or class()

-- Lines: 6 to 9
function InSessionStart:init(session)
	assert(session)

	self._session = session
end

-- Lines: 11 to 12
function InSessionStart:destroy()
end

-- Lines: 14 to 15
function InSessionStart:transition()
	return CoreSessionStateInSessionStarted.Started, self._session
end

return
