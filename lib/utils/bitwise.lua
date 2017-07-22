Bitwise = Bitwise or class()

-- Lines: 7 to 8
function Bitwise:init()
end

-- Lines: 10 to 11
function Bitwise:lshift(x, by)
	return x * 2 ^ by
end

-- Lines: 16 to 17
function Bitwise:rshift(x, by)
	return math.floor(x / 2 ^ by)
end

return
