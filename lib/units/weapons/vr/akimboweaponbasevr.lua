AkimboWeaponBaseVR = AkimboWeaponBase or Application:error("AkimboWeaponBaseVR requires AkimboWeaponBase!")

-- Lines: 5 to 9
function AkimboWeaponBaseVR:fire(from_pos, direction, ...)
	from_pos = self:fire_object():position()
	direction = self:fire_object():rotation():y()

	return AkimboWeaponBaseVR.super.fire(self, from_pos, direction, ...)
end
local __check_auto_aim = AkimboWeaponBase.check_auto_aim

-- Lines: 14 to 17
function AkimboWeaponBaseVR:check_auto_aim(from_pos, direction, ...)
	from_pos = self:fire_object():position()
	direction = self:fire_object():rotation():y()

	return __check_auto_aim(self, from_pos, direction, ...)
end
local __start_reload = AkimboWeaponBase.start_reload

-- Lines: 23 to 29
function AkimboWeaponBaseVR:start_reload(...)
	if alive(self._second_gun) then
		self._second_gun:base():start_reload(...)
	end

	__start_reload(self, ...)
end
local __on_reload = AkimboWeaponBase.on_reload

-- Lines: 32 to 38
function AkimboWeaponBaseVR:on_reload(...)
	if alive(self._second_gun) then
		self._second_gun:base():on_reload(...)
	end

	__on_reload(self, ...)
end
local __update_reloading = NewRaycastWeaponBase.update_reloading

-- Lines: 41 to 47
function AkimboWeaponBaseVR:update_reloading(...)
	if alive(self._second_gun) then
		self._second_gun:base():update_reloading(...)
	end

	__update_reloading(self, ...)
end
local __update_reload_finish = NewRaycastWeaponBase.update_reload_finish

-- Lines: 50 to 58
function AkimboWeaponBaseVR:update_reload_finish(...)
	if alive(self._second_gun) and self._second_gun:base():is_finishing_reload() then
		self._second_gun:base():update_reload_finish(...)
	end

	__update_reload_finish(self, ...)
end

-- Lines: 64 to 69
function AkimboWeaponBaseVR:on_enabled(...)
	if alive(self.parent_weapon) then
		self._last_gadget_idx = self.parent_weapon:base()._gadget_on
	end

	AkimboWeaponBaseVR.super.on_enabled(self, ...)
end

-- Lines: 71 to 73
function AkimboWeaponBaseVR:on_disabled(...)
	AkimboWeaponBaseVR.super.on_disabled(self, ...)
end

-- Lines: 75 to 77
function AkimboWeaponBaseVR:set_gadget_on(...)
	AkimboWeaponBaseVR.super.set_gadget_on(self, ...)
end

