core:module("CoreMissionManager")
core:import("CoreMissionScriptElement")
core:import("CoreEvent")
core:import("CoreClass")
core:import("CoreDebug")
core:import("CoreCode")
core:import("CoreTable")
require("core/lib/managers/mission/CoreElementDebug")

MissionManager = MissionManager or CoreClass.class(CoreEvent.CallbackHandler)

-- Lines 13-27
function MissionManager:init()
	MissionManager.super.init(self)

	self._runned_unit_sequences_callbacks = {}
	self._scripts = {}
	self._active_scripts = {}
	self._area_instigator_categories = {}

	self:add_area_instigator_categories("none")
	self:set_default_area_instigator("none")

	self._global_event_listener = rawget(_G, "EventListenerHolder"):new()
	self._global_event_list = {}
end

-- Lines 29-44
function MissionManager:post_init()
	self._workspace = managers.gui_data:create_saferect_workspace()

	managers.gui_data:layout_corner_saferect_workspace(self._workspace)
	self._workspace:set_timer(TimerManager:main())

	self._fading_debug_output = self._workspace:panel():gui(Idstring("core/guis/core_fading_debug_output"))

	self._fading_debug_output:set_leftbottom(0, self._workspace:height() / 3)
	self._fading_debug_output:script().configure({
		font_size = 18,
		max_rows = 20
	})

	self._persistent_debug_output = self._workspace:panel():gui(Idstring("core/guis/core_persistent_debug_output"))

	self._persistent_debug_output:set_righttop(self._workspace:width(), 0)
	self:set_persistent_debug_enabled(false)
	self:set_fading_debug_enabled(true)
	managers.viewport:add_resolution_changed_func(callback(self, self, "_resolution_changed"))
end

-- Lines 46-48
function MissionManager:_resolution_changed()
	managers.gui_data:layout_corner_saferect_workspace(self._workspace)
end

-- Lines 51-87
function MissionManager:parse(params, stage_name, offset, file_type)
	local file_path, activate_mission = nil

	if CoreClass.type_name(params) == "table" then
		file_path = params.file_path
		file_type = params.file_type or "mission"
		activate_mission = params.activate_mission
		offset = params.offset
	else
		file_path = params
		file_type = file_type or "mission"
	end

	CoreDebug.cat_debug("gaspode", "MissionManager", file_path, file_type, activate_mission)

	if not DB:has(file_type, file_path) then
		Application:error("Couldn't find", file_path, "(", file_type, ")")

		return false
	end

	local reverse = string.reverse(file_path)
	local i = string.find(reverse, "/")
	local file_dir = string.reverse(string.sub(reverse, i))
	local continent_files = self:_serialize_to_script(file_type, file_path)
	continent_files._meta = nil

	for name, data in pairs(continent_files) do
		if not managers.worlddefinition:continent_excluded(name) then
			self:_load_mission_file(file_dir, data)
		end
	end

	self:_activate_mission(activate_mission)

	return true
end

-- Lines 89-98
function MissionManager:_serialize_to_script(type, name)
	if Application:editor() then
		return PackageManager:editor_load_script_data(type:id(), name:id())
	else
		if not PackageManager:has(type:id(), name:id()) then
			Application:throw_exception("Script data file " .. name .. " of type " .. type .. " has not been loaded. Could be that old mission format is being loaded. Try resaving the level.")
		end

		return PackageManager:script_data(type:id(), name:id())
	end
end

-- Lines 101-109
function MissionManager:_load_mission_file(file_dir, data)
	local file_path = file_dir .. data.file
	local scripts = self:_serialize_to_script("mission", file_path)
	scripts._meta = nil

	for name, data in pairs(scripts) do
		data.name = name

		self:_add_script(data)
	end
end

-- Lines 112-114
function MissionManager:_add_script(data)
	self._scripts[data.name] = MissionScript:new(data)
end

-- Lines 117-119
function MissionManager:scripts()
	return self._scripts
end

-- Lines 122-124
function MissionManager:script(name)
	return self._scripts[name]
end

-- Lines 126-141
function MissionManager:_activate_mission(name)
	CoreDebug.cat_debug("gaspode", "MissionManager:_activate_mission", name)

	if name then
		if self:script(name) then
			self:activate_script(name)
		else
			Application:throw_exception("There was no mission named " .. name .. " availible to activate!")
		end
	else
		for _, script in pairs(self._scripts) do
			if script:activate_on_parsed() then
				self:activate_script(script:name())
			end
		end
	end
end

-- Lines 144-155
function MissionManager:activate_script(name, ...)
	CoreDebug.cat_debug("gaspode", "MissionManager:activate_script", name)

	if not self._scripts[name] then
		if Global.running_simulation then
			managers.editor:output_error("Can't activate mission script " .. name .. ". It doesn't exist.")

			return
		else
			Application:throw_exception("Can't activate mission script " .. name .. ". It doesn't exist.")
		end
	end

	self._scripts[name]:activate(...)
