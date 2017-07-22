NpcVehicleStatePlayerProximity = NpcVehicleStatePlayerProximity or class(NpcBaseVehicleState)

-- Lines: 3 to 6
function NpcVehicleStatePlayerProximity:init(unit)
	NpcBaseVehicleState.init(self, unit)
end

-- Lines: 11 to 12
function NpcVehicleStatePlayerProximity:on_enter(npc_driving_ext)
end

-- Lines: 17 to 19
function NpcVehicleStatePlayerProximity:on_exit(npc_driving_ext)
	managers.motion_path:reset_player_proximity_distance()
end

-- Lines: 22 to 23
function NpcVehicleStatePlayerProximity:update(t, dt)
end

-- Lines: 25 to 26
function NpcVehicleStatePlayerProximity:name()
	return NpcVehicleDrivingExt.STATE_PLAYER_PROXIMITY
end

-- Lines: 34 to 61
function NpcVehicleStatePlayerProximity:change_state(npc_driving_ext)
	local player_unit = npc_driving_ext:_get_target_unit()

	if not player_unit then
		return
	end

	local player_position = player_unit:position()
	local cop_position = self._unit:position()
	local distance_to_player = math.abs(player_position - cop_position:length()) / 100

	if npc_driving_ext._debug.nav_paths then
		npc_driving_ext._debug.nav_paths.distance_to_player = distance_to_player
	end

	local unit_id = self._unit:unit_data().unit_id
	local unit_to_player_proximity_distance = managers.motion_path:get_player_proximity_distance_for_unit(unit_id)

	if unit_to_player_proximity_distance <= distance_to_player then
		npc_driving_ext:set_state(NpcVehicleDrivingExt.STATE_PURSUIT)
	end
end

return
