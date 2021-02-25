VehicleStateInvalid = VehicleStateInvalid or class(BaseVehicleState)

-- Lines 3-5
function VehicleStateInvalid:init(unit)
	BaseVehicleState.init(self, unit)
end
