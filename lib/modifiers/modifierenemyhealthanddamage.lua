ModifierEnemyHealthAndDamage = ModifierEnemyHealthAndDamage or class(BaseModifier)
ModifierEnemyHealthAndDamage._type = "ModifierEnemyHealthAndDamage"
ModifierEnemyHealthAndDamage.name_id = "none"
ModifierEnemyHealthAndDamage.desc_id = "menu_cs_modifier_enemy_health_damage"
ModifierEnemyHealthAndDamage.total_localization = "menu_cs_modifier_health_damage_total"

-- Lines 8-26
function ModifierEnemyHealthAndDamage:init(data)
	ModifierEnemyHealthAndDamage.super.init(self, data)
	MutatorEnemyHealth:modify_character_tweak_data(tweak_data.character, self:get_health_multiplier())
end

-- Lines 28-30
function ModifierEnemyHealthAndDamage:get_health_multiplier()
	return 1 + self:value("health") / 100
end

-- Lines 32-34
function ModifierEnemyHealthAndDamage:get_damage_multiplier()
	return 1 + self:value("damage") / 100
end

-- Lines 36-41
function ModifierEnemyHealthAndDamage:modify_value(id, value)
	if id == "PlayerDamage:TakeDamageBullet" then
		return value * self:get_damage_multiplier()
	end

	return value
end
