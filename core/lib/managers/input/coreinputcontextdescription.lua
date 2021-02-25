core:module("CoreInputContextDescription")

ContextDescription = ContextDescription or class()

-- Lines 5-11
function ContextDescription:init(name)
	self._input_target_descriptions = {}
	self._layout_descriptions = {}
	self._context_descriptions = {}
	self._name = name

	assert(self._name, "You must specify a name for a context")
end

-- Lines 13-15
function ContextDescription:add_input_target_description(input_target_description)
	self._input_target_descriptions[input_target_description:target_name()] = input_target_description
end

-- Lines 17-19
function ContextDescription:add_layout_description(input_layout_description)
	self._layout_descriptions[input_layout_description:layout_name()] = input_layout_description
end

-- Lines 21-23
function ContextDescription:add_context_description(context_description)
	self._context_descriptions[context_description:context_description_name()] = context_description
end

-- Lines 25-34
function ContextDescription:device_layout_description(device_type, layout_name)
	layout_name = layout_name or "default"
	local layout_description = self._layout_descriptions[layout_name]

	if layout_description == nil then
		return
	end

	return layout_description:device_layout_description(device_type)
end

-- Lines 36-38
function ContextDescription:context_description_name()
	return self._name
end

-- Lines 40-42
function ContextDescription:context_description(context_name)
	return self._context_descriptions[context_name]
end

-- Lines 44-46
function ContextDescription:context_descriptions()
	return self._context_descriptions
end

-- Lines 48-50
function ContextDescription:input_targets()
	return self._input_target_descriptions
end

-- Lines 52-56
function ContextDescription:input_target_description(target_name)
	local input_target = self._input_target_descriptions[target_name]

	assert(input_target ~= nil, "Input Target with name '" .. target_name .. "' can not be found in context '" .. self._name .. "'")

	return input_target
end
