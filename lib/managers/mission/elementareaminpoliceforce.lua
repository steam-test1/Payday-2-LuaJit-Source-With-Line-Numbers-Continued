core:import("CoreMissionScriptElement")

ElementAreaMinPoliceForce = ElementAreaMinPoliceForce or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 8
function ElementAreaMinPoliceForce:init(...)
	ElementAreaMinPoliceForce.super.init(self, ...)

	self._network_execute = true
end

-- Lines: 14 to 21
function ElementAreaMinPoliceForce:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:operation_add()
	ElementAreaMinPoliceForce.super.on_executed(self, instigator)
end

-- Lines: 23 to 25
function ElementAreaMinPoliceForce:operation_add()
	managers.groupai:state():set_area_min_police_force(self._id, self._values.amount, self._values.position)
end

-- Lines: 27 to 29
function ElementAreaMinPoliceForce:operation_remove()
	managers.groupai:state():set_area_min_police_force(self._id)
end

