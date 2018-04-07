require("lib/network/base/BaseNetworkSession")
require("lib/network/base/ClientNetworkSession")
require("lib/network/base/HostNetworkSession")
require("lib/network/matchmaking/NetworkAccount")
require("lib/network/matchmaking/NetworkAccountPSN")
require("lib/network/matchmaking/NetworkAccountSTEAM")
require("lib/network/matchmaking/NetworkAccountSTEAMDebug")
require("lib/network/matchmaking/NetworkAccountXBL")
require("lib/network/matchmaking/NetworkFriend")
require("lib/network/matchmaking/NetworkFriendsPSN")
require("lib/network/matchmaking/NetworkFriendsXBL")
require("lib/network/matchmaking/NetworkGenericPSN")
require("lib/network/matchmaking/NetworkGroupLobby")
require("lib/network/matchmaking/NetworkGroupLobbyPSN")
require("lib/network/matchmaking/NetworkMatchMaking")
require("lib/network/matchmaking/NetworkMatchMakingPSN")
require("lib/network/matchmaking/NetworkMatchMakingSTEAM")
require("lib/network/matchmaking/NetworkMatchMakingXBL")
require("lib/network/matchmaking/NetworkVoiceChatDisabled")
require("lib/network/matchmaking/NetworkVoiceChatPSN")
require("lib/network/matchmaking/NetworkVoiceChatSTEAM")
require("lib/network/matchmaking/NetworkVoiceChatXBL")
require("lib/network/base/NetworkPeer")
require("lib/network/base/handlers/BaseNetworkHandler")
require("lib/network/base/handlers/DefaultNetworkHandler")
require("lib/network/base/handlers/ConnectionNetworkHandler")
require("lib/network/base/handlers/PacketNetworkHandler")
require("lib/network/handlers/UnitNetworkHandler")
require("lib/units/beings/player/PlayerDamage")
require("lib/units/beings/player/PlayerMovement")

NetworkManager = NetworkManager or class()

if SystemInfo:platform() == Idstring("X360") then
	NetworkManager.DEFAULT_PORT = 1000
elseif SystemInfo:platform() == Idstring("XB1") then
	NetworkManager.DEFAULT_PORT = 43210
elseif SystemInfo:platform() == Idstring("PS4") then
	NetworkManager.DEFAULT_PORT = 22222
else
	NetworkManager.DEFAULT_PORT = 9899
end

NetworkManager.DROPIN_ENABLED = true

if SystemInfo:platform() == Idstring("X360") or SystemInfo:platform() == Idstring("PS3") or SystemInfo:platform() == Idstring("PS4") or SystemInfo:platform() == Idstring("XB1") then
	NetworkManager.PROTOCOL_TYPE = "TCP_IP"
else
	NetworkManager.PROTOCOL_TYPE = "STEAM"
end

-- Lines: 57 to 114
function NetworkManager:init()
	self.OVERWRITEABLE_MSGS = {
		set_look_dir = {clbk = NetworkManager.clbk_msg_overwrite},
		criminal_hurt = {
			clbk = PlayerDamage.clbk_msg_overwrite_criminal_hurt,
			indexes = {}
		},
		suspicion = {
			clbk = PlayerMovement.clbk_msg_overwrite_suspicion,
			indexes = {}
		}
	}

	if SystemInfo:platform() == Idstring("PS3") then
		self._is_ps3 = true
	elseif SystemInfo:platform() == Idstring("X360") then
		self._is_x360 = true
	elseif SystemInfo:platform() == Idstring("PS4") then
		self._is_ps4 = true
	elseif SystemInfo:platform() == Idstring("XB1") then
		self._is_xb1 = true
	else
		self._is_win32 = true
	end

	self._spawn_points = {}

	if self._is_ps3 then
		Network:set_use_psn_network(true)

		if #PSN:get_world_list() == 0 then
			PSN:init_matchmaking()
		end

		self:_register_PSN_matchmaking_callbacks()
	elseif self._is_ps4 then
		Network:set_use_psn_network(true)

		if #PSN:get_world_list() == 0 then
			PSN:init_matchmaking()
		end

		self:_register_PSN_matchmaking_callbacks()
	elseif self._is_xb1 then
		self.account = NetworkAccountXBL:new()
		self.voice_chat = NetworkVoiceChatXBL:new()
	elseif self._is_win32 then
		if SystemInfo:distribution() == Idstring("STEAM") then
			self.account = NetworkAccountSTEAM:new()
			self.voice_chat = NetworkVoiceChatSTEAM:new()
		else
			self.account = NetworkAccount:new()
			self.voice_chat = NetworkVoiceChatDisabled:new()
		end
	elseif self._is_x360 then
		self.account = NetworkAccountXBL:new()
		self.voice_chat = NetworkVoiceChatXBL:new()
	end

	self._started = false
	managers.network = self

	self:_create_lobby()
	self:load()
