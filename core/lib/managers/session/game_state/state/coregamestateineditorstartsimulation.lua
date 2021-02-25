core:module("CoreGameStateInEditorStartSimulation")
core:import("CoreGameStateInGame")
core:import("CoreGameStateLoadingGame")

StartSimulation = StartSimulation or class(CoreGameStateLoadingGame.LoadingGame)

-- Lines 7-9
function StartSimulation:transition()
	return CoregameStateInEditorSimulation.Simulation
end
