CoreMusicManager = CoreMusicManager or class()

-- Lines 3-56
function CoreMusicManager:init()
	if not Global.music_manager then
		Global.music_manager = {}
		Global.music_manager.source = SoundDevice:create_source("music")
		Global.music_manager.volume = 0

		self:init_globals()
	end

	self._path_list = {}
	self._path_map = {}
	self._event_map = {}

	local temp_list = {}

	if Application:editor() then
		local music_tracks = self:music_tracks()

		for _, track in pairs(music_tracks) do
			local events = PackageManager:has(Idstring("bnk"), Idstring(track)) and SoundDevice:events(track)

			if events then
				for k, v in pairs(events) do
					if not temp_list[v.path] then
						temp_list[v.path] = 1

						table.insert(self._path_list, v.path)
					end

					self._path_map[k] = v.path

					if not self._event_map[v.path] then
						self._event_map[v.path] = {}
					end

					table.insert(self._event_map[v.path], k)
				end
			end
		end

		table.sort(self._path_list)

		for k, v in pairs(self._event_map) do
			table.sort(v)
		end
	end

	self._has_music_control = true
	self._external_media_playing = false
end

-- Lines 58-60
function CoreMusicManager:init_finalize()
	managers.savefile:add_load_sequence_done_callback_handler(callback(self, self, "on_load_complete"))
end

-- Lines 62-63
function CoreMusicManager:init_globals()
	return
end

-- Lines 65-67
function CoreMusicManager:music_tracks()
	return {}
end

-- Lines 69-79
function CoreMusicManager:check_music_switch()
	local switches = tweak_data.levels:get_music_switches()

	if switches and #switches > 0 then
		Global.music_manager.current_track = switches[math.random(#switches)]

		print("CoreMusicManager:check_music_switch()", Global.music_manager.current_track)
		Global.music_manager.source:set_switch("music_randomizer", Global.music_manager.current_track)
	end
end

-- Lines 81-94
function CoreMusicManager:post_event(name)
	if not name then
		return
	end

	if Global.music_manager.current_event ~= name then
		if not self._skip_play then
			Global.music_manager.source:post_event(name)
		end

		Global.music_manager.current_event = name
	end
end

-- Lines 98-101
function CoreMusicManager:stop()
	Global.music_manager.source:stop()

	Global.music_manager.current_event = nil
end

-- Lines 103-105
function CoreMusicManager:music_paths()
	return self._path_list
end

-- Lines 107-109
function CoreMusicManager:music_events(path)
	return self._event_map[path]
end

-- Lines 111-113
function CoreMusicManager:music_path(event)
	return self._path_map[event]
end

-- Lines 116-123
function CoreMusicManager:set_volume(volume)
	Global.music_manager.volume = volume

	if self._has_music_control then
		SoundDevice:set_rtpc("option_music_volume", volume * 100)
	else
		SoundDevice:set_rtpc("option_music_volume", 0)
	end
end

-- Lines 126-135
function CoreMusicManager:clbk_game_has_music_control(status)
	print("[CoreMusicManager:clbk_game_has_music_control]", status)

	if status then
		SoundDevice:set_rtpc("option_music_volume", Global.music_manager.volume * 100)
	else
		SoundDevice:set_rtpc("option_music_volume", 0)
	end

	self._has_music_control = status
end

-- Lines 137-139
function CoreMusicManager:on_load_complete()
	self:set_volume(managers.user:get_setting("music_volume") / 100)
end

-- Lines 141-143
function CoreMusicManager:has_music_control()
	return self._has_music_control
end

-- Lines 146-156
function CoreMusicManager:save(data)
	local state = {}

	if game_state_machine:current_state_name() ~= "ingame_waiting_for_players" then
		state.event = Global.music_manager.current_event
	end

	state.track = Global.music_manager.current_track
	data.CoreMusicManager = state
end

-- Lines 158-165
function CoreMusicManager:load(data)
	local state = data.CoreMusicManager

	if state.event then
		self:post_event(state.event)
	end

	Global.music_manager.synced_track = state.track
end