end

-- Lines: 118 to 127
function NetworkManager:init_finalize()
	print("NetworkManager:init_finalize()")

	if Network:multiplayer() and not Application:editor() then
		self._session:on_load_complete(false)

		if self._session:is_client() and not self._session:server_peer() then
			game_state_machine:current_state():on_server_left()
		end
	end
end

-- Lines: 129 to 180
function NetworkManager:_create_lobby()
	if self._is_win32 then
		cat_print("lobby", "Online Lobby is PC")

		if SystemInfo:distribution() == Idstring("STEAM") then
			self.matchmake = NetworkMatchMakingSTEAM:new()
		else
			self.matchmake = NetworkMatchMaking:new()
		end
	elseif self._is_ps4 then
		cat_print("lobby", "Online Lobby is PS4")

		self.friends = NetworkFriendsPSN:new()
		self.group = NetworkGroupLobbyPSN:new()
		self.matchmake = NetworkMatchMakingPSN:new()
		self.shared_psn = NetworkGenericPSN:new()
		self.shared = self.shared_psn
		self.account = NetworkAccountPSN:new()
		self.match = nil

		self:ps3_determine_voice()

		self._shared_update = self.shared_psn
	elseif self._is_xb1 then
		self.friends = NetworkFriendsXBL:new()
		self.matchmake = NetworkMatchMakingXBL:new()
	elseif self._is_ps3 then
		cat_print("lobby", "Online Lobby is PS3")

		self.friends = NetworkFriendsPSN:new()
		self.group = NetworkGroupLobbyPSN:new()
		self.matchmake = NetworkMatchMakingPSN:new()
		self.shared_psn = NetworkGenericPSN:new()
		self.shared = self.shared_psn
		self.account = NetworkAccountPSN:new()
		self.match = nil

		print("voice chat _create_lobby")
		self:ps3_determine_voice()

		self._shared_update = self.shared_psn
	elseif self._is_x360 then
		self.friends = NetworkFriendsXBL:new()
		self.matchmake = NetworkMatchMakingXBL:new()
	else
		Global._boot_invite_mp = nil

		Application:error("NetworkManager:create_lobby failed to get a valid lobby for online play.")

		return
	end
end

-- Lines: 186 to 216
function NetworkManager:ps3_determine_voice(lan)
	local voice = "voice_quiet"

	if lan == true then
		voice = "voice_quiet"
	elseif PSN:is_online() then
		voice = PSN:online_chat_allowed() and "voice_psn" or "voice_disabled"
	end

	if self.voice_chat and self.voice_chat:voice_type() == voice then
		return
	end

	if self.voice_chat and self.voice_chat:voice_type() ~= voice then
		self.voice_chat:close_all(true)

		self.voice_chat = nil
	end

	if voice == "voice_psn" then
		self.voice_chat = NetworkVoiceChatPSN:new()
	elseif voice == "voice_disabled" then
		self.voice_chat = NetworkVoiceChatDisabled:new()
	else
		self.voice_chat = NetworkVoiceChatDisabled:new(true)
	end
end

-- Lines: 219 to 220
function NetworkManager:session()
	return self._session
