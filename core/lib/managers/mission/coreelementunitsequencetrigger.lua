core:module("CoreElementUnitSequenceTrigger")
core:import("CoreMissionScriptElement")
core:import("CoreCode")

ElementUnitSequenceTrigger = ElementUnitSequenceTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 7 to 12
function ElementUnitSequenceTrigger:init(...)
	ElementUnitSequenceTrigger.super.init(self, ...)

	if not self._values.sequence_list and self._values.sequence then
		self._values.sequence_list = {{
			unit_id = self._values.unit_id,
			sequence = self._values.sequence
		}}
	end
end

-- Lines: 15 to 36
function ElementUnitSequenceTrigger:on_script_activated()
	if Network:is_client() then
		-- Nothing
	else
		self._mission_script:add_save_state_cb(self._id)

		for _, data in pairs(self._values.sequence_list) do
			managers.mission:add_runned_unit_sequence_trigger(data.unit_id, data.sequence, callback(self, self, "on_executed"))
		end
	end

	self._has_active_callback = true
end

-- Lines: 40 to 45
function ElementUnitSequenceTrigger:send_to_host(instigator)
	if alive(instigator) then
		managers.network:session():send_to_host("to_server_mission_element_trigger", self._id, instigator)
	end
end

-- Lines: 47 to 58
function ElementUnitSequenceTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementUnitSequenceTrigger.super.on_executed(self, instigator)
end

-- Lines: 60 to 62
function ElementUnitSequenceTrigger:save(data)
	data.save_me = true
end

-- Lines: 66 to 71
function ElementUnitSequenceTrigger:load(data)
	if not self._has_active_callback then
		self:on_script_activated()
	end
end

return
