ScrollablePanel = ScrollablePanel or class()
local PANEL_PADDING = 10
local FADEOUT_SPEED = 5
local SCROLL_SPEED = 28
ScrollablePanel.SCROLL_SPEED = SCROLL_SPEED

-- Lines 9-128
function ScrollablePanel:init(parent_panel, name, data)
	data = data or {}
	self._alphas = {}
	self._x_padding = data.x_padding ~= nil and data.x_padding or data.padding ~= nil and data.padding or PANEL_PADDING
	self._y_padding = data.y_padding ~= nil and data.y_padding or data.padding ~= nil and data.padding or PANEL_PADDING
	self._scrollbar_y_padding = data.scrollbar_y_padding
	self._update = data.update ~= nil and data.update or self._default_update
	self._force_scroll_indicators = data.force_scroll_indicators
	local layer = data.layer ~= nil and data.layer or 50
	data.name = data.name or name and name .. "Base"
	self._panel = parent_panel:panel(data)
	self._scroll_panel = self._panel:panel({
		name = name and name .. "Scroll",
		x = self:x_padding(),
		y = self:y_padding(),
		w = self._panel:w() - self:x_padding() * 2,
		h = self._panel:h() - self:y_padding() * 2
	})
	self._canvas = self._scroll_panel:panel({
		name = name and name .. "Canvas",
		w = self._scroll_panel:w(),
		h = self._scroll_panel:h()
	})

	if data.ignore_up_indicator == nil or not data.ignore_up_indicator then
		local scroll_up_indicator_shade = self:panel():panel({
			halign = "right",
			name = "scroll_up_indicator_shade",
			valign = "top",
			alpha = 0,
			layer = layer,
			x = self:x_padding(),
			y = self:y_padding(),
			w = self:canvas():w()
		})

		BoxGuiObject:new(scroll_up_indicator_shade, {
			sides = {
				0,
				0,
				2,
				0
			}
		}):set_aligns("scale", "scale")
	end

	if data.ignore_down_indicator == nil or not data.ignore_down_indicator then
		local scroll_down_indicator_shade = self:panel():panel({
			valign = "bottom",
			name = "scroll_down_indicator_shade",
			halign = "right",
			alpha = 0,
			layer = layer,
			x = self:x_padding(),
			y = self:y_padding(),
			w = self:canvas():w(),
			h = self:panel():h() - self:y_padding() * 2
		})

		BoxGuiObject:new(scroll_down_indicator_shade, {
			sides = {
				0,
				0,
				0,
				2
			}
		}):set_aligns("scale", "scale")
	end

	local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar_arrow")
	local scroll_up_indicator_arrow = self:panel():bitmap({
		name = "scroll_up_indicator_arrow",
		halign = "right",
		valign = "top",
		alpha = 0,
		texture = texture,
		texture_rect = rect,
		layer = layer,
		color = Color.white
	})

	scroll_up_indicator_arrow:set_top(self:scrollbar_y_padding())
	scroll_up_indicator_arrow:set_right(self:panel():w() - self:scrollbar_x_padding())

	local scroll_down_indicator_arrow = self:panel():bitmap({
		name = "scroll_down_indicator_arrow",
		valign = "bottom",
		alpha = 0,
		halign = "right",
		rotation = 180,
		texture = texture,
		texture_rect = rect,
		layer = layer,
		color = Color.white
	})

	scroll_down_indicator_arrow:set_bottom(self:panel():h() - self:scrollbar_y_padding())
	scroll_down_indicator_arrow:set_right(self:panel():w() - self:scrollbar_x_padding())

	if data.left_scrollbar then
		scroll_up_indicator_arrow:set_left(2)
		scroll_down_indicator_arrow:set_left(2)
	end

	local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()
	self._scroll_bar = self:panel():panel({
		name = "scroll_bar",
		halign = "right",
		w = 4,
		layer = layer - 1,
		h = bar_h
	})
	self._scroll_bar_box_class = BoxGuiObject:new(self._scroll_bar, {
		sides = {
			2,
			2,
			0,
			0
		}
	})

	self._scroll_bar_box_class:set_aligns("scale", "scale")
	self._scroll_bar:set_w(data.scroll_w or 8)
	self._scroll_bar:set_bottom(scroll_down_indicator_arrow:top())
	self._scroll_bar:set_center_x(scroll_down_indicator_arrow:center_x())

	self._bar_minimum_size = data.bar_minimum_size or 5
	self._thread = self._panel:animate(function (o, self)
		while true do
			local dt = coroutine.yield()

			self:_update(dt)
		end
	end, self)
