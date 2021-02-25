core:module("CoreInputLayer")
core:import("CoreInputContextStack")
core:import("CoreInputProvider")
core:import("CoreInputContext")

Layer = Layer or class()

-- Lines 8-12
function Layer:init(input_provider, layer_description)
	self._input_context_stack = CoreInputContextStack.Stack:new()
	self._layer_description = layer_description
	self._input_provider = input_provider
end

-- Lines 14-17
function Layer:destroy()
	self._input_context_stack:destroy()
	self._input_provider:_layer_destroyed(self)
end

-- Lines 19-21
function Layer:context()
	return self._input_context_stack:active_context()
end

-- Lines 23-25
function Layer:layer_description()
	return self._layer_description
end

-- Lines 27-30
function Layer:create_context()
	local context_description = self._layer_description:context_description()

	return CoreInputContext.Context:new(context_description, self._input_context_stack)
end
