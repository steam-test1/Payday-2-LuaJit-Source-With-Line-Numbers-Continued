core:import("CoreMissionScriptElement")

ElementStatistics = ElementStatistics or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementStatistics:init(...)
	ElementStatistics.super.init(self, ...)
end

-- Lines: 9 to 17
function ElementStatistics:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.statistics:mission_stats(self._values.name)
	ElementStatistics.super.on_executed(self, instigator)
end

-- Lines: 19 to 21
function ElementStatistics:client_on_executed(...)
	self:on_executed(...)
end

return
