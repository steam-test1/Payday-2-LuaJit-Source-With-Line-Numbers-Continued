CoreExecuteInOtherMissionUnitElement = CoreExecuteInOtherMissionUnitElement or class(MissionElement)
ExecuteInOtherMissionUnitElement = ExecuteInOtherMissionUnitElement or class(CoreExecuteInOtherMissionUnitElement)

-- Lines 5-7
function ExecuteInOtherMissionUnitElement:init(...)
	CoreExecuteInOtherMissionUnitElement.init(self, ...)
end

-- Lines 9-12
function CoreExecuteInOtherMissionUnitElement:init(unit)
	MissionElement.init(self, unit)
end

-- Lines 14-17
function CoreExecuteInOtherMissionUnitElement:selected()
	MissionElement.selected(self)
end

-- Lines 19-26
function CoreExecuteInOtherMissionUnitElement:add_unit_list_btn()
	-- Lines 20-20
	local function f(unit)
		return unit:type() == Idstring("mission_element") and unit ~= self._unit
	end

	local dialog = SelectUnitByNameModal:new("Add other mission unit", f)

	for _, unit in ipairs(dialog:selected_units()) do
		self:add_on_executed(unit)
	end
end

-- Lines 28-61
function CoreExecuteInOtherMissionUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	self._btn_toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")

	self._btn_toolbar:add_tool("ADD_UNIT_LIST", "Add unit from unit list", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	self._btn_toolbar:connect("ADD_UNIT_LIST", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "add_unit_list_btn"), nil)
	self._btn_toolbar:realize()
	panel_sizer:add(self._btn_toolbar, 0, 1, "EXPAND,LEFT")
end
