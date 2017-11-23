require("lib/managers/HUDManager")
require("lib/managers/HUDManagerVR")


-- Lines: 4 to 8
local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

local PADDING = 30
VRGuiObject = VRGuiObject or class()

-- Lines: 16 to 28
function VRGuiObject:init(panel, id, params)
	self._id = id
	self._panel = panel:panel({
		w = params.w,
		h = params.h,
		x = params.x,
		y = params.y
	})
	self._parent_menu = params.parent_menu
	self._enabled = true
end

-- Lines: 30 to 31
function VRGuiObject:id()
	return self._id
end

-- Lines: 34 to 35
function VRGuiObject:parent_menu()
	return self._parent_menu
end

-- Lines: 38 to 41
function VRGuiObject:set_enabled(enabled)
	self._enabled = enabled

	self._panel:set_visible(enabled)
end

-- Lines: 43 to 44
function VRGuiObject:enabled()
	return self._enabled
end

-- Lines: 48 to 59
function VRGuiObject:set_selected(selected)
	if self._selected == selected then
		return
	end

	self._selected = selected

	if selected then
		managers.menu:post_event("highlight")
	end

	return true
end

-- Lines: 62 to 63
function VRGuiObject:moved(x, y)
end

-- Lines: 65 to 66
function VRGuiObject:pressed(x, y)
end

-- Lines: 68 to 69
function VRGuiObject:released(x, y)
end
local overrides = {
	"inside",
	"x",
	"y",
	"w",
	"h",
	"left",
	"right",
	"top",
	"bottom",
	"set_x",
	"set_y",
	"set_w",
	"set_h",
	"set_left",
	"set_right",
	"set_top",
	"set_bottom",
	"set_visible"
}

for _, func in ipairs(overrides) do

	-- Lines: 72 to 73
	VRGuiObject[func] = function (self, ...)
		return self._panel[func](self._panel, ...)
	end
end

local unselected_color = Color.black:with_alpha(0.5)
local selected_color = Color.black:with_alpha(0.7)
VRButton = VRButton or class(VRGuiObject)

-- Lines: 83 to 102
function VRButton:init(panel, id, params)
	params.w = params.w or 200
	params.h = params.h or 75

	VRButton.super.init(self, panel, id, params)

	self._bg = self._panel:rect({
		name = "bg",
		color = unselected_color
	})
	self._text = self._panel:text({
		font_size = 50,
		text = managers.localization:to_upper_text(params.text_id),
		font = tweak_data.menu.pd2_massive_font
	})

	make_fine_text(self._text)
	self._text:set_center(self._panel:w() / 2, self._panel:h() / 2)
	BoxGuiObject:new(self._panel, {sides = {
		1,
		1,
		1,
		1
	}})
end

-- Lines: 104 to 108
function VRButton:set_selected(selected)
	if VRButton.super.set_selected(self, selected) then
		self._bg:set_color(selected and selected_color or unselected_color)
	end
end

-- Lines: 110 to 114
function VRButton:set_text(text_id)
	self._text:set_text(managers.localization:to_upper_text(text_id))
	make_fine_text(self._text)
	self._text:set_center_x(self._panel:w() / 2)
end
VRSlider = VRSlider or class(VRGuiObject)

-- Lines: 119 to 160
function VRSlider:init(panel, id, params)
	params.w = params.w or 400
	params.h = params.h or 75

	VRSlider.super.init(self, panel, id, params)

	self._value = params.value or 0
	self._max = params.max or 1
	self._min = params.min or 0
	self._snap = params.snap or 1
	self._value_clbk = params.value_clbk
	self._line = self._panel:rect({
		h = 4,
		name = "line"
	})

	self._line:set_center_y(self._panel:h() / 2)

	self._mid_piece = self._panel:panel({
		w = 100,
		name = "mid_piece",
		layer = 1
	})

	self._mid_piece:set_center_x(self._panel:w() / 2)

	self._bg = self._mid_piece:rect({
		name = "bg",
		color = unselected_color
	})
	self._text = self._mid_piece:text({
		font_size = 50,
		text = tostring(math.floor(self._value)),
		font = tweak_data.menu.pd2_massive_font
	})

	make_fine_text(self._text)
	self._text:set_center(self._mid_piece:w() / 2, self._mid_piece:h() / 2)
	BoxGuiObject:new(self._mid_piece, {sides = {
		1,
		1,
		1,
		1
	}})
	self:_update_position()
