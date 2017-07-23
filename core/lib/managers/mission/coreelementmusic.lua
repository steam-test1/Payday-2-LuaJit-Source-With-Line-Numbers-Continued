core:module("CoreElementMusic")
core:import("CoreMissionScriptElement")

ElementMusic = ElementMusic or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 6 to 8
function ElementMusic:init(...)
	ElementMusic.super.init(self, ...)
end

-- Lines: 10 to 12
function ElementMusic:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 14 to 28
function ElementMusic:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not self._values.use_instigator or instigator == managers.player:player_unit() then
		if self._values.music_event then
			managers.music:post_event(self._values.music_event)
		elseif Application:editor() then
			managers.editor:output_error("Cant play music event nil [" .. self._editor_name .. "]")
		end
	end

	ElementMusic.super.on_executed(self, instigator)
end

