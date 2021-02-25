require("lib/network/matchmaking/NetworkAccount")

NetworkAccountPSN = NetworkAccountPSN or class(NetworkAccount)

-- Lines 39-43
function NetworkAccountPSN:init()
	NetworkAccount.init(self)
end

-- Lines 45-50
function NetworkAccountPSN:signin_state()
	if PSN:is_online() == true then
		return "signed in"
	end

	return "not signed in"
end

-- Lines 52-64
function NetworkAccountPSN:local_signin_state()
	if not PSN:cable_connected() then
		return false
	end

	local n = PSN:get_localinfo()

	if not n then
		return false
	end

	if not n.local_ip then
		return false
	end

	return true
end

-- Lines 66-68
function NetworkAccountPSN:show_signin_ui()
	PSN:display_online_connection()
end

-- Lines 70-85
function NetworkAccountPSN:username_id()
	local online_name = PSN:get_npid_user()

	if online_name then
		return online_name
	else
		local local_user_info_name = PS3:get_userinfo()

		if local_user_info_name then
			return local_user_info_name
		end
	end

	return managers.localization:text("menu_mp_player")
end

-- Lines 87-104
function NetworkAccountPSN:player_id()
	if PSN:get_npid_user() == nil then
		local n = PSN:get_localinfo()

		if n and n.local_ip then
			return n.local_ip
		end

		Application:error("Could not get local ip, returning \"player_id\" VERY BAD!.")

		return "player_id"
	end

	return PSN:get_npid_user()
end

-- Lines 106-108
function NetworkAccountPSN:is_connected()
	return true
end

-- Lines 110-112
function NetworkAccountPSN:lan_connection()
	return PSN:cable_connected()
end

-- Lines 116-122
function NetworkAccountPSN:_lan_ip()
	local l = PSN:get_lan_info()

	if l and l.lan_ip then
		return l.lan_ip
	end

	return "player_lan"
end

-- Lines 125-128
function NetworkAccountPSN:publish_statistics(stats, force_store)
	Application:error("NetworkAccountPSN:publish_statistics( stats, force_store )")
	Application:stack_dump()
end

-- Lines 130-132
function NetworkAccountPSN:achievements_fetched()
	self._achievements_fetched = true
end

-- Lines 134-136
function NetworkAccountPSN:challenges_loaded()
	self._challenges_loaded = true
end

-- Lines 138-140
function NetworkAccountPSN:experience_loaded()
	self._experience_loaded = true
end
