CoreEditableGui = CoreEditableGui or class()

-- Lines: 3 to 44
function CoreEditableGui:init(unit)
	self._unit = unit
	self._text = self._text or "Default Text"
	self._cull_distance = self._cull_distance or 5000
	self._sides = self._sides or 1
	self._gui_movie = self._gui_movie or "default_text"
	self._gui_object = self._gui_object or "gui_name"
	self._font = self._font or "core/fonts/diesel"
	self._blend_mode = self._blend_mode or "normal"
	self._wrap = self._wrap or false
	self._word_wrap = self._word_wrap or false
	self._render_template = self._render_template or "diffuse_vc_decal"
	self._alpha = self._alpha or 1
	self._shape = {
		self._x or 0,
		self._y or 0,
		self._w or self.width or 1,
		self._h or self.height or 1
	}
	self._vertical = self._vertical or "center"
	self._align = self._align or "left"
	self._gui = World:newgui()
	self._default_font = self._font
	self._guis = {}

	if self._sides == 1 then
		self:add_workspace(self._unit:get_object(Idstring(self._gui_object)))
	else
		for i = 1, self._sides, 1 do
			self:add_workspace(self._unit:get_object(Idstring(self._gui_object .. i)))
		end
	end

	local text_object = self._guis[1].gui:child("std_text")
	self._font_size = text_object:font_size()

	self:set_font_size(self._font_size)

	self._font_color = Vector3(text_object:color().red, text_object:color().green, text_object:color().blue)
end

-- Lines: 46 to 66
function CoreEditableGui:add_workspace(gui_object)
	local ws = self._gui:create_object_workspace(0, 0, gui_object, Vector3(0, 0, 0))
	local gui = ws:panel():gui(Idstring("core/guis/core_editable_gui"))
	local panel = gui:panel()

	gui:child("std_text"):set_wrap(self._wrap)
	gui:child("std_text"):set_word_wrap(self._word_wrap)
	gui:child("std_text"):set_blend_mode(self._blend_mode)
	gui:child("std_text"):set_font(Idstring(self._font))
	gui:child("std_text"):set_text(self._text)
	gui:child("std_text"):set_render_template(Idstring(self._render_template))
	gui:child("std_text"):set_align(self._align)
	gui:child("std_text"):set_vertical(self._vertical)
	gui:child("std_text"):set_alpha(self._alpha)
	gui:child("std_text"):set_shape(self._shape[1] * gui:w(), self._shape[2] * gui:h(), self._shape[3] * gui:w(), self._shape[4] * gui:h())
	table.insert(self._guis, {
		workspace = ws,
		gui = gui,
		panel = panel
	})
end

-- Lines: 68 to 69
function CoreEditableGui:text()
	return self._text
end

-- Lines: 72 to 83
function CoreEditableGui:set_text(text)
	text = text or ""
	self._text = text

	if managers.localization then
		text = managers.localization:format_text(text)
	end

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_text(text)
	end
end

-- Lines: 85 to 86
function CoreEditableGui:default_font()
	return self._default_font
end

-- Lines: 89 to 90
function CoreEditableGui:font()
	return self._font
end

-- Lines: 93 to 99
function CoreEditableGui:set_font(font)
	self._font = font or self._font

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_font(Idstring(self._font))
	end

	self:set_font_size(self._font_size)
end

-- Lines: 101 to 102
function CoreEditableGui:font_size()
	return self._font_size
end

-- Lines: 105 to 110
function CoreEditableGui:set_font_size(font_size)
	self._font_size = font_size or self._font_size

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_font_size(self._font_size * (10 * gui.gui:child("std_text"):height()) / 100)
	end
end

-- Lines: 112 to 113
function CoreEditableGui:font_color()
	return self._font_color
end

-- Lines: 116 to 121
function CoreEditableGui:set_font_color(font_color)
	self._font_color = font_color or self._font_color

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_color(Color(1, self._font_color.x, self._font_color.y, self._font_color.z))
	end
end

-- Lines: 123 to 124
function CoreEditableGui:align()
	return self._align
end

-- Lines: 127 to 132
function CoreEditableGui:set_align(align)
	self._align = align or self._align

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_align(self._align)
	end
end

-- Lines: 134 to 135
function CoreEditableGui:vertical()
	return self._vertical
end

-- Lines: 138 to 143
function CoreEditableGui:set_vertical(vertical)
	self._vertical = vertical or self._vertical

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_vertical(self._vertical)
	end
end

-- Lines: 145 to 150
function CoreEditableGui:set_blend_mode(blend_mode)
	self._blend_mode = blend_mode or self._blend_mode

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_blend_mode(self._blend_mode)
	end
end

-- Lines: 152 to 153
function CoreEditableGui:blend_mode()
	return self._blend_mode
end

-- Lines: 156 to 161
function CoreEditableGui:set_render_template(render_template)
	self._render_template = render_template or self._render_template

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_render_template(Idstring(self._render_template))
	end
end

-- Lines: 163 to 164
function CoreEditableGui:render_template()
	return self._render_template
end

-- Lines: 168 to 177
function CoreEditableGui:set_wrap(wrap)
	if wrap == nil then
		return
	end

	self._wrap = wrap

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_wrap(self._wrap)
	end
end

-- Lines: 179 to 180
function CoreEditableGui:wrap()
	return self._wrap
end

-- Lines: 183 to 192
function CoreEditableGui:set_word_wrap(word_wrap)
	if word_wrap == nil then
		return
	end

	self._word_wrap = word_wrap

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_word_wrap(self._word_wrap)
	end
end

-- Lines: 194 to 195
function CoreEditableGui:word_wrap()
	return self._word_wrap
end

-- Lines: 198 to 203
function CoreEditableGui:set_alpha(alpha)
	self._alpha = alpha or self._alpha

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_alpha(self._alpha)
	end
end

-- Lines: 205 to 206
function CoreEditableGui:alpha()
	return self._alpha
end

-- Lines: 209 to 216
function CoreEditableGui:set_shape(shape)
	self._shape = shape or self._shape

	for _, gui in ipairs(self._guis) do
		gui.gui:child("std_text"):set_shape(self._shape[1] * gui.gui:w(), self._shape[2] * gui.gui:h(), self._shape[3] * gui.gui:w(), self._shape[4] * gui.gui:h())
	end

	self:set_font_size()
end

-- Lines: 218 to 219
function CoreEditableGui:shape()
	return self._shape
end

-- Lines: 230 to 231
function CoreEditableGui:set_debug(enabled)
end

-- Lines: 234 to 242
function CoreEditableGui:on_unit_set_enabled(enabled)
	for _, gui in ipairs(self._guis) do
		if enabled then
			gui.workspace:show()
		else
			gui.workspace:hide()
		end
	end
end

-- Lines: 244 to 249
function CoreEditableGui:lock_gui()
	for _, gui in ipairs(self._guis) do
		gui.workspace:set_cull_distance(self._cull_distance)
		gui.workspace:set_frozen(true)
	end
end

-- Lines: 251 to 258
function CoreEditableGui:destroy()
	for _, gui in ipairs(self._guis) do
		if alive(self._gui) and alive(gui.workspace) then
			self._gui:destroy_workspace(gui.workspace)
		end
	end

	self._guis = nil
end

