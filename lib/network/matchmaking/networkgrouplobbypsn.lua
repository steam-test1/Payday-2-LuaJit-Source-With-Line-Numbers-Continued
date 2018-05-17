require("lib/network/matchmaking/NetworkGroupLobby")

NetworkGroupLobbyPSN = NetworkGroupLobbyPSN or class(NetworkGroupLobby)

-- Lines: 89 to 116
function NetworkGroupLobbyPSN:init()
	NetworkGroupLobby.init(self)
	cat_print("lobby", "group = NetworkGroupLobbyPSN")

	self.OPEN_SLOTS = 4
	self._players = {}
	self._returned_players = {}
	self._room_id = nil
	self._inlobby = false
	self._join_enable = true
	self._is_server_var = false
	self._is_client_var = false
	self._callback_map = {}

	-- Lines: 109 to 110
	local function f(...)
		self:_custom_message_cb(...)
	end

	PSN:set_matchmaking_callback("custom_message", f)

	self._time_to_leave = nil

	self:_load_globals()
end

-- Lines: 118 to 123
function NetworkGroupLobbyPSN:_session_destroyed_cb(room_id)
	cat_print("lobby", "NetworkGroupLobbyPSN:_session_destroyed_cb")

	if room_id == self._room_id then
		self:leave_group_lobby_cb()
	end
end

-- Lines: 125 to 126
function NetworkGroupLobbyPSN:destroy()
end

-- Lines: 128 to 137
function NetworkGroupLobbyPSN:update(time)
	if self._time_to_leave and self._time_to_leave < TimerManager:wall():time() then
		self._time_to_leave = nil

		self:leave_group_lobby_cb()
	end

	if self._try_time and self._try_time < TimerManager:wall():time() then
		self._try_time = nil

		self:leave_group_lobby_cb("join_failed")
	end
end

-- Lines: 139 to 151
function NetworkGroupLobbyPSN:create_group_lobby()
	cat_print("lobby", "NetworkGroupLobbyPSN:create_group_lobby()")

	self._players = {}
	local world_list = PSN:get_world_list()

	-- Lines: 145 to 146
	local function session_created(roomid)
		managers.network.group:_created_group_lobby(roomid)
	end

	PSN:set_matchmaking_callback("session_created", session_created)
	PSN:create_session(0, world_list[1].world_id, 0, self.OPEN_SLOTS, 0)
end

-- Lines: 153 to 171
function NetworkGroupLobbyPSN:join_group_lobby(room_info)
	self:_is_server(false)
	self:_is_client(true)

	if Global.psn_invite_id then
		Global.psn_invite_id = Global.psn_invite_id + 1

		if Global.psn_invite_id > 990 then
			Global.psn_invite_id = 1
		end
	end

	self._room_id = room_info.room_id

	-- Lines: 165 to 166
	local function f(...)
		self:_join_invite(...)
	end

	PSN:set_matchmaking_callback("connection_etablished", f)

	self._try_time = TimerManager:wall():time() + 30

	PSN:join_session(self._room_id)
end

-- Lines: 173 to 181
function NetworkGroupLobbyPSN:send_go_to_lobby()
	if self:_is_server() then
		for k, v in pairs(self._players) do
			if v.rpc then
				v.rpc:grp_go_to_lobby()
			end
		end
	end
end

-- Lines: 184 to 190
function NetworkGroupLobbyPSN:go_to_lobby()
	if self._callback_map.go_to_lobby then
		self:_call_callback("go_to_lobby")
	else
		self:leave_group_lobby()
	end
end

-- Lines: 192 to 210
function NetworkGroupLobbyPSN:send_return_group_lobby()
	local playerid = managers.network.account:player_id()

	cat_print("lobby", "Now telling server that im back and ready. My playerid is: ", tostring(playerid))

	local timeout = 40

	if Application:bundled() then
		timeout = 15
	end

	self._server_rpc:lobby_return(managers.network.account:player_id())

	for k, v in pairs(self._players) do
		if v.is_server then
			managers.network.generic:ping_watch(self._server_rpc, false, callback(self, self, "_server_timed_out"), v.pnid, timeout)

			return
		end
	end
end

