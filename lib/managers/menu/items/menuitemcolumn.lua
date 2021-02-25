core:import("CoreMenuItem")

ItemColumn = ItemColumn or class(CoreMenuItem.Item)
ItemColumn.TYPE = "column"

-- Lines 6-10
function ItemColumn:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)

	self._type = ItemColumn.TYPE
end

ItemServerColumn = ItemServerColumn or class(ItemColumn)
ItemServerColumn.TYPE = "server_column"

-- Lines 15-19
function ItemServerColumn:init(data_node, parameters)
	ItemServerColumn.super.init(self, data_node, parameters)

	self._type = ItemServerColumn.TYPE
end
