core:module("CoreFreezeState")
core:import("CoreFiniteStateMachine")
core:import("CoreFreezeStateMelted")
core:import("CoreSessionGenericState")

FreezeState = FreezeState or class(CoreSessionGenericState.State)

-- Lines: 8 to 10
function FreezeState:init()
	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreFreezeStateMelted.Melted, "freeze_state", self)
end

-- Lines: 12 to 14
function FreezeState:set_debug(debug_on)
	self._state:set_debug(debug_on)
end

-- Lines: 16 to 18
function FreezeState.default_data(data)
	data.start_state = "CoreFreezeStateMelted.Melted"
end

-- Lines: 20 to 22
function FreezeState:save(data)
	self._state:save(data.start_state)
end

-- Lines: 24 to 26
function FreezeState:transition()
	self._state:transition()
end

return
