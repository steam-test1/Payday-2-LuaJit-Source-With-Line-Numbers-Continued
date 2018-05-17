core:import("CoreMissionScriptElement")

ElementDisableShout = ElementDisableShout or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementDisableShout:init(...)
	ElementDisableShout.super.init(self, ...)
end

-- Lines: 10 to 11
function ElementDisableShout:client_on_executed(...)
end

-- Lines: 13 to 15
function ElementDisableShout.sync_function(unit, state)
	unit:unit_data().disable_shout = state
end

-- Lines: 17 to 34
function ElementDisableShout:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	-- Lines: 22 to 25
	local function f(unit)
		ElementDisableShout.sync_function(unit, self._values.disable_shout)
		managers.network:session():send_to_peers_synched("sync_disable_shout", unit, self._values.disable_shout)
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:execute_on_all_units(f)
	end

	ElementDisableShout.super.on_executed(self, instigator)
end

