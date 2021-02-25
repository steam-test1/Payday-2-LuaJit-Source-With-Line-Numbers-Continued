require("lib/utils/Messages")

MessageSystem = MessageSystem or class()

-- Lines 8-14
function MessageSystem:init()
	self._listeners = {}
	self._remove_list = {}
	self._add_list = {}
	self._messages = {}
end

-- Lines 16-18
function MessageSystem:register(message, uid, func)
	table.insert(self._add_list, {
		message = message,
		uid = uid,
		func = func
	})
end

-- Lines 20-22
function MessageSystem:unregister(message, uid)
	table.insert(self._remove_list, {
		message = message,
		uid = uid
	})
end

-- Lines 25-28
function MessageSystem:notify(message, uid, ...)
	local arg = {
		...
	}

	table.insert(self._messages, {
		message = message,
		uid = uid,
		arg = arg
	})
end

-- Lines 31-42
function MessageSystem:notify_now(message, uid, ...)
	local arg = {
		...
	}

	if self._listeners[message] then
		if uid and self._listeners[message][uid] then
			self._listeners[message][uid](unpack(arg))
		else
			for key, value in pairs(self._listeners[message]) do
				value(unpack(arg))
			end
		end
	end
end

-- Lines 44-65
function MessageSystem:_notify()
	local messages = table.list_copy(self._messages)
	local count = #self._messages

	for i = 1, count do
		self._messages[i] = nil
	end

	self._messages = nil
	self._messages = {}

	for i, m in ipairs(messages) do
		if self._listeners[m.message] then
			if m.uid then
				self._listeners[m.message][m.uid](unpack(m.arg))
			else
				for key, value in pairs(self._listeners[m.message]) do
					value(unpack(m.arg))
				end
			end
		end
	end
end

-- Lines 67-70
function MessageSystem:flush()
	if #self._remove_list > 0 then
		self:_remove()
	end

	if #self._add_list > 0 then
		self:_add()
	end
end

-- Lines 72-75
function MessageSystem:update()
	self:flush()
	self:_notify()
end

-- Lines 78-88
function MessageSystem:_remove()
	local count = #self._remove_list

	for i = 1, count do
		local data = self._remove_list[i]

		self:_unregister(self._remove_list[i].message, self._remove_list[i].uid)

		self._remove_list[i].message = nil
		self._remove_list[i].uid = nil
	end

	self._remove_list = nil
	self._remove_list = {}
end

-- Lines 90-101
function MessageSystem:_add()
	local count = #self._add_list

	for i = 1, count do
		local data = self._add_list[i]

		self:_register(data.message, data.uid, data.func)

		self._add_list[i].message = nil
		self._add_list[i].uid = nil
		self._add_list[i].func = nil
	end

	self._add_list = nil
	self._add_list = {}
end

-- Lines 103-111
function MessageSystem:_register(message, uid, func)
	if not self._listeners[message] then
		self._listeners[message] = {}
	end

	if not self._listeners[message][uid] then
		self._listeners[message][uid] = func
	end
end

-- Lines 113-117
function MessageSystem:_unregister(message, uid)
	if self._listeners[message] then
		self._listeners[message][uid] = nil
	end
end
