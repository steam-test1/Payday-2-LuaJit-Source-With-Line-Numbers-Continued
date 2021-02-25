PlayerAnimationData = PlayerAnimationData or class()

-- Lines 5-7
function PlayerAnimationData:init(unit)
	self._unit = unit
end

-- Lines 11-15
function PlayerAnimationData:anim_clbk_footstep_l(unit)
	self._footstep = "l"

	unit:base():anim_data_clbk_footstep("left")
end

-- Lines 19-23
function PlayerAnimationData:anim_clbk_footstep_r(unit)
	self._footstep = "r"

	unit:base():anim_data_clbk_footstep("right")
end

-- Lines 27-30
function PlayerAnimationData:anim_clbk_startfoot_l(unit)
	self._footstep = "l"
end

-- Lines 34-37
function PlayerAnimationData:anim_clbk_startfoot_r(unit)
	self._footstep = "r"
end

-- Lines 42-44
function PlayerAnimationData:foot()
	return self._footstep
end

-- Lines 48-50
function PlayerAnimationData:anim_clbk_upper_body_empty(unit)
	unit:anim_state_machine():stop_segment(Idstring("upper_body"))
end

-- Lines 54-56
function PlayerAnimationData:anim_clbk_base_empty(unit)
	unit:anim_state_machine():stop_segment(Idstring("base"))
end

-- Lines 60-66
function PlayerAnimationData:anim_clbk_death_exit(unit)
	unit:movement():on_death_exit()
	unit:base():on_death_exit()

	if unit:inventory() then
		unit:inventory():on_death_exit()
	end
end
