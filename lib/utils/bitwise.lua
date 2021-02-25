Bitwise = Bitwise or class()

-- Lines 6-8
function Bitwise:init()
end

-- Lines 10-12
function Bitwise:lshift(x, by)
	return x * 2^by
end

-- Lines 16-18
function Bitwise:rshift(x, by)
	return math.floor(x / 2^by)
end
