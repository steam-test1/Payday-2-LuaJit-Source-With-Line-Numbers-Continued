core:module("CoreGameStateInit")
core:import("CoreGameStateInEditor")
core:import("CoreGameStatePreFrontEnd")

Init = Init or class()

-- Lines 7-9
function Init:init()
	self.game_state._is_in_init = true
end

-- Lines 11-13
function Init:destroy()
	self.game_state._is_in_init = false
end

-- Lines 15-21
function Init:transition()
	if Application:editor() then
		return CoreGameStateInEditor.InEditor
	else
		return CoreGameStatePreFrontEnd.PreFrontEnd
	end
end
