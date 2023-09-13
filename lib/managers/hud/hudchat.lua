HUDChat = HUDChat or class()
HUDChat.line_height = 21
HUDChat.max_lines = 10

-- Lines 5-52
function HUDChat:init(ws, hud)
	self._ws = ws
	self._hud_panel = hud.panel

	self:set_channel_id(ChatManager.GAME)

	self._output_width = 300
	self._panel_width = 500
	self._lines = {}
	self._esc_callback = callback(self, self, "esc_key_callback")
	self._enter_callback = callback(self, self, "enter_key_callback")
	self._typing_callback = 0
	self._skip_first = false
	self._panel = self._hud_panel:panel({
		name = "chat_panel",
		h = 500,
		halign = "left",
		x = 0,
		valign = "bottom",
		w = self._panel_width
	})

	self._panel:set_bottom(self._panel:parent():h() - 112)

	local output_panel = self._panel:panel({
		name = "output_panel",
		h = 10,
		x = 0,
		layer = 1,
		w = self._output_width
	})

	output_panel:gradient({
		blend_mode = "sub",
		name = "output_bg",
		valign = "grow",
		layer = -1,
		gradient_points = {
			0,
			Color.white:with_alpha(0),
			0.2,
			Color.white:with_alpha(0.25),
			1,
			Color.white:with_alpha(0)
		}
	})

	local scroll_panel = output_panel:panel({
		name = "scroll_panel",
		x = 0,
		h = 10,
		w = self._output_width
	})
	self._scroll_indicator_box_class = BoxGuiObject:new(output_panel, {
		sides = {
			0,
			0,
			0,
			0
		}
	})
	local scroll_up_indicator_shade = output_panel:bitmap({
		texture = "guis/textures/headershadow",
		name = "scroll_up_indicator_shade",
		visible = false,
		rotation = 180,
		layer = 2,
		color = Color.white,
		w = output_panel:w()
	})
	local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar_arrow")
	local scroll_up_indicator_arrow = self._panel:bitmap({
		name = "scroll_up_indicator_arrow",
		layer = 2,
		texture = texture,
		texture_rect = rect,
		color = Color.white
	})
	local scroll_down_indicator_shade = output_panel:bitmap({
		texture = "guis/textures/headershadow",
		name = "scroll_down_indicator_shade",
		visible = false,
		layer = 2,
		color = Color.white,
		w = output_panel:w()
	})
	local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar_arrow")
	local scroll_down_indicator_arrow = self._panel:bitmap({
		name = "scroll_down_indicator_arrow",
		layer = 2,
		rotation = 180,
		texture = texture,
		texture_rect = rect,
		color = Color.white
	})
	local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()
	local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar")
	local scroll_bar = self._panel:panel({
		w = 15,
		name = "scroll_bar",
		layer = 2,
		h = bar_h
	})
	local scroll_bar_box_panel = scroll_bar:panel({
		name = "scroll_bar_box_panel",
		halign = "scale",
		w = 4,
		x = 5,
		valign = "scale"
	})
	self._scroll_bar_box_class = BoxGuiObject:new(scroll_bar_box_panel, {
		sides = {
			2,
			2,
			0,
			0
		}
	})

	output_panel:set_x(scroll_down_indicator_arrow:w() + 4)
	self:_create_input_panel()
	self:_layout_input_panel()
	self:_layout_output_panel(true)
end

-- Lines 54-56
function HUDChat:set_layer(layer)
	self._panel:set_layer(layer)
end

-- Lines 58-62
function HUDChat:set_channel_id(channel_id)
	managers.chat:unregister_receiver(self._channel_id, self)

	self._channel_id = channel_id

	managers.chat:register_receiver(self._channel_id, self)
end

-- Lines 64-68
function HUDChat:esc_key_callback()
	managers.hud:set_chat_focus(false)
end

-- Lines 71-85
function HUDChat:enter_key_callback()
	local text = self._input_panel:child("input_text")
	local message = text:text()

	if string.len(message) > 0 then
		local u_name = managers.network.account:username()

		managers.chat:send_message(self._channel_id, u_name or "Offline", message)
	end

	text:set_text("")
	text:set_selection(0, 0)
	managers.hud:set_chat_focus(false)
end

