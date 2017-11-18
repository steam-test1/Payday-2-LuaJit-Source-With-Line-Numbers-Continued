PlayerTasedVR = PlayerTased or Application:error("PlayerTasedVR need PlayerTased!")
local __update_movement = PlayerTased._update_movement
local __enter = PlayerTased.enter
local __exit = PlayerTased.exit

-- Lines: 7 to 12
function PlayerTasedVR:enter(...)
	__enter(self, ...)

	self._state_data.tased = true

	self._unit:hand():set_tased(true)
end

-- Lines: 14 to 19
function PlayerTasedVR:exit(...)
	__exit(self, ...)

	self._state_data.tased = false

	self._unit:hand():set_tased(false)
end
local mvec_pos_new = Vector3()
local mvec_hmd_delta = Vector3()
local mvec_hmd_pos = Vector3()

-- Lines: 26 to 42
function PlayerTasedVR:_update_movement(t, dt)
	__update_movement(self, t, dt)

	local pos_new = mvec_pos_new

	mvector3.set(pos_new, self._ext_movement:ghost_position())

	local hmd_pos = mvec_hmd_pos

	mvector3.set(hmd_pos, self._ext_movement:hmd_position())

	local hmd_delta = mvec_hmd_delta

	mvector3.set(hmd_delta, self._ext_movement:hmd_delta())
	mvector3.set_z(hmd_delta, 0)
	mvector3.rotate_with(hmd_delta, self._camera_base_rot)
	mvector3.add(pos_new, hmd_delta)
	self._ext_movement:set_ghost_position(pos_new, self._unit:position())
end

