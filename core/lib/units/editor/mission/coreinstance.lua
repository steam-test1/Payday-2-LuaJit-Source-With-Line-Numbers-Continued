CoreInstanceInputUnitElement = CoreInstanceInputUnitElement or class(MissionElement)
InstanceInputUnitElement = InstanceInputUnitElement or class(CoreInstanceInputUnitElement)
InstanceInputUnitElement.SAVE_UNIT_POSITION = false
InstanceInputUnitElement.SAVE_UNIT_ROTATION = false

-- Lines 7-13
function InstanceInputUnitElement:init(...)
	InstanceInputUnitElement.super.init(self, ...)

	self._hed.event = "none"

	table.insert(self._save_values, "event")
end

-- Lines 15-27
function InstanceInputUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local event = EWS:TextCtrl(panel, self._hed.event, "", "TE_PROCESS_ENTER")

	panel_sizer:add(event, 0, 0, "EXPAND")
	event:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "event",
		ctrlr = event
	})
	event:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "event",
		ctrlr = event
	})
end

CoreInstanceOutputUnitElement = CoreInstanceOutputUnitElement or class(MissionElement)
InstanceOutputUnitElement = InstanceOutputUnitElement or class(CoreInstanceOutputUnitElement)
InstanceOutputUnitElement.SAVE_UNIT_POSITION = false
InstanceOutputUnitElement.SAVE_UNIT_ROTATION = false

-- Lines 37-43
function InstanceOutputUnitElement:init(...)
	InstanceOutputUnitElement.super.init(self, ...)

	self._hed.event = "none"

	table.insert(self._save_values, "event")
end

-- Lines 45-57
function InstanceOutputUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local event = EWS:TextCtrl(panel, self._hed.event, "", "TE_PROCESS_ENTER")

	panel_sizer:add(event, 0, 0, "EXPAND")
	event:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "set_element_data"), {
		value = "event",
		ctrlr = event
	})
	event:connect("EVT_KILL_FOCUS", callback(self, self, "set_element_data"), {
		value = "event",
		ctrlr = event
	})
end

CoreInstanceEventUnitElement = CoreInstanceEventUnitElement or class(MissionElement)
InstanceEventUnitElement = InstanceEventUnitElement or class(CoreInstanceEventUnitElement)
InstanceEventUnitElement.SAVE_UNIT_POSITION = false
InstanceEventUnitElement.SAVE_UNIT_ROTATION = false

-- Lines 68-77
function InstanceEventUnitElement:init(type, ...)
	InstanceEventUnitElement.super.init(self, ...)

	self._type = type
	self._guis = {}
	self._hed.event_list = {}

	table.insert(self._save_values, "event_list")
end

-- Lines 79-85
function InstanceEventUnitElement:layer_finished(...)
	InstanceEventUnitElement.super.layer_finished(self, ...)

	if self._hed.instance then
		table.insert(self._hed.event_list, {
			instance = self._hed.instance,
			event = self._hed.event
		})
	end
end

-- Lines 87-89
function InstanceEventUnitElement:selected()
	InstanceEventUnitElement.super.selected(self)
end

-- Lines 91-95
function InstanceEventUnitElement:update_selected(t, dt)
	for _, data in ipairs(self._hed.event_list) do
		self:_draw_instance_link(t, dt, data.instance)
	end
end

-- Lines 97-102
function InstanceEventUnitElement:update_editing(t, dt)
	local instance_name = self:_instance_name_raycast()

	if instance_name then
		self:_draw_instance_link(t, dt, instance_name)
	end
end

-- Lines 104-112
function InstanceEventUnitElement:_draw_instance_link(t, dt, instance_name)
	local r, g, b = self:get_link_color()

	managers.editor:layer("Instances"):external_draw_instance(t, dt, instance_name, r, g, b)

	if self._type == "input" then
		Application:draw_arrow(self._unit:position(), managers.world_instance:get_instance_data_by_name(instance_name).position, r, g, b, 0.2)
	else
		Application:draw_arrow(managers.world_instance:get_instance_data_by_name(instance_name).position, self._unit:position(), r, g, b, 0.2)
	end
