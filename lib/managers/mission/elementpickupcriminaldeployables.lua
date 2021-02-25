core:import("CoreMissionScriptElement")

ElementPickupCriminalDeployables = ElementPickupCriminalDeployables or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-6
function ElementPickupCriminalDeployables:client_on_executed(...)
end

-- Lines 8-19
function ElementPickupCriminalDeployables:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local groupai_state = managers.groupai and managers.groupai:state()

	if groupai_state then
		groupai_state:pickup_criminal_deployables()
	end

	ElementPickupCriminalDeployables.super.on_executed(self, instigator)
end
