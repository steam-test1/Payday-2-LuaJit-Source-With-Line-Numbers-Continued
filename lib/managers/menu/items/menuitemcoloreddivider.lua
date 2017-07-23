core:import("CoreMenuItem")

MenuItemColoredDivider = MenuItemColoredDivider or class(MenuItemDivider)
MenuItemColoredDivider.TYPE = "divider"

-- Lines: 7 to 11
function MenuItemColoredDivider:init(data_node, parameters)
	MenuItemColoredDivider.super.init(self, data_node, parameters)

	self._type = MenuItemColoredDivider.TYPE
end

-- Lines: 15 to 24
function MenuItemColoredDivider:setup_gui(node, row_item)
	MenuItemColoredDivider.super.setup_gui(self, node, row_item)

	self._color = self._color or row_item.item:parameters().color or Color.red
	self._rect = row_item.gui_panel:rect({
		layer = 1000,
		color = self._color
	})

	return true
end

-- Lines: 28 to 33
function MenuItemColoredDivider:set_color(color)
	self._color = color

	if self._rect then
		self._rect:set_color(self._color)
	end
end

