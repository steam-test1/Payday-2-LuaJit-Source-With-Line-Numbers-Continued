core:import("CoreMissionScriptElement")

ElementScenarioEvent = ElementScenarioEvent or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-8
function ElementScenarioEvent:init(...)
	ElementScenarioEvent.super.init(self, ...)

	self._network_execute = true
end

-- Lines 10-12
function ElementScenarioEvent:client_on_executed(...)
end

-- Lines 14-20
function ElementScenarioEvent:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementScenarioEvent.super.on_executed(self, instigator)
end

-- Lines 22-35
function ElementScenarioEvent:operation_add()
	local event_decriptor = {
		amount = self._values.amount,
		task_type = self._values.task,
		element = self,
		pos = self._values.position,
		rot = self._values.rotation,
		base_chance = self._values.base_chance or 1,
		chance_inc = self._values.chance_inc or 0
	}

	managers.groupai:state():add_spawn_event(self._id, event_decriptor)
end

-- Lines 37-40
function ElementScenarioEvent:operation_remove()
	managers.groupai:state():remove_spawn_event(self._id)
end
