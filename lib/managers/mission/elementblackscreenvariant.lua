core:import("CoreMissionScriptElement")

ElementBlackscreenVariant = ElementBlackscreenVariant or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementBlackscreenVariant:init(...)
	ElementBlackscreenVariant.super.init(self, ...)
end

-- Lines 9-11
function ElementBlackscreenVariant:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-21
function ElementBlackscreenVariant:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_blackscreen_variant(tonumber(self._values.variant))
	ElementBlackscreenVariant.super.on_executed(self, instigator)
end

ElementEndscreenVariant = ElementEndscreenVariant or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 31-33
function ElementEndscreenVariant:init(...)
	ElementEndscreenVariant.super.init(self, ...)
end

-- Lines 35-37
function ElementEndscreenVariant:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 39-46
function ElementEndscreenVariant:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_endscreen_variant(tonumber(self._values.variant))
	ElementEndscreenVariant.super.on_executed(self, instigator)
end
