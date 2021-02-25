UnoPuzzleDoorBase = UnoPuzzleDoorBase or class(UnitBase)
UnoPuzzleDoorBase.RIDDLE_COUNT = 4

-- Lines 5-27
function UnoPuzzleDoorBase:init(unit)
	UnoPuzzleDoorBase.super.init(self, unit, true)

	self._outer = UnoPuzzleDoorRing:new(unit:get_object(Idstring("a_outer_ring")), 26)
	self._middle = UnoPuzzleDoorRing:new(unit:get_object(Idstring("a_middle_ring")), 26)
	self._inner = UnoPuzzleDoorRing:new(unit:get_object(Idstring("a_inner_ring")), 26)
	local riddle_ids = {}

	for i = 1, #tweak_data.safehouse.uno_door_riddles do
		riddle_ids[i] = i
	end

	table.shuffle(riddle_ids)

	for i = UnoPuzzleDoorBase.RIDDLE_COUNT + 1, #riddle_ids do
		riddle_ids[i] = nil
	end

	self._riddle_ids = riddle_ids
	self._rings_moving = false
	self._sound_source = self._unit:sound_source(Idstring("snd"))
end

-- Lines 29-32
function UnoPuzzleDoorBase:init_puzzle()
	UnoPuzzleDoorBase.puzzle_initialized = true

	self:set_riddle(1)
end

-- Lines 34-57
function UnoPuzzleDoorBase:update(unit, t, dt)
	if not self._current_riddle then
		return
	end

	self._unit:set_moving()

	local rotating = false
	rotating = self._outer:update(t, dt) or rotating
	rotating = self._middle:update(t, dt) or rotating
	rotating = self._inner:update(t, dt) or rotating

	if rotating ~= self._rings_moving then
		local sound_event = rotating and "uno_door_puzzle_rotate_start" or "uno_door_puzzle_rotate_stop"

		self._sound_source:post_event(sound_event)

		self._rings_moving = rotating
	end
end

-- Lines 59-61
function UnoPuzzleDoorBase:save(data)
	data.puzzle_door_riddles = self._riddle_ids
end

-- Lines 63-65
function UnoPuzzleDoorBase:load(data)
	self._riddle_ids = data.puzzle_door_riddles
end

-- Lines 67-77
function UnoPuzzleDoorBase:set_riddle(current_riddle)
	if current_riddle == self._current_riddle then
		return
	end

	local riddle_id = self._riddle_ids[current_riddle]
	self._current_riddle = current_riddle
	self._solution = tweak_data.safehouse.uno_door_riddles[riddle_id]

	self._unit:damage():run_sequence_simple("set_riddle_seq_" .. current_riddle)
	self._unit:damage():run_sequence_simple("set_riddle_" .. riddle_id)
end

-- Lines 79-102
function UnoPuzzleDoorBase:submit_answer()
	local stops = {
		self._outer:current_stop(),
		self._middle:current_stop(),
		self._inner:current_stop()
	}
	local submitted_key = string.join(":", stops):key()
	local success = submitted_key == self._solution

	self._unit:damage():run_sequence_simple(success and "answer_success" or "answer_fail")

	if not success then
		self:set_riddle(1)

		return
	end

	local all_done = self._current_riddle == self.RIDDLE_COUNT

	if all_done then
		self._unit:damage():run_sequence_simple("all_riddles_solved")
	else
		self:set_riddle(self._current_riddle + 1)
	end
end

-- Lines 104-109
function UnoPuzzleDoorBase:revive_player()
	local player = managers.player:player_unit()

	if player and player:character_damage():need_revive() then
		player:character_damage():revive(true)
	end
end

-- Lines 111-111
function UnoPuzzleDoorBase:turn_outer_cw()
	self._outer:turn_clockwise()
end

-- Lines 112-112
function UnoPuzzleDoorBase:turn_outer_ccw()
	self._outer:turn_counterclockwise()
end

-- Lines 114-114
function UnoPuzzleDoorBase:turn_middle_cw()
	self._middle:turn_clockwise()
end

-- Lines 115-115
function UnoPuzzleDoorBase:turn_middle_ccw()
	self._middle:turn_counterclockwise()
end

-- Lines 117-117
function UnoPuzzleDoorBase:turn_inner_cw()
	self._inner:turn_clockwise()
end

-- Lines 118-118
function UnoPuzzleDoorBase:turn_inner_ccw()
	self._inner:turn_counterclockwise()
end

UnoPuzzleDoorRing = UnoPuzzleDoorRing or class()
UnoPuzzleDoorRing.SPEED = 10
UnoPuzzleDoorRing.EPSILON = 0.0001

-- Lines 148-153
function UnoPuzzleDoorRing:init(ring_object, stops)
	self._object = ring_object
	self._stops = stops
	self._current_stop = 0
	self._target = Rotation()
end

-- Lines 155-165
function UnoPuzzleDoorRing:update(t, dt)
	local rotation = self._object:local_rotation()
	local diff = Rotation:rotation_difference(rotation, self._target)
	local max_rotation = dt * self.SPEED
	local angle = math.clamp(diff:roll(), -max_rotation, max_rotation)

	self._object:set_local_rotation(rotation * Rotation(Vector3(0, 1, 0), angle))

	return self.EPSILON < math.abs(angle)
end

-- Lines 167-169
function UnoPuzzleDoorRing:current_stop()
	return self._current_stop
end

-- Lines 171-174
function UnoPuzzleDoorRing:_target_stop(stop)
	local angle = 360 / self._stops * stop
	self._target = Rotation(Vector3(0, 1, 0), angle)
end

-- Lines 176-179
function UnoPuzzleDoorRing:turn_clockwise()
	self._current_stop = math.mod(self._current_stop + 1, self._stops)

	self:_target_stop(self._current_stop)
end

-- Lines 181-188
function UnoPuzzleDoorRing:turn_counterclockwise()
	self._current_stop = self._current_stop - 1

	if self._current_stop < 0 then
		self._current_stop = self._stops - 1
	end

	self:_target_stop(self._current_stop)
end
