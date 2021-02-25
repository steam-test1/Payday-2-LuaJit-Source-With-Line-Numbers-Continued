core:import("CoreClass")
core:import("CoreEvent")
core:import("CoreEws")
core:import("CoreColorPickerPanel")

TemplateMixerDummy = TemplateMixerDummy or class()

-- Lines 8-29
function TemplateMixerDummy:init(editor, ...)
	self._editor = editor
	self._args = {
		...
	}

	if #self._args == 1 then
		self._param = self._args[1]
		self._type = "sky"
	elseif #self._args == 2 then
		self._mat = self._args[1]
		self._param = self._args[2]
		self._type = "underlay"
	elseif #self._args == 3 then
		self._pro = self._args[1]
		self._mod = self._args[2]
		self._param = self._args[3]
		self._type = "posteffect"
	else
		error("[TemplateMixerDummy] Bad number of arguments!")
	end

	self._editor:reg_mixer(self)
end

-- Lines 31-33
function TemplateMixerDummy:get_value()
	return self._val
end

-- Lines 35-37
function TemplateMixerDummy:set_value(v)
	self._val = v
end

-- Lines 39-68
function TemplateMixerDummy:update_mix(env1, env2, blend)
	local p1, p2 = nil

	if self._type == "posteffect" then
		p1 = self._editor:retrive_posteffect_param(self._editor._template_effects[env1], self._pro, self._mod, self._param)
		p2 = self._editor:retrive_posteffect_param(self._editor._template_effects[env2], self._pro, self._mod, self._param)
	elseif self._type == "underlay" then
		p1 = self._editor:retrive_underlay_param(self._editor._template_underlays[env1], self._mat, self._param)
		p2 = self._editor:retrive_underlay_param(self._editor._template_underlays[env2], self._mat, self._param)
	else
		p1 = self._editor:retrive_sky_param(self._editor._template_skies[env1], self._param)
		p2 = self._editor:retrive_sky_param(self._editor._template_skies[env2], self._param)
	end

	if p1 and p2 then
		local p1type = type(p1)
		local p2type = type(p2)

		if p1type == p2type then
			if p1type == "string" then
				if blend < 0.5 then
					self._val = p1
				else
					self._val = p2
				end
			else
				self._val = math.lerp(p1, p2, blend)
			end
		end
	end
end

-- Lines 70-74
function TemplateMixerDummy:args()
	local v = {
		unpack(self._args)
	}

	table.insert(v, self)

	return unpack(v)
end

FormulaMixerDummy = FormulaMixerDummy or class()
FormulaMixerDummy.STD_TOL = 0.01

-- Lines 82-91
function FormulaMixerDummy:init(editor, master, tol, formula, ...)
	self._editor = editor
	self._master = master
	self._formula = formula
	self._tol = tol
	self._params = {
		...
	}
	self._value = formula(master:get_value(), unpack(self._params))

	self._editor:add_updator(self)
end

-- Lines 93-95
function FormulaMixerDummy:get_value()
	return self._value
end

-- Lines 97-99
function FormulaMixerDummy:set_value(v)
	self._value = v
end

-- Lines 101-111
function FormulaMixerDummy:update(t, dt)
	local value = self._formula(self._master:get_value(), unpack(self._params))
	local t = type(value)

	if t == "string" and value ~= self._value or t == "number" and self._tol < math.abs(value - self._value) or t == "userdata" and self._tol < (value - self._value):length() then
		self._value = value
	end
end

DummyWidget = DummyWidget or class()

-- Lines 117-119
function DummyWidget:init(t)
	self._val = t
end

-- Lines 121-123
function DummyWidget:get_value()
	return self._val
end

-- Lines 125-127
function DummyWidget:set_value(v)
	self._val = v
end

Vector2Slider = Vector2Slider or class()

