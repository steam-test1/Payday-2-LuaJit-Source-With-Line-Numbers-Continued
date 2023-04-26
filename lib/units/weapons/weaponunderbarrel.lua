WeaponUnderbarrel = WeaponUnderbarrel or class(WeaponGadgetBase)
WeaponUnderbarrel.GADGET_TYPE = "underbarrel"

-- Lines 5-12
function WeaponUnderbarrel:init(unit)
	self._unit = unit
	self._is_npc = false
	self._tweak_data = tweak_data.weapon[self.name_id]
	self._deployed = false

	self:setup_underbarrel()
end

-- Lines 14-16
function WeaponUnderbarrel:destroy(unit)
end

-- Lines 18-27
function WeaponUnderbarrel:setup_data(setup_data, damage_multiplier, ammo_data)
	self._alert_events = setup_data.alert_AI and {} or nil
	self._alert_fires = {}
	self._autoaim = setup_data.autoaim
	self._setup = setup_data
	self._ammo_data = ammo_data or {}

	self._ammo:set_ammo_data(self._ammo_data)
end

-- Lines 29-31
function WeaponUnderbarrel:_update_stats_values()
	return {}
end

-- Lines 34-36
function WeaponUnderbarrel:setup_underbarrel()
	self._ammo = WeaponAmmo:new(self.name_id, self._tweak_data.CLIP_AMMO_MAX, self._tweak_data.AMMO_MAX)
end

-- Lines 38-43
function WeaponUnderbarrel:check_state()
	if self._is_npc then
		return false
	end

	self:toggle()
end

-- Lines 47-49
function WeaponUnderbarrel:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	return {}
end

-- Lines 51-56
function WeaponUnderbarrel:start_shooting_allowed()
	if not self._next_fire_t or self._next_fire_t <= TimerManager:main():time() then
		return true
	end

	return false
end

-- Lines 58-60
function WeaponUnderbarrel:on_shot()
	self._next_fire_t = TimerManager:main():time() + (self._tweak_data.fire_mode_data and self._tweak_data.fire_mode_data.fire_rate or 0)
end

-- Lines 62-64
function WeaponUnderbarrel:fire_mode()
	return self._tweak_data.FIRE_MODE
end

-- Lines 66-68
function WeaponUnderbarrel:can_toggle_firemode()
	return self._tweak_data.CAN_TOGGLE_FIREMODE
end

-- Lines 70-72
function WeaponUnderbarrel:is_single_shot()
	return self._tweak_data.FIRE_MODE == "single"
end

-- Lines 74-76
function WeaponUnderbarrel:replenish()
	self._ammo:replenish()
end

-- Lines 78-80
function WeaponUnderbarrel:ammo_base()
	return self._ammo
end

-- Lines 82-91
function WeaponUnderbarrel:_get_sound_event(weapon, event, alternative_event)
	local str_name = self.name_id or self._name_id

	if not weapon.third_person_important or not weapon:third_person_important() then
		str_name = self.name_id:gsub("_crew", "")
	end

	local sounds = self._tweak_data.sounds
	local event = sounds and (sounds[event] or sounds[alternative_event])

	return event
end

-- Lines 93-95
function WeaponUnderbarrel:_get_tweak_data_weapon_animation(anim)
	return "bipod_" .. anim
end

-- Lines 97-99
function WeaponUnderbarrel:_spawn_muzzle_effect()
	return true
end

-- Lines 101-103
function WeaponUnderbarrel:_spawn_shell_eject_effect()
	return true
end

-- Lines 105-107
function WeaponUnderbarrel:_check_alert(...)
	return nil
end

-- Lines 109-111
function WeaponUnderbarrel:_build_suppression(...)
	return nil
end

-- Lines 115-124
function WeaponUnderbarrel:_check_state(current_state)
	WeaponUnderbarrel.super._check_state(self, current_state)

	if self._anim_state ~= self._on then
		self._anim_state = self._on

		self:play_anim()
	end
end

-- Lines 126-133
function WeaponUnderbarrel:play_anim()
	if not self._anim then
		return
	end

	local length = self._unit:anim_length(self._anim)
	local speed = self._anim_state and 1 or -1

	self._unit:anim_play_to(self._anim, self._anim_state and length or 0, speed)
end

-- Lines 135-137
function WeaponUnderbarrel:reload_prefix()
	return "underbarrel_"
end

-- Lines 141-143
function WeaponUnderbarrel:is_underbarrel()
	return true
end

-- Lines 145-147
function WeaponUnderbarrel:toggle_requires_stance_update()
	return true
end

-- Lines 149-154
function WeaponUnderbarrel:on_add_ammo_from_bag()
	if self._tweak_data.reload_on_ammo_bag then
		self._ammo:set_ammo_remaining_in_clip(math.min(self._ammo:get_ammo_total(), self._ammo:get_ammo_max_per_clip()))
	end
end
