PlayerIncapacitatedVR = PlayerIncapacitated or Application:error("PlayerIncapacitatedVR needs PlayerIncapacitated!")
PlayerIncapacitatedVR._update_movement = PlayerBleedOutVR._update_movement
PlayerIncapacitatedVR._start_action_incapacitated = PlayerFatalVR._start_action_dead
PlayerIncapacitatedVR._end_action_incapacitated = PlayerFatalVR._end_action_dead
PlayerIncapacitatedVR.set_belt_and_hands_enabled = PlayerFatalVR.set_belt_and_hands_enabled
local __enter = PlayerIncapacitated.enter
local __exit = PlayerIncapacitated.exit

-- Lines: 12 to 16
function PlayerIncapacitatedVR:enter(...)
	__enter(self, ...)
	self._ext_movement:set_orientation_state("incapacitated", self._unit:position())
end

-- Lines: 18 to 25
function PlayerIncapacitatedVR:exit(state_data, new_state_name)
	self._ext_movement:set_orientation_state("none")

	local exit_data = __exit(self, state_data, new_state_name) or {}

	if new_state_name == "carry" then
		exit_data.skip_hand_carry = true
	end

	return exit_data
end

