GageModifierMaxHealth = GageModifierMaxHealth or class(GageModifier)
GageModifierMaxHealth._type = "GageModifierMaxHealth"
GageModifierMaxHealth.default_value = "health"

-- Lines: 6 to 7
function GageModifierMaxHealth:get_health_multiplier()
	return 1 + self:value() / 100
end

-- Lines: 10 to 14
function GageModifierMaxHealth:modify_value(id, value)
	if id == "PlayerDamage:GetMaxHealth" then
		return value * self:get_health_multiplier()
	end

	return value
end

