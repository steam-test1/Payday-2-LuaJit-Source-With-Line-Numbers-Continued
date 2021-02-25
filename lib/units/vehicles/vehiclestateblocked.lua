VehicleStateBlocked = VehicleStateBlocked or class(BaseVehicleState)

-- Lines 3-5
function VehicleStateBlocked:init(unit)
	BaseVehicleState.init(self, unit)
end

-- Lines 9-19
function VehicleStateBlocked:enter(state_data, enter_data)
	self._unit:vehicle_driving():_stop_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	self:adjust_interactions()
	self._unit:vehicle_driving():set_input(0, 0, 1, 1, false, false, 2)
	self:remove_name_hud()
end

-- Lines 23-40
function VehicleStateBlocked:adjust_interactions()
	VehicleStateParked.super.adjust_interactions(self)

	if self._unit:vehicle_driving():is_interaction_allowed() then
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		end

		self._unit:vehicle_driving()._interaction_enter_vehicle = true

		if self._unit:vehicle_driving()._has_trunk then
			self._unit:vehicle_driving()._interaction_trunk = true
		else
			self._unit:vehicle_driving()._interaction_loot = true
		end

		self._unit:vehicle_driving()._interaction_repair = false
	end
end

-- Lines 44-46
function VehicleStateBlocked:allow_exit()
	return true
end

-- Lines 50-52
function VehicleStateBlocked:stop_vehicle()
	return true
end

-- Lines 56-58
function VehicleStateBlocked:is_vulnerable()
	return false
end

-- Lines 62-64
function VehicleStateBlocked:exit()
	self:create_name_hud()
end
