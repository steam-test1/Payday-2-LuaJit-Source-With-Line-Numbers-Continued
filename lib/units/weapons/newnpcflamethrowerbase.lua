NewNPCFlamethrowerBase = NewNPCFlamethrowerBase or class(NewNPCRaycastWeaponBase)

-- Lines 441-446
function NewNPCFlamethrowerBase:init(...)
	NewNPCFlamethrowerBase.super.init(self, ...)
	self:setup_default()
end

-- Lines 449-455
function NewNPCFlamethrowerBase:setup_default()
	self._use_shell_ejection_effect = false
	self._use_trails = false
end

-- Lines 458-459
function NewNPCFlamethrowerBase:_spawn_muzzle_effect(from_pos, direction)
end

-- Lines 462-471
function NewNPCFlamethrowerBase:update(unit, t, dt)
	if self._check_shooting_expired and self._check_shooting_expired.check_t < t then
		self._check_shooting_expired = nil

		self._unit:set_extension_update_enabled(Idstring("base"), false)
		SawWeaponBase._stop_sawing_effect(self)
		self:play_tweak_data_sound("stop_fire")
	end
end

-- Lines 474-484
function NewNPCFlamethrowerBase:fire_blank(direction, impact)
	if not self._check_shooting_expired then
		self:play_tweak_data_sound("fire")
	end

	self._check_shooting_expired = {
		check_t = Application:time() + 0.3
	}

	self._unit:set_extension_update_enabled(Idstring("base"), true)
	self._unit:flamethrower_effect_extension():_spawn_muzzle_effect(self._obj_fire:position(), direction)
end

-- Lines 486-488
function NewNPCFlamethrowerBase:auto_fire_blank(direction, impact)
	self:fire_blank(direction, impact)
end

-- Lines 491-498
function NewNPCFlamethrowerBase:_sound_autofire_start(nr_shots)
	local tweak_sound = tweak_data.weapon[self._name_id].sounds or {}

	self._sound_fire:stop()

	local sound = self._sound_fire:post_event(tweak_sound.fire, callback(self, self, "_on_auto_fire_stop"), nil, "end_of_event")
	sound = sound or self._sound_fire:post_event(tweak_sound.fire)
end

-- Lines 500-506
function NewNPCFlamethrowerBase:_sound_autofire_end()
	local tweak_sound = tweak_data.weapon[self._name_id].sounds or {}
	local sound = self._sound_fire:post_event(tweak_sound.stop_fire)
	sound = sound or self._sound_fire:post_event(tweak_sound.stop_fire)
end

-- Lines 509-511
function NewNPCFlamethrowerBase:third_person_important()
	return NewFlamethrowerBase.third_person_important(self)
end
