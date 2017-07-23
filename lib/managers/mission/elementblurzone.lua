core:import("CoreMissionScriptElement")

ElementBlurZone = ElementBlurZone or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementBlurZone:init(...)
	ElementBlurZone.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementBlurZone:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 28
function ElementBlurZone:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.mode == 0 then
		managers.environment_controller:set_blurzone(self._id, self._values.mode)
	else
		managers.environment_controller:set_blurzone(self._id, self._values.mode, self._values.position, self._values.radius, self._values.height)
	end

	ElementBlurZone.super.on_executed(self, instigator)
end

-- Lines: 30 to 32
function ElementBlurZone:operation_remove()
	managers.environment_controller:set_blurzone(self._id, -1)
end

