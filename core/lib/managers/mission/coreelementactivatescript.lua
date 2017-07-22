core:module("CoreElementActivateScript")
core:import("CoreMissionScriptElement")

ElementActivateScript = ElementActivateScript or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 6 to 8
function ElementActivateScript:init(...)
	ElementActivateScript.super.init(self, ...)
end

-- Lines: 10 to 12
function ElementActivateScript:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 14 to 26
function ElementActivateScript:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.activate_script ~= "none" then
		managers.mission:activate_script(self._values.activate_script, instigator)
	elseif Application:editor() then
		managers.editor:output_error("Cant activate script named \"none\" [" .. self._editor_name .. "]")
	end

	ElementActivateScript.super.on_executed(self, instigator)
end

return
