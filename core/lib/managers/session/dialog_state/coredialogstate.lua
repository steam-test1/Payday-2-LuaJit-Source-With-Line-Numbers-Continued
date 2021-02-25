core:module("CoreDialogState")
core:import("CoreFiniteStateMachine")
core:import("CoreDialogStateNone")
core:import("CoreSessionGenericState")

DialogState = DialogState or class(CoreSessionGenericState.State)

-- Lines 8-10
function DialogState:init()
	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreDialogStateNone.None, "dialog_state", self)
end

-- Lines 12-14
function DialogState:set_debug(debug_on)
	self._state:set_debug(debug_on)
end

-- Lines 16-18
function DialogState.default_data(data)
	data.start_state = "CoreFreezeStateMelted.Melted"
end

-- Lines 20-22
function DialogState:save(data)
	self._state:save(data.start_state)
end

-- Lines 24-26
function DialogState:transition()
	self._state:transition()
end
