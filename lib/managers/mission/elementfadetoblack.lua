core:import("CoreMissionScriptElement")

ElementFadeToBlack = ElementFadeToBlack or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-8
function ElementFadeToBlack:init(...)
	ElementFadeToBlack.super.init(self, ...)
end

-- Lines 10-12
function ElementFadeToBlack:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 14-22
function ElementFadeToBlack:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.overlay_effect:play_effect(self._values.state and tweak_data.overlay_effects.element_fade_in or tweak_data.overlay_effects.element_fade_out)
	ElementFadeToBlack.super.on_executed(self, instigator)
end
