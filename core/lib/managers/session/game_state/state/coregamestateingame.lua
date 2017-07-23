core:module("CoreGameStateInGame")
core:import("CoreGameStatePrepareLoadingFrontEnd")

InGame = InGame or class()

-- Lines: 6 to 10
function InGame:init(level_handler)
	self._level_handler = level_handler
	self.game_state._is_in_game = true

	EventManager:trigger_event(Idstring("game_state_ingame"), nil)
end

-- Lines: 12 to 14
function InGame:destroy()
	self.game_state._is_in_game = nil
end

-- Lines: 16 to 24
function InGame:transition()
	if not self.game_state._front_end_requester:is_requested() then
		return
	end

	if self.game_state._session_manager:_main_systems_are_stable_for_loading() then
		return CoreGameStatePrepareLoadingFrontEnd.PrepareLoadingFrontEnd, self._level_handler
	end
end

-- Lines: 26 to 28
function InGame:end_update(t, dt)
	self._level_handler:end_update(t, dt)
end

