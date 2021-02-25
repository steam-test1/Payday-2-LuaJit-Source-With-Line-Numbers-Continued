MissionElementTimeline = MissionElementTimeline or class(CoreEditorEwsDialog)

-- Lines 3-76
function MissionElementTimeline:init(caption)
	CoreEditorEwsDialog.init(self, nil, "Element - " .. caption, "", Vector3(25, 602, 0), Vector3(1000, 200, 0), "DEFAULT_DIALOG_STYLE,RESIZE_BORDER,STAY_ON_TOP")
	self:create_panel("VERTICAL")

	self._multiplier = 30
	self._scrolled_area = EWS:ScrolledWindow(self._panel)

	self._scrolled_area:set_scrollbars(Vector3(1, 1, 1), Vector3(1, 1, 1), Vector3(0, 0, 0), false)

	local scrolled_area_sizer = EWS:BoxSizer("VERTICAL")

	self._scrolled_area:set_sizer(scrolled_area_sizer)
	self._panel_sizer:add(self._scrolled_area, 1, 0, "EXPAND")

	self._sequence_track = EWS:SequencerTrack(self._scrolled_area, "")

	self:_connect_mouse_events(self._sequence_track)
	self._sequence_track:set_background_colour(EWS:get_system_colour("3DFACE"):unpack())

	self._ruler = EWS:SequencerRuler(self._scrolled_area)

	self._ruler:set_major_divisions(100, 1)
	self._sequence_track:set_units(100, self._multiplier)
	scrolled_area_sizer:add(self._ruler, 0, 0, "EXPAND")
	scrolled_area_sizer:add(self._sequence_track, 1, 0, "EXPAND")

	local button_sizer = EWS:BoxSizer("HORIZONTAL")
	local button_sizer1 = EWS:BoxSizer("HORIZONTAL")

	self:_zoom_button(button_sizer1, "1", 1)
	self:_zoom_button(button_sizer1, "2", 2)
	self:_zoom_button(button_sizer1, "5", 5)
	self:_zoom_button(button_sizer1, "10", 10)
	self:_zoom_button(button_sizer1, "25", 25)
	self:_zoom_button(button_sizer1, "50", 50)

	local element_name_sizer = EWS:BoxSizer("HORIZONTAL")

	element_name_sizer:add(EWS:StaticText(self._panel, "Name:", 0, ""), 1, 0, "ALIGN_CENTER_VERTICAL")

	self._element_name = EWS:StaticText(self._panel, "", "", "ALIGN_CENTRE,ST_NO_AUTORESIZE")

	element_name_sizer:add(self._element_name, 6, 0, "ALIGN_CENTER_VERTICAL")
	button_sizer1:add(element_name_sizer, 0, 32, "EXPAND,LEFT")

	local element_delay_sizer = EWS:BoxSizer("HORIZONTAL")

	element_delay_sizer:add(EWS:StaticText(self._panel, "Delay:", 0, ""), 1, 0, "ALIGN_CENTER_VERTICAL")

	self._element_delay = EWS:StaticText(self._panel, "", "", "ALIGN_CENTRE,ST_NO_AUTORESIZE")

	element_delay_sizer:add(self._element_delay, 2, 0, "ALIGN_CENTER_VERTICAL")
	button_sizer1:add(element_delay_sizer, 0, 32, "EXPAND,LEFT")
	button_sizer:add(button_sizer1, 1, 0, "ALIGN_LEFT")

	local button_sizer2 = EWS:BoxSizer("HORIZONTAL")
	local cancel_btn = EWS:Button(self._panel, "Close", "", "")

	button_sizer2:add(cancel_btn, 0, 2, "RIGHT,LEFT")
	cancel_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_cancel"), "")
	cancel_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")
	button_sizer:add(button_sizer2, 0, 0, "EXPAND")
	self._panel_sizer:add(button_sizer, 0, 2, "EXPAND,TOP,BOTTOM")
	self._dialog_sizer:add(self._panel, 1, 0, "EXPAND")
	self._dialog:set_visible(true)
	self._dialog:connect("EVT_CHILD_FOCUS", callback(self, self, "on_focus"), "")
	self._sequence_track:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")
end

-- Lines 78-80
function MissionElementTimeline:on_focus()
	managers.editor:select_unit(self._mission_unit)
end

-- Lines 82-87
function MissionElementTimeline:_zoom_button(sizer, name, seconds)
	local btn = EWS:Button(self._panel, name, "", "BU_EXACTFIT")

	sizer:add(btn, 0, 2, "RIGHT,LEFT,TOP")
	btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_btn_zoom"), seconds)
	btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")
end

-- Lines 89-104
function MissionElementTimeline:on_btn_zoom(seconds)
	self._ruler:set_major_divisions((self:size().x - 40) / seconds, self._ruler:units_per_major_division())
	self._sequence_track:set_units((self:size().x - 40) / seconds, self._multiplier)
	self._sequence_track:set_focus()

	local clip = self._sequence_track:selected_clips()[1]

	if not clip then
		return
	end

	local offset_in_window = self:size().x / 2
	local scroll_offset = self._sequence_track:units_to_pixels(clip:start_time()) - offset_in_window

	self._scrolled_area:scroll(Vector3(scroll_offset / self._scrolled_area:scroll_pixels_per_unit().x, -1, 0))
end

-- Lines 106-109
function MissionElementTimeline:set_mission_unit(unit)
	self._mission_unit = unit

	self:update_timeline()
