core:import("CoreMissionScriptElement")

ElementExperience = ElementExperience or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementExperience:init(...)
	ElementExperience.super.init(self, ...)
end

-- Lines: 9 to 17
function ElementExperience:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.experience:mission_xp_award(self._values.amount)
	ElementExperience.super.on_executed(self, instigator)
end

-- Lines: 19 to 21
function ElementExperience:client_on_executed(...)
	self:on_executed(...)
end

