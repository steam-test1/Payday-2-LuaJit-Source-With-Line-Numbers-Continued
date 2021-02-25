core:import("CoreMissionScriptElement")

ElementSpawnGrenade = ElementSpawnGrenade or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementSpawnGrenade:init(...)
	ElementSpawnGrenade.super.init(self, ...)
end

-- Lines 9-10
function ElementSpawnGrenade:client_on_executed(...)
end

-- Lines 12-26
function ElementSpawnGrenade:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.grenade_type == "frag" then
		ProjectileBase.throw_projectile(self._values.grenade_type, self._values.position, self._values.spawn_dir * self._values.strength)
	end

	ElementSpawnGrenade.super.on_executed(self, instigator)
end
