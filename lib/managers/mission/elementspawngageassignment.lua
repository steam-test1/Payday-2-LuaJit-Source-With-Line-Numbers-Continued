core:import("CoreMissionScriptElement")

ElementSpawnGageAssignment = ElementSpawnGageAssignment or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementSpawnGageAssignment:init(...)
	ElementSpawnGageAssignment.super.init(self, ...)
end

-- Lines 9-11
function ElementSpawnGageAssignment:on_script_activated()
end

-- Lines 13-23
function ElementSpawnGageAssignment:on_executed(instigator)
	if not self._values.enabled or not managers.gage_assignment then
		return
	end

	local num_executions = tweak_data.gage_assignment:get_num_assignment_units() or 1

	for i = 1, num_executions do
		managers.gage_assignment:queue_spawn(self:get_orientation())
	end

	ElementSpawnGageAssignment.super.on_executed(self, instigator)
end
