GageModifierQuickSwitch = GageModifierQuickSwitch or class(GageModifier)
GageModifierQuickSwitch._type = "GageModifierQuickSwitch"
GageModifierQuickSwitch.default_value = "speed"

-- Lines 6-8
function GageModifierQuickSwitch:get_speed_multiplier()
	return 1 + self:value() / 100
end

-- Lines 10-15
function GageModifierQuickSwitch:modify_value(id, value)
	if id == "PlayerStandard:GetSwapSpeedMultiplier" then
		return value * self:get_speed_multiplier()
	end

	return value
end
