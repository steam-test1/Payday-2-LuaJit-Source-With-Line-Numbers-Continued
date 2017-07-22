core:module("CoreGameStateInEditorPrepareStartSimulation")
core:import("CoreGameStateInEditorSimulation")
core:import("CoreGameStatePrepareLoadingGame")

PrepareStartSimulation = PrepareStartSimulation or class(CoreGameStatePrepareLoadingGame.PrepareLoadingGame)

-- Lines: 7 to 19
function PrepareStartSimulation:init()
	PrepareStartSimulation.super.init(self)

	local factory = self.game_state._session_manager._factory
	self._level_handler = factory:create_level_handler()

	self.game_state:player_slots():enter_level_handler(self._level_handler)

	local local_user_manager = self.game_state._session_manager._local_user_manager

	local_user_manager:enter_level_handler(self._level_handler)
	self._level_handler:set_player_slots(self.game_state:player_slots())
end

-- Lines: 21 to 25
function PrepareStartSimulation:transition()
	if self.game_state._session_manager:all_systems_are_stable_for_loading() then
		return CoreGameStateInEditorSimulation.Simulation, self._level_handler
	end
end

return
