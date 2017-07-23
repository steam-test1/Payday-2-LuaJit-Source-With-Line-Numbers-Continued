NetworkVoiceChatDisabled = NetworkVoiceChatDisabled or class()

-- Lines: 13 to 23
function NetworkVoiceChatDisabled:init(quiet)
	self._quiet = quiet or false

	if self._quiet then
		cat_print("lobby", "Voice is quiet.")
	else
		cat_print("lobby", "Voice is disabled.")
	end
end

-- Lines: 26 to 27
function NetworkVoiceChatDisabled:check_status_information()
end

-- Lines: 29 to 30
function NetworkVoiceChatDisabled:open()
end

-- Lines: 32 to 33
function NetworkVoiceChatDisabled:set_volume(volume)
end

-- Lines: 35 to 41
function NetworkVoiceChatDisabled:voice_type()
	if self._quiet == true then
		return "voice_quiet"
	else
		return "voice_disabled"
	end
end

-- Lines: 43 to 44
function NetworkVoiceChatDisabled:set_drop_in(data)
end

-- Lines: 46 to 47
function NetworkVoiceChatDisabled:pause()
end

-- Lines: 49 to 50
function NetworkVoiceChatDisabled:resume()
end

-- Lines: 52 to 53
function NetworkVoiceChatDisabled:init_voice()
end

-- Lines: 54 to 55
function NetworkVoiceChatDisabled:destroy_voice()
end

-- Lines: 57 to 58
function NetworkVoiceChatDisabled:num_peers()
	return true
end

-- Lines: 61 to 62
function NetworkVoiceChatDisabled:open_session(roomid)
end

-- Lines: 64 to 65
function NetworkVoiceChatDisabled:close_session()
end

-- Lines: 68 to 69
function NetworkVoiceChatDisabled:open_channel_to(player_info, context)
end

-- Lines: 71 to 72
function NetworkVoiceChatDisabled:close_channel_to(player_info)
end

-- Lines: 74 to 75
function NetworkVoiceChatDisabled:lost_peer(peer)
end

-- Lines: 77 to 78
function NetworkVoiceChatDisabled:close_all()
end

-- Lines: 80 to 81
function NetworkVoiceChatDisabled:set_team(team)
end

-- Lines: 83 to 84
function NetworkVoiceChatDisabled:peer_team(xuid, team, rpc)
end

-- Lines: 88 to 89
function NetworkVoiceChatDisabled:_open_close_peers()
end

-- Lines: 91 to 92
function NetworkVoiceChatDisabled:mute_player(mute, peer)
end

-- Lines: 94 to 95
function NetworkVoiceChatDisabled:update()
end

-- Lines: 97 to 98
function NetworkVoiceChatDisabled:_load_globals()
end

-- Lines: 99 to 100
function NetworkVoiceChatDisabled:_save_globals(disable_voice)
end

-- Lines: 102 to 122
function NetworkVoiceChatDisabled:_display_warning()
	if self._quiet == false and self:_have_displayed_warning() == true then
		managers.menu:show_err_no_chat_parental_control()
	end
end

-- Lines: 123 to 130
function NetworkVoiceChatDisabled:_have_displayed_warning()
	if Global.psn_parental_voice and Global.psn_parental_voice == true then
		return false
	end

	Global.psn_parental_voice = true

	return true
end

-- Lines: 135 to 136
function NetworkVoiceChatDisabled:clear_team()
end

-- Lines: 141 to 145
function NetworkVoiceChatDisabled:psn_session_destroyed()
	if Global.psn and Global.psn.voice then
		Global.psn.voice.restart = nil
	end
end

