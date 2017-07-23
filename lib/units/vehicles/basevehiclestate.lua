BaseVehicleState = BaseVehicleState or class()

-- Lines: 11 to 13
function BaseVehicleState:init(unit)
	self._unit = unit
end

-- Lines: 17 to 23
function BaseVehicleState:update(t, dt)
	self._unit:vehicle_driving():_wake_nearby_dynamics()
	self._unit:vehicle_driving():_detect_npc_collisions()
	self._unit:vehicle_driving():_detect_collisions(t, dt)
	self._unit:vehicle_driving():_detect_invalid_possition(t, dt)
	self._unit:vehicle_driving():_play_sound_events(t, dt)
end

-- Lines: 28 to 29
function BaseVehicleState:enter(state_data, enter_data)
end

-- Lines: 34 to 35
function BaseVehicleState:exit(state_data)
end

-- Lines: 40 to 67
function BaseVehicleState:get_action_for_interaction(pos, locator, tweak_data)
	local locator_name = locator:name()

	for _, seat in pairs(tweak_data.seats) do
		if locator_name == Idstring(VehicleDrivingExt.INTERACTION_PREFIX .. seat.name) then
			if seat.driving then
				return VehicleDrivingExt.INTERACT_DRIVE
			else
				return VehicleDrivingExt.INTERACT_ENTER
			end
		end
	end

	for _, loot_point in pairs(tweak_data.loot_points) do
		if locator_name == Idstring(VehicleDrivingExt.INTERACTION_PREFIX .. loot_point.name) then
			return VehicleDrivingExt.INTERACT_LOOT
		end
	end

	if tweak_data.repair_point and locator_name == Idstring(VehicleDrivingExt.INTERACTION_PREFIX .. tweak_data.repair_point) then
		return VehicleDrivingExt.INTERACT_REPAIR
	end

	if tweak_data.trunk_point and locator_name == Idstring(VehicleDrivingExt.INTERACTION_PREFIX .. tweak_data.trunk_point) then
		return VehicleDrivingExt.INTERACT_TRUNK
	end

	return VehicleDrivingExt.INTERACT_INVALID
end

-- Lines: 72 to 76
function BaseVehicleState:adjust_interactions()
	if not self._unit:vehicle_driving():is_interaction_allowed() then
		self:disable_interactions()
	end
end

-- Lines: 80 to 91
function BaseVehicleState:disable_interactions()
	if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_DISABLED)

		self._unit:vehicle_driving()._interaction_enter_vehicle = false
		self._unit:vehicle_driving()._interaction_loot = false
		self._unit:vehicle_driving()._interaction_trunk = false
		self._unit:vehicle_driving()._interaction_repair = false
	end
end

-- Lines: 95 to 96
function BaseVehicleState:allow_exit()
	return true
end

-- Lines: 101 to 102
function BaseVehicleState:is_vulnerable()
	return false
end

-- Lines: 107 to 108
function BaseVehicleState:stop_vehicle()
	return false
end

