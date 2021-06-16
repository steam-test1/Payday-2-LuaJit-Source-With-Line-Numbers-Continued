PointOfNoReturnElement = PointOfNoReturnElement or class(MissionElement)
PointOfNoReturnElement.LINK_ELEMENTS = {
	"elements"
}

-- Lines 4-30
function PointOfNoReturnElement:init(unit)
	PointOfNoReturnElement.super.init(self, unit)
	self:_add_tweak_options()

	self._hed.elements = {}
	self._hed.tweak_id = "noreturn"
	self._hed.time_easy = 300
	self._hed.time_normal = 240
	self._hed.time_hard = 120
	self._hed.time_overkill = 60
	self._hed.time_overkill_145 = 30
	self._hed.time_easy_wish = nil
	self._hed.time_overkill_290 = 15
	self._hed.time_sm_wish = nil

	table.insert(self._save_values, "elements")
	table.insert(self._save_values, "tweak_id")
	table.insert(self._save_values, "time_easy")
	table.insert(self._save_values, "time_normal")
	table.insert(self._save_values, "time_hard")
	table.insert(self._save_values, "time_overkill")
	table.insert(self._save_values, "time_overkill_145")
	table.insert(self._save_values, "time_easy_wish")
	table.insert(self._save_values, "time_overkill_290")
	table.insert(self._save_values, "time_sm_wish")
end

-- Lines 32-42
function PointOfNoReturnElement:post_init(...)
	PointOfNoReturnElement.super.post_init(self, ...)

	if self._hed.time_easy_wish == nil then
		self._hed.time_easy_wish = self._hed.time_overkill_290
	end

	if self._hed.time_sm_wish == nil then
		self._hed.time_sm_wish = self._hed.time_overkill_290
	end
end

-- Lines 44-50
function PointOfNoReturnElement:_add_tweak_options()
	self._tweak_options = table.map_keys(tweak_data.point_of_no_returns, function (x, y)
		if x == "noreturn" then
			return true
		end

		if y == "noreturn" then
			return false
		end

		return x < y
	end)
end

-- Lines 52-55
function PointOfNoReturnElement:_set_text()
	local data = tweak_data.point_of_no_returns[self._hed.tweak_id]

	self._text:set_value(managers.localization:text(data.text_id))
end

-- Lines 57-62
function PointOfNoReturnElement:set_element_data(params, ...)
	PointOfNoReturnElement.super.set_element_data(self, params, ...)

	if params.value == "tweak_id" then
		self:_set_text()
	end
end

