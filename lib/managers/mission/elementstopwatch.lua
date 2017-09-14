core:import("CoreMissionScriptElement")

ElementStopwatch = ElementStopwatch or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 6 to 12
function ElementStopwatch:init(...)
	ElementStopwatch.super.init(self, ...)

	self._digital_gui_units = {}
	self._triggers = {}
end

-- Lines: 15 to 42
function ElementStopwatch:on_script_activated()
	self._timer = 0

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

-- Lines: 44 to 47
function ElementStopwatch:_load_unit(unit)
	table.insert(self._digital_gui_units, unit)
	unit:digital_gui():timer_set(self._timer)
end

-- Lines: 49 to 51
function ElementStopwatch:set_enabled(enabled)
	ElementStopwatch.super.set_enabled(self, enabled)
end

-- Lines: 55 to 65
function ElementStopwatch:add_updator()
	if not Network:is_server() then
		return
	end

	if not self._updator then
		self._updator = true

		self._mission_script:add_updator(self._id, callback(self, self, "update_timer"))
	end
end

-- Lines: 67 to 72
function ElementStopwatch:remove_updator()
	if self._updator then
		self._mission_script:remove_updator(self._id)

		self._updator = nil
	end
end

-- Lines: 75 to 84
function ElementStopwatch:update_timer(t, dt)
	self._timer = self._timer + dt

	for id, cb_data in pairs(self._triggers) do
		if cb_data.time <= self._timer and not cb_data.disabled then
			cb_data.callback()
			self:remove_trigger(id)
		end
	end
end

-- Lines: 87 to 88
function ElementStopwatch:client_on_executed(...)
end

-- Lines: 90 to 95
function ElementStopwatch:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementStopwatch.super.on_executed(self, instigator)
end

-- Lines: 97 to 98
function ElementStopwatch:get_time()
	return self._timer
end

-- Lines: 101 to 104
function ElementStopwatch:stopwatch_operation_pause()
	self:remove_updator()
	self:_pause_digital_guis()
end

-- Lines: 106 to 110
function ElementStopwatch:stopwatch_operation_start()
	self:_update_digital_guis_timer()
	self:add_updator()
	self:_start_digital_guis_count_up()
end

-- Lines: 112 to 115
function ElementStopwatch:stopwatch_operation_add_time(time)
	self._timer = self._timer + time

	self:_update_digital_guis_timer()
end

-- Lines: 117 to 120
function ElementStopwatch:stopwatch_operation_subtract_time(time)
	self._timer = self._timer - time

	self:_update_digital_guis_timer()
end

-- Lines: 122 to 125
function ElementStopwatch:stopwatch_operation_reset()
	self._timer = 0

	self:_update_digital_guis_timer()
end

-- Lines: 127 to 130
function ElementStopwatch:stopwatch_operation_set_time(time)
	self._timer = time

	self:_update_digital_guis_timer()
end

-- Lines: 132 to 138
function ElementStopwatch:_update_digital_guis_timer()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_set(self._timer, true)
		end
	end
end

-- Lines: 140 to 146
function ElementStopwatch:_start_digital_guis_count_up()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_start_count_up(true)
		end
	end
end

-- Lines: 148 to 154
function ElementStopwatch:_pause_digital_guis()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_pause(true)
		end
	end
end

-- Lines: 156 to 158
function ElementStopwatch:add_trigger(id, time, callback, disabled)
	self._triggers[id] = {
		time = time,
		callback = callback,
		disabled = disabled
	}
end

-- Lines: 160 to 164
function ElementStopwatch:remove_trigger(id)
	if not self._triggers[id].disabled then
		self._triggers[id] = nil
	end
end

-- Lines: 166 to 170
function ElementStopwatch:enable_trigger(id)
	if self._triggers[id] then
		self._triggers[id].disabled = false
	end
end
ElementStopwatchOperator = ElementStopwatchOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 176 to 178
function ElementStopwatchOperator:init(...)
	ElementStopwatchOperator.super.init(self, ...)
end

-- Lines: 181 to 182
function ElementStopwatchOperator:client_on_executed(...)
end

