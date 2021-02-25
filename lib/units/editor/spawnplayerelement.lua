SpawnPlayerElement = SpawnPlayerElement or class(MissionElement)

-- Lines 3-9
function SpawnPlayerElement:init(unit)
	MissionElement.init(self, unit)

	self._hed.state = managers.player:default_player_state()

	table.insert(self._save_values, "state")
end

-- Lines 11-19
function SpawnPlayerElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	self:_build_value_combobox(panel, panel_sizer, "state", managers.player:player_states(), "Select a state from the combobox")
	self:_add_help_text("The state defines how the player will be spawned")
end

-- Lines 21-23
function SpawnPlayerElement:add_to_mission_package()
end
