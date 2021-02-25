core:import("CoreMissionScriptElement")

ElementTeamRelation = ElementTeamRelation or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementTeamRelation:init(...)
	ElementCharacterTeam.super.init(self, ...)
end

-- Lines 9-22
function ElementTeamRelation:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_team_relation(self._values.team1, self._values.team2, self._values.relation, self._values.mutual)
	ElementTeamRelation.super.on_executed(self, instigator)
end
