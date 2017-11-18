PlayerHandState = PlayerHandState or class()

-- Lines: 3 to 8
function PlayerHandState:init(name, hand_state_machine, hand_unit, sequence)
	self._name = name
	self._hsm = hand_state_machine
	self._hand_unit = hand_unit
	self._sequence = sequence
end

-- Lines: 10 to 11
function PlayerHandState:destroy()
end

-- Lines: 13 to 14
function PlayerHandState:name()
	return self._name
end

-- Lines: 17 to 18
function PlayerHandState:hsm()
	return self._hsm
end

-- Lines: 25 to 31
function PlayerHandState:at_enter(previous_state, params)
	if self._hand_unit and self._sequence and self._hand_unit:damage():has_sequence(self._sequence) then
		self._hand_unit:damage():run_sequence_simple(self._sequence)
	end
end

-- Lines: 33 to 34
function PlayerHandState:at_exit(next_state)
end

-- Lines: 36 to 39
function PlayerHandState:default_transition(next_state, params)
	self:at_exit(next_state)
	next_state:at_enter(self, params)
end

-- Lines: 41 to 42
function PlayerHandState:set_controller_enabled(enabled)
end

