ModifierHeavySniper = ModifierHeavySniper or class(BaseModifier)
ModifierHeavySniper._type = "ModifierHeavySniper"
ModifierHeavySniper.name_id = "none"
ModifierHeavySniper.desc_id = "menu_cs_modifier_heavy_sniper"
ModifierHeavySniper.default_value = "spawn_chance"
ModifierHeavySniper.heavy_units = {
	Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
	Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
	Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
	Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
	Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"),
	Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"),
	Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"),
	Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"),
	Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy"),
	Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"),
	Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"),
	Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36")
}
local tmp_lookup = {}

for i, unit_ids in ipairs(ModifierHeavySniper.heavy_units) do
	tmp_lookup[unit_ids:key()] = true
end

ModifierHeavySniper.heavy_units = tmp_lookup
tmp_lookup = nil

-- Lines 42-50
function ModifierHeavySniper:modify_value(id, value)
	if id == "GroupAIStateBesiege:SpawningUnit" then
		local is_heavy = ModifierHeavySniper.heavy_units[value:key()]

		if is_heavy and math.random() < self:value() * 0.01 then
			return Idstring("units/pd2_dlc_drm/characters/ene_zeal_swat_heavy_sniper/ene_zeal_swat_heavy_sniper")
		end
	end

	return value
end
