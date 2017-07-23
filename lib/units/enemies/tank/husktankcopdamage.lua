HuskTankCopDamage = HuskTankCopDamage or class(HuskCopDamage)

-- Lines: 3 to 6
function HuskTankCopDamage:init(...)
	HuskTankCopDamage.super.init(self, ...)

	self._is_halloween = self._unit:name() == Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4_husk")
end

-- Lines: 8 to 13
function HuskTankCopDamage:damage_bullet(attack_data, ...)
	if self._is_halloween then
		attack_data.damage = math.min(attack_data.damage, 235)
	end

	return HuskTankCopDamage.super.damage_bullet(self, attack_data, ...)
end

-- Lines: 16 to 18
function HuskTankCopDamage:seq_clbk_vizor_shatter()
	TankCopDamage.seq_clbk_vizor_shatter(self)
end

