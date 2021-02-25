ListenerHolder = ListenerHolder or class()

-- Lines 5-11
function ListenerHolder:add(key, clbk)
	if self._calling then
		self:_set_new(key, clbk)
	else
		self:_add(key, clbk)
	end
end

-- Lines 16-22
function ListenerHolder:remove(key)
	if self._calling then
		self:_set_trash(key)
	else
		self:_remove(key)
	end
end

-- Lines 26-43
function ListenerHolder:call(...)
	if self._listeners then
		self._calling = true

		for key, clbk in pairs(self._listeners) do
			if self:_not_trash(key) then
				clbk(...)
			end
		end

		self._calling = nil

		self:_append_new_additions()
		self:_dispose_trash()
	end
end

-- Lines 47-52
function ListenerHolder:_remove(key)
	self._listeners[key] = nil

	if not next(self._listeners) then
		self._listeners = nil
	end
end

-- Lines 56-59
function ListenerHolder:_add(key, clbk)
	self._listeners = self._listeners or {}
	self._listeners[key] = clbk
end

-- Lines 63-69
function ListenerHolder:_set_trash(key)
	self._trash = self._trash or {}
	self._trash[key] = true

	if self._additions then
		self._additions[key] = nil
	end
end

-- Lines 73-79
function ListenerHolder:_set_new(key, clbk)
	self._additions = self._additions or {}
	self._additions[key] = clbk

	if self._trash then
		self._trash[key] = nil
	end
end

-- Lines 83-90
function ListenerHolder:_append_new_additions()
	if self._additions then
		for key, clbk in pairs(self._additions) do
			self:_add(key, clbk)
		end

		self._additions = nil
	end
end

-- Lines 94-101
function ListenerHolder:_dispose_trash()
	if self._trash then
		for key, _ in pairs(self._trash) do
			self:_remove(key)
		end

		self._trash = nil
	end
end

-- Lines 105-107
function ListenerHolder:_not_trash(key)
	return not self._trash or not self._trash[key]
end

-- Lines 111-113
function ListenerHolder:is_empty()
	return not self._listeners
end
