core:import("CoreMissionScriptElement")

ElementInvulnerable = ElementInvulnerable or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 9-11
function ElementInvulnerable:init(...)
	ElementInvulnerable.super.init(self, ...)
end

-- Lines 13-19
function ElementInvulnerable:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:perform_invulnerable(instigator)
	ElementInvulnerable.super.on_executed(self, instigator)
end

-- Lines 21-23
function ElementInvulnerable:client_on_executed(instigator)
	self:make_unit_invulnerable(instigator)
end

-- Lines 25-34
function ElementInvulnerable:perform_invulnerable(instigator)
	self:make_unit_invulnerable(instigator)

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		for _, unit in ipairs(element:units()) do
			self:make_unit_invulnerable(unit)
		end
	end
end

-- Lines 36-49
function ElementInvulnerable:_check_unit(unit)
	if alive(unit) and unit:character_damage() then
		local all_char_criminals = managers.groupai:state():all_char_criminals()

		for key, char_data in pairs(all_char_criminals) do
			if char_data.unit == unit then
				return false
			end
		end

		return unit:character_damage().set_invulnerable and unit:character_damage().set_immortal
	end

	return false
end

-- Lines 52-57
function ElementInvulnerable:make_unit_invulnerable(unit)
	if self:_check_unit(unit) then
		unit:character_damage():set_invulnerable(self._values.invulnerable)
		unit:character_damage():set_immortal(self._values.immortal)
	end
end
