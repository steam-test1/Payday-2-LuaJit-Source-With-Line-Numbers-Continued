core:module("CoreSessionGenericState")

State = State or class()

-- Lines 5-6
function State:init()
end

-- Lines 8-10
function State:_set_stable_for_loading()
	self._is_stable_for_loading = true
end

-- Lines 12-14
function State:_not_stable_for_loading()
	self._is_stable_for_loading = nil
end

-- Lines 16-18
function State:is_stable_for_loading()
	return self._is_stable_for_loading ~= nil
end

-- Lines 20-22
function State:transition()
	assert(false, "you must override transition()")
end