end

-- Lines 114-125
function InstanceEventUnitElement:_instance_name_raycast()
	local ray = managers.editor:unit_by_raycast({
		ray_type = "body editor",
		skip_instance_check = true,
		mask = 1
	})

	if not ray or not ray.unit then
		return nil
	end

	local instance_name = ray.unit:unit_data().instance

	if not instance_name then
		return nil
	end

	local instance_data = managers.world_instance:get_instance_data_by_name(instance_name)

	return instance_data.script == self._unit:mission_element_data().script and instance_name or nil
end

-- Lines 128-141
function InstanceEventUnitElement:on_instance_changed_name(old_name, new_name)
	for _, data in ipairs(self._hed.event_list) do
		if data.instance == old_name then
			data.instance = new_name
		end
	end

	for _, data in ipairs(self._guis) do
		if data.instance_name == old_name then
			data.instance_name = new_name

			data.instance_name_ctrlr:set_label(new_name)
		end
	end
end

-- Lines 144-151
function InstanceEventUnitElement:on_instance_deleted(name)
	local clone_guis = clone(self._guis)

	for i, event_list_data in ipairs(clone(self._hed.event_list)) do
		if event_list_data.instance == name then
			self:remove_entry(event_list_data)
		end
	end
end

-- Lines 153-159
function InstanceEventUnitElement:_get_events(instance_name)
	if self._type == "input" then
		return managers.world_instance:get_mission_inputs_by_name(instance_name)
	else
		return managers.world_instance:get_mission_outputs_by_name(instance_name)
	end
end

-- Lines 161-166
function InstanceEventUnitElement:_set_instance_by_raycast()
	local instance_name = self:_instance_name_raycast()

	if instance_name then
		self:_add_instance_by_name(instance_name)
	end
end

-- Lines 168-174
function InstanceEventUnitElement:_add_instance_by_name(instance_name)
	local events = self:_get_events(instance_name)
	local event_list_data = {
		instance = instance_name,
		event = events[1]
	}

	table.insert(self._hed.event_list, event_list_data)
	self:_add_instance_gui(instance_name, events, event_list_data)
end

