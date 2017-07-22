BaseNetworkHandler = BaseNetworkHandler or class()
BaseNetworkHandler._gamestate_filter = {
	any_ingame = {
		ingame_incapacitated = true,
		ingame_bleed_out = true,
		ingame_clean = true,
		ingame_standard = true,
		ingame_waiting_for_respawn = true,
		ingame_waiting_for_spawn_allowed = true,
		ingame_electrified = true,
		ingame_fatal = true,
		ingame_mask_off = true,
		ingame_access_camera = true,
		ingame_driving = true,
		ingame_waiting_for_players = true,
		ingame_parachuting = true,
		ingame_arrested = true,
		ingame_civilian = true,
		ingame_freefall = true
	},
	any_ingame_playing = {
		ingame_incapacitated = true,
		ingame_bleed_out = true,
		ingame_clean = true,
		ingame_standard = true,
		ingame_waiting_for_respawn = true,
		ingame_waiting_for_spawn_allowed = true,
		ingame_electrified = true,
		ingame_fatal = true,
		ingame_mask_off = true,
		ingame_access_camera = true,
		ingame_driving = true,
		ingame_parachuting = true,
		ingame_freefall = true,
		ingame_arrested = true,
		ingame_civilian = true
	},
	downed = {
		ingame_incapacitated = true,
		ingame_bleed_out = true,
		ingame_fatal = true
	},
	need_revive = {
		ingame_incapacitated = true,
		ingame_arrested = true,
		ingame_bleed_out = true,
		ingame_fatal = true
	},
	arrested = {ingame_arrested = true},
	game_over = {gameoverscreen = true},
	any_end_game = {
		victoryscreen = true,
		gameoverscreen = true
	},
	waiting_for_players = {ingame_waiting_for_players = true},
	waiting_for_respawn = {ingame_waiting_for_respawn = true},
	waiting_for_spawn_allowed = {ingame_waiting_for_spawn_allowed = true},
	menu = {menu_main = true},
	player_slot = {
		ingame_lobby_menu = true,
		menu_main = true,
		ingame_waiting_for_players = true
	},
	lobby = {
		menu_main = true,
		ingame_lobby_menu = true
	}
}

-- Lines: 97 to 103
function BaseNetworkHandler._verify_in_session()
	local session = managers.network:session()

	if not session then
		print("[BaseNetworkHandler._verify_in_session] Discarding message")
		Application:stack_dump()
	end

	return session
end

-- Lines: 108 to 115
function BaseNetworkHandler._verify_in_server_session()
	local session = managers.network:session()
	session = session and session:is_host()

	if not session then
		print("[BaseNetworkHandler._verify_in_server_session] Discarding message")
		Application:stack_dump()
	end

	return session
end

-- Lines: 120 to 127
function BaseNetworkHandler._verify_in_client_session()
	local session = managers.network:session()
	session = session and session:is_client()

	if not session then
		print("[BaseNetworkHandler._verify_in_client_session] Discarding message")
		Application:stack_dump()
	end

	return session
end

-- Lines: 132 to 148
function BaseNetworkHandler._verify_sender(rpc)
	local session = managers.network:session()
	local peer = nil

	if session then
		peer = rpc:protocol_at_index(0) == "STEAM" and session:peer_by_user_id(rpc:ip_at_index(0)) or session:peer_by_ip(rpc:ip_at_index(0))

		if peer then
			return peer
		end
	end

	print("[BaseNetworkHandler._verify_sender] Discarding message", session, peer and peer:id())
	Application:stack_dump()
end

-- Lines: 152 to 153
function BaseNetworkHandler._verify_character_and_sender(unit, rpc)
	return BaseNetworkHandler._verify_sender(rpc) and BaseNetworkHandler._verify_character(unit)
end

-- Lines: 158 to 159
function BaseNetworkHandler._verify_character(unit)
	return alive(unit) and not unit:character_damage():dead()
end

-- Lines: 164 to 172
function BaseNetworkHandler._verify_gamestate(acceptable_gamestates)
	local correct_state = acceptable_gamestates[game_state_machine:last_queued_state_name()]

	if correct_state then
		return true
	end

	print("[BaseNetworkHandler._verify_gamestate] Discarding message. current state:", game_state_machine:last_queued_state_name(), "acceptable:", inspect(acceptable_gamestates))
	Application:stack_dump()
end

-- Lines: 176 to 214
function BaseNetworkHandler:_chk_flush_unit_too_early_packets(unit)
	if self._flushing_unit_too_early_packets then
		return
	end

	if not alive(unit) then
		return
	end

	local unit_id = unit:id()

	if unit_id == -1 then
		return
	end

	if not self._unit_too_early_queue then
		return
	end

	local unit_rpcs = self._unit_too_early_queue[unit_id]

	if not unit_rpcs then
		return
	end

	print("[BaseNetworkHandler:_chk_flush_unit_too_early_packets]", unit_id)

	self._flushing_unit_too_early_packets = true

	for _, rpc_info in ipairs(unit_rpcs) do
		print(" calling", rpc_info.fun_name)

		rpc_info.params[rpc_info.unit_param_index] = unit

		self[rpc_info.fun_name](self, unpack(rpc_info.params))
	end

	self._unit_too_early_queue[unit_id] = nil

	if not next(self._unit_too_early_queue) then
		self._unit_too_early_queue = nil
	end

	self._flushing_unit_too_early_packets = nil
end

-- Lines: 218 to 242
function BaseNetworkHandler:_chk_unit_too_early(unit, unit_id_str, fun_name, unit_param_index, ...)
	if self._flushing_unit_too_early_packets then
		return
	end

	if alive(unit) then
		return
	end

	if not self._unit_too_early_queue then
		self._unit_too_early_queue = {}
	end

	local data = {
		unit_param_index = unit_param_index,
		fun_name = fun_name,
		params = {...}
	}
	local unit_id = tonumber(unit_id_str)
	self._unit_too_early_queue[unit_id] = self._unit_too_early_queue[unit_id] or {}

	table.insert(self._unit_too_early_queue[unit_id], data)
	print("[BaseNetworkHandler:_chk_unit_too_early]", unit_id_str, fun_name)

	return true
end

return