end

-- Lines: 162 to 163
function VRSlider:value()
	return self._value
end

-- Lines: 166 to 167
function VRSlider:value_ratio()
	return (self._value - self._min) / (self._max - self._min)
end

-- Lines: 170 to 171
function VRSlider:value_from_ratio(ratio)
	return math.clamp((self._max - self._min) * ratio + self._min, self._min, self._max)
end

-- Lines: 174 to 178
function VRSlider:set_value(value)
	self._value = math.clamp(value, self._min, self._max)

	self:set_text(math.floor(self._value))
	self:_update_position()
end

-- Lines: 180 to 184
function VRSlider:_update_position()
	local value_ratio = self:value_ratio()
	local w = self._panel:w() - self._mid_piece:w()

	self._mid_piece:set_center_x(value_ratio * w + self._mid_piece:w() / 2)
end

-- Lines: 186 to 190
function VRSlider:set_selected(selected)
	if VRButton.super.set_selected(self, selected) then
		self._bg:set_color(selected and selected_color or unselected_color)
	end
end

-- Lines: 192 to 196
function VRSlider:set_text(text)
	self._text:set_text(tostring(text))
	make_fine_text(self._text)
	self._text:set_center_x(self._mid_piece:w() / 2)
end

-- Lines: 198 to 206
function VRSlider:pressed(x, y)
	if not self._selected then
		return
	end

	self._start_x = x
	self._start_ratio = self:value_ratio()
	self._pressed = true
end

-- Lines: 208 to 214
function VRSlider:released(x, y)
	if self._pressed and self._value_clbk then
		self._value_clbk(self._value)
	end

	self._pressed = nil
end

-- Lines: 216 to 227
function VRSlider:moved(x, y)
	if self._pressed then
		local diff = x - self._start_x
		local diff_ratio = diff / (self._panel:w() - self._mid_piece:w())

		if self._snap <= math.abs(diff_ratio) * self._max then
			self:set_value(math.floor(self:value_from_ratio(diff_ratio + self._start_ratio) / self._snap) * self._snap)

			self._start_ratio = self:value_ratio()
			self._start_x = self._panel:world_x() + self._mid_piece:w() / 2 + (self._panel:w() - self._mid_piece:w()) * self._start_ratio
		end
	end
end
VRSettingButton = VRSettingButton or class(VRButton)

-- Lines: 233 to 242
function VRSettingButton:init(panel, id, params)
	if not params.setting then
		Application:error("Tried to add a setting button without a setting!")
	end

	params.text_id = self:_get_setting_text(managers.vr:get_setting(params.setting))

	VRSettingButton.super.init(self, panel, id, params)

	self._setting = params.setting
end

-- Lines: 244 to 250
function VRSettingButton:_get_setting_text(value)
	if type(value) == "boolean" then
		return value and "menu_vr_on" or "menu_vr_off"
	else
		return "menu_vr_" .. tostring(value)
	end
end

-- Lines: 252 to 255
function VRSettingButton:setting_changed()
	local new_value = managers.vr:get_setting(self._setting)

	self:set_text(self:_get_setting_text(new_value))
end
VRSettingSlider = VRSettingSlider or class(VRSlider)

-- Lines: 260 to 276
function VRSettingSlider:init(panel, id, params)
	if not params.setting then
		Application:error("Tried to add a setting slider without a setting!")
	end

	params.value = managers.vr:get_setting(params.setting)
	params.value_clbk = params.value_clbk or function (value)
		managers.vr:set_setting(params.setting, value)
	end
	params.min, params.max = managers.vr:setting_limits(params.setting)

	if not params.max then
		Application:error("Tried to add a setting slider without limits: " .. params.setting)
	end

	VRSettingSlider.super.init(self, panel, id, params)

	self._setting = params.setting
end

-- Lines: 278 to 281
function VRSettingSlider:setting_changed()
	local new_value = managers.vr:get_setting(self._setting)

	self:set_value(new_value)