end

-- Lines: 223 to 224
function NetworkManager:shared_handler_data()
	return self._shared_handler_data
end

-- Lines: 228 to 261
function NetworkManager:load()
	if Global.network then
		self._network_bound = Global.network.network_bound

		self:start_network()

		if Global.network.session then
			if Global.network.session_host then
				self._session = HostNetworkSession:new()

				self._session:create_local_peer(false)
			else
				self._session = ClientNetworkSession:new()

				self._session:create_local_peer(false)
			end
		end

		self._session:load(Global.network.session)
		managers.network.matchmake:_load_globals()
		managers.network.account:_load_globals()

		if self._is_x360 then
			managers.network.voice_chat:resume()
		else
			managers.network.voice_chat:_load_globals()
		end

		Global.network = nil

		if self._is_win32 then
			managers.network.voice_chat:open()
		end
	end

	if Network.set_loading_state then
		Network:set_loading_state(false)
	end
end

-- Lines: 265 to 286
function NetworkManager:save()
	if self._started then
		Global.network = {}
		Global.network.network_bound = self._network_bound

		if self._session then
			Global.network.session_host = self._session:is_host()
			Global.network.session = {}

			self._session:save(Global.network.session)
		end

		managers.network.matchmake:_save_globals()
		managers.network.account:_save_globals()
		managers.network.voice_chat:_save_globals(true)

		if self._is_win32 then
			managers.network.voice_chat:destroy_voice()
		end
	end
end

-- Lines: 290 to 310
function NetworkManager:update(t, dt)
	if self._stop_next_frame then
		self:stop_network(true)

		self._stop_next_frame = nil

		return
	end

	if self._session then
		self._session:update()
	end

	if self.matchmake then
		self.matchmake:update()
	end

	if self.voice_chat then
		self.voice_chat:update(t)
	end

	if self.account then
		self.account:update()
	end
end

-- Lines: 314 to 323
function NetworkManager:end_update()
	if self._stop_network then
		self._stop_next_frame = true
		self._stop_network = nil
	end

	if self._session then
		self._session:end_update()
	end
end

-- Lines: 327 to 343
function NetworkManager:start_network()
	if not self._started then
		Global.category_print.multiplayer_base = true

		self:register_handler("connection", ConnectionNetworkHandler)
		self:register_handler("packet", PacketNetworkHandler)
		managers.network:register_handler("unit", UnitNetworkHandler)
		Network:bind(self._network_bound and -1 or self.DEFAULT_PORT, DefaultNetworkHandler:new())

		self._network_bound = true
		self._started = true

		cat_print("multiplayer_base", "[NetworkManager:start_network]")
	end
end

-- Lines: 347 to 356
function NetworkManager:register_handler(name, handler_class)
	if not self._handlers then
		self._handlers = {}
		self._shared_handler_data = {}
	end

	local new_handler = handler_class:new()
	self._handlers[name] = new_handler

	Network:set_receiver(Idstring(name), new_handler)
end

-- Lines: 360 to 367
function NetworkManager:prepare_stop_network(...)
	if self._session then
		self._session:prepare_to_close(...)

		if self.voice_chat and self._is_win32 then
			self.voice_chat:destroy_voice()
		end
	end
end

-- Lines: 371 to 408
function NetworkManager:stop_network(clean)
	if self._started then
		self._session:on_network_stopped()

		self._started = false

		if clean and self._session then
			local peers = self._session:peers()

			for k, peer in pairs(peers) do
				local rpc = peer:rpc()

				if rpc then
					Network:reset_connection(rpc)
					Network:remove_client(rpc)
				end
			end
		end

		self._handlers = nil
		self._shared_handler_data = nil

		self._session:destroy()

		self._session = nil
		self._stop_network = nil
		self._stop_next_frame = nil
		self._network_bound = nil

		Network:unbind()
		Network:set_disconnected()

		if not Application:editor() then
			Network:set_multiplayer(false)
		end

		cat_print("multiplayer_base", "[NetworkManager:stop_network]")
		print("---------------------------------------------------------")
	end
