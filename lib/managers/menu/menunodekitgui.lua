core:import("CoreMenuNodeGui")

MenuNodeKitGui = MenuNodeKitGui or class(MenuNodeGui)

-- Lines: 5 to 7
function MenuNodeKitGui:init(node, layer, parameters)
	MenuNodeKitGui.super.init(self, node, layer, parameters)
end

-- Lines: 9 to 11
function MenuNodeKitGui:_setup_item_panel_parent(safe_rect, shape)
	MenuNodeKitGui.super._setup_item_panel_parent(self, safe_rect, shape)
end

-- Lines: 13 to 16
function MenuNodeKitGui:_update_scaled_values()
	MenuNodeKitGui.super._update_scaled_values(self)

	self.font_size = tweak_data.menu.kit_default_font_size
end

-- Lines: 18 to 22
function MenuNodeKitGui:resolution_changed()
	self:_update_scaled_values()
	MenuNodeKitGui.super.resolution_changed(self)
end

return
