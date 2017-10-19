require("lib/managers/menu/ExtendedPanel")
require("lib/managers/menu/UiPlacer")
require("lib/managers/menu/ScrollablePanel")

local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.pd2_tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size


-- Lines: 21 to 26
local function set_defaults(target, source)
	target = target or {}

	for k, v in pairs(source) do
		target[k] = target[k] or v
	end

	return target
end

GrowPanel = GrowPanel or class(ExtendedPanel)

-- Lines: 33 to 47
function GrowPanel:init(parent, config)
	config = config or {}

	GrowPanel.super.init(self, parent, config)

	self._fixed_w = config.fixed_w and (config.fixed_w ~= true and config.fixed_w or config.w or parent:w())
	self._fixed_h = config.fixed_h and (config.fixed_h ~= true and config.fixed_h or config.h or parent:h())

	self:set_size(self._fixed_w or config.w or 0, self._fixed_h or config.h or 0)

	local padd_x = config.padding_x or config.padding or 0
	local padd_y = config.padding_y or config.padding or 0
	local bord_x = config.border_x or config.border or padd_x
	local bord_y = config.border_y or config.border or padd_y
	self._placer = ResizingPlacer:new(self, {
		border_x = bord_x,
		border_y = bord_y,
		padding_x = padd_x,
		padding_y = padd_y
	})
end

-- Lines: 49 to 53
function GrowPanel:clear()
	GrowPanel.super.clear(self)
	self._placer:clear()
	self:_set_ensure_size(self._fixed_w or 0, self._fixed_h or 0)
end

-- Lines: 55 to 56
function GrowPanel:placer()
	return self._placer
end

-- Lines: 59 to 62
function GrowPanel:set_fixed_w(w)
	self._fixed_w = w

	self:set_w(w)
end

-- Lines: 64 to 67
function GrowPanel:set_fixed_h(h)
	self._fixed_h = h

	self:set_h(h)
end

-- Lines: 69 to 73
function GrowPanel:_ensure_size(w, h)
	w = math.max(self._fixed_w or w, self:w())
	h = math.max(self._fixed_h or h, self:h())

	self:_set_ensure_size(w, h)
end

-- Lines: 75 to 77
function GrowPanel:_set_ensure_size(w, h)
	self:set_size(w, h)
end

-- Lines: 80 to 81
function GrowPanel:row_w()
	return self:w() - self._placer._border_padding_x * 2
end
ScrollGrowPanel = ScrollGrowPanel or class(GrowPanel)

-- Lines: 88 to 92
function ScrollGrowPanel:init(scroll, config)
	config = set_defaults(config, {use_given = true})

	ScrollGrowPanel.super.init(self, scroll:canvas(), config)

	self._scroll = scroll
end

-- Lines: 94 to 98
function ScrollGrowPanel:clear()
	self._scroll:set_canvas_size(0, 0)
	ScrollGrowPanel.super.clear(self)
end

-- Lines: 100 to 106
function ScrollGrowPanel:_set_ensure_size(w, h)
	if h < self._scroll:canvas_scroll_height() then
		self:set_size(w, h)
	else
		self._scroll:set_canvas_size(w, h)
	end
end
local ScrollablePanelExt = ScrollablePanelExt or class(ScrollablePanel)

-- Lines: 114 to 118
function ScrollablePanelExt:init(parent_panel, name, data)
	self._scroll_padding = data and data.scrollbar_padding

	ScrollablePanelExt.super.init(self, parent_panel, name, data)
end

-- Lines: 120 to 121
function ScrollablePanelExt:scrollbar_padding()
	return self._scroll_padding or ScrollablePanelExt.super.scrollbar_padding(self)
end

-- Lines: 124 to 129
function ScrollablePanelExt:set_canvas_size(w, h)
	ScrollablePanelExt.super.set_canvas_size(self, w, h)

	if self.on_canvas_resized then
		self:on_canvas_resized()
	end
end
ScrollableList = ScrollableList or class(ExtendedPanel)

