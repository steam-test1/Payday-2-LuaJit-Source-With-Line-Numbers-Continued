core:import("CoreMissionScriptElement")

ElementVariableSet = ElementVariableSet or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementVariableSet:init(...)
	ElementVariableSet.super.init(self, ...)
end

-- Lines: 9 to 17
function ElementVariableSet:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.challenge:mission_set_value(self._values.variable, self._values.activated)
	ElementVariableSet.super.on_executed(self, instigator)
end

-- Lines: 19 to 21
function ElementVariableSet:client_on_executed(...)
	self:on_executed(...)
end

return
