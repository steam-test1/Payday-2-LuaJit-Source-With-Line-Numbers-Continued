WeaponUnderbarrelRaycast = WeaponUnderbarrelRaycast or class(WeaponUnderbarrel)
WeaponUnderbarrelRaycast.GADGET_TYPE = "underbarrel_raycast"

mixin(WeaponUnderbarrelRaycast, RaycastWeaponBase)

-- Lines 6-9
function WeaponUnderbarrelRaycast:init(unit)
	WeaponUnderbarrel.init(self, unit)
	RaycastWeaponBase.init(self, unit)
end

-- Lines 11-21
function WeaponUnderbarrelRaycast:setup_data(setup_data, damage_multiplier, ammo_data)
	WeaponUnderbarrel.setup_data(self, setup_data, damage_multiplier, ammo_data)

	self._base_stats_modifiers = ammo_data and ammo_data.base_stats_modifiers or {}
	self._blueprint = {}
	self._parts = {}

	self:_update_stats_values(false, ammo_data)
	RaycastWeaponBase.setup(self, setup_data, damage_multiplier)
end

-- Lines 24-28
function WeaponUnderbarrelRaycast:modify_base_stats(stats)
	for stat, value in pairs(self._base_stats_modifiers) do
		stats[stat] = (stats[stat] or 1) + value
	end
end

-- Lines 31-34
function WeaponUnderbarrelRaycast:replenish()
	self._ammo:replenish()
	self:update_damage()
end

-- Lines 36-38
function WeaponUnderbarrelRaycast:ammo_base()
	return self._ammo
end

-- Lines 44-46
function WeaponUnderbarrelRaycast:_spawn_muzzle_effect()
	return nil
end

-- Lines 48-50
function WeaponUnderbarrelRaycast:_spawn_shell_eject_effect()
	return true
end

-- Lines 52-54
function WeaponUnderbarrelRaycast:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return RaycastWeaponBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
end

-- Lines 56-58
function WeaponUnderbarrelRaycast:_get_tweak_data_weapon_animation(anim)
	return WeaponUnderbarrel._get_tweak_data_weapon_animation(self, anim)
end

-- Lines 60-62
function WeaponUnderbarrelRaycast:_get_sound_event(weapon, event, alternative_event)
	return WeaponUnderbarrel._get_sound_event(self, weapon, event, alternative_event)
end

-- Lines 64-66
function WeaponUnderbarrelRaycast:fire_mode()
	return WeaponUnderbarrel.fire_mode(self)
end

-- Lines 68-70
function WeaponUnderbarrelRaycast:reload_prefix()
	return WeaponUnderbarrel.reload_prefix(self)
end

-- Lines 72-75
function WeaponUnderbarrelRaycast:_check_alert(weapon, rays, fire_pos, direction, user_unit)
	RaycastWeaponBase._check_alert(self, rays, fire_pos, direction, user_unit)

	return true
end

-- Lines 77-80
function WeaponUnderbarrelRaycast:_build_suppression(weapon, enemies_in_cone, suppr_mul)
	RaycastWeaponBase._build_suppression(self, enemies_in_cone, suppr_mul)

	return true
end

WeaponUnderbarrelShotgunRaycast = WeaponUnderbarrelShotgunRaycast or class(WeaponUnderbarrelRaycast)

mixin(WeaponUnderbarrelShotgunRaycast, NewRaycastWeaponBase)
mixin(WeaponUnderbarrelShotgunRaycast, ShotgunBase)

-- Lines 87-92
function WeaponUnderbarrelShotgunRaycast:init(unit)
	self._blueprint = {}
	self._parts = {}

	WeaponUnderbarrel.init(self, unit)
	ShotgunBase.init(self, unit)
end

-- Lines 94-97
function WeaponUnderbarrelShotgunRaycast:replenish()
	self._ammo:replenish()
	self:update_damage()
end

-- Lines 99-101
function WeaponUnderbarrelShotgunRaycast:ammo_base()
	return self._ammo
end

-- Lines 103-105
function WeaponUnderbarrelShotgunRaycast:_get_tweak_data_weapon_animation(anim)
	return WeaponUnderbarrel._get_tweak_data_weapon_animation(self, anim)
end

-- Lines 107-109
function WeaponUnderbarrelShotgunRaycast:can_toggle_firemode()
	return WeaponUnderbarrel.can_toggle_firemode(self)
end

