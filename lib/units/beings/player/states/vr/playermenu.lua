require("lib/units/beings/player/playerwarp")
require("lib/units/beings/player/handmelee")
require("lib/input/HandStateMachine")

local hand_states_menu = require("lib/input/HandStatesPlayerMenu")
TouchWheel = TouchWheel or class()

-- Lines: 10 to 17
function TouchWheel:init(granularity_x, granularity_y)
	self._granularity_x = granularity_x
	self._granularity_y = granularity_y
	self._reference = Vector3(0, 0, 0)
	self._value = Vector3(0, 0, 0)
	self._prev_value = Vector3(0, 0, 0)
	self._touching = false
end

-- Lines: 19 to 40
function TouchWheel:feed(v)
	mvector3.set(self._prev_value, self._value)

	if mvector3.length_sq(v) < 0.001 then
		if self._touching then
			self._touching = false

			mvector3.set_zero(self._value)
			mvector3.set_zero(self._prev_value)
		end
	elseif not self._touching then
		mvector3.set(self._reference, v)

		self._touching = true
	end

	if self._touching then
		mvector3.set_x(self._value, math.round((v.x - self._reference.x) / self._granularity_x))
		mvector3.set_y(self._value, math.round((v.y - self._reference.y) / self._granularity_y))
	end

	return self._touching
end

-- Lines: 43 to 44
function TouchWheel:step_x()
	return self._value.x - self._prev_value.x
end

-- Lines: 47 to 48
function TouchWheel:step_y()
	return self._value.y - self._prev_value.y
end

-- Lines: 51 to 52
function TouchWheel:value()
	return self._value
end
PlayerMenu = PlayerMenu or class()
PlayerMenu.DEBUG_AREA = false
PlayerMenu.DEBUG_WARP = false
PlayerMenu.STATE_IDLE = 0
PlayerMenu.STATE_TARGETING = 1
PlayerMenu.STATE_WARPING = 2
PlayerMenu.STATE_BOOTUP_INIT = 3
PlayerMenu.STATE_EMPTY = 4
PlayerMenu.WARP_SPEED = 3000
local mvec_temp1 = Vector3()
local mvec_temp2 = Vector3()
local mvec_temp3 = Vector3()

-- Lines: 72 to 127
function PlayerMenu:init(position, is_start_menu)
	self._is_start_menu = is_start_menu or false
	self._can_warp = self._is_start_menu
	self._position = mvector3.copy(position)
	self._base_rotation = Rotation(0, 0, 0)
	self._last_good_position = mvector3.copy(position)
	self._hmd_pos = VRManager:hmd_position()
	self._hmd_delta = Vector3()
	self._vr_controller = managers.controller:get_vr_controller()
	self._controller = managers.controller:create_controller("menu_vr", managers.controller:get_vr_wrapper_index(), false)

	self._controller:set_enabled(true)
	self:_set_tracking_enabled(false)

	self._touch_wheel = TouchWheel:new(0.25, 0.25)
	local width = 650
	local height = 650
	local origin = Vector3(0, 0, 0)
	self._play_area = {
		Vector3(-width / 2, height / 2, 0) + origin,
		Vector3(width / 2, height / 2, 0) + origin,
		Vector3(width / 2, -height / 2, 0) + origin,
		Vector3(-width / 2, -height / 2, 0) + origin
	}

	self:_create_camera()
	self:_create_hands()
	self:_setup_draw()
	self:_setup_states()
	self:register_workspace({
		ws = managers.mouse_pointer:workspace(),
		activate = function ()
			if managers.menu:active_menu() then
				managers.menu:active_menu().input:activate_mouse(1)
			end
		end,
		deactivate = function ()
			if managers.menu:active_menu() then
				managers.menu:active_menu().input:deactivate_mouse(1)
			end
		end
	})

	self._current_ws = managers.mouse_pointer:workspace()
	self._default_ws = self._current_ws
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
	self._fadeout.effect_id = self._fadeout.effect_id or managers.overlay_effect:play_effect(self._fadeout.effect)
	self._position_reset_timer_t = 0
end

-- Lines: 129 to 139
function PlayerMenu:destroy()
	if self._vp then
		self._vp:destroy()

		self._vp = nil
	end

	if self._controller then
		self._controller:destroy()

		self._controller = nil
	end
