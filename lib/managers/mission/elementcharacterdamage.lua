core:import("CoreMissionScriptElement")

ElementCharacterDamage = ElementCharacterDamage or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-23
function ElementCharacterDamage:init(...)
	ElementCharacterDamage.super.init(self, ...)

	self._units = {}
	local dmg_filter = self:value("damage_types")

	if dmg_filter and dmg_filter ~= "" then
		self._allow_damage_types = {}
		local dmgs = string.split(dmg_filter, " ")

		for _, dmg_type in ipairs(dmgs) do
			table.insert(self._allow_damage_types, dmg_type)
		end
	end
end

-- Lines 25-26
function ElementCharacterDamage:destroy()
end

-- Lines 28-29
function ElementCharacterDamage:on_created()
end

-- Lines 31-38
function ElementCharacterDamage:on_script_activated()
	for _, id in ipairs(self:value("elements")) do
		local element = self:get_mission_element(id)

		if element.add_event_callback then
			element:add_event_callback("spawn", callback(self, self, "unit_spawned"))
		end
	end
end

-- Lines 40-44
function ElementCharacterDamage:unit_spawned(unit)
	if alive(unit) and unit:character_damage() then
		unit:character_damage():add_listener("character_damage_" .. tostring(unit:key()), nil, callback(self, self, "clbk_linked_unit_took_damage"))
	end
end

-- Lines 46-58
function ElementCharacterDamage:clbk_linked_unit_took_damage(unit, damage_info)
	if not alive(unit) then
		return
	end

	local damage = damage_info.damage

	if self:value("percentage") then
		damage = damage / unit:character_damage()._HEALTH_INIT * 100
	end

	self:on_executed(damage_info.attacker_unit, damage, damage_info.variant)
end

-- Lines 60-75
function ElementCharacterDamage:on_executed(instigator, damage, damage_type)
	if not self._values.enabled then
		return
	end

	local allow = true

	if self._allow_damage_types and not table.contains(self._allow_damage_types, damage_type) then
		allow = false
	end

	if allow then
		damage = math.floor(damage * tweak_data.gui.stats_present_multiplier)

		self:override_value_on_element_type("ElementCounterOperator", "amount", damage)
		ElementCharacterDamage.super.on_executed(self, instigator)
	end
end

-- Lines 77-79
function ElementCharacterDamage:save(data)
	data.enabled = self._values.enabled
end

-- Lines 81-83
function ElementCharacterDamage:load(data)
	self:set_enabled(data.enabled)
end
