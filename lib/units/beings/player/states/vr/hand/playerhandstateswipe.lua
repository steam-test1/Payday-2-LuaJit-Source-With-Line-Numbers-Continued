require("lib/units/beings/player/states/vr/hand/PlayerHandState")

PlayerHandStateSwipe = PlayerHandStateSwipe or class(PlayerHandState)

-- Lines: 5 to 7
function PlayerHandStateSwipe:init(hsm, name, hand_unit, sequence)
	PlayerHandStateWeapon.super.init(self, name, hsm, hand_unit, sequence)
end

-- Lines: 9 to 15
function PlayerHandStateSwipe:at_enter(prev_state, params)
	PlayerHandStateSwipe.super.at_enter(self, prev_state)

	self._params = params
	self.prev_state = prev_state:name()
	self._flick_callback = params.flick_callback

	self:hsm():enter_controller_state("tablet")
end

-- Lines: 17 to 20
function PlayerHandStateSwipe:at_exit(next_state)
	PlayerHandStateSwipe.super.at_exit(self, next_state)

	self._flick_callback = nil
end
local tmp_vec = Vector3(0, 0, 0)

-- Lines: 23 to 45
function PlayerHandStateSwipe:update(t, dt)
	mvector3.set(tmp_vec, Vector3(4, 12, 3.5))
	mvector3.rotate_with(tmp_vec, self._hand_unit:rotation())
	mvector3.add(tmp_vec, self._hand_unit:position())

	local tablet_hand = self._hsm:other_hand():hand_unit()
	local tablet_oobb = tablet_hand:get_object(Idstring("g_tablet")):oobb()

	tablet_oobb:grow(2)

	if tablet_oobb:point_inside(tmp_vec) then
		self._start_swipe = self._start_swipe or mvector3.copy(tmp_vec)
		self._start_t = self._start_t or t
		self._current_swipe = tmp_vec
	elseif self._start_swipe then
		self._start_swipe = nil
		self._start_t = nil
		self._last_flick = nil
	end

	if self._start_swipe and self._current_swipe and self._start_t and self._start_t < t then
		self:_check_flick(self._start_swipe, self._current_swipe, t - self._start_t)
	end
end
local dir_vec = Vector3(0, 0, 0)

-- Lines: 48 to 78
function PlayerHandStateSwipe:_check_flick(start, current, dt)
	if mvector3.distance_sq(start, current) / dt > 100 then
		mvector3.set(dir_vec, current)
		mvector3.subtract(dir_vec, start)

		local inv_rot = self._hand_unit:rotation():inverse()

		mvector3.rotate_with(dir_vec, inv_rot)

		local vel = math.max((mvector3.normalize(dir_vec) / dt) / 25, 3)
		local dir_string = nil
		local axis = dir_vec.z < dir_vec.x and "x" or "z"

		if dir_vec[axis] > 0 then
			dir_string = axis == "x" and "left" or "down"
		else
			dir_string = axis == "x" and "up" or "right"
		end

		if dir_string == self._last_flick then
			return
		end

		if self._flick_callback then
			self._flick_callback(dir_string, 1 / vel)
		end

		self._last_flick = dir_string
	end
end

-- Lines: 80 to 83
function PlayerHandStateSwipe:item_transition(next_state, params)
	params = self._params

	self:default_transition(next_state, params)
end