end

-- Lines: 147 to 150
function PlayerMenu:register_workspace(params)
	self._workspaces = self._workspaces or {}
	self._workspaces[params.ws:key()] = params
end

-- Lines: 152 to 155
function PlayerMenu:unregister_workspace(ws)
	self._workspaces = self._workspaces or {}
	self._workspaces[ws:key()] = nil
end

-- Lines: 157 to 158
function PlayerMenu:get_rumble_position()
	return self._hmd_pos
end

-- Lines: 161 to 177
function PlayerMenu:change_state(state, ...)
	if state == self._current_state then
		return
	end

	if self._current_state then
		local exit = self._states[self._current_state].exit

		if exit then
			exit(...)
		end
	end

	self._current_state = state
	local enter = self._states[self._current_state].enter

	if enter then
		enter(...)
	end

	self._state_update = self._states[self._current_state].update
end

-- Lines: 179 to 180
function PlayerMenu:current_state()
	return self._current_state
end

-- Lines: 183 to 184
function PlayerMenu:controller()
	return self._controller
end

-- Lines: 187 to 188
function PlayerMenu:hand(hand_index)
	return self._hands[hand_index]
end

-- Lines: 191 to 192
function PlayerMenu:camera()
	return self._camera_object
end

-- Lines: 195 to 196
function PlayerMenu:position()
	return self._position
end

-- Lines: 199 to 200
function PlayerMenu:base_rotation()
	return self._base_rotation
end


-- Lines: 203 to 210
local function clip_line_plane(from, line_dir, line_length, n, p)
	local denom = mvector3.dot(line_dir, n)

	if denom == 0 then
		return line_length
	end

	local clipped_length = mvector3.dot(p - from, n) / denom

	return clipped_length > 0 and clipped_length < line_length and clipped_length or line_length
end


-- Lines: 213 to 224
function PlayerMenu:inside_play_area(position)
	local area = self._play_area
	local inside = true

	for i = 1, 4, 1 do
		local p1 = area[i]
		local p2 = area[i < 4 and i + 1 or 1]
		local n = p2 - p1

		mvector3.normalize(n)

		p1 = p1 + n * 30
		inside = inside and mvector3.dot(n, position - p1) > 0
	end

	return inside or PlayerMenu.DEBUG_WARP
end

-- Lines: 227 to 244
function PlayerMenu:clip_line_against_play_area(from, dir, line_length)
	local area = self._play_area
	local n = math.UP
	line_length = clip_line_plane(from, dir, line_length, n, Vector3(0, 0, 0))

	for i = 1, 4, 1 do
		local p1 = area[i]
		local p2 = area[i < 4 and i + 1 or 1]
		local n = p2 - p1

		mvector3.normalize(n)

		p1 = p1 + n * 30

		if mvector3.dot(n, from - p1) > 0 then
			line_length = clip_line_plane(from, dir, line_length, n, p1)
		end
	end

	return {
		from = from,
		to = from + dir * (line_length - 1)
	}
end

-- Lines: 247 to 273
function PlayerMenu:clip_point_to_area(from)
	local area = self._play_area
	local n = math.UP
	local area = self._play_area
	local to = Vector3(0, 0, 0)
	local length_sq = 100000

	for i = 1, 4, 1 do
		local p1 = area[i]
		local p2 = area[i < 4 and i + 1 or 1]
		local n = p2 - p1
		local line_length = mvector3.normalize(n)
		local v = from - p1
		p1 = p1 + n:cross(math.UP) * 31
		local p = p1 + n * math.clamp(mvector3.dot(v, n), 31, line_length - 31)
		local l = mvector3.length_sq(p - from)

		if l < length_sq then
			length_sq = l
			to = p
		end
	end

	return {
		from = from,
		to = to
	}
end

-- Lines: 276 to 281
function PlayerMenu:_rotate_player(right)
	local angle = managers.vr:get_setting("rotate_player_angle")
	local rot = right and Rotation(-angle, 0, 0) or Rotation(angle, 0, 0)

	mrotation.multiply(self._base_rotation, rot)
	managers.overlay_effect:play_effect(tweak_data.vr.overlay_effects.fade_in_rotate_player)
