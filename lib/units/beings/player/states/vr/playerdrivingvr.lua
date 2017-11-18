PlayerDrivingVR = PlayerDriving or Application:error("PlayerDrivingVR needs PlayerDriving!")
local __enter = PlayerDriving.enter

-- Lines: 4 to 67
function PlayerDrivingVR:enter(...)
	__enter(self, ...)
	self._camera_unit:base():enter_vehicle()

	if self._seat.has_shooting_mode then
		self._seat.allow_shooting = true
	end

	if not self._seat.allow_shooting and not self._seat.has_shooting_mode then
		managers.hud:belt():set_visible(false)
		self._unit:hand():_set_hand_state(PlayerHand.RIGHT, "driving")
		self._unit:hand():_set_hand_state(PlayerHand.LEFT, "driving")
	else
		local weapon_hand_id = self._unit:hand():get_default_hand_id("weapon")

		if weapon_hand_id then
			self._unit:hand():_set_hand_state(PlayerHand.other_hand_id(weapon_hand_id), "driving")
		end
	end

	local driving_tweak = tweak_data.vr.driving[self._vehicle_ext.tweak_data]

	if not driving_tweak then
		debug_pause("Missing tweak_data for vehicle:", self._vehicle_ext.tweak_data)
	end

	if self._seat.driving then
		self._vehicle_ws_ids = {}

		if type(driving_tweak.steering_pos) ~= "table" or not driving_tweak.steering_pos then
			local offsets = {driving_tweak.steering_pos}
		end

		for key, offset in pairs(offsets) do
			local dir = (driving_tweak.steering_dir or math.Y):rotate_with(self._vehicle_unit:rotation())
			local up = driving_tweak.steering_up
			local id = type(key) == "string" and "steering_" .. key or "steering"
			local steering_ws = managers.hud:create_vehicle_interaction_ws(id, self._vehicle_unit, offset, dir, up)

			table.insert(self._vehicle_ws_ids, id)

			local panel = steering_ws:panel():panel({
				w = 100,
				name = "steering",
				h = 100
			})

			panel:set_center_x(steering_ws:panel():w() / 2)
			BoxGuiObject:new(panel, {sides = {
				1,
				1,
				1,
				1
			}})

			local dbg = panel:text({
				text = "DRIVE",
				font = tweak_data.menu.pd2_large_font,
				font_size = tweak_data.menu.pd2_medium_font_size
			})
			local _, _, w, h = dbg:text_rect()

			dbg:set_size(w, h)
			dbg:set_center(50, 50)
		end
	end

	local exit_tweak = driving_tweak.exit_pos[self._seat.name]

	if exit_tweak then
		local dir = exit_tweak.direction:rotate_with(self._vehicle_unit:rotation())
		local up = exit_tweak.up and exit_tweak.up:rotate_with(self._vehicle_unit:rotation())
		local exit_ws = managers.hud:create_vehicle_interaction_ws("exit", self._vehicle_unit, exit_tweak.position, dir, up)

		table.insert(self._vehicle_ws_ids, "exit")

		local panel = exit_ws:panel():panel({
			w = 100,
			name = "exit",
			h = 100
		})

		panel:set_center_x(exit_ws:panel():w() / 2)
		BoxGuiObject:new(panel, {sides = {
			1,
			1,
			1,
			1
		}})

		local dbg = panel:text({
			text = "EXIT",
			font = tweak_data.menu.pd2_large_font,
			font_size = tweak_data.menu.pd2_medium_font_size
		})
		local _, _, w, h = dbg:text_rect()

		dbg:set_size(w, h)
		dbg:set_center(50, 50)
	end
end
local __exit = PlayerDriving.exit

-- Lines: 70 to 81
function PlayerDrivingVR:exit(...)
	__exit(self, ...)
	self._unit:hand():_change_hand_to_default(PlayerHand.RIGHT)
	self._unit:hand():_change_hand_to_default(PlayerHand.LEFT)
	self._unit:hand():set_base_rotation(self._camera_unit:base():base_rotation())
	managers.hud:belt():set_visible(true)

	for _, id in ipairs(self._vehicle_ws_ids or {}) do
		managers.hud:destroy_vehicle_interaction_ws(id)
	end
end

-- Lines: 83 to 94
function PlayerDrivingVR:_postion_player_on_seat(seat)
	local rot = self._seat.object:rotation()
	local pos = self._seat.object:position()

	self._unit:set_rotation(rot)
	self._unit:set_position(pos)
	self._ext_movement:reset_ghost_position()
	self._ext_movement:reset_hmd_position()

	self._initial_hmd_rotation = VRManager:hmd_rotation()
	self._hmd_delta = Vector3()
end
local __update = PlayerDriving.update
local hmd_delta = Vector3()
local ghost_pos = Vector3()
local seat_offset = Vector3()
local hmd_rot = Rotation()

-- Lines: 101 to 125
function PlayerDrivingVR:update(t, dt)
	__update(self, t, dt)

	local seat_pos, seat_rot = self._vehicle_unit:vehicle_driving():get_object_placement(self._unit)

	if not seat_pos or not seat_rot then
		return
	end

	mrotation.set_zero(hmd_rot)
	mrotation.set_yaw_pitch_roll(hmd_rot, seat_rot:yaw() - self._initial_hmd_rotation:yaw(), 0, 0)
	self._unit:hand():set_base_rotation(Rotation(hmd_rot:yaw(), hmd_rot:pitch(), hmd_rot:roll()))
	mvector3.add(self._hmd_delta, self._ext_movement:hmd_delta())
	mvector3.set(hmd_delta, self._hmd_delta)
	mvector3.rotate_with(hmd_delta, hmd_rot)
	mvector3.set_static(seat_offset, 0, 0, 145)
	mvector3.rotate_with(seat_offset, seat_rot)
	mvector3.set(ghost_pos, seat_pos)
	mvector3.add(ghost_pos, seat_offset)
	mvector3.subtract(ghost_pos, Vector3(0, 0, self._ext_movement:hmd_position().z))
	mvector3.add(ghost_pos, hmd_delta)
	self._ext_movement:set_ghost_position(ghost_pos)
end

-- Lines: 127 to 129
function PlayerDrivingVR:set_steering(value)
	self._steering_value = value
end
local __get_drive_axis = PlayerDriving._get_drive_axis

-- Lines: 132 to 139
function PlayerDrivingVR:_get_drive_axis()
	local drive_axis = __get_drive_axis(self)

	if self._steering_value then
		mvector3.set_x(drive_axis, self._steering_value)
	end

	return drive_axis
end

