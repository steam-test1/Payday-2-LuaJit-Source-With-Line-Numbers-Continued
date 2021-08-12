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
	self:perform_invulnerable(instigator)
end

-- Lines 25-43
function ElementInvulnerable:perform_invulnerable(instigator)
	local units = {}

	if self:_check_unit(instigator) then
		table.insert(units, instigator)
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		for _, unit in ipairs(element:units()) do
			if self:_check_unit(unit) and not table.contains(units, unit) then
				table.insert(units, unit)
			end
		end
	end

	for _, unit in ipairs(units) do
		self:make_unit_invulnerable(unit)
	end
end

-- Lines 45-58
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

-- Lines 61-64
function ElementInvulnerable:make_unit_invulnerable(unit)
	unit:character_damage():set_invulnerable(self._values.invulnerable)
	unit:character_damage():set_immortal(self._values.immortal)
end