-- Lines 87-112
function HUDChat:_create_input_panel()
	self._input_panel = self._panel:panel({
		name = "input_panel",
		h = 24,
		alpha = 0,
		x = 0,
		layer = 1,
		w = self._panel_width
	})

	self._input_panel:rect({
		name = "focus_indicator",
		layer = 0,
		visible = false,
		color = Color.white:with_alpha(0.2)
	})

	local say = self._input_panel:text({
		y = 0,
		name = "say",
		vertical = "center",
		hvertical = "center",
		align = "left",
		blend_mode = "normal",
		halign = "left",
		x = 0,
		layer = 1,
		text = utf8.to_upper(managers.localization:text("debug_chat_say")),
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = Color.white
	})
	local _, _, w, h = say:text_rect()

	say:set_size(w, self._input_panel:h())

	local input_text = self._input_panel:text({
		y = 0,
		name = "input_text",
		vertical = "center",
		wrap = true,
		align = "left",
		blend_mode = "normal",
		hvertical = "center",
		text = "",
		word_wrap = false,
		halign = "left",
		x = 0,
		layer = 1,
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = Color.white
	})
	local caret = self._input_panel:rect({
		name = "caret",
		h = 0,
		y = 0,
		w = 0,
		x = 0,
		layer = 2,
		color = Color(0.05, 1, 1, 1)
	})

	if _G.IS_VR then
		say:set_visible(false)
		caret:set_visible(false)
	end

	self._input_panel:gradient({
		blend_mode = "sub",
		name = "input_bg",
		valign = "grow",
		layer = -1,
		gradient_points = {
			0,
			Color.white:with_alpha(0),
			0.2,
			Color.white:with_alpha(0.25),
			1,
			Color.white:with_alpha(0)
		},
		h = self._input_panel:h()
	})
end

-- Lines 114-162
function HUDChat:_layout_output_panel(force_update_scroll_indicators)
	local output_panel = self._panel:child("output_panel")
	local scroll_panel = output_panel:child("scroll_panel")

	scroll_panel:set_w(self._output_width)
	output_panel:set_w(self._output_width)

	local line_height = HUDChat.line_height
	local max_lines = HUDChat.max_lines
	local lines = 0

	for i = #self._lines, 1, -1 do
		local line = self._lines[i][1]
		local icon = self._lines[i][2]

		line:set_w(output_panel:w() - line:left())

		local _, _, w, h = line:text_rect()

		line:set_h(h)

		lines = lines + line:number_of_lines()
	end

	local scroll_at_bottom = scroll_panel:bottom() == output_panel:h()

	output_panel:set_h(line_height * math.min(max_lines, lines))
	scroll_panel:set_h(line_height * lines)

	local y = 0

	for i = #self._lines, 1, -1 do
		local line = self._lines[i][1]
		local icon = self._lines[i][2]
		local _, _, w, h = line:text_rect()

		line:set_bottom(scroll_panel:h() - y)

		if icon then
			icon:set_left(icon:left())
			icon:set_top(line:top() + 1)
			line:set_left(icon:right())
		else
			line:set_left(line:left())
		end

		y = y + line_height * line:number_of_lines()
	end

	output_panel:set_bottom(self._input_panel:top())

	if lines <= max_lines or scroll_at_bottom then
		scroll_panel:set_bottom(output_panel:h())
	end

	self:set_scroll_indicators(force_update_scroll_indicators)
end

-- Lines 164-176
function HUDChat:_layout_input_panel()
	self._input_panel:set_w(self._panel_width)

	local say = self._input_panel:child("say")
	local input_text = self._input_panel:child("input_text")

	input_text:set_left(say:right() + 4)
	input_text:set_w(self._input_panel:w() - input_text:left())

	local focus_indicator = self._input_panel:child("focus_indicator")

	focus_indicator:set_shape(input_text:shape())
	self._input_panel:set_y(self._input_panel:parent():h() - self._input_panel:h())
end

