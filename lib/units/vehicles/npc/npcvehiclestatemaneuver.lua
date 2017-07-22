NpcVehicleStateManeuver = NpcVehicleStateManeuver or class(NpcBaseVehicleState)

-- Lines: 3 to 5
function NpcVehicleStateManeuver:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

-- Lines: 9 to 15
function NpcVehicleStateManeuver:on_enter(npc_driving_ext)
	local unit_id = npc_driving_ext._unit:unit_data().unit_id

	managers.motion_path:remove_ground_unit_from_path(unit_id)
end

-- Lines: 18 to 31
function NpcVehicleStateManeuver:on_exit(npc_driving_ext)
	local unit_id = npc_driving_ext._unit:unit_data().unit_id
	local path_info = managers.motion_path:find_nearest_ground_path(unit_id)

	if path_info then
		path_info.unit_id = unit_id

		managers.motion_path:put_unit_on_path(path_info)
	end
end

-- Lines: 33 to 34
function NpcVehicleStateManeuver:update(npc_driving_ext, t, dt)
end

-- Lines: 37 to 38
function NpcVehicleStateManeuver:name()
	return NpcVehicleDrivingExt.STATE_MANEUVER
end

-- Lines: 44 to 45
function NpcVehicleStateManeuver:change_state(npc_driving_ext)
end

-- Lines: 48 to 49
function NpcVehicleStateManeuver:is_maneuvering()
	return true
end

return
