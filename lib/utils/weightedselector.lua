WeightedSelector = WeightedSelector or class()

-- Lines 7-9
function WeightedSelector:init()
	self:clear()
end

-- Lines 11-14
function WeightedSelector:add(value, weight)
	table.insert(self._values, {
		value = value,
		weight = weight
	})

	self._total_weight = self._total_weight + weight
end

-- Lines 16-28
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

-- Lines 30-33
function WeightedSelector:clear()
	self._values = {}
	self._total_weight = 0
end