end

-- Lines: 284 to 347
function PlayerMenu:update(t, dt)
	if self._controller:get_input_pressed("rotate_player_left") then
		self:_rotate_player(false)
	end

	if self._controller:get_input_pressed("rotate_player_right") then
		self:_rotate_player(true)
	end

	if self._tracking_enabled then
		local hmd_pos, hmd_rot = VRManager:hmd_pose()

		mvector3.set(self._hmd_delta, hmd_pos)
		mvector3.subtract(self._hmd_delta, self._hmd_pos)
		mvector3.set_z(self._hmd_delta, 0)
		mvector3.set(self._hmd_pos, hmd_pos)

		self._position = self._position + self._hmd_delta:rotate_with(self._base_rotation)
		local pos = mvec_temp1

		mvector3.set(pos, self._position)
		mvector3.set_z(pos, hmd_pos.z)
		self._camera_object:set_position(pos)

		hmd_rot = self._base_rotation * hmd_rot

		self._camera_object:set_rotation(hmd_rot)

		if self:inside_play_area(self._position) then
			mvector3.set(self._last_good_position, self._position)
		end

		if self:_update_fadeout(t, dt, mvector3.distance(self._position, self._last_good_position)) then
			mvector3.set(self._position, self._last_good_position)
		end

		local hmd_horz = mvec_temp1

		mvector3.set(hmd_horz, hmd_pos:rotate_with(self._base_rotation))
		mvector3.set_z(hmd_horz, 0)

		for i, hand in ipairs(self._hands) do
			local pos, rot = self._vr_controller:pose(i - 1)
			rot = self._base_rotation * rot
			pos = pos:rotate_with(self._base_rotation)

			hand:update_orientation(pos, rot, self._position, hmd_horz)
		end
	end

	if self._state_update then
		self._state_update(t, dt)
	end

	if self.DEBUG_AREA then
		for j = 1, 4, 1 do
			for i = 1, 4, 1 do
				local p1 = mvector3.copy(self._play_area[i])
				local p2 = mvector3.copy(self._play_area[i < 4 and i + 1 or 1])

				mvector3.set_z(p1, 100 * j)
				mvector3.set_z(p2, 100 * j)
				self._brush_laser:cylinder(p1, p2, 1)
			end
		end
	end
end


-- Lines: 350 to 380
local function intersect_ws(shape, normal, from, dir)
	local d = mvector3.dot(dir, normal)

	if d <= 0 then
		return nil
	end

	local p = mvector3.dot(shape[1] - from, normal) / d * dir + from

	for i = 1, #shape, 1 do
		local p1 = shape[i]
		local p2 = nil
		p2 = i ~= #shape and shape[i + 1] or shape[1]
		local d = p1 - p2

		mvector3.normalize(d)

		local line_normal = p1 - (i == 1 and shape[4] or shape[i - 1])

		mvector3.normalize(line_normal)

		if mvector3.dot(p1 - p, line_normal) < 0 then
			return nil
		end
	end

	return p
end


-- Lines: 383 to 437
function PlayerMenu:raycast(from, dir)
	local closest_point, min_length_sq = nil
	local workspaces = self._workspaces
	local p = {}
	local v1 = mvec_temp1
	local v2 = mvec_temp2
	local normal = mvec_temp3
	local v = mvec_temp1
	local hit_ws = nil

	for _, data in pairs(workspaces) do
		local ws = data.ws

		if ws:visible() then
			local w = ws:width()
			local h = ws:height()

			mvector3.set_static(v, 0, 0, 0)

			p[1] = ws:local_to_world(v)

			mvector3.set_static(v, w, 0, 0)

			p[2] = ws:local_to_world(v)

			mvector3.set_static(v, w, h, 0)

			p[3] = ws:local_to_world(v)

			mvector3.set_static(v, 0, h, 0)

			p[4] = ws:local_to_world(v)

			mvector3.set(v1, p[2])
			mvector3.subtract(v1, p[1])
			mvector3.normalize(v1)
			mvector3.set(v2, p[4])
			mvector3.subtract(v2, p[1])
			mvector3.normalize(v2)
			mvector3.cross(normal, v1, v2)

			local point = intersect_ws(p, normal, from, dir)

			if point then
				mvector3.set(mvec_temp1, point)
				mvector3.subtract(mvec_temp1, from)

				local len_sq = mvector3.length_sq(mvec_temp1)

				if not min_length_sq or len_sq < min_length_sq then
					min_length_sq = len_sq
					closest_point = point
					hit_ws = ws
				end
			end
		end
	end

	return closest_point, hit_ws
