ModifierHealSpeed = ModifierHealSpeed or class(BaseModifier)
ModifierHealSpeed._type = "ModifierHealSpeed"
ModifierHealSpeed.name_id = "none"
ModifierHealSpeed.desc_id = "menu_cs_modifier_medic_speed"
ModifierHealSpeed.default_value = "speed"
ModifierHealSpeed.total_localization = "menu_cs_modifier_total_generic_percent"

-- Lines: 9 to 10
function ModifierHealSpeed:get_cooldown_multiplier()
	return 1 - self:value() / 100
end

-- Lines: 13 to 17
function ModifierHealSpeed:modify_value(id, value)
	if id == "MedicDamage:CooldownTime" then
		return value * self:get_cooldown_multiplier()
	end

	return value
end

return
