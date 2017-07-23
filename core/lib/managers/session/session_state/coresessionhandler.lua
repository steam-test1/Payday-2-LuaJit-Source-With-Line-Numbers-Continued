core:module("CoreSessionHandler")

Session = Session or class()

-- Lines: 5 to 7
function Session:joined_session()
	cat_print("debug", "Joined Session!")
end

-- Lines: 9 to 11
function Session:session_ended()
	cat_print("debug", "Session Ended")
end

-- Lines: 13 to 15
function Session:session_started()
	cat_print("debug", "Session Started!")
end

