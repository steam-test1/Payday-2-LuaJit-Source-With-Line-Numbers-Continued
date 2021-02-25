-- Lines 1-30
function CoreEditor:build_marker_panel()
	self._marker_panel = EWS:Panel(self._ews_editor_frame, "Markers", "TAB_TRAVERSAL")
	local marker_sizer = EWS:BoxSizer("VERTICAL")

	self._marker_panel:set_sizer(marker_sizer)

	local btn_sizer = EWS:BoxSizer("HORIZONTAL")
	local create_marker_btn = EWS:Button(self._marker_panel, "Create Marker", "_create_marker", "BU_EXACTFIT,NO_BORDER")

	create_marker_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_make_marker"), nil)
	btn_sizer:add(create_marker_btn, 0, 2, "RIGHT")

	local use_marker_btn = EWS:Button(self._marker_panel, "Use Marker", "_use_marker", "BU_EXACTFIT,NO_BORDER")

	use_marker_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_use_marker"), nil)
	btn_sizer:add(use_marker_btn, 0, 2, "RIGHT")

	local delete_marker_btn = EWS:Button(self._marker_panel, "Del. Marker", "_delete_marker", "BU_EXACTFIT,NO_BORDER")

	delete_marker_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_delete_marker"), nil)
	btn_sizer:add(delete_marker_btn, 0, 2, "RIGHT")
	marker_sizer:add(btn_sizer, 0, 0, "EXPAND")

	local marker_list_sizer = EWS:BoxSizer("VERTICAL")
	self._ews_markers = EWS:ListBox(self._marker_panel, "_markers", "LB_SINGLE,LB_HSCROLL,LB_NEEDED_SB,LB_SORT")

	marker_list_sizer:add(self._ews_markers, 0, 0, "EXPAND")
	marker_sizer:add(marker_list_sizer, 0, 0, "EXPAND")

	return self._marker_panel
end

-- Lines 32-38
function CoreEditor:marker_name()
	local i = 1

	while self._markers["marker" .. i] do
		i = i + 1
	end

	return "marker" .. i
end

-- Lines 39-48
function CoreEditor:on_make_marker()
	local name = EWS:get_text_from_user(Global.frame_panel, "Enter name for the marker:", "Create Marker", self:marker_name(), Vector3(-1, -1, 0), true)

	if name and name ~= "" then
		if self._markers[name] then
			self:on_make_marker()
		else
			self:make_marker(name)
		end
	end
end

-- Lines 49-57
function CoreEditor:make_marker(name)
	if self._current_layer then
		local m = Marker:new(name)

		if self._current_layer:create_marker(m) then
			self._ews_markers:append(name)

			self._markers[name] = m
		end
	end
end

-- Lines 58-63
function CoreEditor:on_use_marker()
	local s = self:get_marker_string()

	if s then
		self:use_marker(s)
	end
end

-- Lines 64-70
function CoreEditor:use_marker(name)
	if self._current_layer and self._markers[name] then
		self._current_layer:use_marker(self._markers[name])
	end
end

-- Lines 72-77
function CoreEditor:on_delete_marker()
	local s = self:get_marker_string()

	if s then
		self:delete_marker(s)
	end
end

-- Lines 78-83
function CoreEditor:delete_marker(name)
	if self._markers[name] then
		self._markers[name] = nil
	end

	self:remove_marker_from_list(name)
end

-- Lines 85-93
function CoreEditor:get_marker_string()
	if self._ews_markers:nr_items() > 0 then
		local i = self._ews_markers:selected_index()

		if i >= 0 then
			return self._ews_markers:get_string(i)
		end
	end

	return nil
end

-- Lines 94-104
function CoreEditor:remove_marker_from_list(s)
	local i = 0
	local size = self._ews_markers:nr_items()

	while i < size do
		if s == self._ews_markers:get_string(i) then
			self._ews_markers:remove(i)

			break
		end

		i = i + 1
	end
end

-- Lines 106-108
function CoreEditor:create_marker(name, pos, rot)
	self._markers[name] = Marker:new(name, pos, rot)
end

-- Lines 109-114
function CoreEditor:get_marker(name)
	if self._markers[name] then
		return self._markers[name]
	end

	return nil
end

-- Lines 116-119
function CoreEditor:clear_markers()
	self._ews_markers:clear()

	self._markers = {}
end

Marker = Marker or class()

-- Lines 123-127
function Marker:init(name, pos, rot)
	self._name = name
	self._pos = pos
	self._rot = rot
end

-- Lines 128-130
function Marker:set_pos(pos)
	self._pos = pos
end

-- Lines 131-133
function Marker:set_rot(rot)
	self._rot = rot
end

-- Lines 134-139
function Marker:draw()
	local l = 2000

	Application:draw_line(self._pos, self._pos + self._rot:x() * l, 0.5, 0, 0)
	Application:draw_line(self._pos, self._pos + self._rot:y() * l, 0, 0.5, 0)
	Application:draw_line(self._pos, self._pos + self._rot:z() * l, 0, 0, 0.5)
end

-- Lines 141-144
function Marker:save(file, t)
	t = t .. "\t"

	file:puts(t .. "<marker name=\"" .. self._name .. "\" pos=\"" .. self._pos.x .. " " .. self._pos.y .. " " .. self._pos.z .. "\" rot=\"" .. self._rot:yaw() .. " " .. self._rot:pitch() .. " " .. self._rot:roll() .. "\"/>")
end
