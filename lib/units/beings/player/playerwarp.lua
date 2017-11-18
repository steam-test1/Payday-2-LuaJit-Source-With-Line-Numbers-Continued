WarpTargetMarker = WarpTargetMarker or class()
local bezier3 = require("lib/utils/Bezier3")
local MARKER_UNIT_ID = Idstring("units/pd2_dlc_vr/player/vr_warper")
local LADDER_UNIT_ID = Idstring("units/pd2_dlc_vr/player/vr_ladder")
WarpTargetMarker.SEQUENCES = {
	jump = "warp_jump",
	ladder = "warp_ladder",
	jump_start = "warp_orange",
	move = "warp_blue"
}

-- Lines: 9 to 15
function WarpTargetMarker:init(unit_name)
	self._unit = World:spawn_unit(unit_name, Vector3(), Rotation())

	self._unit:set_visible(false)

	self._damage_ext = self._unit:damage()
	self._enabled = false
	self._sequence = nil
end

-- Lines: 18 to 32
function WarpTargetMarker:show(marker_type)
	local sequence = self.SEQUENCES[marker_type] or "warp_blue"

	if self._sequence ~= sequence then
		self._sequence = sequence

		if self._damage_ext:has_sequence(sequence) then
			self._damage_ext:run_sequence_simple(sequence)
		end
	end

	if not self._enabled then
		self._unit:set_visible(true)

		self._enabled = true
	end
end

-- Lines: 34 to 39
function WarpTargetMarker:hide()
	if self._enabled then
		self._unit:set_visible(false)

		self._enabled = false
	end
end

-- Lines: 41 to 42
function WarpTargetMarker:enabled()
	return self._enabled
end

-- Lines: 45 to 49
function WarpTargetMarker:set_orientation(position, rotation)
	self._unit:set_position(position)
	self._unit:set_rotation(rotation)
	self._unit:set_moving(2)
end
PlayerWarp = PlayerWarp or class()
local MAX_MOVEMENT_DISTANCE = 500
local MAX_JUMP_DISTANCE = 450
local MAX_TARGET_TO_RAY_DISTANCE = 600
local MAX_JUMP_HEIGHT_THRESHOLD = 120
local MIN_JUMP_TARGET_TO_WARP_THRESHOLD = 25
local MAX_JUMP_HEIGHT = (tweak_data.player.movement_state.standard.movement.jump_velocity.z * tweak_data.player.movement_state.standard.movement.jump_velocity.z) / 1964
PlayerWarp.TARGET_TYPE = 0

-- Lines: 64 to 104
function PlayerWarp:init(hand_unit)
	self._unit = hand_unit
	self._targeting = false
	self._slotmask = managers.slot:get_mask("statics")
	self._brush_blocked = Draw:brush(Color(0.15, 1, 0, 0))

	self._brush_blocked:set_blend_mode("opacity_add")

	self._brush = Draw:brush(Color(0.07, 0, 0.60784, 0.81176))

	self._brush:set_blend_mode("opacity_add")

	self._brush2 = Draw:brush(Color(0.15, 0, 1, 0))

	self._brush2:set_blend_mode("opacity_add")

	self._brush_interact = Draw:brush(Color(0.15, 1, 1, 0))

	self._brush_interact:set_blend_mode("opacity_add")

	self._brush_text = Draw:brush(Color(1, 1, 1, 1))

	self._brush_text:set_font(Idstring("core/fonts/system_font"), 5)
	self._brush_text:set_render_template(Idstring("OverlayText"))
	self._brush_text:set_depth_mode("disabled")

	self._blocked = false
	self._target = {
		type = "",
		position = Vector3()
	}
	self._snap_points = {}
	self._range = MAX_MOVEMENT_DISTANCE
	self._max_range = MAX_MOVEMENT_DISTANCE
	self._max_jump_distance = MAX_JUMP_DISTANCE
	self._jump_move_speed = MAX_JUMP_DISTANCE / ((2 * tweak_data.player.movement_state.standard.movement.jump_velocity.z) / 982)
	self._enable_jump = false
	self._warp_markers = {}

	table.insert(self._warp_markers, WarpTargetMarker:new(MARKER_UNIT_ID))
	table.insert(self._warp_markers, WarpTargetMarker:new(MARKER_UNIT_ID))

	self._ladders = {}
	self._ladder_marker = World:spawn_unit(LADDER_UNIT_ID, Vector3(), Rotation())

	self:hide_ladder_marker()