end

-- Lines: 440 to 441
function PlayerMenu:is_idle()
	return self._current_state == PlayerMenu.STATE_IDLE
end

-- Lines: 444 to 447
function PlayerMenu:attach_controller(controller)
	self._hand_state_machine:attach_controller(controller)
	self._hand_state_machine:refresh()
end

-- Lines: 449 to 451
function PlayerMenu:dettach_controller(controller)
	self._hand_state_machine:deattach_controller(controller)
end

-- Lines: 453 to 455
function PlayerMenu:set_primary_hand(hand)
	self:_set_primary_hand(hand == "right" and 1 or 2)
end

-- Lines: 457 to 458
function PlayerMenu:primary_hand_index()
	return self._primary_hand
end

-- Lines: 461 to 478
function PlayerMenu:start()
	self._base_rotation = Rotation(self._is_start_menu and 0 or -VRManager:hmd_rotation():yaw(), 0, 0)

	if not self._is_start_menu then
		self._position = Vector3()
		self._last_good_position = Vector3()
	end

	self._hmd_pos = VRManager:hmd_position()
	self._hmd_pos = self._hmd_pos:rotate_with(self._base_rotation)
	self._hmd_delta = Vector3()

	self._hand_state_machine:refresh()
	self:_set_tracking_enabled(true)

	self._is_active = true

	if self._clear_vp then
		self._clear_vp:set_active(true)
	end

	self:_set_viewport_active(true)
	self:change_state(PlayerMenu.STATE_IDLE)
end

-- Lines: 480 to 490
function PlayerMenu:stop()
	self:_set_tracking_enabled(false)

	self._is_active = false

	self:_set_viewport_active(false)

	if self._clear_vp then
		self._clear_vp:set_active(false)
	end

	self:change_state(PlayerMenu.STATE_EMPTY)
	self._hand_state_machine:enter_hand_state(1, "default")
	self._hand_state_machine:enter_hand_state(2, "default")
end

-- Lines: 492 to 493
function PlayerMenu:is_active()
	return self._is_active or false
end

-- Lines: 496 to 499
function PlayerMenu:set_position(position)
	mvector3.set(self._position, position)
	mvector3.set(self._last_good_position, position)
end

-- Lines: 505 to 543
function PlayerMenu:update_input()
	if self._controller:get_input_pressed("laser_primary") then
		managers.mouse_pointer._ws:feed_mouse_pressed(Idstring("0"))
	elseif self._controller:get_input_released("laser_primary") then
		managers.mouse_pointer._ws:feed_mouse_released(Idstring("0"))
	end

	if self._controller:get_input_pressed("laser_secondary") then
		managers.mouse_pointer._ws:feed_mouse_pressed(Idstring("1"))
	elseif self._controller:get_input_released("laser_secondary") then
		managers.mouse_pointer._ws:feed_mouse_released(Idstring("1"))
	end

	if self._touch_wheel:feed(self._controller:get_input_axis("touchpad_primary")) then
		local dx = self._touch_wheel:step_x()
		local dy = self._touch_wheel:step_y()

		if dx ~= 0 or dy ~= 0 then
			self._vr_controller:trigger_haptic_pulse(self._primary_hand - 1, 0, 700)
		end

		if dy > 0 then
			managers.mouse_pointer._ws:feed_mouse_pressed(Idstring("mouse wheel up"))
		elseif dy < 0 then
			managers.mouse_pointer._ws:feed_mouse_pressed(Idstring("mouse wheel down"))
		end

		if dx > 0 then
			managers.mouse_pointer._ws:feed_mouse_pressed(Idstring("mouse wheel right"))
		elseif dx < 0 then
			managers.mouse_pointer._ws:feed_mouse_pressed(Idstring("mouse wheel left"))
		end
	end