-- Lines 133-204
function Vector2Slider:init(editor, p, name, picker_bottom, picker_top, min, max, scale, display_scale)
	self._scale = scale
	self._editor = editor

	if display_scale then
		self._display_scale = display_scale
	else
		self._display_scale = 1
	end

	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._top_button_box = EWS:BoxSizer("HORIZONTAL")

	if picker_top == "depth" or picker_top == "all" then
		self._top_depth_btn = EWS:Button(p, "Pick Depth X", "", "")

		self._top_depth_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_top_depth_button"), "")
		self._top_button_box:add(self._top_depth_btn, 0, 0, "EXPAND")
	end

	if picker_top == "height" or picker_top == "all" then
		self._top_height_btn = EWS:Button(p, "Pick Height X", "", "")

		self._top_height_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_top_height_button"), "")
		self._top_button_box:add(self._top_height_btn, 0, 0, "EXPAND")
	end

	if picker_bottom == "depth" or picker_bottom == "all" then
		self._bottom_depth_btn = EWS:Button(p, "Pick Depth Y", "", "")

		self._bottom_depth_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_bottom_depth_button"), "")
		self._top_button_box:add(self._bottom_depth_btn, 0, 0, "EXPAND")
	end

	if picker_bottom == "height" or picker_bottom == "all" then
		self._bottom_height_btn = EWS:Button(p, "Pick Height Y", "", "")

		self._bottom_height_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_bottom_height_button"), "")
		self._top_button_box:add(self._bottom_height_btn, 0, 0, "EXPAND")
	end

	self._box:add(self._top_button_box, 0, 0, "EXPAND")

	self._slider_r_box = EWS:BoxSizer("HORIZONTAL")
	self._slider_r = EWS:Slider(p, 0, min, max)

	self._slider_r:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider"), "")
	self._slider_r:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_r_box:add(self._slider_r, 5, 0, "EXPAND")

	self._slider_r_textctrl = EWS:TextCtrl(p, "", "", "TE_PROCESS_ENTER")

	self._slider_r_textctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_update_textctrl"), "")
	self._slider_r_box:add(self._slider_r_textctrl, 1, 0, "EXPAND")
	self._box:add(self._slider_r_box, 1, 0, "EXPAND")

	self._slider_g_box = EWS:BoxSizer("HORIZONTAL")
	self._slider_g = EWS:Slider(p, 0, min, max)

	self._slider_g:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider"), "")
	self._slider_g:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_g_box:add(self._slider_g, 5, 0, "EXPAND")

	self._slider_g_textctrl = EWS:TextCtrl(p, "", "", "TE_PROCESS_ENTER")

	self._slider_g_textctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_update_textctrl"), "")
	self._slider_g_box:add(self._slider_g_textctrl, 1, 0, "EXPAND")
	self._box:add(self._slider_g_box, 1, 0, "EXPAND")
end

-- Lines 206-209
function Vector2Slider:on_slider_changed()
	self:set_text()
	self._editor:value_is_changed()
end

-- Lines 211-213
function Vector2Slider:on_slider()
	self:set_text()
end

-- Lines 215-218
function Vector2Slider:on_pick_top_depth_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "depth_x"
end

-- Lines 220-223
function Vector2Slider:on_pick_top_height_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "height_x"
end

-- Lines 225-228
function Vector2Slider:on_pick_bottom_depth_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "depth_y"
end

-- Lines 230-233
function Vector2Slider:on_pick_bottom_height_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "height_y"
end

-- Lines 235-237
function Vector2Slider:get_value()
	return Vector3(self._slider_r:get_value() / self._scale, self._slider_g:get_value() / self._scale, 0)
end

-- Lines 239-252
function Vector2Slider:on_update_textctrl()
	local r = tonumber(self._slider_r_textctrl:get_value())

	if type(r) ~= "number" then
		r = 0
	end

	local g = tonumber(self._slider_g_textctrl:get_value())

	if type(g) ~= "number" then
		g = 0
	end

	self:set_value(Vector3(r * self._display_scale / self._scale, g * self._display_scale / self._scale, 0))
	self._editor:value_is_changed()
end

-- Lines 254-257
function Vector2Slider:set_text()
	self._slider_r_textctrl:set_value(tostring(self._slider_r:get_value() / self._display_scale))
	self._slider_g_textctrl:set_value(tostring(self._slider_g:get_value() / self._display_scale))
end

