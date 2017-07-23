Utl = {}

-- Lines: 8 to 10
function Utl.round(val, dec)
	local dec_mul = 10 ^ (dec or 4)

	return math.floor(val * dec_mul) / dec_mul
end

