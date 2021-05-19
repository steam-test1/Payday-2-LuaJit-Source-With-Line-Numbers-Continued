HuskCivilianDamage = HuskCivilianDamage or class(HuskCopDamage)
HuskCivilianDamage._HEALTH_INIT = CivilianDamage._HEALTH_INIT
HuskCivilianDamage.damage_bullet = CivilianDamage.damage_bullet
HuskCivilianDamage.damage_melee = CivilianDamage.damage_melee
HuskCivilianDamage.damage_tase = CivilianDamage.damage_tase
HuskCivilianDamage.sync_damage_tase = CivilianDamage.sync_damage_tase
HuskCivilianDamage._play_civilian_tase_effect = CivilianDamage._play_civilian_tase_effect
HuskCivilianDamage._tase_effect_clbk = CivilianDamage._tase_effect_clbk
HuskCivilianDamage.no_intimidation_by_dmg = CivilianDamage.no_intimidation_by_dmg

-- Lines 19-21
function HuskCivilianDamage:_on_damage_received(damage_info)
	CivilianDamage._on_damage_received(self, damage_info)
end

-- Lines 25-27
function HuskCivilianDamage:_unregister_from_enemy_manager(damage_info)
	CivilianDamage._unregister_from_enemy_manager(self, damage_info)
end

-- Lines 31-36
function HuskCivilianDamage:damage_explosion(attack_data)
	if attack_data.variant == "explosion" then
		attack_data.damage = 10
	end

	return CopDamage.damage_explosion(self, attack_data)
end

-- Lines 40-45
function HuskCivilianDamage:damage_fire(attack_data)
	if attack_data.variant == "fire" then
		attack_data.damage = 10
	end

	return CopDamage.damage_fire(self, attack_data)
end
