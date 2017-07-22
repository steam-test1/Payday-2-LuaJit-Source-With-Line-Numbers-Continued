core:import("CoreMissionScriptElement")

ElementEnableUnit = ElementEnableUnit or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 9
function ElementEnableUnit:init(...)
	ElementEnableUnit.super.init(self, ...)

	self._units = {}
end

-- Lines: 12 to 46
function ElementEnableUnit:on_script_activated()
	local elementBroken = false

	for _, id in ipairs(self._values.unit_ids) do
		if Global.running_simulation then
			local unit = managers.editor:unit_with_id(id)

			if unit then
				table.insert(self._units, unit)
			else
				elementBroken = true

				print("MISSING UNIT WITH ID:", id)
			end
		else
			local unit = managers.worlddefinition:get_unit_on_load(id, callback(self, self, "_load_unit"))

			if unit then
				table.insert(self._units, unit)
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

-- Lines: 50 to 52
function ElementEnableUnit:_load_unit(unit)
	table.insert(self._units, unit)
end

-- Lines: 54 to 56
function ElementEnableUnit:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 58 to 69
function ElementEnableUnit:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, unit in ipairs(self._units) do
		managers.game_play_central:mission_enable_unit(unit)
	end

	ElementEnableUnit.super.on_executed(self, instigator)
end

-- Lines: 71 to 74
function ElementEnableUnit:save(data)
	data.save_me = true
	data.enabled = self._values.enabled
end

-- Lines: 77 to 82
function ElementEnableUnit:load(data)
	if not self._has_fetched_units then
		self:on_script_activated()
	end

	self:set_enabled(data.enabled)
end

return
