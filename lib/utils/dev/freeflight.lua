core:module("FreeFlight")
core:import("CoreFreeFlight")
core:import("CoreClass")

FreeFlight = FreeFlight or class(CoreFreeFlight.FreeFlight)

-- Lines 8-21
function FreeFlight:enable(...)
	FreeFlight.super.enable(self, ...)

	if managers.hud then
		managers.hud:set_freeflight_disabled()
	end
end

-- Lines 23-33
function FreeFlight:disable(...)
	FreeFlight.super.disable(self, ...)

	if managers.hud then
		managers.hud:set_freeflight_enabled()
	end
end

-- Lines 35-39
function FreeFlight:_pause()
	Application:set_pause(true)
end

-- Lines 41-45
function FreeFlight:_unpause()
	Application:set_pause(false)
end

CoreClass.override_class(CoreFreeFlight.FreeFlight, FreeFlight)
