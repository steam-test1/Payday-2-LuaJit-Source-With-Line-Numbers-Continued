core:module("CorePlayerSlotStateLocalUserDebugBind")
core:import("CorePlayerSlotStateLocalUserBound")

LocalUserDebugBind = UserDebugBind or class()

-- Lines: 6 to 8
function LocalUserDebugBind:init()
	self.player_slot._local_user_manager:debug_bind_primary_input_provider_id(self.player_slot)
end

-- Lines: 10 to 11
function LocalUserDebugBind:transition()
	return CorePlayerSlotStateLocalUserBound.LocalUserBound, self.player_slot:assigned_user()
end

return