end

-- Lines: 412 to 414
function NetworkManager:queue_stop_network()
	self._stop_network = true
end

-- Lines: 418 to 431
function NetworkManager:is_ready_to_load()
	if self._stop_next_frame or self._stop_network then
		return false
	end

	if self._session and not self._session:is_ready_to_close() then
		return false
	end

	if self.account and not self.account:is_ready_to_close() then
		return false
	end

	return true
end

-- Lines: 436 to 445
function NetworkManager:stopping()
	if not self._started then
		return true
	end

	if self._stop_next_frame or self._stop_network then
		return true
	end

	return false
end

-- Lines: 451 to 461
function NetworkManager:start_client()
	self:stop_network(true)
	self:start_network()

	if self._is_win32 then
		self.voice_chat:open()
	end

	self._session = ClientNetworkSession:new()

	self._session:create_local_peer(true)
end

-- Lines: 466 to 474
function NetworkManager:discover_hosts(result_cb)
	self:stop_network(true)
	self:start_network()

	self._session = ClientNetworkSession:new()

	self._session:create_local_peer(true)

	self._discover_hosts_cb = result_cb

	self._session:discover_hosts()
end

-- Lines: 479 to 504
function NetworkManager:on_discover_host_received(sender)
	if Global.game_settings.single_player then
		return
	end

	local level_name = Global.level_data.level
	local level_id = tweak_data.levels:get_index_from_world_name(level_name)

	if level_id then
		level_name = ""
	else
		level_id = 1
	end

	local peer = managers.network:session():local_peer()
	local state = peer:in_lobby() and 1 or 2
	local difficulty = Global.game_settings.difficulty
	level_id = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)

	print("on_discover_host_received", level_id)

	local my_name = nil
	my_name = SystemInfo:platform() == Idstring("PS3") and "Player 1" or Network:hostname()

	sender:discover_host_reply(my_name, level_id, level_name, sender:ip_at_index(0), state, difficulty)
end

-- Lines: 509 to 516
function NetworkManager:on_discover_host_reply(host, host_name, level_name, my_ip, state, difficulty)
	print("on_discover_host_reply", host, host_name, level_name, my_ip, state)

	if self._discover_hosts_cb then
		local cb = self._discover_hosts_cb

		self._session:on_host_discovered(host, host_name, level_name, my_ip, state, difficulty)
		cb(host, host_name, level_name, my_ip, state, difficulty)
	end
end

-- Lines: 520 to 544
function NetworkManager:host_game()
	self:stop_network(true)
	self:start_network()

	if self._is_win32 then
		self.voice_chat:open()
	end

	self._session = HostNetworkSession:new()

	self._session:create_local_peer(true)

	if self.is_ps3 then
		self._session:broadcast_server_up()
	end
end

-- Lines: 548 to 555
function NetworkManager:join_game_at_host_rpc(host_rpc, result_cb)
	self._discover_hosts_cb = nil

	if self._session then
		self._session:request_join_host(host_rpc, result_cb)
	else
		print("[NetworkManager:join_game_at_host_rpc] no session!!!")
	end
end

-- Lines: 559 to 562
function NetworkManager:register_spawn_point(id, data)
	local runtime_data = {
		pos_rot = {
			data.position,
			data.rotation
		},
		id = id
	}
	self._spawn_points[id] = runtime_data
end

-- Lines: 566 to 568
function NetworkManager:unregister_spawn_point(id)
	self._spawn_points[id] = nil
end

-- Lines: 572 to 574
function NetworkManager:unregister_all_spawn_points()
	self._spawn_points = {}
end

-- Lines: 578 to 579
function NetworkManager:has_spawn_points()
	return next(self._spawn_points)
end

-- Lines: 584 to 585
function NetworkManager:spawn_point(sp_id)
	return self._spawn_points[sp_id]
end

