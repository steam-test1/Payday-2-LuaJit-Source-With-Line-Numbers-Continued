core:module("CoreElementOperator")
core:import("CoreMissionScriptElement")

ElementOperator = ElementOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-8
function ElementOperator:init(...)
	ElementOperator.super.init(self, ...)
end

-- Lines 10-12
function ElementOperator:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 14-32
function ElementOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.operation == "add" then
				element:operation_add()
			elseif self._values.operation == "remove" then
				element:operation_remove()
			end
		end
	end

	ElementOperator.super.on_executed(self, instigator)
end
