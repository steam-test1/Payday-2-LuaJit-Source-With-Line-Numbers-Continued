HuskBossDamage = HuskBossDamage or class(HuskCopDamage)

-- Lines 3-5
function HuskBossDamage:seq_clbk_armorbreak()
	BossDamage.seq_clbk_armorbreak(self)
end
