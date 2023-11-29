NPCShotgunBase = NPCShotgunBase or class(NPCRaycastWeaponBase)

-- Lines 3-7
function NPCShotgunBase:init(...)
	NPCShotgunBase.super.init(self, ...)

	self._do_shotgun_push = true
end
