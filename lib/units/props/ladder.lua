Ladder = Ladder or class()
Ladder.ladders = Ladder.ladders or {}
Ladder.active_ladders = Ladder.active_ladders or {}
Ladder.ladder_index = 1
Ladder.LADDERS_PER_FRAME = 1
Ladder.SNAP_LENGTH = 125
Ladder.SEGMENT_LENGTH = 200
Ladder.MOVER_NORMAL_OFFSET = 30
Ladder.EXIT_OFFSET_TOP = 50
Ladder.ON_LADDER_NORMAL_OFFSET = 60
Ladder.DEBUG = false
Ladder.EVENT_IDS = {}

-- Lines: 17 to 18
function Ladder.current_ladder()
	return Ladder.active_ladders[Ladder.ladder_index]
end

-- Lines: 21 to 26
function Ladder.next_ladder()
	Ladder.ladder_index = Ladder.ladder_index + 1

	if #Ladder.active_ladders < Ladder.ladder_index then
		Ladder.ladder_index = 1
	end

	return Ladder.current_ladder()
end

-- Lines: 29 to 45
function Ladder:init(unit)
	self._unit = unit
	self.normal_axis = self.normal_axis or "y"
	self.up_axis = self.up_axis or "z"
	self._offset = self._offset or 0

	self:set_enabled(true)

	self._climb_on_top_offset = 50
	self._normal_target_offset = self._normal_target_offset or 40

	self:set_config()
	table.insert(Ladder.ladders, self._unit)
end

-- Lines: 47 to 112
function Ladder:set_config()
	self._ladder_orientation_obj = self._unit:get_object(Idstring(self._ladder_orientation_obj_name))
	local rotation = self._ladder_orientation_obj:rotation()
	local position = self._ladder_orientation_obj:position()
	self._normal = rotation[self.normal_axis](rotation)

	if self.invert_normal_axis then
		mvector3.multiply(self._normal, -1)
	end

	self._up = rotation[self.up_axis](rotation)
	self._w_dir = math.cross(self._up, self._normal)
	position = position + self._up * self._offset
	local top = position + self._up * self._height
	local ray = self._unit:raycast("ray", top, position)

	if ray then
		position = ray.position
	end

	self._bottom = position
	self._top = top
	self._rotation = Rotation(self._w_dir, self._up, self._normal)
	self._corners = {
		position - (self._w_dir * self._width) / 2,
		position + (self._w_dir * self._width) / 2,
		top + (self._w_dir * self._width) / 2,
		top - (self._w_dir * self._width) / 2
	}
	local snap_start = Ladder.SNAP_LENGTH

	if 2 * Ladder.SNAP_LENGTH < self._height then
		self._climb_distance = self._height - 2 * Ladder.SNAP_LENGTH
	else
		snap_start = self._height * 0.2
		self._climb_distance = self._height * 0.6
	end

	self._start_point = self._bottom + self._up * snap_start + self._normal * Ladder.MOVER_NORMAL_OFFSET
	local segments = 1

	if Ladder.SEGMENT_LENGTH < self._climb_distance then
		segments = self._climb_distance / Ladder.SEGMENT_LENGTH
		local percent = (segments - math.floor(segments)) / math.floor(segments)
		segments = percent > 0.1 and math.ceil(segments) or math.floor(segments)
	end

	self._segments = segments
	self._top_exit = mvector3.copy(self._normal)

	mvector3.multiply(self._top_exit, -Ladder.EXIT_OFFSET_TOP)
	mvector3.add(self._top_exit, self._top)

	self._bottom_exit = mvector3.copy(self._normal)

	mvector3.multiply(self._bottom_exit, Ladder.MOVER_NORMAL_OFFSET)
	mvector3.add(self._bottom_exit, self._bottom)

	self._up_dot = math.dot(self._up, math.UP)
	self._w_dir_half = self._w_dir * self._width * 0.5
end

-- Lines: 114 to 118
function Ladder:update(t, dt)
	if Ladder.DEBUG then
		self:debug_draw()
	end
end
local mvec1 = Vector3()

-- Lines: 121 to 165
function Ladder:can_access(pos, move_dir)
	if not self._enabled then
		return
	end

	if Ladder.DEBUG then
		local brush = Draw:brush(Color.red)

		brush:cylinder(self._bottom, self._top, 5)
	end

	if _G.IS_VR then
		return self:_can_access_vr(pos, move_dir)
	end

	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local n_dot = mvector3.dot(self._normal, mvec1)

	if n_dot < 0 or n_dot > 50 then
		return false
	end

	local w_dot = mvector3.dot(self._w_dir, mvec1)

	if w_dot < 0 or self._width < w_dot then
		return false
	end

	local h_dot = mvector3.dot(self._up, mvec1)

	if h_dot < 0 or self._height < h_dot then
		return false
	end

	local towards_dot = mvector3.dot(move_dir, self._normal)

	if self._height - self._climb_on_top_offset < h_dot then
		return towards_dot > 0.5
	end

	if towards_dot < -0.5 then
		return true
	end
end

-- Lines: 168 to 173
function Ladder:_can_access_vr(pos, move_dir)
	local min_dis = tweak_data.vr.ladder.distance * tweak_data.vr.ladder.distance

	if mvector3.distance_sq(pos, self:bottom()) < min_dis or mvector3.distance_sq(pos, self:top()) < min_dis then
		return true
	end
