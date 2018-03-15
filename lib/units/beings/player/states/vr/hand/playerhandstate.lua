PlayerHandState = PlayerHandState or class()

-- Lines: 4 to 9
function PlayerHandState:init(name, hand_state_machine, hand_unit, sequence)
	self._name = name
	self._hsm = hand_state_machine
	self._hand_unit = hand_unit
	self._sequence = sequence
end

-- Lines: 11 to 12
function PlayerHandState:destroy()
end

-- Lines: 14 to 15
function PlayerHandState:name()
	return self._name
end

-- Lines: 18 to 19
function PlayerHandState:hsm()
	return self._hsm
end

-- Lines: 26 to 32
function PlayerHandState:at_enter(previous_state, params)
	if self._hand_unit and self._sequence and self._hand_unit:damage():has_sequence(self._sequence) then
		self._hand_unit:damage():run_sequence_simple(self._sequence)
	end
end

-- Lines: 34 to 35
function PlayerHandState:at_exit(next_state)
end

-- Lines: 37 to 40
function PlayerHandState:default_transition(next_state, params)
	self:at_exit(next_state)
	next_state:at_enter(self, params)
end

-- Lines: 42 to 43
function PlayerHandState:set_controller_enabled(enabled)
end

