core:module("CoreMenuStateFrontEnd")
core:import("CoreMenuStatePrepareLoadingGame")
core:import("CoreMenuStatePreFrontEnd")

FrontEnd = FrontEnd or class()

-- Lines: 7 to 10
function FrontEnd:init()
	local menu_handler = self.menu_state._menu_handler

	menu_handler:front_end()
end

-- Lines: 12 to 20
function FrontEnd:transition()
	local game_state = self.menu_state._game_state

	if game_state:is_preparing_for_loading_game() then
		return CoreMenuStatePrepareLoadingGame.PrepareLoadingGame
	elseif game_state:is_in_pre_front_end() then
		return CoreMenuStatePreFrontEnd.PreFrontEnd
	end
end

