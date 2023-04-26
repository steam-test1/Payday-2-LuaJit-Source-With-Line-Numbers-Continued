AkimboShotgunBase = AkimboShotgunBase or class(AkimboWeaponBase)

-- Lines 3-11
function AkimboShotgunBase:init(...)
	AkimboShotgunBase.super.init(self, ...)

	self._hip_fire_rate_inc = 0
	self._do_shotgun_push = true

	self:setup_default()
end

-- Lines 13-15
function AkimboShotgunBase:setup_default(...)
	ShotgunBase.setup_default(self, ...)
end

-- Lines 17-19
function AkimboShotgunBase:_fire_raycast(...)
	return ShotgunBase._fire_raycast(self, ...)
end

-- Lines 31-33
function AkimboShotgunBase:fire_rate_multiplier(...)
	return ShotgunBase.fire_rate_multiplier(self, ...)
end

-- Lines 35-37
function AkimboShotgunBase:run_and_shoot_allowed(...)
	return ShotgunBase.run_and_shoot_allowed(self, ...)
end

-- Lines 39-41
function AkimboShotgunBase:_update_stats_values(...)
	ShotgunBase._update_stats_values(self, ...)
end

-- Lines 43-45
function AkimboShotgunBase:_check_one_shot_shotgun_achievements(...)
	ShotgunBase._check_one_shot_shotgun_achievements(self, ...)
end

NPCAkimboShotgunBase = NPCAkimboShotgunBase or class(NPCAkimboWeaponBase)