end

-- Lines 111-117
function MissionElementTimeline:update_timeline()
	self._sequence_track:remove_all_clips()

	for _, params in ipairs(self._mission_unit:mission_element_data().on_executed) do
		local unit = self._mission_unit:mission_element():on_execute_unit_by_id(params.id)

		self:_add_unit(unit, params)
	end
end

-- Lines 119-128
function MissionElementTimeline:delay_updated(params)
	for _, clip in ipairs(self._sequence_track:clips()) do
		if clip:metadata().params == params then
			local coor = params.delay * self._multiplier

			clip:set_range(coor, coor)
			self._element_delay:set_value(string.format("%.2f", params.delay))

			return
		end
	end
end

-- Lines 131-133
function MissionElementTimeline:add_element(unit, params)
	self:_add_unit(unit, params)
end

-- Lines 136-143
function MissionElementTimeline:select_element(params)
	for _, clip in ipairs(self._sequence_track:clips()) do
		if clip:metadata().params == params then
			self:_select_clip(clip)

			return
		end
	end
end

-- Lines 146-154
function MissionElementTimeline:_select_clip(clip)
	self._element_name:set_value(clip and clip:metadata().unit:unit_data().name_id or "")
	self._element_delay:set_value(clip and string.format("%.2f", clip:metadata().params.delay) or "")
	self._sequence_track:deselect_all_clips()

	if clip then
		clip:set_selected(true)
	end
end

-- Lines 157-164
function MissionElementTimeline:remove_element(params)
	for _, clip in ipairs(self._sequence_track:clips()) do
		if clip:metadata().params == params then
			self._sequence_track:remove_clip(clip)

			return
		end
	end
end

-- Lines 167-173
function MissionElementTimeline:_add_unit(unit, params)
	local key = EWS:SequencerKey()

	key:set_metadata({
		unit = unit,
		params = params
	})

	local r, g, b = self:_get_color(unit)

	key:set_colour(r, g, b)

	return self._sequence_track:add_clip(key, params.delay * self._multiplier)
end

-- Lines 176-182
function MissionElementTimeline:_get_color(unit)
	local color = unit:mission_element():timeline_color()

	if color then
		return color.x, color.y, color.z
	end

	return math.rand(1), math.rand(1), math.rand(1)
end

-- Lines 184-192
function MissionElementTimeline:_connect_mouse_events(component)
	component:connect("EVT_LEFT_DOWN", callback(self, self, "_on_mouse_left_down"), component)
	component:connect("EVT_RIGHT_DOWN", callback(self, self, "_on_mouse_right_down"), component)
	component:connect("EVT_MOUSEWHEEL", callback(self, self, "_on_mousewheel"), component)
	component:connect("EVT_MOTION", callback(self, self, "_on_mouse_motion"), component)
	component:connect("EVT_LEFT_UP", callback(self, self, "_on_mouse_left_up"), component)
end

-- Lines 194-203
function MissionElementTimeline:_on_mouse_left_down(sender, event)
	self._dragging = true
	local key = self._sequence_track:clip_at_event(event)

	if key then
		self._mission_unit:mission_element():set_on_executed_element(key:metadata().unit)
	end

	managers.editor:select_unit(self._mission_unit)
	self:_select_clip(key)
end

-- Lines 205-207
function MissionElementTimeline:_on_mouse_left_up(sender, event)
	self._dragging = false
end

-- Lines 209-217
function MissionElementTimeline:_on_mouse_right_down(sender, event)
	local key = self._sequence_track:clip_at_event(event)

	if key then
		managers.editor:select_unit(key:metadata().unit)
	else
		managers.editor:select_unit(self._mission_unit)
	end

	self:_select_clip(key)
end

-- Lines 219-233
function MissionElementTimeline:_on_mouse_motion(sender, event)
	if not self._dragging then
		return
	end

	local pos = event:get_position(self._sequence_track)
	local coor = self._sequence_track:pixels_to_units(pos.x)

	for _, key in ipairs(self._sequence_track:selected_clips()) do
		key:set_range(coor, coor)

		local delay = coor / self._multiplier
		key:metadata().params.delay = delay

		self._mission_unit:mission_element():set_on_executed_element(key:metadata().unit)
		self._element_delay:set_value(string.format("%.2f", key:metadata().params.delay))
	end
end

-- Lines 235-244
function MissionElementTimeline:_on_mousewheel(track, event)
	local clip = self._sequence_track:selected_clips()[1]

	if not clip then
		return
	end

	local delta = math.sign(event:get_wheel_rotation()) * math.clamp(self._ruler:pixels_per_major_division() / 100, 1, 20)

	self:zoom_around(clip:start_time(), self._panel:get_size().x / 2, delta)
end

-- Lines 246-257
function MissionElementTimeline:zoom_around(time, offset_in_window, delta)
	self._scrolled_area:freeze()

	local new_pixels_per_division = math.clamp(self._ruler:pixels_per_major_division() + delta, 20, 10000)

	self._ruler:set_major_divisions(new_pixels_per_division, self._ruler:units_per_major_division())
	self._sequence_track:set_units(new_pixels_per_division, self._multiplier)

	local scroll_offset = self._sequence_track:units_to_pixels(time) - offset_in_window

	self._scrolled_area:scroll(Vector3(scroll_offset / self._scrolled_area:scroll_pixels_per_unit().x, -1, 0))
	self._scrolled_area:thaw()
end
