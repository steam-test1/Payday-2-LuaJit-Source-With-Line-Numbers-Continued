NpcVehicleStateInactive = NpcVehicleStateInactive or class(NpcBaseVehicleState)

-- Lines 3-5
function NpcVehicleStateInactive:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

-- Lines 9-10
function NpcVehicleStateInactive:update(t, dt)
end

-- Lines 12-14
function NpcVehicleStateInactive:name()
	return NpcVehicleDrivingExt.STATE_INACTIVE
end
