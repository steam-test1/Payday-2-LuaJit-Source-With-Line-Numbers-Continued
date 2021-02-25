NPCGrenadeLauncherBase = NPCGrenadeLauncherBase or class(NPCRaycastWeaponBase)

-- Lines 3-5
function NPCGrenadeLauncherBase:init(...)
	NPCGrenadeLauncherBase.super.init(self, ...)
end

-- Lines 9-12
function NPCGrenadeLauncherBase:fire_blank(direction, impact)
	World:effect_manager():spawn(self._muzzle_effect_table)
	self:_sound_singleshot()
end