-- Lines 178-232
function HUDChat:set_scroll_indicators(force_update_scroll_indicators)
	local output_panel = self._panel:child("output_panel")
	local scroll_panel = output_panel:child("scroll_panel")
	local scroll_up_indicator_shade = output_panel:child("scroll_up_indicator_shade")
	local scroll_up_indicator_arrow = self._panel:child("scroll_up_indicator_arrow")
	local scroll_down_indicator_shade = output_panel:child("scroll_down_indicator_shade")
	local scroll_down_indicator_arrow = self._panel:child("scroll_down_indicator_arrow")
	local scroll_bar = self._panel:child("scroll_bar")

	scroll_up_indicator_shade:set_top(0)
	scroll_down_indicator_shade:set_bottom(output_panel:h())
	scroll_up_indicator_arrow:set_righttop(output_panel:left() - 2, output_panel:top() + 2)
	scroll_down_indicator_arrow:set_rightbottom(output_panel:left() - 2, output_panel:bottom() - 2)

	local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()

	if scroll_panel:h() ~= 0 then
		local old_h = scroll_bar:h()

		scroll_bar:set_h(bar_h * output_panel:h() / scroll_panel:h())

		if old_h ~= scroll_bar:h() then
			self._scroll_bar_box_class:create_sides(scroll_bar:child("scroll_bar_box_panel"), {
				sides = {
					2,
					2,
					0,
					0
				}
			})
		end
	end

	local sh = scroll_panel:h() ~= 0 and scroll_panel:h() or 1

	scroll_bar:set_y(scroll_up_indicator_arrow:bottom() - scroll_panel:y() * (output_panel:h() - scroll_up_indicator_arrow:h() * 2) / sh)
	scroll_bar:set_center_x(scroll_up_indicator_arrow:center_x())

	local visible = output_panel:h() < scroll_panel:h() and self._focus
	local scroll_up_visible = visible and scroll_panel:top() < 0
	local scroll_dn_visible = visible and output_panel:h() < scroll_panel:bottom()

	self:_layout_input_panel()
	scroll_bar:set_visible(visible)

	local update_scroll_indicator_box = force_update_scroll_indicators or false

	if scroll_up_indicator_arrow:visible() ~= scroll_up_visible then
		scroll_up_indicator_shade:set_visible(false)
		scroll_up_indicator_arrow:set_visible(scroll_up_visible)

		update_scroll_indicator_box = true
	end

	if scroll_down_indicator_arrow:visible() ~= scroll_dn_visible then
		scroll_down_indicator_shade:set_visible(false)
		scroll_down_indicator_arrow:set_visible(scroll_dn_visible)

		update_scroll_indicator_box = true
	end

	if update_scroll_indicator_box then
		self._scroll_indicator_box_class:create_sides(output_panel, {
			sides = {
				0,
				0,
				scroll_up_visible and 2 or 0,
				scroll_dn_visible and 2 or 0
			}
		})
	end
end

-- Lines 234-242
function HUDChat:scroll_up()
	local output_panel = self._panel:child("output_panel")
	local scroll_panel = output_panel:child("scroll_panel")

	if output_panel:h() < scroll_panel:h() then
		scroll_panel:set_top(math.min(0, scroll_panel:top() + HUDChat.line_height))

		return true
	end
end

-- Lines 244-252
function HUDChat:scroll_down()
	local output_panel = self._panel:child("output_panel")
	local scroll_panel = output_panel:child("scroll_panel")

	if output_panel:h() < scroll_panel:h() then
		scroll_panel:set_bottom(math.max(scroll_panel:bottom() - HUDChat.line_height, output_panel:h()))

		return true
	end
end

-- Lines 255-261
function HUDChat:input_focus()
	return self._focus
end

-- Lines 291-293
function HUDChat:set_skip_first(skip_first)
	self._skip_first = skip_first
end

-- Lines 295-339
function HUDChat:_on_focus()
	if self._focus then
		return
	end

	local output_panel = self._panel:child("output_panel")

	output_panel:stop()
	output_panel:animate(callback(self, self, "_animate_show_output"), output_panel:alpha())
	self._input_panel:stop()
	self._input_panel:animate(callback(self, self, "_animate_show_component"))

	self._focus = true

	self._input_panel:child("focus_indicator"):set_color(Color(0.8, 1, 0.8):with_alpha(0.2))
	self._ws:connect_keyboard(Input:keyboard())

	if _G.IS_VR then
		Input:keyboard():show()
	end

	self._input_panel:key_press(callback(self, self, "key_press"))
	self._input_panel:key_release(callback(self, self, "key_release"))

	self._enter_text_set = false

	self._input_panel:child("input_bg"):animate(callback(self, self, "_animate_input_bg"))
	self:set_scroll_indicators(true)
	self:set_layer(1100)
	self:update_caret()
