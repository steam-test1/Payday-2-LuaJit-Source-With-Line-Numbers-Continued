ModifierEnemyDamage = ModifierEnemyDamage or class(BaseModifier)
ModifierEnemyDamage._type = "ModifierEnemyDamage"
ModifierEnemyDamage.name_id = "none"
ModifierEnemyDamage.desc_id = "menu_cs_modifier_enemy_damage"
ModifierEnemyDamage.default_value = "damage"
ModifierEnemyDamage.total_localization = "menu_cs_modifier_total_generic_percent"

-- Lines 9-11
function ModifierEnemyDamage:get_damage_multiplier()
	return 1 + self:value() / 100
end

-- Lines 13-18
function ModifierEnemyDamage:modify_value(id, value)
	if id == "PlayerDamage:TakeDamageBullet" then
		return value * self:get_damage_multiplier()
	end

	return value
end