end

-- Lines 130-132
function ScrollablePanel:alive()
	return alive(self:panel())
end

-- Lines 134-136
function ScrollablePanel:panel()
	return self._panel
end

-- Lines 138-140
function ScrollablePanel:scroll_panel()
	return self._scroll_panel
end

-- Lines 142-144
function ScrollablePanel:canvas()
	return self._canvas
end

-- Lines 146-148
function ScrollablePanel:x_padding()
	return self._x_padding
end

-- Lines 150-152
function ScrollablePanel:y_padding()
	return self._y_padding
end

-- Lines 154-160
function ScrollablePanel:scrollbar_x_padding()
	if self._x_padding == 0 then
		return PANEL_PADDING
	else
		return self._x_padding
	end
end

-- Lines 162-170
function ScrollablePanel:scrollbar_y_padding()
	local y_padding = self:y_padding()

	if self._scrollbar_y_padding then
		return y_padding + self._scrollbar_y_padding
	end

	return y_padding + 6
end

-- Lines 172-179
function ScrollablePanel:set_pos(x, y)
	if x ~= nil then
		self:panel():set_x(x)
	end

	if y ~= nil then
		self:panel():set_y(y)
	end
end

-- Lines 181-197
function ScrollablePanel:set_size(w, h)
	self:panel():set_size(w, h)
	self:scroll_panel():set_size(w - self:x_padding() * 2, h - self:y_padding() * 2)

	local scroll_up_indicator_arrow = self:panel():child("scroll_up_indicator_arrow")

	scroll_up_indicator_arrow:set_top(self:scrollbar_y_padding())
	scroll_up_indicator_arrow:set_right(self:panel():w() - self:scrollbar_x_padding())

	local scroll_down_indicator_arrow = self:panel():child("scroll_down_indicator_arrow")

	scroll_down_indicator_arrow:set_bottom(self:panel():h() - self:scrollbar_y_padding())
	scroll_down_indicator_arrow:set_right(self:panel():w() - self:scrollbar_x_padding())
	self._scroll_bar:set_bottom(scroll_down_indicator_arrow:top())
	self._scroll_bar:set_center_x(scroll_down_indicator_arrow:center_x())
end

-- Lines 199-201
function ScrollablePanel:on_canvas_updated_callback(callback)
	self._on_canvas_updated = callback
end

-- Lines 203-205
function ScrollablePanel:canvas_max_width()
	return self:scroll_panel():w()
end

-- Lines 207-209
function ScrollablePanel:canvas_scroll_width()
	return self:scroll_panel():w() - self:x_padding() - 5
end

-- Lines 211-213
function ScrollablePanel:canvas_scroll_height()
	return self:scroll_panel():h()
end

-- Lines 215-252
function ScrollablePanel:update_canvas_size()
	local orig_w = self:canvas():w()
	local max_h = 0

	for i, panel in ipairs(self:canvas():children()) do
		local h = panel:y() + panel:h()

		if max_h < h then
			max_h = h
		end
	end

	local show_scrollbar = self:canvas_scroll_height() < max_h
	local max_w = show_scrollbar and self:canvas_scroll_width() or self:canvas_max_width()

	self:canvas():grow(max_w - self:canvas():w(), max_h - self:canvas():h())

	if self._on_canvas_updated then
		self._on_canvas_updated(max_w)
	end

	max_h = 0

	for i, panel in ipairs(self:canvas():children()) do
		local h = panel:y() + panel:h()

		if max_h < h then
			max_h = h
		end
	end

	if max_h <= self:scroll_panel():h() then
		max_h = self:scroll_panel():h()
	end

	self:set_canvas_size(nil, max_h)
