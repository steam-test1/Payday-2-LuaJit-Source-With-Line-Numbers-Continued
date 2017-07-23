core:module("CoreGameStateInEditorStartSimulation")
core:import("CoreGameStateInGame")
core:import("CoreGameStateLoadingGame")

StartSimulation = StartSimulation or class(CoreGameStateLoadingGame.LoadingGame)

-- Lines: 7 to 8
function StartSimulation:transition()
	return CoregameStateInEditorSimulation.Simulation
end

