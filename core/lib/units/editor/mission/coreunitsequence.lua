CoreUnitSequenceUnitElement = CoreUnitSequenceUnitElement or class(MissionElement)
CoreUnitSequenceUnitElement.LINK_VALUES = {
	{
		layer = "Statics",
		output = true,
		table_key = "notify_unit_id",
		table_value = "trigger_list"
	}
}
UnitSequenceUnitElement = UnitSequenceUnitElement or class(CoreUnitSequenceUnitElement)

-- Lines 14-16
function UnitSequenceUnitElement:init(...)
	CoreUnitSequenceUnitElement.init(self, ...)
end

-- Lines 18-26
function CoreUnitSequenceUnitElement:init(unit)
	MissionElement.init(self, unit)

	self._hed.trigger_list = {}
	self._hed.only_for_local_player = nil

	table.insert(self._save_values, "trigger_list")
	table.insert(self._save_values, "only_for_local_player")
end

-- Lines 28-31
function CoreUnitSequenceUnitElement:update_unselected(...)
	MissionElement.update_unselected(self, ...)
	self:verify_trigger_units()
end

-- Lines 33-37
function CoreUnitSequenceUnitElement:update_selected(...)
	MissionElement.update_selected(self, ...)
	self:verify_trigger_units()
	self:_draw_trigger_units(0, 1, 1)
end

-- Lines 39-48
function CoreUnitSequenceUnitElement:verify_trigger_units()
	for i = #self._hed.trigger_list, 1, -1 do
		local unit = managers.editor:unit_with_id(self._hed.trigger_list[i].notify_unit_id)

		if not alive(unit) then
			table.remove(self._hed.trigger_list, i)
		end
	end
end

-- Lines 50-53
function CoreUnitSequenceUnitElement:draw_links_unselected(...)
	CoreUnitSequenceUnitElement.super.draw_links_unselected(self, ...)
	self:_draw_trigger_units(0, 0.75, 0.75)
end

-- Lines 55-76
function CoreUnitSequenceUnitElement:_get_sequence_units()
	local units = {}
	local trigger_name_list = self._unit:damage():get_trigger_name_list()

	if trigger_name_list then
		for _, trigger_name in ipairs(trigger_name_list) do
			local trigger_data = self._unit:damage():get_trigger_data_list(trigger_name)

			if trigger_data and #trigger_data > 0 then
				for _, data in ipairs(trigger_data) do
					if alive(data.notify_unit) then
						table.insert(units, data.notify_unit)
					end
				end
			end
		end
	end

	return units
end

-- Lines 78-90
function CoreUnitSequenceUnitElement:_draw_trigger_units(r, g, b)
	for _, unit in ipairs(self:_get_sequence_units()) do
		local params = {
			from_unit = self._unit,
			to_unit = unit,
			r = r,
			g = g,
			b = b
		}

		self:_draw_link(params)
		Application:draw(unit, r, g, b)
	end
end

-- Lines 92-95
function CoreUnitSequenceUnitElement:new_save_values(...)
	self:_set_trigger_list()

	return MissionElement.new_save_values(self, ...)
end

-- Lines 97-100
function CoreUnitSequenceUnitElement:save_values(...)
	self:_set_trigger_list()
	MissionElement.save_values(self, ...)
end

-- Lines 102-134
function CoreUnitSequenceUnitElement:_set_trigger_list()
	self._hed.trigger_list = {}

	local triggers = managers.sequence:get_trigger_list(self._unit:name())

	if #triggers > 0 then
		local trigger_name_list = self._unit:damage():get_trigger_name_list() or {}

		for _, trigger_name in ipairs(trigger_name_list) do
			local trigger_data = self._unit:damage():get_trigger_data_list(trigger_name)

			if trigger_data and #trigger_data > 0 then
				for _, data in ipairs(trigger_data) do
					local notify_unit_data = data.notify_unit:unit_data()

					if notify_unit_data.instance then
						Application:warn("[CoreUnitSequenceUnitElement] Attempted to store an instanced unit to this element", self._unit:name(), " - notify unit ID:", notify_unit_data.unit_id)
					else
						table.insert(self._hed.trigger_list, {
							name = data.trigger_name,
							id = data.id,
							notify_unit_id = notify_unit_data.unit_id,
							time = data.time,
							notify_unit_sequence = data.notify_unit_sequence
						})
					end
				end
			end
		end
	end
end

-- Lines 136-150
function CoreUnitSequenceUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_checkbox(panel, panel_sizer, "only_for_local_player")

	local help = {}

	help.text = "Use the \"Edit Triggable\" interface, which you enable in the down left toolbar, to select and edit which units and sequences you want to run."
	help.panel = panel
	help.sizer = panel_sizer

	self:add_help_text(help)
end

-- Lines 152-164
function CoreUnitSequenceUnitElement:add_to_mission_package()
	managers.editor:add_to_world_package({
		category = "units",
		name = "core/units/run_sequence_dummy/run_sequence_dummy",
		continent = self._unit:unit_data().continent
	})
	managers.editor:add_to_world_package({
		category = "script_data",
		name = "core/units/run_sequence_dummy/run_sequence_dummy.sequence_manager",
		continent = self._unit:unit_data().continent
	})
end
