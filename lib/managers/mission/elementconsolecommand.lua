core:import("CoreMissionScriptElement")

ElementConsoleCommand = ElementConsoleCommand or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementConsoleCommand:init(...)
	ElementConsoleCommand.super.init(self, ...)
end

-- Lines 9-17
function ElementConsoleCommand:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	Application:console_command("s " .. self._values.cmd)
	ElementConsoleCommand.super.on_executed(self, instigator)
end