end

-- Lines 341-374
function HUDChat:_loose_focus()
	if not self._focus then
		return
	end

	self._focus = false

	self._input_panel:child("focus_indicator"):set_color(Color.white:with_alpha(0.2))
	self._ws:disconnect_keyboard()
	self._input_panel:key_press(nil)
	self._input_panel:enter_text(nil)
	self._input_panel:key_release(nil)
	self._panel:child("output_panel"):stop()
	self._panel:child("output_panel"):animate(callback(self, self, "_animate_fade_output"))
	self._input_panel:stop()
	self._input_panel:animate(callback(self, self, "_animate_hide_input"))

	local text = self._input_panel:child("input_text")

	text:stop()
	self._input_panel:child("input_bg"):stop()

	local output_panel = self._panel:child("output_panel")
	local scroll_panel = output_panel:child("scroll_panel")

	scroll_panel:set_bottom(output_panel:h())
	self:set_scroll_indicators()
	self:set_layer(1)
	self:update_caret()
end

-- Lines 376-383
function HUDChat:clear()
	local text = self._input_panel:child("input_text")

	text:set_text("")
	text:set_selection(0, 0)
	self:_loose_focus()
	managers.hud:set_chat_focus(false)
end

-- Lines 385-388
function HUDChat:_shift()
	local k = Input:keyboard()

	return k:down("left shift") or k:down("right shift") or k:has_button("shift") and k:down("shift")
end

-- Lines 391-398
function HUDChat.blink(o)
	while true do
		o:set_color(Color(0, 1, 1, 1))
		wait(0.3)
		o:set_color(Color.white)
		wait(0.3)
	end
end

-- Lines 400-407
function HUDChat:set_blinking(b)
	local caret = self._input_panel:child("caret")

	if b == self._blinking then
		return
	end

	if b then
		caret:animate(self.blink)
	else
		caret:stop()
	end

	self._blinking = b

	if not self._blinking then
		caret:set_color(Color.white)
	end
end

-- Lines 409-438
function HUDChat:update_caret()
	local text = self._input_panel:child("input_text")
	local caret = self._input_panel:child("caret")
	local s, e = text:selection()
	local x, y, w, h = text:selection_rect()

	if s == 0 and e == 0 then
		if text:align() == "center" then
			x = text:world_x() + text:w() / 2
		else
			x = text:world_x()
		end

		y = text:world_y()
	end

	h = text:h()

	if w < 3 then
		w = 3
	end

	if not self._focus then
		w = 0
		h = 0
	end

	caret:set_world_shape(x, y + 2, w, h - 4)
	self:set_blinking(s == e and self._focus)

	local mid = x / self._input_panel:child("input_bg"):w()

	self._input_panel:child("input_bg"):set_gradient_points({
		0,
		Color.white:with_alpha(0),
		mid,
		Color.white:with_alpha(0.25),
		1,
		Color.white:with_alpha(0)
	})
end

-- Lines 441-471
function HUDChat:enter_text(o, s)
	if managers.hud and managers.hud:showing_stats_screen() then
		return
	end

	if self._skip_first then
		self._skip_first = false

		return
	end

	local text = self._input_panel:child("input_text")

	if type(self._typing_callback) ~= "number" then
		self._typing_callback()
	end

	text:replace_text(s)

	local lbs = text:line_breaks()

	if #lbs > 1 then
		local s = lbs[2]
		local e = utf8.len(text:text())

		text:set_selection(s, e)
		text:replace_text("")
	end

	self:update_caret()
end

