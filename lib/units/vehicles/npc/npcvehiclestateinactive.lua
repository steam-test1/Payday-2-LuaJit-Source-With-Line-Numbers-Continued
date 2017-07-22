NpcVehicleStateInactive = NpcVehicleStateInactive or class(NpcBaseVehicleState)

-- Lines: 3 to 5
function NpcVehicleStateInactive:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

-- Lines: 9 to 10
function NpcVehicleStateInactive:update(t, dt)
end

-- Lines: 12 to 13
function NpcVehicleStateInactive:name()
	return NpcVehicleDrivingExt.STATE_INACTIVE
end

return
