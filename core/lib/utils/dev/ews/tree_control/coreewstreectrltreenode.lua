require("core/lib/utils/dev/ews/tree_control/CoreBaseTreeNode")

CoreEWSTreeCtrlTreeNode = CoreEWSTreeCtrlTreeNode or class(CoreBaseTreeNode)

-- Lines: 4 to 9
function CoreEWSTreeCtrlTreeNode:init(ews_tree_ctrl, item_id, checkbox_style)
	self._checkbox_style = checkbox_style
	self._tree_ctrl = assert(ews_tree_ctrl, "nil argument supplied as ews_tree_ctrl")
	self._item_id = assert(item_id, "nil argument supplied as item_id")

	self:set_state(0)
end

-- Lines: 11 to 12
function CoreEWSTreeCtrlTreeNode:id()
	return self._item_id
end

-- Lines: 15 to 22
function CoreEWSTreeCtrlTreeNode:expand(recurse)
	self._tree_ctrl:expand(self._item_id)

	if recurse then
		for _, child in ipairs(self:children()) do
			child:expand(true)
		end
	end
end

-- Lines: 24 to 31
function CoreEWSTreeCtrlTreeNode:collapse(recurse)
	self._tree_ctrl:collapse(self._item_id)

	if recurse then
		for _, child in ipairs(self:children()) do
			child:collapse(true)
		end
	end
end

-- Lines: 33 to 36
function CoreEWSTreeCtrlTreeNode:set_selected(state)
	if state == nil then
		state = true
	end

	self._tree_ctrl:select_item(self._item_id, state)
end

-- Lines: 38 to 44
function CoreEWSTreeCtrlTreeNode:state(state)
	if self._checkbox_style then
		return self._tree_ctrl:get_item_image(self._item_id, "NORMAL")
	else
		return 0
	end
end

-- Lines: 46 to 50
function CoreEWSTreeCtrlTreeNode:set_state(state)
	if self._checkbox_style then
		self:_change_state(state)
	end
end

-- Lines: 52 to 53
function CoreEWSTreeCtrlTreeNode:checkbox_style()
	return self._checkbox_style
end

-- Lines: 56 to 58
function CoreEWSTreeCtrlTreeNode:set_checkbox_style(style)
	self._checkbox_style = style
end

-- Lines: 60 to 62
function CoreEWSTreeCtrlTreeNode:set_image(image, item_state)
	self._tree_ctrl:set_item_image(self._item_id, image, item_state or "NORMAL")
end

-- Lines: 64 to 65
function CoreEWSTreeCtrlTreeNode:get_image(item_state)
	return self._tree_ctrl:get_item_image(self._item_id, item_state or "NORMAL")
end

-- Lines: 68 to 70
function CoreEWSTreeCtrlTreeNode:_change_state(state)
	self._tree_ctrl:set_item_image(self._item_id, state, "NORMAL")
end

-- Lines: 75 to 76
function CoreEWSTreeCtrlTreeNode:text()
	return self._tree_ctrl:get_item_text(self._item_id)
end

-- Lines: 79 to 84
function CoreEWSTreeCtrlTreeNode:parent()
	local parent_id = self._tree_ctrl:get_parent(self._item_id)

	if parent_id ~= -1 and self._tree_ctrl:get_parent(parent_id) ~= -1 then
		return CoreEWSTreeCtrlTreeNode:new(self._tree_ctrl, parent_id, self._checkbox_style)
	end
end

-- Lines: 86 to 87
function CoreEWSTreeCtrlTreeNode:children()
	return table.collect(self._tree_ctrl:get_children(self._item_id), function (child_id)
		return CoreEWSTreeCtrlTreeNode:new(self._tree_ctrl, child_id, self._checkbox_style)
	end)
end

-- Lines: 90 to 91
function CoreEWSTreeCtrlTreeNode:append(text)
	return CoreEWSTreeCtrlTreeNode:new(self._tree_ctrl, self._tree_ctrl:append(self._item_id, text), self._checkbox_style)
end

-- Lines: 94 to 96
function CoreEWSTreeCtrlTreeNode:remove()
	self._tree_ctrl:remove(self._item_id)
end

-- Lines: 103 to 104
function CoreEWSTreeCtrlTreeNode:has_children()
	return table.getn(self._tree_ctrl:get_children(self._item_id)) > 0
end

return