end

-- Lines 254-287
function ScrollablePanel:set_canvas_size(w, h)
	if w == nil then
		w = self:canvas():w()
	end

	if h == nil then
		h = self:canvas():h()
	end

	if h <= self:scroll_panel():h() then
		h = self:scroll_panel():h()

		self:canvas():set_y(0)
	end

	self:canvas():set_size(w, h)

	local show_scrollbar = math.floor(self:scroll_panel():h()) < math.floor(h)

	if not show_scrollbar then
		self._scroll_bar:set_alpha(0)
		self._scroll_bar:set_visible(false)
		self._scroll_bar_box_class:hide()
		self:set_element_alpha_target("scroll_up_indicator_arrow", 0, 100)
		self:set_element_alpha_target("scroll_down_indicator_arrow", 0, 100)
		self:set_element_alpha_target("scroll_up_indicator_shade", 0, 100)
		self:set_element_alpha_target("scroll_down_indicator_shade", 0, 100)
	else
		self._scroll_bar:set_alpha(1)
		self._scroll_bar:set_visible(true)
		self._scroll_bar_box_class:show()
		self:_set_scroll_indicator()
		self:_check_scroll_indicator_states()
	end
end

-- Lines 289-296
function ScrollablePanel:set_element_alpha_target(element, target, speed)
	local element_name = type(element) == "string" and element or element:name()
	self._alphas[element_name] = {
		current = self._alphas[element_name] and self._alphas[element_name].current or element.alpha and element:alpha() or 1,
		target = target,
		speed = speed or self._alphas[element_name] and self._alphas[element_name].speed or 5
	}
end

-- Lines 298-300
function ScrollablePanel:is_scrollable()
	return self:scroll_panel():h() < self:canvas():h()
end

-- Lines 306-311
function ScrollablePanel:scroll(x, y, direction)
	if self:panel():inside(x, y) then
		self:perform_scroll(SCROLL_SPEED * TimerManager:main():delta_time() * 200, direction)

		return true
	end
end

-- Lines 313-327
function ScrollablePanel:perform_scroll(speed, direction)
	if self:canvas():h() <= self:scroll_panel():h() then
		return
	end

	local scroll_amount = speed * direction
	local max_h = self:canvas():h() - self:scroll_panel():h()
	max_h = max_h * -1
	local new_y = math.clamp(self:canvas():y() + scroll_amount, max_h, 0)

	self:canvas():set_y(new_y)
	self:_set_scroll_indicator()
	self:_check_scroll_indicator_states()
end

-- Lines 329-342
function ScrollablePanel:scroll_to(y)
	if self:canvas():h() <= self:scroll_panel():h() then
		return
	end

	local scroll_amount = -y
	local max_h = self:canvas():h() - self:scroll_panel():h()
	max_h = max_h * -1
	local new_y = math.clamp(scroll_amount, max_h, 0)

	self:canvas():set_y(new_y)
	self:_set_scroll_indicator()
	self:_check_scroll_indicator_states()
end

-- Lines 344-364
function ScrollablePanel:scroll_with_bar(target_y, current_y)
	local arrow_size = self:panel():child("scroll_up_indicator_arrow"):size()
	local scroll_panel = self:scroll_panel()
	local canvas = self:canvas()

	if target_y < current_y then
		if target_y < scroll_panel:world_bottom() - arrow_size then
			local mul = (scroll_panel:h() - arrow_size * 2) / canvas:h()

			self:perform_scroll((current_y - target_y) / mul, 1)
		end

		current_y = target_y
	elseif current_y < target_y then
		if target_y > scroll_panel:world_y() + arrow_size then
			local mul = (scroll_panel:h() - arrow_size * 2) / canvas:h()

			self:perform_scroll((target_y - current_y) / mul, -1)
		end

		current_y = target_y
	end
