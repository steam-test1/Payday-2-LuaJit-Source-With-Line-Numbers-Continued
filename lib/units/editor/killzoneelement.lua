KillzoneUnitElement = KillzoneUnitElement or class(MissionElement)

-- Lines 3-9
function KillzoneUnitElement:init(unit)
	KillzoneUnitElement.super.init(self, unit)

	self._hed.type = "sniper"

	table.insert(self._save_values, "type")
end

-- Lines 11-22
function KillzoneUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "type", {
		"sniper",
		"gas",
		"fire",
		"laser"
	})
end
