require("lib/states/GameState")

WorldCameraState = WorldCameraState or class(GameState)

-- Lines: 5 to 7
function WorldCameraState:init(game_state_machine)
	GameState.init(self, "world_camera", game_state_machine)
end

-- Lines: 9 to 10
function WorldCameraState:at_enter()
end

-- Lines: 12 to 13
function WorldCameraState:at_exit()
end

return