-- Lines 259-263
function Vector2Slider:set_value(v)
	self._slider_r:set_value(v.x * self._scale)
	self._slider_g:set_value(v.y * self._scale)
	self:set_text()
end

DBDropdown = DBDropdown or class()

-- Lines 269-289
function DBDropdown:init(editor, p, name, db_key)
	self._editor = editor
	self._name = name
	self._db_key = db_key
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._button_box = EWS:BoxSizer("HORIZONTAL")

	self._box:add(self._button_box, 1, 0, "EXPAND")

	self._value_box = EWS:BoxSizer("HORIZONTAL")
	self._combobox = EWS:ComboBox(p, "", "", "CB_SORT,CB_READONLY")

	self._combobox:connect("", "EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_combobox_changed"), "")
	self:append_values()
	self._value_box:add(self._combobox, 1, 0, "EXPAND")
	self._box:add(self._value_box, 1, 0, "EXPAND")
end

-- Lines 291-301
function DBDropdown:append_values()
	local value = nil

	for _, v in ipairs(LightIntensityDB:list()) do
		self._combobox:append(v:s())

		value = v:s()
	end

	if value then
		self._combobox:set_value(value)
	end
end

-- Lines 303-305
function DBDropdown:get_value()
	return "#" .. self._db_key .. "#" .. self._combobox:get_value()
end

-- Lines 307-309
function DBDropdown:on_combobox_changed()
	self._editor:value_is_changed()
end

-- Lines 311-327
function DBDropdown:set_value(v)
	if type(v) == "string" then
		local str = string.sub(v, 2)

		assert(str)

		local i = string.find(str, "#")

		assert(i)

		local db_key = string.sub(str, 1, i - 1)

		assert(db_key and db_key == self._db_key)

		local value_key = string.sub(str, i + 1)

		assert(value_key)
		self._combobox:set_value(value_key)
	end
end

SingelSlider = SingelSlider or class()

-- Lines 333-382
function SingelSlider:init(editor, p, name, picker, min, max, scale, display_scale, picky)
	self._scale = scale
	self._editor = editor
	self._name = name
	self._min = min
	self._picky = picky

	if display_scale then
		self._display_scale = display_scale
	else
		self._display_scale = 1
	end

	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._button_box = EWS:BoxSizer("HORIZONTAL")

	if picker == "height" or picker == "all" then
		self._height_btn = EWS:Button(p, "Pick Height", "", "")

		self._height_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_height_button"), "")
		self._button_box:add(self._height_btn, 0, 0, "EXPAND")
	end

	if picker == "depth" or picker == "all" then
		self._depth_btn = EWS:Button(p, "Pick Depth", "", "")

		self._depth_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_depth_button"), "")
		self._button_box:add(self._depth_btn, 0, 0, "EXPAND")
	end

	self._box:add(self._button_box, 1, 0, "EXPAND")

	self._slider_box = EWS:BoxSizer("HORIZONTAL")
	self._chackbox = EWS:CheckBox(p, "", "", "")

	self._chackbox:set_tool_tip("Feed Zero")
	self._slider_box:add(self._chackbox, 0, 0, "EXPAND")

	self._slider = EWS:Slider(p, 0, min, max)

	self._slider:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider"), "")
	self._slider:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_box:add(self._slider, 5, 0, "EXPAND")

	self._slider_textctrl = EWS:TextCtrl(p, "", "", "TE_PROCESS_ENTER")

	self._slider_textctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_update_textctrl"), "")
	self._slider_box:add(self._slider_textctrl, 1, 0, "EXPAND")
	self._box:add(self._slider_box, 1, 0, "EXPAND")
	self:set_text()
end

-- Lines 384-390
function SingelSlider:get_value()
	if self._chackbox:get_value() then
		return self._min
	else
		return self._slider:get_value() / self._scale
	end
end

-- Lines 392-395
function SingelSlider:on_pick_depth_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "depth"
end

-- Lines 397-400
function SingelSlider:on_pick_height_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "height"
end

-- Lines 402-405
function SingelSlider:on_slider_changed()
	self:set_text()
	self._editor:value_is_changed()
end

