core:import("CoreEditorUtils")

SpawnGageAssignmentElement = SpawnGageAssignmentElement or class(MissionElement)
SpawnGageAssignmentElement.USES_POINT_ORIENTATION = true

-- Lines 6-8
function SpawnGageAssignmentElement:init(unit)
	SpawnGageAssignmentElement.super.init(self, unit)
end

-- Lines 10-12
function SpawnGageAssignmentElement:_build_panel(panel, panel_sizer)
	self:_create_panel()
end

-- Lines 14-16
function SpawnGageAssignmentElement:destroy(...)
	SpawnGageAssignmentElement.super.destroy(self, ...)
end
