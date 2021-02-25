core:module("CoreMenuItemOption")

ItemOption = ItemOption or class()

-- Lines 6-18
function ItemOption:init(data_node, parameters)
	local params = parameters or {}

	if data_node then
		for key, value in pairs(data_node) do
			if key ~= "_meta" and type(value) ~= "table" then
				params[key] = value
			end
		end
	end

	self:set_parameters(params)
end

-- Lines 20-22
function ItemOption:value()
	return self._parameters.value
end

-- Lines 24-26
function ItemOption:get_parameter(name)
	return self._parameters[name]
end

-- Lines 28-30
function ItemOption:parameters()
	return self._parameters
end

-- Lines 32-34
function ItemOption:set_parameters(parameters)
	self._parameters = parameters
end
