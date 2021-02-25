GageModifierMaxLives = GageModifierMaxLives or class(GageModifier)
GageModifierMaxLives._type = "GageModifierMaxLives"
GageModifierMaxLives.default_value = "lives"

-- Lines 6-11
function GageModifierMaxLives:modify_value(id, value)
	if id == "PlayerDamage:GetMaximumLives" then
		return value + self:value()
	end

	return value
end
