core:module("CoreSubtitlePresenter")
core:import("CoreClass")
core:import("CoreCode")
core:import("CoreEvent")
core:import("CoreDebug")
core:import("CoreSubtitleSequence")

SubtitlePresenter = SubtitlePresenter or CoreClass.class()
DebugPresenter = DebugPresenter or CoreClass.class(SubtitlePresenter)
OverlayPresenter = OverlayPresenter or CoreClass.class(SubtitlePresenter)

-- Lines: 18 to 19
function SubtitlePresenter:destroy()
end

-- Lines: 22 to 23
function SubtitlePresenter:update(time, delta_time)
end

-- Lines: 26 to 27
function SubtitlePresenter:show()
end

-- Lines: 30 to 31
function SubtitlePresenter:hide()
end

-- Lines: 35 to 36
function SubtitlePresenter:show_text(text, duration)
end

-- Lines: 40 to 41
function SubtitlePresenter:preprocess_sequence(sequence)
	return sequence
end

-- Lines: 49 to 51
function DebugPresenter:destroy()
	CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter is destroyed."))
end

-- Lines: 53 to 55
function DebugPresenter:show()
	CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter is shown."))
end

-- Lines: 57 to 59
function DebugPresenter:hide()
	CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter hides."))
end

-- Lines: 61 to 63
function DebugPresenter:show_text(text, duration)
	CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter displays \"%s\" %s.", text, duration and string.format("for %g seconds", duration) or "until further notice"))
end

-- Lines: 69 to 73
function OverlayPresenter:init(font_name, font_size)
	self:set_font(font_name or self:_default_font_name(), font_size or self:_default_font_size())
	self:_clear_workspace()

	self.__resolution_changed_id = managers.viewport:add_resolution_changed_func(CoreEvent.callback(self, self, "_on_resolution_changed"))
end

-- Lines: 75 to 91
function OverlayPresenter:destroy()
	if self.__resolution_changed_id and managers.viewport then
		managers.viewport:remove_resolution_changed_func(self.__resolution_changed_id)
	end

	self.__resolution_changed_id = nil

	if CoreCode.alive(self.__subtitle_panel) then
		self.__subtitle_panel:stop()
		self.__subtitle_panel:clear()
	end

	self.__subtitle_panel = nil

	if CoreCode.alive(self.__ws) then
		self.__ws:gui():destroy_workspace(self.__ws)
	end

	self.__ws = nil
end

-- Lines: 93 to 95
function OverlayPresenter:show()
	self.__ws:show()
end

-- Lines: 97 to 99
function OverlayPresenter:hide()
	self.__ws:hide()
end

-- Lines: 101 to 105
function OverlayPresenter:set_debug(enabled)
	if self.__ws then
		self.__ws:panel():set_debug(enabled)
	end
end

-- Lines: 107 to 129
function OverlayPresenter:set_font(font_name, font_size)
	self.__font_name = assert(tostring(font_name), "Invalid font name parameter.")
	self.__font_size = assert(tonumber(font_size), "Invalid font size parameter.")

	if self.__subtitle_panel then
		for _, ui_element_name in ipairs({
			"layout",
			"label",
			"shadow"
		}) do
			local ui_element = self.__subtitle_panel:child(ui_element_name)

			if ui_element then
				ui_element:set_font(Idstring(self.__font_name))
				ui_element:set_font_size(self.__font_size)
			end
		end
	end

	local string_width_measure_text_field = CoreCode.alive(self.__ws) and self.__ws:panel():child("string_width")

	if string_width_measure_text_field then
		string_width_measure_text_field:set_font(Idstring(self.__font_name))
		string_width_measure_text_field:set_font_size(self.__font_size)
	end
end

-- Lines: 132 to 139
function OverlayPresenter:set_width(pixels)
	local safe_width = self:_gui_width()
	self.__width = math.min(pixels, safe_width)

	if CoreCode.alive(self.__subtitle_panel) then
		self:_layout_text_field():set_width(self.__width)
	end
end

-- Lines: 141 to 146
function OverlayPresenter:show_text(text, duration)
	local label = self.__subtitle_panel:child("label") or self.__subtitle_panel:text({
		name = "label",
		vertical = "bottom",
		word_wrap = true,
		wrap = true,
		align = "center",
		y = 1,
		x = 1,
		layer = 1,
		font = self.__font_name,
		font_size = self.__font_size,
		color = Color.white
	})
	local shadow = self.__subtitle_panel:child("shadow") or self.__subtitle_panel:text({
		y = 2,
		name = "shadow",
		vertical = "bottom",
		wrap = true,
		align = "center",
		word_wrap = true,
		visible = false,
		x = 2,
		layer = 0,
		font = self.__font_name,
		font_size = self.__font_size,
		color = Color.black:with_alpha(0.5)
	})

	label:set_text(text)
	shadow:set_text(text)