end

-- Lines: 106 to 118
function PlayerWarp:show_ladder_marker(ladder, going_down, idle)
	self._active_ladder = ladder
	self._going_down_ladder = going_down

	self._ladder_marker:set_position(going_down and ladder:ladder():top() or ladder:ladder():bottom())

	local ladder_rot = ladder:rotation()

	if going_down then
		ladder_rot = ladder_rot * Rotation(180)
	end

	self._ladder_marker:set_rotation(ladder_rot)
	self._ladder_marker:damage():run_sequence_simple("ladder_" .. (going_down and "down" or "up") .. (idle and "_idle" or ""))
end

-- Lines: 120 to 123
function PlayerWarp:hide_ladder_marker()
	self._active_ladder = nil

	self._ladder_marker:damage():run_sequence_simple("ladder_hide")
end

-- Lines: 125 to 129
function PlayerWarp:hide_markers()
	for i = 1, #self._warp_markers, 1 do
		self._warp_markers[i]:hide()
	end
end

-- Lines: 131 to 142
function PlayerWarp:show_markers(...)
	local args = {...}
	local nr_args = #args

	for i = 1, #self._warp_markers, 1 do
		if i <= nr_args then
			self._warp_markers[i]:show(args[i].name)
			self._warp_markers[i]:set_orientation(args[i].position, args[i].rotation)
		else
			self._warp_markers[i]:hide()
		end
	end
end

-- Lines: 144 to 146
function PlayerWarp:set_player_unit(player_unit)
	self._player_unit = player_unit
end

-- Lines: 148 to 165
function PlayerWarp:set_targeting(enabled)
	if enabled ~= self._targeting then
		for _, ladder in ipairs(self._ladders) do
			local going_down = ladder:ladder():top().z < self._unit:position().z

			if enabled and mvector3.distance_sq(self._unit:position(), going_down and ladder:ladder():top() or ladder:ladder():bottom()) < 250000 and mvector3.dot(self._unit:rotation():y(), ladder:ladder():normal() * (going_down and -1 or 1)) < 0 then
				self:show_ladder_marker(ladder, going_down, true)
			else
				self:hide_ladder_marker()
			end
		end
	end

	self._targeting = enabled

	if not self._targeting then
		self:hide_markers()
	end
end

-- Lines: 167 to 168
function PlayerWarp:target_position()
	return self._target.position
end

-- Lines: 171 to 172
function PlayerWarp:target_type()
	return self._target.type
end

-- Lines: 175 to 176
function PlayerWarp:target_data()
	return self._target.data
end

-- Lines: 179 to 181
function PlayerWarp:clear_snap_points()
	self._snap_points = {}
end

-- Lines: 183 to 185
function PlayerWarp:add_snap_point(position, type, tolerance, data)
	table.insert(self._snap_points, {
		position = position,
		type = type,
		tolerance = tolerance,
		data = data
	})
end

-- Lines: 187 to 189
function PlayerWarp:clear_ladders()
	self._ladders = {}
end

-- Lines: 191 to 193
function PlayerWarp:add_ladder(ladder)
	table.insert(self._ladders, ladder)
end


-- Lines: 195 to 209
local function brush_debug_print(brush, position, ysize, text_data)
	local ypos = 0
	local t = text_data

	if type(t) == "string" then
		t = {text_data}
	end

	for _, text in ipairs(t) do
		for line in string.gmatch(text, "([^\r\n]+)") do
			brush:text(position + Vector3(0, 0, ypos), line)

			ypos = ypos - ysize
		end
	end
end

local jump_vec = Vector3()

