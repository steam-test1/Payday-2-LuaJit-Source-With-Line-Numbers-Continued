BaseMutator = BaseMutator or class()
BaseMutator._type = "BaseMutator"
BaseMutator.name_id = ""
BaseMutator.desc_id = ""
BaseMutator.has_options = false
BaseMutator.categories = {}
BaseMutator.incompatiblities = {}
BaseMutator.incompatibility_tags = {}
BaseMutator.icon_coords = {
	1,
	1
}
BaseMutator.load_priority = 0
BaseMutator.reductions = {
	money = 0,
	exp = 0
}
BaseMutator.disables_achievements = true

-- Lines 20-35
function BaseMutator:init(mutator_manager)
	self._enabled = false
	self._values = {}

	self:register_values()

	local mutator_data = Global.mutators and Global.mutators.mutator_values and Global.mutators.mutator_values[self:id()]

	if mutator_data then
		for key, value in pairs(mutator_data.values) do
			self:set_value(key, value)
		end

		self._enabled = mutator_data.enabled
	end
end

-- Lines 38-40
function BaseMutator:register_values(mutator_manager)
end

-- Lines 43-45
function BaseMutator:setup(mutator_manager)
end

-- Lines 49-51
function BaseMutator:_ensure_global_values()
	Global.mutators.mutator_values[self:id()] = Global.mutators.mutator_values[self:id()] or {
		values = {},
		enabled = self._enabled
	}
end

-- Lines 54-56
function BaseMutator:id()
	return self._type
end

-- Lines 59-61
function BaseMutator:name()
	return managers.localization:text(self.name_id)
end

-- Lines 64-66
function BaseMutator:desc()
	return managers.localization:text(self.desc_id)
end

-- Lines 69-74
function BaseMutator:longdesc()
	if not self.longdesc_id then
		self.longdesc_id = string.gsub(self.desc_id, "_desc", "_longdesc")
	end

	return managers.localization:text(self.longdesc_id)
end

-- Lines 77-80
function BaseMutator:icon()
	local x = self.icon_coords[1]
	local y = self.icon_coords[2]
	local size = MutatorsManager._icon_size

	return MutatorsManager._atlas_file, {
		size * (x - 1),
		size * (y - 1),
		size,
		size
	}
end

-- Lines 83-95
function BaseMutator:is_compatible_with(mutator)
	for i, mutator_id in ipairs(self.incompatiblities) do
		if mutator:id() == mutator_id then
			return false
		end
	end

	for i, tag in ipairs(self.incompatibility_tags) do
		if table.contains(mutator.incompatibility_tags, tag) then
			return false
		end
	end

	return true
end

-- Lines 98-100
function BaseMutator:is_incompatible_with(mutator)
	return not self:is_compatible_with(mutator) or not mutator:is_compatible_with(self)
end

-- Lines 103-105
function BaseMutator:is_enabled()
	return self._enabled
end

-- Lines 108-112
function BaseMutator:set_enabled(enable)
	self._enabled = enable

	self:_ensure_global_values()

	Global.mutators.mutator_values[self:id()].enabled = enable
end

-- Lines 115-124
function BaseMutator:is_active()
	if managers.mutators then
		for i, active_mutator in ipairs(managers.mutators:active_mutators()) do
			if active_mutator.mutator and active_mutator.mutator:id() == self:id() then
				return true
			end
		end
	end

	return false
end

-- Lines 127-129
function BaseMutator:get_cash_reduction()
	return self.reductions.money
end

-- Lines 132-134
function BaseMutator:get_experience_reduction()
	return self.reductions.exp
end

-- Lines 137-139
function BaseMutator:update(t, dt)
end

-- Lines 143-161
function BaseMutator:_mutate_name(key)
	if Global.game_settings.single_player then
		return self:is_enabled() and self:value(key)
	elseif Network:is_server() then
		return self:is_enabled() and self:value(key)
	elseif Network:is_client() then
		return self:value(key)
	elseif managers.mutators:crimenet_lobby_data() then
		return self:value(key)
	else
		return self:is_enabled() and self:value(key)
	end
end

-- Lines 166-168
function BaseMutator:show_options()
	return self.has_options
end