end

-- Lines: 545 to 550
function PlayerMenu:change_ws(ws)
	self._workspaces[self._current_ws:key()].deactivate()
	self._workspaces[ws:key()].activate()
	managers.mouse_pointer:set_custom_workspace(ws)

	self._current_ws = ws
end

-- Lines: 553 to 569
function PlayerMenu:draw()
	local hand = self._hands[self._primary_hand]
	local offset = mvector3.copy(hand:laser_position())

	mvector3.rotate_with(offset, hand:rotation())

	local from = hand:position() + offset
	local p, ws = self:raycast(from, hand:forward())
	local to = nil

	if p and ws then
		to = p

		if ws ~= self._current_ws then
			self:change_ws(ws)
		end

		local mouse_pos = managers.mouse_pointer:workspace():world_to_local(p)

		managers.mouse_pointer:set_mouse_world_position(mouse_pos.x, mouse_pos.y)
	end

	self:_laser_ray(p ~= nil, from, to)
end

-- Lines: 571 to 580
function PlayerMenu:update_base(t, dt)
	self:update_input()
	self:draw()
end

-- Lines: 582 to 590
function PlayerMenu:idle_update(t, dt)
	if self._can_warp or PlayerMenu.DEBUG_WARP then
		local warp = self._controller:get_input_bool("warp")

		if self._controller:get_input_touch_bool("warp_target") and not warp then
			self:change_state(PlayerMenu.STATE_TARGETING)
		end
	end

	self:update_base(t, dt)
end

-- Lines: 595 to 596
function PlayerMenu:target_enter()
end

-- Lines: 598 to 600
function PlayerMenu:target_exit()
	self._warp_marker:set_visible(false)
end

-- Lines: 602 to 635
function PlayerMenu:target_update(t, dt)
	self:update_base(t, dt)

	local hand = self._hands[self._primary_hand == 1 and 2 or 1]
	local hand_forward = hand:forward()
	local hand_position = hand:position()
	local can_warp = mvector3.dot(hand_forward, math.UP) <= 0.8
	local warp_pos = nil

	if can_warp then
		local ray = nil
		ray = self:clip_line_against_play_area(hand_position, hand_forward, 1000)

		if not self:inside_play_area(ray.to) then
			ray = self:clip_point_to_area(hand_position)
		end

		mvector3.set_z(ray.to, 0)
		self:_warp_target(ray.to)

		warp_pos = ray.to

		self:_warp_ray(hand_position, hand_position + hand_forward * 1000)
	end

	self._warp_marker:set_visible(can_warp)

	local targeting = self._controller:get_input_touch_bool("warp_target")

	if self._controller:get_input_bool("warp") then
		if can_warp then
			self:change_state(PlayerMenu.STATE_WARPING, warp_pos)
		end
	elseif not targeting then
		self:change_state(PlayerMenu.STATE_IDLE)
	end
end

-- Lines: 640 to 642
function PlayerMenu:warp_enter(position)
	self._target_position = mvector3.copy(position)
end

-- Lines: 644 to 645
function PlayerMenu:warp_exit()
end

-- Lines: 647 to 657
function PlayerMenu:warp_update(t, dt)
	self._warp_dir = self._target_position - self._position
	local dist = mvector3.normalize(self._warp_dir)
	local warp_len = dt * PlayerMenu.WARP_SPEED

	if dist <= warp_len or dist == 0 then
		self:set_position(self._target_position)
		self:change_state(PlayerMenu.STATE_IDLE)
	else
		self:set_position(self._position + self._warp_dir * warp_len)
	end
end

-- Lines: 662 to 666
function PlayerMenu:bootup_init_update()
	if TextureCache:check_textures_loaded() then
		self:change_state(PlayerMenu.STATE_EMPTY)
	end
end

-- Lines: 668 to 672
function PlayerMenu:bootup_init_exit()
	self:_set_viewport_active(true)
	managers.overlay_effect:play_effect(tweak_data.overlay_effects.level_fade_in)
	self:_set_tracking_enabled(true)
end

-- Lines: 688 to 691
function PlayerMenu:_set_tracking_enabled(enabled)
	self._tracking_enabled = enabled
end