-- Lines: 213 to 280
function PlayerWarp:update(unit, t, dt)
	if self._targeting then
		self._target.position = nil
		self._aim_position = nil
		local pos = unit:position()
		local ppos = self._player_unit:position()
		local forward = unit:rotation():y()
		local sp_found = false

		for _, sp in ipairs(self._snap_points) do
			if self:_check_snap_point(pos, forward, sp) then
				sp_found = true
				self._target.position = sp.position
				self._target.type = sp.type
				self._target.data = sp.data
				self._aim_position = sp.position

				break
			end
		end

		if self._active_ladder then
			local ladder = self._active_ladder:ladder()
			local ladder_pos = self._going_down_ladder and ladder:top() or ladder:bottom()

			if mvector3.distance_sq(pos, ladder_pos) < 250000 and mvector3.dot(forward, (ladder_pos - pos):normalized()) > 0.95 then
				if self._target.type ~= "ladder" then
					self:show_ladder_marker(self._active_ladder, self._going_down_ladder)
				end

				sp_found = true
				self._target.position = ladder_pos + ladder:normal() * 40
				self._target.type = "ladder"
				self._target.data = self._active_ladder
				self._aim_position = self._target.position
			elseif self._target.type == "ladder" then
				self:show_ladder_marker(self._active_ladder, self._going_down_ladder, true)
			end
		end

		if not sp_found then
			self:_find_warp_position(ppos, pos, forward)
		end

		local brush = self._blocked and self._brush_blocked or self._target.type == "move" and self._brush or self._brush_interact

		self:_draw(brush, pos)

		if Global.debug_warp and self._target.position then
			local warp_type = sp_found and "special" or self._target.type
			local info = {
				"Max range: " .. tostring(math.round(self._max_range, 0.01)),
				"Max jump: " .. tostring(math.round(self._max_jump_distance, 0.01)),
				"Warp type: " .. tostring(warp_type),
				"Distance: " .. tostring(math.round((self._target.position - ppos):length(), 0.01)),
				"Elevation: " .. tostring(math.round((self._target.position - ppos).z, 0.01))
			}
			local dir = self._target.position - ppos

			mvector3.set_z(dir, 0)

			local distance = mvector3.normalize(dir)
			local right = Vector3(0, 0, 0)

			mvector3.cross(right, dir, math.UP)

			local text_pos = (ppos + dir * math.min(distance, 200)) - right * 10 + dir * 30

			mvector3.set_z(text_pos, self._target.position.z + 50)
			brush_debug_print(self._brush_text, text_pos - right * 10, 5, info)
		end
	end
end

-- Lines: 282 to 284
function PlayerWarp:set_range(range)
	self._range = math.min(range, self._max_range)
end

-- Lines: 286 to 289
function PlayerWarp:set_max_range(max_range)
	self._max_range = max_range
	self._range = math.min(self._range, max_range)
end

-- Lines: 291 to 293
function PlayerWarp:set_enable_jump(enabled)
	self._enable_jump = enabled
end

-- Lines: 295 to 297
function PlayerWarp:set_max_jump_distance(max_jump_distance)
	self._max_jump_distance = max_jump_distance
end

-- Lines: 299 to 301
function PlayerWarp:set_jump_move_speed(speed)
	self._jump_move_speed = speed
end

-- Lines: 303 to 305
function PlayerWarp:set_blocked(blocked)
	self._blocked = blocked
end

-- Lines: 307 to 347
function PlayerWarp:_draw_bezier(brush, source, target, tangent)
	local line_segments = {}
	local v = target - source

	mvector3.set_z(v, 0)

	local xmax = mvector3.normalize(v)
	local p = source + tangent * xmax / 2
	local x1 = 0
	local y1 = source.z
	local x2 = xmax / 2
	local y2 = p.z
	local x3 = xmax / 2
	local y3 = p.z
	local x4 = xmax
	local y4 = target.z
	local angle_tolerance = 0
	local cusp_limit = 0
	local scale = 1

	table.insert(line_segments, {
		0,
		source.z
	})
	bezier3.interpolate(function (s, x, y)
		table.insert(line_segments, {
			x,
			y
		})
	end, x1, y1, x2, y2, x3, y3, x4, y4, scale, angle_tolerance, cusp_limit)

	local n = #line_segments

	for i = 1, n - 1, 1 do
		local p1 = source + v * line_segments[i][1]

		mvector3.set_z(p1, line_segments[i][2])

		local p2 = source + v * line_segments[i + 1][1]

		mvector3.set_z(p2, line_segments[i + 1][2])
		brush:cylinder(p1, p2, 1)

		line_segments[i] = nil
	end
end

