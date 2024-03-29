NetworkVoiceChatDisabled = NetworkVoiceChatDisabled or class()

-- Lines 13-23
function NetworkVoiceChatDisabled:init(quiet)
	self._quiet = quiet or false

	if self._quiet then
		cat_print("lobby", "Voice is quiet.")
	else
		cat_print("lobby", "Voice is disabled.")
	end
end

-- Lines 25-27
function NetworkVoiceChatDisabled:check_status_information()
end

-- Lines 29-30
function NetworkVoiceChatDisabled:open()
end

-- Lines 32-33
function NetworkVoiceChatDisabled:set_volume(volume)
end

-- Lines 35-41
function NetworkVoiceChatDisabled:voice_type()
	if self._quiet == true then
		return "voice_quiet"
	else
		return "voice_disabled"
	end
end

-- Lines 43-44
function NetworkVoiceChatDisabled:set_drop_in(data)
end

-- Lines 46-47
function NetworkVoiceChatDisabled:pause()
end

-- Lines 49-50
function NetworkVoiceChatDisabled:resume()
end

-- Lines 52-53
function NetworkVoiceChatDisabled:init_voice()
end

-- Lines 54-55
function NetworkVoiceChatDisabled:destroy_voice()
end

-- Lines 57-59
function NetworkVoiceChatDisabled:num_peers()
	return true
end

-- Lines 61-62
function NetworkVoiceChatDisabled:open_session(roomid)
end

-- Lines 64-65
function NetworkVoiceChatDisabled:close_session()
end

-- Lines 67-69
function NetworkVoiceChatDisabled:open_channel_to(player_info, context)
end

-- Lines 71-72
function NetworkVoiceChatDisabled:close_channel_to(player_info)
end

-- Lines 74-75
function NetworkVoiceChatDisabled:lost_peer(peer)
end

-- Lines 77-78
function NetworkVoiceChatDisabled:close_all()
end

-- Lines 80-81
function NetworkVoiceChatDisabled:set_team(team)
end

-- Lines 83-84
function NetworkVoiceChatDisabled:peer_team(xuid, team, rpc)
end

-- Lines 86-87
function NetworkVoiceChatDisabled:enabled()
end

-- Lines 89-90
function NetworkVoiceChatDisabled:set_recording()
end

-- Lines 92-93
function NetworkVoiceChatDisabled:on_member_added()
end

-- Lines 95-96
function NetworkVoiceChatDisabled:on_member_removed()
end

-- Lines 98-99
function NetworkVoiceChatDisabled:is_muted()
end

-- Lines 103-104
function NetworkVoiceChatDisabled:_open_close_peers()
end

-- Lines 106-107
function NetworkVoiceChatDisabled:mute_player(mute, peer)
end

-- Lines 109-110
function NetworkVoiceChatDisabled:update()
end

-- Lines 112-113
function NetworkVoiceChatDisabled:_load_globals()
end

-- Lines 114-115
function NetworkVoiceChatDisabled:_save_globals(disable_voice)
end

-- Lines 117-137
function NetworkVoiceChatDisabled:_display_warning()
	if self._quiet == false and self:_have_displayed_warning() == true then
		managers.menu:show_err_no_chat_parental_control()
	end
end

-- Lines 138-146
function NetworkVoiceChatDisabled:_have_displayed_warning()
	if Global.psn_parental_voice and Global.psn_parental_voice == true then
		return false
	end

	Global.psn_parental_voice = true

	return true
end

-- Lines 149-151
function NetworkVoiceChatDisabled:clear_team()
end

-- Lines 156-160
function NetworkVoiceChatDisabled:psn_session_destroyed()
	if Global.psn and Global.psn.voice then
		Global.psn.voice.restart = nil
	end
end