end

-- Lines: 148 to 166
function OverlayPresenter:preprocess_sequence(sequence)
	local new_sequence = CoreSubtitleSequence.SubtitleSequence:new()

	for _, subtitle in ipairs(sequence:subtitles()) do
		local subtitle_string = subtitle:string()
		local wrapped_lines = self:_split_string_into_lines(subtitle_string, sequence)
		local lines_per_batch = 2
		local batch_count = math.max(math.ceil(#wrapped_lines / lines_per_batch), 1)
		local batch_duration = subtitle:duration() / batch_count
		local batch = 0

		for line = 1, batch_count * lines_per_batch, 2 do
			local wrapped_string = table.concat({
				wrapped_lines[line],
				wrapped_lines[line + 1]
			}, "\n")

			new_sequence:add_subtitle(CoreSubtitleSequence.Subtitle:new(wrapped_string, subtitle:start_time() + batch_duration * batch, batch_duration))

			batch = batch + 1
		end
	end

	return new_sequence
end

-- Lines: 169 to 179
function OverlayPresenter:_clear_workspace()
	if CoreCode.alive(self.__ws) then
		managers.gui_data:destroy_workspace(self.__ws)
	end

	self.__ws = managers.gui_data:create_saferect_workspace("screen", Overlay:gui())
	self.__subtitle_panel = self.__ws:panel():panel({layer = 150})

	self:_on_resolution_changed()
end

-- Lines: 183 to 184
function OverlayPresenter:_split_string_into_lines(subtitle_string, owning_sequence)
	return self:_auto_word_wrap_string(subtitle_string)
end

-- Lines: 187 to 200
function OverlayPresenter:_auto_word_wrap_string(subtitle_string)
	local layout_text_field = self:_layout_text_field()

	layout_text_field:set_text(subtitle_string)

	local line_breaks = table.collect(layout_text_field:line_breaks(), function (index)
		return index + 1
	end)
	local wrapped_lines = {}

	for line = 1, #line_breaks, 1 do
		local range_start = line_breaks[line]
		local range_end = line_breaks[line + 1]
		local string_range = utf8.sub(subtitle_string, range_start, (range_end or 0) - 1)

		table.insert(wrapped_lines, string.trim(string_range))
	end

	return wrapped_lines
end

-- Lines: 203 to 205
function OverlayPresenter:_layout_text_field()
	assert(self.__subtitle_panel)

	return self.__subtitle_panel:child("layout") or self.__subtitle_panel:text({
		name = "layout",
		vertical = "bottom",
		word_wrap = true,
		wrap = true,
		align = "center",
		visible = false,
		width = self.__width,
		font = self.__font_name,
		font_size = self.__font_size
	})
end

-- Lines: 208 to 212
function OverlayPresenter:_string_width(subtitle_string)
	local string_width_measure_text_field = self.__ws:panel():child("string_width") or self.__ws:panel():text({
		name = "string_width",
		wrap = false,
		visible = false,
		font = self.__font_name,
		font_size = self.__font_size
	})

	string_width_measure_text_field:set_text(subtitle_string)

	local x, y, width, height = string_width_measure_text_field:text_rect()

	return width
end

-- Lines: 215 to 246
function OverlayPresenter:_on_resolution_changed()
	self:set_font(self.__font_name or self:_default_font_name(), self.__font_size or self:_default_font_size())

	local width = self:_gui_width()
	local height = self:_gui_height()
	local safe_rect = managers.gui_data:corner_scaled_size()

	managers.gui_data:layout_corner_saferect_workspace(self.__ws)
	self.__subtitle_panel:set_width(safe_rect.width)
	self.__subtitle_panel:set_height(safe_rect.height - 120)
	self.__subtitle_panel:set_x(0)
	self.__subtitle_panel:set_y(0)
	self:set_width(self:_string_width("The quick brown fox jumped over the lazy dog bla bla bla bla bla bla bla bla bla blah blah blah blah blah ."))

	local label = self.__subtitle_panel:child("label")

	if label then
		label:set_h(self.__subtitle_panel:h())
		label:set_w(self.__subtitle_panel:w())
	end

	local shadow = self.__subtitle_panel:child("shadow")

	if shadow then
		shadow:set_h(self.__subtitle_panel:h())
		shadow:set_w(self.__subtitle_panel:w())
	end
end

-- Lines: 248 to 249
function OverlayPresenter:_gui_width()
	return self.__subtitle_panel:width()
end

-- Lines: 253 to 254
function OverlayPresenter:_gui_height()
	return self.__subtitle_panel:width()
end

-- Lines: 257 to 258
function OverlayPresenter:_default_font_name()
	return "core/fonts/system_font"
end

-- Lines: 261 to 262
function OverlayPresenter:_default_font_size()
	return 22
end

