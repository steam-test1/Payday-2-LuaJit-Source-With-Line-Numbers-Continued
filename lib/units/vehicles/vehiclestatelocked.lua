VehicleStateLocked = VehicleStateLocked or class(BaseVehicleState)

-- Lines 3-5
function VehicleStateLocked:init(unit)
	BaseVehicleState.init(self, unit)
end

-- Lines 9-19
function VehicleStateLocked:enter(state_data, enter_data)
	self._unit:vehicle_driving():_stop_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	self:disable_interactions()
	self._unit:vehicle_driving():set_input(0, 0, 1, 1, false, false, 2)
	self:remove_name_hud()
end

-- Lines 23-25
function VehicleStateLocked:allow_exit()
	return true
end

-- Lines 29-31
function VehicleStateLocked:stop_vehicle()
	return true
end

-- Lines 35-37
function VehicleStateLocked:is_vulnerable()
	return false
end

-- Lines 41-43
function VehicleStateLocked:exit()
	self:create_name_hud()
end
