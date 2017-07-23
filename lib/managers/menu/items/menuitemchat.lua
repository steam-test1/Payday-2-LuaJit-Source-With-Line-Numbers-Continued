core:import("CoreMenuItem")

MenuItemChat = MenuItemChat or class(CoreMenuItem.Item)
MenuItemChat.TYPE = "chat"

-- Lines: 6 to 10
function MenuItemChat:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)

	self._type = MenuItemChat.TYPE
end

