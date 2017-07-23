core:module("CoreFakeSessionCreator")
core:import("CoreFakeSession")

Creator = Creator or class()

-- Lines: 6 to 7
function Creator:init()
end

-- Lines: 9 to 17
function Creator:create_session(session_info, player_slots)
	if session_info:is_ranked() then
		cat_print("debug", "create_session: is_ranked")
	end

	if session_info:can_join_in_progress() then
		cat_print("debug", "create_session: is_ranked")
	end

	return CoreFakeSession.Session:new()
end

-- Lines: 20 to 21
function Creator:join_session(session_id)
	return CoreFakeSession.Session:new()
end

-- Lines: 24 to 27
function Creator:find_session(session_info, callback)
	local fake_sessions = {
		{info = 2},
		{info = 3}
	}

	callback(fake_sessions)
end

