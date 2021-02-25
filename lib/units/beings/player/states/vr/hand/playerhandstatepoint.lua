require("lib/units/beings/player/states/vr/hand/PlayerHandState")

PlayerHandStatePoint = PlayerHandStatePoint or class(PlayerHandState)

-- Lines 6-8
function PlayerHandStatePoint:init(hsm, name, hand_unit, sequence)
	PlayerHandStatePoint.super.init(self, name, hsm, hand_unit, sequence)
end

-- Lines 10-16
function PlayerHandStatePoint:at_enter(prev_state)
	PlayerHandStatePoint.super.at_enter(self, prev_state)

	self._timer_t = nil
	self._can_transition = false

	self:hsm():enter_controller_state("point")
end

-- Lines 18-27
function PlayerHandStatePoint:update(t, dt)
	if not self._timer_t then
		self._timer_t = t
	end

	if t - self._timer_t > 1.1 and not self._can_transition then
		self._can_transition = true

		self._hsm:change_to_default(nil, true)
	end
end

-- Lines 29-33
function PlayerHandStatePoint:default_transition(next_state)
	if self._can_transition then
		PlayerHandStatePoint.super.default_transition(self, next_state)
	end
end
