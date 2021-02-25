core:module("CoreGameStateLoadingFrontEnd")
core:import("CoreGameStatePreFrontEnd")

LoadingFrontEnd = LoadingFrontEnd or class()

-- Lines 6-11
function LoadingFrontEnd:init()
	self._debug_time = self.game_state._session_manager:_debug_time()

	for _, unit in ipairs(World:find_units_quick("all")) do
		unit:set_slot(0)
	end
end

-- Lines 13-14
function LoadingFrontEnd:destroy()
end

-- Lines 16-21
function LoadingFrontEnd:transition()
	local current_time = self.game_state._session_manager:_debug_time()

	if current_time > self._debug_time + 2 then
		return CoreGameStatePreFrontEnd.PreFrontEnd
	end
end
