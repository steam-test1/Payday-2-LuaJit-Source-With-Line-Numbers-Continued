core:module("CoreFakeSession")
core:import("CoreSession")

Session = Session or class()

-- Lines 6-7
function Session:init()
end

-- Lines 9-11
function Session:delete_session()
	cat_print("debug", "FakeSession: delete_session")
end

-- Lines 13-15
function Session:start_session()
	cat_print("debug", "FakeSession: start_session")
end

-- Lines 17-19
function Session:end_session()
	cat_print("debug", "FakeSession: end_session")
end

-- Lines 21-23
function Session:join_local_user(local_user)
	cat_print("debug", "FakeSession: Local user:'" .. local_user:gamer_name() .. "' joined!")
end

-- Lines 25-27
function Session:join_remote_user(remote_user)
	cat_print("debug", "FakeSession: Remote user:'" .. remote_user:gamer_name() .. "' joined!")
end
