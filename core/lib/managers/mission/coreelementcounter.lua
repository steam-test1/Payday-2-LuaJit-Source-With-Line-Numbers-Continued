core:module("CoreElementCounter")
core:import("CoreMissionScriptElement")
core:import("CoreClass")

ElementCounter = ElementCounter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 7 to 13
function ElementCounter:init(...)
	ElementCounter.super.init(self, ...)

	self._digital_gui_units = {}
	self._triggers = {}
end

-- Lines: 15 to 40
function ElementCounter:on_script_activated()
	self._values.counter_target = self:value("counter_target")
	self._original_value = self._values.counter_target

	if not Network:is_server() then
		return
	end

	if self._values.digital_gui_unit_ids then
		for _, id in ipairs(self._values.digital_gui_unit_ids) do
			if Global.running_simulation then
				local unit = managers.editor:unit_with_id(id)

				table.insert(self._digital_gui_units, unit)
				unit:digital_gui():number_set(self._values.counter_target)
			else
				local unit = managers.worlddefinition:get_unit_on_load(id, callback(self, self, "_load_unit"))

				if unit then
					table.insert(self._digital_gui_units, unit)
					unit:digital_gui():number_set(self._values.counter_target)
				end
			end
		end
	end
end

-- Lines: 42 to 45
function ElementCounter:_load_unit(unit)
	table.insert(self._digital_gui_units, unit)
	unit:digital_gui():number_set(self._values.counter_target)
end

-- Lines: 47 to 66
function ElementCounter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.counter_target > 0 then
		self._values.counter_target = self._values.counter_target - 1

		self:_update_digital_guis_number()

		if self:is_debug() then
			self._mission_script:debug_output("Counter " .. self._editor_name .. ": " .. self._values.counter_target .. " Previous value: " .. self._values.counter_target + 1, Color(1, 0, 0.75, 0))
		end

		if self._values.counter_target == 0 then
			ElementCounter.super.on_executed(self, instigator)
		end
	elseif self:is_debug() then
		self._mission_script:debug_output("Counter " .. self._editor_name .. ": already exhausted!", Color(1, 0, 0.75, 0))
	end
end

-- Lines: 68 to 71
function ElementCounter:reset_counter_target(counter_target)
	self._values.counter_target = counter_target

	self:_update_digital_guis_number()
end

-- Lines: 74 to 79
function ElementCounter:counter_operation_add(amount)
	self._values.counter_target = self._values.counter_target + amount

	self:_update_digital_guis_number()
	self:_check_triggers("add")
	self:_check_triggers("value")
end

-- Lines: 82 to 87
function ElementCounter:counter_operation_subtract(amount)
	self._values.counter_target = self._values.counter_target - amount

	self:_update_digital_guis_number()
	self:_check_triggers("subtract")
	self:_check_triggers("value")
end

-- Lines: 90 to 95
function ElementCounter:counter_operation_reset(amount)
	self._values.counter_target = self._original_value

	self:_update_digital_guis_number()
	self:_check_triggers("reset")
	self:_check_triggers("value")
end

-- Lines: 98 to 103
function ElementCounter:counter_operation_set(amount)
	self._values.counter_target = amount

	self:_update_digital_guis_number()
	self:_check_triggers("set")
	self:_check_triggers("value")
end

-- Lines: 106 to 113
function ElementCounter:apply_job_value(amount)
	local type = CoreClass.type_name(amount)

	if type ~= "number" then
		Application:error("[ElementCounter:apply_job_value] " .. self._id .. "(" .. self._editor_name .. ") Can't apply job value of type " .. type)

		return
	end

	self:counter_operation_set(amount)
end

-- Lines: 115 to 119
function ElementCounter:add_trigger(id, type, amount, callback)
	self._triggers[type] = self._triggers[type] or {}
	self._triggers[type][id] = {
		amount = amount,
		callback = callback
	}
end

-- Lines: 121 to 122
function ElementCounter:counter_value()
	return self._values.counter_target
end

-- Lines: 129 to 135
function ElementCounter:_update_digital_guis_number()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():number_set(self._values.counter_target, true)
		end
	end
end

-- Lines: 138 to 149
function ElementCounter:_check_triggers(type)
	if not self._triggers[type] then
		return
	end

	for id, cb_data in pairs(self._triggers[type]) do
		if type ~= "value" or cb_data.amount == self._values.counter_target then
			cb_data.callback()
		end
	end
