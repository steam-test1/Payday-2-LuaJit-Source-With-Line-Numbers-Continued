core:module("CoreInputContext")

Context = Context or class()

-- Lines 5-15
function Context:init(input_context_description, input_context_stack)
	self._input_data = {}

	self:_construct_input_data(input_context_description)

	self._input_context_description = input_context_description
	self._input_context_stack = input_context_stack

	assert(self._input_context_stack)
	self._input_context_stack:push_input_context(self)
end

-- Lines 17-20
function Context:destroy()
	self._input_context_stack:pop_input_context(self)

	self._input_source = nil
end

-- Lines 22-28
function Context:create_context(context_name)
	local context_description = self._input_context_description:context_description(context_name)

	assert(context_description, "Couldn't find subcontext with name:'" .. context_name .. "'")

	local context = Context:new(context_description, self._input_context_stack)

	return context
end

-- Lines 30-32
function Context:input()
	return self._input_data
end

-- Lines 34-36
function Context:_context_description()
	return self._input_context_description
end

-- Lines 38-49
function Context:_construct_input_data(input_context_description)
	for name, input_target in pairs(input_context_description:input_targets()) do
		local type_name = input_target:target_type_name()

		if type_name == "vector" then
			self._input_data[name] = Vector3(0, 0, 0)
		elseif type_name == "bool" then
			self._input_data[name] = false
		else
			assert(false, "unknown type:'" .. type_name .. "'")
		end
	end
end