-- Lines: 212 to 236
function NetworkGroupLobbyPSN:_handle_returned_players()
	if #self._returned_players ~= 0 and self._callback_map.player_returned then
		cat_print("lobby", "We now have a return callback so now handling players")

		for index, playerid in pairs(self._returned_players) do
			local v, k = nil
			k, v = self:find(playerid)

			if k then
				local res = self:_call_callback("player_returned", v)

				if res == true then
					v.rpc:lobby_return_answer("yes")
					managers.network.generic:ping_watch(v.rpc, false, callback(self, self, "_client_timed_out"), v.pnid)
				else
					v.rpc:lobby_return_answer("no")
				end
			end
		end

		self._returned_players = {}
	end
end

-- Lines: 238 to 247
function NetworkGroupLobbyPSN:return_group_lobby(playerid, sender)
	cat_print("lobby", "Client reports that it has returned to group lobby. ", tostring(playerid))
	table.insert(self._returned_players, playerid)

	if self._callback_map.player_returned then
		self:_handle_returned_players()
	else
		cat_print("lobby", "No player_returned callback so save these returns for later")
	end
end

-- Lines: 249 to 261
function NetworkGroupLobbyPSN:lobby_return_answer(answer, sender)
	cat_print("lobby", "Group leader tell us lobby_return_answer. ", tostring(answer), tostring(self._server_rpc))

	if answer == "yes" then
		for k, v in pairs(self._players) do
			if v.is_server then
				managers.network.generic:ping_watch(sender, false, callback(self, self, "_server_timed_out"), v.pnid)

				return
			end
		end
	else
		self:leave_group_lobby()
	end
end

-- Lines: 264 to 271
function NetworkGroupLobbyPSN:find(playerid)
	for k, v in pairs(self._players) do
		if tostring(v.playerid) == tostring(playerid) then
			return k, v
		end
	end

	return nil, nil
end

-- Lines: 274 to 299
function NetworkGroupLobbyPSN:leave_group_lobby(instant)
	if self:_is_server() and #self._players == 0 then
		self:leave_group_lobby_cb()

		return nil
	end

	self._try_time = nil

	if not instant then
		if self:_is_server() then
			for k, v in pairs(self._players) do
				managers.network.generic:ping_remove(v.rpc, false)
				v.rpc:psn_grp_unregister_player(managers.network.account:player_id(), true)
			end
		elseif self._server_rpc then
			self._server_rpc:psn_grp_unregister_player(managers.network.account:player_id(), false)
			managers.network.generic:ping_remove(self._server_rpc)
		end

		self._time_to_leave = TimerManager:wall():time() + 2
	else
		self:leave_group_lobby_cb()
	end
end

-- Lines: 301 to 324
function NetworkGroupLobbyPSN:leave_group_lobby_cb(error_callback)
	if self._room_id then
		managers.network.voice_chat:close_session()

		if self:_is_server() then
			PSN:destroy_session(self._room_id)
		else
			PSN:leave_session(self._room_id)
		end
	end

	self._room_id = nil
	self._inlobby = false
	self._is_server_var = false
	self._is_client_var = false
	self._players = {}

	if self._server_rpc then
		managers.network.generic:ping_remove(self._server_rpc, false)

		self._server_rpc = nil
	end

	self:_call_callback(error_callback or "left_group")
end

-- Lines: 326 to 333
function NetworkGroupLobbyPSN:set_join_enabled(enabled)
	self._join_enable = enabled

	if enabled and not managers.network.systemlink:is_lan() then
		managers.platform:set_presence("MPLobby")
	else
		managers.platform:set_presence("MPLobby_no_invite")
	end
end

-- Lines: 335 to 364
function NetworkGroupLobbyPSN:send_group_lobby_invite(network_friend)
	if self._room_id == nil then
		return false
	end

	for k, v in pairs(self._players) do
		if tostring(v.pnid) == tostring(network_friend) then
			return false
		end
	end

	local friends = PSN:get_list_friends()

	if friends then
		for k, v in pairs(friends) do
			if tostring(v.friend) == tostring(network_friend) and v.status == 2 and v.info and v.info == managers.platform:presence() then
				local msg = {join_invite = true}

				if not Global.psn_invite_id then
					Global.psn_invite_id = 1
				end

				msg.invite_id = Global.psn_invite_id

				PSN:send_message_custom(network_friend, self._room_id, msg)

				return true
			end
		end
	end

	return false
