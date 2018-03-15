NetworkVoiceChatPSN = NetworkVoiceChatPSN or class()

-- Lines: 29 to 41
function NetworkVoiceChatPSN:init()
	self._started = false
	self._room_id = nil
	self._team = 1
	self._restart_session = nil
	self._peers = {}

	self:_load_globals()

	self._muted_players = {}
end

-- Lines: 43 to 44
function NetworkVoiceChatPSN:check_status_information()
end

-- Lines: 46 to 47
function NetworkVoiceChatPSN:open()
end

-- Lines: 49 to 50
function NetworkVoiceChatPSN:voice_type()
	return "voice_psn"
end

-- Lines: 53 to 54
function NetworkVoiceChatPSN:pause()
end

-- Lines: 56 to 57
function NetworkVoiceChatPSN:resume()
end

-- Lines: 59 to 61
function NetworkVoiceChatPSN:set_volume(volume)
	PSNVoice:set_volume(volume)
end

-- Lines: 63 to 71
function NetworkVoiceChatPSN:init_voice()
	if self._started == false and not self._starting then
		self._starting = true

		PSNVoice:assign_callback(function (...)
			self:_callback(...)
		end)
		PSNVoice:init(4, 4, 50, 16000)

		self._started = true
	end
end

-- Lines: 72 to 87
function NetworkVoiceChatPSN:destroy_voice(disconnected)
	if self._started == true then
		self._started = false

		if self._room_id and not disconnected then
			self:close_session()
		end

		PSNVoice:destroy()

		self._closing = nil
		self._room_id = nil
		self._restart_session = nil
		self._team = 1
	end
end

-- Lines: 89 to 100
function NetworkVoiceChatPSN:num_peers()
	local l = PSNVoice:get_players_info()

	if l then
		local x = 0

		for k, v in pairs(l) do
			if v.joined == 1 then
				x = x + 1
			end
		end

		return #l <= x
	end

	return true
end

-- Lines: 103 to 135
function NetworkVoiceChatPSN:open_session(roomid)
	print("[VOICECHAT] NetworkVoiceChatPSN:open_session( ", roomid, " ) self._room_id: ", self._room_id, "self._restart_session: ", self._restart_session)

	if self._room_id and self._room_id == roomid then
		print("Voice: same_room")

		return
	end

	if self._restart_session and self._restart_session == roomid then
		print("Voice: restart")

		return
	end

	if self._closing or self._joining then
		print("Voice: closing|joining")

		self._restart_session = roomid

		return
	end

	if self._started == false then
		self._restart_session = roomid

		self:init_voice()
	end

	if self._room_id then
		print("Voice: restart room")

		return
	end

	self._room_id = roomid
	self._joining = true

	PSNVoice:start_session(roomid)
end

-- Lines: 137 to 158
function NetworkVoiceChatPSN:close_session()
	print("[VOICECHAT] NetworkVoiceChatPSN:close_session() see following stack dump")

	if self._joining then
		self._close = true

		return
	end

	if self._room_id and not self._closing then
		self._closing = true

		if not PSNVoice:stop_session() then
			self._closing = nil
			self._room_id = nil
			self._delay_frame = TimerManager:wall():time() + 1
		end
	elseif not self._closing then
		self._restart_session = nil
		self._delay_frame = nil
	end
end

-- Lines: 160 to 163
function NetworkVoiceChatPSN:open_channel_to(player_info, context)
	print("[VOICECHAT] NetworkVoiceChatPSN:open_channel_to")
end

-- Lines: 165 to 169
function NetworkVoiceChatPSN:close_channel_to(player_info)
	print("[VOICECHAT] NetworkVoiceChatPSN:close_channel_to")
	PSNVoice:stop_sending_to(player_info._name)
end

-- Lines: 171 to 172
function NetworkVoiceChatPSN:lost_peer(peer)
end

