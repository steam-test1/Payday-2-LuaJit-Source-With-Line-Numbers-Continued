core:import("CoreMissionScriptElement")

ElementLookAtTrigger = ElementLookAtTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementLookAtTrigger:init(...)
	ElementLookAtTrigger.super.init(self, ...)
end

-- Lines 9-12
function ElementLookAtTrigger:on_script_activated()
	self:add_callback()
	self._mission_script:add_save_state_cb(self._id)
end

-- Lines 14-19
function ElementLookAtTrigger:set_enabled(enabled)
	ElementLookAtTrigger.super.set_enabled(self, enabled)

	if enabled then
		self:add_callback()
	end
end

-- Lines 21-25
function ElementLookAtTrigger:add_callback()
	if not self._callback then
		self._callback = self._mission_script:add(callback(self, self, "update_lookat"), self._values.interval)
	end
end

-- Lines 27-32
function ElementLookAtTrigger:remove_callback()
	if self._callback then
		self._mission_script:remove(self._callback)

		self._callback = nil
	end
end

-- Lines 34-45
function ElementLookAtTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementLookAtTrigger.super.on_executed(self, instigator)

	if not self._values.enabled then
		self:remove_callback()
	end
end

-- Lines 48-69
function ElementLookAtTrigger:update_lookat()
	if not self._values.enabled then
		return
	end

	local player = managers.player:player_unit()
	local is_player_looking_at = managers.player:is_player_looking_at(self._values.position, {
		distance = self._values.distance,
		at_facing = self._values.in_front and self._values.rotation:y(),
		sensitivity = self._values.sensitivity,
		raycheck = self._values.raycheck,
		player_unit = player
	})

	if is_player_looking_at then
		if Network:is_client() then
			managers.network:session():send_to_host("to_server_mission_element_trigger", self._id, player)
		else
			self:on_executed(player)
		end
	end
end
