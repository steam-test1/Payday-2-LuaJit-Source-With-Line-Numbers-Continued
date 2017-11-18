PlayerArrestedVR = PlayerArrested or Application:error("PlayerArrestedVR needs PlayerArrested!")
local __enter = PlayerArrested.enter
local __exit = PlayerArrested.exit

-- Lines: 6 to 11
function PlayerArrestedVR:enter(...)
	__enter(self, ...)
	self._ext_movement:set_orientation_state("cuffed", self._unit:position())
	self._unit:hand():set_cuffed(true)
end

-- Lines: 13 to 18
function PlayerArrestedVR:exit(...)
	__exit(self, ...)
	self._ext_movement:set_orientation_state("none")
	self._unit:hand():set_cuffed(false)
end
local mvec_pos_new = Vector3()
local mvec_hmd_delta = Vector3()

-- Lines: 23 to 34
function PlayerArrestedVR:_update_movement(t, dt)
	local pos_new = mvec_pos_new

	mvector3.set(pos_new, self._ext_movement:ghost_position())

	local hmd_delta = mvec_hmd_delta

	mvector3.set(hmd_delta, self._ext_movement:hmd_delta())
	mvector3.set_z(hmd_delta, 0)
	mvector3.rotate_with(hmd_delta, self._camera_base_rot)
	mvector3.add(pos_new, hmd_delta)
	self._ext_movement:set_ghost_position(pos_new)
end

-- Lines: 41 to 80
function PlayerArrestedVR:_update_check_actions(t, dt)
	local input = self:_get_input(t, dt)

	if input.btn_stats_screen_press then
		self._unit:base():set_stats_screen_visible(true)
	elseif input.btn_stats_screen_release then
		self._unit:base():set_stats_screen_visible(false)
	end

	self:_update_foley(t, input)

	if self._unit:character_damage()._arrested_timer <= 0 and not self._timer_finished then
		self._timer_finished = true

		managers.hud:pd_stop_timer()
		managers.hud:pd_show_text()
		PlayerStandard.say_line(self, "s21x_sin")
	end

	if self._equip_weapon_expire_t and self._equip_weapon_expire_t <= t then
		self._equip_weapon_expire_t = nil
	end

	if self._unequip_weapon_expire_t and self._unequip_weapon_expire_t + 0.5 <= t then
		self._unequip_weapon_expire_t = nil
	end

	self:_update_foley(t, input)

	local new_action = self:_check_action_interact(t, input)
end

