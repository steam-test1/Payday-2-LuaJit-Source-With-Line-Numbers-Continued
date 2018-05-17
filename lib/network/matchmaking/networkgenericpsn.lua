NetworkGenericPSN = NetworkGenericPSN or class()

-- Lines: 3 to 17
function NetworkGenericPSN:init()
	cat_print("lobby", "generic = NetworkGenericPSN")

	-- Lines: 5 to 6
	local function f()
	end

	PSN:set_matchmaking_callback("room_invitation", f)

	-- Lines: 8 to 9
	local function psn_left(...)
		self:psn_member_left(...)
	end

	PSN:set_matchmaking_callback("member_left", psn_left)

	-- Lines: 11 to 12
	local function psn_join(...)
		self:psn_member_joined(...)
	end

	PSN:set_matchmaking_callback("member_joined", psn_join)

	-- Lines: 14 to 15
	local function psn_destroyed(...)
		self:psn_session_destroyed(...)
	end

	PSN:set_matchmaking_callback("session_destroyed", psn_destroyed)
end

-- Lines: 19 to 21
function NetworkGenericPSN:update(time)
	managers.network.voice_chat:update()
end

-- Lines: 24 to 32
function NetworkGenericPSN:start_game()
	Global.rendezvous = {}
	Global.rendezvous.rendevous = managers.network.shared_rdv:rendezvousonline()
	Global.rendezvous.is_online = managers.network.shared_rdv:is_online()

	managers.network.voice_chat:_save_globals(true)
	managers.network.group:_save_global()
	managers.network.matchmake:_save_global()
end

-- Lines: 35 to 43
function NetworkGenericPSN:end_game()
	Global.rendezvous = {}
	Global.rendezvous.rendevous = managers.network.shared_rdv:rendezvousonline()
	Global.rendezvous.is_online = managers.network.shared_rdv:is_online()

	managers.network.generic:set_entermenu(true)
	managers.network.voice_chat:_save_globals(managers.network.group:room_id() or false)
	managers.network.group:_save_global()
end

-- Lines: 47 to 49
function NetworkGenericPSN:psn_member_joined(info)
	managers.network.matchmake:psn_member_joined(info)
end

-- Lines: 51 to 53
function NetworkGenericPSN:psn_member_left(info)
	managers.network.matchmake:psn_member_left(info)
end

-- Lines: 55 to 79
function NetworkGenericPSN:psn_session_destroyed(info)
	cat_print("lobby", "NetworkGenericPSN:_session_destroyed_cb")
	cat_print_inspect("lobby", info)
	managers.network.voice_chat:psn_session_destroyed(info.room_id)
	managers.network.matchmake:_session_destroyed_cb(info.room_id)
	managers.network.group:_session_destroyed_cb(info.room_id)
end