end
VRSettingTrigger = VRSettingTrigger or class(VRButton)

-- Lines: 285 to 290
function VRSettingTrigger:init(panel, id, params)
	VRSettingTrigger.super.init(self, panel, id, params)

	self._setting = params.setting
	self._change_clbk = params.change_clbk
end

-- Lines: 292 to 296
function VRSettingTrigger:setting_changed()
	if self._change_clbk then
		self:_change_clbk(managers.vr:get_setting(self._setting))
	end
end
VRMenu = VRMenu or class()

-- Lines: 302 to 306
function VRMenu:init()
	self._buttons = {}
	self._sub_menus = {}
	self._objects = {}
end

-- Lines: 308 to 315
function VRMenu:set_selected(index)
	if self._selected and self._selected ~= index then
		self._buttons[self._selected].button:set_selected(false)
	end

	if index then
		self._buttons[index].button:set_selected(true)
	end

	self._selected = index
end

-- Lines: 317 to 318
function VRMenu:selected()
	return self._selected and self._buttons[self._selected]
end

-- Lines: 321 to 336
function VRMenu:mouse_moved(o, x, y)
	local selected = nil

	for i, button in ipairs(self._buttons) do
		if button.button:inside(x, y) and button.button:enabled() then
			selected = i
		end

		button.button:moved(x, y)
	end

	self:set_selected(selected)

	if self._open_menu then
		self._open_menu:mouse_moved(o, x, y)
	end
end

-- Lines: 338 to 350
function VRMenu:mouse_pressed(o, button, x, y)
	if button ~= Idstring("0") then
		return
	end

	for _, button in ipairs(self._buttons) do
		button.button:pressed(x, y)
	end

	if self._open_menu then
		self._open_menu:mouse_pressed(o, button, x, y)
	end
end

-- Lines: 352 to 364
function VRMenu:mouse_released(o, button, x, y)
	if button ~= Idstring("0") then
		return
	end

	for _, button in ipairs(self._buttons) do
		button.button:released(x, y)
	end

	if self._open_menu then
		self._open_menu:mouse_released(o, button, x, y)
	end
end

-- Lines: 366 to 375
function VRMenu:mouse_clicked(o, button, x, y)
	if self:selected() and self:selected().clbk then
		self:selected().clbk(self:selected().button)
		managers.menu:post_event("menu_enter")
	end

	if self._open_menu then
		self._open_menu:mouse_clicked(o, button, x, y)
	end
end

-- Lines: 377 to 379
function VRMenu:add_object(id, obj)
	self._objects[id] = obj
end

-- Lines: 381 to 386
function VRMenu:remove_object(id)
	if self._objects[id].destroy then
		self._objects[id]:destroy()
	end

	self._objects[id] = nil
end

-- Lines: 388 to 389
function VRMenu:object(id)
	return self._objects[id]
end

-- Lines: 392 to 396
function VRMenu:clear_objects()
	for id in pairs(self._objects) do
		self:remove_object(id)
	end
end

-- Lines: 398 to 402
function VRMenu:update(t, dt)
	for id, obj in pairs(self._objects) do
		obj:update(t, dt)
	end
end
VRSubMenu = VRSubMenu or class(VRMenu)

-- Lines: 408 to 413
function VRSubMenu:init(panel, id)
	VRSubMenu.super.init(self)

	self._id = id
	self._enabled = false
	self._panel = panel:panel({
		visible = false,
		w = panel:w() * 0.8 - PADDING * 2,
		h = panel:h() - PADDING * 2,
		x = panel:w() * 0.2 + PADDING,
		y = PADDING
	})
end

-- Lines: 415 to 424
function VRSubMenu:add_desc(desc)
	self._desc = self._panel:text({
		word_wrap = true,
		wrap = true,
		text = managers.localization:text(desc),
		font = tweak_data.menu.pd2_large_font,
		font_size = tweak_data.menu.pd2_large_font_size
	})

	make_fine_text(self._desc)
end

-- Lines: 426 to 427
function VRSubMenu:setting(id)
	return self._settings and self._settings[id]
end

