core:module("CoreGameStateInEditorStopSimulation")
core:import("CoreGameStateInEditor")

StopSimulation = StopSimulation or class()

-- Lines: 6 to 8
function StopSimulation:init()
	self.game_state._front_end_requester:task_started()
end

-- Lines: 10 to 12
function StopSimulation:destroy()
	self.game_state._front_end_requester:task_completed()
end

-- Lines: 14 to 15
function StopSimulation:transition()
	return CoreGameStateInEditor.InEditor
end

return
