core:import("CoreMissionScriptElement")

ElementArcadeState = ElementArcadeState or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-15
function ElementArcadeState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementArcadeState.super.on_executed(self, instigator)
end