-- Lines 474-537
function HUDChat:update_key_down(o, k)
	wait(0.6)

	local text = self._input_panel:child("input_text")

	while self._key_pressed == k do
		local s, e = text:selection()
		local n = utf8.len(text:text())
		local d = math.abs(e - s)

		if self._key_pressed == Idstring("backspace") then
			if s == e and s > 0 then
				text:set_selection(s - 1, e)
			end

			text:replace_text("")

			if utf8.len(text:text()) < 1 and type(self._esc_callback) ~= "number" then
				-- Nothing
			end
		elseif self._key_pressed == Idstring("delete") then
			if s == e and s < n then
				text:set_selection(s, e + 1)
			end

			text:replace_text("")

			if utf8.len(text:text()) < 1 and type(self._esc_callback) ~= "number" then
				-- Nothing
			end
		elseif self._key_pressed == Idstring("insert") then
			local clipboard = Application:get_clipboard() or ""

			text:replace_text(clipboard)

			local lbs = text:line_breaks()

			if #lbs > 1 then
				local s = lbs[2]
				local e = utf8.len(text:text())

				text:set_selection(s, e)
				text:replace_text("")
			end
		elseif self._key_pressed == Idstring("left") then
			if s < e then
				text:set_selection(s, s)
			elseif s > 0 then
				text:set_selection(s - 1, s - 1)
			end
		elseif self._key_pressed == Idstring("right") then
			if s < e then
				text:set_selection(e, e)
			elseif s < n then
				text:set_selection(s + 1, s + 1)
			end
		elseif self._key_pressed == Idstring("up") then
			self:scroll_up()
			self:set_scroll_indicators()
		elseif self._key_pressed == Idstring("down") then
			self:scroll_down()
			self:set_scroll_indicators()
		else
			self._key_pressed = false
		end

		self:update_caret()
		wait(0.03)
	end
end

-- Lines 539-543
function HUDChat:key_release(o, k)
	if self._key_pressed == k then
		self._key_pressed = false
	end
end

-- Lines 546-637
function HUDChat:key_press(o, k)
	if self._skip_first then
		self._skip_first = false

		return
	end

	if not self._enter_text_set then
		self._input_panel:enter_text(callback(self, self, "enter_text"))

		self._enter_text_set = true
	end

	local text = self._input_panel:child("input_text")
	local s, e = text:selection()
	local n = utf8.len(text:text())
	local d = math.abs(e - s)
	self._key_pressed = k

	text:stop()
	text:animate(callback(self, self, "update_key_down"), k)

	if k == Idstring("backspace") then
		if s == e and s > 0 then
			text:set_selection(s - 1, e)
		end

		text:replace_text("")

		if utf8.len(text:text()) < 1 and type(self._esc_callback) ~= "number" then
			-- Nothing
		end
	elseif k == Idstring("delete") then
		if s == e and s < n then
			text:set_selection(s, e + 1)
		end

		text:replace_text("")

		if utf8.len(text:text()) < 1 and type(self._esc_callback) ~= "number" then
			-- Nothing
		end
	elseif k == Idstring("insert") then
		local clipboard = Application:get_clipboard() or ""

		text:replace_text(clipboard)

		local lbs = text:line_breaks()

		if #lbs > 1 then
			local s = lbs[2]
			local e = utf8.len(text:text())

			text:set_selection(s, e)
			text:replace_text("")
		end
	elseif k == Idstring("left") then
		if s < e then
			text:set_selection(s, s)
		elseif s > 0 then
			text:set_selection(s - 1, s - 1)
		end
	elseif k == Idstring("right") then
		if s < e then
			text:set_selection(e, e)
		elseif s < n then
			text:set_selection(s + 1, s + 1)
		end
	elseif k == Idstring("up") then
		self:scroll_up()
		self:set_scroll_indicators()
	elseif k == Idstring("down") then
		self:scroll_down()
		self:set_scroll_indicators()
	elseif self._key_pressed == Idstring("end") then
		text:set_selection(n, n)
	elseif self._key_pressed == Idstring("home") then
		text:set_selection(0, 0)
	elseif k == Idstring("enter") then
		if type(self._enter_callback) ~= "number" then
			self._enter_callback()
		end
	elseif k == Idstring("esc") and type(self._esc_callback) ~= "number" then
		text:set_text("")
		text:set_selection(0, 0)
		self._esc_callback()
	end

	self:update_caret()
end

-- Lines 641-643
function HUDChat:send_message(name, message)
end