-- Lines: 349 to 383
function PlayerWarp:_draw(brush, unit_pos)
	local yaw = self._player_unit:camera():rotation():yaw()

	if PlayerWarp.TARGET_TYPE == 0 then
		brush:cylinder(unit_pos, self._aim_position, 1)
	elseif PlayerWarp.TARGET_TYPE == 1 and self._target.position then
		self:_draw_bezier(brush, unit_pos, self._target.position, (self._aim_position - unit_pos):normalized())
	elseif PlayerWarp.TARGET_TYPE == 2 and self._target.position then
		local v = (self._target.position - self._player_unit:position()) * 0.5 + Vector3(0, 0, 50)

		self:_draw_bezier(brush, self._player_unit:position(), self._target.position, v:normalized())
	elseif PlayerWarp.TARGET_TYPE == 3 and self._target.position then
		local v = (self._target.position - self._player_unit:position()) * 0.5 + Vector3(0, 0, 100)

		self:_draw_bezier(brush, self._player_unit:position() + Vector3(0, 0, 50), self._target.position, v:normalized())
	end

	if self._target.position then
		local primary_target = {
			name = self._target.type,
			position = self._target.position,
			rotation = Rotation(yaw, 0, 0)
		}
		local secondary_target = nil

		if self._target.type == "jump" then
			secondary_target = {
				name = "jump_start",
				position = self._jump_start_position,
				rotation = Rotation(yaw, 0, 0)
			}
			local pos = self._jump_start_position
			local dir = self._target.position - pos
			local target_rel_height = dir.z

			mvector3.set_z(dir, 0)

			local jump_length = mvector3.normalize(dir)

			brush:bezier_cylinder(pos, dir, math.UP, Vector3(0, 0, 0), Vector3(jump_length * 0.5, MAX_JUMP_HEIGHT, 0), Vector3(jump_length * 0.5, MAX_JUMP_HEIGHT, 0), Vector3(jump_length, target_rel_height, 0), 1, 20)
		end

		self:show_markers(primary_target, secondary_target)
	else
		self:hide_markers()
	end
end

-- Lines: 385 to 425
function PlayerWarp:_find_warp_position(player_position, pos, forward)
	local warp_target, jump_target = self:_find_target(player_position, pos, forward)
	self._target.type = "move"
	self._target.data = nil
	self._aim_position = pos + forward * self._max_range
	local warp_pos = player_position
	local good_warp_pos = false

	if warp_target then
		local found_warp_position, best_warp_position = self._player_unit:find_warp_position(15, 0.2, 350, 10, warp_target)
		warp_pos = best_warp_position
		self._target.position = best_warp_position
	end

	if jump_target and self:_is_jump_candidate(player_position, warp_pos, warp_target, jump_target) then
		mvector3.set_z(jump_vec, tweak_data.player.movement_state.standard.movement.jump_velocity.z)

		local found_jump_position, best_jump_position = self._player_unit:find_warp_jump_position(8, 0.2, self._jump_move_speed, jump_vec, jump_target)

		if found_jump_position then
			local v = best_jump_position - jump_target
			local height_diff = math.abs(v.z)
			local d = math.sqrt(v.x * v.x + v.y * v.y)

			if height_diff < 20 and d < 50 and MIN_JUMP_TARGET_TO_WARP_THRESHOLD < mvector3.distance(warp_pos, best_jump_position) then
				self._target.position = best_jump_position
				self._target.type = "jump"
				self._jump_start_position = player_position
			end
		end
	end
end

-- Lines: 432 to 471
function PlayerWarp:_is_jump_candidate(player_position, warp_position, warp_target, jump_target)
	if not self._enable_jump then
		return false
	end

	if alive(self._player_unit) and (self._player_unit:movement():current_state_name() == "mask_off" or self._player_unit:movement():current_state_name() == "civilian") then
		return false
	end

	if self._max_jump_distance < mvector3.distance(player_position, jump_target) then
		return false
	end

	if math.abs(warp_position.z - jump_target.z) < MIN_JUMP_TARGET_TO_WARP_THRESHOLD then
		return false
	end

	if mvector3.distance(warp_position, jump_target) < 30 then
		return false
	end

	if MAX_JUMP_HEIGHT_THRESHOLD < math.abs(jump_target.z - player_position.z) then
		return false
	end

	if player_position.z < jump_target.z then
		local v = player_position - jump_target
		local jump_time = math.max(math.sqrt(v.x * v.x + v.y * v.y) / self._jump_move_speed, tweak_data.player.movement_state.standard.movement.jump_velocity.z / 982)
		local height = tweak_data.player.movement_state.standard.movement.jump_velocity.z * jump_time - 491 * jump_time * jump_time

		if height < jump_target.z - player_position.z then
			return false
		end
	end

	return true
