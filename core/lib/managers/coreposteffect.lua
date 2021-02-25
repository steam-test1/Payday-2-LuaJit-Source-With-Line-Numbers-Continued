CorePostEffectModifier = CorePostEffectModifier or class()

-- Lines 3-5
function CorePostEffectModifier:init()
	self._params = {}
end

-- Lines 7-19
function CorePostEffectModifier:add(from)
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
function CorePostEffectModifier:scale(scale)
	for key, value in pairs(self._params) do
		self._params[key] = self._params[key] * scale
	end
end

-- Lines 27-35
function CorePostEffectModifier:copy(from)
	for key, value in pairs(from._params) do
		if type(value) ~= "number" then
			self._params[key] = Vector3(value.x, value.y, value.z)
		else
			self._params[key] = value
		end
	end
end

-- Lines 37-48
function CorePostEffectModifier:interpolate(postfx, with, scale)
	for key, value in pairs(postfx._params) do
		if type(value) ~= "string" then
			if not with._params[key] then
				self._params[key] = nil
			else
				local invscale = 1 - scale
				self._params[key] = postfx._params[key] * invscale + with._params[key] * scale
			end
		end
	end
end

-- Lines 50-57
function CorePostEffectModifier:interpolate_value(postfx, with, key, scale)
	if not with._params[key] or not postfx._params[key] then
		return
	else
		local invscale = 1 - scale
		self._params[key] = postfx._params[key] * invscale + with._params[key] * scale
	end
end

-- Lines 59-79
function CorePostEffectModifier:parse(xml_node)
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

-- Lines 81-83
function CorePostEffectModifier:set_value(key, value)
	self._params[key] = value
end

-- Lines 85-87
function CorePostEffectModifier:value(key)
	return self._params[key]
end

-- Lines 89-99
function CorePostEffectModifier:database_lookup(str)
	local i = string.find(str, "#")
	local db_key = string.sub(str, 1, i - 1)
	local value_key = string.sub(str, i + 1)

	assert(db_key == "LightIntensityDB")

	local value = LightIntensityDB:lookup(value_key)

	assert(value)

	return value
end

CorePostProcessor = CorePostProcessor or class()

-- Lines 105-107
function CorePostProcessor:init()
	self._modifiers = {}
end

-- Lines 109-116
function CorePostProcessor:add(from)
	for name, modifier in pairs(from._modifiers) do
		if not self._modifiers[name] then
			self._modifiers[name] = CorePostEffectModifier:new()
		end

		modifier:add(from._modifiers[name])
	end
end

-- Lines 118-122
function CorePostProcessor:scale(scale)
	for name, modifier in pairs(self._modifiers) do
		modifier:scale(scale)
	end
end

-- Lines 124-131
function CorePostProcessor:copy(from)
	for name, modifier in pairs(from._modifiers) do
		if not self._modifiers[name] then
			self._modifiers[name] = CorePostEffectModifier:new()
		end

		self._modifiers[name]:copy(modifier)
	end
end

-- Lines 133-157
function CorePostProcessor:interpolate(postfx, with, scale)
	for name, modifier in pairs(postfx._modifiers) do
		if not with._modifiers[name] then
			with._modifiers[name] = CorePostEffectModifier:new()
		end

		if not self._modifiers[name] then
			self._modifiers[name] = CorePostEffectModifier:new()
		end
	end

	for name, modifier in pairs(with._modifiers) do
		if not postfx._modifiers[name] then
			postfx._modifiers[name] = CorePostEffectModifier:new()
		end

		if not self._modifiers[name] then
			self._modifiers[name] = CorePostEffectModifier:new()
		end
	end

	for name, modifier in pairs(self._modifiers) do
		modifier:interpolate(postfx._modifiers[name], with._modifiers[name], scale)
	end
end

-- Lines 159-169
function CorePostProcessor:interpolate_value(postfx, with, modifier, key, scale)
	if not with._modifiers[modifier] or not postfx._modifiers[modifier] then
		return
	end

	if not self._modifiers[modifier] then
		self._modifiers[modifier] = CorePostEffectModifier:new()
	end

	self._modifiers[modifier]:interpolate_value(postfx._modifiers[modifier], with._modifiers[modifier], key, scale)
end