end

-- Lines 158-162
function MissionManager:update(t, dt)
	for _, script in pairs(self._scripts) do
		script:update(t, dt)
	end
end

-- Lines 165-175
function MissionManager:stop_simulation(...)
	self:pre_destroy()

	for _, script in pairs(self._scripts) do
		script:stop_simulation(...)
	end

	self._scripts = {}
	self._runned_unit_sequences_callbacks = {}
	self._global_event_listener = rawget(_G, "EventListenerHolder"):new()
end

-- Lines 178-180
function MissionManager:on_simulation_started()
	self._pre_destroyed = nil
end

-- Lines 183-195
function MissionManager:add_runned_unit_sequence_trigger(id, sequence, callback)
	if self._runned_unit_sequences_callbacks[id] then
		if self._runned_unit_sequences_callbacks[id][sequence] then
			table.insert(self._runned_unit_sequences_callbacks[id][sequence], callback)
		else
			self._runned_unit_sequences_callbacks[id][sequence] = {
				callback
			}
		end
	else
		local t = {
			[sequence] = {
				callback
			}
		}
		self._runned_unit_sequences_callbacks[id] = t
	end
end

-- Lines 198-217
function MissionManager:runned_unit_sequence(unit, sequence, params)
	if self._pre_destroyed then
		return
	end

	if alive(unit) and unit:unit_data() then
		local id = unit:unit_data().unit_id
		id = id ~= 0 and id or unit:editor_id()

		if self._runned_unit_sequences_callbacks[id] and self._runned_unit_sequences_callbacks[id][sequence] then
			for _, call in ipairs(self._runned_unit_sequences_callbacks[id][sequence]) do
				call(params and params.unit)
			end
		end
	end
end

-- Lines 219-221
function MissionManager:add_area_instigator_categories(category)
	table.insert(self._area_instigator_categories, category)
end

-- Lines 224-226
function MissionManager:area_instigator_categories()
	return self._area_instigator_categories
end

-- Lines 229-231
function MissionManager:set_default_area_instigator(default)
	self._default_area_instigator = default
end

-- Lines 234-236
function MissionManager:default_area_instigator()
	return self._default_area_instigator
end

-- Lines 240-242
function MissionManager:default_instigator()
	return nil
end

-- Lines 245-247
function MissionManager:persistent_debug_enabled()
	return self._persistent_debug_enabled
end

-- Lines 250-257
function MissionManager:set_persistent_debug_enabled(enabled)
	self._persistent_debug_enabled = enabled

	if enabled then
		self._persistent_debug_output:show()
	else
		self._persistent_debug_output:hide()
	end
end

-- Lines 260-265
function MissionManager:add_persistent_debug_output(debug, color)
	if not self._persistent_debug_enabled then
		return
	end

	self._persistent_debug_output:script().log(debug, color)
end

-- Lines 268-275
function MissionManager:set_fading_debug_enabled(enabled)
	self._fading_debug_enabled = enabled

	if enabled then
		self._fading_debug_output:show()
	else
		self._fading_debug_output:hide()
	end
end

-- Lines 278-294
function MissionManager:add_fading_debug_output(debug, color, as_subtitle)
	if not Application:production_build() then
		return
	end

	if not self._fading_debug_enabled then
		return
	end

	if as_subtitle then
		self:_show_debug_subtitle(debug, color)
	else
		local stuff = {
			" -",
			" \\",
			" |",
			" /"
		}
		self._fade_index = (self._fade_index or 0) + 1
		self._fade_index = self._fade_index > #stuff and self._fade_index and 1 or self._fade_index

		self._fading_debug_output:script().log(stuff[self._fade_index] .. " " .. debug, color, nil)
	end
end

-- Lines 296-310
function MissionManager:_show_debug_subtitle(debug, color)
	self._debug_subtitle_text = self._debug_subtitle_text or self._workspace:panel():text({
		font_size = 20,
		wrap = true,
		word_wrap = true,
		align = "center",
		font = "core/fonts/diesel",
		halign = "center",
		valign = "center",
		text = debug,
		color = color or Color.white
	})

	self._debug_subtitle_text:set_w(self._workspace:panel():w() / 2)
	self._debug_subtitle_text:set_text(debug)

	local subtitle_time = math.max(4, utf8.len(debug) * 0.04)
	local _, _, w, h = self._debug_subtitle_text:text_rect()

	self._debug_subtitle_text:set_h(h)
	self._debug_subtitle_text:set_center_x(self._workspace:panel():w() / 2)
	self._debug_subtitle_text:set_top(self._workspace:panel():h() / 1.4)
	self._debug_subtitle_text:set_color(color or Color.white)
	self._debug_subtitle_text:set_alpha(1)
	self._debug_subtitle_text:stop()
	self._debug_subtitle_text:animate(function (o)
		_G.wait(subtitle_time)
		self._debug_subtitle_text:set_alpha(0)
	end)
