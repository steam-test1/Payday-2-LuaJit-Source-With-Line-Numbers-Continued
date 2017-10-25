AkimboShotgunBase = AkimboShotgunBase or class(AkimboWeaponBase)

-- Lines: 3 to 6
function AkimboShotgunBase:init(...)
	AkimboShotgunBase.super.init(self, ...)
	self:setup_default()
end

-- Lines: 8 to 10
function AkimboShotgunBase:setup_default()
	ShotgunBase.setup_default(self)
end

-- Lines: 12 to 13
function AkimboShotgunBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return ShotgunBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
end

-- Lines: 16 to 17
function AkimboShotgunBase:get_damage_falloff(damage, col_ray, user_unit)
	return ShotgunBase.get_damage_falloff(self, damage, col_ray, user_unit)
end

-- Lines: 20 to 21
function AkimboShotgunBase:run_and_shoot_allowed()
	return ShotgunBase.run_and_shoot_allowed(self)
end

-- Lines: 24 to 26
function AkimboShotgunBase:_update_stats_values()
	ShotgunBase._update_stats_values(self)
end
NPCAkimboShotgunBase = NPCAkimboShotgunBase or class(NPCAkimboWeaponBase)

