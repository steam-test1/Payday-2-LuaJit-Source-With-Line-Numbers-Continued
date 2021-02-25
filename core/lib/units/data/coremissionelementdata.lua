CoreMissionElementData = CoreMissionElementData or class()
MissionElementData = MissionElementData or class(CoreMissionElementData)

-- Lines 5-7
function MissionElementData:init(...)
	CoreMissionElementData.init(self, ...)
end

-- Lines 9-11
function CoreMissionElementData:init(unit)
end
