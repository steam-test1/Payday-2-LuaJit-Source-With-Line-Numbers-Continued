core:module("CoreGameStateInEditorPrepareStopSimulation")
core:import("CoreGameStateInEditorStopSimulation")

PrepareStopSimulation = PrepareStopSimulation or class()

-- Lines: 6 to 8
function PrepareStopSimulation:init(level_handler)
	self._level_handler = level_handler
end

-- Lines: 11 to 17
function PrepareStopSimulation:destroy()
	local local_user_manager = self.game_state._session_manager._local_user_manager

	self.game_state:player_slots():leave_level_handler(self._level_handler)
	local_user_manager:leave_level_handler(self._level_handler)
	self._level_handler:destroy()
end

-- Lines: 19 to 23
function PrepareStopSimulation:transition()
	if self.game_state._session_manager:all_systems_are_stable_for_loading() then
		return CoreGameStateInEditorStopSimulation.StopSimulation
	end
end

return
