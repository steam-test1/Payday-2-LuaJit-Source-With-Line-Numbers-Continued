core:module("CoreGameStateFrontEnd")
core:import("CoreGameStatePrepareLoadingGame")

FrontEnd = FrontEnd or class()

-- Lines: 6 to 8
function FrontEnd:init()
	self.game_state._is_in_front_end = true
end

-- Lines: 10 to 12
function FrontEnd:destroy()
	self.game_state._is_in_front_end = false
end

-- Lines: 14 to 22
function FrontEnd:transition()
	if not self.game_state._game_requester:is_requested() then
		return
	end

	if self.game_state._session_manager:_main_systems_are_stable_for_loading() then
		return CoreGameStatePrepareLoadingGame.PrepareLoadingGame
	end
end

