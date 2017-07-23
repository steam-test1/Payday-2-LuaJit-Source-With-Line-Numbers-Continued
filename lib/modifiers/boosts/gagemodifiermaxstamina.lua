GageModifierMaxStamina = GageModifierMaxStamina or class(GageModifier)
GageModifierMaxStamina._type = "GageModifierMaxStamina"
GageModifierMaxStamina.default_value = "stamina"

-- Lines: 6 to 7
function GageModifierMaxStamina:get_stamina_multiplier()
	return 1 + self:value() / 100
end

-- Lines: 10 to 14
function GageModifierMaxStamina:modify_value(id, value)
	if id == "PlayerManager:GetStaminaMultiplier" then
		return value * self:get_stamina_multiplier()
	end

	return value
end

