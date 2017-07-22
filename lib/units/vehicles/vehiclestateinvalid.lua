VehicleStateInvalid = VehicleStateInvalid or class(BaseVehicleState)

-- Lines: 3 to 5
function VehicleStateInvalid:init(unit)
	BaseVehicleState.init(self, unit)
end

return
