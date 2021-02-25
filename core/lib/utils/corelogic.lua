core:module("CoreLogic")

-- Lines 11-17
function toboolean(value)
	if type(value) == "string" then
		return value == "true"
	elseif type(value) == "number" then
		return value == 1
	end
end

-- Lines 19-25
function iff(t, a, b)
	if t then
		return a
	else
		return b
	end
end
