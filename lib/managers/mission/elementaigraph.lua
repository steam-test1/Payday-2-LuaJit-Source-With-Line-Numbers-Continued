core:import("CoreMissionScriptElement")

ElementAIGraph = ElementAIGraph or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 8
function ElementAIGraph:init(...)
	ElementAIGraph.super.init(self, ...)
end

-- Lines: 11 to 12
function ElementAIGraph:on_script_activated()
end

-- Lines: 14 to 16
function ElementAIGraph:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 18 to 28
function ElementAIGraph:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.graph_ids) do
		managers.navigation:set_nav_segment_state(id, self._values.operation)
	end

	ElementAIGraph.super.on_executed(self, instigator)
end

