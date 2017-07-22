GageModifierMaxAmmo = GageModifierMaxAmmo or class(GageModifier)
GageModifierMaxAmmo._type = "GageModifierMaxAmmo"
GageModifierMaxAmmo.default_value = "ammo"

-- Lines: 6 to 7
function GageModifierMaxAmmo:get_ammo_multiplier()
	return 1 + self:value() / 100
end

-- Lines: 10 to 14
function GageModifierMaxAmmo:modify_value(id, value)
	if id == "WeaponBase:GetMaxAmmoMultiplier" then
		return value * self:get_ammo_multiplier()
	end

	return value
end

return