-- Lines: 174 to 182
function NetworkVoiceChatPSN:close_all()
	print("[VOICECHAT] NetworkVoiceChatPSN:close_all() see following stack dump")

	if self._room_id then
		self:close_session()
	end

	self._room_id = nil
	self._closing = nil
end

-- Lines: 184 to 190
function NetworkVoiceChatPSN:set_team(team)
	if self._room_id then
		PSN:change_team(self._room_id, PSN:get_local_userid(), team)
		PSNVoice:set_team_target(team)
	end

	self._team = team
end

-- Lines: 193 to 199
function NetworkVoiceChatPSN:clear_team()
	if self._room_id and PSN:get_local_userid() then
		PSN:change_team(self._room_id, PSN:get_local_userid(), 1)
		PSNVoice:set_team_target(1)

		self._team = 1
	end
end

-- Lines: 204 to 206
function NetworkVoiceChatPSN:set_drop_in(data)
	self._drop_in = data
end

-- Lines: 208 to 235
function NetworkVoiceChatPSN:_load_globals()
	if Global.psn and Global.psn.voice then
		self._started = Global.psn.voice.started
	end

	if PSN:is_online() and Global.psn and Global.psn.voice then
		PSNVoice:assign_callback(function (...)
		end)

		self._room_id = Global.psn.voice.room
		self._team = Global.psn.voice.team

		if Global.psn.voice.drop_in then
			self:open_session(Global.psn.voice.drop_in.room_id)
		end

		if Global.psn.voice.restart then
			self._restart_session = restart
			self._delay_frame = TimerManager:wall():time() + 2
		else
			PSNVoice:assign_callback(function (...)
				self:_callback(...)
			end)

			if self._room_id then
				self:set_team(self._team)
			end
		end

		Global.psn.voice = nil
	end
end

-- Lines: 236 to 265
function NetworkVoiceChatPSN:_save_globals(disable_voice)
	if disable_voice == nil then
		return
	end

	if not Global.psn then
		Global.psn = {}
	end


	-- Lines: 244 to 245
	local function f(...)
	end

	PSNVoice:assign_callback(f)

	Global.psn.voice = {}
	Global.psn.voice.started = self._started
	Global.psn.voice.drop_in = self._drop_in

	if type(disable_voice) == "boolean" then
		if disable_voice == true then
			Global.psn.voice.room = self._room_id
			Global.psn.voice.team = self._team
		else
			Global.psn.voice.team = 1
		end
	else
		self:close_all()

		Global.psn.voice.restart = disable_voice
		Global.psn.voice.team = 1
	end
end

-- Lines: 268 to 269
function NetworkVoiceChatPSN:enabled()
	return managers.user:get_setting("voice_chat")
end

-- Lines: 273 to 284
function NetworkVoiceChatPSN:update_settings()
	self._push_to_talk = managers.user:get_setting("push_to_talk")
	self._enabled = managers.user:get_setting("voice_chat")

	if self._enabled then
		PSNVoice:start_recording()
	else
		PSNVoice:stop_recording()
	end

	if self._enabled and self._push_to_talk then
		PSNVoice:stop_recording()
	end
end

-- Lines: 287 to 308
function NetworkVoiceChatPSN:set_recording(button_pushed_to_talk)
	self:update_settings()

	if not self._enabled then
		PSNVoice:stop_recording()

		return
	end

	if not self._push_to_talk then
		if self._enabled then
			PSNVoice:start_recording()
		else
			PSNVoice:stop_recording()
		end
	elseif button_pushed_to_talk then
		PSNVoice:start_recording()
	else
		PSNVoice:stop_recording()
	end
end

-- Lines: 311 to 312
function NetworkVoiceChatPSN:enabled()
	return managers.user:get_setting("voice_chat")
end

