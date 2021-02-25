ModifierDozerRage = ModifierDozerRage or class(BaseModifier)
ModifierDozerRage._type = "ModifierDozerRage"
ModifierDozerRage.name_id = "none"
ModifierDozerRage.desc_id = "menu_cs_modifier_dozer_rage"

-- Lines 7-9
function ModifierDozerRage:OnTankVisorShatter(unit, damage_info)
	unit:base():add_buff("base_damage", self:value("damage") * 0.01)
end
