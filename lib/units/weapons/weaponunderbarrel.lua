WeaponUnderbarrel = WeaponUnderbarrel or class(WeaponGadgetBase)
WeaponUnderbarrel.GADGET_TYPE = "underbarrel"

-- Lines 5-14
function WeaponUnderbarrel:init(unit)
	self._unit = unit
	self._is_npc = false
	self._tweak_data = tweak_data.weapon[self.name_id]
	self._deployed = false

	self:setup_underbarrel()
end

-- Lines 16-18
function WeaponUnderbarrel:destroy(unit)
end

-- Lines 20-22
function WeaponUnderbarrel:setup_underbarrel()
	self._ammo = WeaponAmmo:new(self.name_id, self._tweak_data.CLIP_AMMO_MAX, self._tweak_data.AMMO_MAX)
end

-- Lines 24-29
function WeaponUnderbarrel:check_state()
	if self._is_npc then
		return false
	end

	self:toggle()
end

-- Lines 33-35
function WeaponUnderbarrel:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return {}
end

-- Lines 37-42
function WeaponUnderbarrel:start_shooting_allowed()
	if not self._next_fire_t or self._next_fire_t <= TimerManager:main():time() then
		return true
	end

	return false
end

-- Lines 44-46
function WeaponUnderbarrel:on_shot()
	self._next_fire_t = TimerManager:main():time() + (self._tweak_data.fire_mode_data and self._tweak_data.fire_mode_data.fire_rate or 0)
end

-- Lines 48-50
function WeaponUnderbarrel:fire_mode()
	return self._tweak_data.FIRE_MODE
end

-- Lines 52-54
function WeaponUnderbarrel:can_toggle_firemode()
	return self._tweak_data.CAN_TOGGLE_FIREMODE
end

-- Lines 56-58
function WeaponUnderbarrel:is_single_shot()
	return self._tweak_data.FIRE_MODE == "single"
end

-- Lines 60-62
function WeaponUnderbarrel:replenish()
	self._ammo:replenish()
end

-- Lines 64-66
function WeaponUnderbarrel:ammo_base()
	return self._ammo
end

-- Lines 68-77
function WeaponUnderbarrel:_get_sound_event(weapon, event, alternative_event)
	local str_name = self.name_id

	if not weapon.third_person_important or not weapon:third_person_important() then
		str_name = self.name_id:gsub("_crew", "")
	end

	local sounds = self._tweak_data.sounds
	local event = sounds and (sounds[event] or sounds[alternative_event])

	return event
end

-- Lines 79-81
function WeaponUnderbarrel:_get_tweak_data_weapon_animation(anim)
	return "bipod_" .. anim
end

-- Lines 83-85
function WeaponUnderbarrel:_spawn_muzzle_effect()
	return true
end

-- Lines 87-89
function WeaponUnderbarrel:_spawn_shell_eject_effect()
	return true
end

-- Lines 93-102
function WeaponUnderbarrel:_check_state(current_state)
	WeaponUnderbarrel.super._check_state(self, current_state)

	if self._anim_state ~= self._on then
		self._anim_state = self._on

		self:play_anim()
	end
end

-- Lines 104-111
function WeaponUnderbarrel:play_anim()
	if not self._anim then
		return
	end

	local length = self._unit:anim_length(self._anim)
	local speed = self._anim_state and 1 or -1

	self._unit:anim_play_to(self._anim, self._anim_state and length or 0, speed)
end

-- Lines 113-115
function WeaponUnderbarrel:reload_prefix()
	return "underbarrel_"
end

-- Lines 119-121
function WeaponUnderbarrel:is_underbarrel()
	return true
end

-- Lines 123-125
function WeaponUnderbarrel:toggle_requires_stance_update()
	return true
end
