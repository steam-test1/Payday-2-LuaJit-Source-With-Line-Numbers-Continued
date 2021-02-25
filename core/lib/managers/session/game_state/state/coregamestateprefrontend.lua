core:module("CoreGameStatePreFrontEnd")
core:import("CoreGameStateFrontEnd")

PreFrontEnd = PreFrontEnd or class()

-- Lines 6-10
function PreFrontEnd:init()
	local player_slot = self.game_state:player_slots():primary_slot()

	player_slot:_release_user_from_slot()

	self.game_state._is_in_pre_front_end = true
end

-- Lines 12-14
function PreFrontEnd:destroy()
	self.game_state._is_in_pre_front_end = false
end

-- Lines 16-25
function PreFrontEnd:transition()
	if not self.game_state:player_slots():has_primary_local_user() then
		return
	end

	local local_user = self.game_state:player_slots():primary_local_user()

	if local_user:profile_data_is_loaded() then
		return CoreGameStateFrontEnd.FrontEnd
	end
end
