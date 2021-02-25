CoreUnderlayMaterial = CoreUnderlayMaterial or class()

-- Lines 3-5
function CoreUnderlayMaterial:init()
	self._params = {}
end

-- Lines 7-19
function CoreUnderlayMaterial:add(from)
	for key, value in pairs(from._params) do
		if self._params[key] then
			self._params[key] = self._params[key] + from._params[key]
		elseif type(from._params[key]) ~= "number" then
			self._params[key] = Vector3(from._params[key].x, from._params[key].y, from._params[key].z)
		else
			self._params[key] = from._params[key]
		end
	end
end

-- Lines 21-25
function CoreUnderlayMaterial:scale(scale)
	for key, value in pairs(self._params) do
		self._params[key] = self._params[key] * scale
	end
end

-- Lines 27-35
function CoreUnderlayMaterial:copy(from)
	for key, value in pairs(from._params) do
		if type(value) ~= "number" then
			self._params[key] = Vector3(value.x, value.y, value.z)
		else
			self._params[key] = value
		end
	end
end

-- Lines 37-46
function CoreUnderlayMaterial:interpolate(postfx, with, scale)
	for key, value in pairs(postfx._params) do
		if not with._params[key] then
			self._params[key] = nil
		else
			local invscale = 1 - scale
			self._params[key] = postfx._params[key] * invscale + with._params[key] * scale
		end
	end
end

-- Lines 48-55
function CoreUnderlayMaterial:interpolate_value(postfx, with, key, scale)
	if not with._params[key] or not postfx._params[key] then
		return
	else
		local invscale = 1 - scale
		self._params[key] = postfx._params[key] * invscale + with._params[key] * scale
	end
end

-- Lines 57-77
function CoreUnderlayMaterial:parse(xml_node)
	self._params = {}

	for child in xml_node:children() do
		local key = child:parameter("key")
		local value = child:parameter("value")

		if child:name() == "param" and key and key ~= "" and value and value ~= "" then
			if math.string_is_good_vector(value) then
				self._params[key] = math.string_to_vector(value)
			elseif tonumber(value) then
				self._params[key] = tonumber(value)
			elseif string.sub(value, 1, 1) == "#" then
				self._params[key] = self:database_lookup(string.sub(value, 2))
			else
				self._params[key] = tostring(value)
			end
		end
	end
end

-- Lines 79-81
function CoreUnderlayMaterial:set_value(key, value)
	self._params[key] = value
end

-- Lines 83-85
function CoreUnderlayMaterial:value(key)
	return self._params[key]
end

-- Lines 87-97
function CoreUnderlayMaterial:database_lookup(str)
	local i = string.find(str, "#")
	local db_key = string.sub(str, 1, i - 1)
	local value_key = string.sub(str, i + 1)

	assert(db_key == "LightIntensityDB")

	local value = LightIntensityDB:lookup(value_key)

	assert(value)

	return value
end

CoreUnderlayEffect = CoreUnderlayEffect or class()

-- Lines 103-105
function CoreUnderlayEffect:init()
	self:set_default()
end

-- Lines 107-110
function CoreUnderlayEffect:set_default()
	self._materials = {}
	self._name = "default"
end

-- Lines 112-114
function CoreUnderlayEffect:set_name(name)
	self._name = name
end

-- Lines 116-123
function CoreUnderlayEffect:add(from)
	for name, material in pairs(from._materials) do
		if not self._materials[name] then
			self._materials[name] = CoreUnderlayMaterial:new()
		end

		material:add(from._materials[name])
	end
end

-- Lines 125-129
function CoreUnderlayEffect:scale(scale)
	for name, material in pairs(self._materials) do
		material:scale(scale)
	end
end

-- Lines 131-140
function CoreUnderlayEffect:copy(from)
	for name, material in pairs(from._materials) do
		if not self._materials[name] then
			self._materials[name] = CoreUnderlayMaterial:new()
		end

		self._materials[name]:copy(material)
	end

	self._name = from._name
end

-- Lines 142-168
function CoreUnderlayEffect:interpolate(postfx, with, scale)
	for name, material in pairs(postfx._materials) do
		if not with._materials[name] then
			with._materials[name] = CoreUnderlayMaterial:new()
		end

		if not self._materials[name] then
			self._materials[name] = CoreUnderlayMaterial:new()
		end
	end

	for name, material in pairs(with._materials) do
		if not postfx._materials[name] then
			postfx._materials[name] = CoreUnderlayMaterial:new()
		end

		if not self._materials[name] then
			self._materials[name] = CoreUnderlayMaterial:new()
		end
	end

	for name, material in pairs(self._materials) do
		material:interpolate(postfx._materials[name], with._materials[name], scale)
	end

	self._name = postfx._name
end

-- Lines 170-181
function CoreUnderlayEffect:interpolate_value(postfx, with, material, key, scale)
	if not with._materials[material] or not postfx._materials[material] then
		return
	end

	if not self._materials[material] then
		self._materials[material] = CoreUnderlayMaterial:new()
	end

	self._name = postfx._name

	self._materials[material]:interpolate_value(postfx._materials[material], with._materials[material], key, scale)
end

-- Lines 183-193
function CoreUnderlayEffect:parse(xml_node)
	for child in xml_node:children() do
		local name = child:parameter("name")

		if child:name() == "material" and name and name ~= "" then
			if not self._materials[name] then
				self._materials[name] = CoreUnderlayMaterial:new()
			end

			self._materials[name]:parse(child)
		end
	end
end

-- Lines 195-200
function CoreUnderlayEffect:set_value(material, key, value)
	if not self._materials[material] then
		self._materials[material] = CoreUnderlayMaterial:new()
	end

	self._materials[material]:set_value(key, value)
end

-- Lines 202-208
function CoreUnderlayEffect:value(material, key)
	if self._materials[material] then
		return self._materials[material]:value(key)
	else
		return nil
	end
end
