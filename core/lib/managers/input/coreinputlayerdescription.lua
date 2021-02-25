core:module("CoreInputLayerDescription")

LayerDescription = LayerDescription or class()

-- Lines 5-8
function LayerDescription:init(name, priority)
	self._name = name
	self._priority = priority
end

-- Lines 10-12
function LayerDescription:layer_description_name()
	return self._name
end

-- Lines 14-17
function LayerDescription:set_context_description(context_description)
	assert(self._context_description == nil)

	self._context_description = context_description
end

-- Lines 19-22
function LayerDescription:context_description()
	assert(self._context_description, "Must specify context for this layer_description")

	return self._context_description
end

-- Lines 24-26
function LayerDescription:priority()
	return self._priority
end
