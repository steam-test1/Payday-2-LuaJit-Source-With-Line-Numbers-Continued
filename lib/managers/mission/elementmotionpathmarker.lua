core:import("CoreMissionScriptElement")

ElementMotionpathMarker = ElementMotionpathMarker or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 13
function ElementMotionpathMarker:init(...)
	ElementMotionpathMarker.super.init(self, ...)

	self._network_execute = true

	if self._values.icon == "guis/textures/VehicleMarker" then
		self._values.icon = "wp_standard"
	end
end

-- Lines: 15 to 17
function ElementMotionpathMarker:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)
end

-- Lines: 19 to 21
function ElementMotionpathMarker:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 23 to 25
function ElementMotionpathMarker:on_executed(instigator)
	ElementMotionpathMarker.super.on_executed(self, instigator)
end

-- Lines: 28 to 29
function ElementMotionpathMarker:operation_remove()
end

-- Lines: 31 to 34
function ElementMotionpathMarker:save(data)
	data.enabled = self._values.enabled
	data.motion_state = self._values.motion_state
end

-- Lines: 36 to 39
function ElementMotionpathMarker:load(data)
	self:set_enabled(data.enabled)

	self._values.motion_state = data.motion_state
end

-- Lines: 41 to 43
function ElementMotionpathMarker:add_trigger(trigger_id, outcome, callback)
	managers.motion_path:add_trigger(self._id, self._values.path_id, trigger_id, outcome, callback)
end

-- Lines: 49 to 51
function ElementMotionpathMarker:motion_operation_goto_marker(checkpoint_marker_id, goto_marker_id)
	managers.motion_path:operation_goto_marker(checkpoint_marker_id, goto_marker_id)
end

-- Lines: 53 to 55
function ElementMotionpathMarker:motion_operation_teleport_to_marker(checkpoint_marker_id, teleport_to_marker_id)
	managers.motion_path:operation_teleport_to_marker(checkpoint_marker_id, teleport_to_marker_id)
end

-- Lines: 58 to 60
function ElementMotionpathMarker:motion_operation_set_motion_state(state)
	self._values.motion_state = state
end

-- Lines: 63 to 65
function ElementMotionpathMarker:motion_operation_set_rotation(operator_id)
	managers.motion_path:operation_set_unit_target_rotation(self._id, operator_id)
end

return
