core:module("CoreFiniteStateMachine")
core:import("CoreDebug")

FiniteStateMachine = FiniteStateMachine or class()

-- Lines: 6 to 14
function FiniteStateMachine:init(state_class, object_name, object)
	self._object = object
	self._object_name = object_name

	if state_class then
		self:_set_state(state_class)
	end

	self._debug = true
end

-- Lines: 16 to 19
function FiniteStateMachine:load(data)
	local class = _G[data.class_name]

	self._set_state(class)
end

-- Lines: 21 to 23
function FiniteStateMachine:save(data)
	data.class_name = class_name(self._state_class)
end

-- Lines: 25 to 27
function FiniteStateMachine:set_debug(debug_enabled)
	self._debug = debug_enabled
end

-- Lines: 29 to 31
function FiniteStateMachine:destroy()
	self:_destroy_current_state()
end

-- Lines: 33 to 41
function FiniteStateMachine:transition()
	assert(self._state)
	assert(self._state.transition, "You must at least have a transition method")

	local new_state_class, arg = self._state:transition()

	if new_state_class then
		self:_set_state(new_state_class, arg)
	end
end

-- Lines: 43 to 45
function FiniteStateMachine:state()
	assert(self._state)

	return self._state
end

-- Lines: 48 to 49
function FiniteStateMachine:_class_name(state_class)
	return CoreDebug.full_class_name(state_class)
end

-- Lines: 52 to 57
function FiniteStateMachine:_destroy_current_state()
	if self._state and self._state.destroy then
		self._state:destroy()

		self._state = nil
	end
end

-- Lines: 59 to 81
function FiniteStateMachine:_set_state(new_state_class, ...)
	if self._debug then
		cat_print("debug", "transitions from '" .. self:_class_name(self._state_class) .. "' to '" .. self:_class_name(new_state_class) .. "'")
	end

	self:_destroy_current_state()

	local init_function = new_state_class.init

	-- Lines: 68 to 69
function 	new_state_class.init()
	end
	self._state = new_state_class:new()

	assert(self._state ~= nil)

	new_state_class.init = init_function
	self._state[self._object_name] = self._object
	self._state_class = new_state_class

	if init_function then
		self._state:init(...)
	end
end

return
