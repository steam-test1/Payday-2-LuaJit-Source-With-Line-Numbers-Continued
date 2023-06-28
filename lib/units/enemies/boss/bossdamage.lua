BossDamage = BossDamage or class(CopDamage)

-- Lines 3-7
function BossDamage:seq_clbk_armorbreak()
	if not self._unit:character_damage():dead() then
		self._unit:sound():say(self._unit:sound().armorbreak_str or "armorbreak")
	end
end

-- Lines 9-17
function BossDamage:die(...)
	local contour_ext = self._unit:contour()

	if contour_ext then
		contour_ext:remove(contour_ext.init_contour or "highlight_character")
	end

	BossDamage.super.die(self, ...)
end
