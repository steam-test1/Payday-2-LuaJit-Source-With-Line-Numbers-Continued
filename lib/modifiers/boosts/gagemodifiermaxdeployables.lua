GageModifierMaxDeployables = GageModifierMaxDeployables or class(GageModifier)
GageModifierMaxDeployables._type = "GageModifierMaxDeployables"
GageModifierMaxDeployables.default_value = "deployables"

-- Lines: 6 to 7
function GageModifierMaxDeployables:get_amount_multiplier()
	return 1 + self:value() / 100
end

-- Lines: 10 to 16
function GageModifierMaxDeployables:modify_value(id, value)
	if id == "PlayerManager:GetEquipmentMaxAmount" and value > 0 then
		local new_val = math.floor(value * self:get_amount_multiplier())
		new_val = math.max(new_val, value + 1)

		return new_val
	end

	return value
end

return
