WeaponUnderbarrel = WeaponUnderbarrel or class(WeaponGadgetBase)

-- Lines 4-7
function WeaponUnderbarrel:init(...)
	WeaponUnderbarrel.super.init(self, ...)
end

WeaponUnderbarrelLauncher = WeaponUnderbarrelLauncher or class(WeaponUnderbarrel)
WeaponUnderbarrelRaycast = WeaponUnderbarrelRaycast or class(WeaponUnderbarrel)
WeaponUnderbarrelShotgunRaycast = WeaponUnderbarrelShotgunRaycast or class(WeaponUnderbarrelRaycast)
WeaponUnderbarrelFlamethrower = WeaponUnderbarrelFlamethrower or class(WeaponUnderbarrelRaycast)
