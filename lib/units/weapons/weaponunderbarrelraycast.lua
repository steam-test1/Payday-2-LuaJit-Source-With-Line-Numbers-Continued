WeaponUnderbarrelRaycast = WeaponUnderbarrelRaycast or class(WeaponUnderbarrel)
WeaponUnderbarrelRaycast.GADGET_TYPE = "underbarrel_raycast"

mixin(WeaponUnderbarrelRaycast, RaycastWeaponBase)

-- Lines 6-9
function WeaponUnderbarrelRaycast:init(unit)
	WeaponUnderbarrel.init(self, unit)
	RaycastWeaponBase.init(self, unit)
end

-- Lines 11-18
function WeaponUnderbarrelRaycast:setup_data(setup_data, damage_multiplier, ammo_data)
	WeaponUnderbarrel.setup_data(self, setup_data, damage_multiplier, ammo_data)

	self._blueprint = {}
	self._parts = {}

	self:_update_stats_values(false, ammo_data)
	RaycastWeaponBase.setup(self, setup_data, damage_multiplier)
end

-- Lines 20-23
function WeaponUnderbarrelRaycast:replenish()
	self._ammo:replenish()
	self:update_damage()
end

-- Lines 25-27
function WeaponUnderbarrelRaycast:ammo_base()
	return self._ammo
end

-- Lines 33-35
function WeaponUnderbarrelRaycast:_spawn_muzzle_effect()
	return nil
end

-- Lines 37-39
function WeaponUnderbarrelRaycast:_spawn_shell_eject_effect()
	return true
end

-- Lines 41-43
function WeaponUnderbarrelRaycast:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return RaycastWeaponBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
end

-- Lines 45-47
function WeaponUnderbarrelRaycast:_get_tweak_data_weapon_animation(anim)
	return WeaponUnderbarrel._get_tweak_data_weapon_animation(self, anim)
end

-- Lines 49-51
function WeaponUnderbarrelRaycast:_get_sound_event(weapon, event, alternative_event)
	return WeaponUnderbarrel._get_sound_event(self, weapon, event, alternative_event)
end

-- Lines 53-55
function WeaponUnderbarrelRaycast:fire_mode()
	return WeaponUnderbarrel.fire_mode(self)
end

-- Lines 57-59
function WeaponUnderbarrelRaycast:reload_prefix()
	return WeaponUnderbarrel.reload_prefix(self)
end

-- Lines 61-64
function WeaponUnderbarrelRaycast:_check_alert(weapon, rays, fire_pos, direction, user_unit)
	RaycastWeaponBase._check_alert(self, rays, fire_pos, direction, user_unit)

	return true
end

-- Lines 66-69
function WeaponUnderbarrelRaycast:_build_suppression(weapon, enemies_in_cone, suppr_mul)
	RaycastWeaponBase._build_suppression(self, enemies_in_cone, suppr_mul)

	return true
end

WeaponUnderbarrelShotgunRaycast = WeaponUnderbarrelShotgunRaycast or class(WeaponUnderbarrelRaycast)

mixin(WeaponUnderbarrelShotgunRaycast, NewRaycastWeaponBase)
mixin(WeaponUnderbarrelShotgunRaycast, ShotgunBase)

-- Lines 76-81
function WeaponUnderbarrelShotgunRaycast:init(unit)
	self._blueprint = {}
	self._parts = {}

	WeaponUnderbarrel.init(self, unit)
	ShotgunBase.init(self, unit)
end

-- Lines 83-86
function WeaponUnderbarrelShotgunRaycast:replenish()
	self._ammo:replenish()
	self:update_damage()
end

-- Lines 88-90
function WeaponUnderbarrelShotgunRaycast:ammo_base()
	return self._ammo
end

-- Lines 92-94
function WeaponUnderbarrelShotgunRaycast:_get_tweak_data_weapon_animation(anim)
	return WeaponUnderbarrel._get_tweak_data_weapon_animation(self, anim)
end

-- Lines 96-98
function WeaponUnderbarrelShotgunRaycast:can_toggle_firemode()
	return WeaponUnderbarrel.can_toggle_firemode(self)
end

-- Lines 100-102
function WeaponUnderbarrelShotgunRaycast:reload_prefix()
	return WeaponUnderbarrel.reload_prefix(self)
end

-- Lines 104-106
function WeaponUnderbarrelShotgunRaycast:is_single_shot()
	return WeaponUnderbarrel.is_single_shot(self)
end

-- Lines 112-114
function WeaponUnderbarrelShotgunRaycast:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return ShotgunBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
end

-- Lines 116-119
function WeaponUnderbarrelShotgunRaycast:_check_alert(weapon, rays, fire_pos, direction, user_unit)
	ShotgunBase._check_alert(self, rays, fire_pos, direction, user_unit)

	return true
end

-- Lines 121-124
function WeaponUnderbarrelShotgunRaycast:_build_suppression(weapon, enemies_in_cone, suppr_mul)
	ShotgunBase._build_suppression(self, enemies_in_cone, suppr_mul)

	return true
end
