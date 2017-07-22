local is_win32 = SystemInfo:platform() == Idstring("WIN32")
local NOT_WIN_32 = not is_win32
local medium_font = tweak_data.menu.pd2_medium_font
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font = tweak_data.menu.pd2_small_font
local small_font_size = tweak_data.menu.pd2_small_font_size
CustomSafehouseGuiItem = CustomSafehouseGuiItem or class()

-- Lines: 12 to 14
function CustomSafehouseGuiItem:init()
	self._selected = false
end

-- Lines: 16 to 17
function CustomSafehouseGuiItem:refresh()
end

-- Lines: 19 to 20
function CustomSafehouseGuiItem:inside()
end

-- Lines: 22 to 23
function CustomSafehouseGuiItem:is_selected()
	return self._selected
end

-- Lines: 26 to 34
function CustomSafehouseGuiItem:set_selected(selected, play_sound)
	if self._selected ~= selected then
		self._selected = selected

		self:refresh()

		if self._selected and play_sound ~= false then
			managers.menu_component:post_event("highlight")
		end
	end
end

-- Lines: 36 to 37
function CustomSafehouseGuiItem:is_active()
	return self._active
end

-- Lines: 40 to 45
function CustomSafehouseGuiItem:set_active(active, play_sound)
	if self._active ~= active then
		self._active = active

		self:refresh()
	end
end

-- Lines: 47 to 50
function CustomSafehouseGuiItem:trigger()
	managers.menu_component:post_event("menu_enter")
	self:refresh()
end

-- Lines: 52 to 53
function CustomSafehouseGuiItem:flash()
end
CustomSafehouseGuiTabItem = CustomSafehouseGuiTabItem or class(CustomSafehouseGuiItem)

-- Lines: 60 to 100
function CustomSafehouseGuiTabItem:init(index, title_id, page_item, gui, tab_x, tab_panel)
	CustomSafehouseGuiTabItem.super.init(self)

	self._index = index
	self._name_id = title_id
	self._active = false
	self._selected = false
	self._gui = gui
	self._page_item = page_item
	local page_panel = tab_panel:panel({
		name = "Page" .. string.capitalize(tostring(title_id)),
		x = tab_x
	})
	local page_text = page_panel:text({
		name = "PageText",
		vertical = "center",
		align = "center",
		layer = 1,
		text = managers.localization:to_upper_text(title_id),
		font = medium_font,
		font_size = medium_font_size,
		color = Color.black
	})
	local _, _, tw, th = page_text:text_rect()

	page_panel:set_size(tw + 15, th + 10)
	page_text:set_size(page_panel:size())

	local page_tab_bg = page_panel:bitmap({
		texture = "guis/textures/pd2/shared_tab_box",
		name = "PageTabBG",
		w = page_panel:w(),
		h = page_panel:h(),
		color = tweak_data.screen_colors.text
	})
	self._page_panel = page_panel

	self:refresh()
end

-- Lines: 102 to 103
function CustomSafehouseGuiTabItem:index()
	return self._index
end

-- Lines: 106 to 107
function CustomSafehouseGuiTabItem:page()
	return self._page_item
end

-- Lines: 110 to 111
function CustomSafehouseGuiTabItem:prev_page_position()
	return self._page_panel:left() - 15
end

-- Lines: 114 to 115
function CustomSafehouseGuiTabItem:next_page_position()
	return self._page_panel:right() + 15
end

-- Lines: 118 to 121
function CustomSafehouseGuiTabItem:set_active(active)
	self._active = active

	self:refresh()
end

-- Lines: 123 to 124
function CustomSafehouseGuiTabItem:is_active()
	return self._active
end

-- Lines: 127 to 128
function CustomSafehouseGuiTabItem:inside(x, y)
	return self._page_panel:inside(x, y)
end

-- Lines: 132 to 140
function CustomSafehouseGuiTabItem:refresh()
	if alive(self._page_panel) then
		self._page_panel:child("PageText"):set_blend_mode(self._active and "normal" or "add")
		self._page_panel:child("PageText"):set_color(self._active and Color.black or self._selected and tweak_data.screen_colors.button_stage_2 or tweak_data.screen_colors.button_stage_3)
		self._page_panel:child("PageTabBG"):set_visible(self._active)
	end
end
CustomSafehouseGuiPage = CustomSafehouseGuiPage or class(CustomSafehouseGuiItem)

-- Lines: 147 to 162
function CustomSafehouseGuiPage:init(page_id, page_panel, fullscreen_panel, gui)
	CustomSafehouseGuiPage.super.init(self)

	self._gui = gui
	self._active = false
	self._selected = 0
	self._page_name = page_id
	self._panel = page_panel:panel({})
	self._info_panel = gui:info_panel():panel({})
	self._event_listener = gui:event_listener()

	self._event_listener:add(page_id, {"refresh"}, callback(self, self, "refresh"))
	self:refresh()