-- Lines: 185 to 234
function ElementStopwatchOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local time = self:get_random_table_value_float(self:value("time"))

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.operation == "pause" then
				element:stopwatch_operation_pause()
			elseif self._values.operation == "start" then
				element:stopwatch_operation_start()
			elseif self._values.operation == "add_time" then
				element:stopwatch_operation_add_time(time)
			elseif self._values.operation == "subtract_time" then
				element:stopwatch_operation_subtract_time(time)
			elseif self._values.operation == "reset" then
				element:stopwatch_operation_reset()
			elseif self._values.operation == "set_time" then
				element:stopwatch_operation_set_time(time)
			elseif self._values.operation == "save_time" then
				local time = element:get_time() or 0
				local saved_time = managers.mission:get_saved_job_value(self:value("save_key"))

				print("[stopwatch] saving stopwatch time", self:value("save_key"), time, saved_time, self:_save_value_ok(time, saved_time))

				if self:_save_value_ok(time, saved_time) then
					Global.mission_manager.saved_job_values[self:value("save_key")] = time
				end
			elseif self._values.operation == "load_time" then
				print("[stopwatch] loading stopwatch time", self:value("save_key"), Global.mission_manager.saved_job_values[self:value("save_key")])

				local saved_time = Global.mission_manager.saved_job_values[self:value("save_key")]

				if saved_time ~= nil then
					if type(saved_time) ~= "number" then
						saved_time = tonumber(saved_time)
					end

					if saved_time ~= nil then
						element:stopwatch_operation_set_time(saved_time)
					end
				end
			end
		end
	end

	ElementStopwatchOperator.super.on_executed(self, instigator)
end

-- Lines: 237 to 252
function ElementStopwatchOperator:_save_value_ok(new_time, saved_time)
	local condition = self:value("condition")

	if condition == "always" or saved_time == nil then
		return true
	elseif condition == "equal" then
		return new_time == saved_time
	elseif condition == "less_than" then
		return new_time < saved_time
	elseif condition == "greater_than" then
		return saved_time < new_time
	elseif condition == "less_or_equal" then
		return new_time <= saved_time
	elseif condition == "greater_or_equal" then
		return saved_time <= new_time
	end

	return false
end
ElementStopwatchTrigger = ElementStopwatchTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 260 to 262
function ElementStopwatchTrigger:init(...)
	ElementStopwatchTrigger.super.init(self, ...)
end

-- Lines: 264 to 266
function ElementStopwatchTrigger:on_script_activated()
	self:activate_trigger()
end

-- Lines: 268 to 273
function ElementStopwatchTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementStopwatchTrigger.super.on_executed(self, instigator)
end

-- Lines: 276 to 277
function ElementStopwatchTrigger:client_on_executed(...)
end

-- Lines: 280 to 289
function ElementStopwatchTrigger:activate_trigger()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			element:add_trigger(self._id, self._values.time, callback(self, self, "on_executed"), not self:enabled())
		end
	end
end

-- Lines: 291 to 292
function ElementStopwatchTrigger:operation_add()
end

-- Lines: 295 to 305
function ElementStopwatchTrigger:set_enabled(enabled)
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			element:enable_trigger(self._id)
		end
	end

	ElementStopwatchTrigger.super.set_enabled(self, enabled)
end
ElementStopwatchFilter = ElementStopwatchFilter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 311 to 313
function ElementStopwatchFilter:init(...)
	ElementStopwatchFilter.super.init(self, ...)
end

-- Lines: 316 to 317
function ElementStopwatchFilter:on_script_activated()
end

-- Lines: 320 to 321
function ElementStopwatchFilter:client_on_executed(...)
end

-- Lines: 323 to 327
function ElementStopwatchFilter:on_executed(instigator)
	if self._values.enabled and self:_values_ok() then
		ElementStopwatchFilter.super.on_executed(self, instigator)
	end
end

-- Lines: 329 to 336
function ElementStopwatchFilter:_values_ok()
	if self._values.needed_to_execute == "all" then
		return self:_all_elements_ok()
	end

	if self._values.needed_to_execute == "any" then
		return self:_any_elements_ok()
	end
end

-- Lines: 338 to 344
function ElementStopwatchFilter:_all_elements_ok()
	for _, id in ipairs(self._values.elements) do
		if not self:_check_time(self:get_mission_element(id), self:_get_time()) then
			return false
		end
	end

	return true
end

-- Lines: 347 to 353
function ElementStopwatchFilter:_any_elements_ok()
	for _, id in ipairs(self._values.elements) do
		if self:_check_time(self:get_mission_element(id), self:_get_time()) then
			return true
		end
	end

	return false
end

-- Lines: 357 to 365
function ElementStopwatchFilter:_get_time()
	local time = self._values.value

	if self._values.stopwatch_value_ids and #self._values.stopwatch_value_ids > 0 then
		local element = self:get_mission_element(self._values.stopwatch_value_ids[1])

		if element then
			time = element:get_time()
		end
	end

	return time
end

-- Lines: 369 to 381
function ElementStopwatchFilter:_check_time(element, value)
	if not self._values.check_type or self._values.check_type == "equal" then
		return element:get_time() == value
	elseif self._values.check_type == "less_or_equal" then
		return element:get_time() <= value
	elseif self._values.check_type == "greater_or_equal" then
		return value <= element:get_time()
	elseif self._values.check_type == "less_than" then
		return element:get_time() < value
	elseif self._values.check_type == "greater_than" then
		return value < element:get_time()
	end

	return false
end

