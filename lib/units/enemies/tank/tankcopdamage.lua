TankCopDamage = TankCopDamage or class(CopDamage)

-- Lines: 3 to 6
function TankCopDamage:init(...)
	TankCopDamage.super.init(self, ...)

	self._is_halloween = self._unit:name() == Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
end

-- Lines: 8 to 13
function TankCopDamage:damage_bullet(attack_data, ...)
	if self._is_halloween then
		attack_data.damage = math.min(attack_data.damage, 235)
	end

	return TankCopDamage.super.damage_bullet(self, attack_data, ...)
end

-- Lines: 16 to 23
function TankCopDamage:seq_clbk_vizor_shatter()
	if not self._unit:character_damage():dead() then
		self._unit:sound():say("visor_lost")
		managers.modifiers:run_func("OnTankVisorShatter", self._unit)
	end
end