end

-- Lines: 367 to 379
function NetworkGroupLobbyPSN:kick_player(player_id, timeout)
	local v, k, rpc = nil
	k, v = self:find(player_id)

	if k and v.rpc then
		rpc = v.rpc

		rpc:lobby_return_answer("no")
	end

	self:_unregister_player(player_id, false, rpc)
end

-- Lines: 381 to 385
function NetworkGroupLobbyPSN:accept_group_lobby_invite(room, accept)
	if accept == true then
		self:_call_callback("accepted_group_lobby_invite", room)
	end
end

-- Lines: 387 to 397
function NetworkGroupLobbyPSN:send_game_id(id, private, created)
	if created and created == true then
		for k, v in pairs(self._players) do
			self:_call_callback("reserv_slot", v.pnid)
		end
	end

	for k, v in pairs(self._players) do
		v.rpc:psn_send_mm_id(PSN:convert_sessionid_to_string(id), private)
	end
end

-- Lines: 399 to 401
function NetworkGroupLobbyPSN:register_callback(event, callback)
	self._callback_map[event] = callback
end

-- Lines: 403 to 405
function NetworkGroupLobbyPSN:start_game()
	self:_call_callback("game_started")
end

-- Lines: 407 to 408
function NetworkGroupLobbyPSN:end_game()
end

-- Lines: 410 to 419
function NetworkGroupLobbyPSN:ingame_start_game()
	if self._server_rpc then
		for k, v in pairs(self._players) do
			if v.is_server then
				managers.network.generic:ping_watch(self._server_rpc, false, callback(self, self, "_server_timed_out"), v.pnid)

				return
			end
		end
	end
end

-- Lines: 421 to 427
function NetworkGroupLobbyPSN:say(message)
	if self:_is_server() then
		for k, v in pairs(self._players) do
			v.rpc:say_toclient(message)
		end
	end
end

-- Lines: 429 to 435
function NetworkGroupLobbyPSN:membervoted(player, votes)
	if self:_is_server() then
		for k, v in pairs(self._players) do
			v.rpc:membervoted_toclient(player, votes)
		end
	end
end

-- Lines: 437 to 438
function NetworkGroupLobbyPSN:is_group_leader()
	return self:_is_server() == true
end

-- Lines: 441 to 442
function NetworkGroupLobbyPSN:has_pending_invite()
	return false
end

-- Lines: 445 to 449
function NetworkGroupLobbyPSN:is_in_group()
	if self._inlobby then
		return true
	end

	return false
end

-- Lines: 452 to 457
function NetworkGroupLobbyPSN:num_group_players()
	local x = 0

	for k, v in pairs(self._players) do
		x = x + 1
	end

	return x
end

-- Lines: 460 to 461
function NetworkGroupLobbyPSN:get_group_players()
	return self._players
end

-- Lines: 464 to 468
function NetworkGroupLobbyPSN:is_full()
	if #self._players == self.OPEN_SLOTS - 1 then
		return true
	end

	return false
end

-- Lines: 472 to 473
function NetworkGroupLobbyPSN:get_leader_rpc()
	return self._server_rpc
end

-- Lines: 477 to 490
function NetworkGroupLobbyPSN:get_members_rpcs()
	local rpcs = {}

	for _, v in pairs(self._players) do
		if v.rpc then
			table.insert(rpcs, v.rpc)
		else
			Application:throw_exception("A player without an RPC. This is not good!")
		end
	end

	return rpcs
end

-- Lines: 493 to 520
function NetworkGroupLobbyPSN:resync_screen()
	managers.network:bind_port()

	if self:is_group_leader() then
		local playerinfo = {
			name = managers.network.account:username(),
			player_id = managers.network.account:player_id(),
			group_id = tostring(self._room_id),
			rpc = Network:self("TCP_IP")
		}

		self:_call_callback("player_joined", playerinfo)
	else
		local playerinfo = {
			name = managers.network.account:username(),
			player_id = managers.network.account:player_id(),
			group_id = tostring(self._room_id),
			rpc = Network:self("TCP_IP")
		}

		self:_call_callback("player_joined", playerinfo)
	end

	for k, v in pairs(self._players) do
		local playerinfo = {
			name = v.name,
			player_id = v.pnid,
			group_id = v.group,
			rpc = v.rpc
		}

		self:_call_callback("player_joined", playerinfo)
	end
