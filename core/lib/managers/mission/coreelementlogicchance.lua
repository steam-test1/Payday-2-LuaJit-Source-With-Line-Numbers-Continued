core:module("CoreElementLogicChance")
core:import("CoreMissionScriptElement")

ElementLogicChance = ElementLogicChance or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 6 to 10
function ElementLogicChance:init(...)
	ElementLogicChance.super.init(self, ...)

	self._chance = self._values.chance
	self._triggers = {}
end

-- Lines: 13 to 14
function ElementLogicChance:client_on_executed(...)
end

-- Lines: 16 to 32
function ElementLogicChance:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local roll = math.random(100)

	if self._chance < roll then
		self:_trigger_outcome("fail")

		return
	end

	self:_trigger_outcome("success")
	ElementLogicChance.super.on_executed(self, instigator)
end

-- Lines: 34 to 36
function ElementLogicChance:chance_operation_add_chance(chance)
	self._chance = self._chance + chance
end

-- Lines: 38 to 40
function ElementLogicChance:chance_operation_subtract_chance(chance)
	self._chance = self._chance - chance
end

-- Lines: 42 to 44
function ElementLogicChance:chance_operation_reset()
	self._chance = self._values.chance
end

-- Lines: 46 to 48
function ElementLogicChance:chance_operation_set_chance(chance)
	self._chance = chance
end

-- Lines: 50 to 52
function ElementLogicChance:add_trigger(id, outcome, callback)
	self._triggers[id] = {
		outcome = outcome,
		callback = callback
	}
end

-- Lines: 54 to 56
function ElementLogicChance:remove_trigger(id)
	self._triggers[id] = nil
end

-- Lines: 58 to 64
function ElementLogicChance:_trigger_outcome(outcome)
	for _, data in pairs(self._triggers) do
		if data.outcome == outcome then
			data.callback()
		end
	end
end
ElementLogicChanceOperator = ElementLogicChanceOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 70 to 72
function ElementLogicChanceOperator:init(...)
	ElementLogicChanceOperator.super.init(self, ...)
end

-- Lines: 75 to 76
function ElementLogicChanceOperator:client_on_executed(...)
end

-- Lines: 78 to 99
function ElementLogicChanceOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.operation == "add_chance" then
				element:chance_operation_add_chance(self._values.chance)
			elseif self._values.operation == "subtract_chance" then
				element:chance_operation_subtract_chance(self._values.chance)
			elseif self._values.operation == "reset" then
				element:chance_operation_reset()
			elseif self._values.operation == "set_chance" then
				element:chance_operation_set_chance(self._values.chance)
			end
		end
	end

	ElementLogicChanceOperator.super.on_executed(self, instigator)
end
ElementLogicChanceTrigger = ElementLogicChanceTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 105 to 107
function ElementLogicChanceTrigger:init(...)
	ElementLogicChanceTrigger.super.init(self, ...)
end

-- Lines: 109 to 114
function ElementLogicChanceTrigger:on_script_activated()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_trigger(self._id, self._values.outcome, callback(self, self, "on_executed"))
	end
end

-- Lines: 117 to 118
function ElementLogicChanceTrigger:client_on_executed(...)
end

-- Lines: 120 to 126
function ElementLogicChanceTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementLogicChanceTrigger.super.on_executed(self, instigator)
end

return