-- Lines 176-215
function InstanceEventUnitElement:_add_instance_gui(instance_name, events, event_list_data)
	local panel = self._panel
	local panel_sizer = self._panel_sizer
	local h_sizer = EWS:BoxSizer("HORIZONTAL")

	panel_sizer:add(h_sizer, 0, 1, "EXPAND,LEFT")

	local instance_name_ctrlr = EWS:StaticText(panel, "" .. instance_name, 0, "ALIGN_LEFT")

	h_sizer:add(instance_name_ctrlr, 2, 1, "LEFT,ALIGN_CENTER_VERTICAL")

	local events_params = {
		ctrlr_proportions = 2,
		name_proportions = 0,
		tooltip = "Select an event from the combobox",
		sorted = true,
		sizer_proportions = 2,
		panel = panel,
		sizer = h_sizer,
		options = events,
		value = event_list_data.event
	}
	local event = CoreEws.combobox(events_params)
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("SELECT", "Remove", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("SELECT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "remove_entry"), event_list_data)
	toolbar:realize()
	table.insert(self._guis, {
		instance_name_ctrlr = instance_name_ctrlr,
		instance_name = instance_name,
		event = event,
		name_ctrlr = events_params.name_ctrlr,
		toolbar = toolbar
	})
	h_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	event:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_on_gui_set_event_data"), event_list_data)
	panel:layout()
end

-- Lines 217-221
function InstanceEventUnitElement:_on_gui_set_event_data(event_list_data)
	local guis = self:_get_guis_by_event_list_data(event_list_data)
	local event = guis.event:get_value()
	event_list_data.event = event
end

-- Lines 223-229
function InstanceEventUnitElement:_get_guis_by_event_list_data(event_list_data)
	for i, entry in pairs(clone(self._hed.event_list)) do
		if entry == event_list_data then
			return self._guis[i]
		end
	end
end

-- Lines 231-253
function InstanceEventUnitElement:remove_entry(event_list_data)
	-- Lines 232-244
	local function _remove_guis(guis)
		if guis then
			guis.instance_name_ctrlr:destroy()
			guis.event:destroy()

			if guis.name_ctrlr then
				guis.name_ctrlr:destroy()
			end

			guis.toolbar:destroy()
			table.delete(self._guis, guis)
			self._panel:layout()
		end
	end

	for i, entry in pairs(clone(self._hed.event_list)) do
		if entry == event_list_data then
			table.remove(self._hed.event_list, i)
			_remove_guis(self._guis[i])

			break
		end
	end
end

-- Lines 255-257
function InstanceEventUnitElement:destroy_panel(...)
	InstanceEventUnitElement.super.destroy_panel(self, ...)
end

-- Lines 259-270
function InstanceEventUnitElement:_on_gui_select_instance_list()
	local settings = {
		list_style = "LC_REPORT,LC_NO_HEADER,LC_SORT_ASCENDING"
	}
	local names = managers.world_instance:instance_names_by_script(self._unit:mission_element_data().script)
	local dialog = SelectNameModal:new("Select instances", names, settings)

	if dialog:cancelled() then
		return
	end

	for _, instance_name in ipairs(dialog:_selected_item_assets()) do
		self:_add_instance_by_name(instance_name)
	end
end

-- Lines 272-291
function InstanceEventUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local btn_toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	btn_toolbar:add_tool("SELECT_UNIT_LIST", "Select unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	btn_toolbar:connect("SELECT_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_gui_select_instance_list"), nil)
	btn_toolbar:realize()
	panel_sizer:add(btn_toolbar, 0, 1, "EXPAND,LEFT")

	for _, data in pairs(clone(self._hed.event_list)) do
		local events = self:_get_events(data.instance)

		self:_add_instance_gui(data.instance, events, data)
	end
end

-- Lines 293-295
function InstanceEventUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "_set_instance_by_raycast"))
end

CoreInstanceInputEventUnitElement = CoreInstanceInputEventUnitElement or class(InstanceEventUnitElement)
InstanceInputEventUnitElement = InstanceInputEventUnitElement or class(CoreInstanceInputEventUnitElement)

-- Lines 303-305
function InstanceInputEventUnitElement:init(...)
	InstanceInputEventUnitElement.super.init(self, "input", ...)
end

CoreInstanceOutputEventUnitElement = CoreInstanceOutputEventUnitElement or class(InstanceEventUnitElement)
InstanceOutputEventUnitElement = InstanceOutputEventUnitElement or class(CoreInstanceOutputEventUnitElement)

-- Lines 313-315
function InstanceOutputEventUnitElement:init(...)
	InstanceOutputEventUnitElement.super.init(self, "output", ...)
end

CoreInstancePointUnitElement = CoreInstancePointUnitElement or class(MissionElement)
InstancePointUnitElement = InstancePointUnitElement or class(CoreInstancePointUnitElement)

-- Lines 323-329
function InstancePointUnitElement:init(...)
	InstancePointUnitElement.super.init(self, ...)

	self._hed.instance = nil

	table.insert(self._save_values, "instance")
end

-- Lines 331-335
function InstancePointUnitElement:update_selected(t, dt)
	if self._hed.instance then
		InstanceEventUnitElement._draw_instance_link(self, t, dt, self._hed.instance)
	end
end

-- Lines 337-342
function InstancePointUnitElement:update_editing(t, dt)
	local instance_name = self:_instance_name_raycast()

	if instance_name then
		InstanceEventUnitElement._draw_instance_link(self, t, dt, instance_name)
	end
end

-- Lines 344-357
function InstancePointUnitElement:selected()
	InstanceEventUnitElement.super.selected(self)

	local names = self:_get_options()

	if self._instance_params then
		CoreEws.update_combobox_options(self._instance_params, names)
	end

	if not table.contains(names, self._hed.instance) then
		self._hed.instance = nil
	end

	if self._instance_params then
		CoreEws.change_combobox_value(self._instance_params, self._hed.instance)
	end
end

-- Lines 359-361
function InstancePointUnitElement:external_change_instance(instance)
	self._hed.instance = instance
end

-- Lines 363-369
function InstancePointUnitElement:_set_instance_by_raycast()
	local instance_name = self:_instance_name_raycast()

	if instance_name then
		self._hed.instance = instance_name

		CoreEws.change_combobox_value(self._instance_params, instance_name)
	end
end

-- Lines 371-382
function InstancePointUnitElement:_instance_name_raycast()
	local ray = managers.editor:unit_by_raycast({
		ray_type = "body editor",
		skip_instance_check = true,
		mask = 1
	})

	if not ray or not ray.unit then
		return nil
	end

	local instance_name = ray.unit:unit_data().instance

	if not instance_name then
		return nil
	end

	local instance_data = managers.world_instance:get_instance_data_by_name(instance_name)

	return instance_data.mission_placed and instance_data.script == self._unit:mission_element_data().script and instance_name or nil
end

-- Lines 384-393
function InstancePointUnitElement:_get_options()
	local _names = managers.world_instance:instance_names_by_script(self._unit:mission_element_data().script)
	local names = {}

	for _, name in ipairs(_names) do
		if managers.world_instance:get_instance_data_by_name(name).mission_placed then
			table.insert(names, name)
		end
	end

	return names
end

-- Lines 395-403
function InstancePointUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local instance_ctrlr, instance_params = self:_build_value_combobox(panel, panel_sizer, "instance", self:_get_options())
	self._instance_params = instance_params
end

-- Lines 405-407
function InstancePointUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "_set_instance_by_raycast"))
end

