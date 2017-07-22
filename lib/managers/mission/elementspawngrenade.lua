core:import("CoreMissionScriptElement")

ElementSpawnGrenade = ElementSpawnGrenade or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementSpawnGrenade:init(...)
	ElementSpawnGrenade.super.init(self, ...)
end

-- Lines: 10 to 11
function ElementSpawnGrenade:client_on_executed(...)
end

-- Lines: 13 to 23
function ElementSpawnGrenade:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.grenade_type == "frag" then
		ProjectileBase.throw_projectile(1, self._values.position, self._values.spawn_dir * self._values.strength)
	end

	ElementSpawnGrenade.super.on_executed(self, instigator)
end

return