-- Lines 65-241
function PointOfNoReturnElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local exact_names = {
		"core/units/mission_elements/trigger_area/trigger_area"
	}

	self:_build_add_remove_unit_from_list(panel, panel_sizer, self._hed.elements, nil, exact_names)
	self:_build_value_combobox(panel, panel_sizer, "tweak_id", self._tweak_options, "Select an id from the combobox")

	local data = tweak_data.point_of_no_returns[self._hed.tweak_id]
	local text_sizer = EWS:BoxSizer("HORIZONTAL")

	text_sizer:add(EWS:StaticText(panel, "Text: ", "", ""), 1, 2, "ALIGN_CENTER_VERTICAL,RIGHT,EXPAND")

	self._text = EWS:StaticText(panel, managers.localization:text(data.text_id), "", "")

	text_sizer:add(self._text, 2, 2, "RIGHT,TOP,EXPAND")
	panel_sizer:add(text_sizer, 0, 4, "EXPAND,BOTTOM")

	local time_params_easy = {
		name = "Time left on easy:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Easy difficulty (Currently not used on Payday 2)",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_easy
	}
	local time_easy = CoreEWS.number_controller(time_params_easy)

	time_easy:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_easy",
		ctrlr = time_easy
	})
	time_easy:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_easy",
		ctrlr = time_easy
	})

	local time_params_normal = {
		name = "Time left on normal:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Normal difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_normal
	}
	local time_normal = CoreEWS.number_controller(time_params_normal)

	time_normal:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_normal",
		ctrlr = time_normal
	})
	time_normal:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_normal",
		ctrlr = time_normal
	})

	local time_params_hard = {
		name = "Time left on hard:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Hard difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_hard
	}
	local time_hard = CoreEWS.number_controller(time_params_hard)

	time_hard:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_hard",
		ctrlr = time_hard
	})
	time_hard:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_hard",
		ctrlr = time_hard
	})

	local time_params_overkill = {
		name = "Time left on overkill:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Very Hard difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_overkill
	}
	local time_overkill = CoreEWS.number_controller(time_params_overkill)

	time_overkill:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_overkill",
		ctrlr = time_overkill
	})
	time_overkill:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_overkill",
		ctrlr = time_overkill
	})

	local time_params_overkill_145 = {
		name = "Time left on overkill 145:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Overkill difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_overkill_145
	}
	local time_overkill_145 = CoreEWS.number_controller(time_params_overkill_145)

	time_overkill_145:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_overkill_145",
		ctrlr = time_overkill_145
	})
	time_overkill_145:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_overkill_145",
		ctrlr = time_overkill_145
	})

	local time_params_easy_wish = {
		name = "Time left on easy wish:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Easy Wish difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_easy_wish
	}
	local time_easy_wish = CoreEWS.number_controller(time_params_easy_wish)

	time_easy_wish:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_easy_wish",
		ctrlr = time_easy_wish
	})
	time_easy_wish:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_easy_wish",
		ctrlr = time_easy_wish
	})

	local time_params_overkill_290 = {
		name = "Time left on overkill 290:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on Death Wish difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_overkill_290
	}
	local time_overkill_290 = CoreEWS.number_controller(time_params_overkill_290)

	time_overkill_290:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_overkill_290",
		ctrlr = time_overkill_290
	})
	time_overkill_290:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_overkill_290",
		ctrlr = time_overkill_290
	})

	local time_params_sm_wish = {
		name = "Time left on sm wish:",
		ctrlr_proportions = 2,
		name_proportions = 1,
		tooltip = "Set the time left on SM Wish difficulty",
		min = 1,
		floats = 0,
		panel = panel,
		sizer = panel_sizer,
		value = self._hed.time_sm_wish
	}
	local time_sm_wish = CoreEWS.number_controller(time_params_sm_wish)

	time_sm_wish:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "time_sm_wish",
		ctrlr = time_sm_wish
	})
	time_sm_wish:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "time_sm_wish",
		ctrlr = time_sm_wish
	})
end

-- Lines 250-252
function PointOfNoReturnElement:draw_links(t, dt, selected_unit, all_units)
	MissionElement.draw_links(self, t, dt, selected_unit, all_units)
end

-- Lines 254-255
function PointOfNoReturnElement:update_editing()
end

-- Lines 258-266
function PointOfNoReturnElement:update_selected(t, dt, selected_unit, all_units)
	for _, id in ipairs(self._hed.elements) do
		local unit = all_units[id]
		local draw = not selected_unit or unit == selected_unit or self._unit == selected_unit

		if draw then
			self:_draw_link({
				g = 0,
				b = 0.75,
				r = 0.75,
				from_unit = self._unit,
				to_unit = unit
			})
		end
	end
end

-- Lines 268-278
function PointOfNoReturnElement:add_element()
	local ray = managers.editor:unit_by_raycast({
		ray_type = "editor",
		mask = 10
	})

	if ray and ray.unit and ray.unit:name():s() == "core/units/mission_elements/trigger_area/trigger_area" then
		local id = ray.unit:unit_data().unit_id

		if table.contains(self._hed.elements, id) then
			table.delete(self._hed.elements, id)
		else
			table.insert(self._hed.elements, id)
		end
	end
end

-- Lines 281-283
function PointOfNoReturnElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "add_element"))
end
