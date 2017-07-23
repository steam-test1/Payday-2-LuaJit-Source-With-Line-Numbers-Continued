core:module("CoreGameState")
core:import("CoreFiniteStateMachine")
core:import("CoreGameStateInit")
core:import("CoreSessionGenericState")
core:import("CoreRequester")

GameState = GameState or class(CoreSessionGenericState.State)

-- Lines: 9 to 17
function GameState:init(player_slots, session_manager)
	self._player_slots = player_slots
	self._session_manager = session_manager
	self._game_requester = CoreRequester.Requester:new()
	self._front_end_requester = CoreRequester.Requester:new()

	assert(self._session_manager)

	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreGameStateInit.Init, "game_state", self)
end

-- Lines: 19 to 21
function GameState:set_debug(debug_on)
	self._state:set_debug(debug_on)
end

-- Lines: 23 to 25
function GameState.default_data(data)
	data.start_state = "GameStateInit"
end

-- Lines: 27 to 29
function GameState:save(data)
	self._state:save(data.start_state)
end

-- Lines: 31 to 35
function GameState:update(t, dt)
	if self._state:state().update then
		self._state:update(t, dt)
	end
end

-- Lines: 37 to 41
function GameState:end_update(t, dt)
	if self._state:state().end_update then
		self._state:state():end_update(t, dt)
	end
end

-- Lines: 43 to 45
function GameState:transition()
	self._state:transition()
end

-- Lines: 47 to 48
function GameState:player_slots()
	return self._player_slots
end

-- Lines: 51 to 52
function GameState:is_in_pre_front_end()
	return self._is_in_pre_front_end
end

-- Lines: 55 to 56
function GameState:is_in_front_end()
	return self._is_in_front_end
end

-- Lines: 59 to 60
function GameState:is_in_init()
	return self._is_in_init
end

-- Lines: 63 to 64
function GameState:is_in_editor()
	return self._is_in_editor
end

-- Lines: 67 to 68
function GameState:is_in_game()
	return self._is_in_game
end

-- Lines: 71 to 72
function GameState:is_preparing_for_loading_game()
	return self._is_preparing_for_loading_game
end

-- Lines: 75 to 76
function GameState:is_preparing_for_loading_front_end()
	return self._is_preparing_for_loading_front_end
end

-- Lines: 79 to 80
function GameState:_session_info()
	return self._session_manager:session():session_info()
end

-- Lines: 83 to 85
function GameState:request_game()
	self._game_requester:request()
end

-- Lines: 87 to 89
function GameState:request_front_end()
	self._front_end_requester:request()
end

