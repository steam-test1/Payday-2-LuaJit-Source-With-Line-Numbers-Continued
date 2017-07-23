NpcVehicleStateBroken = NpcVehicleStateBroken or class(NpcBaseVehicleState)

-- Lines: 3 to 5
function NpcVehicleStateBroken:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

-- Lines: 9 to 10
function NpcVehicleStateBroken:update(t, dt)
end

-- Lines: 13 to 14
function NpcVehicleStateBroken:name()
	return NpcVehicleDrivingExt.STATE_BROKEN
end

-- Lines: 18 to 26
function NpcVehicleStateBroken:on_enter()
	print("NpcVehicleStateBroken:on_enter()")

	if self._unit:damage():has_sequence(VehicleDrivingExt.SEQUENCE_FULL_DAMAGED) then
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.SEQUENCE_FULL_DAMAGED)
	end
end

