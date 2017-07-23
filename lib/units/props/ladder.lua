Ladder = Ladder or class()
Ladder.ladders = Ladder.ladders or {}
Ladder.active_ladders = Ladder.active_ladders or {}
Ladder.ladder_index = 1
Ladder.LADDERS_PER_FRAME = 1
Ladder.DEBUG = false
Ladder.EVENT_IDS = {}

-- Lines: 10 to 11
function Ladder.current_ladder()
	return Ladder.active_ladders[Ladder.ladder_index]
end

-- Lines: 14 to 19
function Ladder.next_ladder()
	Ladder.ladder_index = Ladder.ladder_index + 1

	if #Ladder.active_ladders < Ladder.ladder_index then
		Ladder.ladder_index = 1
	end

	return Ladder.current_ladder()
end

-- Lines: 22 to 38
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

-- Lines: 40 to 67
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
	self._bottom = position
	self._top = top
	self._rotation = Rotation(self._w_dir, self._up, self._normal)
	self._corners = {
		position - (self._w_dir * self._width) / 2,
		position + (self._w_dir * self._width) / 2,
		top + (self._w_dir * self._width) / 2,
		top - (self._w_dir * self._width) / 2
	}
end

-- Lines: 69 to 73
function Ladder:update(t, dt)
	if Ladder.DEBUG then
		self:debug_draw()
	end
end
local mvec1 = Vector3()

-- Lines: 76 to 114
function Ladder:can_access(pos, move_dir)
	if not self._enabled then
		return
	end

	if Ladder.DEBUG then
		local brush = Draw:brush(Color.red)

		brush:cylinder(self._bottom, self._top, 5)
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

-- Lines: 116 to 145
function Ladder:check_end_climbing(pos, move_dir, gnd_ray)
	if not self._enabled then
		return true
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

-- Lines: 149 to 156
function Ladder:get_normal_move_offset(pos)
	mvector3.set(mvec1, pos)
	mvector3.subtract(mvec1, self._corners[1])

	local normal_move_offset = math.dot(self._normal, mvec1)
	normal_move_offset = math.lerp(0, self._normal_target_offset - normal_move_offset, 0.1)

	return normal_move_offset
end

-- Lines: 159 to 160
function Ladder:rotation()
	return self._rotation
end

-- Lines: 163 to 164
function Ladder:up()
	return self._up
end

-- Lines: 167 to 168
function Ladder:normal()
	return self._normal
end

-- Lines: 171 to 172
function Ladder:w_dir()
	return self._w_dir
end

-- Lines: 175 to 176
function Ladder:bottom()
	return self._bottom
end

-- Lines: 179 to 180
function Ladder:top()
	return self._top
end

-- Lines: 183 to 186
function Ladder:set_width(width)
	self._width = width

	self:set_config()
end

-- Lines: 188 to 189
function Ladder:width()
	return self._width
end

-- Lines: 192 to 195
function Ladder:set_height(height)
	self._height = height

	self:set_config()
end

-- Lines: 197 to 198
function Ladder:height()
	return self._height
end

-- Lines: 201 to 202
function Ladder:corners()
	return self._corners
end

-- Lines: 205 to 214
function Ladder:set_enabled(enabled)
	self._enabled = enabled

	if not self._enabled or not table.contains(Ladder.active_ladders, self._unit) then
		table.delete(Ladder.active_ladders, self._unit)
	end
end

-- Lines: 216 to 219
function Ladder:destroy(unit)
	table.delete(Ladder.ladders, self._unit)
	table.delete(Ladder.active_ladders, self._unit)
end

-- Lines: 221 to 236
function Ladder:debug_draw()
	local brush = Draw:brush(Color.white:with_alpha(0.5))

	brush:quad(self._corners[1], self._corners[2], self._corners[3], self._corners[4])

	for i = 1, 4, 1 do
		brush:line(self._corners[i], self._corners[i] + self._normal * (50 + i * 25))
	end

	local brush = Draw:brush(Color.red)

	brush:sphere(self._corners[1], 5)
end

-- Lines: 238 to 244
function Ladder:save(data)
	local state = {
		enabled = self._enabled,
		height = self._height,
		width = self._width
	}
	data.Ladder = state
end

-- Lines: 246 to 254
function Ladder:load(data)
	local state = data.Ladder

	if state.enabled ~= self._enabled then
		self:set_enabled(state.enabled)
	end

	self._width = state.width
	self._height = state.height

	self:set_config()
end

