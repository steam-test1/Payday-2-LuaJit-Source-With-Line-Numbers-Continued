core:module("CoreMenuStateStopLoadingGame")
core:import("CoreSessionResponse")
core:import("CoreMenuStatePreFrontEnd")
core:import("CoreMenuStateInGame")

StopLoadingGame = StopLoadingGame or class()

-- Lines 8-12
function StopLoadingGame:init()
	local menu_handler = self.menu_state._menu_handler
	self._response = CoreSessionResponse.Done:new()

	menu_handler:stop_loading_game_environment(self._response)
end

-- Lines 14-16
function StopLoadingGame:destroy()
	self._response:destroy()
end

-- Lines 18-24
function StopLoadingGame:transition()
	if not self._response:is_done() then
		return
	end

	return CoreMenuStateInGame.InGame
end
