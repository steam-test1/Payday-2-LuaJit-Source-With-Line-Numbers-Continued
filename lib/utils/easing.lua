Easing = {}
local mlerp = math.lerp
local mpow = math.pow
local msin = math.sin
local mcos = math.cos
local msqrt = math.sqrt
local mabs = math.abs
local masin = math.asin
local pi = math.pi

-- Lines: 19 to 20
function Easing.linear(a, b, t)
	return mlerp(a, b, t)
end

-- Lines: 25 to 26
function Easing.in_quad(a, b, t)
	return (b - a) * t * t + a
end

-- Lines: 29 to 30
function Easing.out_quad(a, b, t)
	return -(b - a) * t * (t - 2) + a
end

-- Lines: 33 to 40
function Easing.inout_quad(a, b, t)
	t = t * 2

	if t < 1 then
		return (b - a) * 0.5 * t * t + a
	else
		return -(b - a) * 0.5 * ((t - 1) * (t - 3) - 1) + a
	end
end

-- Lines: 42 to 50
function Easing.outin_quad(a, b, t)
	t = t * 2
	local c = (b - a) * 0.5

	if t < 1 then
		return Easing.out_quad(a, c, t)
	else
		return Easing.in_quad(a + c, b, t - 1) + c
	end
end

-- Lines: 54 to 55
function Easing.in_cubic(a, b, t)
	return (b - a) * t * t * t + a
end

-- Lines: 58 to 60
function Easing.out_cubic(a, b, t)
	t = t - 1

	return (b - a) * (t * t * t + 1) + a
end

-- Lines: 63 to 71
function Easing.inout_cubic(a, b, t)
	t = t * 2

	if t < 1 then
		return (b - a) * 0.5 * t * t * t + a
	else
		t = t - 2

		return (b - a) * 0.5 * (t * t * t + 2) + a
	end
end

-- Lines: 73 to 81
function Easing.outin_cubic(a, b, t)
	t = t * 2
	local c = (b - a) * 0.5

	if t < 1 then
		return Easing.out_cubic(a, c, t)
	else
		return Easing.in_cubic(a + c, b, t - 1) + c
	end
end

-- Lines: 85 to 86
function Easing.in_quart(a, b, t)
	return (b - a) * t * t * t * t + a
end

-- Lines: 89 to 91
function Easing.out_quart(a, b, t)
	t = t - 1

	return -(b - a) * (t * t * t * t - 1) + a
end

-- Lines: 94 to 102
function Easing.inout_quart(a, b, t)
	t = t * 2

	if t < 1 then
		return (b - a) * 0.5 * t * t * t * t + a
	else
		t = t - 2

		return -(b - a) * 0.5 * (t * t * t * t - 2) + a
	end
end

-- Lines: 104 to 112
function Easing.outin_quart(a, b, t)
	t = t * 2
	local c = (b - a) * 0.5

	if t < 1 then
		return Easing.out_quart(a, c, t)
	else
		return Easing.in_quart(a + c, b, t - 1) + c
	end
end

-- Lines: 116 to 117
function Easing.in_quint(a, b, t)
	return (b - a) * t * t * t * t * t + a
end

-- Lines: 120 to 122
function Easing.out_quint(a, b, t)
	t = t - 1

	return (b - a) * (t * t * t * t * t + 1) + a
end

-- Lines: 125 to 133
function Easing.inout_quint(a, b, t)
	t = t * 2

	if t < 1 then
		return (b - a) * 0.5 * t * t * t * t * t + a
	else
		t = t - 2

		return (b - a) * 0.5 * (t * t * t * t * t + 2) + a
	end
end

-- Lines: 135 to 143
function Easing.outin_quint(a, b, t)
	t = t * 2
	local c = (b - a) * 0.5

	if t < 1 then
		return Easing.out_quint(a, c, t)
	else
		return Easing.in_quint(a + c, b, t - 1) + c
	end
end

-- Lines: 147 to 154
function Easing.in_expo(a, b, t)
	if t == 0 then
		return a
	else
		local c = b - a

		return c * mpow(2, 10 * (t - 1)) - c * 0.001 + a
	end
end

-- Lines: 156 to 163
function Easing.out_expo(a, b, t)
	if t == 1 then
		return b
	else
		local c = b - a

		return c * 1.001 * (-mpow(2, -10 * t) + 1) + a
	end
end

-- Lines: 166 to 183
function Easing.inout_expo(a, b, t)
	if t == 1 then
		return b
	elseif t == 0 then
		return a
	end

	t = t * 2

	if t < 1 then
		local c = b - a

		return c * 0.5 * mpow(2, 10 * (t - 1)) - c * 0.0005 + a
	else
		t = t - 1
		local c = b - a

		return c * 0.5 * 1.0005 * (-mpow(2, -10 * t) + 2) + a
	end
end

-- Lines: 185 to 193
function Easing.outin_expo(a, b, t)
	t = t * 2
	local c = (b - a) * 0.5

	if t < 1 then
		return Easing.out_expo(a, c, t)
	else
		return Easing.in_expo(a + c, b, t - 1) + c
	end
end

