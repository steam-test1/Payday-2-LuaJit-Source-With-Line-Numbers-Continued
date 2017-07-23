require("lib/network/matchmaking/NetworkAccount")

NetworkAccountXBL = NetworkAccountXBL or class(NetworkAccount)

-- Lines: 39 to 41
function NetworkAccountXBL:init()
	NetworkAccount.init(self)
end

-- Lines: 43 to 46
function NetworkAccountXBL:signin_state()
	local xbl_state = managers.user:signed_in_state(managers.user:get_index())
	local game_signin_state = self:_translate_signin_state(xbl_state)

	return game_signin_state
end

-- Lines: 49 to 56
function NetworkAccountXBL:local_signin_state()
	local xbl_state = managers.user:signed_in_state(managers.user:get_index())

	if xbl_state == "not_signed_in" then
		return "not signed in"
	end

	if xbl_state == "signed_in_locally" then
		return "signed in"
	end

	if xbl_state == "signed_in_to_live" then
		return "signed in"
	end

	return "not signed in"
end

-- Lines: 59 to 60
function NetworkAccountXBL:show_signin_ui()
end

-- Lines: 62 to 63
function NetworkAccountXBL:username_id()
	return Global.user_manager.user_index and Global.user_manager.user_map[Global.user_manager.user_index].username or ""
end

-- Lines: 68 to 69
function NetworkAccountXBL:player_id()
	return managers.user:get_xuid(nil)
end

-- Lines: 72 to 73
function NetworkAccountXBL:is_connected()
	return true
end

-- Lines: 76 to 77
function NetworkAccountXBL:lan_connection()
	return true
end

-- Lines: 80 to 83
function NetworkAccountXBL:publish_statistics(stats, force_store)
	Application:error("NetworkAccountXBL:publish_statistics( stats, force_store )")
	Application:stack_dump()
end

-- Lines: 85 to 88
function NetworkAccountXBL:challenges_loaded()
	self._challenges_loaded = true
end

-- Lines: 90 to 93
function NetworkAccountXBL:experience_loaded()
	self._experience_loaded = true
end

-- Lines: 97 to 102
function NetworkAccountXBL:_translate_signin_state(xbl_state)
	if xbl_state == "signed_in_to_live" then
		return "signed in"
	end

	return "not signed in"
end