-- Lines 111-113
function WeaponUnderbarrelShotgunRaycast:reload_prefix()
	return WeaponUnderbarrel.reload_prefix(self)
end

-- Lines 115-117
function WeaponUnderbarrelShotgunRaycast:is_single_shot()
	return WeaponUnderbarrel.is_single_shot(self)
end

-- Lines 123-125
function WeaponUnderbarrelShotgunRaycast:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return ShotgunBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
end

-- Lines 127-130
function WeaponUnderbarrelShotgunRaycast:_check_alert(weapon, rays, fire_pos, direction, user_unit)
	ShotgunBase._check_alert(self, rays, fire_pos, direction, user_unit)

	return true
end

-- Lines 132-135
function WeaponUnderbarrelShotgunRaycast:_build_suppression(weapon, enemies_in_cone, suppr_mul)
	ShotgunBase._build_suppression(self, enemies_in_cone, suppr_mul)

	return true
end

WeaponUnderbarrelFlamethrower = WeaponUnderbarrelFlamethrower or class(WeaponUnderbarrelRaycast)

mixin(WeaponUnderbarrelFlamethrower, NewRaycastWeaponBase)
mixin(WeaponUnderbarrelFlamethrower, NewFlamethrowerBase)

-- Lines 150-155
function WeaponUnderbarrelFlamethrower:init(unit)
	self._blueprint = {}
	self._parts = {}

	WeaponUnderbarrel.init(self, unit)
	NewFlamethrowerBase.init(self, unit)
end

-- Lines 157-159
function WeaponUnderbarrelFlamethrower:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return NewFlamethrowerBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
end

-- Lines 161-164
function WeaponUnderbarrelFlamethrower:_check_alert(weapon, rays, fire_pos, direction, user_unit)
	NewFlamethrowerBase._check_alert(self, rays, fire_pos, direction, user_unit)

	return true
end

-- Lines 166-169
function WeaponUnderbarrelFlamethrower:_build_suppression(weapon, enemies_in_cone, suppr_mul)
	NewFlamethrowerBase._build_suppression(self, enemies_in_cone, suppr_mul)

	return true
end

-- Lines 171-173
function WeaponUnderbarrelFlamethrower:_spawn_muzzle_effect()
	return false
end

-- Lines 175-177
function WeaponUnderbarrelFlamethrower:_spawn_shell_eject_effect()
	return false
end

-- Lines 179-181
function WeaponUnderbarrelFlamethrower:_get_tweak_data_weapon_animation(anim)
	return WeaponUnderbarrel._get_tweak_data_weapon_animation(self, anim)
end

-- Lines 183-185
function WeaponUnderbarrelFlamethrower:reload_prefix()
	return WeaponUnderbarrel.reload_prefix(self)
end

-- Lines 187-195
function WeaponUnderbarrelFlamethrower:_check_state(current_state)
	WeaponUnderbarrelRaycast._check_state(self, current_state)

	self._enabled = self._on

	if self._enabled then
		self:on_enabled()
	else
		self:on_disabled()
	end
end

-- Lines 197-199
function WeaponUnderbarrelFlamethrower:_get_sound_event(weapon, event, alternative_event)
	return WeaponUnderbarrel._get_sound_event(self, weapon, event, alternative_event)
end

-- Lines 201-205
function WeaponUnderbarrelFlamethrower:start_shooting(weapon)
	self._next_fire_allowed = math.max(self._next_fire_allowed, self._unit:timer():time())
	self._shooting = true
	self._bullets_fired = 0
end

-- Lines 207-209
function WeaponUnderbarrelFlamethrower:tweak_data_anim_play(...)
	Application:error("WeaponUnderbarrelFlamethrower:tweak_data_anim_play", ...)
end

-- Lines 211-213
function WeaponUnderbarrelFlamethrower:tweak_data_anim_play_at_end(...)
	Application:error("WeaponUnderbarrelFlamethrower:tweak_data_anim_play_at_end", ...)
end

-- Lines 215-217
function WeaponUnderbarrelFlamethrower:tweak_data_anim_stop(...)
	Application:error("WeaponUnderbarrelFlamethrower:tweak_data_anim_stop", ...)
end

-- Lines 219-221
function WeaponUnderbarrelFlamethrower:tweak_data_anim_is_playing(...)
	Application:error("WeaponUnderbarrelFlamethrower:tweak_data_anim_is_playing", ...)
end
