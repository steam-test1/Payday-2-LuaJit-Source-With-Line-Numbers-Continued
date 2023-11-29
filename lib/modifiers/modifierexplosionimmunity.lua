ModifierExplosionImmunity = ModifierExplosionImmunity or class(BaseModifier)
ModifierExplosionImmunity._type = "ModifierExplosionImmunity"
ModifierExplosionImmunity.name_id = "none"
ModifierExplosionImmunity.desc_id = "menu_cs_modifier_dozer_immune"

-- Lines 7-16
function ModifierExplosionImmunity:modify_value(id, value, unit)
	if id == "CopDamage:DamageExplosion" then
		local base_ext = unit:base()

		if base_ext and base_ext.has_tag and base_ext:has_tag("tank") then
			return 0
		end
	end

	return value
end
