core:module("CoreInternalGameState")

GameState = GameState or class()

-- Lines: 11 to 14
function GameState:init(name, game_state_machine)
	self._name = name
	self._gsm = game_state_machine
end

-- Lines: 16 to 17
function GameState:destroy()
end

-- Lines: 19 to 20
function GameState:name()
	return self._name
end

-- Lines: 23 to 24
function GameState:gsm()
	return self._gsm
end

-- Lines: 32 to 33
function GameState:at_enter(previous_state)
end

-- Lines: 35 to 36
function GameState:at_exit(next_state)
end

-- Lines: 38 to 41
function GameState:default_transition(next_state)
	self:at_exit(next_state)
	next_state:at_enter(self)
end

-- Lines: 49 to 51
function GameState:force_editor_state()
	self._gsm:change_state_by_name("editor")
end

-- Lines: 54 to 55
function GameState:allow_world_camera_sequence()
	return false
end

-- Lines: 59 to 61
function GameState:play_world_camera_sequence(name, sequence)
	error("NotImplemented")
end

-- Lines: 69 to 70
function GameState:allow_freeflight()
	return true
end

-- Lines: 74 to 76
function GameState:freeflight_drop_player(pos, rot, velocity)
	Application:error("[FreeFlight] Drop player not implemented for state '" .. self:name() .. "'")
end

return
