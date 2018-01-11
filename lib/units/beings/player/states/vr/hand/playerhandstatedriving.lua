require("lib/units/beings/player/states/vr/hand/PlayerHandState")

PlayerHandStateDriving = PlayerHandStateDriving or class(PlayerHandState)
PlayerHandStateDriving.DEBUG = false

-- Lines: 8 to 10
function PlayerHandStateDriving:init(hsm, name, hand_unit, sequence)
	PlayerHandStateDriving.super.init(self, name, hsm, hand_unit, sequence)
end

-- Lines: 12 to 30
function PlayerHandStateDriving:at_enter(prev_state, params)
	PlayerHandStateDriving.super.at_enter(self, prev_state)
	self:hsm():enter_controller_state("driving")

	self._vehicle = managers.player:get_vehicle()
	self._tweak = tweak_data.vr.driving
	self._tweak = self._tweak[self._vehicle.vehicle_unit:vehicle_driving().tweak_data]

	if self._tweak.middle_pos and type(self._tweak.steering_pos) ~= "table" then
		self._start_vec = self._tweak.steering_pos - self._tweak.middle_pos
		self._two_handed = false
	elseif self._tweak.steering_pos then
		self._start_vec = self._tweak.steering_pos.left - self._tweak.steering_pos.right
		self._two_handed = true
	end

	self._hand_side = self:hsm():hand_id() == 1 and "right" or "left"
end

-- Lines: 33 to 35
function PlayerHandStateDriving:at_exit(next_state)
	PlayerHandStateDriving.super.at_exit(self, next_state)
end

-- Lines: 37 to 38
function PlayerHandStateDriving:gripping()
	return self._gripping
end
local pen = Draw:pen()
local offset = Vector3()
local middle = Vector3()
local steering_vec = Vector3()
local exit = Vector3()

-- Lines: 53 to 163
function PlayerHandStateDriving:update(t, dt)

	-- Lines: 47 to 54
	local function offset_to_world(output, offset)
		mvector3.set(output, offset)
		mvector3.rotate_with(output, self._vehicle.vehicle_unit:rotation())
		mvector3.add(output, self._vehicle.vehicle_unit:position())

		if PlayerHandStateDriving.DEBUG then
			pen:sphere(output, 5)
		end
	end

	self._tweak = tweak_data.vr.driving
	self._tweak = self._tweak[self._vehicle.vehicle_unit:vehicle_driving().tweak_data]
	local can_grip = true
	local other_state = self:hsm():other_hand():current_state()

	if not self._two_handed and other_state:name() == "driving" and other_state:gripping() then
		can_grip = false
	end

	local controller = managers.vr:hand_state_machine():controller()

	if self._vehicle.seat == "driver" and self._tweak.steering_pos then
		if self._two_handed then
			offset_to_world(offset, self._tweak.steering_pos[self._hand_side])
			mvector3.set(middle, self:hsm():other_hand():position())
		else
			offset_to_world(offset, self._tweak.steering_pos)
			offset_to_world(middle, self._tweak.middle_pos)
		end

		local dis = mvector3.distance(self._hand_unit:position(), offset)

		if dis < 20 and can_grip then
			if not self._close then
				self._close = true

				if not self._gripping then
					self._hand_unit:damage():run_sequence_simple("ready")
					managers.controller:get_vr_controller():trigger_haptic_pulse(self:hsm():hand_id() - 1, 0, 700)
				end
			end
		elseif self._close then
			if not self._gripping then
				self._hand_unit:damage():run_sequence_simple("idle")
			end

			self._close = false
		end

		if self._close and controller:get_input_pressed("interact_" .. self._hand_side) then
			self._gripping = true

			self._hand_unit:damage():run_sequence_simple("grip_wpn")
		elseif self._gripping and controller:get_input_released("interact_" .. self._hand_side) then
			self._gripping = false

			self._hand_unit:damage():run_sequence_simple(self._close and "ready" or "idle")
			managers.player:player_unit():movement():current_state():set_steering()
		end

		local can_steer = self._gripping

		if self._two_handed and (other_state:name() == "driving" and not other_state:gripping() or self._hand_side == "right") then
			can_steer = false
		end

		if can_steer then
			mvector3.set(steering_vec, self._hand_unit:position())
			mvector3.subtract(steering_vec, middle)
			mvector3.rotate_with(steering_vec, self._vehicle.vehicle_unit:rotation():inverse())

			local steering_rot = Rotation:rotation_difference(Rotation(self._start_vec, math.UP), Rotation(math.UP, math.UP))

			mvector3.rotate_with(steering_vec, steering_rot)
			mvector3.set_y(steering_vec, 0)

			local angle = mvector3.angle(steering_vec, self._start_vec:rotate_with(steering_rot))

			if steering_vec.z > 0 then
				self._invert_angle = steering_vec.x < 0
			end

			if self._invert_angle then
				angle = angle * -1
			end

			if self._tweak.inverted then
				angle = angle * -1
			end

			local val = math.clamp(angle / self._tweak.max_angle, -0.99, 0.99)

			if math.abs(val) < 0.1 then
				val = 0
			end

			managers.player:player_unit():movement():current_state():set_steering(val)
		end
	end

	if not self._gripping then
		if not self._tweak.exit_pos[self._vehicle.seat] then
			debug_pause("Seat " .. self._vehicle.seat .. " has no exit in " .. self._vehicle.vehicle_unit:vehicle_driving().tweak_data .. "!")

			return
		end

		offset_to_world(exit, self._tweak.exit_pos[self._vehicle.seat].position)

		local dis = mvector3.distance(self._hand_unit:position(), exit)

		if dis < 20 then
			if not self._close_exit then
				self._close_exit = true

				self._hand_unit:damage():run_sequence_simple("ready")
				managers.controller:get_vr_controller():trigger_haptic_pulse(self:hsm():hand_id() - 1, 0, 700)
			end
		elseif self._close_exit then
			self._hand_unit:damage():run_sequence_simple("idle")

			self._close_exit = false
		end

		if self._close_exit and controller:get_input_pressed("interact_" .. self._hand_side) then
			managers.player:player_unit():movement():current_state():_start_action_exit_vehicle(t)
		end
	end
end

