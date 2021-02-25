GageModifierQuickReload = GageModifierQuickReload or class(GageModifier)
GageModifierQuickReload._type = "GageModifierQuickReload"
GageModifierQuickReload.default_value = "speed"

-- Lines 6-8
function GageModifierQuickReload:get_speed_multiplier()
	return 1 + self:value() / 100
end

-- Lines 10-15
function GageModifierQuickReload:modify_value(id, value)
	if id == "WeaponBase:GetReloadSpeedMultiplier" then
		return value * self:get_speed_multiplier()
	end

	return value
end
