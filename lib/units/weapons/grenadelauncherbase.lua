GrenadeLauncherBase = GrenadeLauncherBase or class(ProjectileWeaponBase)
GrenadeLauncherContinousReloadBase = GrenadeLauncherContinousReloadBase or class(GrenadeLauncherBase)

-- Lines 7-13
function GrenadeLauncherContinousReloadBase:init(...)
	GrenadeLauncherContinousReloadBase.super.init(self, ...)

	self._use_shotgun_reload = true
end

-- Lines 16-18
function GrenadeLauncherContinousReloadBase:shotgun_shell_data()
	return nil
end
