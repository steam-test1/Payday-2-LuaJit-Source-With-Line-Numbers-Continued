NpcBaseVehicleState = NpcBaseVehicleState or class()

-- Lines: 3 to 5
function NpcBaseVehicleState:init(unit)
	self._unit = unit
end

-- Lines: 10 to 11
function NpcBaseVehicleState:on_enter(npc_driving_ext)
end

-- Lines: 15 to 16
function NpcBaseVehicleState:on_exit(npc_driving_ext)
end

-- Lines: 19 to 20
function NpcBaseVehicleState:update(t, dt)
end

-- Lines: 23 to 24
function NpcBaseVehicleState:name()
	return NpcVehicleDrivingExt.STATE_BASE
end

-- Lines: 28 to 29
function NpcBaseVehicleState:calc_steering(angle)
	return 0
end

-- Lines: 33 to 34
function NpcBaseVehicleState:calc_distance_threshold(angle)
	return 501
end

-- Lines: 38 to 39
function NpcBaseVehicleState:calc_speed_limit(path, unit_and_pos)
	return 0
end

-- Lines: 43 to 44
function NpcBaseVehicleState:handle_hard_turn(npc_driving_ext, angle_to_target)
end

-- Lines: 47 to 48
function NpcBaseVehicleState:handle_end_of_the_road(is_last_checkpoint, unit_and_pos)
end

-- Lines: 51 to 52
function NpcBaseVehicleState:evasion_maneuvers(npc_driving_ext, target_steering)
end

-- Lines: 54 to 55
function NpcBaseVehicleState:change_state(npc_driving_ext)
end

-- Lines: 58 to 59
function NpcBaseVehicleState:handle_stuck_vehicle(npc_driving_ext)
end

-- Lines: 62 to 63
function NpcBaseVehicleState:is_maneuvering()
	return false
end

