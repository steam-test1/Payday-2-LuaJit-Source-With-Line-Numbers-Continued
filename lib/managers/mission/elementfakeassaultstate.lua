core:import("CoreMissionScriptElement")

ElementFakeAssaultState = ElementFakeAssaultState or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementFakeAssaultState:init(...)
	ElementFakeAssaultState.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementFakeAssaultState:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 21
function ElementFakeAssaultState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_fake_assault_mode(self._values.state)
	ElementFakeAssaultState.super.on_executed(self, instigator)
end

return
