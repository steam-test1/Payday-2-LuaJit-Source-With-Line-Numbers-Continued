core:import("CoreMissionScriptElement")

ElementLoadDelayed = ElementLoadDelayed or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementLoadDelayed:init(...)
	ElementLoadDelayed.super.init(self, ...)
end

-- Lines 9-11
function ElementLoadDelayed:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-24
function ElementLoadDelayed:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not Application:editor() then
		for _, unit_id in ipairs(self._values.unit_ids) do
			managers.worlddefinition:create_delayed_unit(unit_id)
		end
	end

	ElementLoadDelayed.super.on_executed(self, instigator)
end
