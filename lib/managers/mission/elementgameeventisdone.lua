core:import("CoreMissionScriptElement")

ElementGameEventIsDone = ElementGameEventIsDone or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementGameEventIsDone:init(...)
	ElementGameEventIsDone.super.init(self, ...)
end

-- Lines 9-25
function ElementGameEventIsDone:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local ok = false

	if not ok then
		return
	end

	ElementGameEventIsDone.super.on_executed(self, instigator)
end

-- Lines 27-29
function ElementGameEventIsDone:client_on_executed(...)
	self:on_executed(...)
end
