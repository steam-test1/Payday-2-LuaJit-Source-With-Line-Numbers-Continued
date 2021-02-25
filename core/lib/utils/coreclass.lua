core:module("CoreClass")

__overrides = {}
__everyclass = {}

-- Lines 16-40
function class(...)
	local super = ...

	if select("#", ...) >= 1 and super == nil then
		error("trying to inherit from nil", 2)
	end

	local class_table = {}

	if __everyclass then
		table.insert(__everyclass, class_table)
	end

	class_table.super = __overrides[super] or super
	class_table.__index = class_table
	class_table.__module__ = getfenv(2)

	setmetatable(class_table, __overrides[super] or super)

	-- Lines 31-38
	function class_table.new(klass, ...)
		local object = {}

		setmetatable(object, __overrides[class_table] or class_table)

		if object.init then
			return object, object:init(...)
		end

		return object
	end

	return class_table
end

-- Lines 42-51
function override_class(old_class, new_class)
	assert(__everyclass, "Too late to override class now.")

	for _, ct in ipairs(__everyclass) do
		if ct ~= new_class and ct.super == old_class then
			ct.super = new_class

			setmetatable(ct, new_class)
		end
	end

	__overrides[old_class] = new_class
end

-- Lines 53-55
function close_override()
	__everyclass = nil
end

-- Lines 62-68
function type_name(value)
	local name = type(value)

	if name == "userdata" and value.type_name then
		return value.type_name
	end

	return name
end

-- Lines 74-83
function mixin(res, ...)
	for _, t in ipairs({
		...
	}) do
		for k, v in pairs(t) do
			if k ~= "new" and k ~= "__index" then
				rawset(res, k, v)
			end
		end
	end

	return res
end

-- Lines 85-87
function mix(...)
	return mixin({}, ...)
end

-- Lines 89-94
function mixin_add(res, ...)
	for _, t in ipairs({
		...
	}) do
		for k, v in pairs(t) do
			table.insert(res, v)
		end
	end

	return res
end

-- Lines 96-98
function mix_add(...)
	return mixin_add({}, ...)
end

-- Lines 104-119
function hijack_func(instance_or_meta, func_name, func)
	local meta = getmetatable(instance_or_meta) or instance_or_meta

	if not meta then
		Application:error("Can't hijack nil instance or class.")
	elseif not meta[func_name] then
		Application:error("Unable to hijack non-existing function \"" .. tostring(func_name) .. "\".")
	else
		local old_func_name = "hijacked_" .. func_name

		if not meta[old_func_name] then
			meta[old_func_name] = meta[func_name]
			meta[func_name] = func or function ()
			end
		end
	end
end

-- Lines 121-134
function unhijack_func(instance_or_meta, func_name)
	local meta = getmetatable(instance_or_meta) or instance_or_meta

	if not meta then
		Application:error("Can't unhijack nil instance or class.")
	else
		local old_func_name = "hijacked_" .. func_name

		if meta[old_func_name] then
			meta[func_name] = meta[old_func_name]
			meta[old_func_name] = nil
		end
	end
end

__frozen__newindex = __frozen__newindex or function (self, key, value)
	error(string.format("Attempt to set %s = %s in frozen %s.", tostring(key), tostring(value), type_or_class_name(self)))
end

-- Lines 140-152
function freeze(...)
	for _, instance in ipairs({
		...
	}) do
		if not is_frozen(instance) then
			local metatable = getmetatable(instance)

			if metatable == nil then
				setmetatable(instance, {
					__newindex = __frozen__newindex
				})
			else
				setmetatable(instance, {
					__index = metatable.__index,
					__newindex = __frozen__newindex,
					__metatable = metatable
				})
			end
		end
	end

	return ...
end

-- Lines 154-157
function is_frozen(instance)
	local metatable = debug.getmetatable(instance)

	return metatable and metatable.__newindex == __frozen__newindex
end

-- Lines 159-167
function frozen_class(...)
	local class_table = class(...)
	local new = class_table.new

	-- Lines 162-165
	function class_table.new(klass, ...)
		local instance, ret = new(klass, ...)

		return freeze(instance), ret
	end

	return class_table
end

-- Lines 177-181
function responder(...)
	local response = {
		...
	}

	-- Lines 179-179
	local function responder_function()
		return unpack(response)
	end

	return setmetatable({}, {
		__index = function ()
			return responder_function
		end
	})
end

-- Lines 190-200
function responder_map(response_table)
	local responder = {}

	for key, value in pairs(response_table) do
		if key == "default" then
			setmetatable(responder, {
				__index = function ()
					return function ()
						return value
					end
				end
			})
		else
			responder[key] = function ()
				return value
			end
		end
	end

	return responder
end

GetSet = GetSet or class()

-- Lines 209-215
function GetSet:init(t)
	for k, v in pairs(t) do
		self["_" .. k] = v

		self[k] = function (self)
			return self["_" .. k]
		end

		self["set_" .. k] = function (self, v)
			self["_" .. k] = v
		end
	end
end