-- Lines: 590 to 614
function NetworkManager:_register_PSN_matchmaking_callbacks()
	local gen_clbk = callback(self, self, "clbk_PSN_event")

	PSN:set_matchmaking_callback("session_destroyed", gen_clbk)
	PSN:set_matchmaking_callback("session_created", gen_clbk)
	PSN:set_matchmaking_callback("session_kickout", gen_clbk)
	PSN:set_matchmaking_callback("member_left", gen_clbk)
	PSN:set_matchmaking_callback("member_joined", gen_clbk)
	PSN:set_matchmaking_callback("owner_changed", gen_clbk)
	PSN:set_matchmaking_callback("server_ready", gen_clbk)
	PSN:set_matchmaking_callback("lobby_refresh", gen_clbk)
	PSN:set_matchmaking_callback("lobby_joined", gen_clbk)
	PSN:set_matchmaking_callback("lobby_left", gen_clbk)
	PSN:set_matchmaking_callback("friends_updated", gen_clbk)
	PSN:set_matchmaking_callback("receive_group_invitation", gen_clbk)
	PSN:set_matchmaking_callback("room_custom_info", gen_clbk)
	PSN:set_matchmaking_callback("invitation_received", gen_clbk)
	PSN:set_matchmaking_callback("invitation_received_result", gen_clbk)
	PSN:set_matchmaking_callback("invitation_gui_opened", gen_clbk)
	PSN:set_matchmaking_callback("invitation_gui_closed", gen_clbk)
	PSN:set_matchmaking_callback("connection_etablished", gen_clbk)
	PSN:set_matchmaking_callback("session_search", gen_clbk)
	PSN:set_matchmaking_callback("custom_message", gen_clbk)
	PSN:set_matchmaking_callback("session_update", gen_clbk)
	PSN:set_matchmaking_callback("error", gen_clbk)
end

-- Lines: 618 to 620
function NetworkManager:clbk_PSN_event(...)
	print("[NetworkManager:clbk_PSN_event]", inspect(...))
end

-- Lines: 624 to 632
function NetworkManager:search_ses()
	PSN:set_matchmaking_callback("session_search", callback(self, self, "clbk_search_session"))

	local search_params = {numbers = {
		1,
		3
	}}

	PSN:search_session(search_params, {}, PSN:get_world_list()[1].world_id)
end

-- Lines: 636 to 641
function NetworkManager:clbk_search_session(search_results)
	print("[NetworkManager:clbk_search_session]", search_results)

	for i, k in pairs(search_results) do
		print(i, k and inspect(k))
	end
end

-- Lines: 645 to 656
function NetworkManager.clbk_msg_overwrite(overwrite_data, msg_queue, ...)
	if msg_queue then
		if overwrite_data.index then
			msg_queue[overwrite_data.index] = {...}
		else
			table.insert(msg_queue, {...})

			overwrite_data.index = #msg_queue
		end
	else
		overwrite_data.index = nil
	end
end

-- Lines: 660 to 661
function NetworkManager:protocol_type()
	return self.PROTOCOL_TYPE
end

-- Lines: 666 to 670
function NetworkManager:set_packet_throttling_enabled(state)
	if self._session and self._is_win32 then
		self._session:set_packet_throttling_enabled(state)
	end
end

-- Lines: 674 to 698
function NetworkManager:on_peer_added(peer, peer_id)
	cat_print("multiplayer_base", "NetworkManager:on_peer_added", peer, peer_id)

	if managers.hud then
		managers.menu:get_menu("kit_menu").renderer:set_slot_joining(peer, peer_id)
	end

	if Network:is_server() then
		managers.network.matchmake:set_num_players(managers.network:session():amount_of_players())
	end

	if SystemInfo:platform() == Idstring("X360") or SystemInfo:platform() == Idstring("XB1") then
		managers.network.matchmake:on_peer_added(peer)
	end

	if managers.chat then
		managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("menu_chat_peer_added", {name = peer:name()}))
	end

	if managers.mutators then
		managers.mutators:on_peer_added(peer, peer_id)
	end

	if managers.statistics then
		peer:set_is_dropin(managers.statistics:has_session_started())
	end
end

