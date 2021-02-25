AkimboWeaponBaseVR = AkimboWeaponBase or Application:error("AkimboWeaponBaseVR requires AkimboWeaponBase!")

-- Lines 4-10
function AkimboWeaponBaseVR:fire(from_pos, direction, ...)
	from_pos = self:fire_object():position()
	direction = self:fire_object():rotation():y()

	return AkimboWeaponBaseVR.super.fire(self, from_pos, direction, ...)
end

local __check_auto_aim = AkimboWeaponBase.check_auto_aim

-- Lines 13-18
function AkimboWeaponBaseVR:check_auto_aim(from_pos, direction, ...)
	from_pos = self:fire_object():position()
	direction = self:fire_object():rotation():y()

	return __check_auto_aim(self, from_pos, direction, ...)
end

local __start_reload = AkimboWeaponBase.start_reload

-- Lines 23-29
function AkimboWeaponBaseVR:start_reload(...)
	if alive(self._second_gun) then
		self._second_gun:base():start_reload(...)
	end

	__start_reload(self, ...)
end

local __on_reload = AkimboWeaponBase.on_reload

-- Lines 32-38
function AkimboWeaponBaseVR:on_reload(...)
	if alive(self._second_gun) then
		self._second_gun:base():on_reload(...)
	end

	__on_reload(self, ...)
end

local __update_reloading = NewRaycastWeaponBase.update_reloading

-- Lines 41-47
function AkimboWeaponBaseVR:update_reloading(...)
	if alive(self._second_gun) then
		self._second_gun:base():update_reloading(...)
	end

	__update_reloading(self, ...)
end

local __update_reload_finish = NewRaycastWeaponBase.update_reload_finish

-- Lines 50-58
function AkimboWeaponBaseVR:update_reload_finish(...)
	if alive(self._second_gun) and self._second_gun:base():is_finishing_reload() then
		self._second_gun:base():update_reload_finish(...)
	end

	__update_reload_finish(self, ...)
end

local __tweak_data_anim_play = AkimboWeaponBase.tweak_data_anim_play

-- Lines 61-73
function AkimboWeaponBaseVR:tweak_data_anim_play(anim, ...)
	if alive(self.parent_weapon) and anim == "magazine_empty" then
		AkimboWeaponBase.super.tweak_data_anim_play(self.parent_weapon:base(), anim, ...)
	end

	return __tweak_data_anim_play(self, anim, ...)
end

-- Lines 79-84
function AkimboWeaponBaseVR:on_enabled(...)
	if alive(self.parent_weapon) then
		self._last_gadget_idx = self.parent_weapon:base()._gadget_on
	end

	AkimboWeaponBaseVR.super.on_enabled(self, ...)
end

-- Lines 86-88
function AkimboWeaponBaseVR:on_disabled(...)
	AkimboWeaponBaseVR.super.on_disabled(self, ...)
end

-- Lines 90-92
function AkimboWeaponBaseVR:set_gadget_on(...)
	AkimboWeaponBaseVR.super.set_gadget_on(self, ...)
end
