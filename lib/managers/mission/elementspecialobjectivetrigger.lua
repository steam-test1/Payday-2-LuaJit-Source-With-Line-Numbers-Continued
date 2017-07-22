core:import("CoreMissionScriptElement")

ElementSpecialObjectiveTrigger = ElementSpecialObjectiveTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementSpecialObjectiveTrigger:init(...)
	ElementSpecialObjectiveTrigger.super.init(self, ...)
end

-- Lines: 9 to 14
function ElementSpecialObjectiveTrigger:on_script_activated()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_event_callback(self._values.event, callback(self, self, "on_executed"))
	end
end

-- Lines: 16 to 22
function ElementSpecialObjectiveTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementSpecialObjectiveTrigger.super.on_executed(self, instigator)
end

return
