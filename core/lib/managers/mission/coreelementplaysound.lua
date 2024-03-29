core:module("CoreElementPlaySound")
core:import("CoreMissionScriptElement")

ElementPlaySound = ElementPlaySound or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-8
function ElementPlaySound:init(...)
	ElementPlaySound.super.init(self, ...)
end

-- Lines 10-14
function ElementPlaySound:on_script_activated()
	if Network:is_server() then
		self._mission_script:add_save_state_cb(self._id)
	end
end

-- Lines 16-18
function ElementPlaySound:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 20-52
function ElementPlaySound:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._source and self:value("interrupt") ~= false then
		self._source:stop()
	end

	if self._values.use_instigator then
		if Network:is_server() and alive(instigator) and instigator:id() ~= -1 then
			if self._values.use_play_func then
				instigator:sound():play(self._values.sound_event, nil, true)
			else
				instigator:sound():say(self._values.sound_event, true, not self._values.append_prefix, true)
			end
		end
	elseif not self._values.elements or #self._values.elements == 0 then
		self:_play_sound()
	elseif Network:is_server() then
		self:_play_sound_on_elements()
	end

	ElementPlaySound.super.on_executed(self, instigator)
end

-- Lines 54-73
function ElementPlaySound:_play_sound_on_elements()
	-- Lines 55-67
	local function f(unit)
		if unit:id() ~= -1 then
			if self._values.use_play_func then
				unit:sound():play(self._values.sound_event, nil, true)
			else
				unit:sound():say(self._values.sound_event, true, not self._values.append_prefix, true)
			end
		end
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:execute_on_all_units(f)
	end
end

-- Lines 75-89
function ElementPlaySound:_play_sound()
	if self._values.sound_event then
		if self._source then
			self._source:stop()
		end

		self._source = SoundDevice:create_source(self._editor_name)

		self._source:set_position(self._values.position)
		self._source:set_orientation(self._values.rotation)

		if self._source:post_event(self._values.sound_event, callback(self, self, "sound_ended"), nil, "end_of_event") then
			self._playing_sound = true
		end
	elseif Application:editor() then
		managers.editor:output_error("Cant play sound event nil [" .. self._editor_name .. "]")
	end
end

-- Lines 91-93
function ElementPlaySound:sound_ended(...)
	self._playing_sound = nil
end

-- Lines 95-100
function ElementPlaySound:operation_remove()
	if self._source then
		self._source:stop()
		self:sound_ended()
	end
end

-- Lines 102-105
function ElementPlaySound:save(data)
	data.enabled = self._values.enabled
	data.was_playing_sound = self._playing_sound
end

-- Lines 107-115
function ElementPlaySound:load(data)
	self:set_enabled(data.enabled)

	if data.was_playing_sound then
		self:_play_sound()
	end
end

-- Lines 117-122
function ElementPlaySound:stop_simulation()
	if self._source then
		self._source:stop()
	end

	ElementPlaySound.super.stop_simulation(self)
end

-- Lines 124-129
function ElementPlaySound:pre_destroy()
	if self._source then
		self._source:stop()
		self:sound_ended()
	end
end

-- Lines 131-138
function ElementPlaySound:destroy()
	if self._source then
		self._source:stop()
		self._source:delete()

		self._source = nil

		self:sound_ended()
	end
end
