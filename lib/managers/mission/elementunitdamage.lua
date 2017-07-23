core:import("CoreMissionScriptElement")

ElementUnitDamage = ElementUnitDamage or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 6 to 23
function ElementUnitDamage:init(...)
	ElementUnitDamage.super.init(self, ...)

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

-- Lines: 25 to 26
function ElementUnitDamage:destroy()
end

-- Lines: 28 to 29
function MissionScriptElement:on_created()
end

-- Lines: 32 to 62
function ElementUnitDamage:on_script_activated()
	local elementBroken = false

	for _, id in ipairs(self._values.unit_ids) do
		if Global.running_simulation then
			if not managers.editor:unit_with_id(id) then
				print("MISSING UNIT WITH ID:", id)

				elementBroken = true
			else
				self:_load_unit(managers.editor:unit_with_id(id))
			end
		else
			local unit = managers.worlddefinition:get_unit_on_load(id, callback(self, self, "_load_unit"))

			if unit then
				self:_load_unit(unit)
			end
		end
	end

	if elementBroken then
		for _, id in ipairs(self._values.unit_ids) do
			if managers.editor:unit_with_id(id) then
				print(inspect(managers.editor:unit_with_id(id)))
			end
		end
	end

	self._has_fetched_units = true

	self._mission_script:add_save_state_cb(self._id)
end

-- Lines: 64 to 69
function ElementUnitDamage:_load_unit(unit)
	if unit.damage then
		unit:damage():add_listener("element_unit_damage" .. self._id, {"on_take_damage"}, callback(self, self, "clbk_linked_unit_took_damage"))
		table.insert(self._units, unit)
	end
end

-- Lines: 71 to 73
function ElementUnitDamage:clbk_linked_unit_took_damage(unit, attacker, damage_type, damage)
	self:on_executed(attacker, damage_type, damage)
end

-- Lines: 76 to 92
function ElementUnitDamage:on_executed(instigator, damage_type, damage)
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
		ElementUnitDamage.super.on_executed(self, instigator)
	end
end

-- Lines: 95 to 96
function ElementUnitDamage:client_on_executed(...)
end

-- Lines: 98 to 100
function ElementUnitDamage:save(data)
	data.enabled = self._values.enabled
end

-- Lines: 102 to 104
function ElementUnitDamage:load(data)
	self:set_enabled(data.enabled)
end

