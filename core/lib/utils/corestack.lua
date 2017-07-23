core:module("CoreStack")

Stack = Stack or class()

-- Lines: 5 to 7
function Stack:init()
	self:clear()
end

-- Lines: 9 to 12
function Stack:push(value)
	self._last = self._last + 1
	self._table[self._last] = value
end

-- Lines: 14 to 21
function Stack:pop()
	if self:is_empty() then
		error("Stack is empty")
	end

	local value = self._table[self._last]
	self._table[self._last] = nil
	self._last = self._last - 1

	return value
end

-- Lines: 24 to 29
function Stack:top()
	if self:is_empty() then
		error("Stack is empty")
	end

	return self._table[self._last]
end

-- Lines: 32 to 33
function Stack:is_empty()
	return self._last == 0
end

-- Lines: 36 to 37
function Stack:size()
	return self._last
end

-- Lines: 40 to 43
function Stack:clear()
	self._last = 0
	self._table = {}
end

-- Lines: 45 to 46
function Stack:stack_table()
	return self._table
end