-- Lines: 135 to 168
function ScrollableList:init(parent, scroll_config, canvas_config)
	scroll_config = set_defaults(scroll_config, {
		ignore_up_indicator = true,
		padding = 0,
		ignore_down_indicator = true,
		layer = parent:layer()
	})
	self._scroll = ScrollablePanelExt:new(parent, nil, scroll_config)
	scroll_config.use_given = true
	local add_as_input = scroll_config.input
	scroll_config.input = nil

	ScrollableList.super.init(self, self._scroll:panel(), scroll_config)

	local scrollbar_padding = scroll_config.scrollbar_padding or scroll_config.padding or self._scroll:padding()
	canvas_config = canvas_config or {}
	local add_canvas = canvas_config.input or add_as_input
	canvas_config.input = nil
	canvas_config.fixed_w = self._scroll._scroll_bar:left() - scrollbar_padding
	self._canvas = ScrollGrowPanel:new(self._scroll, canvas_config)

	self._scroll:set_canvas_size(canvas_config.w or canvas_config.fixed_w, canvas_config.h or 0)

	if add_canvas then
		self:add_input_component(self._canvas)
	end

	if add_as_input then
		if parent.add_input_component then
			parent:add_input_component(self)
		else
			error("Trying to add as input component on parent that doesn't have a add_input_component function")
		end
	end
end

-- Lines: 170 to 175
function ScrollableList:resize(w, h)
	w = w or self:w()
	h = h or self:h()

	self._scroll:set_size(w, h)
end

-- Lines: 177 to 182
function ScrollableList:resize_canvas(w, h)
	w = w or self._canvas:w()
	h = h or self._canvas:h()

	self._canvas:_set_ensure_size(w, h)
end

-- Lines: 184 to 186
function ScrollableList:clear()
	self._canvas:clear()
end

-- Lines: 188 to 199
function ScrollableList:mouse_moved(button, x, y)
	local h, c = self._scroll:mouse_moved(button, x, y)

	if not self._scroll:panel():inside(x, y) then
		return h, c
	end

	local hover, cursor = ScrollableList.super.mouse_moved(self, button, x, y)
	hover = hover or h
	cursor = cursor or c

	return hover, cursor
end

-- Lines: 202 to 206
function ScrollableList:mouse_clicked(o, button, x, y)
	self._scroll:mouse_clicked(o, button, x, y)

	if not self._scroll:panel():inside(x, y) then
		return
	end

	return ScrollableList.super.mouse_clicked(self, o, button, x, y)
end

-- Lines: 209 to 213
function ScrollableList:mouse_pressed(button, x, y)
	self._scroll:mouse_pressed(button, x, y)

	if not self._scroll:panel():inside(x, y) then
		return
	end

	return ScrollableList.super.mouse_pressed(self, button, x, y)
end

-- Lines: 216 to 220
function ScrollableList:mouse_released(button, x, y)
	self._scroll:mouse_released(button, x, y)

	if not self._scroll:panel():inside(x, y) then
		return
	end

	return ScrollableList.super.mouse_released(self, button, x, y)
end

-- Lines: 223 to 227
function ScrollableList:mouse_wheel_up(x, y)
	self._scroll:scroll(x, y, 1)

	if not self._scroll:panel():inside(x, y) then
		return
	end

	return ScrollableList.super.mouse_wheel_up(self, x, y)
end

-- Lines: 230 to 234
function ScrollableList:mouse_wheel_down(x, y)
	self._scroll:scroll(x, y, -1)

	if not self._scroll:panel():inside(x, y) then
		return
	end

	return ScrollableList.super.mouse_wheel_down(self, x, y)
end

-- Lines: 237 to 238
function ScrollableList:canvas()
	return self._canvas
end

-- Lines: 241 to 242
function ScrollableList:scroll_item()
	return self._scroll
end

-- Lines: 245 to 247
function ScrollableList:perform_scroll(val)
	self._scroll:perform_scroll(val, 1)
end

-- Lines: 249 to 264
function ScrollableList:scroll_to_show(top_or_item, bottom)
	local top = nil

	if top_or_item.top and top_or_item.bottom then
		top = top_or_item:top()
		bottom = top_or_item:bottom()
	end

	bottom = bottom - self:h()
	local cur = -self._canvas:y()

	if top < cur then
		self._scroll:scroll_to(top)
	elseif cur < bottom then
		self._scroll:scroll_to(bottom)
	end