end

-- Lines 366-373
function ScrollablePanel:release_scroll_bar()
	self._pressing_arrow_up = false
	self._pressing_arrow_down = false

	if self._grabbed_scroll_bar then
		self._grabbed_scroll_bar = false

		return true
	end
end

-- Lines 375-380
function ScrollablePanel:_set_scroll_indicator()
	local bar_h = self:panel():child("scroll_down_indicator_arrow"):top() - self:panel():child("scroll_up_indicator_arrow"):bottom()

	if self:canvas():h() ~= 0 then
		self._scroll_bar:set_h(math.max(bar_h * self:scroll_panel():h() / self:canvas():h(), self._bar_minimum_size))
	end
end

-- Lines 382-402
function ScrollablePanel:_check_scroll_indicator_states()
	local up_alpha = math.floor(self:canvas():top()) < 0 and 1 or 0
	local down_alpha = math.floor(self:scroll_panel():h()) < math.floor(self:canvas():bottom()) and 1 or 0

	self:set_element_alpha_target("scroll_up_indicator_arrow", up_alpha, FADEOUT_SPEED)
	self:set_element_alpha_target("scroll_down_indicator_arrow", down_alpha, FADEOUT_SPEED)

	if self:y_padding() > 0 or self._force_scroll_indicators then
		self:set_element_alpha_target("scroll_up_indicator_shade", up_alpha, FADEOUT_SPEED)
		self:set_element_alpha_target("scroll_down_indicator_shade", down_alpha, FADEOUT_SPEED)
	end

	local up_arrow = self:panel():child("scroll_up_indicator_arrow")
	local down_arrow = self:panel():child("scroll_down_indicator_arrow")
	local canvas_h = self:canvas():h() ~= 0 and self:canvas():h() or 1
	local at = self:canvas():top() / (self:scroll_panel():h() - canvas_h)
	local max = down_arrow:top() - up_arrow:bottom() - self._scroll_bar:h()

	self._scroll_bar:set_top(up_arrow:bottom() + max * at)
end

-- Lines 404-415
function ScrollablePanel:reset_scroll_indicator_alphas()
	self:_check_scroll_indicator_states()

	local element = nil

	for element_name, data in pairs(self._alphas) do
		data.current = data.target
		element = self:panel():child(element_name)

		if alive(element) then
			element:set_alpha(data.current)
		end
	end
end

-- Lines 421-432
function ScrollablePanel:_default_update(dt)
	local element, step = nil

	for element_name, data in pairs(self._alphas) do
		step = dt == -1 and 1 or dt * data.speed
		data.current = math.step(data.current, data.target, step)
		element = self:panel():child(element_name)

		if alive(element) then
			element:set_alpha(data.current)
		end
	end
end

-- Lines 434-454
function ScrollablePanel:mouse_moved(button, x, y)
	if self._grabbed_scroll_bar then
		self:scroll_with_bar(y, self._current_y)

		self._current_y = y

		return true, "grab"
	elseif alive(self._scroll_bar) and self._scroll_bar:visible() and self._scroll_bar:inside(x, y) then
		return true, "hand"
	elseif self:panel():child("scroll_up_indicator_arrow"):inside(x, y) then
		if self._pressing_arrow_up then
			self:perform_scroll(SCROLL_SPEED * 0.1, 1)
		end

		return true, self:panel():child("scroll_up_indicator_arrow"):alpha() > 0 and "link" or "arrow"
	elseif self:panel():child("scroll_down_indicator_arrow"):inside(x, y) then
		if self._pressing_arrow_down then
			self:perform_scroll(SCROLL_SPEED * 0.1, -1)
		end

		return true, self:panel():child("scroll_down_indicator_arrow"):alpha() > 0 and "link" or "arrow"
	end
