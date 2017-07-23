core:module("CoreLinkedStackMap")

LinkedStackMap = LinkedStackMap or class()

-- Lines: 6 to 11
function LinkedStackMap:init()
	self._linked_map = {}
	self._top_link = nil
	self._bottom_link = nil
	self._last_link_id = 0
end

-- Lines: 13 to 14
function LinkedStackMap:top_link()
	return self._top_link
end

-- Lines: 17 to 18
function LinkedStackMap:top()
	return self._top_link and self._top_link.value
end

-- Lines: 21 to 22
function LinkedStackMap:get_linked_map()
	return self._linked_map
end

-- Lines: 25 to 26
function LinkedStackMap:get(link_id)
	return self._linked_map[link_id]
end

-- Lines: 32 to 34
function LinkedStackMap:iterator()

	-- Lines: 30 to 32
	local function func(map, key)
		local id, link = next(map, key)

		return id, link and link.value
	end

	return func, self._linked_map, nil
end

-- Lines: 51 to 53
function LinkedStackMap:top_bottom_iterator()

	-- Lines: 38 to 52
	local function func(map, link_id)
		if link_id then
			local link = map[link_id].previous

			if link then
				return link.id, link.value
			else
				return nil, nil
			end
		elseif self._top_link then
			return self._top_link.id, self._top_link.value
		else
			return nil, nil
		end
	end

	return func, self._linked_map, nil
end

-- Lines: 70 to 72
function LinkedStackMap:bottom_top_iterator()

	-- Lines: 57 to 71
	local function func(map, link_id)
		if link_id then
			local link = map[link_id].next

			if link then
				return link.id, link.value
			else
				return nil, nil
			end
		elseif self._bottom_link then
			return self._bottom_link.id, self._bottom_link.value
		else
			return nil, nil
		end
	end

	return func, self._linked_map, nil
end

-- Lines: 75 to 91
function LinkedStackMap:add(value)
	self._last_link_id = self._last_link_id + 1
	local link = {
		value = value,
		id = self._last_link_id
	}
	self._linked_map[self._last_link_id] = link

	if self._top_link then
		self._top_link.next = link
		link.previous = self._top_link
	else
		self._bottom_link = link
	end

	self._top_link = link

	return self._last_link_id
end

-- Lines: 94 to 119
function LinkedStackMap:remove(link_id)
	local link = self._linked_map[link_id]

	if link then
		local previous_link = link.previous
		local next_link = link.next

		if previous_link then
			previous_link.next = next_link
		end

		if next_link then
			next_link.previous = previous_link
		end

		if self._top_link == link then
			self._top_link = previous_link
		end

		if self._bottom_link == link then
			self._bottom_link = next_link
		end

		self._linked_map[link_id] = nil
	end
end

-- Lines: 121 to 135
function LinkedStackMap:to_string()
	local string = ""
	local link = self._top_link

	while link do
		string = string == "" and tostring(link.value) or string .. ", " .. tostring(link.value)
		link = link.previous
	end

	return string
end

