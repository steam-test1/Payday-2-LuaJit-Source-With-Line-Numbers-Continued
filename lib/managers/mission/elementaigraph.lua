core:import("CoreMissionScriptElement")

ElementAIGraph = ElementAIGraph or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-8
function ElementAIGraph:init(...)
	ElementAIGraph.super.init(self, ...)
end

-- Lines 10-12
function ElementAIGraph:on_script_activated()
end

-- Lines 14-16
function ElementAIGraph:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 18-37
function ElementAIGraph:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local handler_func = nil
	local is_meta_operation = table.contains(NavigationManager.nav_meta_operations, self._values.operation)

	if is_meta_operation then
		handler_func = NavigationManager.perform_nav_segment_meta_operation
	else
		handler_func = NavigationManager.set_nav_segment_state
	end

	for _, id in ipairs(self._values.graph_ids) do
		handler_func(managers.navigation, id, self._values.operation, self._values.filter_group)
	end

	ElementAIGraph.super.on_executed(self, instigator)
end
