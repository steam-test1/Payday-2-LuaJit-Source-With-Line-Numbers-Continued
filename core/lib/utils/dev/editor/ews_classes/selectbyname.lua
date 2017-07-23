SelectByName = SelectByName or class(UnitByName)

-- Lines: 3 to 84
function SelectByName:init(...)
	UnitByName.init(self, "Select by name", nil, ...)
end

-- Lines: 86 to 103
function SelectByName:_build_buttons(panel, sizer)
	local find_btn = EWS:Button(panel, "Find", "", "BU_BOTTOM")

	sizer:add(find_btn, 0, 2, "RIGHT,LEFT")
	find_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_on_find_unit"), "")
	find_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local select_btn = EWS:Button(panel, "Select", "", "BU_BOTTOM")

	sizer:add(select_btn, 0, 2, "RIGHT,LEFT")
	select_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_on_select_unit"), "")
	select_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	local delete_btn = EWS:Button(panel, "Delete", "", "BU_BOTTOM")

	sizer:add(delete_btn, 0, 2, "RIGHT,LEFT")
	delete_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_on_delete"), "")
	delete_btn:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")
	UnitByName._build_buttons(self, panel, sizer)
end

-- Lines: 147 to 164
function SelectByName:_on_delete()
	local confirm = EWS:message_box(self._dialog, "Delete selected unit(s)?", self._dialog_name, "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))

	if confirm == "NO" then
		return
	end

	managers.editor:freeze_gui_lists()

	for _, unit in ipairs(self:_selected_item_units()) do
		managers.editor:delete_unit(unit)
	end

	managers.editor:thaw_gui_lists()
end

-- Lines: 166 to 169
function SelectByName:_on_find_unit()
	self:_on_select_unit()
	managers.editor:center_view_on_unit(self:_selected_item_unit())
end

-- Lines: 171 to 192
function SelectByName:_on_select_unit()
	managers.editor:change_layer_based_on_unit(self:_selected_item_unit())
	managers.editor:freeze_gui_lists()

	self._blocked = true

	managers.editor:select_units(self:_selected_item_units())
	managers.editor:thaw_gui_lists()

	self._blocked = false
end

