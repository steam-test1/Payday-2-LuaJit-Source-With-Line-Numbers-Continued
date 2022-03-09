BossDamage = BossDamage or class(CopDamage)

-- Lines 3-7
function BossDamage:seq_clbk_armorbreak()
	if not self._unit:character_damage():dead() then
		self._unit:sound():say("armorbreak")
	end
end
