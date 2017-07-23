HuskMedicDamage = HuskMedicDamage or class(HuskCopDamage)

-- Lines: 3 to 8
function HuskMedicDamage:init(...)
	HuskMedicDamage.super.init(self, ...)

	self._heal_cooldown_t = 0
	self._debug_brush = Draw:brush(Color(0.5, 0.5, 0, 1))
end

-- Lines: 10 to 12
function HuskMedicDamage:update(...)
	MedicDamage.update(self, ...)
end

-- Lines: 14 to 15
function HuskMedicDamage:heal_unit(...)
	return MedicDamage.heal_unit(self, ...)
end

