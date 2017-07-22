core:import("CoreMissionScriptElement")

ElementPlayerStyle = ElementPlayerStyle or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementPlayerStyle:init(...)
	ElementPlayerStyle.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementPlayerStyle:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 20
function ElementPlayerStyle:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.player:change_player_look(self._values.style)
	ElementPlayerStyle.super.on_executed(self, instigator)
end

return
