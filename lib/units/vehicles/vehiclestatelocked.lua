VehicleStateLocked = VehicleStateLocked or class(BaseVehicleState)

-- Lines 3-5
function VehicleStateLocked:init(unit)
	BaseVehicleState.init(self, unit)
end

-- Lines 9-17
function VehicleStateLocked:enter(state_data, enter_data)
	self._unit:vehicle_driving():_stop_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	self:disable_interactions()
	self._unit:vehicle_driving():set_input(0, 0, 1, 1, false, false, 2)
end

-- Lines 21-23
function VehicleStateLocked:allow_exit()
	return true
end

-- Lines 27-29
function VehicleStateLocked:stop_vehicle()
	return true
end

-- Lines 33-35
function VehicleStateLocked:is_vulnerable()
	return false
end
