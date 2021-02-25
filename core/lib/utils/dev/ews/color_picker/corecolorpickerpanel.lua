core:module("CoreColorPickerPanel")
core:import("CoreClass")
core:import("CoreEvent")
core:import("CoreColorPickerDraggables")
core:import("CoreColorPickerFields")

ColorPickerPanel = ColorPickerPanel or CoreClass.mixin(CoreClass.class(), CoreEvent.BasicEventHandling)

-- Lines 9-12
function ColorPickerPanel:init(parent_frame, enable_alpha, orientation, enable_value)
	assert(orientation == "HORIZONTAL" or orientation == "VERTICAL")
	self:_create_panel(parent_frame, enable_alpha, orientation, enable_value)
end

-- Lines 14-16
function ColorPickerPanel:panel()
	return self._panel
end

-- Lines 18-20
function ColorPickerPanel:color()
	return self._fields:color()
end

-- Lines 22-25
function ColorPickerPanel:set_color(color)
	self._draggables:set_color(color)
	self._fields:set_color(color)
end

-- Lines 27-30
function ColorPickerPanel:update(time, delta_time)
	self._draggables:update(time, delta_time)
	self._fields:update(time, delta_time)
end

-- Lines 32-48
function ColorPickerPanel:_create_panel(parent_frame, enable_alpha, orientation, enable_value)
	self._panel = EWS:Panel(parent_frame)
	local panel_sizer = EWS:BoxSizer(orientation)

	self._panel:set_sizer(panel_sizer)

	self._draggables = CoreColorPickerDraggables.ColorPickerDraggables:new(self._panel, enable_alpha, enable_value)
	self._fields = CoreColorPickerFields.ColorPickerFields:new(self._panel, enable_alpha, enable_value)

	self._draggables:connect("EVT_COLOR_UPDATED", CoreEvent.callback(self, self, "_on_color_updated"), self._draggables)
	self._fields:connect("EVT_COLOR_UPDATED", CoreEvent.callback(self, self, "_on_color_updated"), self._fields)
	self._draggables:connect("EVT_COLOR_CHANGED", CoreEvent.callback(self, self, "_on_color_changed"), self._draggables)
	self._fields:connect("EVT_COLOR_CHANGED", CoreEvent.callback(self, self, "_on_color_changed"), self._fields)
	panel_sizer:add(self._draggables:panel(), 0, 0, "EXPAND")
	panel_sizer:add(self._fields:panel(), 1, 0, "EXPAND")
end

-- Lines 50-53
function ColorPickerPanel:_on_color_updated(sender, color)
	table.exclude({
		self._draggables,
		self._fields
	}, sender)[1]:set_color(color)
	self:_send_event("EVT_COLOR_UPDATED", color)
end

-- Lines 55-57
function ColorPickerPanel:_on_color_changed(sender, color)
	self:_send_event("EVT_COLOR_CHANGED", color)
end
