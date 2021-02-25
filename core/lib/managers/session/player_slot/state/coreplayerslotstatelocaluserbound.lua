core:module("CorePlayerSlotStateLocalUserBound")
core:import("CorePlayerSlotStateInit")

LocalUserBound = LocalUserBound or class()

-- Lines 6-8
function LocalUserBound:init(local_user)
	self._local_user = local_user
end

-- Lines 10-11
function LocalUserBound:destroy()
end

-- Lines 13-17
function LocalUserBound:transition()
	if self.player_slot._init:is_requested() then
		return CorePlayerSlotStateInit.Init
	end
end
