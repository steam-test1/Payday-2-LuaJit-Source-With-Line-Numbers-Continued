ArcadeStateUnitElement = ArcadeStateUnitElement or class(MissionElement)

-- Lines: 3 to 11
function ArcadeStateUnitElement:init(unit)
	ArcadeStateUnitElement.super.init(self, unit)
	table.insert(self._save_values, "state")
end

-- Lines: 13 to 20
function ArcadeStateUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "state", JobManager.arcade_states, "Select a state from the combobox")
end