-- Lines 407-412
function SingelSlider:on_slider()
	if self._picky then
		self._editor:value_is_changed()
	end

	self:set_text()
end

-- Lines 414-422
function SingelSlider:on_update_textctrl()
	local n = tonumber(self._slider_textctrl:get_value())

	if type(n) ~= "number" then
		n = 0
	end

	self:set_value(n * self._display_scale / self._scale)
	self._editor:value_is_changed()
end

-- Lines 424-426
function SingelSlider:set_text()
	self._slider_textctrl:set_value(tostring(self._slider:get_value() / self._display_scale))
end

-- Lines 428-431
function SingelSlider:set_value(v)
	self._slider:set_value(v * self._scale)
	self:set_text()
end

EnvironmentEditorEnvMixer = EnvironmentEditorEnvMixer or class()

-- Lines 437-455
function EnvironmentEditorEnvMixer:init(editor, p, name)
	self._editor = editor
	self._name = name
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._slider_box = EWS:BoxSizer("HORIZONTAL")
	self._slider = EWS:Slider(p, 0, 0, (#self._editor._template_environment_names - 1) * self._editor.MIX_MUL)

	self._slider:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider_change"), "")
	self._slider:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_box:add(self._slider, 5, 0, "EXPAND")
	self._box:add(self._slider_box, 1, 0, "EXPAND")
	self:update_tool_tip(self._editor._template_environment_names[1], self._editor._template_environment_names[2], 0)

	for _, sub in ipairs(self._editor._template_environment_names) do
		self._name_str = self._name_str and self._name_str .. " " .. sub or sub
	end
end

-- Lines 457-459
function EnvironmentEditorEnvMixer:get_value()
	return tostring(self._slider:get_value() / self._editor.MIX_MUL) .. " " .. self._name_str
end

-- Lines 461-464
function EnvironmentEditorEnvMixer:on_slider_changed()
	self._editor:value_is_changed()
	self:on_slider_change()
end

-- Lines 466-485
function EnvironmentEditorEnvMixer:on_slider_change()
	local val = self._slider:get_value() / self._editor.MIX_MUL
	local fval = math.floor(val)
	local i1 = fval + 1
	local i2 = fval + 2
	local blend = val - fval

	if i2 > #self._editor._template_environment_names then
		i1 = i1 - 1
		i2 = i2 - 1
		blend = 1
	end

	local env1 = self._editor._template_environment_names[i1]
	local env2 = self._editor._template_environment_names[i2]

	self:update_tool_tip(env1, env2, blend)
	self._editor:update_mix(env1, env2, blend)
end

-- Lines 487-489
function EnvironmentEditorEnvMixer:update_tool_tip(env1, env2, blend)
	self._slider:set_tool_tip(string.format("%.1f", tostring(1 - blend)) .. "% " .. env1 .. " - " .. string.format("%.1f", tostring(blend)) .. "% " .. env2)
end

-- Lines 491-493
function EnvironmentEditorEnvMixer:set_value(v)
	self._slider:set_value(tonumber(string.match(v, "[%w_.]+")) * self._editor.MIX_MUL)
end

RgbBox = RgbBox or class()

-- Lines 499-572
function RgbBox:init(editor, p, name)
	self._editor = editor
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._pick_box = EWS:BoxSizer("HORIZONTAL")
	self._pick_btn = EWS:Button(p, "Pick Color", "", "")

	self._pick_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_pick_button"), "")
	self._pick_box:add(self._pick_btn, 0, 0, "EXPAND")

	self._btn = EWS:Button(p, "", "", "")

	self._btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_color_button"), "")
	self._pick_box:add(self._btn, 0, 0, "EXPAND")
	self._box:add(self._pick_box, 1, 0, "EXPAND")

	self._slider_box = EWS:BoxSizer("VERTICAL")
	self._slider_r_box = EWS:BoxSizer("HORIZONTAL")
	self._slider_r = EWS:Slider(p, 128, 0, 255)

	self._slider_r:set_background_colour(195, 180, 180)
	self._slider_r:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider"), "")
	self._slider_r:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_r_box:add(self._slider_r, 5, 0, "EXPAND")

	self._slider_r_textctrl = EWS:TextCtrl(p, "", "", "TE_PROCESS_ENTER")

	self._slider_r_textctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_update_textctrl"), "")
	self._slider_r_box:add(self._slider_r_textctrl, 1, 0, "EXPAND")
	self._slider_box:add(self._slider_r_box, 1, 0, "EXPAND")

	self._slider_g_box = EWS:BoxSizer("HORIZONTAL")
	self._slider_g = EWS:Slider(p, 128, 0, 255)

	self._slider_g:set_background_colour(180, 195, 180)
	self._slider_g:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider"), "")
	self._slider_g:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_g_box:add(self._slider_g, 5, 0, "EXPAND")

	self._slider_g_textctrl = EWS:TextCtrl(p, "", "", "TE_PROCESS_ENTER")

	self._slider_g_textctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_update_textctrl"), "")
	self._slider_g_box:add(self._slider_g_textctrl, 1, 0, "EXPAND")
	self._slider_box:add(self._slider_g_box, 1, 0, "EXPAND")

	self._slider_b_box = EWS:BoxSizer("HORIZONTAL")
	self._slider_b = EWS:Slider(p, 128, 0, 255)

	self._slider_b:set_background_colour(180, 180, 195)
	self._slider_b:connect("", "EVT_SCROLL_THUMBTRACK", callback(self, self, "on_slider"), "")
	self._slider_b:connect("", "EVT_SCROLL_CHANGED", callback(self, self, "on_slider_changed"), "")
	self._slider_b_box:add(self._slider_b, 5, 0, "EXPAND")

	self._slider_b_textctrl = EWS:TextCtrl(p, "", "", "TE_PROCESS_ENTER")

	self._slider_b_textctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_update_textctrl"), "")
	self._slider_b_box:add(self._slider_b_textctrl, 1, 0, "EXPAND")
	self._slider_box:add(self._slider_b_box, 1, 0, "EXPAND")
	self._box:add(self._slider_box, 0, 0, "EXPAND")
	self:set_value(Vector3(0.5, 0.5, 0.5))

	self._color_dialog = EWS:ColourDialog(p, true, self:get_value())
end

-- Lines 574-577
function RgbBox:on_slider_changed()
	self:set_value(Vector3(self._slider_r:get_value() / 255, self._slider_g:get_value() / 255, self._slider_b:get_value() / 255))
	self._editor:value_is_changed()
end

-- Lines 579-581
function RgbBox:on_slider()
	self:set_value(Vector3(self._slider_r:get_value() / 255, self._slider_g:get_value() / 255, self._slider_b:get_value() / 255))
end

-- Lines 583-589
function RgbBox:on_color_button()
	if self._color_dialog:show_modal() then
		self:set_value(self._color_dialog:get_colour())
		self:set_text()
		self._editor:value_is_changed()
	end
end

-- Lines 591-594
function RgbBox:on_pick_button()
	self._editor._update_pick_element = self
	self._editor._update_pick_element_type = "color"
end

-- Lines 596-614
function RgbBox:on_update_textctrl()
	local r = tonumber(self._slider_r_textctrl:get_value())

	if type(r) ~= "number" then
		r = 0
	end

	local g = tonumber(self._slider_g_textctrl:get_value())

	if type(g) ~= "number" then
		g = 0
	end

	local b = tonumber(self._slider_b_textctrl:get_value())

	if type(b) ~= "number" then
		b = 0
	end

	self:set_value(Vector3(r / 255, g / 255, b / 255))
	self._editor:value_is_changed()
end

-- Lines 616-618
function RgbBox:get_value()
	return self._color
end

-- Lines 620-624
function RgbBox:set_text()
	self._slider_r_textctrl:set_value(tostring(self._color.x * 255))
	self._slider_g_textctrl:set_value(tostring(self._color.y * 255))
	self._slider_b_textctrl:set_value(tostring(self._color.z * 255))
end

-- Lines 626-633
function RgbBox:set_value(v)
	self._color = v

	self:set_text()
	self._btn:set_background_colour(self._color.x * 255, self._color.y * 255, self._color.z * 255)
	self._slider_r:set_value(self._color.x * 255)
	self._slider_g:set_value(self._color.y * 255)
	self._slider_b:set_value(self._color.z * 255)
end

EnvEdColorBox = EnvEdColorBox or class()

-- Lines 639-650
function EnvEdColorBox:init(editor, p, name, no_value)
	self._editor = editor
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._picker_panel = CoreColorPickerPanel.ColorPickerPanel:new(p, false, "HORIZONTAL", no_value)

	self._picker_panel:connect("EVT_COLOR_UPDATED", CoreEvent.callback(self, self, "on_changed"), self._picker_panel)
	self._picker_panel:connect("EVT_COLOR_CHANGED", CoreEvent.callback(self, self, "on_leftup"))
	self._box:add(self._picker_panel:panel(), 0, 0, "EXPAND")
	self._editor:add_updator(self)

	self._color = Vector3(0, 0, 0)
end

-- Lines 652-654
function EnvEdColorBox:update(t, dt)
	self._picker_panel:update(t, dt)
end

-- Lines 656-658
function EnvEdColorBox:on_changed(sender, color)
	self._color = Vector3(color.r, color.g, color.b)
end

-- Lines 660-662
function EnvEdColorBox:on_leftup()
	self._editor:value_is_changed()
end

-- Lines 664-666
function EnvEdColorBox:get_value()
	return self._color
end

-- Lines 668-671
function EnvEdColorBox:set_value(v)
	self._color = v

	self._picker_panel:set_color(Color(v.x, v.y, v.z))
end

EnvEdEditBox = EnvEdEditBox or class()

-- Lines 677-686
function EnvEdEditBox:init(editor, p, name, no_value)
	self._editor = editor
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	self._value = "default"
	self._textctrl = EWS:TextCtrl(p, self._value, "", "")

	self._textctrl:connect("", "EVT_COMMAND_TEXT_UPDATED", callback(self, self, "text_changed"), "")
	self._box:add(self._textctrl, 0, 0, "EXPAND")
end

-- Lines 688-691
function EnvEdEditBox:text_changed()
	self._value = self._textctrl:get_value()

	self._editor:value_is_changed()
end

-- Lines 693-695
function EnvEdEditBox:get_value()
	return self._value
end

-- Lines 697-700
function EnvEdEditBox:set_value(value)
	self._value = value

	self._textctrl:set_value(value)
end

PathBox = PathBox or class()

-- Lines 706-726
function PathBox:init(editor, p, name)
	self._editor = editor
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	local h_box = EWS:BoxSizer("HORIZONTAL")
	self._btn = EWS:Button(p, "Browse", "", "")

	self._btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_path_button"), "")
	h_box:add(self._btn, 0, 0, "EXPAND")
	self._box:add(h_box, 1, 0, "EXPAND")

	self._path_text = EWS:StaticText(p, name, "", "")

	self._box:add(self._path_text, 0, 0, "EXPAND")

	self._path = ""
	self._path_dialog = EWS:FileDialog(p, "Sky Scene", managers.database:base_path(), "", "Scene files (*.scene)|*.scene", "OPEN,FILE_MUST_EXIST")
end

-- Lines 728-734
function PathBox:on_path_button()
	if self._path_dialog:show_modal() then
		local dialog_path = self._path_dialog:get_path()

		self:set_value(managers.database:entry_path(dialog_path))
		self._editor:value_is_changed()
	end
end

-- Lines 736-738
function PathBox:get_value()
	return self._path
end

-- Lines 740-743
function PathBox:set_value(v)
	self._path = v

	self._path_text:set_label(self._path)
end

DBPickDialog = DBPickDialog or class()

-- Lines 749-774
function DBPickDialog:init(editor, p, name, pick_type)
	self._editor = editor
	self._parent = p
	self._box = EWS:StaticBoxSizer(p, "VERTICAL", name)
	local h_box = EWS:BoxSizer("HORIZONTAL")
	self._clear_btn = EWS:Button(p, "Clear", "", "")

	self._clear_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "set_value"), "")
	h_box:add(self._clear_btn, 0, 0, "EXPAND")

	self._btn = EWS:Button(p, "Browse", "", "")

	self._btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_path_button"), "")
	h_box:add(self._btn, 0, 0, "EXPAND")
	self._box:add(h_box, 1, 0, "EXPAND")

	self._path_text = EWS:StaticText(p, "", "", "")

	self._box:add(self._path_text, 0, 0, "EXPAND")

	self._path = ""
	self._pick_type = pick_type or ""
