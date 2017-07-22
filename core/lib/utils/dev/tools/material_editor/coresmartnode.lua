CoreSmartNode = CoreSmartNode or class()

-- Lines: 3 to 20
function CoreSmartNode:init(node)
	self._parameters = {}
	self._children = {}

	if type(node) == "string" then
		self._name = node
	else
		self._name = node:name()

		for k, v in pairs(node:parameters()) do
			self._parameters[k] = v
		end

		for child in node:children() do
			table.insert(self._children, CoreSmartNode:new(child))
		end
	end
end

-- Lines: 22 to 31
function CoreSmartNode:children()
	local count = table.getn(self._children)
	local i = 0

	return function ()
		i = i + 1

		if i <= count then
			return self._children[i]
		end
	end
end

-- Lines: 34 to 35
function CoreSmartNode:parameters()
	return self._parameters
end

-- Lines: 38 to 39
function CoreSmartNode:name()
	return self._name
end

-- Lines: 42 to 43
function CoreSmartNode:num_children()
	return #self._children
end

-- Lines: 46 to 47
function CoreSmartNode:parameter(k)
	return self._parameters[k]
end

-- Lines: 50 to 52
function CoreSmartNode:set_parameter(k, v)
	self._parameters[k] = v
end

-- Lines: 54 to 56
function CoreSmartNode:clear_parameter(k)
	self._parameters[k] = nil
end

-- Lines: 58 to 61
function CoreSmartNode:make_child(name)
	local node = CoreSmartNode:new(name)

	table.insert(self._children, node)

	return node
end

-- Lines: 64 to 67
function CoreSmartNode:add_child(n)
	local node = CoreSmartNode:new(n)

	table.insert(self._children, node)

	return node
end

-- Lines: 70 to 78
function CoreSmartNode:index_of_child(c)
	local i = 0

	for child in self:children() do
		if child == c then
			return i
		end

		i = i + 1
	end

	return -1
end

-- Lines: 81 to 85
function CoreSmartNode:remove_child_at(index)
	local i = index + 1
	self._children[i] = self._children[#self._children]
	self._children[#self._children] = nil
end

-- Lines: 87 to 96
function CoreSmartNode:to_real_node()
	local node = Node(self._name)

	for k, v in pairs(self:parameters()) do
		node:set_parameter(k, v)
	end

	for child in self:children() do
		node:add_child(child:to_real_node())
	end

	return node
end

-- Lines: 99 to 100
function CoreSmartNode:to_xml()
	return self:to_real_node():to_xml()
end

return
