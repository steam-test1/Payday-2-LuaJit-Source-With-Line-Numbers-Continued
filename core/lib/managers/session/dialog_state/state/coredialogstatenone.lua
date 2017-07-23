core:module("CoreDialogStateNone")

None = None or class()

-- Lines: 5 to 7
function None:init()
	self.dialog_state:_set_stable_for_loading()
end

-- Lines: 9 to 11
function None:destroy()
	self.dialog_state._not_stable_for_loading()
end

-- Lines: 13 to 14
function None:transition()
end