end

-- Lines: 474 to 481
function PlayerWarp:_can_see_target(position, target)
	if target then
		ray = self._unit:raycast("ray", position, target, "slot_mask", self._slotmask, "ray_type", "body walk")

		if ray and mvector3.distance_sq(ray.position, target) > 1 then
			return false
		end
	end

	return true
end


-- Lines: 484 to 489
local function clip_line_to_sphere(origin, radius, position, direction)
	local o_c = position - origin
	local p = mvector3.dot(o_c, direction)
	local q = mvector3.dot(o_c, o_c) - radius * radius
	local length = -p + math.sqrt(p * p - q)

	return length > 0 and length or 0
end


-- Lines: 494 to 581
function PlayerWarp:_find_target(player_position, position, forward)
	if mvector3.dot(forward, math.UP) > 0.8 then
		return nil
	end

	local wall_mover_fit = 5
	local to, ray, warp_target, jump_target = nil
	to = position + forward * clip_line_to_sphere(player_position, self._range, position, forward)

	if self._max_range < self._max_jump_distance then
		local to_max = position + forward * clip_line_to_sphere(player_position, self._max_jump_distance, position, forward)
		ray = self._unit:raycast("ray", position, to_max, "slot_mask", self._slotmask, "sphere_cast_radius", 7.5, "ray_type", "body walk")

		if ray then
			jump_target = ray.position

			if self._range < mvector3.distance(ray.position, position) then
				ray = nil
			end
		else
			local ray_to_ground = self._unit:raycast("ray", to_max, to_max + math.DOWN * (self._max_jump_distance + MAX_TARGET_TO_RAY_DISTANCE), "slot_mask", self._slotmask, "ray_type", "body walk")

			if ray_to_ground then
				jump_target = ray_to_ground.position
			end
		end
	else
		ray = self._unit:raycast("ray", position, to, "slot_mask", self._slotmask, "sphere_cast_radius", 7.5, "ray_type", "body walk")
	end

	if ray then
		warp_target = ray.position
		jump_target = jump_target or warp_target
		local d = mvector3.dot(ray.normal, math.UP)

		if d < 0.49 then
			local v = ray.normal - d * math.UP
			warp_target = warp_target + v * math.min(wall_mover_fit, mvector3.distance(warp_target, position))
			v = position - warp_target
			local a = mvector3.normalize(v)
			local angle = mvector3.dot(v, math.DOWN)
			local b = self._range
			local a_angle = a * angle
			local c = a_angle + math.sqrt(a_angle * a_angle - (a * a - b * b))
			ray = self._unit:raycast("ray", warp_target, warp_target + math.DOWN * c, "slot_mask", self._slotmask, "ray_type", "body walk")

			if ray then
				warp_target = ray.position
			else
				warp_target = nil
			end
		end
	else
		ray = self._unit:raycast("ray", to, to + math.DOWN * (self._range + MAX_TARGET_TO_RAY_DISTANCE), "slot_mask", self._slotmask, "ray_type", "body walk")

		if ray then
			warp_target = ray.position
			jump_target = jump_target or ray.position
		end
	end

	if warp_target and self._can_see_target(position, warp_target + Vector3(0, 0, 10)) == false then
		warp_target = nil
	end

	if jump_target and self._can_see_target(position, jump_target + Vector3(0, 0, 10)) == false then
		jump_target = nil
	end

	return warp_target, jump_target
end

-- Lines: 584 to 599
function PlayerWarp:_check_snap_point(position, forward, sp)
	local dir = mvector3.copy(sp.position)

	mvector3.subtract(dir, position)

	local length = mvector3.normalize(dir)

	if sp.tolerance < length or self._range < length then
		return false
	end

	local d = length / math.dot(dir, forward)
	local p = position + forward * d
	length = mvector3.length(p - sp.position)

	if length <= sp.tolerance then
		return true
	end

	return false
end

