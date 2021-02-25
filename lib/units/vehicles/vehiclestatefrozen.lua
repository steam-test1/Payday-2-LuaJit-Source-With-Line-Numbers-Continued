VehicleStateFrozen = VehicleStateFrozen or class(BaseVehicleState)

-- Lines 3-5
function VehicleStateFrozen:init(unit)
	BaseVehicleState.init(self, unit)
end

-- Lines 9-21
function VehicleStateFrozen:enter(state_data, enter_data)
	self._unit:vehicle_driving()._hit_soundsource:stop()
	self._unit:vehicle_driving()._slip_soundsource:stop()
	self._unit:vehicle_driving()._bump_soundsource:stop()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)

	self._unit:vehicle_driving()._shooting_stance_allowed = false

	self:disable_interactions()
	self._unit:vehicle_driving():set_input(0, 0, 1, 1, false, false, 2)
end

-- Lines 25-27
function VehicleStateFrozen:allow_exit()
	return false
end

-- Lines 31-33
function VehicleStateFrozen:stop_vehicle()
	return true
end

-- Lines 37-39
function VehicleStateFrozen:is_vulnerable()
	return false
end
