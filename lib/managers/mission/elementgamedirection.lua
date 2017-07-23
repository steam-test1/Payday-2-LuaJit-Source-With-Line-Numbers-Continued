core:import("CoreMissionScriptElement")

ElementGameDirection = ElementGameDirection or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementGameDirection:init(...)
	ElementGameDirection.super.init(self, ...)
end

-- Lines: 9 to 17
function ElementGameDirection:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_mission_fwd_vector(self._values.rotation:y(), self._values.position)
	ElementGameDirection.super.on_executed(self, instigator)
end

