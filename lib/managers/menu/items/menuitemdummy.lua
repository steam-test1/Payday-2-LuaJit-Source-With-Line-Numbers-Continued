core:import("CoreMenuItem")

MenuItemDummy = MenuItemDummy or class(CoreMenuItem.Item)
MenuItemDummy.TYPE = "dummy"

-- Lines: 6 to 11
function MenuItemDummy:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)

	self._type = MenuItemDummy.TYPE
	self.hide_highlight = true
end

-- Lines: 19 to 29
function MenuItemDummy:setup_gui(node, row_item)
	row_item.gui_panel = node.item_panel:panel({
		w = 0,
		h = 0
	})

	row_item.gui_panel:set_left(node:_mid_align())

	self.no_select = true
	self.no_mouse_select = true
	self._highlighted = false

	return true
end

-- Lines: 34 to 40
function MenuItemDummy:trigger()
	MenuItemDummy.super.trigger(self)

	if self._actual_item and self._actual_item.dummy_trigger then
		self._actual_item:dummy_trigger()
	end
end

-- Lines: 42 to 49
function MenuItemDummy:set_actual_item(item)
	self._actual_item = item
	self.no_select = nil

	if self._actual_item.dummy_set_highlight then
		self._actual_item:dummy_set_highlight(false)
	end
end

-- Lines: 51 to 56
function MenuItemDummy:highlight_row_item(node, row_item, mouse_over)
	self._highlighted = true

	if self._actual_item and self._actual_item.dummy_set_highlight then
		self._actual_item:dummy_set_highlight(true, node, row_item, mouse_over)
	end

	return true
end

-- Lines: 59 to 64
function MenuItemDummy:fade_row_item(node, row_item, mouse_over)
	self._highlighted = false

	if self._actual_item and self._actual_item.dummy_set_highlight then
		self._actual_item:dummy_set_highlight(false, node, row_item, mouse_over)
	end

	return true
end

-- Lines: 67 to 68
function MenuItemDummy:is_highlighted()
	return self._highlighted
end

-- Lines: 71 to 72
function MenuItemDummy:reload()
	return true
end

-- Lines: 75 to 76
function MenuItemDummy:menu_unselected_visible()
	return false
end

