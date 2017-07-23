core:module("CoreFreezeStateMelted")

Melted = Melted or class()

-- Lines: 5 to 7
function Melted:init()
	self.freeze_state:_set_stable_for_loading()
end

-- Lines: 9 to 11
function Melted:destroy()
	self.freeze_state:_not_stable_for_loading()
end

-- Lines: 13 to 14
function Melted:transition()
end