-- Lines: 695 to 702
function PlayerMenu:_set_primary_hand(hand)
	local offhand = 3 - hand

	self._hand_state_machine:enter_hand_state(offhand, "empty")
	self._hands[offhand]:set_state("idle")
	self._hand_state_machine:enter_hand_state(hand, "laser")
	self._hands[hand]:set_state("laser")

	self._primary_hand = hand
end

-- Lines: 707 to 744
function PlayerMenu:_setup_states()
	self._current_state = nil
	self._states = {
		[PlayerMenu.STATE_IDLE] = {update = callback(self, self, "idle_update")},
		[PlayerMenu.STATE_TARGETING] = {
			enter = callback(self, self, "target_enter"),
			exit = callback(self, self, "target_exit"),
			update = callback(self, self, "target_update")
		},
		[PlayerMenu.STATE_WARPING] = {
			enter = callback(self, self, "warp_enter"),
			exit = callback(self, self, "warp_exit"),
			update = callback(self, self, "warp_update")
		},
		[PlayerMenu.STATE_BOOTUP_INIT] = {
			update = callback(self, self, "bootup_init_update"),
			exit = callback(self, self, "bootup_init_exit")
		},
		[PlayerMenu.STATE_EMPTY] = {}
	}
	local hand_states = {
		empty = hand_states_menu.EmptyHandState:new(),
		laser = hand_states_menu.LaserHandState:new(),
		default = hand_states_menu.DefaultHandState:new(),
		customization = hand_states_menu.CustomizationLaserHandState:new()
	}

	self:change_state(self._is_start_menu and PlayerMenu.STATE_BOOTUP_INIT or PlayerMenu.STATE_EMPTY)

	self._hand_state_machine = HandStateMachine:new(hand_states, hand_states.empty, hand_states.empty)

	self._hand_state_machine:attach_controller(self._controller, true)
end
PlayerMenuHandBase = PlayerMenuHandBase or class()

-- Lines: 750 to 758
function PlayerMenuHandBase:init(config, laser_orientation_object)
	self._base_position = config.base_position or Vector3()
	self._base_rotation = config.base_rotation or Rotation()
	self._laser_position = config.laser_position or Vector3()
	self._position = self._base_position
	self._rotation = self._base_rotation
	self._forward = self._base_rotation:y()
	self._laser_orientation_object = laser_orientation_object
end

-- Lines: 760 to 771
function PlayerMenuHandBase:update_orientation(position, rotation, player_position, hmd_horz)
	mrotation.multiply(rotation, self._base_rotation)

	position = position + player_position
	position = position - hmd_horz
	position = position + self._base_position:rotate_with(rotation)
	self._rotation = rotation
	self._position = position
	self._forward = rotation:y()

	self:set_orientation(self._position, self._rotation)
end

-- Lines: 773 to 774
function PlayerMenuHandBase:position()
	return self._position
end

-- Lines: 777 to 778
function PlayerMenuHandBase:rotation()
	return self._rotation
end

-- Lines: 781 to 782
function PlayerMenuHandBase:forward()
	return self._forward
end

-- Lines: 785 to 786
function PlayerMenuHandBase:set_state(state)
end

-- Lines: 788 to 789
function PlayerMenuHandBase:laser_position()
	return self._laser_orientation_object:local_position()
end

-- Lines: 792 to 793
function PlayerMenuHandBase:set_orientation(position, rotation)
end
PlayerMenuHandUnit = PlayerMenuHandUnit or class(PlayerMenuHandBase)

-- Lines: 799 to 806
function PlayerMenuHandUnit:init(config)
	local hand_unit = World:spawn_unit(config.unit_name, Vector3(0, 0, 0), Rotation())

	hand_unit:set_extension_update_enabled(Idstring("warp"), false)
	hand_unit:set_extension_update_enabled(Idstring("melee"), false)
	hand_unit:damage():run_sequence_simple("hide_gadgets")

	self._unit = hand_unit

	self.super.init(self, config, hand_unit:get_object(config.laser_orientation_object))
end

-- Lines: 808 to 812
function PlayerMenuHandUnit:set_orientation(position, rotation)
	self._unit:set_position(position)
	self._unit:set_rotation(rotation)
	self._unit:set_moving(2)
