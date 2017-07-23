core:module("CoreGameStateLoadingFrontEnd")
core:import("CoreGameStatePreFrontEnd")

LoadingFrontEnd = LoadingFrontEnd or class()

-- Lines: 6 to 11
function LoadingFrontEnd:init()
	self._debug_time = self.game_state._session_manager:_debug_time()

	for _, unit in ipairs(World:find_units_quick("all")) do
		unit:set_slot(0)
	end
end

-- Lines: 13 to 14
function LoadingFrontEnd:destroy()
end

-- Lines: 16 to 21
function LoadingFrontEnd:transition()
	local current_time = self.game_state._session_manager:_debug_time()

	if self._debug_time + 2 < current_time then
		return CoreGameStatePreFrontEnd.PreFrontEnd
	end
end