CoreInstanceParamsUnitElement = CoreInstanceParamsUnitElement or class(MissionElement)
CoreInstanceParamsUnitElement.TYPES = {
	"number",
	"enemy",
	"objective",
	"civilian",
	"enemy_spawn_action",
	"civilian_spawn_state",
	"special_objective_action"
}
InstanceParamsUnitElement = InstanceParamsUnitElement or class(CoreInstanceParamsUnitElement)

-- Lines 416-422
function InstanceParamsUnitElement:init(...)
	InstanceParamsUnitElement.super.init(self, ...)

	self._hed.params = {}

	table.insert(self._save_values, "params")
end

-- Lines 424-465
function InstanceParamsUnitElement:_add_var_dialog()
	local var_name = EWS:get_text_from_user(Global.frame_panel, "Enter variable name:", "Add variable", "var_", Vector3(-1, -1, 0), true)

	if not var_name or var_name == "" then
		return
	end

	for _, data in ipairs(self._hed.params) do
		if data.var_name == var_name then
			self:_add_var_dialog()

			return
		end
	end

	local dialog = EWS:SingleChoiceDialog(self._panel, "Type", "", CoreInstanceParamsUnitElement.TYPES, "OK,CANCEL")
	local result = dialog:show_modal()
	local type = dialog:get_string_selection()

	if type == "" then
		return
	end

	local default_value = nil

	if type == "number" then
		default_value = 0
	elseif type == "enemy" then
		default_value = SpawnEnemyUnitElement._options[1]
	elseif type == "civilian" then
		default_value = SpawnCivilianUnitElement._options[1]
	elseif type == "objective" then
		default_value = managers.objectives:objectives_by_name()[1]
	elseif type == "enemy_spawn_action" then
		default_value = clone(CopActionAct._act_redirects.enemy_spawn)[1]
	elseif type == "civilian_spawn_state" then
		default_value = CopActionAct._act_redirects.civilian_spawn[1]
	elseif type == "special_objective_action" then
		default_value = CopActionAct._act_redirects.SO[1]
	end

	local data = {
		var_name = var_name,
		type = type,
		default_value = default_value
	}

	table.insert(self._hed.params, data)
	self:_build_var_panel(data)
