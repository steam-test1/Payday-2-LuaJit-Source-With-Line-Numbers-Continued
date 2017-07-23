CoreOperatorUnitElement = CoreOperatorUnitElement or class(MissionElement)
CoreOperatorUnitElement.SAVE_UNIT_POSITION = false
CoreOperatorUnitElement.SAVE_UNIT_ROTATION = false
CoreOperatorUnitElement.LINK_ELEMENTS = {"elements"}
OperatorUnitElement = OperatorUnitElement or class(CoreOperatorUnitElement)

-- Lines: 8 to 10
function OperatorUnitElement:init(...)
	OperatorUnitElement.super.init(self, ...)
end

-- Lines: 12 to 20
function CoreOperatorUnitElement:init(unit)
	CoreOperatorUnitElement.super.init(self, unit)

	self._hed.operation = "none"
	self._hed.elements = {}

	table.insert(self._save_values, "operation")
	table.insert(self._save_values, "elements")
end

-- Lines: 22 to 36
function CoreOperatorUnitElement:draw_links(t, dt, selected_unit, all_units)
	CoreOperatorUnitElement.super.draw_links(self, t, dt, selected_unit)

	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]

		if not alive(unit) then
			table.delete(self._hed.elements, id)
		else
			local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

			if draw then
				self:_draw_link({
					g = 0.75,
					b = 0.25,
					r = 0.75,
					from_unit = self._unit,
					to_unit = unit
				})
			end
		end
	end
end

-- Lines: 38 to 41
function CoreOperatorUnitElement:get_links_to_unit(...)
	CoreOperatorUnitElement.super.get_links_to_unit(self, ...)
	self:_get_links_of_type_from_elements(self._hed.elements, "operator", ...)
end

-- Lines: 43 to 44
function CoreOperatorUnitElement:update_editing()
end

-- Lines: 46 to 56
function CoreOperatorUnitElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		ray_type = "editor",
		mask = 10
	})

	if ray and ray.unit then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

-- Lines: 59 to 61
function CoreOperatorUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

-- Lines: 63 to 75
function CoreOperatorUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local names = nil

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)
	self:_build_value_combobox(panel, panel_sizer, "operation", {
		"none",
		"add",
		"remove"
	}, "Select an operation for the selected elements")
	self:_add_help_text("Choose an operation to perform on the selected elements. An element might not have the selected operation implemented and will then generate error when executed.")
end

