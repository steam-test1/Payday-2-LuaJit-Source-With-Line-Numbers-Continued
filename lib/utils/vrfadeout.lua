VRFadeout = VRFadeout or class()

-- Lines: 5 to 20
function VRFadeout:init()
	self._slotmask = managers.slot:get_mask("statics")
	self._fadeout = {
		value = 0,
		fadein_speed = 0,
		effect = {
			blend_mode = "normal",
			fade_out = 0,
			play_paused = true,
			fade_in = 0,
			color = Color(0, 0, 0, 0),
			timer = TimerManager:main()
		}
	}
	self._ghost_reset_timer_t = 0
end
local mvec_temp1 = Vector3()
local mvec_temp2 = Vector3()
local mvec_temp3 = Vector3()


-- Lines: 26 to 56
local function raycast_multi_dir(position, forward, length, slotmask)
	local dir = mvec_temp1

	mvector3.set(dir, forward)
	mvector3.multiply(dir, length)

	local p_behind = mvec_temp2

	mvector3.set(p_behind, position)
	mvector3.subtract(p_behind, dir)

	local p_ahead = mvec_temp3

	mvector3.set(p_ahead, position)
	mvector3.add(p_ahead, dir)

	local ray = World:raycast("ray", p_behind, p_ahead, "slot_mask", slotmask, "ray_type", "body mover", "sphere_cast_radius", 10, "bundle", 5)
	local hit = false
	local distance = nil

	if ray then
		hit = true
		distance = mvector3.distance(position, ray.position)
	end

	local ray = World:raycast("ray", p_ahead, p_behind, "slot_mask", slotmask, "ray_type", "body mover", "sphere_cast_radius", 10, "bundle", 5)

	if ray then
		hit = true
		local d = mvector3.distance(position, ray.position)
		distance = distance and math.min(distance, d) or d
	end

	return hit, distance
end


-- Lines: 59 to 70
local function raycast_head(position, rotation, slotmask)
	local hit, distance = raycast_multi_dir(position, rotation:y(), 20, slotmask)
	local h, d = raycast_multi_dir(position, rotation:x(), 20, slotmask)

	if h then
		distance = distance and math.min(distance, d) or d
	end

	h, d = raycast_multi_dir(position, rotation:z(), 20, slotmask)

	if h then
		distance = distance and math.min(distance, d) or d
	end

	return hit, distance
end


-- Lines: 74 to 124
local function fadeout_func(mover_position, head_position, rotation, slotmask)
	local distance_to_mover = mvector3.distance(head_position:with_z(0), mover_position:with_z(0))
	local ghost_max_th = 50
	local fade_distance = 13
	local distance_to_obstacle = fade_distance
	local fadeout = 0
	local outer = World:sphere_overlap(head_position, 15, slotmask)

	if outer then
		local inner = World:sphere_overlap(head_position, 7.5, slotmask)

		if inner then
			return 1
		end

		local hit, distance = raycast_head(head_position, rotation, slotmask)

		if hit then
			local obstacle_min_th = 7

			if distance <= obstacle_min_th then
				distance_to_obstacle = 0
			elseif distance < obstacle_min_th + fade_distance then
				distance_to_obstacle = distance - obstacle_min_th
			end
		end
	end

	if distance_to_obstacle > 0 then
		local pos = mvec_temp1

		mvector3.set(pos, mover_position)
		mvector3.set_z(pos, pos.z - 15)

		local ray = World:raycast("ray", pos, head_position, "slot_mask", slotmask, "ray_type", "body mover", "sphere_cast_radius", 10, "bundle", 5)

		if ray then
			local d1 = mvector3.distance(mover_position, ray.position)
			local d2 = mvector3.distance(mover_position, head_position)
			local d = math.abs(d2 - d1)

			if d1 < d2 or d < 5 then
				distance_to_obstacle = 0
			end
		end
	end

	fadeout = 1 - distance_to_obstacle / fade_distance

	if ghost_max_th < distance_to_mover then
		fadeout = math.max((distance_to_mover - ghost_max_th) / fade_distance, fadeout)
	end

	fadeout = math.clamp(fadeout, 0, 1)

	return fadeout
end


-- Lines: 127 to 129
function VRFadeout:play()
	self._fadeout.effect_id = self._fadeout.effect_id or managers.overlay_effect:play_effect(self._fadeout.effect)
end

-- Lines: 131 to 134
function VRFadeout:reset()
	self._fadeout.value = 0
	self._fadeout.effect.color.alpha = 0
end

-- Lines: 136 to 167
function VRFadeout:update(mover_position, head_position, rotation, t, dt)
	local fadeout_data = self._fadeout
	local fadeout = fadeout_func(mover_position, head_position, rotation, self._slotmask)

	if fadeout_data.value < fadeout then
		fadeout_data.value = math.step(fadeout_data.value, fadeout, fadeout < 1 and dt * 3 or dt * 10)
		fadeout_data.fadein_speed = 0
	elseif fadeout < fadeout_data.value then
		fadeout_data.value = math.step(fadeout_data.value, fadeout, dt * fadeout_data.fadein_speed)
		fadeout_data.fadein_speed = math.min(fadeout_data.fadein_speed + dt * 1, 0.7)
	end

	local v = fadeout_data.value
	fadeout_data.effect.color.alpha = v * v * (3 - 2 * v)

	if fadeout > 0.95 then
		self._ghost_reset_timer_t = self._ghost_reset_timer_t + dt
	else
		self._ghost_reset_timer_t = 0
	end

	if self._ghost_reset_timer_t > 1.5 then
		self._ghost_reset_timer_t = 0

		return true
	end

	return false
end

