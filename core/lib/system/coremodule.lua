local CORE = 0
local PROJ = 1
local CoreModule = {
	PRODUCTION_ONLY = "PRODUCTION_ONLY",
	new = function (self)
		local instance = {}
		self.__index = self

		setmetatable(instance, self)
		instance:init()

		return instance
	end,
	init = function (self)
		self.__modules = {}
		self.__filepaths = {}
		self.__pristine_G = {}
		self.__pristine_closed = false
		self.__obj2nametable = {}

		for k, v in pairs(_G) do
			self.__pristine_G[k] = v
		end

		self.__pristine_G.core = self

		return self
	end,
	register_module = function (self, module_file_path)
		local module_name = self:_get_module_name(module_file_path)

		assert(self.__filepaths[module_name] == nil, "Can't register module '" .. tostring(module_name) .. "'. It is already registred.")

		self.__filepaths[module_name] = module_file_path
	end,
	import = function (self, module_name)
		if self.__filepaths[module_name] ~= nil then
			local fp = self.__filepaths[module_name]

			require(fp)

			local m = self.__modules[module_name]

			assert(m, "Can't import. Please check statement core:module('" .. module_name .. "') in: " .. fp)
			rawset(getfenv(2), module_name, m)

			return m
		else
			error("Can't import module '" .. tostring(module_name) .. "'. It is not registred (is spelling correct?)")
		end
	end,
	from_module_import = function (self, module_name, ...)
		if self.__filepaths[module_name] ~= nil then
			local fp = self.__filepaths[module_name]

			require(fp)

			local m = self.__modules[module_name]

			assert(m, "Can't import. Please check statement core:module('" .. module_name .. "') in: " .. fp)

			for _, name in ipairs({
				...
			}) do
				local v = assert(m[name], "Can't import name '" .. tostring(name) .. "' from module '" .. module_name .. "'")

				rawset(getfenv(2), name, v)
			end
		else
			error("Can't import module '" .. tostring(module_name) .. "'. It is not registred (is spelling correct?)")
		end
	end
}

-- Lines 77-85
function CoreModule:module(module_name)
	local M = nil
	M = self.__modules[module_name] or {}
	self.__modules[module_name] = M
	M._M = M
	M._NAME = module_name

	setmetatable(M, {
		__index = self.__pristine_G
	})
	setfenv(2, M)
end

-- Lines 87-91
function CoreModule:_add_to_pristine_and_global(key, value)
	assert(not self.__pristine_closed)
	rawset(self.__pristine_G, key, value)
	rawset(_G, key, value)
end

-- Lines 93-99
function CoreModule:_copy_module_to_global(module_name)
	assert(not self.__pristine_closed)

	local module = self:import(module_name)

	for k, v in pairs(module) do
		rawset(_G, k, v)
	end
end

-- Lines 101-103
function CoreModule:_close_pristine_namespace(module_name)
	self.__pristine_closed = true
end

-- Lines 105-116
function CoreModule:_get_module_name(module_file_path)
	assert(type(module_file_path) == "string")

	local i = 1
	local j = string.find(module_file_path, "/", i, true)

	while j do
		i = j + 1
		j = string.find(module_file_path, "/", i, true)
	end

	local module_name = string.sub(module_file_path, i)

	assert(module_name ~= "", string.format("Malformed module_file_path '%s'", module_file_path))

	return module_name
end

-- Lines 118-121
function CoreModule:_prepare_reload()
	self.__filepaths = {}
	self.__pristine_closed = false
end

-- Lines 123-140
function CoreModule:_lookup(object)
	assert(Application:production_build(), "core:_lookup(...) is for debugging only!")

	if not self.__obj2nametable[object] then
		-- Lines 126-133
		local function find(o, n, t)
			for k, v in pairs(t) do
				if v == o then
					self.__obj2nametable[o] = {
						k,
						n
					}

					return true
				end
			end
		end

		find(object, "_G", _G)

		for n, m in pairs(self.__modules) do
			find(object, n, m)
		end
	end

	return unpack(self.__obj2nametable[object] or {
		"<notfound>",
		"<notfound>"
	})
end

-- Lines 142-154
function CoreModule:_name_to_module(module_name)
	if not self.__modules[module_name] then
		if self.__filepaths[module_name] ~= nil then
			local fp = self.__filepaths[module_name]

			require(fp)

			local m = self.__modules[module_name]

			assert(m, "Can't import. Please check statement core:module('" .. module_name .. "') in: " .. fp)
		else
			error("Can't import module '" .. tostring(module_name) .. "'. It is not registred (is spelling correct?)")
		end
	end

	return self.__modules[module_name]
end

-- Lines 156-163
function CoreModule:_module_to_name(module)
	for n, m in pairs(self.__modules) do
		if m == module then
			return n
		end
	end

	error("Can't locate module")
end

if _G.core == nil then
	_G.core = CoreModule:new()
else
	_G.core:_prepare_reload()
end
