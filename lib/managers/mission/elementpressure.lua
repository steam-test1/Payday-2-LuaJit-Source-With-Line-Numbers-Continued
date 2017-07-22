core:import("CoreMissionScriptElement")

ElementPressure = ElementPressure or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementPressure:init(...)
	ElementPressure.super.init(self, ...)
end

-- Lines: 10 to 11
function ElementPressure:client_on_executed(...)
end

-- Lines: 13 to 30
function ElementPressure:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.points ~= 0 then
		if self._values.points > 0 then
			managers.groupai:state():add_pressure(self._values.points)
		else
			managers.groupai:state():add_cooldown(math.abs(self._values.points))
		end
	else
		local interval = self._values.interval ~= 0 and self._values.interval

		managers.groupai:state():set_heat_build_period(interval)
	end

	ElementPressure.super.on_executed(self, instigator)
end

return
