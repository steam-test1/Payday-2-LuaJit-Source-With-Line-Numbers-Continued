core:module("CoreSessionResponse")

Done = Done or class()
Done.DONE = 1

-- Lines: 7 to 9
function Done:done()
	self:_set_response(Done.DONE)
end

-- Lines: 11 to 13
function Done:_is_response_value(value)
	assert(not self._is_destroyed, "You can not check a destroyed response object!")

	return self._response == value
end

-- Lines: 16 to 17
function Done:is_done()
	return self:_is_response_value(Done.DONE)
end

-- Lines: 20 to 24
function Done:_set_response(value)
	assert(not self._is_destroyed, "You can not respond to a destroyed response object!")
	assert(self._response == nil, "Response has already been set!")

	self._response = value
end

-- Lines: 26 to 28
function Done:destroy()
	self._is_destroyed = true
end
DoneOrFinished = DoneOrFinished or class(Done)
DoneOrFinished.FINISHED = 2

-- Lines: 35 to 37
function DoneOrFinished:finished()
	self:_set_response(DoneOrFinished.FINISHED)
end

-- Lines: 39 to 40
function DoneOrFinished:is_finished()
	return self:_is_response_value(DoneOrFinished.FINISHED)
end

return
