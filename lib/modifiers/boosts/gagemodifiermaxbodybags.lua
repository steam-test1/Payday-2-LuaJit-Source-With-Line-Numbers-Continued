GageModifierMaxBodyBags = GageModifierMaxBodyBags or class(GageModifier)
GageModifierMaxBodyBags._type = "GageModifierMaxBodyBags"
GageModifierMaxBodyBags.default_value = "bags"

-- Lines 6-11
function GageModifierMaxBodyBags:modify_value(id, value)
	if id == "PlayerManager:GetTotalBodyBags" then
		return value + self:value()
	end

	return value
end
