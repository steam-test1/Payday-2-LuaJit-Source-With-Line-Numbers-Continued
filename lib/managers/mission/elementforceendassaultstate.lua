core:import("CoreMissionScriptElement")

ElementForceEndAssaultState = ElementForceEndAssaultState or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementForceEndAssaultState:init(...)
	ElementForceEndAssaultState.super.init(self, ...)
end

-- Lines 9-10
function ElementForceEndAssaultState:client_on_executed(...)
end

-- Lines 12-22
function ElementForceEndAssaultState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if managers.groupai:state().force_end_assault_phase then
		managers.groupai:state():force_end_assault_phase(true)
	end

	ElementForceEndAssaultState.super.on_executed(self, instigator)
end
