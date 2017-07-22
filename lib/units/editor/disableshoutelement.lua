DisableShoutElement = DisableShoutElement or class(MissionElement)
DisableShoutElement.LINK_ELEMENTS = {"elements"}

-- Lines: 4 to 12
function DisableShoutElement:init(unit)
	DisableShoutElement.super.init(self, unit)

	self._hed.elements = {}
	self._hed.disable_shout = true

	table.insert(self._save_values, "elements")
	table.insert(self._save_values, "disable_shout")
end

-- Lines: 16 to 29
function DisableShoutElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local names = {
		"ai_spawn_enemy",
		"ai_spawn_civilian"
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, names)

	local dis_shout = EWS:CheckBox(panel, "Disable shout", "")

	dis_shout:set_value(self._hed.disable_shout)
	dis_shout:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "set_element_data"), {
		value = "disable_shout",
		ctrlr = dis_shout
	})
	panel_sizer:add(dis_shout, 0, 0, "EXPAND")
end

-- Lines: 32 to 33
function DisableShoutElement:update_editing()
end

-- Lines: 36 to 44
function DisableShoutElement:update_selected(t, dt, selected_unit, all_units)
	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				g = 0.5,
				b = 1,
				r = 0.9,
				from_unit = self._unit,
				to_unit = unit
			})
		end
	end
end

-- Lines: 46 to 58
function DisableShoutElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		ray_type = "editor",
		mask = 10
	})

	if ray and ray.unit and (string.find(ray.unit:name():s(), "ai_spawn_enemy", 1, true) or string.find(ray.unit:name():s(), "ai_spawn_civilian", 1, true)) then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

-- Lines: 61 to 63
function DisableShoutElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end

return
