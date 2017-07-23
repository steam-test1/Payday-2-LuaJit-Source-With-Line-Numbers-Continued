core:module("CoreElementTimer")
core:import("CoreMissionScriptElement")

ElementTimer = ElementTimer or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 6 to 12
function ElementTimer:init(...)
	ElementTimer.super.init(self, ...)

	self._digital_gui_units = {}
	self._triggers = {}
end

-- Lines: 17 to 43
function ElementTimer:on_script_activated()
	self._timer = self:get_random_table_value_float(self:value("timer"))

	if not Network:is_server() then
		return
	end

	if self._values.digital_gui_unit_ids then
		for _, id in ipairs(self._values.digital_gui_unit_ids) do
			if Global.running_simulation then
				local unit = managers.editor:unit_with_id(id)

				table.insert(self._digital_gui_units, unit)
				unit:digital_gui():timer_set(self._timer)
			else
				local unit = managers.worlddefinition:get_unit_on_load(id, callback(self, self, "_load_unit"))

				if unit then
					table.insert(self._digital_gui_units, unit)
					unit:digital_gui():timer_set(self._timer)
				end
			end
		end
	end
end

-- Lines: 45 to 48
function ElementTimer:_load_unit(unit)
	table.insert(self._digital_gui_units, unit)
	unit:digital_gui():timer_set(self._timer)
end

-- Lines: 50 to 57
function ElementTimer:set_enabled(enabled)
	ElementTimer.super.set_enabled(self, enabled)
end

-- Lines: 60 to 69
function ElementTimer:add_updator()
	if not Network:is_server() then
		return
	end

	if not self._updator then
		self._updator = true

		self._mission_script:add_updator(self._id, callback(self, self, "update_timer"))
	end
end

-- Lines: 71 to 76
function ElementTimer:remove_updator()
	if self._updator then
		self._mission_script:remove_updator(self._id)

		self._updator = nil
	end
end

-- Lines: 78 to 92
function ElementTimer:update_timer(t, dt)
	self._timer = self._timer - dt

	if self._timer <= 0 then
		self:remove_updator()
		self:on_executed()
	end

	for id, cb_data in pairs(self._triggers) do
		if self._timer <= cb_data.time and not cb_data.disabled then
			cb_data.callback()
			self:remove_trigger(id)
		end
	end
end

-- Lines: 95 to 96
function ElementTimer:client_on_executed(...)
end

-- Lines: 98 to 104
function ElementTimer:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementTimer.super.on_executed(self, instigator)
end

-- Lines: 106 to 109
function ElementTimer:timer_operation_pause()
	self:remove_updator()
	self:_pause_digital_guis()
end

-- Lines: 111 to 114
function ElementTimer:timer_operation_start()
	self:add_updator()
	self:_start_digital_guis_count_down()
end

-- Lines: 116 to 119
function ElementTimer:timer_operation_add_time(time)
	self._timer = self._timer + time

	self:_update_digital_guis_timer()
end

-- Lines: 121 to 124
function ElementTimer:timer_operation_subtract_time(time)
	self._timer = self._timer - time

	self:_update_digital_guis_timer()
end

-- Lines: 126 to 129
function ElementTimer:timer_operation_reset()
	self._timer = self:get_random_table_value_float(self:value("timer"))

	self:_update_digital_guis_timer()
end

-- Lines: 131 to 134
function ElementTimer:timer_operation_set_time(time)
	self._timer = time

	self:_update_digital_guis_timer()
end

-- Lines: 136 to 142
function ElementTimer:_update_digital_guis_timer()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_set(self._timer, true)
		end
	end
end

-- Lines: 144 to 150
function ElementTimer:_start_digital_guis_count_down()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_start_count_down(true)
		end
	end
end

-- Lines: 152 to 158
function ElementTimer:_start_digital_guis_count_up()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_start_count_up(true)
		end
	end
end

-- Lines: 160 to 166
function ElementTimer:_pause_digital_guis()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_pause(true)
		end
	end
end

-- Lines: 168 to 170
function ElementTimer:add_trigger(id, time, callback, disabled)
	self._triggers[id] = {
		time = time,
		callback = callback,
		disabled = disabled
	}
end

-- Lines: 172 to 176
function ElementTimer:remove_trigger(id)
	if not self._triggers[id].disabled then
		self._triggers[id] = nil
	end
end

-- Lines: 178 to 182
function ElementTimer:enable_trigger(id)
	if self._triggers[id] then
		self._triggers[id].disabled = false
	end
end
ElementTimerOperator = ElementTimerOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 188 to 190
function ElementTimerOperator:init(...)
	ElementTimerOperator.super.init(self, ...)
end

-- Lines: 193 to 194
function ElementTimerOperator:client_on_executed(...)
end

-- Lines: 196 to 223
function ElementTimerOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local time = self:get_random_table_value_float(self:value("time"))

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.operation == "pause" then
				element:timer_operation_pause()
			elseif self._values.operation == "start" then
				element:timer_operation_start()
			elseif self._values.operation == "add_time" then
				element:timer_operation_add_time(time)
			elseif self._values.operation == "subtract_time" then
				element:timer_operation_subtract_time(time)
			elseif self._values.operation == "reset" then
				element:timer_operation_reset(time)
			elseif self._values.operation == "set_time" then
				element:timer_operation_set_time(time)
			end
		end
	end

	ElementTimerOperator.super.on_executed(self, instigator)
end
ElementTimerTrigger = ElementTimerTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 229 to 231
function ElementTimerTrigger:init(...)
	ElementTimerTrigger.super.init(self, ...)
end

-- Lines: 233 to 235
function ElementTimerTrigger:on_script_activated()
	self:activate_trigger()
end

-- Lines: 238 to 239
function ElementTimerTrigger:client_on_executed(...)
end

-- Lines: 241 to 247
function ElementTimerTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementTimerTrigger.super.on_executed(self, instigator)
end

-- Lines: 249 to 255
function ElementTimerTrigger:activate_trigger()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_trigger(self._id, self._values.time, callback(self, self, "on_executed"), not self:enabled())
	end
end

-- Lines: 257 to 259
function ElementTimerTrigger:operation_add()
	self:activate_trigger()
end

-- Lines: 261 to 268
function ElementTimerTrigger:set_enabled(enabled)
	ElementTimerTrigger.super.set_enabled(self, enabled)

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:enable_trigger(self._id)
	end
end

