core:module("CoreFreezeStateMelted")

Melted = Melted or class()

-- Lines 5-7
function Melted:init()
	self.freeze_state:_set_stable_for_loading()
end

-- Lines 9-11
function Melted:destroy()
	self.freeze_state:_not_stable_for_loading()
end

-- Lines 13-14
function Melted:transition()
end
