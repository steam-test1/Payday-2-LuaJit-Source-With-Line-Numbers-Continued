core:import("CoreMenuItem")

MenuItemFriend = MenuItemFriend or class(CoreMenuItem.Item)
MenuItemFriend.TYPE = "friend"

-- Lines: 6 to 10
function MenuItemFriend:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)

	self._type = MenuItemFriend.TYPE
end

return
