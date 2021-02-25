core:module("CoreSessionStateFindSession")
core:import("CoreSessionStateCreateSession")
core:import("CoreSessionStateJoinSession")

FindSession = FindSession or class()

-- Lines 7-9
function FindSession:init()
	self.session_state._session_creator:find_session(self.session_state._session_info, callback(self, self, "_sessions_found"))
end

-- Lines 11-12
function FindSession:destroy()
end

-- Lines 14-20
function FindSession:_sessions_found(sessions)
	if not sessions then
		self._session_to_join = false
	end

	self._session_id_to_join = sessions[1].info
end

-- Lines 22-28
function FindSession:transition()
	if self._session_id_to_join == false then
		return CoreSessionStateCreateSession.CreateSession
	elseif self._session_id_to_join ~= nil then
		return CoreSessionStateJoinSession.JoinSession, self._session_id_to_join
	end
end
