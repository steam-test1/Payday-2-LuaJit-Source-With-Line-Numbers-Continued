if core then
	core:module("CoreEvent")
	core:import("CoreDebug")
end

-- Lines: 18 to 41
function callback(o, base_callback_class, base_callback_func_name, base_callback_param)
	if base_callback_class and base_callback_func_name and base_callback_class[base_callback_func_name] then
		if base_callback_param ~= nil then
			if o then
				return function (...)
					return base_callback_class[base_callback_func_name](o, base_callback_param, ...)
				end
			else
				return function (...)
					return base_callback_class[base_callback_func_name](base_callback_param, ...)
				end
			end
		elseif o then
			return function (...)
				return base_callback_class[base_callback_func_name](o, ...)
			end
		else
			return function (...)
				return base_callback_class[base_callback_func_name](...)
			end
		end
	elseif base_callback_class then
		local class_name = base_callback_class and CoreDebug.class_name(getmetatable(base_callback_class) or base_callback_class)

		error("Callback on class \"" .. tostring(class_name) .. "\" refers to a non-existing function \"" .. tostring(base_callback_func_name) .. "\".")
	elseif base_callback_func_name then
		error("Callback to function \"" .. tostring(base_callback_func_name) .. "\" is on a nil class.")
	else
		error("Callback class and function was nil.")
	end
end

local tc = 0

-- Lines: 49 to 50
function get_ticket(delay)
	return {
		delay,
		math.random(delay - 1)
	}
end

-- Lines: 53 to 54
function valid_ticket(ticket)
	return tc % ticket[1] == ticket[2]
end

-- Lines: 57 to 62
function update_tickets()
	tc = tc + 1

	if tc > 30 then
		tc = 0
	end
end

BasicEventHandling = {}

-- Lines: 73 to 78
function BasicEventHandling:connect(event_name, callback_func, data)
	self._event_callbacks = self._event_callbacks or {}
	self._event_callbacks[event_name] = self._event_callbacks[event_name] or {}

	
	-- Lines: 75 to 76
	local function wrapped_func(...)
		callback_func(data, ...)
	end

	table.insert(self._event_callbacks[event_name], wrapped_func)

	return wrapped_func
end

-- Lines: 81 to 91
function BasicEventHandling:disconnect(event_name, wrapped_func)
	if self._event_callbacks and self._event_callbacks[event_name] then
		table.delete(self._event_callbacks[event_name], wrapped_func)

		if table.empty(self._event_callbacks[event_name]) then
			self._event_callbacks[event_name] = nil

			if table.empty(self._event_callbacks) then
				self._event_callbacks = nil
			end
		end
	end
end

-- Lines: 93 to 94
function BasicEventHandling:_has_callbacks_for_event(event_name)
	return self._event_callbacks ~= nil and self._event_callbacks[event_name] ~= nil
end

-- Lines: 97 to 103
function BasicEventHandling:_send_event(event_name, ...)
	if self._event_callbacks then
		for _, wrapped_func in ipairs(self._event_callbacks[event_name] or {}) do
			wrapped_func(...)
		end
	end
end
CallbackHandler = CallbackHandler or class()

-- Lines: 113 to 115
function CallbackHandler:init()
	self:clear()
end

-- Lines: 117 to 120
function CallbackHandler:clear()
	self._t = 0
	self._sorted = {}
end

-- Lines: 122 to 128
function CallbackHandler:__insert_sorted(cb)
	local i = 1

	while self._sorted[i] and (self._sorted[i].next == nil or self._sorted[i].next < cb.next) do
		i = i + 1
	end

	table.insert(self._sorted, i, cb)
end

-- Lines: 130 to 136
function CallbackHandler:add(f, interval, times)
	times = times or -1
	local cb = {
		f = f,
		interval = interval,
		times = times,
		next = self._t + interval
	}

	self:__insert_sorted(cb)

	return cb
end

-- Lines: 139 to 143
function CallbackHandler:remove(cb)
	if cb then
		cb.next = nil
	end
end

-- Lines: 145 to 169
function CallbackHandler:update(dt)
	self._t = self._t + dt

	while true do
		local cb = self._sorted[1]

		if cb == nil then
			return
		elseif cb.next == nil then
			table.remove(self._sorted, 1)
		elseif self._t < cb.next then
			return
		else
			table.remove(self._sorted, 1)
			cb:f(self._t)

			if cb.times >= 0 then
				cb.times = cb.times - 1

				if cb.times <= 0 then
					cb.next = nil
				end
			end

			if cb.next then
				cb.next = cb.next + cb.interval

				self:__insert_sorted(cb)
			end
		end
	end
end
CallbackEventHandler = CallbackEventHandler or class()

-- Lines: 180 to 181
function CallbackEventHandler:init()
end

-- Lines: 183 to 185
function CallbackEventHandler:clear()
	self._callback_map = nil
end

-- Lines: 187 to 190
function CallbackEventHandler:add(func)
	self._callback_map = self._callback_map or {}
	self._callback_map[func] = true
end

-- Lines: 192 to 203
function CallbackEventHandler:remove(func)
	if not self._callback_map or self._callback_map[func] == nil then
		return
	end

	if (self._dispatch_depth or 0) > 0 then
		self._callback_map[func] = false

		return
	end

	self._callback_map[func] = nil
end

-- Lines: 205 to 225
function CallbackEventHandler:dispatch(...)
	self._dispatch_depth = (self._dispatch_depth or 0) + 1

	if not self._callback_map then
		return
	end

	for func, run in pairs(self._callback_map) do
		if run then
			func(...)
		end
	end

	self._dispatch_depth = self._dispatch_depth - 1

	if self._dispatch_depth == 0 then
		for func, keep in pairs(self._callback_map) do
			if not keep then
				self:remove(func)
			end
		end
	end
end

-- Lines: 240 to 249
function over(seconds, f, fixed_dt)
	local t = 0

	while true do
		local dt = coroutine.yield()
		t = t + (fixed_dt and 0.03333333333333333 or dt)

		if seconds <= t then
			break
		end

		f(t / seconds, t)
	end

	f(1, seconds)
end

-- Lines: 255 to 266
function seconds(s, t)
	if not t then
		return seconds, s, 0
	end

	if s and s <= t then
		return nil
	end

	local dt = coroutine.yield()
	t = t + dt

	if s and s < t then
		t = s
	end

	if s then
		return t, t / s, dt
	else
		return t, t, dt
	end
end

-- Lines: 269 to 275
function wait(seconds, fixed_dt)
	local t = 0

	while t < seconds do
		local dt = coroutine.yield()
		t = t + (fixed_dt and 0.03333333333333333 or dt)
	end
end

