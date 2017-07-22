core:import("CoreMissionScriptElement")

ElementBlackscreenVariant = ElementBlackscreenVariant or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementBlackscreenVariant:init(...)
	ElementBlackscreenVariant.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementBlackscreenVariant:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 21
function ElementBlackscreenVariant:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_blackscreen_variant(tonumber(self._values.variant))
	ElementBlackscreenVariant.super.on_executed(self, instigator)
end
ElementEndscreenVariant = ElementEndscreenVariant or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 31 to 33
function ElementEndscreenVariant:init(...)
	ElementEndscreenVariant.super.init(self, ...)
end

-- Lines: 35 to 37
function ElementEndscreenVariant:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 39 to 46
function ElementEndscreenVariant:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_endscreen_variant(tonumber(self._values.variant))
	ElementEndscreenVariant.super.on_executed(self, instigator)
end

return
