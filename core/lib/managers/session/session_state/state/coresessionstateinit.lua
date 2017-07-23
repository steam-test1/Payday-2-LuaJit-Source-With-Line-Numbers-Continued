core:module("CoreSessionStateInit")
core:import("CoreSessionStateFindSession")

Init = Init or class()

-- Lines: 6 to 8
function Init:init()
	assert(not self.session_state._quit_session_requester:is_requested())
end

-- Lines: 10 to 14
function Init:transition()
	if self.session_state._join_session_requester:is_requested() and self.session_state:player_slots():has_primary_local_user() then
		return CoreSessionStateFindSession.FindSession
	end
end

