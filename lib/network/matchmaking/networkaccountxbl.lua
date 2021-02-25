require("lib/network/matchmaking/NetworkAccount")

NetworkAccountXBL = NetworkAccountXBL or class(NetworkAccount)

-- Lines 39-41
function NetworkAccountXBL:init()
	NetworkAccount.init(self)
end

-- Lines 43-47
function NetworkAccountXBL:signin_state()
	local xbl_state = managers.user:signed_in_state(managers.user:get_index())
	local game_signin_state = self:_translate_signin_state(xbl_state)

	return game_signin_state
end

-- Lines 49-57
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

-- Lines 59-60
function NetworkAccountXBL:show_signin_ui()
end

-- Lines 62-66
function NetworkAccountXBL:username_id()
	return Global.user_manager.user_index and Global.user_manager.user_map[Global.user_manager.user_index].username or ""
end

-- Lines 68-70
function NetworkAccountXBL:player_id()
	return managers.user:get_xuid(nil)
end

-- Lines 72-74
function NetworkAccountXBL:is_connected()
	return true
end

-- Lines 76-78
function NetworkAccountXBL:lan_connection()
	return true
end

-- Lines 80-83
function NetworkAccountXBL:publish_statistics(stats, force_store)
	Application:error("NetworkAccountXBL:publish_statistics( stats, force_store )")
	Application:stack_dump()
end

-- Lines 85-88
function NetworkAccountXBL:challenges_loaded()
	self._challenges_loaded = true
end

-- Lines 90-93
function NetworkAccountXBL:experience_loaded()
	self._experience_loaded = true
end

-- Lines 97-103
function NetworkAccountXBL:_translate_signin_state(xbl_state)
	if xbl_state == "signed_in_to_live" then
		return "signed in"
	end

	return "not signed in"
end
