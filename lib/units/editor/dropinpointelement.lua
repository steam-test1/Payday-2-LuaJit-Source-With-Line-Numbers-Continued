DropInPointUnitElement = DropInPointUnitElement or class(MissionElement)

-- Lines: 3 to 5
function DropInPointUnitElement:init(unit)
	DropInPointUnitElement.super.init(self, unit)
end

-- Lines: 7 to 11
function DropInPointUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()
	self:_add_help_text("Will act as a drop-in point when enabled. Drop-in points affect users that drop-in, respawns and team AI spawns.")
end

