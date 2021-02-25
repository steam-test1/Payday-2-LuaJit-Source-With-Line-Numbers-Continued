core:import("CoreMissionScriptElement")

ElementBainState = ElementBainState or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementBainState:init(...)
	ElementBainState.super.init(self, ...)
end

-- Lines 9-11
function ElementBainState:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-21
function ElementBainState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_bain_state(self._values.state)
	ElementBainState.super.on_executed(self, instigator)
end