end

-- Lines 312-318
function MissionManager:get_element_by_id(id)
	for name, script in pairs(self._scripts) do
		if script:element(id) then
			return script:element(id)
		end
	end
end

-- Lines 323-325
function MissionManager:add_global_event_listener(key, events, clbk)
	self._global_event_listener:add(key, events, clbk)
end

-- Lines 328-330
function MissionManager:remove_global_event_listener(key)
	self._global_event_listener:remove(key)
end

-- Lines 333-335
function MissionManager:call_global_event(event, ...)
	self._global_event_listener:call(event, ...)
end

-- Lines 338-340
function MissionManager:set_global_event_list(list)
	self._global_event_list = list
end

-- Lines 343-345
function MissionManager:get_global_event_list()
	return self._global_event_list
end

-- Lines 349-355
function MissionManager:save(data)
	local state = {}

	for _, script in pairs(self._scripts) do
		script:save(state)
	end

	data.MissionManager = state
end

-- Lines 357-362
function MissionManager:load(data)
	local state = data.MissionManager

	for _, script in pairs(self._scripts) do
		script:load(state)
	end
end

-- Lines 364-369
function MissionManager:pre_destroy()
	self._pre_destroyed = true

	for _, script in pairs(self._scripts) do
		script:pre_destroy()
	end
end

-- Lines 371-375
function MissionManager:destroy()
	for _, script in pairs(self._scripts) do
		script:destroy()
	end
end

MissionScript = MissionScript or CoreClass.class(CoreEvent.CallbackHandler)
MissionScript.imported_modules = MissionScript.imported_modules or {}

for module_name, _ in pairs(MissionScript.imported_modules) do
	MissionScript.import(module_name)
end

-- Lines 386-390
function MissionScript.import(module_name)
	MissionScript.imported_modules[module_name] = true
	local module = core:import(module_name)

	return module
end

-- Lines 392-425
function MissionScript:init(data)
	MissionScript.super.init(self)

	self._elements = {}
	self._element_groups = {}
	self._name = data.name
	self._activate_on_parsed = data.activate_on_parsed

	CoreDebug.cat_debug("gaspode", "New MissionScript:", self._name)
	self:_create_elements(data.elements)

	if data.instances then
		for _, instance_name in ipairs(data.instances) do
			local instance_data = managers.world_instance:get_instance_data_by_name(instance_name)
			local prepare_mission_data = managers.world_instance:prepare_mission_data_by_name(instance_name)

			if instance_data and prepare_mission_data then
				if not instance_data.mission_placed then
					self:create_instance_elements(prepare_mission_data)
				else
					self:_preload_instance_class_elements(prepare_mission_data)
				end
			end
		end
	end

	self._updators = {}
	self._save_states = {}

	self:_on_created(self._elements)
end

-- Lines 427-434
function MissionScript:external_create_instance_elements(prepare_mission_data)
	local new_elements = self:create_instance_elements(prepare_mission_data)

	self:_on_created(new_elements)

	if self._active then
		self:_on_script_activated(new_elements)
	end
end

-- Lines 436-443
function MissionScript:create_instance_elements(prepare_mission_data)
	local new_elements = {}

	for _, instance_mission_data in pairs(prepare_mission_data) do
		new_elements = self:_create_elements(instance_mission_data.elements)
	end

	return new_elements
end

-- Lines 445-451
function MissionScript:_preload_instance_class_elements(prepare_mission_data)
	for _, instance_mission_data in pairs(prepare_mission_data) do
		for _, element in ipairs(instance_mission_data.elements) do
			self:_element_class(element.module, element.class)
		end
	end
end

-- Lines 453-470
function MissionScript:_create_elements(elements)
	local new_elements = {}

	for _, element in ipairs(elements) do
		local class = element.class
		local new_element = self:_element_class(element.module, class):new(self, element)
		self._elements[element.id] = new_element
		new_elements[element.id] = new_element
		self._element_groups[class] = self._element_groups[class] or {}

		table.insert(self._element_groups[class], new_element)
	end

	return new_elements
end

-- Lines 473-475
function MissionScript:activate_on_parsed()
	return self._activate_on_parsed
end

-- Lines 479-483
function MissionScript:_on_created(elements)
	for _, element in pairs(elements) do
		element:on_created()
	end
end