end

-- Lines 467-469
function InstanceParamsUnitElement:_add_var(var_name, type, default_value)
end

-- Lines 471-484
function InstanceParamsUnitElement:_remove_var_name(var_name)
	for i, data in ipairs(self._hed.params) do
		if data.var_name == var_name then
			table.remove(self._hed.params, i)

			if self._panels[i] then
				local rem_data = table.remove(self._panels, i)

				rem_data.panel:destroy_children()
				rem_data.panel:destroy()
			end

			self._panel:layout()

			return
		end
	end
end

-- Lines 486-520
function InstanceParamsUnitElement:_build_var_panel(data)
	self._panels = self._panels or {}
	local panel = EWS:Panel(self._panel, "", "TAB_TRAVERSAL")
	local sizer = EWS:BoxSizer("HORIZONTAL")

	panel:set_sizer(sizer)

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("REMOVE", "Remove", CoreEws.image_path("toolbar\\delete_16x16.png"), nil)
	toolbar:connect("REMOVE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_remove_var_name"), data.var_name)
	toolbar:realize()
	sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	self._panel_sizer:add(panel, 0, 0, "EXPAND")

	if data.type == "number" then
		self:_build_number(data, panel, sizer)
	elseif data.type == "enemy" then
		self:_build_combobox(data, panel, sizer, SpawnEnemyUnitElement._options)
	elseif data.type == "civilian" then
		self:_build_combobox(data, panel, sizer, SpawnCivilianUnitElement._options)
	elseif data.type == "objective" then
		self:_build_combobox(data, panel, sizer, managers.objectives:objectives_by_name())
	elseif data.type == "enemy_spawn_action" then
		self:_build_combobox(data, panel, sizer, clone(CopActionAct._act_redirects.enemy_spawn))
	elseif data.type == "civilian_spawn_state" then
		self:_build_combobox(data, panel, sizer, CopActionAct._act_redirects.civilian_spawn)
	elseif data.type == "special_objective_action" then
		self:_build_combobox(data, panel, sizer, CopActionAct._act_redirects.SO)
	end

	table.insert(self._panels, {
		var_name = data.var_name,
		panel = panel
	})
	self._panel:layout()
end

-- Lines 522-540
function InstanceParamsUnitElement:_build_number(data, panel, sizer)
	local number_params = {
		name_proportions = 1,
		tooltip = "Set a default number variable.",
		floats = 0,
		sizer_proportions = 1,
		ctrlr_proportions = 2,
		name = data.var_name,
		panel = panel,
		sizer = sizer,
		value = data.default_value
	}
	local number = CoreEws.number_controller(number_params)

	number:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_default_var_name"), {
		ctrlr = number,
		data = data
	})
	number:connect("EVT_KILL_FOCUS", callback(self, self, "_set_default_var_name"), {
		ctrlr = number,
		data = data
	})
end

-- Lines 542-567
function InstanceParamsUnitElement:_build_combobox(data, panel, sizer, options)
	local horizontal_sizer = EWS:BoxSizer("HORIZONTAL")

	sizer:add(horizontal_sizer, 1, 1, "EXPAND,LEFT")

	local params = {
		sizer_proportions = 1,
		name_proportions = 1,
		tooltip = "Select an option from the combobox",
		sorted = true,
		ctrlr_proportions = 2,
		name = data.var_name,
		panel = panel,
		sizer = horizontal_sizer,
		options = options,
		value = data.default_value
	}
	local combobox = CoreEws.combobox(params)

	combobox:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_default_var_name"), {
		ctrlr = combobox,
		data = data
	})

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Set from list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_gui_select_name_dialog"), {
		combobox = params,
		data = data
	})
	toolbar:realize()
	horizontal_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
end

-- Lines 569-572
function InstanceParamsUnitElement:_set_default_var_name(data)
	local value = data.ctrlr:get_value()
	data.data.default_value = tonumber(value) or value
end

