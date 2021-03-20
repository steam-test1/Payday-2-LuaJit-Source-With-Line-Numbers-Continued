-- Lines 16-36
function class(...)
	local super = ...

	if select("#", ...) >= 1 and super == nil then
		error("trying to inherit from nil", 2)
	end

	local class_table = {
		super = super
	}
	class_table.__index = class_table

	setmetatable(class_table, super)

	-- Lines 27-34
	function class_table.new(klass, ...)
		local object = {}

		setmetatable(object, class_table)

		if object.init then
			return object, object:init(...)
		end

		return object
	end

	return class_table
end

-- Lines 38-61
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

CoreLoadingSetup = CoreLoadingSetup or class()

-- Lines 65-65
function CoreLoadingSetup:init()
end

-- Lines 67-68
function CoreLoadingSetup:init_managers(managers)
end

-- Lines 70-71
function CoreLoadingSetup:init_gp()
end

-- Lines 73-74
function CoreLoadingSetup:post_init()
end

-- Lines 76-77
function CoreLoadingSetup:update(t, dt)
end

-- Lines 79-79
function CoreLoadingSetup:destroy()
end

-- Lines 81-85
function CoreLoadingSetup:__init()
	self:init_managers(managers)
	self:init_gp()
	self:post_init()
end

-- Lines 87-89
function CoreLoadingSetup:__update(t, dt)
	self:update(t, dt)
end

-- Lines 91-93
function CoreLoadingSetup:__destroy(t, dt)
	self:destroy()
end

-- Lines 95-99
function CoreLoadingSetup:make_entrypoint()
	rawset(_G, "init", callback(self, self, "__init"))
	rawset(_G, "update", callback(self, self, "__update"))
	rawset(_G, "destroy", callback(self, self, "__destroy"))
end
