local sqrt = math.sqrt
local abs = math.abs
local min = math.min
local max = math.max
local sin = math.sin
local cos = math.cos
local radians = math.rad
local degrees = math.deg
local atan2 = math.atan2

-- Lines 8-13
local function hypot(a, b)
	if a == 0 and b == 0 then
		return 0
	end

	b = abs(b)
	a = abs(a)
	b = min(a, b)
	a = max(a, b)

	return a * sqrt(1 + (b / a)^2)
end

-- Lines 16-18
local function distance(x1, y1, x2, y2)
	return hypot(x2 - x1, y2 - y1)
end

-- Lines 21-23
local function distance2(x1, y1, x2, y2)
	return (x2 - x1)^2 + (y2 - y1)^2
end

-- Lines 26-31
local function point_around(cx, cy, r, angle)
	angle = radians(angle)

	return cx + cos(angle) * r, cy + sin(angle) * r
end

-- Lines 34-40
local function rotate_point(x, y, cx, cy, angle)
	if angle == 0 then
		return x, y
	end

	angle = radians(angle)
	y = y - cy
	x = x - cx
	local c = cos(angle)
	local s = sin(angle)

	return cx + x * c - y * s, cy + y * c + x * s
end

-- Lines 43-45
local function point_angle(x, y, cx, cy)
	return degrees(atan2(y - cy, x - cx))
end

-- Lines 48-50
local function reflect_point(x, y, cx, cy)
	return 2 * cx - x, 2 * cy - y
end

-- Lines 53-60
local function reflect_point_distance(x, y, cx, cy, length)
	local d = distance(x, y, cx, cy)

	if d == 0 then
		return cx, cy
	end

	local scale = length / d

	return cx + (cx - x) * scale, cy + (cy - y) * scale
end

return {
	hypot = hypot,
	distance = distance,
	distance2 = distance2,
	point_around = point_around,
	rotate_point = rotate_point,
	point_angle = point_angle,
	reflect_point = reflect_point,
	reflect_point_distance = reflect_point_distance
}
