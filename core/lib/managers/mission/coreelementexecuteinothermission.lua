core:module("CoreElementExecuteInOtherMission")
core:import("CoreMissionScriptElement")

ElementExecuteInOtherMission = ElementExecuteInOtherMission or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-8
function ElementExecuteInOtherMission:init(...)
	ElementExecuteInOtherMission.super.init(self, ...)
end

-- Lines 10-12
function ElementExecuteInOtherMission:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 15-21
function ElementExecuteInOtherMission:get_mission_element(id)
	for name, script in pairs(managers.mission:scripts()) do
		if script:element(id) then
			return script:element(id)
		end
	end
end
