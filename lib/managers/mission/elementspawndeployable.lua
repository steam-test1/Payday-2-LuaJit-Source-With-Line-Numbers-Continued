core:import("CoreMissionScriptElement")

ElementSpawnDeployable = ElementSpawnDeployable or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementSpawnDeployable:init(...)
	ElementSpawnDeployable.super.init(self, ...)
end

-- Lines 9-11
function ElementSpawnDeployable:client_on_executed(...)
end

-- Lines 13-34
function ElementSpawnDeployable:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.deployable_id ~= "none" then
		if self._values.deployable_id == "doctor_bag" then
			DoctorBagBase.spawn(self._values.position, self._values.rotation, 0)
		elseif self._values.deployable_id == "ammo_bag" then
			AmmoBagBase.spawn(self._values.position, self._values.rotation, 0)
		elseif self._values.deployable_id == "grenade_crate" then
			GrenadeCrateBase.spawn(self._values.position, self._values.rotation, 0)
		elseif self._values.deployable_id == "bodybags_bag" then
			BodyBagsBagBase.spawn(self._values.position, self._values.rotation, 0)
		end
	end

	ElementSpawnDeployable.super.on_executed(self, instigator)
end