-- Lines 171-181
function CorePostProcessor:parse(xml_node)
	for child in xml_node:children() do
		local name = child:parameter("name")

		if child:name() == "modifier" and name and name ~= "" then
			if not self._modifiers[name] then
				self._modifiers[name] = CorePostEffectModifier:new()
			end

			self._modifiers[name]:parse(child)
		end
	end
end

-- Lines 183-188
function CorePostProcessor:set_value(modifier, key, value)
	if not self._modifiers[modifier] then
		self._modifiers[modifier] = CorePostEffectModifier:new()
	end

	self._modifiers[modifier]:set_value(key, value)
end

-- Lines 190-196
function CorePostProcessor:value(modifier, key)
	if self._modifiers[modifier] then
		return self._modifiers[modifier]:value(key)
	else
		return nil
	end
end

CorePostEffect = CorePostEffect or class()

-- Lines 202-204
function CorePostEffect:init()
	self:set_default()
end

-- Lines 206-208
function CorePostEffect:set_name(name)
	self._name = name
end

-- Lines 210-213
function CorePostEffect:set_default()
	self._post_processors = {}
	self._name = "default"
end

-- Lines 215-223
function CorePostEffect:add(from)
	for name, processor in pairs(from._post_processors) do
		if not self._post_processors[name] then
			self._post_processors[name] = CorePostProcessor:new()
			self._post_processors[name]._effect = processor._effect
		end

		processor:add(from._post_processors[name])
	end
end

-- Lines 225-229
function CorePostEffect:scale(scale)
	for name, processor in pairs(self._post_processors) do
		processor:scale(scale)
	end
end

-- Lines 231-241
function CorePostEffect:copy(from)
	for name, processor in pairs(from._post_processors) do
		if not self._post_processors[name] then
			self._post_processors[name] = CorePostProcessor:new()
			self._post_processors[name]._effect = processor._effect
		end

		self._post_processors[name]:copy(processor)
	end

	self._name = from._name
end

-- Lines 243-273
function CorePostEffect:interpolate(postfx, with, scale)
	for name, processor in pairs(postfx._post_processors) do
		if not with._post_processors[name] then
			with._post_processors[name] = CorePostProcessor:new()
			with._post_processors[name]._effect = processor._effect
		end

		if not self._post_processors[name] then
			self._post_processors[name] = CorePostProcessor:new()
			self._post_processors[name]._effect = processor._effect
		end
	end

	for name, processor in pairs(with._post_processors) do
		if not postfx._post_processors[name] then
			postfx._post_processors[name] = CorePostProcessor:new()
			postfx._post_processors[name]._effect = processor._effect
		end

		if not self._post_processors[name] then
			self._post_processors[name] = CorePostProcessor:new()
			self._post_processors[name]._effect = processor._effect
		end
	end

	for name, processor in pairs(self._post_processors) do
		processor:interpolate(postfx._post_processors[name], with._post_processors[name], scale)
	end

	self._name = postfx._name
end

-- Lines 275-287
function CorePostEffect:interpolate_value(postfx, with, processor, modifier, key, scale)
	if not with._post_processors[processor] or not postfx._post_processors[processor] then
		return
	end

	if not self._post_processors[processor] then
		self._post_processors[processor] = CorePostProcessor:new()
		self._post_processors[processor]._effect = processor._effect
	end

	self._name = postfx._name

	self._post_processors[processor]:interpolate_value(postfx._post_processors[processor], with._post_processors[processor], modifier, key, scale)
end

-- Lines 289-301
function CorePostEffect:parse(xml_node)
	for child in xml_node:children() do
		local name = child:parameter("name")
		local effect = child:parameter("effect")

		if child:name() == "post_processor" and name and name ~= "" and effect and effect ~= "" then
			if not self._post_processors[name] then
				self._post_processors[name] = CorePostProcessor:new()
			end

			self._post_processors[name]._effect = effect

			self._post_processors[name]:parse(child)
		end
	end
end

-- Lines 303-308
function CorePostEffect:set_value(processor, modifier, key, value)
	if not self._post_processors[processor] then
		self._post_processors[processor] = CorePostProcessor:new()
	end

	self._post_processors[processor]:set_value(modifier, key, value)
end

-- Lines 310-316
function CorePostEffect:value(processor, modifier, key)
	if self._post_processors[processor] then
		return self._post_processors[processor]:value(modifier, key)
	else
		return nil
	end
end
