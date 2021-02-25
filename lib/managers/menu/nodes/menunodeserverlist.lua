core:import("CoreMenuNode")
core:import("CoreSerialize")
core:import("CoreMenuItem")
core:import("CoreMenuItemToggle")

MenuNodeServerList = MenuNodeServerList or class(MenuNodeTable)

-- Lines 8-10
function MenuNodeServerList:init(data_node)
	MenuNodeServerList.super.init(self, data_node)
end

-- Lines 12-15
function MenuNodeServerList:update(t, dt)
	MenuNodeServerList.super.update(self, t, dt)
end

-- Lines 18-25
function MenuNodeServerList:_setup_columns()
	self:_add_column({
		proportions = 1.9,
		align = "left",
		text = string.upper("")
	})
	self:_add_column({
		proportions = 1.7,
		align = "right",
		text = string.upper("")
	})
	self:_add_column({
		proportions = 1,
		align = "right",
		text = string.upper("")
	})
	self:_add_column({
		proportions = 0.225,
		align = "right",
		text = string.upper("")
	})
end