end

-- Lines 456-460
function ScrollablePanel:mouse_clicked(o, button, x, y)
	if alive(self._scroll_bar) and self._scroll_bar:visible() and self._scroll_bar:inside(x, y) then
		return true
	end
end

-- Lines 462-474
function ScrollablePanel:mouse_pressed(button, x, y)
	if alive(self._scroll_bar) and self._scroll_bar:visible() and self._scroll_bar:inside(x, y) then
		self._grabbed_scroll_bar = true
		self._current_y = y

		return true
	elseif self:panel():child("scroll_up_indicator_arrow"):inside(x, y) then
		self._pressing_arrow_up = true

		return true
	elseif self:panel():child("scroll_down_indicator_arrow"):inside(x, y) then
		self._pressing_arrow_down = true

		return true
	end
end

-- Lines 476-478
function ScrollablePanel:mouse_released(button, x, y)
	return self:release_scroll_bar()
end

HorizontalScrollablePanel = HorizontalScrollablePanel or class(ScrollablePanel)
local PANEL_PADDING = 10
local FADEOUT_SPEED = 5
local SCROLL_SPEED = 28
HorizontalScrollablePanel.SCROLL_SPEED = SCROLL_SPEED

-- Lines 491-612
function HorizontalScrollablePanel:init(parent_panel, name, data)
	data = data or {}
	self._alphas = {}
	self._x_padding = data.x_padding ~= nil and data.x_padding or data.padding ~= nil and data.padding or PANEL_PADDING
	self._y_padding = data.y_padding ~= nil and data.y_padding or data.padding ~= nil and data.padding or PANEL_PADDING
	self._scrollbar_y_padding = data.scrollbar_y_padding
	self._update = data.update ~= nil and data.update or self._default_update
	self._force_scroll_indicators = data.force_scroll_indicators
	local layer = data.layer ~= nil and data.layer or 50
	data.name = data.name or name and name .. "Base"
	self._panel = parent_panel:panel(data)
	self._scroll_panel = self._panel:panel({
		name = name and name .. "Scroll",
		x = self:x_padding(),
		y = self:y_padding(),
		w = self._panel:w() - self:x_padding() * 2,
		h = self._panel:h() - self:y_padding() * 2
	})
	self._canvas = self._scroll_panel:panel({
		name = name and name .. "Canvas",
		w = self._scroll_panel:w(),
		h = self._scroll_panel:h()
	})

	if data.ignore_left_indicator == nil or not data.ignore_left_indicator then
		local scroll_left_indicator_shade = self:panel():panel({
			halign = "left",
			name = "scroll_left_indicator_shade",
			alpha = 0,
			valign = "top",
			layer = layer,
			x = self:x_padding(),
			y = self:y_padding(),
			h = self:canvas():h()
		})

		BoxGuiObject:new(scroll_left_indicator_shade, {
			sides = {
				0,
				0,
				2,
				0
			}
		}):set_aligns("scale", "scale")
	end

	if data.ignore_right_indicator == nil or not data.ignore_right_indicator then
		local scroll_right_indicator_shade = self:panel():panel({
			valign = "top",
			name = "scroll_right_indicator_shade",
			halign = "right",
			alpha = 0,
			layer = layer,
			x = self:x_padding(),
			y = self:y_padding(),
			h = self:canvas():h(),
			w = self:panel():w() - self:x_padding() * 2
		})

		BoxGuiObject:new(scroll_right_indicator_shade, {
			sides = {
				0,
				0,
				0,
				2
			}
		}):set_aligns("scale", "scale")
	end

	local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar_arrow")
	local rect_offset = 0
	local scroll_left_indicator_arrow = self:panel():bitmap({
		name = "scroll_left_indicator_arrow",
		valign = "top",
		alpha = 0,
		halign = "left",
		rotation = 270,
		texture = texture,
		texture_rect = rect,
		layer = layer,
		color = Color.white
	})

	scroll_left_indicator_arrow:set_left(self:scrollbar_x_padding())
	scroll_left_indicator_arrow:set_top(self:panel():h() - self:scrollbar_y_padding() + rect_offset)

	local scroll_right_indicator_arrow = self:panel():bitmap({
		name = "scroll_right_indicator_arrow",
		valign = "top",
		alpha = 0,
		halign = "right",
		rotation = 90,
		texture = texture,
		texture_rect = rect,
		layer = layer,
		color = Color.white
	})

	scroll_right_indicator_arrow:set_right(self:panel():w() - self:scrollbar_x_padding())
	scroll_right_indicator_arrow:set_top(self:panel():h() - self:scrollbar_y_padding() + rect_offset)

	if data.down_scrollbar then
		scroll_left_indicator_arrow:set_bottom(2)
		scroll_right_indicator_arrow:set_bottom(2)
	end

	local bar_w = scroll_right_indicator_arrow:left() - scroll_left_indicator_arrow:right()
	self._scroll_bar = self:panel():panel({
		valign = "top",
		name = "scroll_bar",
		h = 4,
		layer = layer - 1,
		w = bar_w
	})
	self._scroll_bar_box_class = BoxGuiObject:new(self._scroll_bar, {
		sides = {
			0,
			0,
			2,
			2
		}
	})

	self._scroll_bar_box_class:set_aligns("scale", "scale")
	self._scroll_bar:set_h(data.scroll_h or 8)
	self._scroll_bar:set_right(scroll_right_indicator_arrow:left())
	self._scroll_bar:set_center_y(scroll_right_indicator_arrow:center_y())

	self._bar_minimum_size = data.bar_minimum_size or 5
	self._thread = self._panel:animate(function (o, self)
		while true do
			local dt = coroutine.yield()

			self:_update(dt)
		end
	end, self)