-- Lines: 430 to 501
function VRSubMenu:add_setting(type, text_id, setting, params)
	local y_offset = 0

	if self._desc then
		y_offset = self._desc:h()
	end

	self._settings = self._settings or {}
	local num_settings = table.size(self._settings)
	params = params or {}
	local setting_text = self._panel:text({
		word_wrap = true,
		wrap = true,
		text = managers.localization:text(text_id),
		font = tweak_data.menu.pd2_large_font,
		font_size = tweak_data.menu.pd2_large_font_size,
		y = num_settings * 100 + y_offset
	})
	local setting_item, clbk = nil

	if type == "button" then
		setting_item = VRSettingButton:new(self._panel, setting, table.map_append({
			setting = setting,
			parent_menu = self
		}, params))


		-- Lines: 452 to 460
		function clbk(btn)
			local new_value = not managers.vr:get_setting(setting)

			managers.vr:set_setting(setting, new_value)
			btn:setting_changed()

			if params.clbk then
				params.clbk(new_value)
			end
		end
	elseif type == "slider" then

		-- Lines: 461 to 462
		local function clbk(value)
			managers.vr:set_setting(setting, value)
		end

		setting_item = VRSettingSlider:new(self._panel, setting, table.map_append({
			setting = setting,
			parent_menu = self
		}, params))
	elseif type == "multi_button" then
		if not params.options then
			Application:error("Tried to add a multi_button setting without options: " .. setting)

			params.options = {"error"}
		end

		local option_count = #params.options
		setting_item = VRSettingButton:new(self._panel, setting, table.map_append({
			setting = setting,
			parent_menu = self
		}, params))


		-- Lines: 474 to 484
		function clbk(btn)
			local current_index = table.index_of(params.options, managers.vr:get_setting(setting))
			local new_index = current_index % option_count + 1
			local new_value = params.options[new_index]

			managers.vr:set_setting(setting, new_value)
			btn:setting_changed()

			if params.clbk then
				params.clbk(new_value)
			end
		end
	elseif type == "trigger" then
		params.text_id = params.trigger_text_id
		setting_item = VRSettingTrigger:new(self._panel, setting, table.map_append({
			setting = setting,
			parent_menu = self
		}, params))


		-- Lines: 488 to 491
		function clbk(btn)
			local value = params.value_clbk(btn)

			managers.vr:set_setting(setting, value)
		end
	end

	setting_item:set_y(num_settings * 100 + y_offset)
	setting_item:set_right(self._panel:w() - PADDING)
	setting_text:set_w((self._panel:w() - setting_item:w()) - PADDING * 2)
	make_fine_text(setting_text)
	table.insert(self._buttons, {
		button = setting_item,
		clbk = clbk,
		custom_params = {
			x = setting_item:x(),
			y = setting_item:y()
		}
	})

	self._settings[setting] = {
		text = setting_text,
		button = setting_item
	}
end

-- Lines: 503 to 510
function VRSubMenu:set_setting_enabled(setting, enabled)
	local item = self:setting(setting)

	if item then
		item.text:set_visible(enabled)
		item.button:set_visible(enabled)
		item.button:set_enabled(enabled)
	end
end

