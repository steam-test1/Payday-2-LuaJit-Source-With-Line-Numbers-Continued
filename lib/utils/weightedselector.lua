WeightedSelector = WeightedSelector or class()

-- Lines: 7 to 9
function WeightedSelector:init()
	self:clear()
end

-- Lines: 11 to 14
function WeightedSelector:add(value, weight)
	table.insert(self._values, {
		value = value,
		weight = weight
	})

	self._total_weight = self._total_weight + weight
end

-- Lines: 17 to 26
function WeightedSelector:select()
	local rand = math.random() * self._total_weight

	for idx, item in ipairs(self._values) do
		if rand < item.weight then
			return item.value
		end

		rand = rand - item.weight
	end

	return nil
end

-- Lines: 30 to 33
function WeightedSelector:clear()
	self._values = {}
	self._total_weight = 0
end

return
