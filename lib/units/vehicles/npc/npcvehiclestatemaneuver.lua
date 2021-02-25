NpcVehicleStateManeuver = NpcVehicleStateManeuver or class(NpcBaseVehicleState)

-- Lines 3-5
function NpcVehicleStateManeuver:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

-- Lines 9-15
function NpcVehicleStateManeuver:on_enter(npc_driving_ext)
	local unit_id = npc_driving_ext._unit:unit_data().unit_id

	managers.motion_path:remove_ground_unit_from_path(unit_id)
end

-- Lines 18-31
function NpcVehicleStateManeuver:on_exit(npc_driving_ext)
	local unit_id = npc_driving_ext._unit:unit_data().unit_id
	local path_info = managers.motion_path:find_nearest_ground_path(unit_id)

	if path_info then
		path_info.unit_id = unit_id

		managers.motion_path:put_unit_on_path(path_info)
	end
end

-- Lines 33-34
function NpcVehicleStateManeuver:update(npc_driving_ext, t, dt)
end

-- Lines 37-39
function NpcVehicleStateManeuver:name()
	return NpcVehicleDrivingExt.STATE_MANEUVER
end

-- Lines 43-45
function NpcVehicleStateManeuver:change_state(npc_driving_ext)
end

-- Lines 48-50
function NpcVehicleStateManeuver:is_maneuvering()
	return true
end
