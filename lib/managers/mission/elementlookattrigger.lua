core:import("CoreMissionScriptElement")

ElementLookAtTrigger = ElementLookAtTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementLookAtTrigger:init(...)
	ElementLookAtTrigger.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementLookAtTrigger:on_script_activated()
	self:add_callback()
end

-- Lines: 13 to 18
function ElementLookAtTrigger:set_enabled(enabled)
	ElementLookAtTrigger.super.set_enabled(self, enabled)

	if enabled then
		self:add_callback()
	end
end

-- Lines: 20 to 24
function ElementLookAtTrigger:add_callback()
	if not self._callback then
		self._callback = self._mission_script:add(callback(self, self, "update_lookat"), self._values.interval)
	end
end

-- Lines: 26 to 31
function ElementLookAtTrigger:remove_callback()
	if self._callback then
		self._mission_script:remove(self._callback)

		self._callback = nil
	end
end

-- Lines: 33 to 44
function ElementLookAtTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementLookAtTrigger.super.on_executed(self, instigator)

	if not self._values.enabled then
		self:remove_callback()
	end
end

-- Lines: 47 to 79
function ElementLookAtTrigger:update_lookat()
	if not self._values.enabled then
		return
	end

	local player = managers.player:player_unit()

	if alive(player) then
		local dir = self._values.position - player:camera():position()

		if self._values.distance and self._values.distance > 0 then
			local distance = dir:length()

			if self._values.distance < distance then
				return
			end
		end

		if self._values.in_front then
			local dot = player:camera():forward():dot(self._values.rotation:y())

			if dot > 0 then
				return
			end
		end

		dir = dir:normalized()
		local dot = player:camera():forward():dot(dir)

		if self._values.sensitivity <= dot then
			if Network:is_client() then
				managers.network:session():send_to_host("to_server_mission_element_trigger", self._id, player)
			else
				self:on_executed(player)
			end
		end
	end
end

