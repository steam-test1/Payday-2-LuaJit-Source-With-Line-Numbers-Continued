core:module("CoreFakeSession")
core:import("CoreSession")

Session = Session or class()

-- Lines: 6 to 7
function Session:init()
end

-- Lines: 9 to 11
function Session:delete_session()
	cat_print("debug", "FakeSession: delete_session")
end

-- Lines: 13 to 15
function Session:start_session()
	cat_print("debug", "FakeSession: start_session")
end

-- Lines: 17 to 19
function Session:end_session()
	cat_print("debug", "FakeSession: end_session")
end

-- Lines: 21 to 23
function Session:join_local_user(local_user)
	cat_print("debug", "FakeSession: Local user:'" .. local_user:gamer_name() .. "' joined!")
end

-- Lines: 25 to 27
function Session:join_remote_user(remote_user)
	cat_print("debug", "FakeSession: Remote user:'" .. remote_user:gamer_name() .. "' joined!")
end

return