-- Lines 171-188
function BaseMutator:setup_options_gui(node)
	local params = {
		name = "default_item",
		localize = false,
		text_id = "No options!",
		align = "right",
		disabled_color = tweak_data.screen_colors.important_1
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	return new_item
end

-- Lines 191-193
function BaseMutator:reset_to_default()
end

-- Lines 196-198
function BaseMutator:options_fill()
	return 0
end

-- Lines 200-202
function BaseMutator:_get_percentage_fill(min, max, current)
	return math.clamp(((current or 0) - min) / (max - min), 0, 1)
end

-- Lines 207-211
function BaseMutator:clear_values()
	for id, data in pairs(self._values) do
		data.current = data.default
	end
end

-- Lines 214-216
function BaseMutator:values()
	return self._values
end

-- Lines 219-241
function BaseMutator:register_value(key, default, network_key)
	if not network_key then
		network_key = key
		local splits = string.split(key, "[_]")

		if splits then
			network_key = ""

			for _, str in ipairs(splits) do
				network_key = network_key .. tostring(str[1])
			end
		end
	end

	self._values[key] = {
		current = default,
		default = default,
		network_key = network_key
	}
end

-- Lines 244-256
function BaseMutator:set_value(id, value)
	if not self._values[id] then
		Application:error(string.format("Can not set a value for a key that has not been registered! %s: %s", self:id(), id))

		return
	end

	self._values[id].current = value

	self:_ensure_global_values()

	Global.mutators.mutator_values[self:id()].values[id] = value
end

-- Lines 259-268
function BaseMutator:set_host_value(id, value)
	if not self._values[id] then
		Application:error(string.format("Can not set a value for a key that has not been registered! %s: %s", self:id(), id))

		return
	end

	self._values[id].host = value
end

-- Lines 271-300
function BaseMutator:value(id)
	if not self._values[id] then
		Application:error(string.format("Can not get a value for a key that has not been registered! %s: %s", self:id(), id))

		return nil
	end

	local value = self:_get_value(self._values, id)
	local ret_value = value.current

	if Network:is_client() then
		self:_apply_host_values(managers.mutators:get_mutators_from_lobby_data())

		ret_value = value.host == nil and value.client or value.host
	end

	if managers.mutators:crimenet_lobby_data() then
		self:_apply_host_values(managers.mutators:crimenet_lobby_data())

		ret_value = value.host == nil and value.client or value.host
	end

	if ret_value == nil then
		ret_value = value.default
	end

	return ret_value
end

-- Lines 302-308
function BaseMutator:_get_value(table, id, default)
	local value = table[id]

	if value == nil then
		value = default
	end

	return value
end

-- Lines 310-316
function BaseMutator:_apply_host_values(host_mutators)
	if host_mutators and host_mutators[self:id()] then
		for key, value in pairs(host_mutators[self:id()]) do
			self:set_host_value(key, value)
		end
	end
end

-- Lines 321-340
function BaseMutator:build_matchmaking_key()
	local matchmaking_key = string.format("%s ", self:id())

	if table.size(self:values()) > 0 then
		for key, data in pairs(self:values()) do
			local value = data.current

			if type(value) == "number" then
				matchmaking_key = matchmaking_key .. string.format("%s %.4f ", data.network_key, value)
			else
				matchmaking_key = matchmaking_key .. string.format("%s %s ", data.network_key, tostring(value))
			end
		end
	end

	return matchmaking_key
end

-- Lines 343-358
function BaseMutator:build_compressed_data(id)
	local matchmaking_key = string.format("%c", string.byte("a") + id)

	for key, data in pairs(self:values()) do
		local value = data.current

		if type(value) == "number" then
			matchmaking_key = matchmaking_key .. string.format("%.2f ", value)
		elseif type(value) == "boolean" then
			matchmaking_key = matchmaking_key .. string.format("%d ", value and 1 or 0)
		else
			matchmaking_key = matchmaking_key .. string.format("%s ", tostring(value))
		end
	end

	return matchmaking_key
end

-- Lines 361-389
function BaseMutator:uncompress_data(str_dat)
	local ret = {}

	for key, data in pairs(self:values()) do
		local default = data.default
		local idx = string.find(str_dat, " ", 1, true)

		if idx == nil then
			return nil, ""
		end

		local new_value = string.sub(str_dat, 1, idx)
		str_dat = string.sub(str_dat, idx + 1)

		if type(default) == "number" then
			local number = tonumber(new_value)

			if number == nil then
				ret[key] = default
			else
				ret[key] = number
			end
		elseif type(default) == "boolean" then
			ret[key] = tonumber(new_value) == 1
		else
			ret[key] = new_value
		end
	end

	return ret, str_dat
end

-- Lines 392-420
function BaseMutator:partial_uncompress_data(str_dat)
	local ret = string.format("%s ", self:id())

	for key, data in pairs(self:values()) do
		local default = data.default
		local idx = string.find(str_dat, " ", 1, true)

		if idx == nil then
			return nil, ""
		end

		local new_value = string.sub(str_dat, 1, idx)
		str_dat = string.sub(str_dat, idx + 1)

		if type(default) == "number" then
			local number = tonumber(new_value)

			if number == nil then
				ret = ret .. string.format("%s %.4f ", data.network_key, default)
			else
				ret = ret .. string.format("%s %.4f ", data.network_key, number)
			end
		elseif type(default) == "boolean" then
			ret = ret .. string.format("%s %s ", data.network_key, tostring(tonumber(new_value) == 1))
		else
			ret = ret .. string.format("%s %s ", data.network_key, tostring(new_value))
		end
	end

	return ret, str_dat
end

-- Lines 423-464
function BaseMutator:get_data_from_attribute_string(string_table)
	if #string_table > 0 and #string_table % 2 ~= 0 then
		Application:error("Warning! Mismatched attribute string table, should have an even amount of elements!", self:id())
		print(inspect(string_table))

		return nil
	end

	local data = {}

	for i = 1, #string_table, 2 do
		local key = string_table[i]
		local value = string.trim(string_table[i + 1])

		for id, data in pairs(self._values) do
			if key == data.network_key then
				key = id

				break
			end
		end

		if value == "true" or value == "false" then
			data[key] = toboolean(string_table[i + 1])
		else
			local number = tonumber(string_table[i + 1])

			if number == nil then
				data[key] = string_table[i + 1]
			else
				data[key] = number
			end
		end
	end

	return data
end

-- Lines 469-470
function BaseMutator:modify_character_tweak_data(character_tweak)
end

-- Lines 472-473
function BaseMutator:modify_tweak_data(id, value)
end

-- Lines 475-477
function BaseMutator:modify_value(id, value)
	return value
end
