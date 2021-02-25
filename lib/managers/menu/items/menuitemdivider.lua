core:import("CoreMenuItem")

MenuItemDivider = MenuItemDivider or class(CoreMenuItem.Item)
MenuItemDivider.TYPE = "divider"

-- Lines 6-12
function MenuItemDivider:init(data_node, parameters)
	MenuItemDivider.super.init(self, data_node, parameters)

	self._type = MenuItemDivider.TYPE
	self.no_mouse_select = true
	self.no_select = true
end

-- Lines 15-45
function MenuItemDivider:setup_gui(node, row_item)
	local scaled_size = managers.gui_data:scaled_size()
	row_item.gui_panel = node.item_panel:panel({
		w = node.item_panel:w()
	})
	local h = row_item.item:parameters().size or 10

	if row_item.text then
		row_item.text = node:_text_item_part(row_item, row_item.gui_panel, 0)
		local _, _, tw, th = row_item.text:text_rect()

		row_item.text:set_size(tw, th)

		h = th
		local color_ranges = row_item.color_ranges

		if color_ranges then
			for _, color_range in ipairs(color_ranges) do
				if color_range then
					row_item.text:set_range_color(color_range.start, color_range.stop, color_range.color)
				end
			end
		end
	end

	row_item.gui_panel:set_left(node:_mid_align())
	row_item.gui_panel:set_w(scaled_size.width - row_item.gui_panel:left())
	row_item.gui_panel:set_h(h)

	return true
end

-- Lines 71-81
function MenuItemDivider:reload(row_item, node)
	MenuItemDivider.super.reload(self, row_item, node)
	self:_set_row_item_state(node, row_item)

	return true
end

-- Lines 84-89
function MenuItemDivider:highlight_row_item(node, row_item, mouse_over)
	self:_set_row_item_state(node, row_item)

	return true
end

-- Lines 92-95
function MenuItemDivider:fade_row_item(node, row_item, mouse_over)
	self:_set_row_item_state(node, row_item)

	return true
end

-- Lines 98-106
function MenuItemDivider:_set_row_item_state(node, row_item)
	if row_item.highlighted then
		-- Nothing
	end
end

-- Lines 108-110
function MenuItemDivider:menu_unselected_visible()
	return false
end

-- Lines 113-115
function MenuItemDivider:on_delete_row_item(row_item, ...)
	MenuItemDivider.super.on_delete_row_item(self, row_item, ...)
end