end

-- Lines: 164 to 165
function CustomSafehouseGuiPage:update(t, dt)
end

-- Lines: 167 to 168
function CustomSafehouseGuiPage:event_listener()
	return self._event_listener
end

-- Lines: 171 to 174
function CustomSafehouseGuiPage:refresh()
	self:panel():set_visible(self._active)
	self:info_panel():set_visible(self._active)
end

-- Lines: 176 to 179
function CustomSafehouseGuiPage:set_active(active)
	self._active = active

	self:refresh()

	return active
end

-- Lines: 182 to 183
function CustomSafehouseGuiPage:on_notify(tree, msg)
end

-- Lines: 185 to 186
function CustomSafehouseGuiPage:name()
	return self._page_name
end

-- Lines: 189 to 190
function CustomSafehouseGuiPage:panel()
	return self._panel
end

-- Lines: 193 to 194
function CustomSafehouseGuiPage:info_panel()
	return self._info_panel
end

-- Lines: 198 to 204
function CustomSafehouseGuiPage:stack_panels(padding, panels)
	for idx, panel in ipairs(panels) do
		panel:set_left(0)
		panel:set_top(idx > 1 and panels[idx - 1]:bottom() + padding or 0)
	end
end

-- Lines: 206 to 207
function CustomSafehouseGuiPage:mouse_clicked(o, button, x, y)
end

-- Lines: 209 to 210
function CustomSafehouseGuiPage:mouse_pressed(button, x, y)
end

-- Lines: 212 to 213
function CustomSafehouseGuiPage:mouse_released(button, x, y)
end

-- Lines: 215 to 216
function CustomSafehouseGuiPage:mouse_moved(button, x, y)
end

-- Lines: 218 to 219
function CustomSafehouseGuiPage:mouse_wheel_up(x, y)
end

-- Lines: 221 to 222
function CustomSafehouseGuiPage:mouse_wheel_down(x, y)
end

-- Lines: 224 to 225
function CustomSafehouseGuiPage:move_up()
end

-- Lines: 227 to 228
function CustomSafehouseGuiPage:move_down()
end

-- Lines: 230 to 231
function CustomSafehouseGuiPage:move_left()
end

-- Lines: 233 to 234
function CustomSafehouseGuiPage:move_right()
end

-- Lines: 236 to 237
function CustomSafehouseGuiPage:confirm_pressed()
end

-- Lines: 240 to 255
function CustomSafehouseGuiPage:special_btn_pressed(button)
	if not self:is_active() or not self._controllers_mapping then
		return
	end

	local btn = self._controllers_mapping and self._controllers_mapping[button:key()]

	if btn and btn._callback and (not self._button_press_delay or self._button_press_delay < TimerManager:main():time()) then
		managers.menu_component:post_event("menu_enter")
		btn._callback()

		self._button_press_delay = TimerManager:main():time() + 0.2

		return
	end
end

-- Lines: 257 to 258
function CustomSafehouseGuiPage:get_legend()
	return {
		"move",
		"back"
	}
end
CustomSafehouseGuiButtonItem = CustomSafehouseGuiButtonItem or class(CustomSafehouseGuiItem)

-- Lines: 266 to 316
function CustomSafehouseGuiButtonItem:init(panel, data, x, priority)
	CustomSafehouseGuiButtonItem.super.init(self, panel, data)

	self._btn_data = data
	self._callback = data.callback
	local up_font_size = NOT_WIN_32 and RenderSettings.resolution.y < 720 and data.btn == "BTN_STICK_R" and 2 or 0
	self._color = data.color or tweak_data.screen_colors.button_stage_3
	self._selected_color = data.selected_color or tweak_data.screen_colors.button_stage_2
	self._custom_data = data.custom
	self._hidden = false
	self._panel = panel:panel({
		x = x,
		y = data.y or x + (priority - 1) * small_font_size,
		w = panel:w() - x * 2,
		h = medium_font_size
	})
	self._btn_text = self._panel:text({
		name = "text",
		blend_mode = "add",
		text = "",
		x = 0,
		layer = 1,
		align = data.align or "right",
		w = self._panel:w(),
		font_size = small_font_size + up_font_size,
		font = small_font,
		color = self._color
	})
	local text = data.name_id

	if data.localize == nil or data.localize then
		text = managers.localization:text(data.name_id)
	end

	self:set_text(text)

	self._select_rect = self._panel:rect({
		blend_mode = "add",
		name = "select_rect",
		halign = "scale",
		alpha = 0.3,
		valign = "scale",
		color = self._color
	})

	self._select_rect:set_visible(false)

	if not managers.menu:is_pc_controller() then
		self._btn_text:set_color(data.color or tweak_data.screen_colors.text)
	end
