core:module("CoreInputContextStack")
core:import("CoreStack")

Stack = Stack or class()

-- Lines: 6 to 9
function Stack:init(device_type)
	self._device_type = device_type
	self._active_input_context = CoreStack.Stack:new()
end

-- Lines: 11 to 13
function Stack:destroy()
	self._active_input_context:destroy()
end

-- Lines: 15 to 17
function Stack:active_device_layout()
	local target_context = self._active_input_context:top()

	return target_context:device_layout(self._device_type)
end

-- Lines: 20 to 25
function Stack:active_context()
	if self._active_input_context:is_empty() then
		return
	end

	return self._active_input_context:top()
end

-- Lines: 28 to 31
function Stack:pop_input_context(input_context)
	assert(self._active_input_context:top() == input_context)
	self._active_input_context:pop()
end

-- Lines: 33 to 35
function Stack:push_input_context(input_context)
	self._active_input_context:push(input_context)
end