end

-- Lines: 269 to 283
function ScrollableList:add_lines_and_static_down_indicator()
	local box = BoxGuiObject:new(self:scroll_item():scroll_panel(), {
		w = self:canvas():w(),
		sides = {
			1,
			1,
			2,
			0
		}
	})
	local down_no_scroll = BoxGuiObject:new(box._panel, {sides = {
		0,
		0,
		0,
		1
	}})
	local down_scroll = BoxGuiObject:new(box._panel, {sides = {
		0,
		0,
		0,
		2
	}})


	-- Lines: 275 to 279
	local function update_down_indicator()
		local indicate = self:scroll_item()._scroll_bar:visible()

		down_no_scroll:set_visible(not indicate)
		down_scroll:set_visible(indicate)
	end

	update_down_indicator()

	self._scroll.on_canvas_resized = update_down_indicator
end
ScrollItemList = ScrollItemList or class(ScrollableList)

-- Lines: 289 to 295
function ScrollItemList:init(parent, scroll_config, canvas_config)
	ScrollItemList.super.init(self, parent, scroll_config, canvas_config)

	self._input_focus = scroll_config.input_focus
	self._items = {}
end

-- Lines: 297 to 301
function ScrollItemList:clear()
	self._items = {}
	self._selected_item = nil

	ScrollItemList.super.clear(self)
end

-- Lines: 303 to 304
function ScrollItemList:items()
	return self._items
end

-- Lines: 307 to 309
function ScrollItemList:set_input_focus(state)
	self._input_focus = state
end

-- Lines: 312 to 313
function ScrollItemList:input_focus()
	return self:allow_input() and self._input_focus
end

-- Lines: 316 to 328
function ScrollItemList:mouse_moved(button, x, y)
	if not self._scroll:panel():inside(x, y) then
		return
	end

	for k, v in pairs(self._items) do
		if v:inside(x, y) then
			if self._selected_item ~= v then
				self:select_item(v)
			end

			break
		end
	end

	return ScrollItemList.super.mouse_moved(self, button, x, y)
end

-- Lines: 331 to 335
function ScrollItemList:_on_selected_changed(selected)
	if self._on_selected_callback then
		self._on_selected_callback(selected)
	end
end

-- Lines: 337 to 339
function ScrollItemList:set_selected_callback(func)
	self._on_selected_callback = func
end

-- Lines: 341 to 342
function ScrollItemList:selected_item()
	return self._selected_item
end

-- Lines: 345 to 347
function ScrollItemList:select_index(index)
	self:select_item(self._items[index])
end

