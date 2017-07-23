core:import("CoreMissionScriptElement")

ElementHeat = ElementHeat or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementHeat:init(...)
	ElementHeat.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementHeat:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 26
function ElementHeat:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if Network:is_server() then
		if self._values.level ~= 0 then
			managers.groupai:state():force_up_heat_level(self._values.level)
		elseif self._values.points ~= 0 then
			-- Nothing
		end
	end

	ElementHeat.super.on_executed(self, instigator)
end
ElementHeatTrigger = ElementHeatTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 32 to 38
function ElementHeatTrigger:init(...)
	ElementHeatTrigger.super.init(self, ...)

	if Network:is_server() then
		self:add_callback()
	end
end

-- Lines: 41 to 42
function ElementHeatTrigger:add_callback()
end

-- Lines: 45 to 46
function ElementHeatTrigger:remove_callback()
end

-- Lines: 48 to 56
function ElementHeatTrigger:heat_changed()
	if Network:is_client() then
		return
	end
end

-- Lines: 62 to 74
function ElementHeatTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	instigator = managers.player:player_unit()

	ElementHeatTrigger.super.on_executed(self, instigator)

	if not self._values.enabled then
		self:remove_callback()
	end
end