end

-- Lines: 814 to 816
function PlayerMenuHandUnit:set_state(state)
	self._unit:damage():run_sequence_simple(state)
end

-- Lines: 818 to 819
function PlayerMenuHandUnit:unit()
	return self._unit
end
PlayerMenuHandObject = PlayerMenuHandObject or class(PlayerMenuHandBase)

-- Lines: 826 to 833
function PlayerMenuHandObject:init(config)
	self.super.init(self, config, config.laser_orientation_object)

	self._states = config.states

	self:_hide_all()

	if config.default_state then
		self:set_state(config.default_state)
	end
end

-- Lines: 835 to 840
function PlayerMenuHandObject:set_orientation(position, rotation)
	if self._object then
		self._object:set_position(position)
		self._object:set_rotation(rotation)
	end
end

-- Lines: 842 to 853
function PlayerMenuHandObject:_set_visibility(object, visibility)
	if object then
		local objects = {object}

		while #objects ~= 0 do
			local cur = table.remove(objects, 1)

			cur:set_visibility(visibility)

			for _, o in ipairs(cur:children()) do
				table.insert(objects, o)
			end
		end
	end
end

-- Lines: 855 to 865
function PlayerMenuHandObject:set_state(state)
	local obj = self._states[state]

	if self._object then
		self:_set_visibility(self._object, false)
	end

	if obj then
		self._object = obj

		self:_set_visibility(self._object, true)
	end
end

-- Lines: 867 to 871
function PlayerMenuHandObject:_hide_all()
	for _, o in pairs(self._states) do
		self:_set_visibility(o, false)
	end
end

-- Lines: 875 to 916
function PlayerMenu:_create_hands()
	if self._is_start_menu then
		self._hands = {
			PlayerMenuHandUnit:new({
				unit_name = Idstring("units/pd2_dlc_vr/player/vr_hand_right"),
				base_rotation = Rotation(math.X, -50),
				base_position = Vector3(0, -2, -7),
				laser_orientation_object = Idstring("a_laser")
			}),
			PlayerMenuHandUnit:new({
				unit_name = Idstring("units/pd2_dlc_vr/player/vr_hand_left"),
				base_rotation = Rotation(math.X, -50),
				base_position = Vector3(0, -2, -7),
				laser_orientation_object = Idstring("a_laser")
			})
		}
	else
		self._hands = {
			PlayerMenuHandObject:new({
				default_state = "idle",
				states = {
					idle = MenuRoom:get_object(Idstring("g_gloves_idle_right")),
					laser = MenuRoom:get_object(Idstring("g_gloves_laser_right"))
				},
				base_rotation = Rotation(math.X, -50),
				base_position = Vector3(0, -2, -7),
				laser_orientation_object = MenuRoom:get_object(Idstring("a_laser_right"))
			}),
			PlayerMenuHandObject:new({
				default_state = "idle",
				states = {
					idle = MenuRoom:get_object(Idstring("g_gloves_idle_left")),
					laser = MenuRoom:get_object(Idstring("g_gloves_laser_left"))
				},
				base_rotation = Rotation(math.X, -50),
				base_position = Vector3(0, -2, -7),
				laser_orientation_object = MenuRoom:get_object(Idstring("a_laser_left"))
			})
		}
	end
end

-- Lines: 918 to 946
function PlayerMenu:_create_camera()
	if self._is_start_menu then
		self._camera_object = World:create_camera()

		self._camera_object:set_near_range(3)
		self._camera_object:set_far_range(250000)
		self._camera_object:set_fov(75)
		self._camera_object:set_position(self._position)

		self._vp = managers.viewport:new_vp(0, 0, 1, 1, "menu_main")

		self._vp:set_camera(self._camera_object)
		self._vp:set_active(false)
	else
		self._camera_object = MenuRoom:create_camera()

		self._camera_object:set_near_range(3)
		self._camera_object:set_far_range(250000)
		self._camera_object:set_fov(75)
		self._camera_object:set_aspect_ratio(1.7777777777777777)
		self._camera_object:set_stereo(true)

		self._clear_vp = managers.viewport:new_vp(0, 0, 1, 1, "menu_vr_clear", CoreManagerBase.PRIO_WORLDCAMERA)

		self._clear_vp:set_render_params("GBufferClear", self._clear_vp:vp())
		self._clear_vp:set_camera(self._camera_object)
		self._clear_vp:set_active(false)

		self._vp = managers.viewport:new_vp(0, 0, 1, 1, "menu_vr", CoreManagerBase.PRIO_WORLDCAMERA)

		self._vp:set_render_params("MenuRoom", self._vp:vp())
		self._vp:set_camera(self._camera_object)
		self._vp:set_active(false)
	end
