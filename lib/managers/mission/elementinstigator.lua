core:import("CoreMissionScriptElement")

ElementInstigator = ElementInstigator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 10
function ElementInstigator:init(...)
	ElementInstigator.super.init(self, ...)

	self._instigators = {}
	self._triggers = {}
end

-- Lines: 13 to 14
function ElementInstigator:client_on_executed(...)
end

-- Lines: 16 to 24
function ElementInstigator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:instigator_operation_set(instigator)
	ElementInstigator.super.on_executed(self, instigator)
end

-- Lines: 26 to 43
function ElementInstigator:instigator_operation_set(instigator)
	if not self:_is_valid_instigator(instigator) then
		return
	end

	if not table.contains(self._instigators, instigator) then
		self:_check_triggers("changed")
	end

	if alive(instigator) and not instigator:character_damage():dead() then
		self._instigators = {instigator}

		if instigator:unit_data().mission_element then
			instigator:unit_data().mission_element:add_event_callback("death", callback(self, self, "on_instigator_death"))
		end

		self:_check_triggers("set")
	end
end

-- Lines: 45 to 63
function ElementInstigator:instigator_operation_add_first(instigator)
	if not self:_is_valid_instigator(instigator) then
		return
	end

	if table.contains(self._instigators, instigator) then
		return
	end

	if alive(instigator) and not instigator:character_damage():dead() then
		table.insert(self._instigators, 1, instigator)

		if instigator:unit_data().mission_element then
			instigator:unit_data().mission_element:add_event_callback("death", callback(self, self, "on_instigator_death"))
		end

		self:_check_triggers("add_first")
	end
end

-- Lines: 65 to 83
function ElementInstigator:instigator_operation_add_last(instigator)
	if not self:_is_valid_instigator(instigator) then
		return
	end

	if table.contains(self._instigators, instigator) then
		return
	end

	if alive(instigator) and not instigator:character_damage():dead() then
		table.insert(self._instigators, instigator)

		if instigator:unit_data().mission_element then
			instigator:unit_data().mission_element:add_event_callback("death", callback(self, self, "on_instigator_death"))
		end

		self:_check_triggers("add_last")
	end
end

-- Lines: 85 to 101
function ElementInstigator:_is_valid_instigator(instigator)
	if type_name(instigator) ~= "Unit" then
		local msg = "[ElementInstigator:_is_valid_instigator] Element can only store units as instigators. Tried to use type " .. type_name(instigator) .. "."

		if Application:editor() then
			managers.editor:output_error(msg)
		else
			Application:error(msg)
		end

		return false
	end

	if not alive(instigator) or instigator:character_damage():dead() then
		if Application:editor() then
			managers.editor:output_error("Cant set instigator. Reason: " .. (not alive(instigator) and " Dont exist" or instigator:character_damage():dead() and "Dead") .. ". In element " .. self._editor_name .. ".")
		end

		return false
	end

	return true
end

-- Lines: 104 to 112
function ElementInstigator:on_instigator_death(unit)
	if not table.contains(self._instigators, unit) then
		return
	end

	self:_check_triggers("death")
end

-- Lines: 114 to 117
function ElementInstigator:instigator_operation_clear(instigator)
	self._instigators = {}

	self:_check_triggers("cleared")
end

-- Lines: 119 to 120
function ElementInstigator:instigator_operation_use_first(keep_on_use)
	return keep_on_use and self._instigators[1] or table.remove(self._instigators, 1)
end

-- Lines: 123 to 124
function ElementInstigator:instigator_operation_use_last(keep_on_use)
	return keep_on_use and self._instigators[#self._instigators] or table.remove(self._instigators)
end

-- Lines: 127 to 129
function ElementInstigator:instigator_operation_use_random(keep_on_use)
	local index = math.random(#self._instigators)

	return keep_on_use and self._instigators[index] or table.remove(self._instigators, index)
end

-- Lines: 132 to 139
function ElementInstigator:instigator_operation_use_all(keep_on_use)
	if keep_on_use then
		return self._instigators
	end

	local instigators = clone(self._instigators)
	self._instigators = {}

	return instigators
end

-- Lines: 143 to 146
function ElementInstigator:add_trigger(id, type, callback)
	self._triggers[type] = self._triggers[type] or {}
	self._triggers[type][id] = {callback = callback}
end

-- Lines: 149 to 157
function ElementInstigator:_check_triggers(type)
	if not self._triggers[type] then
		return
	end

	for id, cb_data in pairs(self._triggers[type]) do
		cb_data.callback()
	end
end
ElementInstigatorOperator = ElementInstigatorOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 163 to 165
function ElementInstigatorOperator:init(...)
	ElementInstigatorOperator.super.init(self, ...)
end

-- Lines: 168 to 169
function ElementInstigatorOperator:client_on_executed(...)
end

-- Lines: 171 to 211
function ElementInstigatorOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.operation ~= "none" then
		for _, id in ipairs(self._values.elements) do
			local element = self:get_mission_element(id)

			if element then
				if self._values.operation == "set" then
					element:instigator_operation_set(instigator)
				elseif self._values.operation == "add_first" then
					element:instigator_operation_add_first(instigator)
				elseif self._values.operation == "add_last" then
					element:instigator_operation_add_last(instigator)
				elseif self._values.operation == "clear" then
					element:instigator_operation_clear()
				elseif self._values.operation == "use_first" then
					self:_check_and_execute(element:instigator_operation_use_first(self._values.keep_on_use))
				elseif self._values.operation == "use_last" then
					self:_check_and_execute(element:instigator_operation_use_last(self._values.keep_on_use))
				elseif self._values.operation == "use_random" then
					self:_check_and_execute(element:instigator_operation_use_random(self._values.keep_on_use))
				elseif self._values.operation == "use_all" then
					for _, use_instigator in ipairs(element:instigator_operation_use_all(self._values.keep_on_use)) do
						self:_check_and_execute(use_instigator)
					end
				end
			end
		end
	elseif Application:editor() then
		managers.editor:output_error("Cant use operation " .. self._values.operation .. " in element " .. self._editor_name .. ".")
	end

	if self._values.operation == "set" or self._values.operation == "add_first" or self._values.operation == "add_last" or self._values.operation == "clear" then
		ElementInstigatorOperator.super.on_executed(self, instigator)
	end
end

-- Lines: 213 to 219
function ElementInstigatorOperator:_check_and_execute(use_instigator)
	if alive(use_instigator) and not use_instigator:character_damage():dead() then
		ElementInstigatorOperator.super.on_executed(self, use_instigator)
	elseif Application:editor() then
		managers.editor:output_warning("Cant use instigator. Reason: " .. (not alive(use_instigator) and " Dont exist" or use_instigator:character_damage():dead() and "Dead") .. ". In element " .. self._editor_name .. ".")
	end
end
ElementInstigatorTrigger = ElementInstigatorTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 225 to 227
function ElementInstigatorTrigger:init(...)
	ElementInstigatorTrigger.super.init(self, ...)
end

-- Lines: 229 to 234
function ElementInstigatorTrigger:on_script_activated()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_trigger(self._id, self._values.trigger_type, callback(self, self, "on_executed"))
	end
end

-- Lines: 237 to 238
function ElementInstigatorTrigger:client_on_executed(...)
end

-- Lines: 240 to 246
function ElementInstigatorTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementInstigatorTrigger.super.on_executed(self, instigator)
end

