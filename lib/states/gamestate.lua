core:import("CoreInternalGameState")

GameState = GameState or class(CoreInternalGameState.GameState)

-- Lines: 5 to 9
function GameState:freeflight_drop_player(pos, rot, velocity)
	if managers.player then
		managers.player:warp_to(pos, rot, nil, velocity)
	end
end

-- Lines: 10 to 11
function GameState:set_controller_enabled(enabled)
end

-- Lines: 13 to 23
function GameState:default_transition(next_state, params)
	self:at_exit(next_state, params)
	self:set_controller_enabled(false)

	if self:gsm():is_controller_enabled() then
		next_state:set_controller_enabled(true)
	end

	next_state:at_enter(self, params)
end

-- Lines: 25 to 27
function GameState:on_disconnected()
	game_state_machine:change_state_by_name("disconnected")
end

-- Lines: 29 to 31
function GameState:on_server_left()
	game_state_machine:change_state_by_name("server_left")
end

CoreClass.override_class(CoreInternalGameState.GameState, GameState)

return