-- Lines 574-583
function InstanceParamsUnitElement:_on_gui_select_name_dialog(params)
	local dialog = SelectNameModal:new("Select name", params.combobox.options)

	if dialog:cancelled() then
		return
	end

	for _, name in ipairs(dialog:_selected_item_assets()) do
		CoreEws.change_combobox_value(params.combobox, name)
		self:_set_default_var_name({
			ctrlr = params.combobox.ctrlr,
			data = params.data
		})
	end
end

-- Lines 585-600
function InstanceParamsUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD", "Add variable", CoreEws.image_path("world_editor\\add_unit.png"), nil)
	toolbar:connect("ADD", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_add_var_dialog"), nil)
	toolbar:realize()
	panel_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")

	for _, data in ipairs(self._hed.params) do
		self:_build_var_panel(data)
	end
end

CoreInstanceSetParamsUnitElement = CoreInstanceSetParamsUnitElement or class(MissionElement)
InstanceSetParamsUnitElement = InstanceSetParamsUnitElement or class(CoreInstanceSetParamsUnitElement)

-- Lines 617-630
function InstanceSetParamsUnitElement:init(...)
	InstanceSetParamsUnitElement.super.init(self, ...)

	self._panels = {}
	self._hed.instance = nil
	self._hed.params = {}
	self._hed.apply_on_execute = nil

	table.insert(self._save_values, "instance")
	table.insert(self._save_values, "params")
	table.insert(self._save_values, "apply_on_execute")
end

-- Lines 632-636
function InstanceSetParamsUnitElement:update_selected(t, dt)
	if self._hed.instance then
		InstanceEventUnitElement._draw_instance_link(self, t, dt, self._hed.instance)
	end
end

-- Lines 638-643
function InstanceSetParamsUnitElement:update_editing(t, dt)
	local instance_name = self:_instance_name_raycast()

	if instance_name then
		InstanceEventUnitElement._draw_instance_link(self, t, dt, instance_name)
	end
end

-- Lines 645-658
function InstanceSetParamsUnitElement:selected()
	InstanceEventUnitElement.super.selected(self)

	local names = self:_get_options()

	if self._instance_params then
		CoreEws.update_combobox_options(self._instance_params, names)
	end

	if not table.contains(names, self._hed.instance) then
		self._hed.instance = nil
	end

	if self._instance_params then
		CoreEws.change_combobox_value(self._instance_params, self._hed.instance)
	end
end

-- Lines 661-668
function InstanceSetParamsUnitElement:on_instance_changed_name(old_name, new_name)
	if old_name == self._hed.instance then
		self._hed.instance = new_name

		if self._instance_params then
			CoreEws.change_combobox_value(self._instance_params, self._hed.instance)
		end
	end
end

-- Lines 671-680
function InstanceSetParamsUnitElement:on_instance_deleted(name)
	if name == self._hed.instance then
		self._hed.instance = nil
		self._hed.params = {}

		self:_destroy_params_panels()

		if self._instance_params then
			CoreEws.change_combobox_value(self._instance_params, self._hed.instance)
		end
	end
end

-- Lines 682-693
function InstanceSetParamsUnitElement:_instance_name_raycast()
	local ray = managers.editor:unit_by_raycast({
		ray_type = "body editor",
		skip_instance_check = true,
		mask = 1
	})

	if not ray or not ray.unit then
		return nil
	end

	local instance_name = ray.unit:unit_data().instance

	if not instance_name then
		return nil
	end

	local instance_data = managers.world_instance:get_instance_data_by_name(instance_name)

	return instance_data.script == self._unit:mission_element_data().script and instance_name or nil
end

-- Lines 695-702
function InstanceSetParamsUnitElement:_set_instance_by_raycast()
	local instance_name = self:_instance_name_raycast()

	if instance_name then
		self:_check_change_instance(instance_name)
		CoreEws.change_combobox_value(self._instance_params, self._hed.instance)
		self:_on_instance_changed()
	end
end

-- Lines 704-712
function InstanceSetParamsUnitElement:_get_options()
	local _names = managers.world_instance:instance_names_by_script(self._unit:mission_element_data().script)
	local names = {}

	for _, name in ipairs(_names) do
		table.insert(names, name)
	end

	table.sort(names)

	return names
end

-- Lines 714-716
function InstanceSetParamsUnitElement:_on_gui_change_instance(params)
	self:_check_change_instance(params.ctrlr:get_value())
end

-- Lines 718-744
function InstanceSetParamsUnitElement:_check_change_instance(new_instance)
	if not self._hed.instance or not next(self._hed.params) then
		self._hed.instance = new_instance

		return
	end

	local new_folder = managers.world_instance:get_instance_data_by_name(new_instance).folder
	local folder = managers.world_instance:get_instance_data_by_name(self._hed.instance).folder

	if new_folder == folder then
		self._hed.instance = new_instance

		return
	end

	local msg = "Changing instance from " .. self._hed.instance .. " to " .. new_instance .. " will reset variables. Continue?"
	local confirm = EWS:message_box(Global.frame_panel, msg, "func_instance_set_params", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))

	if confirm == "NO" then
		CoreEws.change_combobox_value(self._instance_params, self._hed.instance)

		return
	end

	self._hed.params = {}
	self._hed.instance = new_instance
