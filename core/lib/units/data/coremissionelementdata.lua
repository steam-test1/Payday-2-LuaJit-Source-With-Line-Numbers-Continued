CoreMissionElementData = CoreMissionElementData or class()
MissionElementData = MissionElementData or class(CoreMissionElementData)

-- Lines: 5 to 7
function MissionElementData:init(...)
	CoreMissionElementData.init(self, ...)
end

-- Lines: 10 to 11
function CoreMissionElementData:init(unit)
end

return
