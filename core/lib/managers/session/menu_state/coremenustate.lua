core:module("CoreMenuState")
core:import("CoreSessionGenericState")
core:import("CoreFiniteStateMachine")
core:import("CoreMenuStateNone")

MenuState = MenuState or class(CoreSessionGenericState.State)

-- Lines 8-14
function MenuState:init(game_state, menu_handler, player_slots)
	self._game_state = game_state

	assert(self._game_state)

	self._menu_handler = menu_handler
	self._player_slots = player_slots
	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreMenuStateNone.None, "menu_state", self)
end

-- Lines 16-18
function MenuState:set_debug(debug_on)
	self._state:set_debug(debug_on)
end

-- Lines 20-22
function MenuState.default_data(data)
	data.start_state = "CoreMenuStateNone.None"
end

-- Lines 24-26
function MenuState:save(data)
	self._state:save(data.start_state)
end

-- Lines 28-30
function MenuState:transition()
	self._state:transition()
end

-- Lines 32-34
function MenuState:game_state()
	return self._game_state
end