end
ElementCounterReset = ElementCounterReset or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 155 to 157
function ElementCounterReset:init(...)
	ElementCounterReset.super.init(self, ...)
end

-- Lines: 159 to 176
function ElementCounterReset:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self:is_debug() then
				self._mission_script:debug_output("Counter reset " .. element:editor_name() .. " to: " .. self._values.counter_target, Color(1, 0, 0.75, 0))
			end

			element:reset_counter_target(self._values.counter_target)
		end
	end

	ElementCounterReset.super.on_executed(self, instigator)
end
ElementCounterOperator = ElementCounterOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 182 to 184
function ElementCounterOperator:init(...)
	ElementCounterOperator.super.init(self, ...)
end

-- Lines: 187 to 188
function ElementCounterOperator:client_on_executed(...)
end

-- Lines: 190 to 213
function ElementCounterOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local amount = self:value("amount")

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.operation == "add" then
				element:counter_operation_add(amount)
			elseif self._values.operation == "subtract" then
				element:counter_operation_subtract(amount)
			elseif self._values.operation == "reset" then
				element:counter_operation_reset(amount)
			elseif self._values.operation == "set" then
				element:counter_operation_set(amount)
			end
		end
	end

	ElementCounterOperator.super.on_executed(self, instigator)
end
ElementCounterTrigger = ElementCounterTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 219 to 221
function ElementCounterTrigger:init(...)
	ElementCounterTrigger.super.init(self, ...)
end

-- Lines: 223 to 228
function ElementCounterTrigger:on_script_activated()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_trigger(self._id, self._values.trigger_type, self._values.amount, callback(self, self, "on_executed"))
	end
end

-- Lines: 231 to 232
function ElementCounterTrigger:client_on_executed(...)
end

-- Lines: 234 to 240
function ElementCounterTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementCounterTrigger.super.on_executed(self, instigator)
end
ElementCounterFilter = ElementCounterFilter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 246 to 248
function ElementCounterFilter:init(...)
	ElementCounterFilter.super.init(self, ...)
end

-- Lines: 251 to 252
function ElementCounterFilter:on_script_activated()
end

-- Lines: 255 to 256
function ElementCounterFilter:client_on_executed(...)
end

-- Lines: 258 to 268
function ElementCounterFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not self:_values_ok() then
		return
	end

	ElementCounterFilter.super.on_executed(self, instigator)
end

-- Lines: 271 to 288
function ElementCounterFilter:_values_ok()
	if self._values.check_type == "counters_equal" then
		return self:_all_counter_values_equal()
	end

	if self._values.check_type == "counters_not_equal" then
		return not self:_all_counter_values_equal()
	end

	if self._values.needed_to_execute == "all" then
		return self:_all_counters_ok()
	end

	if self._values.needed_to_execute == "any" then
		return self:_any_counters_ok()
	end
end

-- Lines: 290 to 300
function ElementCounterFilter:_all_counter_values_equal()
	local test_value = nil

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)
		test_value = test_value or element:counter_value()

		if test_value ~= element:counter_value() then
			return false
		end
	end

	return true
end

-- Lines: 303 to 309
function ElementCounterFilter:_all_counters_ok()
	for _, id in ipairs(self._values.elements) do
		if not self:_check_type(self:get_mission_element(id)) then
			return false
		end
	end

	return true
end

-- Lines: 312 to 318
function ElementCounterFilter:_any_counters_ok()
	for _, id in ipairs(self._values.elements) do
		if self:_check_type(self:get_mission_element(id)) then
			return true
		end
	end

	return false
end

-- Lines: 321 to 342
function ElementCounterFilter:_check_type(element)
	if not self._values.check_type or self._values.check_type == "equal" then
		return element:counter_value() == self._values.value
	end

	if self._values.check_type == "less_or_equal" then
		return element:counter_value() <= self._values.value
	end

	if self._values.check_type == "greater_or_equal" then
		return self._values.value <= element:counter_value()
	end

	if self._values.check_type == "less_than" then
		return element:counter_value() < self._values.value
	end

	if self._values.check_type == "greater_than" then
		return self._values.value < element:counter_value()
	end
end

return