end

-- Lines: 958 to 960
function PlayerMenu:_set_viewport_active(active)
	self._vp:set_active(active)
end

-- Lines: 962 to 966
function PlayerMenu:_warp_target(to)
	if self._is_start_menu then
		self._warp_marker:set_position(to)
	end
end

-- Lines: 968 to 977
function PlayerMenu:_warp_ray(from, to)
	if self._is_start_menu then
		self._brush_warp:cylinder(from, to, 1)
	else
		local obj = self._mover_ray_obj

		obj:set_position(from)

		local v = (to - from):normalized()

		obj:set_rotation(Rotation:look_at(v, math.UP))
	end
end

-- Lines: 979 to 995
function PlayerMenu:_laser_ray(visible, from, to)
	if self._is_start_menu then
		if visible then
			self._brush_laser_dot:sphere(to, 1)
			self._brush_laser:cylinder(from, to, 0.25)
		end
	else
		local ray_obj = self._laser_ray_obj
		local dot_obj = self._laser_dot_obj

		if visible then
			ray_obj:cylinder(from, to, 0.25, 20, Color(0.05, 0, 1, 0))
			dot_obj:sphere(to, 1, 1, Color(1, 0, 1, 0))
		end

		ray_obj:set_visibility(visible)
		dot_obj:set_visibility(visible)
	end
end

-- Lines: 997 to 1024
function PlayerMenu:_update_fadeout(t, dt, distance)
	if not self._is_start_menu then
		return false
	end

	local fadeout_data = self._fadeout
	local fadeout = distance / 25
	fadeout = math.clamp(fadeout, 0, 1)

	if fadeout_data.value < fadeout then
		fadeout_data.value = math.step(fadeout_data.value, fadeout, fadeout < 1 and dt * 3 or dt * 10)
		fadeout_data.fadein_speed = 0
	elseif fadeout < fadeout_data.value then
		fadeout_data.value = math.step(fadeout_data.value, fadeout, dt * fadeout_data.fadein_speed)
		fadeout_data.fadein_speed = math.min(fadeout_data.fadein_speed + dt * 4, 3)
	end

	local v = fadeout_data.value
	fadeout_data.effect.color.alpha = v * v * (3 - 2 * v)

	if fadeout > 0.95 then
		self._position_reset_timer_t = self._position_reset_timer_t + dt
	else
		self._position_reset_timer_t = 0
	end

	return self._position_reset_timer_t > 0.2
end

-- Lines: 1027 to 1045
function PlayerMenu:_setup_draw()
	if self._is_start_menu then
		self._brush_warp = Draw:brush(Color(0.07, 0, 0.60784, 0.81176))

		self._brush_warp:set_blend_mode("opacity_add")

		self._brush_laser = Draw:brush(Color(0.05, 0, 1, 0))

		self._brush_laser:set_blend_mode("opacity_add")
		self._brush_laser:set_render_template(Idstring("LineObject"))

		self._brush_laser_dot = Draw:brush(Color(1, 0, 1, 0))

		self._brush_laser_dot:set_blend_mode("opacity_add")
		self._brush_laser_dot:set_render_template(Idstring("LineObject"))

		self._warp_marker = World:spawn_unit(Idstring("units/pd2_dlc_vr/player/vr_warper"), Vector3(0, 0, 0), Rotation())

		self._warp_marker:set_visible(false)
	else
		self._laser_ray_obj = MenuRoom:get_object(Idstring("laser_ray"))

		self._laser_ray_obj:set_visibility(false)

		self._laser_dot_obj = MenuRoom:get_object(Idstring("laser_dot"))

		self._laser_dot_obj:set_visibility(false)
	end
end

