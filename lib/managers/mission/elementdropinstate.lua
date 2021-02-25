core:import("CoreMissionScriptElement")

ElementDropinState = ElementDropinState or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementDropinState:init(...)
	ElementDropinState.super.init(self, ...)
end

-- Lines 9-11
function ElementDropinState:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-21
function ElementDropinState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_allow_dropin(self._values.state)
	ElementDropinState.super.on_executed(self, instigator)
end
