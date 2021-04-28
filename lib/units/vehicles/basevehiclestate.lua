BaseVehicleState = BaseVehicleState or class()

-- Lines 4-6
function BaseVehicleState:init(unit)
	self._unit = unit
end

-- Lines 10-16
function BaseVehicleState:update(t, dt)
	self._unit:vehicle_driving():_wake_nearby_dynamics()
	self._unit:vehicle_driving():_detect_npc_collisions()
	self._unit:vehicle_driving():_detect_collisions(t, dt)
	self._unit:vehicle_driving():_detect_invalid_possition(t, dt)
	self._unit:vehicle_driving():_play_sound_events(t, dt)
end

-- Lines 20-22
function BaseVehicleState:enter(state_data, enter_data)
end

-- Lines 26-28
function BaseVehicleState:exit(state_data)
end

-- Lines 32-61
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

-- Lines 65-69
function BaseVehicleState:adjust_interactions()
	if not self._unit:vehicle_driving():is_interaction_allowed() then
		self:disable_interactions()
	end
end

-- Lines 73-84
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

-- Lines 88-90
function BaseVehicleState:allow_exit()
	return true
end

-- Lines 94-96
function BaseVehicleState:is_vulnerable()
	return false
end

-- Lines 100-102
function BaseVehicleState:stop_vehicle()
	return false
end

-- Lines 106-115
function BaseVehicleState:create_name_hud()
	local name_id = self._unit:vehicle_driving()._tweak_data.name_id

	if name_id and self._unit:unit_data().name_label_id == nil then
		local id = managers.hud:add_vehicle_name_label({
			name = utf8.to_upper(managers.localization:text(name_id)),
			unit = self._unit
		})
		self._unit:unit_data().name_label_id = id
	end
end

-- Lines 119-121
function BaseVehicleState:remove_name_hud()
	managers.hud:remove_hud_info_by_unit(self._unit)
end
