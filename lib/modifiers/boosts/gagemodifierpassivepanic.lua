GageModifierPassivePanic = GageModifierPassivePanic or class(GageModifier)
GageModifierPassivePanic._type = "GageModifierPassivePanic"
GageModifierPassivePanic.default_value = "panic"

-- Lines 6-8
function GageModifierPassivePanic:get_chance_increase()
	return self:value() / 100
end

-- Lines 10-15
function GageModifierPassivePanic:modify_value(id, value)
	if id == "PlayerManager:GetKillshotPanicChance" and value ~= -1 then
		return value + self:get_chance_increase()
	end

	return value
end