end

-- Lines 746-751
function InstanceSetParamsUnitElement:_on_instance_changed()
	if self._hed.instance then
		local params = managers.world_instance:get_instance_params_by_name(self._hed.instance)

		self:_build_from_params(params)
	end
end

-- Lines 753-757
function InstanceSetParamsUnitElement:_set_var_name(data)
	local value = data.ctrlr:get_value()
	value = tonumber(value) or value
	self._hed.params[data.var_name] = value
end

-- Lines 759-765
function InstanceSetParamsUnitElement:_destroy_params_panels()
	for _, panel in ipairs(self._panels) do
		panel:destroy_children()
		panel:destroy()
	end

	self._panels = {}
end

-- Lines 767-814
function InstanceSetParamsUnitElement:_build_from_params(params)
	self._panel:freeze()
	self:_destroy_params_panels()

	for _, data in ipairs(params) do
		local panel = EWS:Panel(self._panel, "", "TAB_TRAVERSAL")
		local sizer = EWS:BoxSizer("HORIZONTAL")

		panel:set_sizer(sizer)
		self._panel_sizer:add(panel, 0, 0, "EXPAND")

		local use = EWS:CheckBox(panel, "", "")

		use:set_tool_tip("Toggle use of variable on/off")
		use:set_value(self._hed.params[data.var_name] and true or false)
		sizer:add(use, 0, 4, "EXPAND,RIGHT")

		local value_panel = EWS:Panel(panel, "", "TAB_TRAVERSAL")
		local value_sizer = EWS:BoxSizer("HORIZONTAL")

		value_panel:set_sizer(value_sizer)
		sizer:add(value_panel, 1, 0, "EXPAND")

		local value_ctrlr = nil

		if data.type == "number" then
			value_ctrlr = self:_build_number(data, value_panel, value_sizer)
		elseif data.type == "enemy" then
			value_ctrlr = self:_build_combobox(data, value_panel, value_sizer, SpawnEnemyUnitElement._options)
		elseif data.type == "civilian" then
			value_ctrlr = self:_build_combobox(data, value_panel, value_sizer, SpawnCivilianUnitElement._options)
		elseif data.type == "objective" then
			value_ctrlr = self:_build_combobox(data, value_panel, value_sizer, managers.objectives:objectives_by_name())
		elseif data.type == "enemy_spawn_action" then
			value_ctrlr = self:_build_combobox(data, value_panel, value_sizer, clone(CopActionAct._act_redirects.enemy_spawn))
		elseif data.type == "civilian_spawn_state" then
			value_ctrlr = self:_build_combobox(data, value_panel, value_sizer, CopActionAct._act_redirects.civilian_spawn)
		elseif data.type == "special_objective_action" then
			value_ctrlr = self:_build_combobox(data, value_panel, value_sizer, CopActionAct._act_redirects.SO)
		end

		use:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "_on_gui_toggle_use"), {
			ctrlr = use,
			var_name = data.var_name,
			value_panel = value_panel,
			value_ctrlr = value_ctrlr
		})
		value_panel:set_enabled(self._hed.params[data.var_name] and true or false)
		table.insert(self._panels, panel)
	end

	self._panel:layout()
	self._panel:thaw()