-- Lines 488-500
function MissionScript:_element_class(module_name, class_name)
	local element_class = rawget(_G, class_name)

	if not element_class and module_name and module_name ~= "none" then
		local raw_module = rawget(_G, "CoreMissionManager")[module_name]
		element_class = raw_module and raw_module[class_name] or MissionScript.import(module_name)[class_name]
	end

	if not element_class then
		element_class = CoreMissionScriptElement.MissionScriptElement

		Application:error("[MissionScript]SCRIPT ERROR: Didn't find class", class_name, module_name)
	end

	return element_class
end

-- Lines 502-508
function MissionScript:activate(...)
	self._active = true

	managers.mission:add_persistent_debug_output("")
	managers.mission:add_persistent_debug_output("Activate mission " .. self._name, Color(1, 0, 1, 0))
	self:_on_script_activated(CoreTable.clone(self._elements), ...)
end

-- Lines 510-519
function MissionScript:_on_script_activated(elements, ...)
	for _, element in pairs(elements) do
		element:on_script_activated()
	end

	for _, element in pairs(elements) do
		if element:value("execute_on_startup") then
			element:on_executed(...)
		end
	end
end

-- Lines 521-523
function MissionScript:add_updator(id, updator)
	self._updators[id] = updator
end

-- Lines 525-527
function MissionScript:remove_updator(id)
	self._updators[id] = nil
end

-- Lines 530-537
function MissionScript:update(t, dt)
	MissionScript.super.update(self, dt)

	for _, updator in pairs(self._updators) do
		updator(t, dt)
	end
end

-- Lines 540-569
function MissionScript:_debug_draw(t, dt)
	local brush = Draw:brush(Color.red)
	local name_brush = Draw:brush(Color.red)

	name_brush:set_font(Idstring("fonts/font_medium"), 16)
	name_brush:set_render_template(Idstring("OverlayVertexColorTextured"))

	for _, element in pairs(self._elements) do
		brush:set_color(element:enabled() and Color.green or Color.red)
		name_brush:set_color(element:enabled() and Color.green or Color.red)

		if element:value("position") then
			brush:sphere(element:value("position"), 5)

			if managers.viewport:get_current_camera() then
				local cam_up = managers.viewport:get_current_camera():rotation():z()
				local cam_right = managers.viewport:get_current_camera():rotation():x()

				name_brush:center_text(element:value("position") + Vector3(0, 0, 30), utf8.from_latin1(element:editor_name()), cam_right, -cam_up)
			end
		end

		if element:value("rotation") then
			local rotation = CoreClass.type_name(element:value("rotation")) == "Rotation" and element:value("rotation") or Rotation(element:value("rotation"), 0, 0)

			brush:cylinder(element:value("position"), element:value("position") + rotation:y() * 50, 2)
			brush:cylinder(element:value("position"), element:value("position") + rotation:z() * 25, 1)
		end

		element:debug_draw(t, dt)
	end
end

-- Lines 572-574
function MissionScript:name()
	return self._name
end

-- Lines 577-579
function MissionScript:element_groups()
	return self._element_groups
end

-- Lines 582-584
function MissionScript:element_group(name)
	return self._element_groups[name]
end

-- Lines 587-589
function MissionScript:elements()
	return self._elements
end

-- Lines 592-594
function MissionScript:element(id)
	return self._elements[id]
end

-- Lines 597-600
function MissionScript:debug_output(debug, color)
	managers.mission:add_persistent_debug_output(Application:date("%X") .. ": " .. debug, color)
	CoreDebug.cat_print("editor", debug)
end

-- Lines 603-605
function MissionScript:is_debug()
	return true
end

-- Lines 608-610
function MissionScript:add_save_state_cb(id)
	self._save_states[id] = true
end

-- Lines 613-615
function MissionScript:remove_save_state_cb(id)
	self._save_states[id] = nil
end

-- Lines 618-642
function MissionScript:save(data)
	local state = {}

	for id, _ in pairs(self._save_states) do
		state[id] = {}

		self._elements[id]:save(state[id])
	end

	data[self._name] = state
end

-- Lines 645-676
function MissionScript:load(data)
	local state = data[self._name]

	if self._element_groups.ElementInstancePoint then
		for _, element in ipairs(self._element_groups.ElementInstancePoint) do
			if state[element:id()] then
				self._elements[element:id()]:load(state[element:id()])

				state[element:id()] = nil
			end
		end
	end

	for id, mission_state in pairs(state) do
		self._elements[id]:load(mission_state)
	end
end

-- Lines 679-684
function MissionScript:stop_simulation(...)
	for _, element in pairs(self._elements) do
		element:stop_simulation(...)
	end

	MissionScript.super.clear(self)
end

-- Lines 687-692
function MissionScript:pre_destroy(...)
	for _, element in pairs(self._elements) do
		element:pre_destroy(...)
	end

	MissionScript.super.clear(self)
end

-- Lines 695-700
function MissionScript:destroy(...)
	for _, element in pairs(self._elements) do
		element:destroy(...)
	end

	MissionScript.super.clear(self)
end
