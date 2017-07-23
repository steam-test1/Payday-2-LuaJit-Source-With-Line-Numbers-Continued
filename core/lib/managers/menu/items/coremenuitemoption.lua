core:module("CoreMenuItemOption")

ItemOption = ItemOption or class()

-- Lines: 7 to 18
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

-- Lines: 20 to 21
function ItemOption:value()
	return self._parameters.value
end

-- Lines: 24 to 25
function ItemOption:parameters()
	return self._parameters
end

-- Lines: 28 to 30
function ItemOption:set_parameters(parameters)
	self._parameters = parameters
end