-- Lines: 317 to 333
function NetworkVoiceChatPSN:update_settings()
	self._push_to_talk = false
	self._enabled = managers.user:get_setting("voice_chat")

	print("GN: Update settings")

	if self._enabled then
		PSNVoice:start_recording()
		PSNVoice:set_enable(true)
		print("GN: Voice chat set to true 1")
	else
		PSNVoice:stop_recording()
		PSNVoice:set_enable(false)
		print("GN: Voice chat set to false 1")
	end

	if self._enabled and self._push_to_talk then
		PSNVoice:stop_recording()
	end
end

-- Lines: 336 to 357
function NetworkVoiceChatPSN:set_recording(button_pushed_to_talk)
	self:update_settings()

	if not self._enabled then
		PSNVoice:stop_recording()

		return
	end

	if not self._push_to_talk then
		if self._enabled then
			PSNVoice:start_recording()
		else
			PSNVoice:stop_recording()
		end
	elseif button_pushed_to_talk then
		PSNVoice:start_recording()
	else
		PSNVoice:stop_recording()
	end
end

-- Lines: 359 to 400
function NetworkVoiceChatPSN:_callback(info)
	if info and PSN:get_local_userid() then
		if info.load_succeeded ~= nil then
			self._starting = nil

			if info.load_succeeded then
				self._started = true
				self._delay_frame = TimerManager:wall():time() + 1
			end

			return
		end

		if info.join_succeeded ~= nil then
			self._joining = nil

			if info.join_succeeded == false then
				self._room_id = nil
			else
				self:set_team(self._team)
			end

			if self._restart_session then
				self._delay_frame = TimerManager:wall():time() + 1
			end

			if self._close then
				self._close = nil

				self:close_session()
			end
		end

		if info.leave_succeeded ~= nil then
			self._closing = nil
			self._room_id = nil

			if self._restart_session then
				self._delay_frame = TimerManager:wall():time() + 1
			end
		end

		if info.unload_succeeded ~= nil then

			-- Lines: 395 to 396
			local function f(...)
			end

			PSNVoice:assign_callback(f)
		end
	end
end

-- Lines: 402 to 412
function NetworkVoiceChatPSN:update()
	if self._delay_frame and self._delay_frame < TimerManager:wall():time() then
		self._delay_frame = nil

		if self._restart_session then
			PSNVoice:assign_callback(function (...)
				self:_callback(...)
			end)

			local r = self._restart_session
			self._restart_session = nil

			self:open_session(r)
		end
	end
end

-- Lines: 444 to 445
function NetworkVoiceChatPSN:voice_ui_update_callback(user_info)
end

-- Lines: 447 to 454
function NetworkVoiceChatPSN:psn_session_destroyed(roomid)
	print("[VOICECHAT] NetworkVoiceChatPSN:psn_session_destroyed() see following stack dump")

	if self._room_id and self._room_id == roomid then
		self._room_id = nil
		self._closing = nil
	end
end

-- Lines: 457 to 470
function NetworkVoiceChatPSN:_get_peer_user_id(peer)
	if not self._room_id then
		return
	end

	local members = PSN:get_info_session(self._room_id).memberlist
	local name = peer:name()

	for i, member in ipairs(members) do
		if tostring(member.user_id) == name then
			return member.user_id
		end
	end
end

-- Lines: 473 to 477
function NetworkVoiceChatPSN:on_member_added(peer, mute)
	if peer:rpc() then
		PSNVoice:on_member_added(peer:name(), peer:rpc(), mute)
	end
end

-- Lines: 480 to 482
function NetworkVoiceChatPSN:on_member_removed(peer)
	PSNVoice:on_member_removed(peer:name())
end

-- Lines: 484 to 494
function NetworkVoiceChatPSN:mute_player(mute, peer)
	self._muted_players[peer:name()] = mute

	PSNVoice:mute_player(mute, peer:name())
end

-- Lines: 497 to 498
function NetworkVoiceChatPSN:is_muted(peer)
	return self._muted_players[peer:name()] or false
end

