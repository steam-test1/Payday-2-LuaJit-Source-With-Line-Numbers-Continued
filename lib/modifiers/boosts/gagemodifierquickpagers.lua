GageModifierQuickPagers = GageModifierQuickPagers or class(GageModifier)
GageModifierQuickPagers._type = "GageModifierQuickPagers"
GageModifierQuickPagers.default_value = "speed"

-- Lines 6-8
function GageModifierQuickPagers:get_speed_divisor()
	return 1 + self:value() / 100
end

-- Lines 10-18
function GageModifierQuickPagers:modify_value(id, value, interact_object)
	if id == "PlayerStandard:OnStartInteraction" then
		local tweak = interact_object:interaction().tweak_data

		if tweak == "corpse_alarm_pager" then
			return value / self:get_speed_divisor()
		end
	end

	return value
end
