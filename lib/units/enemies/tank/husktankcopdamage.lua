HuskTankCopDamage = HuskTankCopDamage or class(HuskCopDamage)
HuskTankCopDamage._priority_bodies_ids = TankCopDamage._priority_bodies_ids

-- Lines 4-7
function HuskTankCopDamage:init(...)
	HuskTankCopDamage.super.init(self, ...)

	self._is_halloween = self._unit:name() == Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4_husk")
end

-- Lines 9-15
function HuskTankCopDamage:damage_bullet(attack_data, ...)
	if self._is_halloween then
		attack_data.damage = math.min(attack_data.damage, 235)
	end

	return HuskTankCopDamage.super.damage_bullet(self, attack_data, ...)
end

-- Lines 17-19
function HuskTankCopDamage:seq_clbk_vizor_shatter()
	TankCopDamage.seq_clbk_vizor_shatter(self)
end
