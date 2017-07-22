core:module("CoreRequester")

Requester = Requester or class()

-- Lines: 5 to 7
function Requester:request()
	self._requested = true
end

-- Lines: 9 to 11
function Requester:cancel_request()
	self._requested = nil
end

-- Lines: 13 to 14
function Requester:is_requested()
	return self._requested == true
end

-- Lines: 17 to 19
function Requester:task_started()
	self._task_is_running = true
end

-- Lines: 21 to 25
function Requester:task_completed()
	assert(self._task_is_running ~= nil, "The task can not be completed, since it hasn't started")

	self._task_is_running = nil
	self._requested = nil
end

-- Lines: 27 to 28
function Requester:is_task_running()
	return self._task_is_running
end

-- Lines: 31 to 34
function Requester:force_task_completed()
	self._task_is_running = nil
	self._requested = nil
end

return
