core:import("CoreMissionScriptElement")

ElementActionMessage = ElementActionMessage or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementActionMessage:init(...)
	ElementActionMessage.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementActionMessage:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 27
function ElementActionMessage:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if (self._values.message_id == "none" or instigator ~= managers.player:player_unit()) and Application:editor() then
		managers.editor:output_error("Cant show message " .. self._values.message_id .. " in element " .. self._editor_name .. ".")
	end

	ElementActionMessage.super.on_executed(self, instigator)
end

return
