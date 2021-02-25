CivilianHeisterSound = CivilianHeisterSound or class(PlayerSound)

-- Lines 4-12
function CivilianHeisterSound:init(unit)
	self._unit = unit

	unit:base():post_init()

	local ss = self._unit:sound_source()

	ss:set_switch("int_ext", "third")
end

-- Lines 16-27
function CivilianHeisterSound:set_room_level(level)
	local level_switches = {
		"state_01",
		"state_02",
		"state_03"
	}
	local ss = self._unit:sound_source()

	ss:set_switch("safehouse_state", level_switches[level] or level_switches[1])
end

-- Lines 29-32
function CivilianHeisterSound:set_interactor_voice(interactor_voice)
	local ss = self._unit:sound_source()

	ss:set_switch("safehouse_toggle_robber", interactor_voice)
end

-- Lines 34-37
function CivilianHeisterSound:set_minigame_response(state)
	local ss = self._unit:sound_source()

	ss:set_switch("safehouse_minigame", state)
end

-- Lines 41-43
function CivilianHeisterSound:anim_clbk_play_sound(unit, queue_name)
	self:_play(queue_name)
end

-- Lines 47-54
function CivilianHeisterSound:anim_clbk_stop_sound(unit, source_name)
	if source_name and source_name == Idstring("") then
		self:stop()

		return
	end

	self:stop(source_name)
end

-- Lines 58-64
function CivilianHeisterSound:_play(sound_name, source_name)
	local source = nil

	if source_name then
		source = Idstring(source_name)
	end

	return self._unit:sound_source(source):post_event(sound_name, self.sound_callback, self._unit, "marker", "end_of_event")
end

-- Lines 68-78
function CivilianHeisterSound:sound_callback(instance, event_type, unit, sound_source, label, identifier, position)
	if not alive(unit) then
		return
	end

	if event_type == "end_of_event" and unit:interaction() and unit:interaction()._reenable_ext then
		unit:interaction():_reenable_ext()
	end
end