-- Lines: 512 to 518
function VRSubMenu:add_button(id, text, clbk, custom_params)
	custom_params = custom_params or {}
	local button = VRButton:new(self._panel, id, {
		text_id = text,
		parent_menu = self
	})

	button:set_x(custom_params.x or ((self._buttons[#self._buttons] and self._buttons[#self._buttons].button:left() or self._panel:w()) - button:w()) - PADDING)
	button:set_y(custom_params.y or (self._panel:h() - button:h()) - PADDING)
	table.insert(self._buttons, {
		button = button,
		clbk = clbk,
		custom_params = custom_params
	})

	return button
end

-- Lines: 521 to 528
function VRSubMenu:set_button_enabled(id, enabled)
	for _, button in ipairs(self._buttons) do
		if button.button:id() == id then
			button.button:set_enabled(enabled)
		end
	end

	self:layout_buttons()
end

-- Lines: 530 to 538
function VRSubMenu:layout_buttons()
	local last_x = self._panel:w()

	for _, button in ipairs(self._buttons) do
		if button.button:enabled() and not button.custom_params.x then
			button.button:set_x((last_x - button.button:w()) - PADDING)

			last_x = button.button:x()
		end
	end
end

-- Lines: 540 to 567
function VRSubMenu:add_image(params)
	if not params or not params.texture then
		Application:error("[VRSubMenu:add_image] tried to add missing image!")

		return
	end

	local image = self._panel:bitmap({
		texture = params.texture,
		x = params.x,
		y = params.y,
		w = params.w,
		h = params.h
	})

	if params.fit then
		if params.fit == "height" then
			local h = self._panel:h()
			local dh = h / image:texture_height()

			image:set_size(image:texture_width() * dh, h)
		elseif params.fit == "width" then
			local w = self._panel:w()
			local dw = w / image:texture_width()

			image:set_size(w, image:texture_height() * dw)
		else
			image:set_size(self._panel:w(), self._panel:h())
		end
	end
end

-- Lines: 569 to 582
function VRSubMenu:set_temp_text(text_id, color)
	self:clear_temp_text()

	self._temp_text = self._panel:text({
		word_wrap = true,
		wrap = true,
		text = managers.localization:text(text_id),
		font = tweak_data.menu.pd2_large_font,
		font_size = tweak_data.menu.pd2_large_font_size,
		color = color or Color.white,
		y = self._desc:bottom() + PADDING
	})

	make_fine_text(self._temp_text)
end

-- Lines: 584 to 589
function VRSubMenu:clear_temp_text()
	if alive(self._temp_text) then
		self._panel:remove(self._temp_text)

		self._temp_text = nil
	end
end

-- Lines: 591 to 592
function VRSubMenu:id()
	return self._id
end

-- Lines: 595 to 597
function VRSubMenu:set_enabled_clbk(clbk)
	self._enabled_clbk = clbk
end

-- Lines: 599 to 606
function VRSubMenu:set_enabled(enabled)
	if self._enabled_clbk then
		self:_enabled_clbk(enabled)
	end

	self._enabled = enabled

	self._panel:set_visible(enabled)
end

-- Lines: 608 to 609
function VRSubMenu:enabled()
	return self._enabled
end
VRCustomizationGui = VRCustomizationGui or class(VRMenu)

-- Lines: 616 to 633
function VRCustomizationGui:init(is_start_menu)
	VRCustomizationGui.super.init(self)

	self._is_start_menu = is_start_menu
	self._ws = managers.gui_data:create_fullscreen_workspace("left")

	managers.menu:player():register_workspace({
		ws = self._ws,
		activate = callback(self, self, "activate"),
		deactivate = callback(self, self, "deactivate")
	})

	self._id = "vr_customization"

	if not is_start_menu then
		self:initialize()
	else
		self._ws:hide()
	end
end

-- Lines: 635 to 651
function VRCustomizationGui:initialize()
	if not self._initialized then
		self:_setup_gui()
		managers.vr:show_savefile_dialog()

		if not managers.vr:has_set_height() then
			managers.menu:show_vr_settings_dialog()
			self:open_sub_menu("height")
		end

		self._ws:show()

		self._initialized = true
	end
end

-- Lines: 653 to 681
function VRCustomizationGui:_setup_gui()
	if alive(self._panel) then
		self._panel:clear()
	end

	self._panel = self._ws:panel():panel({})
	self._buttons = {}
	self._bg = self._panel:bitmap({
		texture = "guis/dlcs/vr/textures/pd2/bg",
		name = "bg",
		layer = -2
	})
	local h = self._panel:h()
	local dh = h / self._bg:texture_height()

	self._bg:set_size(self._bg:texture_width() * dh, h)
	self:_setup_sub_menus()
	self:add_back_button()

	self._controls_image = self._panel:bitmap({
		texture = "guis/dlcs/vr/textures/pd2/menu_controls",
		x = self._panel:w() * 0.2 + PADDING,
		y = PADDING
	})
	local h = self._panel:h() - PADDING * 2
	local dh = h / self._controls_image:texture_height()

	self._controls_image:set_size(self._controls_image:texture_width() * dh, h)
end

-- Lines: 683 to 733
function VRCustomizationGui:_setup_sub_menus()
	self._sub_menus = {}
	self._open_menu = nil
	local is_start_menu = self._is_start_menu

	self:add_sub_menu("height", "menu_vr_height_desc", {
		{
			text = "menu_vr_calibrate",
			id = "calibrate",
			clbk = function (btn)
				local hmd_pos = VRManager:hmd_position()

				managers.vr:set_setting("height", hmd_pos.z)
				managers.system_menu:close("vr_settings")
				btn:parent_menu():set_temp_text("menu_vr_height_success", Color.green)
			end
		},
		{
			text = "menu_vr_reset",
			id = "reset",
			clbk = function (btn)
				managers.vr:reset_setting("height")
			end
		}
	})
	self:add_settings_menu("belt", {{
		setting = "belt_snap",
		type = "slider",
		text_id = "menu_vr_belt_snap",
		params = {snap = 15}
	}}, function (menu, enabled)
		if enabled then
			if not menu:object("belt") then
				menu:add_object("belt", VRBeltCustomization:new(is_start_menu))
			end
		elseif menu:object("belt") then
			menu:remove_object("belt")
		end
	end)
	self:add_settings_menu("gameplay", {
		{
			setting = "auto_reload",
			type = "button",
			text_id = "menu_vr_auto_reload_text"
		},
		{
			setting = "default_weapon_hand",
			type = "multi_button",
			text_id = "menu_vr_default_weapon_hand",
			params = {
				options = {
					"right",
					"left"
				},
				clbk = function (value)
					managers.menu:set_primary_hand(value)
				end
			}
		},
		{
			setting = "default_tablet_hand",
			type = "multi_button",
			text_id = "menu_vr_default_tablet_hand",
			params = {options = {
				"left",
				"right"
			}}
		}
	})
	self:add_settings_menu("advanced", {
		{
			setting = "weapon_switch_button",
			type = "button",
			text_id = "menu_vr_weapon_switch_button"
		},
		{
			setting = "autowarp_length",
			type = "multi_button",
			text_id = "menu_vr_autowarp_length",
			params = {options = {
				"off",
				"long",
				"short"
			}}
		},
		{
			setting = "zipline_screen",
			type = "button",
			text_id = "menu_vr_zipline_screen"
		}
	})
end

-- Lines: 735 to 736
function VRCustomizationGui:sub_menu(id)
	return self._sub_menus[id]
end

-- Lines: 739 to 753
function VRCustomizationGui:add_sub_menu(id, desc, buttons, clbk)
	local menu = VRSubMenu:new(self._panel, id)

	menu:add_desc(desc)
	menu:set_enabled_clbk(clbk)

	for _, button in ipairs(buttons) do
		local btn = menu:add_button(button.id, button.text, button.clbk)

		if button.enabled ~= nil then
			btn:set_enabled(button.enabled)
		end
	end

	menu:layout_buttons()

	self._sub_menus[id] = menu

	self:add_menu_button(id)
end

-- Lines: 755 to 774
function VRCustomizationGui:add_settings_menu(id, settings, clbk)
	local menu = VRSubMenu:new(self._panel, id)

	menu:set_enabled_clbk(clbk)
	menu:add_button("reset_" .. id, "menu_vr_reset", function ()
		for setting, item in pairs(menu._settings) do
			managers.vr:reset_setting(setting)
			item.button:setting_changed()
		end

		for _, object in pairs(menu._objects) do
			if object.reset then
				object:reset()
			end
		end
	end)

	for _, setting in ipairs(settings) do
		menu:add_setting(setting.type, setting.text_id, setting.setting, setting.params)
	end

	self._sub_menus[id] = menu

	self:add_menu_button(id)
end

-- Lines: 776 to 782
function VRCustomizationGui:add_image_menu(id, params, clbk)
	local menu = VRSubMenu:new(self._panel, id)

	menu:set_enabled_clbk(clbk)
	menu:add_image(params)

	self._sub_menus[id] = menu

	self:add_menu_button(id)
end

-- Lines: 784 to 791
function VRCustomizationGui:open_sub_menu(id)
	self:close_sub_menu()
	self._controls_image:set_visible(false)

	self._open_menu = self._sub_menus[id]

	self._open_menu:set_enabled(true)
end

-- Lines: 793 to 800
function VRCustomizationGui:close_sub_menu()
	if self._open_menu then
		self._open_menu:set_enabled(false)

		self._open_menu = nil

		self._controls_image:set_visible(true)
	end
end

-- Lines: 802 to 807
function VRCustomizationGui:add_menu_button(id)
	local x = PADDING
	local y = PADDING + (self._buttons[#self._buttons] and self._buttons[#self._buttons].button:bottom() or 0)
	local button = VRButton:new(self._panel, id, {
		text_id = "menu_vr_open_" .. id,
		x = x,
		y = y
	})

	table.insert(self._buttons, {
		button = button,
		clbk = callback(self, self, "open_sub_menu", id)
	})
end

-- Lines: 809 to 814
function VRCustomizationGui:add_back_button()
	local x = PADDING
	local y = (self._panel:h() - 75) - PADDING
	local button = VRButton:new(self._panel, "back", {
		text_id = "menu_vr_back",
		x = x,
		y = y
	})

	table.insert(self._buttons, {
		button = button,
		clbk = callback(self, self, "close_sub_menu")
	})
end

-- Lines: 816 to 820
function VRCustomizationGui:update(t, dt)
	if self._open_menu then
		self._open_menu:update(t, dt)
	end
end

-- Lines: 822 to 832
function VRCustomizationGui:activate()
	local clbks = {
		mouse_move = callback(self, self, "mouse_moved"),
		mouse_click = callback(self, self, "mouse_clicked"),
		mouse_press = callback(self, self, "mouse_pressed"),
		mouse_release = callback(self, self, "mouse_released"),
		id = self._id
	}

	managers.mouse_pointer:use_mouse(clbks)

	self._active = true
end

-- Lines: 834 to 837
function VRCustomizationGui:deactivate()
	managers.mouse_pointer:remove_mouse(self._id)

	self._active = false
end

-- Lines: 839 to 849
function VRCustomizationGui:exit_menu()
	for _, menu in pairs(self._sub_menus) do
		menu:clear_objects()
	end

	if self._active then
		self:deactivate()
	end

	self:_setup_gui()
end
VRBeltCustomization = VRBeltCustomization or class()

-- Lines: 855 to 883
function VRBeltCustomization:init(is_start_menu)
	local scene = is_start_menu and World or MenuRoom
	local player = managers.menu:player()
	self._belt_unit = World:spawn_unit(Idstring("units/pd2_dlc_vr/player/vr_hud_belt"), Vector3(0, 0, 0), Rotation())

	self._belt_unit:set_visible(false)

	self._ws = scene:gui():create_world_workspace(1280, 680, Vector3(), math.X, math.Y)
	self._belt = HUDBelt:new(self._ws)

	HUDManagerVR.link_belt(self._ws, self._belt_unit)

	self._help_ws = scene:gui():create_linked_workspace(256, 300, self._belt_unit:orientation_object(), Vector3(-10, 10, 24.5), math.X * 20, -math.Z * 24.5)
	self._help_panel = self._help_ws:panel()

	self:_setup_help_panel(self._help_panel)

	self._height = managers.vr:get_setting("height") * managers.vr:get_setting("belt_height_ratio")
	self._start_height = self._height

	self._belt_unit:set_position(is_start_menu and Vector3(-320, 10, self._height) or player:position():with_z(self._height) - Vector3(20, 0, 0))
	self._belt_unit:set_rotation(Rotation(90))
	self._belt:set_alpha(0.4)
	player._hand_state_machine:enter_hand_state(player:primary_hand_index(), "customization")
	managers.menu:active_menu().input:focus(false)
	managers.menu:active_menu().input:focus(true)
end

-- Lines: 885 to 890
function VRBeltCustomization:reset()
	managers.vr:reset_setting("belt_height_ratio")

	self._start_height = managers.vr:get_setting("belt_height_ratio") * managers.vr:get_setting("height")
	self._height = self._start_height
end

-- Lines: 892 to 905
function VRBeltCustomization:_setup_help_panel(panel)
	local up_arrow = panel:bitmap({
		texture = "guis/dlcs/vr/textures/pd2/icon_belt_arrow",
		name = "up_arrow",
		texture_rect = {
			128,
			0,
			128,
			128
		}
	})

	up_arrow:set_center_x(panel:w() / 2)

	local down_arrow = panel:bitmap({
		texture = "guis/dlcs/vr/textures/pd2/icon_belt_arrow",
		name = "down_arrow",
		rotation = 180,
		texture_rect = {
			128,
			0,
			128,
			128
		}
	})

	down_arrow:set_center_x(panel:w() / 2)
	down_arrow:set_bottom(panel:h())

	local text = panel:text({
		name = "text",
		text = managers.localization:to_upper_text("menu_vr_belt_grip"),
		font = tweak_data.hud.medium_font_noshadow,
		font_size = tweak_data.hud.default_font_size
	})

	make_fine_text(text)
	text:set_center(panel:w() / 2, panel:h() / 2)

	self._state = "active"
end

-- Lines: 907 to 930
function VRBeltCustomization:_set_help_state(state)
	if state == self._state then
		return
	end

	self._state = state
	local grip = state == "grip"
	local inactive = state == "inactive"
	local x = grip and 0 or 128
	local up_arrow = self._help_panel:child("up_arrow")

	up_arrow:set_texture_rect(x, 0, 128, 128)
	up_arrow:set_alpha(inactive and 0.2 or 1)

	local down_arrow = self._help_panel:child("down_arrow")

	down_arrow:set_texture_rect(x, 0, 128, 128)
	down_arrow:set_alpha(inactive and 0.2 or 1)

	local text = self._help_panel:child("text")

	text:set_alpha(inactive and 0.5 or 1)
	text:set_text(managers.localization:to_upper_text(grip and "menu_vr_belt_release" or "menu_vr_belt_grip"))
	make_fine_text(text)
	text:set_center_x(self._help_panel:w() / 2)
end

-- Lines: 932 to 947
function VRBeltCustomization:destroy()
	self._ws:gui():destroy_workspace(self._ws)
	self._help_ws:gui():destroy_workspace(self._help_ws)

	local player = managers.menu:player()

	player._hand_state_machine:enter_hand_state(player:primary_hand_index(), "laser")

	if managers.menu:active_menu() then
		managers.menu:active_menu().input:focus(false)
		managers.menu:active_menu().input:focus(true)
	end

	self._belt:destroy()
	World:delete_unit(self._belt_unit)
end

-- Lines: 949 to 950
function VRBeltCustomization:height()
	return self._height
end

-- Lines: 953 to 996
function VRBeltCustomization:update(t, dt)
	local player = managers.menu:player()
	local hand = player:hand(player:primary_hand_index())
	local height_diff = hand:position().z - self._belt_unit:position().z

	if mvector3.distance_sq(hand:position(), self._belt_unit:position()) < 1600 and math.abs(height_diff) < 15 then
		self._belt:set_alpha(0.9)

		if managers.menu:get_controller():get_input_pressed("interact") then
			self._grip_offset = height_diff
		end

		if managers.menu:get_controller():get_input_bool("interact") and self._grip_offset then
			local height = managers.vr:get_setting("height")
			local z = hand:position().z - self._grip_offset
			local min, max = managers.vr:setting_limits("belt_height_ratio")

			if min and max then
				z = math.clamp(z, height * min, height * max)
			end

			self._height = z

			self:_set_help_state("grip")
		else
			self:_set_help_state("active")
		end
	else
		self._belt:set_alpha(0.4)
		self:_set_help_state("inactive")
	end

	if managers.menu:get_controller():get_input_released("interact") then
		managers.vr:set_setting("belt_height_ratio", self:height() / managers.vr:get_setting("height"))
	end

	self._belt_unit:set_position(player:position():with_z(self._height) + math.Y:rotate_with(self._belt_unit:rotation()) * 20)

	local hmd_rot = VRManager:hmd_rotation()
	local snap_angle = managers.vr:get_setting("belt_snap")
	local yaw_rot = Rotation(hmd_rot:yaw())
	local angle = Rotation:rotation_difference(Rotation(self._belt_unit:rotation():yaw()), yaw_rot):yaw()
	angle = math.abs(angle)

	if snap_angle < angle then
		self._belt_unit:set_rotation(yaw_rot)
	end
end

