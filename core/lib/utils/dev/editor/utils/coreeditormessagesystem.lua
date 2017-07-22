require("core/lib/utils/dev/editor/utils/CoreEditorMessages")

EditorMessageSystem = EditorMessageSystem or class()

-- Lines: 5 to 12
function EditorMessageSystem:init()
	self._listeners = {}
	self._remove_list = {}
	self._add_list = {}
	self._messages = {}
	self._uid = 1000
end

-- Lines: 14 to 20
function EditorMessageSystem:register(message, uid, func)
	if not uid then
		uid = self._uid
		self._uid = self._uid + 1
	end

	table.insert(self._add_list, {
		message = message,
		uid = uid,
		func = func
	})

	return uid
end

-- Lines: 23 to 25
function EditorMessageSystem:unregister(message, uid)
	table.insert(self._remove_list, {
		message = message,
		uid = uid
	})
end

-- Lines: 28 to 31
function EditorMessageSystem:notify(message, uid, ...)
	local arg = {...}

	table.insert(self._messages, {
		message = message,
		uid = uid,
		arg = arg
	})
end

-- Lines: 34 to 45
function EditorMessageSystem:notify_now(message, uid, ...)
	local arg = {...}

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

-- Lines: 47 to 68
function EditorMessageSystem:_notify()
	local messages = deep_clone(self._messages)
	local count = #self._messages

	for i = 1, count, 1 do
		self._messages[i] = nil
	end

	self._messages = nil
	self._messages = {}

	for i = 1, count, 1 do
		if self._listeners[messages[i].message] then
			if messages[i].uid then
				self._listeners[messages[i].message][messages[i].uid](unpack(messages[i].arg))
			else
				for key, value in pairs(self._listeners[messages[i].message]) do
					value(unpack(messages[i].arg))
				end
			end
		end
	end
end

-- Lines: 70 to 73
function EditorMessageSystem:flush()
	if #self._remove_list > 0 then
		self:_remove()
	end

	if #self._add_list > 0 then
		self:_add()
	end
end

-- Lines: 75 to 78
function EditorMessageSystem:update()
	self:flush()
	self:_notify()
end

-- Lines: 81 to 91
function EditorMessageSystem:_remove()
	local count = #self._remove_list

	for i = 1, count, 1 do
		local data = self._remove_list[i]

		self:_unregister(self._remove_list[i].message, self._remove_list[i].uid)

		self._remove_list[i].message = nil
		self._remove_list[i].uid = nil
	end

	self._remove_list = nil
	self._remove_list = {}
end

-- Lines: 93 to 104
function EditorMessageSystem:_add()
	local count = #self._add_list

	for i = 1, count, 1 do
		local data = self._add_list[i]

		self:_register(data.message, data.uid, data.func)

		self._add_list[i].message = nil
		self._add_list[i].uid = nil
		self._add_list[i].func = nil
	end

	self._add_list = nil
	self._add_list = {}
end

-- Lines: 106 to 114
function EditorMessageSystem:_register(message, uid, func)
	if not self._listeners[message] then
		self._listeners[message] = {}
	end

	if not self._listeners[message][uid] then
		self._listeners[message][uid] = func
	end
end

-- Lines: 116 to 120
function EditorMessageSystem:_unregister(message, uid)
	if self._listeners[message] then
		self._listeners[message][uid] = nil
	end
end

return