end

-- Lines 776-781
function DBPickDialog:on_path_button()
	local path = managers.database:open_file_dialog(self._parent, "Textures (*.dds)|*.dds")

	if path then
		self:set_value(managers.database:entry_path(path))
	end
end

-- Lines 783-785
function DBPickDialog:get_value()
	return self._path
end

-- Lines 787-790
function DBPickDialog:set_value(v)
	self._path = v

	self._path_text:set_label(self._path)
end

CustomCheckBox = CustomCheckBox or class()

-- Lines 796-803
function CustomCheckBox:init(editor, p, text)
	self._editor = editor
	self._box = EWS:StaticBoxSizer(p, "HORIZONTAL", "")
	self._check_box = EWS:CheckBox(p, text, "", "")

	self._check_box:connect("", "EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "on_checkbox"), "")
	self._box:add(self._check_box, 1, 0, "EXPAND")
end

-- Lines 805-807
function CustomCheckBox:on_checkbox()
	self._editor:value_is_changed()
end

-- Lines 809-816
function CustomCheckBox:get_value()
	local v = self._check_box:get_value()

	if v then
		return 1
	else
		return 0
	end
end

-- Lines 818-820
function CustomCheckBox:set_value(v)
	self._check_box:set_value(v > 0)
end

ConnectDialog = ConnectDialog or class()

-- Lines 826-856
function ConnectDialog:init(p)
	self._dialog = EWS:Dialog(p, "Connect Client", "", Vector3(0, 0, 0), Vector3(300, 75, 0), "CAPTION,SYSTEM_MENU")
	local box = EWS:BoxSizer("VERTICAL")
	local text_box = EWS:BoxSizer("HORIZONTAL")
	self._text_ctrl = EWS:TextCtrl(self._dialog, "", "", "TE_PROCESS_ENTER")

	self._text_ctrl:set_value("192.168.0.1")
	self._text_ctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_connect_button"), "")
	text_box:add(self._text_ctrl, 3, 0, "EXPAND")

	self._port_text_ctrl = EWS:TextCtrl(self._dialog, "", "", "TE_PROCESS_ENTER")

	self._port_text_ctrl:set_value("12345")
	self._port_text_ctrl:connect("", "EVT_COMMAND_TEXT_ENTER", callback(self, self, "on_connect_button"), "")
	text_box:add(self._port_text_ctrl, 1, 0, "EXPAND")
	box:add(text_box, 0, 0, "EXPAND")

	local button_box = EWS:BoxSizer("HORIZONTAL")
	self._connect = EWS:Button(self._dialog, "Connect", "", "")

	self._connect:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_connect_button"), "")
	button_box:add(self._connect, 1, 0, "EXPAND")

	self._cancel = EWS:Button(self._dialog, "Cancel", "", "")

	self._cancel:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_cancel_button"), "")
	button_box:add(self._cancel, 1, 0, "EXPAND")
	box:add(button_box, 0, 0, "EXPAND")
	self._dialog:set_sizer(box)
end

-- Lines 858-867
function ConnectDialog:show_modal()
	self._done = false
	self._return_val = true

	self._dialog:show_modal()

	while not self._done do
	end

	return self._return_val
end

-- Lines 869-872
function ConnectDialog:on_connect_button()
	self._done = true

	self._dialog:end_modal("")
end

-- Lines 874-878
function ConnectDialog:on_cancel_button()
	self._done = true
	self._return_val = false

	self._dialog:end_modal("")
end

-- Lines 880-882
function ConnectDialog:get_ip()
	return self._text_ctrl:get_value()
end

-- Lines 884-886
function ConnectDialog:get_port()
	return tonumber(self._port_text_ctrl:get_value())
end
