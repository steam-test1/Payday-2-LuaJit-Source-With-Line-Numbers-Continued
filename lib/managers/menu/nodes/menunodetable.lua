core:import("CoreMenuNode")
core:import("CoreSerialize")
core:import("CoreMenuItem")
core:import("CoreMenuItemToggle")

MenuNodeTable = MenuNodeTable or class(CoreMenuNode.MenuNode)

-- Lines: 8 to 18
function MenuNodeTable:init(data_node)
	MenuNodeTable.super.init(self, data_node)

	self._columns = {}

	self:_setup_columns()

	self._parameters.total_proportions = 0

	for _, data in ipairs(self._columns) do
		self._parameters.total_proportions = self._parameters.total_proportions + data.proportions
	end
end

-- Lines: 20 to 21
function MenuNodeTable:_setup_columns()
end

-- Lines: 23 to 25
function MenuNodeTable:_add_column(params)
	table.insert(self._columns, params)
end

-- Lines: 27 to 28
function MenuNodeTable:columns()
	return self._columns
end

