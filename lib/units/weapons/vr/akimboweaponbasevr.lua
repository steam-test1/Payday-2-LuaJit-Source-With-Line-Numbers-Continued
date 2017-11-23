AkimboWeaponBaseVR = AkimboWeaponBase or Application:error("AkimboWeaponBaseVR requires AkimboWeaponBase!")

-- Lines: 4 to 8
function AkimboWeaponBaseVR:fire(from_pos, direction, ...)
	from_pos = self:fire_object():position()
	direction = self:fire_object():rotation():y()

	return AkimboWeaponBaseVR.super.fire(self, from_pos, direction, ...)
end
local __check_auto_aim = AkimboWeaponBase.check_auto_aim

-- Lines: 13 to 16
function AkimboWeaponBaseVR:check_auto_aim(from_pos, direction, ...)
	from_pos = self:fire_object():position()
	direction = self:fire_object():rotation():y()

	return __check_auto_aim(self, from_pos, direction, ...)
end
local __start_reload = AkimboWeaponBase.start_reload

-- Lines: 22 to 28
function AkimboWeaponBaseVR:start_reload(...)
	if alive(self._second_gun) then
		self._second_gun:base():start_reload(...)
	end

	__start_reload(self, ...)
end
local __on_reload = AkimboWeaponBase.on_reload

-- Lines: 31 to 37
function AkimboWeaponBaseVR:on_reload(...)
	if alive(self._second_gun) then
		self._second_gun:base():on_reload(...)
	end

	__on_reload(self, ...)
end
local __update_reloading = NewRaycastWeaponBase.update_reloading

-- Lines: 40 to 46
function AkimboWeaponBaseVR:update_reloading(...)
	if alive(self._second_gun) then
		self._second_gun:base():update_reloading(...)
	end

	__update_reloading(self, ...)
end
local __update_reload_finish = NewRaycastWeaponBase.update_reload_finish

-- Lines: 49 to 57
function AkimboWeaponBaseVR:update_reload_finish(...)
	if alive(self._second_gun) and self._second_gun:base():is_finishing_reload() then
		self._second_gun:base():update_reload_finish(...)
	end

	__update_reload_finish(self, ...)
end

-- Lines: 63 to 65
function AkimboWeaponBaseVR:on_enabled(...)
	AkimboWeaponBaseVR.super.on_enabled(self, ...)
end

-- Lines: 67 to 69
function AkimboWeaponBaseVR:on_disabled(...)
	AkimboWeaponBaseVR.super.on_disabled(self, ...)
end

-- Lines: 71 to 73
function AkimboWeaponBaseVR:set_gadget_on(...)
	AkimboWeaponBaseVR.super.set_gadget_on(self, ...)
end