end

-- Lines 816-825
function InstanceSetParamsUnitElement:_on_gui_toggle_use(params)
	local use = params.ctrlr:get_value()

	params.value_panel:set_enabled(use)

	local value = params.value_ctrlr

	if use then
		self:_set_var_name({
			ctrlr = params.value_ctrlr,
			var_name = params.var_name
		})
	else
		self._hed.params[params.var_name] = nil
	end
end

-- Lines 827-847
function InstanceSetParamsUnitElement:_build_number(data, panel, sizer)
	local number_params = {
		name_proportions = 1,
		tooltip = "Set a number variable.",
		floats = 0,
		sizer_proportions = 1,
		ctrlr_proportions = 2,
		name = data.var_name,
		panel = panel,
		sizer = sizer,
		value = self._hed.params[data.var_name] or data.default_value
	}
	local number = CoreEws.number_controller(number_params)

	number:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_var_name"), {
		ctrlr = number,
		var_name = data.var_name
	})
	number:connect("EVT_KILL_FOCUS", callback(self, self, "_set_var_name"), {
		ctrlr = number,
		var_name = data.var_name
	})

	return number
end

-- Lines 849-876
function InstanceSetParamsUnitElement:_build_combobox(data, panel, sizer, options)
	local horizontal_sizer = EWS:BoxSizer("HORIZONTAL")

	sizer:add(horizontal_sizer, 1, 1, "EXPAND,LEFT")

	local combobox_params = {
		sizer_proportions = 1,
		name_proportions = 1,
		tooltip = "Select an option from the combobox",
		sorted = true,
		ctrlr_proportions = 2,
		name = data.var_name,
		panel = panel,
		sizer = horizontal_sizer,
		options = options,
		value = self._hed.params[data.var_name] or data.default_value
	}
	local combobox = CoreEws.combobox(combobox_params)

	combobox:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_var_name"), {
		ctrlr = combobox,
		var_name = data.var_name
	})

	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	toolbar:add_tool("ADD_UNIT_LIST", "Set from list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_on_gui_select_name_dialog"), {
		combobox = combobox_params,
		var_name = data.var_name
	})
	toolbar:realize()
	horizontal_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")

	return combobox
end

-- Lines 878-887
function InstanceSetParamsUnitElement:_on_gui_select_name_dialog(params)
	local dialog = SelectNameModal:new("Select name", params.combobox.options)

	if dialog:cancelled() then
		return
	end

	for _, name in ipairs(dialog:_selected_item_assets()) do
		CoreEws.change_combobox_value(params.combobox, name)
		self:_set_var_name({
			ctrlr = params.combobox.ctrlr,
			var_name = params.var_name
		})
	end
end

-- Lines 889-901
function InstanceSetParamsUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local instance_ctrlr, instance_params = self:_build_value_combobox(panel, panel_sizer, "instance", self:_get_options())
	self._instance_params = instance_params

	self:_build_value_checkbox(panel, panel_sizer, "apply_on_execute", "If checked, the values will be applied when the element is executed.")
	self:_on_instance_changed()
end

-- Lines 903-910
function InstanceSetParamsUnitElement:set_element_data(params, ...)
	if params.value == "instance" then
		self:_on_gui_change_instance(params)
		self:_on_instance_changed()

		return
	end

	InstanceSetParamsUnitElement.super.set_element_data(self, params, ...)
end

-- Lines 912-914
function InstanceSetParamsUnitElement:add_triggers(vc)
	vc:add_trigger(Idstring("lmb"), callback(self, self, "_set_instance_by_raycast"))
end
