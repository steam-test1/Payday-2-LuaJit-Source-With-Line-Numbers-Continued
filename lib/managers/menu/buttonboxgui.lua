ButtonBoxGui = ButtonBoxGui or class(TextBoxGui)

-- Lines 4-65
function ButtonBoxGui:_setup_buttons_panel(info_area, button_list, focus_button, only_buttons)
	self._button_list = button_list
	local has_buttons = button_list and #button_list > 0
	local buttons_panel = info_area:panel({
		name = "buttons_panel",
		x = 10,
		layer = 1,
		w = has_buttons and 200 or 0,
		h = info_area:h()
	})

	buttons_panel:set_right(info_area:w())

	self._text_box_buttons_panel = buttons_panel
	self._info_area = info_area

	if has_buttons then
		local button_text_config = {
			name = "button_text",
			vertical = "center",
			word_wrap = "true",
			wrap = "true",
			blend_mode = "add",
			halign = "right",
			x = 10,
			layer = 2,
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			color = tweak_data.screen_colors.button_stage_3
		}
		local max_w = 0
		local max_h = 0

		if button_list then
			for i, button in ipairs(button_list) do
				local button_panel = buttons_panel:panel({
					halign = "grow",
					h = 20,
					y = 100,
					name = button.id_name
				})
				button_text_config.text = utf8.to_upper(button.text or "")

				if button_text_config.text == "" then
					button_text_config.text = " "
				end

				local text = button_panel:text(button_text_config)
				local _, _, w, h = text:text_rect()
				max_w = math.max(max_w, w)
				max_h = math.max(max_h, h)

				text:set_size(w, h)
				button_panel:set_h(h)
				text:set_right(button_panel:w())
				button_panel:set_bottom(i * h)
			end

			buttons_panel:set_h(#button_list * max_h)
			buttons_panel:set_bottom(info_area:h() - 10)
		end

		buttons_panel:set_w(only_buttons and info_area:w() or math.max(max_w, 120) + 40)
		buttons_panel:set_right(info_area:w() - 10)

		local selected = buttons_panel:rect({
			blend_mode = "add",
			name = "selected",
			alpha = 0.3,
			color = tweak_data.screen_colors.button_stage_3
		})

		self:set_focus_button(focus_button, false)
	end

	return buttons_panel
end

-- Lines 67-73
function ButtonBoxGui:_setup_scroll_bar(main, scroll_panel, buttons_panel, top_line, bottom_line)
	ButtonBoxGui.super._setup_scroll_bar(self, main, scroll_panel, buttons_panel, top_line, bottom_line)

	local focus_button = self._text_box_focus_button
	self._text_box_focus_button = nil

	self:set_focus_button(focus_button, false)
end

-- Lines 75-85
function ButtonBoxGui:_override_info_area_size(info_area, scroll_panel, buttons_panel)
	info_area:set_h(math.min(scroll_panel:bottom() + buttons_panel:h() + 10 + 5, 620))

	local text = scroll_panel:child("text")

	if info_area:h() < buttons_panel:h() + scroll_panel:y() + text:h() then
		text:grow(-buttons_panel:w(), 0)

		local _, _, ttw, tth = text:text_rect()

		text:set_h(tth)
	end
end

-- Lines 87-98
function ButtonBoxGui:set_focus_button(focus_button, allow_callbacks)
	if focus_button ~= self._text_box_focus_button then
		managers.menu:post_event("highlight")

		if self._text_box_focus_button then
			self:_set_button_selected(self._text_box_focus_button, false)
		end

		self:_set_button_selected(focus_button, true, allow_callbacks)

		self._text_box_focus_button = focus_button
	end
end

-- Lines 100-137
function ButtonBoxGui:_set_button_selected(index, is_selected, allow_callbacks)
	ButtonBoxGui.super._set_button_selected(self, index, is_selected)

	if allow_callbacks == nil then
		allow_callbacks = true
	end

	local button = self._button_list and self._button_list[index]

	if button and is_selected then
		if allow_callbacks and button.focus_callback_func then
			button.focus_callback_func()
		end

		local button_panel = nil

		if button.id_name then
			button_panel = self._text_box_buttons_panel:child(button.id_name)
		else
			button_panel = self._text_box_buttons_panel:children()[index]
		end

		if button_panel then
			local top = self._text_box_buttons_panel:top() + button_panel:top()
			local bottom = self._text_box_buttons_panel:top() + button_panel:bottom()
			local padding = 10
			local y_top = padding
			local y_bottom = self._info_area:h() - padding
			local new_y = self._text_box_buttons_panel:y()

			if top < y_top then
				new_y = new_y - top + y_top
			elseif y_bottom < bottom then
				new_y = new_y - bottom + y_bottom
			end

			self._text_box_buttons_panel:set_y(new_y)
		end
	end
end

-- Lines 139-153
function ButtonBoxGui:change_focus_button(change, override_at)
	local button_count = self._text_box_buttons_panel:num_children() - 1
	local focus_button = ((override_at or self._text_box_focus_button) + change) % button_count

	if focus_button == 0 then
		focus_button = button_count
	end

	if self._button_list[focus_button].no_selection then
		self:change_focus_button(change, focus_button)

		return
	end

	self:set_focus_button(focus_button)
end

-- Lines 155-167
function ButtonBoxGui:_scroll_buttons(direction)
	local SCROLL_SPEED = 28
	local speed = SCROLL_SPEED * TimerManager:main():delta_time() * 200
	local new_y = self._text_box_buttons_panel:y() + speed * direction
	local padding = 10

	if self._text_box_buttons_panel:h() > self._info_area:h() - 2 * padding then
		new_y = math.clamp(new_y, self._info_area:h() - self._text_box_buttons_panel:h() - padding, padding)
	else
		new_y = self._info_area:h() - self._text_box_buttons_panel:h() - padding
	end

	self._text_box_buttons_panel:set_y(new_y)
end

-- Lines 169-176
function ButtonBoxGui:mouse_wheel_up(x, y)
	local used = ButtonBoxGui.super.mouse_wheel_up(self, x, y)

	if not used and self._text_box_buttons_panel:inside(x, y) then
		self:_scroll_buttons(1)

		used = true
	end

	return used
end

-- Lines 178-185
function ButtonBoxGui:mouse_wheel_down(x, y)
	local used = ButtonBoxGui.super.mouse_wheel_down(self, x, y)

	if not used and self._text_box_buttons_panel:inside(x, y) then
		self:_scroll_buttons(-1)

		used = true
	end

	return used
end
