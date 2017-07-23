core:import("CoreMissionScriptElement")

ElementWhisperState = ElementWhisperState or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementWhisperState:init(...)
	ElementWhisperState.super.init(self, ...)
end

-- Lines: 9 to 11
function ElementWhisperState:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 13 to 21
function ElementWhisperState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_whisper_mode(self._values.state)
	ElementWhisperState.super.on_executed(self, instigator)
end