-- Lines 645-691
function HUDChat:receive_message(name, message, color, icon)
	local output_panel = self._panel:child("output_panel")
	local scroll_panel = output_panel:child("scroll_panel")
	local len = utf8.len(name) + 1
	local x = 0
	local icon_bitmap = nil

	if icon then
		local icon_texture, icon_texture_rect = tweak_data.hud_icons:get_icon_data(icon)
		icon_bitmap = scroll_panel:bitmap({
			y = 1,
			texture = icon_texture,
			texture_rect = icon_texture_rect,
			color = color
		})
		x = icon_bitmap:right()
	end

	local line = scroll_panel:text({
		halign = "left",
		vertical = "top",
		hvertical = "top",
		wrap = true,
		align = "left",
		blend_mode = "normal",
		word_wrap = true,
		y = 0,
		layer = 0,
		text = name .. ": " .. message,
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		x = x,
		color = color
	})
	local total_len = utf8.len(line:text())

	line:set_range_color(0, len, color)
	line:set_range_color(len, total_len, Color.white)

	local _, _, w, h = line:text_rect()

	line:set_h(h)
	table.insert(self._lines, {
		line,
		icon_bitmap
	})
	line:set_kern(line:kern())
	self:_layout_output_panel()

	if not self._focus then
		scroll_panel:set_bottom(output_panel:h())
		self:set_scroll_indicators()
	end

	if not self._focus then
		local output_panel = self._panel:child("output_panel")

		output_panel:stop()
		output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
		output_panel:animate(callback(self, self, "_animate_fade_output"))
	end
end

-- Lines 693-704
function HUDChat:_animate_show_output(o, start_alpha)
	local TOTAL_T = 0.25
	local t = 0
	start_alpha = start_alpha or 0

	while t < TOTAL_T do
		local dt = coroutine.yield()
		t = t + dt

		self:set_output_alpha(start_alpha + t / TOTAL_T * (1 - start_alpha))
	end

	self:set_output_alpha(1)
end

-- Lines 706-721
function HUDChat:_animate_fade_output()
	local wait_t = 10
	local fade_t = 1
	local t = 0

	while wait_t > t do
		local dt = coroutine.yield()
		t = t + dt
	end

	local t = 0

	while fade_t > t do
		local dt = coroutine.yield()
		t = t + dt

		self:set_output_alpha(1 - t / fade_t)
	end

	self:set_output_alpha(0)
end

-- Lines 723-734
function HUDChat:_animate_show_component(input_panel, start_alpha)
	local TOTAL_T = 0.25
	local t = 0
	start_alpha = start_alpha or 0

	while t < TOTAL_T do
		local dt = coroutine.yield()
		t = t + dt

		input_panel:set_alpha(start_alpha + t / TOTAL_T * (1 - start_alpha))
	end

	input_panel:set_alpha(1)
end

-- Lines 736-746
function HUDChat:_animate_hide_input(input_panel)
	local TOTAL_T = 0.25
	local t = 0

	while TOTAL_T > t do
		local dt = coroutine.yield()
		t = t + dt

		input_panel:set_alpha(1 - t / TOTAL_T)
	end

	input_panel:set_alpha(0)
end

-- Lines 748-757
function HUDChat:_animate_input_bg(input_bg)
	local t = 0

	while true do
		local dt = coroutine.yield()
		t = t + dt
		local a = 0.75 + (1 + math.sin(t * 200)) / 8

		input_bg:set_alpha(a)
	end
end

-- Lines 759-777
function HUDChat:set_output_alpha(alpha)
	local output_panel = self._panel:child("output_panel")
	local scroll_bar = self._panel:child("scroll_bar")
	local scroll_up_indicator_shade = output_panel:child("scroll_up_indicator_shade")
	local scroll_up_indicator_arrow = self._panel:child("scroll_up_indicator_arrow")
	local scroll_down_indicator_shade = output_panel:child("scroll_down_indicator_shade")
	local scroll_down_indicator_arrow = self._panel:child("scroll_down_indicator_arrow")

	output_panel:set_alpha(alpha)
	scroll_bar:set_alpha(alpha)
	scroll_up_indicator_shade:set_alpha(alpha)
	scroll_up_indicator_arrow:set_alpha(alpha)
	scroll_down_indicator_shade:set_alpha(alpha)
	scroll_down_indicator_arrow:set_alpha(alpha)
end

-- Lines 779-788
function HUDChat:remove()
	self._panel:child("output_panel"):stop()
	self._input_panel:stop()
	self._hud_panel:remove(self._panel)
	managers.chat:unregister_receiver(self._channel_id, self)
end

if _G.IS_VR then
	require("lib/managers/hud/vr/HUDChatVR")
end
