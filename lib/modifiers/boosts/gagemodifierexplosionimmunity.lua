GageModifierExplosionImmunity = GageModifierExplosionImmunity or class(GageModifier)
GageModifierExplosionImmunity._type = "GageModifierExplosionImmunity"

-- Lines 5-10
function GageModifierExplosionImmunity:modify_value(id, value)
	if id == "PlayerDamage:OnTakeExplosionDamage" then
		return 0
	end

	return value
end
