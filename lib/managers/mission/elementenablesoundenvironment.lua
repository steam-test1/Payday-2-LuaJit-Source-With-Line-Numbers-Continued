core:import("CoreMissionScriptElement")

ElementEnableSoundEnvironment = ElementEnableSoundEnvironment or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementEnableSoundEnvironment:init(...)
	ElementEnableSoundEnvironment.super.init(self, ...)
end

-- Lines 9-11
function ElementEnableSoundEnvironment:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-23
function ElementEnableSoundEnvironment:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, name in pairs(self._values.elements) do
		managers.sound_environment:enable_area(name, self._values.enable)
	end

	ElementEnableSoundEnvironment.super.on_executed(self, instigator)
end
