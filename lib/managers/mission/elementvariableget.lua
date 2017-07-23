core:import("CoreMissionScriptElement")

ElementVariableGet = ElementVariableGet or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementVariableGet:init(...)
	ElementVariableGet.super.init(self, ...)
end

-- Lines: 9 to 21
function ElementVariableGet:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.activated and not managers.challenge:mission_value(self._values.variable) then
		return
	elseif not self._values.activated and managers.challenge:mission_value(self._values.variable) then
		return
	end

	ElementVariableGet.super.on_executed(self, instigator)
end

-- Lines: 23 to 25
function ElementVariableGet:client_on_executed(...)
	self:on_executed(...)
end

