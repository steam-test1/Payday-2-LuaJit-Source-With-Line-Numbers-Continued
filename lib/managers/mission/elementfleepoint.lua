core:import("CoreMissionScriptElement")

ElementFleePoint = ElementFleePoint or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementFleePoint:init(...)
	ElementFleePoint.super.init(self, ...)
end

-- Lines 9-16
function ElementFleePoint:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:operation_add()
	ElementFleePoint.super.on_executed(self, instigator)
end

-- Lines 18-24
function ElementFleePoint:operation_add()
	if self._values.functionality == "loot_drop" then
		managers.groupai:state():add_enemy_loot_drop_point(self._id, self._values.position)
	else
		managers.groupai:state():add_flee_point(self._id, self._values.position)
	end
end

-- Lines 26-32
function ElementFleePoint:operation_remove()
	if self._values.functionality == "loot_drop" then
		managers.groupai:state():remove_enemy_loot_drop_point(self._id)
	else
		managers.groupai:state():remove_flee_point(self._id)
	end
end