end

-- Lines: 318 to 319
function CustomSafehouseGuiButtonItem:button_data()
	return self._btn_data
end

-- Lines: 322 to 323
function CustomSafehouseGuiButtonItem:get_custom_data()
	return self._custom_data
end

-- Lines: 326 to 328
function CustomSafehouseGuiButtonItem:reorder(new_prio)
	self._panel:set_y(self._panel:x() + (new_prio - 1) * small_font_size)
end

-- Lines: 330 to 337
function CustomSafehouseGuiButtonItem:set_text(text)
	local prefix = not managers.menu:is_pc_controller() and self._btn_data.btn and managers.localization:get_default_macro(self._btn_data.btn) or ""

	self._btn_text:set_text(prefix .. utf8.to_upper(text))

	local _, _, w, h = self._btn_text:text_rect()
	h = math.max(h, small_font_size)

	self._panel:set_h(h)
	self._btn_text:set_h(h)
end

-- Lines: 339 to 340
function CustomSafehouseGuiButtonItem:text()
	return self._btn_text:text()
end

-- Lines: 343 to 347
function CustomSafehouseGuiButtonItem:inside(x, y)
	if self._hidden then
		return false
	end

	return self._panel:inside(x, y)
end

-- Lines: 350 to 352
function CustomSafehouseGuiButtonItem:show()
	self._select_rect:set_visible(true)
end

-- Lines: 354 to 356
function CustomSafehouseGuiButtonItem:hide()
	self._select_rect:set_visible(false)
end

-- Lines: 358 to 362
function CustomSafehouseGuiButtonItem:visible()
	if self._hidden then
		return false
	end

	return self._select_rect:visible()
end

-- Lines: 365 to 371
function CustomSafehouseGuiButtonItem:refresh()
	if self._selected then
		self:show()
	else
		self:hide()
	end
end

-- Lines: 373 to 376
function CustomSafehouseGuiButtonItem:trigger()
	CustomSafehouseGuiButtonItem.super.trigger(self)
	self._callback()
end

-- Lines: 378 to 382
function CustomSafehouseGuiButtonItem:set_color(color, selected_color)
	self._color = color or self._color
	self._selected_color = selected_color or color or self._selected_color

	self:set_selected(self._selected, false)
end

-- Lines: 384 to 394
function CustomSafehouseGuiButtonItem:set_selected(selected, play_sound)
	CustomSafehouseGuiButtonItem.super.set_selected(self, selected, play_sound)

	if selected then
		self._btn_text:set_color(self._selected_color)
		self._select_rect:set_color(self._selected_color)
	else
		self._btn_text:set_color(self._color)
		self._select_rect:set_color(self._color)
	end
end

-- Lines: 396 to 397
function CustomSafehouseGuiButtonItem:hidden()
	return self._hidden
end

-- Lines: 400 to 403
function CustomSafehouseGuiButtonItem:set_hidden(hidden)
	self._hidden = hidden

	self._panel:set_visible(not hidden)
end
CustomSafehouseGuiButtonItemWithIcon = CustomSafehouseGuiButtonItemWithIcon or class(CustomSafehouseGuiButtonItem)

-- Lines: 409 to 417
function CustomSafehouseGuiButtonItemWithIcon:init(panel, data, x, priority)
	CustomSafehouseGuiButtonItemWithIcon.super.init(self, panel, data, x, priority)

	if data.icon then
		self:_create_icon(data.icon)
	end

	self._btn_text:set_left(self._panel:h())
end

-- Lines: 419 to 429
function CustomSafehouseGuiButtonItemWithIcon:_create_icon(icon)
	self._icon = self._panel:bitmap({
		x = 3,
		texture = icon,
		w = self._panel:h() - 6,
		h = self._panel:h() - 6,
		color = self._color
	})

	self._icon:set_center_y(self._panel:h() / 2)
end

-- Lines: 431 to 444
function CustomSafehouseGuiButtonItemWithIcon:set_icon(icon)
	if alive(self._icon) then
		if icon then
			self._icon:set_image(icon)
			self._icon:show()
		else
			self._icon:hide()
		end
	elseif icon then
		self:_create_icon(icon)
	end
end

-- Lines: 446 to 447
function CustomSafehouseGuiButtonItemWithIcon:icon()
	return self._icon
end

-- Lines: 450 to 460
function CustomSafehouseGuiButtonItemWithIcon:set_selected(selected, play_sound)
	CustomSafehouseGuiButtonItemWithIcon.super.set_selected(self, selected, play_sound)

	if alive(self._icon) then
		if selected then
			self._icon:set_color(self._selected_color)
		else
			self._icon:set_color(self._color)
		end
	end
end

return
