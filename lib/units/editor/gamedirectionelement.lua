GameDirectionUnitElement = GameDirectionUnitElement or class(MissionElement)

-- Lines 3-6
function GameDirectionUnitElement:init(unit)
	MissionElement.init(self, unit)
end

-- Lines 8-21
function GameDirectionUnitElement:update_selected(t, dt)
end

-- Lines 24-29
function GameDirectionUnitElement:_build_panel(panel, panel_sizer)
end
