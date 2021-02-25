core:import("CoreMissionScriptElement")

ElementLootSecuredTrigger = ElementLootSecuredTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementLootSecuredTrigger:init(...)
	ElementLootSecuredTrigger.super.init(self, ...)
end

-- Lines 9-11
function ElementLootSecuredTrigger:client_on_executed(...)
end

-- Lines 13-19
function ElementLootSecuredTrigger:on_script_activated()
	if self._values.report_only then
		managers.loot:add_trigger(self._id, "report_only", self._values.amount, callback(self, self, "on_executed"))
	else
		managers.loot:add_trigger(self._id, self._values.include_instant_cash and "total_amount" or "amount", self._values.amount, callback(self, self, "on_executed"))
	end
end

-- Lines 21-27
function ElementLootSecuredTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementLootSecuredTrigger.super.on_executed(self, instigator)
end
