core:module("CoreElementPhysicsPush")
core:import("CoreMissionScriptElement")

ElementPhysicsPush = ElementPhysicsPush or class(CoreMissionScriptElement.MissionScriptElement)
ElementPhysicsPush.IDS_EFFECT = Idstring("core/physic_effects/hubelement_push")

-- Lines: 7 to 9
function ElementPhysicsPush:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 11 to 18
function ElementPhysicsPush:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	World:play_physic_effect(self.IDS_EFFECT, self._values.position, self._values.physicspush_range, self._values.physicspush_velocity, self._values.physicspush_mass)
	ElementPhysicsPush.super.on_executed(self, instigator)
end

return