end

-- Lines: 522 to 523
function NetworkGroupLobbyPSN:room_id()
	return self._room_id
end

-- Lines: 528 to 540
function NetworkGroupLobbyPSN:_load_globals()
	if Global.psn and Global.psn.group then
		self._room_id = Global.psn.group.room_id
		self._inlobby = Global.psn.group.inlobby
		self._is_server_var = Global.psn.group.is_server
		self._is_client_var = Global.psn.group.is_client
		self._players = Global.psn.group.players
		self._server_rpc = Global.psn.group.server_rpc
		self._returned_players = Global.psn.group._returned_players
		Global.psn.group = nil
	end
end

-- Lines: 541 to 554
function NetworkGroupLobbyPSN:_save_global()
	if not Global.psn then
		Global.psn = {}
	end

	Global.psn.group = {}
	Global.psn.group.room_id = self._room_id
	Global.psn.group.inlobby = self._inlobby
	Global.psn.group.is_server = self._is_server_var
	Global.psn.group.is_client = self._is_client_var
	Global.psn.group.players = self._players
	Global.psn.group.server_rpc = self._server_rpc
	Global.psn.group._returned_players = self._returned_players
end

-- Lines: 556 to 562
function NetworkGroupLobbyPSN:_call_callback(name, ...)
	if self._callback_map[name] then
		return self._callback_map[name](...)
	else
		Application:error("Callback " .. name .. " not found.")
	end
end

-- Lines: 564 to 570
function NetworkGroupLobbyPSN:_is_server(set)
	if set == true or set == false then
		self._is_server_var = set
	else
		return self._is_server_var
	end
end

-- Lines: 572 to 578
function NetworkGroupLobbyPSN:_is_client(set)
	if set == true or set == false then
		self._is_client_var = set
	else
		return self._is_client_var
	end
end

-- Lines: 582 to 589
function NetworkGroupLobbyPSN:_custom_message_cb(message)
	if message.custom_table and message.custom_table.join_invite and self._join_enable then
		self._invite_id = message.custom_table.invite_id

		self:_call_callback("receive_group_lobby_invite", message, message.sender)
	end
end

-- Lines: 591 to 593
function NetworkGroupLobbyPSN:_recv_game_id(id, private)
	self:_call_callback("receive_game_id", id, private)
end

-- Lines: 595 to 630
function NetworkGroupLobbyPSN:_created_group_lobby(room_id)
	if not room_id then
		self:_call_callback("create_group_failed")

		return
	end

	PSN:set_matchmaking_callback("session_created", function ()
	end)
	self:_call_callback("created_group")
	cat_print("lobby", "NetworkGroupLobbyPSN:_created_group_lobby()")

	self._room_id = room_id

	PSN:hide_session(self._room_id)

	self._inlobby = true
	self._room_info = PSN:get_info_session(self._room_id)

	self:_is_server(true)
	self:_is_client(false)
	managers.network:bind_port()
	managers.network.voice_chat:open_session(self._room_id)

	local playerinfo = {
		name = managers.network.account:username(),
		player_id = managers.network.account:player_id(),
		group_id = tostring(room_id),
		rpc = Network:self("TCP_IP")
	}

	self:_call_callback("player_joined", playerinfo)
end

-- Lines: 634 to 637
function NetworkGroupLobbyPSN:_clear_psn_callback(cb)

	-- Lines: 634 to 635
	local function f()
	end

	PSN:set_matchmaking_callback(cb, f)
end

-- Lines: 639 to 657
function NetworkGroupLobbyPSN:_join_invite(info)
	if info.room_id == self._room_id and info.user_id == info.owner_id then
		self:_clear_psn_callback("connection_etablished")

		self._try_time = nil
		self._room_info = PSN:get_info_session(self._room_id)
		self._server_rpc = Network:handshake(info.external_ip, info.port)

		if not self._server_rpc then
			Application:error("Could not connect with rpc")

			return
		end

		Network:set_timeout(self._server_rpc, 10)

		self._try_time = TimerManager:wall():time() + 10

		self._server_rpc:psn_grp_hello(self._invite_id)
	end
