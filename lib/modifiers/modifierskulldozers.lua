ModifierSkulldozers = ModifierSkulldozers or class(BaseModifier)
ModifierSkulldozers._type = "ModifierSkulldozers"
ModifierSkulldozers.name_id = "none"
ModifierSkulldozers.desc_id = "menu_cs_modifier_dozer_lmg"

-- Lines 7-15
function ModifierSkulldozers:init(data)
	ModifierSkulldozers.super.init(self, data)
	table.insert(tweak_data.group_ai.unit_categories.FBI_tank.unit_types.america, Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"))
	table.insert(tweak_data.group_ai.unit_categories.FBI_tank.unit_types.russia, Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"))
end
