NetworkFriendsXBL = NetworkFriendsXBL or class()

-- Lines 55-57
function NetworkFriendsXBL:init()
	self._callback = {}
end

-- Lines 59-60
function NetworkFriendsXBL:destroy()
end

-- Lines 62-63
function NetworkFriendsXBL:set_visible(set)
end

-- Lines 65-79
function NetworkFriendsXBL:get_friends_list()
	local player_index = managers.user:get_platform_id()

	if not player_index then
		Application:error("Player map not ready yet.")

		player_index = 0
	end

	local friend_list = XboxLive:friends(player_index)
	local friends = {}

	for i, friend in ipairs(friend_list) do
		table.insert(friends, NetworkFriend:new(friend.xuid, friend.gamertag))
	end

	return friends
end

-- Lines 81-89
function NetworkFriendsXBL:get_friends_by_name()
	local player_index = managers.user:get_platform_id()
	local friend_list = XboxLive:friends(player_index)
	local friends = {}

	for i, friend in ipairs(friend_list) do
		friends[friend.gamertag] = friend
	end

	return friends
end

-- Lines 91-96
function NetworkFriendsXBL:get_friends()
	if not self._initialized then
		self._initialized = true

		self._callback.initialization_done()
	end
end

-- Lines 98-100
function NetworkFriendsXBL:register_callback(event, callback)
	self._callback[event] = callback
end

-- Lines 102-103
function NetworkFriendsXBL:send_friend_request(nickname)
end

-- Lines 105-106
function NetworkFriendsXBL:remove_friend(id)
end

-- Lines 108-110
function NetworkFriendsXBL:has_builtin_screen()
	return true
end

-- Lines 112-113
function NetworkFriendsXBL:accept_friend_request(player_id)
end

-- Lines 115-116
function NetworkFriendsXBL:ignore_friend_request(player_id)
end

-- Lines 118-120
function NetworkFriendsXBL:num_pending_friend_requests()
	return 0
end
