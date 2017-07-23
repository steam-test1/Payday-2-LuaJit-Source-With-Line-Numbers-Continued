WaitManager = WaitManager or class()

-- Lines: 4 to 9
function WaitManager:init()
	self._waiting = {}
	self._allowed_spawn = {}
	self._last_whisper_mode = true
end

-- Lines: 11 to 24
function WaitManager:update(...)
	if Network:is_client() or Global.game_settings.drop_in_option ~= 3 then
		return
	end

	local whisper_mode = managers.groupai:state():whisper_mode()

	if self._last_whisper_mode ~= whisper_mode then
		self._last_whisper_mode = whisper_mode

		if whisper_mode == false then
			self:spawn_all_waiting()
		end
	end
end

-- Lines: 26 to 29
function WaitManager:clear_peer(peer_id)
	self._waiting[peer_id] = nil
	self._allowed_spawn[peer_id] = nil
end

-- Lines: 32 to 39
function WaitManager:check_if_waiting_needed()
	if Global.game_settings.drop_in_option == 2 then
		return true
	elseif Global.game_settings.drop_in_option == 3 then
		return managers.groupai:state() and managers.groupai:state():whisper_mode()
	end

	return false
end

-- Lines: 42 to 45
function WaitManager:add_waiting(peer_id)
	self._waiting[peer_id] = true

	managers.hud:add_waiting(peer_id)
end

-- Lines: 47 to 50
function WaitManager:remove_waiting(peer_id)
	self._waiting[peer_id] = nil

	managers.hud:remove_waiting(peer_id)
end

-- Lines: 52 to 53
function WaitManager:is_waiting(peer_id)
	return self._waiting[peer_id]
end

-- Lines: 57 to 58
function WaitManager:check_waiting_allowed_spawn(peer_id)
	return self._allowed_spawn[peer_id]
end

-- Lines: 61 to 79
function WaitManager:spawn_waiting(peer_id)
	if not Network:is_server() then
		return
	end

	self._allowed_spawn[peer_id] = true

	self:remove_waiting(peer_id)

	local peer = managers.network:session():peer(peer_id)

	if not peer then
		return
	end

	managers.achievment:set_script_data("cant_touch_fail", true)
	peer:spawn_unit(0, true)
	managers.groupai:state():fill_criminal_team_with_AI(true)
end

-- Lines: 81 to 90
function WaitManager:kick_to_briefing(peer_id)
	self:remove_waiting(peer_id)

	local peer = managers.network:session():peer(peer_id)

	if not Network:is_server() or not peer then
		return
	end

	managers.network:session():send_to_peer(peer, "kick_to_briefing")
end

-- Lines: 92 to 98
function WaitManager:spawn_all_waiting()
	self._waiting = self._waiting or {}

	for peer_id, waiting in pairs(self._waiting) do
		self:spawn_waiting(peer_id)
	end
end

-- Lines: 100 to 105
function WaitManager:list_of_waiting()
	local rtn = {}

	for peer_id, _ in pairs(self._waiting) do
		table.insert(rtn, peer_id)
	end

	return rtn
end