end

-- Lines 638-646
function HorizontalScrollablePanel:scrollbar_x_padding()
	local x_padding = self:x_padding()

	if self._scrollbar_x_padding then
		return x_padding + self._scrollbar_x_padding
	end

	return x_padding + 6
end

-- Lines 648-654
function HorizontalScrollablePanel:scrollbar_y_padding()
	if self._y_padding == 0 then
		return PANEL_PADDING
	else
		return self._y_padding
	end
end

-- Lines 665-679
function HorizontalScrollablePanel:set_size(w, h)
	self:panel():set_size(w, h)
	self:scroll_panel():set_size(w - self:x_padding() * 2, h - self:y_padding() * 2)

	local scroll_left_indicator_arrow = self:panel():child("scroll_left_indicator_arrow")

	scroll_left_indicator_arrow:set_left(self:scrollbar_y_padding())
	scroll_left_indicator_arrow:set_top(self:panel():h() - self:scrollbar_y_padding())

	local scroll_right_indicator_arrow = self:panel():child("scroll_right_indicator_arrow")

	scroll_right_indicator_arrow:set_right(self:panel():w() - self:scrollbar_x_padding())
	scroll_right_indicator_arrow:set_top(self:panel():h() - self:scrollbar_y_padding())
	self._scroll_bar:set_right(scroll_right_indicator_arrow:left())
	self._scroll_bar:set_center_y(scroll_right_indicator_arrow:center_y())
end

-- Lines 685-687
function HorizontalScrollablePanel:canvas_max_width()
	return self:scroll_panel():h()
end

-- Lines 689-691
function HorizontalScrollablePanel:canvas_scroll_width()
	return self:scroll_panel():h() - self:y_padding() - 5
end

-- Lines 693-695
function HorizontalScrollablePanel:canvas_scroll_height()
	return self:scroll_panel():w()
end

