core:import("CoreMissionScriptElement")

ElementModifyPlayer = ElementModifyPlayer or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementModifyPlayer:init(...)
	ElementModifyPlayer.super.init(self, ...)
end

-- Lines 9-11
function ElementModifyPlayer:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-25
function ElementModifyPlayer:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if alive(instigator) then
		instigator:character_damage():set_mission_damage_blockers("damage_fall_disabled", self._values.damage_fall_disabled)
		instigator:character_damage():set_mission_damage_blockers("invulnerable", self._values.invulnerable)
	end

	ElementModifyPlayer.super.on_executed(self, instigator)
end
