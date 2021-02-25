core:module("CoreGameStateInEditorStopSimulation")
core:import("CoreGameStateInEditor")

StopSimulation = StopSimulation or class()

-- Lines 6-8
function StopSimulation:init()
	self.game_state._front_end_requester:task_started()
end

-- Lines 10-12
function StopSimulation:destroy()
	self.game_state._front_end_requester:task_completed()
end

-- Lines 14-16
function StopSimulation:transition()
	return CoreGameStateInEditor.InEditor
end