-- Lines 697-732
function HorizontalScrollablePanel:update_canvas_size()
	local orig_h = self:canvas():h()
	local max_w = 0

	for i, panel in ipairs(self:canvas():children()) do
		local w = panel:x() + panel:w()

		if max_w < w then
			max_w = w
		end
	end

	local show_scrollbar = self:canvas_scroll_width() < max_w
	local max_h = show_scrollbar and self:canvas_scroll_height() or self:canvas_scroll_height()

	self:canvas():grow(max_h - self:canvas():h(), max_w - self:canvas():w())

	if self._on_canvas_updated then
		self._on_canvas_updated(max_h)
	end

	max_w = 0

	for i, panel in ipairs(self:canvas():children()) do
		local w = panel:x() + panel:w()

		if max_w < w then
			max_w = w
		end
	end

	if max_w <= self:scroll_panel():w() then
		max_w = self:scroll_panel():w()
	end

	self:set_canvas_size(nil, max_w)
end

-- Lines 734-766
function HorizontalScrollablePanel:set_canvas_size(w, h)
	if h == nil then
		h = self:canvas():h()
	end

	if w == nil then
		w = self:canvas():w()
	end

	if w <= self:scroll_panel():w() then
		w = self:scroll_panel():w()

		self:canvas():set_x(0)
	end

	self:canvas():set_size(w, h)

	local show_scrollbar = math.floor(self:scroll_panel():w()) < math.floor(w)

	if not show_scrollbar then
		self._scroll_bar:set_alpha(0)
		self._scroll_bar:set_visible(false)
		self._scroll_bar_box_class:hide()
		self:set_element_alpha_target("scroll_left_indicator_arrow", 0, 100)
		self:set_element_alpha_target("scroll_right_indicator_arrow", 0, 100)
		self:set_element_alpha_target("scroll_left_indicator_shade", 0, 100)
		self:set_element_alpha_target("scroll_right_indicator_shade", 0, 100)
	else
		self._scroll_bar:set_alpha(1)
		self._scroll_bar:set_visible(true)
		self._scroll_bar_box_class:show()
		self:_set_scroll_indicator()
		self:_check_scroll_indicator_states()
	end
end

-- Lines 777-779
function HorizontalScrollablePanel:is_scrollable()
	return self:scroll_panel():w() < self:canvas():w()
end

-- Lines 792-805
function HorizontalScrollablePanel:perform_scroll(speed, direction)
	if self:canvas():w() <= self:scroll_panel():w() then
		return
	end

	local scroll_amount = speed * direction
	local max_w = self:canvas():w() - self:scroll_panel():w()
	max_w = max_w * -1
	local new_x = math.clamp(self:canvas():x() + scroll_amount, max_w, 0)

	self:canvas():set_x(new_x)
	self:_set_scroll_indicator()
	self:_check_scroll_indicator_states()
end

-- Lines 807-820
function HorizontalScrollablePanel:scroll_to(x)
	if self:canvas():w() <= self:scroll_panel():w() then
		return
	end

	local scroll_amount = -x
	local max_w = self:canvas():w() - self:scroll_panel():w()
	max_w = max_w * -1
	local new_x = math.clamp(scroll_amount, max_w, 0)

	self:canvas():set_x(new_x)
	self:_set_scroll_indicator()
	self:_check_scroll_indicator_states()
end

-- Lines 822-840
function HorizontalScrollablePanel:scroll_with_bar(target_x, current_x)
	local arrow_size = self:panel():child("scroll_left_indicator_arrow"):size()
	local scroll_panel = self:scroll_panel()
	local canvas = self:canvas()

	if target_x < current_x then
		if target_x < scroll_panel:world_right() - arrow_size then
			local mul = (scroll_panel:w() - arrow_size * 2) / canvas:w()

			self:perform_scroll((current_x - target_x) / mul, 1)
		end

		current_x = target_x
	elseif current_x < target_x then
		if target_x > scroll_panel:world_x() + arrow_size then
			local mul = (scroll_panel:w() - arrow_size * 2) / canvas:w()

			self:perform_scroll((target_x - current_x) / mul, -1)
		end

		current_x = target_x
	end
