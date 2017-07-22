core:import("CoreMissionScriptElement")

ElementWaypoint = ElementWaypoint or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 12
function ElementWaypoint:init(...)
	ElementWaypoint.super.init(self, ...)

	self._network_execute = true

	if self._values.icon == "guis/textures/waypoint2" or self._values.icon == "guis/textures/waypoint" then
		self._values.icon = "wp_standard"
	end
end

-- Lines: 14 to 16
function ElementWaypoint:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)
end

-- Lines: 18 to 20
function ElementWaypoint:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 22 to 34
function ElementWaypoint:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not self._values.only_in_civilian or managers.player:current_state() == "civilian" then
		local text = managers.localization:text(self._values.text_id)

		managers.hud:add_waypoint(self._id, {
			distance = true,
			state = "sneak_present",
			present_timer = 0,
			text = text,
			icon = self._values.icon,
			position = self._values.position
		})
	elseif managers.hud:get_waypoint_data(self._id) then
		managers.hud:remove_waypoint(self._id)
	end

	ElementWaypoint.super.on_executed(self, instigator)
end

-- Lines: 36 to 38
function ElementWaypoint:operation_remove()
	managers.hud:remove_waypoint(self._id)
end

-- Lines: 40 to 42
function ElementWaypoint:save(data)
	data.enabled = self._values.enabled
end

-- Lines: 44 to 46
function ElementWaypoint:load(data)
	self:set_enabled(data.enabled)
end

return
