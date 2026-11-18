core:module("CoreElementTimer")
core:import("CoreMissionScriptElement")

ElementTimer = ElementTimer or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 6-12
function ElementTimer:init(...)
	ElementTimer.super.init(self, ...)

	self._digital_gui_units = {}
	self._triggers = {}
end

-- Lines 14-36
function ElementTimer:on_script_activated()
	self._timer = self:get_random_table_value(self:value("timer"))

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

-- Lines 38-41
function ElementTimer:_load_unit(unit)
	table.insert(self._digital_gui_units, unit)
	unit:digital_gui():timer_set(self._timer)
end

-- Lines 43-50
function ElementTimer:set_enabled(enabled)
	ElementTimer.super.set_enabled(self, enabled)
end

-- Lines 52-62
function ElementTimer:add_updator()
	if not Network:is_server() then
		return
	end

	if not self._updator then
		self._updator = true

		self._mission_script:add_updator(self._id, callback(self, self, "update_timer"))
	end
end

-- Lines 64-69
function ElementTimer:remove_updator()
	if self._updator then
		self._mission_script:remove_updator(self._id)

		self._updator = nil
	end
end

-- Lines 71-85
function ElementTimer:update_timer(t, dt)
	self._timer = self._timer - dt

	if self._timer <= 0 then
		self:remove_updator()
		self:on_executed()
	end

	for id, cb_data in pairs(self._triggers) do
		if cb_data.time >= self._timer and not cb_data.disabled then
			cb_data.callback()
			self:remove_trigger(id)
		end
	end
end

-- Lines 87-89
function ElementTimer:client_on_executed(...)
	return
end

-- Lines 91-97
function ElementTimer:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementTimer.super.on_executed(self, instigator)
end

-- Lines 99-102
function ElementTimer:timer_operation_pause()
	self:remove_updator()
	self:_pause_digital_guis()
end

-- Lines 104-107
function ElementTimer:timer_operation_start()
	self:add_updator()
	self:_start_digital_guis_count_down()
end

-- Lines 109-112
function ElementTimer:timer_operation_add_time(time)
	self._timer = self._timer + time

	self:_update_digital_guis_timer()
end

-- Lines 114-117
function ElementTimer:timer_operation_subtract_time(time)
	self._timer = self._timer - time

	self:_update_digital_guis_timer()
end

-- Lines 119-122
function ElementTimer:timer_operation_reset()
	self._timer = self:get_random_table_value(self:value("timer"))

	self:_update_digital_guis_timer()
end

-- Lines 124-127
function ElementTimer:timer_operation_set_time(time)
	self._timer = time

	self:_update_digital_guis_timer()
end

-- Lines 129-135
function ElementTimer:_update_digital_guis_timer()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_set(self._timer, true)
		end
	end
end

-- Lines 137-143
function ElementTimer:_start_digital_guis_count_down()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_start_count_down(true)
		end
	end
end

-- Lines 145-151
function ElementTimer:_start_digital_guis_count_up()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_start_count_up(true)
		end
	end
end

-- Lines 153-159
function ElementTimer:_pause_digital_guis()
	for _, unit in ipairs(self._digital_gui_units) do
		if alive(unit) then
			unit:digital_gui():timer_pause(true)
		end
	end
end

-- Lines 161-163
function ElementTimer:add_trigger(id, time, callback, disabled)
	self._triggers[id] = {
		time = time,
		callback = callback,
		disabled = disabled
	}
end

-- Lines 165-169
function ElementTimer:remove_trigger(id)
	if not self._triggers[id].disabled then
		self._triggers[id] = nil
	end
end

-- Lines 171-175
function ElementTimer:enable_trigger(id)
	if self._triggers[id] then
		self._triggers[id].disabled = false
	end
end

ElementTimerOperator = ElementTimerOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 181-183
function ElementTimerOperator:init(...)
	ElementTimerOperator.super.init(self, ...)
end

-- Lines 185-187
function ElementTimerOperator:client_on_executed(...)
	return
end

-- Lines 189-216
function ElementTimerOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local time = self:get_random_table_value(self:value("time"))

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

-- Lines 222-224
function ElementTimerTrigger:init(...)
	ElementTimerTrigger.super.init(self, ...)
end

-- Lines 226-228
function ElementTimerTrigger:on_script_activated()
	self:activate_trigger()
end

-- Lines 230-232
function ElementTimerTrigger:client_on_executed(...)
	return
end

-- Lines 234-240
function ElementTimerTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementTimerTrigger.super.on_executed(self, instigator)
end

-- Lines 242-248
function ElementTimerTrigger:activate_trigger()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_trigger(self._id, self._values.time, callback(self, self, "on_executed"), not self:enabled())
	end
end

-- Lines 250-252
function ElementTimerTrigger:operation_add()
	self:activate_trigger()
end

-- Lines 254-261
function ElementTimerTrigger:set_enabled(enabled)
	ElementTimerTrigger.super.set_enabled(self, enabled)

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:enable_trigger(self._id)
	end
end