-- Lines: 349 to 361
function ScrollItemList:move_selection(move)
	if not self._selected_item then
		self:select_index(1)
	else
		local new_index = self._selected_item:index() + move
		new_index = math.clamp(new_index, 1, #self._items)

		self:select_index(new_index)
	end

	if self._selected_item then
		self:scroll_to_show(self._selected_item)
	end
end

-- Lines: 363 to 378
function ScrollItemList:select_item(item)
	if item == self._selected_item then
		return
	end

	if self._selected_item then
		self._selected_item:set_selected(false)

		self._selected_item = nil
	end

	if item then
		self._selected_item = item

		item:set_selected(true)
	end

	self:_on_selected_changed(item)
end

-- Lines: 380 to 384
function ScrollItemList:add_item(item)
	self._canvas:placer():add_row(item)
	table.insert(self._items, item)
	item:set_index(#self._items)

	return item
end

-- Lines: 387 to 390
function ScrollItemList:move_up()
	if not self:input_focus() then
		return
	end

	self:move_selection(-1)

	return true
end

-- Lines: 393 to 396
function ScrollItemList:move_down()
	if not self:input_focus() then
		return
	end

	self:move_selection(1)

	return true
end
ListItem = ListItem or class(ExtendedPanel)

-- Lines: 403 to 405
function ListItem:init(...)
	ListItem.super.init(self, ...)
end

-- Lines: 407 to 411
function ListItem:_selected_changed(state)
	if self._select_panel then
		self._select_panel:set_visible(state)
	end
end

-- Lines: 413 to 421
function ListItem:set_selected(state)
	if self._selected == state then
		return
	end

	self._selected = state

	self:_selected_changed(state)

	local _ = state and managers.menu_component:post_event("highlight")
end

-- Lines: 423 to 425
function ListItem:set_index(index)
	self._index = index
end

-- Lines: 427 to 428
function ListItem:index()
	return self._index
end
BaseButton = BaseButton or class(ExtendedPanel)

-- Lines: 440 to 447
function BaseButton:init(parent, config)
	config = set_defaults(config, {input = true})

	BaseButton.super.init(self, parent, config)

	self._binding = config.binding and Idstring(config.binding)
	self._enabled = config.enabled == nil and true or config.enabled
	self._hover = false
end

-- Lines: 449 to 456
function BaseButton:set_enabled(state)
	if self._enabled == state then
		return
	end

	self._enabled = state

	self:_enabled_changed(state)
end

-- Lines: 458 to 459
function BaseButton:_enabled_changed(state)
end

-- Lines: 461 to 462
function BaseButton:_hover_changed(state)
end

-- Lines: 464 to 465
function BaseButton:_trigger()
end

-- Lines: 467 to 468
function BaseButton:allow_input()
	return self._enabled and BaseButton.super.allow_input(self)
end

-- Lines: 471 to 482
function BaseButton:mouse_moved(o, x, y)
	local hover = self:inside(x, y)

	if self._hover ~= hover then
		self._hover = hover

		self:_hover_changed(hover)
	end

	if hover then
		return true, "link"
	end
end

-- Lines: 484 to 489
function BaseButton:mouse_clicked(o, button, x, y)
	if button == Idstring("0") and self:inside(x, y) then
		self:_trigger()

		return true
	end
end

-- Lines: 491 to 496
function BaseButton:special_btn_pressed(button)
	if button == self._binding then
		self:_trigger()

		return true
	end
end
TextButton = TextButton or class(BaseButton)

-- Lines: 510 to 534
function TextButton:init(parent, text_config, func, panel_config)
	panel_config = set_defaults(panel_config, {binding = text_config.binding})

	TextButton.super.init(self, parent, panel_config)

	self._normal_color = text_config.normal_color or text_config.color or tweak_data.screen_colors.button_stage_3
	self._hover_color = text_config.hover_color or text_config.color or tweak_data.screen_colors.button_stage_2
	self._disabled_color = text_config.disabled_color or tweak_data.menu.default_disabled_text_color
	text_config.color = self._normal_color

	if text_config.text_id and text_config.binding then
		text_config.text = managers.localization:text(text_config.text_id, {MY_BTN = managers.localization:btn_macro(text_config.binding, true)})
		text_config.text_id = nil
	end

	self._text = self:fine_text(text_config)
	self._trigger = func or function ()
	end
	self._is_fixed = panel_config.fixed_size

	if not panel_config.fixed_size then
		self._panel:set_size(self._text:rightbottom())
	end

	self:_enabled_changed(self._enabled)
end

-- Lines: 536 to 538
function TextButton:_enabled_changed(state)
	self._text:set_color(state and self._normal_color or self._disabled_color)
end

-- Lines: 540 to 542
function TextButton:_hover_changed(hover)
	self._text:set_color(hover and self._hover_color or self._normal_color)
end

-- Lines: 544 to 551
function TextButton:set_text(text)
	self._text:set_text(text)
	self.make_fine_text(self._text)

	if not self._is_fixed then
		self:set_size(self._text:rightbottom())
	end
end
IconButton = IconButton or class(BaseButton)

-- Lines: 563 to 578
function IconButton:init(parent, icon_config, func)
	IconButton.super.init(self, parent, {}, func)

	self._select_panel = ExtendedPanel:new(self)
	self._normal_color = icon_config.normal_color or icon_config.color
	self._hover_color = icon_config.hover_color or icon_config.color or self._normal_color
	self._disabled_color = icon_config.disabled_color or self._normal_color
	self._button = self._select_panel:bitmap(icon_config)

	self:_set_color(self._normal_color)

	self._trigger = func or function ()
	end

	self:set_size(self._button:size())
end

-- Lines: 580 to 584
function IconButton:_set_color(col)
	if col then
		self._button:set_color(col)
	end
end

-- Lines: 586 to 588
function IconButton:_hover_changed(hover)
	self:_set_color(hover and self._hover_color or self._normal_color)
end

-- Lines: 590 to 592
function IconButton:_enabled_changed(state)
	self:_set_color(state and self._normal_color or self._disabled_color)
end
ProgressBar = ProgressBar or class(ExtendedPanel)

-- Lines: 602 to 619
function ProgressBar:init(parent, config, progress)
	ProgressBar.super.init(self, parent, config)

	config = config or {}
	self._max = config.max or 1
	self._back_color = config.back_config and config.back_config.color or config.back_color or Color.black
	self._progress_color = config.progress_config and config.progress_config.color or config.progress_color or Color.white
	self._back = self:rect(config.back_config or {color = self._back_color})
	self._progress = self:rect(config.progress_config or {
		w = 0,
		color = self._progress_color
	})

	if progress then
		self:set_progress(progress)
	end
end

-- Lines: 621 to 622
function ProgressBar:max()
	return self._max
end

-- Lines: 626 to 629
function ProgressBar:set_progress(v)
	v = math.clamp(v, 0, self._max)

	self._progress:set_w((self._back:w() * v) / self._max)

	return v
end

-- Lines: 633 to 638
function ProgressBar:set_max(v, dont_scale_current)
	local current = dont_scale_current and self._progress:w() / self._back:w() * self._max or self._progress:w() / self._back:w() * v
	self._max = v

	self:set_progress(current)
end
TextProgressBar = TextProgressBar or class(ProgressBar)

-- Lines: 652 to 675
function TextProgressBar:init(parent, config, text_config, progress)
	TextProgressBar.super.init(self, parent, config)

	text_config = text_config or {}
	self._on_back_color = text_config.on_back_color or text_config.color or self._progress_color
	self._on_progress_color = text_config.on_progress_color or text_config.color or self._back_color

	if config.percent ~= nil then
		self._percentage = config.percent
	else
		self._percentage = not config.max
	end

	text_config.text = text_config.text or self._percentage and " 0% " or string.format(" 0 / %d ", self._max)
	text_config.color = text_config.color or self._on_back_color
	text_config.layer = text_config.layer or self._progress:layer() + 1
	self._text = self:fine_text(text_config)

	self._text:set_center_y(self._back:center_y())

	if progress then
		self:set_progress(progress)
	end
end

-- Lines: 677 to 699
function TextProgressBar:set_progress(v)
	v = TextProgressBar.super.set_progress(self, v)
	local at = self._progress:right()
	local max = self._back:right()

	if self._percentage then
		local num = v * 100

		self._text:set_text(string.format(" %d%% ", num))
	else
		self._text:set_text(string.format(" %d / %d ", v, self._max))
	end

	self.make_fine_text(self._text)
	self._text:set_left(at)

	local col = self._on_back_color

	if max < self._text:right() then
		col = self._on_progress_color

		self._text:set_right(at)
	end

	self._text:set_color(col)
end
SpecialButtonBinding = SpecialButtonBinding or class()

-- Lines: 705 to 714
function SpecialButtonBinding:init(binding, func, add_to_panel)
	self._binding = Idstring(binding)
	self._on_trigger = func or function ()
	end
	self._enabled = true

	if add_to_panel then
		add_to_panel:add_input_component(self)
	end
end

-- Lines: 716 to 717
function SpecialButtonBinding:allow_input()
	return self._enabled
end

-- Lines: 720 to 725
function SpecialButtonBinding:special_btn_pressed(button)
	if button == self._binding then
		self._on_trigger()

		return true
	end
end

-- Lines: 727 to 729
function SpecialButtonBinding:set_enabled(state)
	self._enabled = state
end
ButtonLegendsBar = ButtonLegendsBar or class(GrowPanel)
ButtonLegendsBar.PADDING = 10

-- Lines: 757 to 767
function ButtonLegendsBar:init(panel, config, panel_config)
	panel_config = set_defaults(panel_config, {
		border = 0,
		input = true,
		fixed_w = panel:w(),
		padding = self.PADDING
	})

	ButtonLegendsBar.super.init(self, panel, panel_config)

	self._text_config = set_defaults(config, {
		font = small_font,
		font_size = small_font_size
	})
	self._legends_only = self._text_config.no_buttons or not panel_config.input or not managers.menu:is_pc_controller()
	self._items = {}
	self._lookup = {}
end

-- Lines: 769 to 791
function ButtonLegendsBar:add_item(data, id, dont_update)
	if type(data) == "string" then
		local text = managers.localization:exists(data) and managers.localization:to_upper_text(data) or data

		table.insert(self._items, self:_create_legend(nil, text))
	else
		local macro_name = data.macro_name or "MY_BTN"
		local text = data.text or managers.localization:to_upper_text(data.text_id, {[macro_name] = managers.localization:btn_macro(data.binding, true) or ""})
		local item = nil

		if data.func and not self._legends_only then
			table.insert(self._items, self:_create_btn(data, text))
		else
			table.insert(self._items, self:_create_legend(data, text))
		end
	end

	if id or data.id then
		self._lookup[id or data.id] = #self._items
	end

	if dont_update or data.enabled == false then
		return
	end

	self:_update_items()
end

-- Lines: 793 to 802
function ButtonLegendsBar:_create_btn(data, text)
	local config = clone(self._text_config)
	config.text = text
	config.binding = data.binding
	local button = TextButton:new(self, config, data.func)

	button:set_visible(false)

	local item = {
		button = true,
		item = button,
		enabled = data.enabled ~= false
	}

	return item
end

-- Lines: 805 to 818
function ButtonLegendsBar:_create_legend(data, text)
	data = data or {}
	local config = data.config or clone(self._text_config)
	config.text = text
	local text = self:fine_text(config)

	text:set_visible(false)

	local item = {
		text = true,
		item = text,
		enabled = data.enabled ~= false
	}

	if data.binding and data.func then
		item.listener = SpecialButtonBinding:new(data.binding, data.func, self)
	end

	return item
end

-- Lines: 821 to 827
function ButtonLegendsBar:add_items(list)
	for k, v in pairs(list) do
		self:add_item(v, nil, true)
	end

	self:_update_items()
end

-- Lines: 829 to 836
function ButtonLegendsBar:set_item_enabled(id_or_pos, state)
	local id = type(id_or_pos) == "number" and id_or_pos or self._lookup[id_or_pos]
	local data = self._items[id]

	if data and data.enabled ~= state then
		data.enabled = state

		self:_update_items()
	end
end

-- Lines: 838 to 853
function ButtonLegendsBar:_update_items()
	local placer = self:placer()

	placer:clear()
	placer:set_at(self:w(), 0)
	self:set_size(0, 0)

	for _, v in pairs(self._items) do
		v.item:set_visible(v.enabled)

		if v.enabled then
			placer:add_left(v.item)
		end

		if v.listener then
			v.listener:set_enabled(v.enabled)
		end
	end
end
TextLegendsBar = TextLegendsBar or class(ButtonLegendsBar)
TextLegendsBar.SEPERATOR = "  |  "

-- Lines: 860 to 868
function TextLegendsBar:init(panel, config, panel_config)
	TextLegendsBar.super.init(self, panel, config, panel_config)

	self._text_config = set_defaults(self._text_config, {
		text = " ",
		align = "right",
		keep_w = true
	})
	self._seperator = self._text_config.seperator or TextLegendsBar.SEPERATOR
	self._text_item = self:fine_text(self._text_config)

	self:set_h(self._text_item:h())
end

-- Lines: 870 to 871
function TextLegendsBar:_create_btn(data, text)
	return self:_create_legend(data, text)
end

-- Lines: 874 to 882
function TextLegendsBar:_create_legend(data, text)
	data = data or {}
	local item = {
		item = text,
		enabled = data.enabled ~= false
	}

	if data.binding and data.func then
		item.listener = SpecialButtonBinding:new(data.binding, data.func, self)
	end

	return item
end

-- Lines: 885 to 900
function TextLegendsBar:_update_items()
	local str = nil

	for _, v in pairs(self._items) do
		if v.enabled then
			str = str and v.item .. self._seperator .. str or v.item
		end

		if v.listener then
			v.listener:set_enabled(v.enabled)
		end
	end

	self._text_item:set_text(str or "")
end

