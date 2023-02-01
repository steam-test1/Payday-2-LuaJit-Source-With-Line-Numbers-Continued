GrenadeLauncherBase = GrenadeLauncherBase or class(ProjectileWeaponBase)
GrenadeLauncherContinousReloadBase = GrenadeLauncherContinousReloadBase or class(GrenadeLauncherBase)

-- Lines 7-13
function GrenadeLauncherContinousReloadBase:init(...)
	GrenadeLauncherContinousReloadBase.super.init(self, ...)

	self._use_shotgun_reload = true
	self._skip_reload_shotgun_shell = true
end