end

-- Lines 842-849
function HorizontalScrollablePanel:release_scroll_bar()
	self._pressing_arrow_left = false
	self._pressing_arrow_right = false

	if self._grabbed_scroll_bar then
		self._grabbed_scroll_bar = false

		return true
	end
end

-- Lines 851-856
function HorizontalScrollablePanel:_set_scroll_indicator()
	local bar_w = self:panel():child("scroll_right_indicator_arrow"):left() - self:panel():child("scroll_left_indicator_arrow"):right()

	if self:canvas():w() ~= 0 then
		self._scroll_bar:set_w(math.max(bar_w * self:scroll_panel():w() / self:canvas():w(), self._bar_minimum_size))
	end
end

-- Lines 858-878
function HorizontalScrollablePanel:_check_scroll_indicator_states()
	local left_alpha = math.floor(self:canvas():right()) < 0 and 1 or 0
	local right_alpha = math.floor(self:scroll_panel():w()) < math.floor(self:canvas():left()) and 1 or 0
	left_alpha = 1
	right_alpha = 1

	self:set_element_alpha_target("scroll_left_indicator_arrow", left_alpha, FADEOUT_SPEED)
	self:set_element_alpha_target("scroll_right_indicator_arrow", right_alpha, FADEOUT_SPEED)

	if self:x_padding() > 0 or self._force_scroll_indicators then
		self:set_element_alpha_target("scroll_left_indicator_shade", left_alpha, FADEOUT_SPEED)
		self:set_element_alpha_target("scroll_right_indicator_shade", right_alpha, FADEOUT_SPEED)
	end

	local left_arrow = self:panel():child("scroll_left_indicator_arrow")
	local right_arrow = self:panel():child("scroll_right_indicator_arrow")
	local canvas_w = self:canvas():w() ~= 0 and self:canvas():w() or 1
	local at = self:canvas():left() / (self:scroll_panel():w() - canvas_w)
	local max = right_arrow:left() - left_arrow:right() - self._scroll_bar:w()

	self._scroll_bar:set_left(left_arrow:right() + max * at)
end

-- Lines 910-928
function HorizontalScrollablePanel:mouse_moved(button, x, y)
	if self._grabbed_scroll_bar then
		self:scroll_with_bar(x, self._current_x)

		self._current_x = x

		return true, "grab"
	elseif alive(self._scroll_bar) and self._scroll_bar:visible() and self._scroll_bar:inside(x, y) then
		return true, "hand"
	elseif self:panel():child("scroll_left_indicator_arrow"):inside(x, y) then
		if self._pressing_arrow_left then
			self:perform_scroll(SCROLL_SPEED * 0.1, 1)
		end

		return true, self:panel():child("scroll_left_indicator_arrow"):alpha() > 0 and "link" or "arrow"
	elseif self:panel():child("scroll_right_indicator_arrow"):inside(x, y) then
		if self._pressing_arrow_right then
			self:perform_scroll(SCROLL_SPEED * 0.1, -1)
		end

		return true, self:panel():child("scroll_right_indicator_arrow"):alpha() > 0 and "link" or "arrow"
	end
end

-- Lines 936-948
function HorizontalScrollablePanel:mouse_pressed(button, x, y)
	if alive(self._scroll_bar) and self._scroll_bar:visible() and self._scroll_bar:inside(x, y) then
		self._grabbed_scroll_bar = true
		self._current_x = x

		return true
	elseif self:panel():child("scroll_left_indicator_arrow"):inside(x, y) then
		self._pressing_arrow_left = true

		return true
	elseif self:panel():child("scroll_right_indicator_arrow"):inside(x, y) then
		self._pressing_arrow_right = true

		return true
	end
end
