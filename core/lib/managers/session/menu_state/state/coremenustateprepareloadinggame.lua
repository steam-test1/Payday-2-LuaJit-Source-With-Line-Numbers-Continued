core:module("CoreMenuStatePrepareLoadingGame")
core:import("CoreSessionResponse")
core:import("CoreMenuStateInGame")
core:import("CoreMenuStateLoadingGame")

PrepareLoadingGame = PrepareLoadingGame or class()

-- Lines 8-13
function PrepareLoadingGame:init()
	self._response = CoreSessionResponse.Done:new()
	local menu_handler = self.menu_state._menu_handler

	menu_handler:prepare_loading_game(self._response)
end

-- Lines 15-17
function PrepareLoadingGame:destroy()
	self._response:destroy()
end

-- Lines 19-23
function PrepareLoadingGame:transition()
	if self._response:is_done() then
		return CoreMenuStateLoadingGame.LoadingGame
	end
end
