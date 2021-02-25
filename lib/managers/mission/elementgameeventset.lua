core:import("CoreMissionScriptElement")

ElementGameEventSet = ElementGameEventSet or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementGameEventSet:init(...)
	ElementGameEventSet.super.init(self, ...)
end

-- Lines 9-17
function ElementGameEventSet:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementGameEventSet.super.on_executed(self, instigator)
end

-- Lines 19-21
function ElementGameEventSet:client_on_executed(...)
	self:on_executed(...)
end
