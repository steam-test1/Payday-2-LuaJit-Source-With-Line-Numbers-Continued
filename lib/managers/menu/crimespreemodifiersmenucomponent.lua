CrimeSpreeModifiersMenuComponent = CrimeSpreeModifiersMenuComponent or class(MenuGuiComponentGeneric)
local padding = 10

-- Lines 6-16
function CrimeSpreeModifiersMenuComponent:init(ws, fullscreen_ws, node)
	self._ws = ws
	self._fullscreen_ws = fullscreen_ws
	self._init_layer = self._ws:panel():layer()
	self._buttons = {}

	self:_setup()
end

-- Lines 18-23
function CrimeSpreeModifiersMenuComponent:close()
	self._ws:panel():remove(self._panel)
	self._ws:panel():remove(self._text_header)
	self._ws:panel():remove(self._number_header)
	self._fullscreen_ws:panel():remove(self._fullscreen_panel)
end

-- Lines 25-167
function CrimeSpreeModifiersMenuComponent:_setup()
	local modifiers, modifiers_name = self:get_modifers()
	local parent = self._ws:panel()

	if alive(self._panel) then
		parent:remove(self._panel)
	end

	self._panel = self._ws:panel():panel({
		layer = 51
	})
	self._fullscreen_panel = self._fullscreen_ws:panel():panel({
		layer = 50
	})

	self._fullscreen_panel:rect({
		alpha = 0.75,
		layer = 0,
		color = Color.black
	})

	local blur = self._fullscreen_panel:bitmap({
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedBlur3D",
		w = self._fullscreen_ws:panel():w(),
		h = self._fullscreen_ws:panel():h()
	})

	-- Lines 54-57
	local function func(o)
		local start_blur = 0

		over(0.6, function (p)
			o:set_alpha(math.lerp(start_blur, 1, p))
		end)
	end

	blur:animate(func)
	self._panel:set_w((CrimeSpreeModifierButton.size.w + padding) * tweak_data.crime_spree.max_modifiers_displayed + padding)
	self._panel:set_h(CrimeSpreeModifierButton.size.h + padding * 3 + tweak_data.menu.pd2_large_font_size)
	self._panel:set_center_x(parent:center_x())
	self._panel:set_center_y(parent:center_y())
	self._panel:rect({
		alpha = 0.4,
		layer = -1,
		color = Color.black
	})

	self._text_header = self._ws:panel():text({
		vertical = "top",
		align = "left",
		layer = 51,
		text = managers.localization:to_upper_text("menu_cs_modifiers_" .. tostring(modifiers_name)),
		font_size = tweak_data.menu.pd2_large_font_size,
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.text
	})
	local x, y, w, h = self._text_header:text_rect()

	self._text_header:set_size(self._panel:w(), h)
	self._text_header:set_left(self._panel:left())
	self._text_header:set_bottom(self._panel:top())

	self._current_num = 1
	self._num_to_select = self:modifiers_to_select()
	self._number_header = self._ws:panel():text({
		vertical = "top",
		align = "right",
		layer = 51,
		text = self._num_to_select > 1 and tostring(self._current_num) .. " / " .. managers.experience:cash_string(self._num_to_select, "") or "",
		font_size = tweak_data.menu.pd2_large_font_size,
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.text
	})
	local x, y, w, h = self._text_header:text_rect()

	self._number_header:set_size(self._panel:w(), h)
	self._number_header:set_left(self._panel:left())
	self._number_header:set_bottom(self._panel:top())

	self._modifiers_panel = self._panel:panel({
		w = self._panel:w(),
		h = self._panel:h() - tweak_data.menu.pd2_large_font_size - padding * 2
	})
	self._button_panel = self._panel:panel({
		y = self._modifiers_panel:bottom() + padding,
		w = self._panel:w(),
		h = tweak_data.menu.pd2_large_font_size
	})

	for i = 1, tweak_data.crime_spree.max_modifiers_displayed do
		local modifier = modifiers[i]
		local btn = CrimeSpreeModifierButton:new(self._modifiers_panel, modifier)

		btn:set_x(padding + (CrimeSpreeModifierButton.size.w + padding) * (i - 1))
		btn:set_y(padding)
		btn:set_callback(callback(self, self, "_on_select_modifier", btn))
		table.insert(self._buttons, btn)
	end

	local finalize_btn = CrimeSpreeButton:new(self._button_panel)

	finalize_btn:set_text(managers.localization:to_upper_text("menu_cs_select_modifier"))
	finalize_btn:set_callback(callback(self, self, "_on_finalize_modifier"))
	finalize_btn:shrink_wrap_button(0, 0)
	table.insert(self._buttons, finalize_btn)

	local back_btn = CrimeSpreeButton:new(self._button_panel)

	back_btn:set_text(managers.localization:to_upper_text("menu_back"))
	back_btn:set_callback(callback(self, self, "_on_back"))
	back_btn:shrink_wrap_button(0, 0)
	table.insert(self._buttons, back_btn)
	back_btn:panel():set_right(self._button_panel:w() - padding * 2)
	finalize_btn:panel():set_right(back_btn:panel():left() - padding * 3)

	for i, modifier in ipairs(modifiers) do
		local btn = self._buttons[i]

		if i > 1 then
			btn:set_link("left", self._buttons[i - 1])
		end

		if i < #modifiers then
			btn:set_link("right", self._buttons[i + 1])
		end

		btn:set_link("down", finalize_btn)
	end

	finalize_btn:set_link("up", self._buttons[1])
	finalize_btn:set_link("right", back_btn)
	back_btn:set_link("up", self._buttons[1])
	back_btn:set_link("left", finalize_btn)
	BoxGuiObject:new(self._panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	if not managers.menu:is_pc_controller() then
		self:_move_selection("up")
	end
end

-- Lines 171-175
function CrimeSpreeModifiersMenuComponent:modifiers_to_select()
	local loud = managers.crime_spree:modifiers_to_select("loud")
	local stealth = managers.crime_spree:modifiers_to_select("stealth")

	return loud + stealth
end

-- Lines 177-191
function CrimeSpreeModifiersMenuComponent:get_modifers()
	local loud = managers.crime_spree:modifiers_to_select("loud")
	local stealth = managers.crime_spree:modifiers_to_select("stealth")

	if loud > 0 then
		return managers.crime_spree:get_loud_modifiers(), "loud"
	elseif stealth > 0 then
		return managers.crime_spree:get_stealth_modifiers(), "stealth"
	else
		Application:error("Showing Crime Spree modifiers menu when there are no modifiers to select!")

		return {}, "loud"
	end
end

-- Lines 195-209
function CrimeSpreeModifiersMenuComponent:_on_select_modifier(item)
	if self._selected_modifier then
		self._selected_modifier:set_active(false)
	end

	self._selected_modifier = item

	if self._selected_modifier then
		self._selected_modifier:set_active(true)
		managers.menu_component:post_event("menu_enter")
	end
end

-- Lines 211-258
function CrimeSpreeModifiersMenuComponent:_on_finalize_modifier()
	if not self._selected_modifier then
		managers.menu:post_event("menu_error")

		return
	end

	managers.crime_spree:select_modifier(self._selected_modifier:data().id)
	managers.menu_component:post_event("item_buy")
	MenuCallbackHandler:save_progress()

	if self:modifiers_to_select() > 0 then
		local modifiers, modifiers_name = self:get_modifers()

		self._text_header:set_text(managers.localization:to_upper_text("menu_cs_modifiers_" .. tostring(modifiers_name)))

		self._current_num = self._current_num + 1

		self._number_header:set_text(managers.experience:cash_string(self._current_num, "") .. " / " .. managers.experience:cash_string(self._num_to_select, ""))

		for i = 1, tweak_data.crime_spree.max_modifiers_displayed do
			self._buttons[i]:set_modifier(modifiers[i])
			self._buttons[i]:set_active(false)
		end

		self:_on_select_modifier(nil)

		if not managers.menu:is_pc_controller() then
			self:_move_selection("up")
		end
	else
		managers.menu:back(false)
		managers.menu:active_menu().logic:refresh_node("crime_spree_lobby")
	end
end

-- Lines 260-262
function CrimeSpreeModifiersMenuComponent:_on_back()
	managers.menu:back(true)
end

-- Lines 266-272
function CrimeSpreeModifiersMenuComponent:update(t, dt)
	for idx, btn in ipairs(self._buttons) do
		if btn._panel:visible() then
			btn:update(t, dt)
		end
	end
end

-- Lines 274-278
function CrimeSpreeModifiersMenuComponent:confirm_pressed()
	if self._selected_item and self._selected_item:callback() then
		self._selected_item:callback()()
	end
end

-- Lines 280-301
function CrimeSpreeModifiersMenuComponent:mouse_moved(o, x, y)
	if not managers.menu:is_pc_controller() then
		return
	end

	local used, pointer = nil
	self._selected_item = nil

	for idx, btn in ipairs(self._buttons) do
		if btn._panel:visible() then
			btn:set_selected(btn:inside(x, y))

			if btn:is_selected() then
				self._selected_item = btn
				pointer = "link"
				used = true
			end
		end
	end

	return used, pointer
end

-- Lines 303-314
function CrimeSpreeModifiersMenuComponent:mouse_pressed(o, button, x, y)
	for idx, btn in ipairs(self._buttons) do
		if btn._panel:visible() and btn:is_selected() and btn:callback() then
			btn:callback()()

			return true
		end
	end
end

-- Lines 316-328
function CrimeSpreeModifiersMenuComponent:_move_selection(dir)
	if not self._selected_item then
		self._selected_item = self._buttons[1]

		self._selected_item:set_selected(true)
	else
		local new_item = self._selected_item:get_link(dir)

		if new_item then
			self._selected_item:set_selected(false)
			new_item:set_selected(true)

			self._selected_item = new_item
		end
	end
end

-- Lines 330-332
function CrimeSpreeModifiersMenuComponent:move_up()
	self:_move_selection("up")
end

-- Lines 334-336
function CrimeSpreeModifiersMenuComponent:move_down()
	self:_move_selection("down")
end

-- Lines 338-340
function CrimeSpreeModifiersMenuComponent:move_left()
	self:_move_selection("left")
end

-- Lines 342-344
function CrimeSpreeModifiersMenuComponent:move_right()
	self:_move_selection("right")
end

CrimeSpreeModifierButton = CrimeSpreeModifierButton or class(MenuGuiItem)
CrimeSpreeModifierButton._type = "CrimeSpreeModifierButton"
CrimeSpreeModifierButton.size = {
	w = 208,
	h = 298
}

-- Lines 356-430
function CrimeSpreeModifierButton:init(parent, data)
	self._data = data
	self._links = {}
	self._panel = parent:panel({
		layer = 1000,
		w = CrimeSpreeModifierButton.size.w,
		h = CrimeSpreeModifierButton.size.h
	})
	local top_padding = padding * 2
	self._image_size = 128
	self._size_modifier = 0.8
	self._image = self._panel:panel({
		y = top_padding,
		w = self._image_size,
		h = self._image_size
	})

	self._image:set_center_x(self._panel:w() * 0.5)

	self._image_pos = {
		x = self._image:center_x(),
		y = self._image:center_y()
	}
	self._modifier_image = self._image:bitmap({
		blend_mode = "add",
		name = "icon",
		valign = "grow",
		halign = "grow",
		layer = 10
	})
	self._desc = self._panel:text({
		vertical = "top",
		wrap = true,
		align = "center",
		wrap_word = true,
		text = "",
		x = padding,
		y = self._image:bottom() + top_padding,
		w = self._panel:w() - padding * 2,
		h = self._panel:h() - self._image:bottom() - top_padding - padding,
		font_size = tweak_data.menu.pd2_tiny_font_size,
		font = tweak_data.menu.pd2_tiny_font,
		color = tweak_data.screen_colors.text
	})
	self._highlight = self._panel:rect({
		blend_mode = "add",
		alpha = 0.4,
		layer = 10,
		color = tweak_data.screen_colors.button_stage_3
	})

	BoxGuiObject:new(self._panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	self._active_outline = BoxGuiObject:new(self._panel, {
		sides = {
			2,
			2,
			2,
			2
		}
	})

	self._image:set_size(self._image_size * self._size_modifier, self._image_size * self._size_modifier)
	self._image:set_center(self._image_pos.x, self._image_pos.y)
	self:refresh()
	self:set_modifier(data)
end

-- Lines 432-448
function CrimeSpreeModifierButton:set_modifier(data)
	self._data = data

	self._panel:set_visible(self._data ~= nil)

	if not self._data then
		return
	end

	local modifier_class = _G[self._data.class]
	local texture, rect = tweak_data.hud_icons:get_icon_data(self._data.icon)

	self._modifier_image:set_image(texture)
	self._modifier_image:set_texture_rect(unpack(rect))
	self._desc:set_text(managers.crime_spree:make_modifier_description(self._data.id))
end

-- Lines 450-453
function CrimeSpreeModifierButton:refresh()
	self._highlight:set_visible(self:is_selected() or self:is_active())
	self._active_outline:set_visible(self:is_active())
end

-- Lines 455-457
function CrimeSpreeModifierButton:inside(x, y)
	return self._panel:inside(x, y)
end

-- Lines 459-461
function CrimeSpreeModifierButton:data()
	return self._data
end

-- Lines 463-465
function CrimeSpreeModifierButton:callback()
	return self._callback
end

-- Lines 467-469
function CrimeSpreeModifierButton:set_callback(clbk)
	self._callback = clbk
end

-- Lines 471-473
function CrimeSpreeModifierButton:get_link(dir)
	return self._links[dir]
end

-- Lines 475-477
function CrimeSpreeModifierButton:set_link(dir, item)
	self._links[dir] = item
end

-- Lines 479-481
function CrimeSpreeModifierButton:set_x(...)
	self._panel:set_x(...)
end

-- Lines 483-485
function CrimeSpreeModifierButton:set_y(...)
	self._panel:set_y(...)
end

-- Lines 487-493
function CrimeSpreeModifierButton:update(t, dt)
	local desired_size = self._image_size * ((self:is_selected() or self:is_active()) and 1 or 0.8)
	local s = self:smoothstep(self._image:w(), desired_size, 500 * dt, 100)

	self._image:set_size(s, s)
	self._image:set_center_x(self._image_pos.x)
	self._image:set_center_y(self._image_pos.y)
end

-- Lines 495-500
function CrimeSpreeModifierButton:smoothstep(a, b, step, n)
	local v = step / n
	v = 1 - (1 - v) * (1 - v)
	local x = a * (1 - v) + b * v

	return x
end

CrimeSpreeButton = CrimeSpreeButton or class(MenuGuiItem)
CrimeSpreeButton._type = "CrimeSpreeButton"

-- Lines 507-548
function CrimeSpreeButton:init(parent, font, font_size)
	self._w = 0.35
	self._color = tweak_data.screen_colors.button_stage_3
	self._selected_color = tweak_data.screen_colors.button_stage_2
	self._links = {}
	self._panel = parent:panel({
		layer = 1000,
		x = parent:w() * (1 - self._w) - padding,
		w = parent:w() * self._w,
		h = font_size or tweak_data.menu.pd2_medium_font_size
	})

	self._panel:set_bottom(parent:h())

	self._text = self._panel:text({
		y = 0,
		blend_mode = "add",
		align = "right",
		text = "",
		halign = "right",
		x = 0,
		layer = 1,
		color = self._color,
		font = font or tweak_data.menu.pd2_medium_font,
		font_size = font_size or tweak_data.menu.pd2_medium_font_size
	})
	self._highlight = self._panel:rect({
		blend_mode = "add",
		alpha = 0.2,
		valign = "scale",
		halign = "scale",
		layer = 10,
		color = self._color
	})

	self:refresh()
end

-- Lines 550-554
function CrimeSpreeButton:refresh()
	self._highlight:set_visible(self:is_selected())
	self._highlight:set_color(self:is_selected() and self._selected_color or self._color)
	self._text:set_color(self:is_selected() and self._selected_color or self._color)
end

-- Lines 556-558
function CrimeSpreeButton:panel()
	return self._panel
end

-- Lines 560-562
function CrimeSpreeButton:inside(x, y)
	return self._panel:inside(x, y)
end

-- Lines 564-566
function CrimeSpreeButton:callback()
	return self._callback
end

-- Lines 568-570
function CrimeSpreeButton:set_callback(clbk)
	self._callback = clbk
end

-- Lines 572-574
function CrimeSpreeButton:set_button(btn)
	self._btn = btn
end

-- Lines 576-579
function CrimeSpreeButton:set_text(text)
	local prefix = not managers.menu:is_pc_controller() and self._btn and managers.localization:get_default_macro(self._btn) or ""

	self._text:set_text(prefix .. text)
end

-- Lines 581-583
function CrimeSpreeButton:get_link(dir)
	return self._links[dir]
end

-- Lines 585-587
function CrimeSpreeButton:set_link(dir, item)
	self._links[dir] = item
end

-- Lines 589-590
function CrimeSpreeButton:update(t, dt)
end

-- Lines 592-595
function CrimeSpreeButton:shrink_wrap_button(w_padding, h_padding)
	local _, _, w, h = self._text:text_rect()

	self._panel:set_size(w + (w_padding or 0), h + (h_padding or 0))
end
