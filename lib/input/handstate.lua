HandState = HandState or class()

-- Lines: 6 to 8
function HandState:init(level)
	self._level = level or 0
end

-- Lines: 10 to 11
function HandState:level()
	return self._level
end

-- Lines: 14 to 24
function HandState:connnection_names()
	local names = {}

	if not self._connections then
		return names
	end

	for name, _ in pairs(self._connections) do
		table.insert(names, name)
	end

	return names
end

-- Lines: 27 to 40
function HandState:apply(hand, key_map)
	if not self._connections then
		return
	end

	local hand_name = hand == 1 and "r" or "l"

	for connection_name, connection_data in pairs(self._connections) do
		if connection_data.hand == hand or not connection_data.hand then
			for _, input in ipairs(connection_data.inputs) do
				key_map[input .. hand_name] = connection_name
			end
		end
	end
end

