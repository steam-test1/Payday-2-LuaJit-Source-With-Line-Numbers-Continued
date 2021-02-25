require("core/lib/utils/dev/tools/material_editor/CoreSmartNode")

local CoreMaterialEditorParameter = require("core/lib/utils/dev/tools/material_editor/parameter_widgets/CoreMaterialEditorParameter")
local CoreMaterialEditorVector2 = CoreMaterialEditorVector2 or class(CoreMaterialEditorParameter)

-- Lines 8-39
function CoreMaterialEditorVector2:init(parent, editor, parameter_info, parameter_node)
	CoreMaterialEditorParameter.init(self, parent, editor, parameter_info, parameter_node)

	local main_box = EWS:BoxSizer("VERTICAL")
	local box = EWS:BoxSizer("HORIZONTAL")

	main_box:add(box, 1, 0, "EXPAND")

	self._x_slider = EWS:Slider(self._right_panel, self:_to_slider_range(self._value).x, 0, self:_to_slider_range(parameter_info.max).x, "", "")

	self._x_slider:connect("", "EVT_SCROLL_THUMBTRACK", self._on_slider, self)
	self._x_slider:connect("", "EVT_SCROLL_CHANGED", self._on_slider, self)
	box:add(self._x_slider, 1, 4, "ALL,EXPAND")

	self._x_text_ctrl = EWS:TextCtrl(self._right_panel, tostring(self._value.x), "", "TE_PROCESS_ENTER")

	self._x_text_ctrl:connect("", "EVT_COMMAND_TEXT_ENTER", self._on_text_ctrl, self)
	self._x_text_ctrl:set_min_size(Vector3(40, -1, -1))
	box:add(self._x_text_ctrl, 0, 4, "ALL,EXPAND")

	box = EWS:BoxSizer("HORIZONTAL")

	main_box:add(box, 1, 0, "EXPAND")

	self._y_slider = EWS:Slider(self._right_panel, self:_to_slider_range(self._value).y, 0, self:_to_slider_range(parameter_info.max).y, "", "")

	self._y_slider:connect("", "EVT_SCROLL_THUMBTRACK", self._on_slider, self)
	self._y_slider:connect("", "EVT_SCROLL_CHANGED", self._on_slider, self)
	box:add(self._y_slider, 1, 4, "ALL,EXPAND")

	self._y_text_ctrl = EWS:TextCtrl(self._right_panel, tostring(self._value.y), "", "TE_PROCESS_ENTER")

	self._y_text_ctrl:connect("", "EVT_COMMAND_TEXT_ENTER", self._on_text_ctrl, self)
	self._y_text_ctrl:set_min_size(Vector3(40, -1, -1))
	box:add(self._y_text_ctrl, 0, 4, "ALL,EXPAND")
	self._right_box:add(main_box, 1, 0, "EXPAND")
end

-- Lines 41-43
function CoreMaterialEditorVector2:update(t, dt)
	CoreMaterialEditorParameter.update(self, t, dt)
end

-- Lines 45-47
function CoreMaterialEditorVector2:destroy()
	CoreMaterialEditorParameter.destroy(self)
end

-- Lines 49-65
function CoreMaterialEditorVector2:on_toggle_customize()
	self._customize = not self._customize

	self:_load_value()
	self._editor:_update_output()
	self._right_panel:set_enabled(self._customize)
	self._x_text_ctrl:set_value(string.format("%.3f", self._value.x))
	self._y_text_ctrl:set_value(string.format("%.3f", self._value.y))

	local value = self:_to_slider_range(self._value)

	self._x_slider:set_value(value.x)
	self._y_slider:set_value(value.y)
	self:update_live()
end

-- Lines 69-80
function CoreMaterialEditorVector2:_on_slider()
	self._value = self:_from_slider_range(Vector3(self._x_slider:get_value(), self._y_slider:get_value()))

	self._parameter_node:set_parameter("value", math.vector_to_string(self._value))
	self:update_live()
	self._x_text_ctrl:set_value(string.format("%.3f", self._value.x))
	self._y_text_ctrl:set_value(string.format("%.3f", self._value.y))
end

-- Lines 82-96
function CoreMaterialEditorVector2:_on_text_ctrl()
	self._value = Vector3(tonumber(self._x_text_ctrl:get_value()) or 0, tonumber(self._y_text_ctrl:get_value()) or 0)

	self._parameter_node:set_parameter("value", math.vector_to_string(self._value))
	self:update_live()

	local value = self:_to_slider_range(self._value)

	self._x_slider:set_value(value.x)
	self._y_slider:set_value(value.y)
	self._editor:_update_output()
end

-- Lines 98-114
function CoreMaterialEditorVector2:_to_slider_range(v)
	local step_x = self._parameter_info.step.x

	if step_x == 0 then
		step_x = step_x + 0.001
	end

	local step_y = self._parameter_info.step.y

	if step_y == 0 then
		step_y = step_y + 0.001
	end

	return Vector3(CoreMaterialEditorParameter.to_slider_range(self, v.x, self._parameter_info.min.x, step_x), CoreMaterialEditorParameter.to_slider_range(self, v.y, self._parameter_info.min.y, step_y))
end

-- Lines 116-132
function CoreMaterialEditorVector2:_from_slider_range(v)
	local step_x = self._parameter_info.step.x

	if step_x == 0 then
		step_x = step_x + 0.001
	end

	local step_y = self._parameter_info.step.y

	if step_y == 0 then
		step_y = step_y + 0.001
	end

	return Vector3(CoreMaterialEditorParameter.from_slider_range(self, v.x, self._parameter_info.min.x, step_x), CoreMaterialEditorParameter.from_slider_range(self, v.y, self._parameter_info.min.y, step_y))
end

return CoreMaterialEditorVector2
