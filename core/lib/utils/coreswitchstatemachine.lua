core:module("CoreSwitchStateMachine")
core:import("CoreFiniteStateMachine")

SwitchStateMachine = SwitchStateMachine or class(CoreFiniteStateMachine.FiniteStateMachine)

-- Lines 6-10
function SwitchStateMachine:init(object_name, object)
	assert(object_name ~= nil)

	self._object_name = object_name
	self._object = object
end

-- Lines 12-14
function SwitchStateMachine:clear()
	self:_destroy_current_state()
end

-- Lines 16-23
function SwitchStateMachine:switch_state(state_class, ...)
	assert(state_class, "You must specify a valid state class to switch to")

	if self._state_class == state_class then
		return
	end

	self:_set_state(state_class, ...)
end