end

-- Lines: 659 to 670
function NetworkGroupLobbyPSN:_server_alive(server)
	if self._server_rpc and self._server_rpc:ip_at_index(0) == server:ip_at_index(0) then
		self._try_time = nil

		Network:set_timeout(self._server_rpc, 3000)
		self._server_rpc:psn_grp_register_player(managers.network.account:username(), managers.network.account:player_id(), tostring(managers.network.group:room_id()), false)

		self._inlobby = true
		self._try_time = TimerManager:wall():time() + 10
	end
end

-- Lines: 672 to 718
function NetworkGroupLobbyPSN:_register_player(name, pnid, group, rpc, is_server)
	if self.OPEN_SLOTS <= #self._players + 1 then
		return
	end

	self._try_time = nil
	local new_player = {
		name = name,
		pnid = pnid,
		playerid = pnid,
		group = group
	}

	if self:_is_server() then
		new_player.rpc = rpc

		rpc:psn_grp_register_player(managers.network.account:username(), managers.network.account:player_id(), tostring(managers.network.group:room_id()), true)

		for k, v in pairs(self._players) do
			v.rpc:psn_grp_register_player(name, pnid, group, false)
			rpc:psn_grp_register_player(v.name, v.pnid, v.group, false)
		end

		managers.network.generic:ping_watch(rpc, false, callback(self, self, "_client_timed_out"), pnid)
	end

	if is_server and is_server == true then
		new_player.is_server = true

		managers.network.generic:ping_watch(self._server_rpc, false, callback(self, self, "_server_timed_out"), pnid)
		managers.network.voice_chat:open_session(self._room_id)
		self:_call_callback("player_joined", {
			player_id = managers.network.account:player_id(),
			group_id = tostring(self._room_id),
			name = managers.network.account:username(),
			rpc = Network:self("TCP_IP")
		})
	end

	table.insert(self._players, new_player)

	if MPFriendsScreen.instance then
		MPFriendsScreen.instance:reset_list()
	end

	local playerinfo = {
		name = name,
		player_id = pnid,
		group_id = group,
		rpc = rpc
	}

	self:_call_callback("player_joined", playerinfo)
end

-- Lines: 721 to 748
function NetworkGroupLobbyPSN:_unregister_player(pnid, is_server, rpc)
	if self:_is_client() and is_server == true then
		self:leave_group_lobby_cb()

		return
	end

	cat_print("lobby", "_unregister_player: didn't leave group")

	local new_list = {}

	for k, v in pairs(self._players) do
		if v.pnid ~= pnid then
			table.insert(new_list, v)
		end
	end

	self._players = new_list

	if MPFriendsScreen.instance then
		MPFriendsScreen.instance:reset_list()
	end

	if self:_is_server() then
		managers.network.generic:ping_remove(rpc, false)

		for k, v in pairs(self._players) do
			v.rpc:psn_grp_unregister_player(pnid, false)
		end
	end

	self:_call_callback("player_left", {
		reason = "went home to mama",
		player_id = pnid
	})
end

-- Lines: 750 to 756
function NetworkGroupLobbyPSN:_in_list(id)
	for k, v in pairs(self._players) do
		if tostring(v.pnid) == tostring(id) then
			return true
		end
	end

	return false
end

-- Lines: 759 to 763
function NetworkGroupLobbyPSN:_server_timed_out(rpc)
	NetworkGroupLobby._server_timed_out(self, rpc)
	self:_unregister_player(nil, true, rpc)
end

-- Lines: 765 to 774
function NetworkGroupLobbyPSN:_client_timed_out(rpc)
	for k, v in pairs(self._players) do
		if v.rpc and v.rpc:ip_at_index(0) == rpc:ip_at_index(0) then
			self:_unregister_player(v.pnid, false, v.rpc)

			return
		end
	end
end

-- Lines: 777 to 781
function NetworkGroupLobbyPSN:leaving_game()
	if self:_is_server() then
		self:leave_group_lobby(true)
	end
end

