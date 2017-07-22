ModifierEnemyHealthAndDamage = ModifierEnemyHealthAndDamage or class(BaseModifier)
ModifierEnemyHealthAndDamage._type = "ModifierEnemyHealthAndDamage"
ModifierEnemyHealthAndDamage.name_id = "none"
ModifierEnemyHealthAndDamage.desc_id = "menu_cs_modifier_enemy_health_damage"

-- Lines: 7 to 17
function ModifierEnemyHealthAndDamage:get_description(modifier_id, idx)
	local desc = ModifierEnemyHealthAndDamage.super.get_description(self, modifier_id, idx)

	if idx == 1 then
		local data = managers.crime_spree:get_modifier_stack_data(self._type)
		local params = {
			health = managers.experience:cash_string(data.health or 0, ""),
			damage = managers.experience:cash_string(data.damage or 0, "")
		}
		desc = desc .. " " .. managers.localization:text("menu_cs_modifier_health_damage_total", params)
	end

	return desc
end

-- Lines: 21 to 27
function ModifierEnemyHealthAndDamage:init(data)
	ModifierEnemyHealthAndDamage.super.init(self, data)
	MutatorEnemyHealth:modify_character_tweak_data(tweak_data.character, self:get_health_multiplier())
end

-- Lines: 29 to 30
function ModifierEnemyHealthAndDamage:get_health_multiplier()
	return 1 + self:value("health") / 100
end

-- Lines: 33 to 34
function ModifierEnemyHealthAndDamage:get_damage_multiplier()
	return 1 + self:value("damage") / 100
end

-- Lines: 37 to 41
function ModifierEnemyHealthAndDamage:modify_value(id, value)
	if id == "PlayerDamage:TakeDamageBullet" then
		return value * self:get_damage_multiplier()
	end

	return value
end

return