end

-- Lines: 175 to 199
function Ladder:_check_end_climbing_vr(pos, move_dir, gnd_ray)
	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local w_dot = mvector3.dot(self._w_dir, mvec1)
	local h_dot = mvector3.dot(self._up, mvec1)

	if w_dot < 100 or self._width + 100 < w_dot then
		return true
	elseif h_dot < 0 or self._height < h_dot then
		return true
	elseif gnd_ray and move_dir then
		local towards_dot = mvector3.dot(move_dir, self._normal)

		if towards_dot > 0 then
			if self._height - self._climb_on_top_offset < h_dot then
				return false
			end

			return true
		end
	end
end

-- Lines: 202 to 237
function Ladder:check_end_climbing(pos, move_dir, gnd_ray)
	if not self._enabled then
		return true
	end

	if _G.IS_VR then
		return self:_check_end_climbing_vr(pos, move_dir, gnd_ray)
	end

	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local w_dot = mvector3.dot(self._w_dir, mvec1)
	local h_dot = mvector3.dot(self._up, mvec1)

	if w_dot < 0 or self._width < w_dot then
		return true
	elseif h_dot < 0 or self._height < h_dot then
		return true
	elseif gnd_ray and move_dir then
		local towards_dot = mvector3.dot(move_dir, self._normal)

		if towards_dot > 0 then
			if self._height - self._climb_on_top_offset < h_dot then
				return false
			end

			return true
		end
	end
end

-- Lines: 241 to 248
function Ladder:get_normal_move_offset(pos)
	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local normal_move_offset = math.dot(self._normal, mvec1)
	normal_move_offset = math.lerp(0, self._normal_target_offset - normal_move_offset, 0.1)

	return normal_move_offset
end

-- Lines: 251 to 255
function Ladder:position(t)
	local pos = mvector3.copy(self._up)

	mvector3.multiply(pos, t * self._climb_distance)
	mvector3.add(pos, self._start_point)

	return pos
end

-- Lines: 258 to 271
function Ladder:on_ladder(pos, t)
	local l_pos = self:position(t) - self._w_dir_half

	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, l_pos)

	local w_dot = math.dot(self._w_dir, mvec1)

	if w_dot < 0 or self._width < w_dot then
		return false
	end

	local n_dot = math.dot(self._normal, mvec1)

	if Ladder.ON_LADDER_NORMAL_OFFSET < n_dot then
		return false
	end

	return true
end

-- Lines: 274 to 280
function Ladder:horizontal_offset(pos)
	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._bottom)

	local offset = mvector3.copy(self._w_dir)

	mvector3.multiply(offset, math.dot(self._w_dir, mvec1))

	return offset
end

-- Lines: 283 to 284
function Ladder:rotation()
	return self._rotation
end

-- Lines: 287 to 288
function Ladder:up()
	return self._up
end

-- Lines: 291 to 292
function Ladder:normal()
	return self._normal
end

-- Lines: 295 to 296
function Ladder:w_dir()
	return self._w_dir
end

-- Lines: 299 to 300
function Ladder:bottom()
	return self._bottom
end

-- Lines: 303 to 304
function Ladder:bottom_exit()
	return self._bottom_exit
end

-- Lines: 307 to 308
function Ladder:top()
	return self._top
end

-- Lines: 311 to 312
function Ladder:top_exit()
	return self._top_exit
end

-- Lines: 315 to 316
function Ladder:segments()
	return self._segments
end

-- Lines: 319 to 322
function Ladder:set_width(width)
	self._width = width

	self:set_config()
end

-- Lines: 324 to 325
function Ladder:width()
	return self._width
end

-- Lines: 328 to 331
function Ladder:set_height(height)
	self._height = height

	self:set_config()
end

-- Lines: 333 to 334
function Ladder:height()
	return self._height
end

-- Lines: 337 to 338
function Ladder:corners()
	return self._corners
end

-- Lines: 341 to 350
function Ladder:set_enabled(enabled)
	self._enabled = enabled

	if self._enabled then
		if not table.contains(Ladder.active_ladders, self._unit) then
			table.insert(Ladder.active_ladders, self._unit)
		end
	else
		table.delete(Ladder.active_ladders, self._unit)
	end
end

-- Lines: 352 to 355
function Ladder:destroy(unit)
	table.delete(Ladder.ladders, self._unit)
	table.delete(Ladder.active_ladders, self._unit)
end

-- Lines: 357 to 372
function Ladder:debug_draw()
	local brush = Draw:brush(Color.white:with_alpha(0.5))

	brush:quad(self._corners[1], self._corners[2], self._corners[3], self._corners[4])

	for i = 1, 4, 1 do
		brush:line(self._corners[i], self._corners[i] + self._normal * (50 + i * 25))
	end

	local brush = Draw:brush(Color.red)

	brush:sphere(self._corners[1], 5)
end

-- Lines: 374 to 380
function Ladder:save(data)
	local state = {
		enabled = self._enabled,
		height = self._height,
		width = self._width
	}
	data.Ladder = state
end

-- Lines: 382 to 390
function Ladder:load(data)
	local state = data.Ladder

	if state.enabled ~= self._enabled then
		self:set_enabled(state.enabled)
	end

	self._width = state.width
	self._height = state.height

	self:set_config()
end

