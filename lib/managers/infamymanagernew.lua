InfamyManager = InfamyManager or class()
InfamyManager.VERSION = 3

-- Lines 4-6
function InfamyManager:init()
	self:_setup()
end

-- Lines 8-30
function InfamyManager:_setup(reset)
	if not Global.infamy_manager or reset then
		Global.infamy_manager = {
			points = Application:digest_value(0, true),
			VERSION = InfamyManager.VERSION,
			reset_message = false
		}
		self._global = Global.infamy_manager
		self._global.unlocks = {}

		for item_id, item_name in pairs(tweak_data.infamy.tree) do
			self._global.unlocks[item_name] = false
		end

		self._global.selected_join_stinger = 0
		self._global.join_stingers = {}

		for index = 0, tweak_data.infamy.join_stingers do
			self._global.join_stingers[index] = {
				index = index,
				unlocked = table.contains(tweak_data.infamy.free_join_stingers, index)
			}
		end
	end

	self._global = Global.infamy_manager
end

-- Lines 33-38
function InfamyManager:give_dlc()
	for i, dlc_stinger_data in ipairs(tweak_data.infamy.dlc_join_stingers) do
		self._global.join_stingers[dlc_stinger_data.join_stinger].unlocked = managers.dlc:is_dlc_unlocked(dlc_stinger_data.dlc)
	end

	self:_verify_loaded_data()
end

-- Lines 41-43
function InfamyManager:points()
	return Application:digest_value(self._global.points, false)
end

-- Lines 45-47
function InfamyManager:aquire_point()
end

-- Lines 49-51
function InfamyManager:_set_points(value)
	self._global.points = Application:digest_value(value, true)
end

-- Lines 53-56
function InfamyManager:_reset_points()
	self:_set_points(0)
	self:_verify_loaded_data()
end

-- Lines 58-60
function InfamyManager:required_points(item)
	return tweak_data.infamy.items[item] and true or false
end

-- Lines 63-70
function InfamyManager:reward_player_styles(global_value, category, player_style, suit_variation)
	managers.blackmarket:on_aquired_player_style(player_style)

	if suit_variation and suit_variation ~= "default" then
		managers.blackmarket:on_aquired_suit_variation(player_style, suit_variation)
	end
end

-- Lines 71-74
function InfamyManager:reward_suit_variations(global_value, category, player_style, suit_variation)
	managers.blackmarket:on_aquired_suit_variation(player_style, suit_variation)
end

-- Lines 77-80
function InfamyManager:reward_gloves(global_value, category, glove_id)
	managers.blackmarket:on_aquired_glove_id(glove_id)
end

-- Lines 83-89
function InfamyManager:reward_item(global_value, category, item_id)
	local item_tweak = tweak_data.blackmarket[category][item_id]
	global_value = global_value or item_tweak.global_value or managers.dlc:dlc_to_global_value(item_tweak.dlc) or "normal"

	managers.blackmarket:add_to_inventory(global_value, category, item_id)
end

-- Lines 92-124
function InfamyManager:missing_item(global_value, category, item_id)
	local item_tweak = tweak_data.blackmarket[category][item_id]
	global_value = global_value or item_tweak.global_value or managers.dlc:dlc_to_global_value(item_tweak.dlc) or "normal"
	local has_item = managers.blackmarket:get_item_amount(global_value, category, item_id, true) > 0

	if not has_item then
		if category == "masks" then
			for slot, crafted in pairs(Global.blackmarket_manager.crafted_items.masks) do
				if slot ~= 1 and crafted.mask_id == item_id and crafted.global_value == global_value then
					has_item = true

					break
				end
			end
		elseif category == "materials" or category == "textures" or category == "colors" then
			local name_converter = {
				colors = "color",
				materials = "material",
				textures = "pattern"
			}
			local name = nil

			for slot, crafted in pairs(Global.blackmarket_manager.crafted_items.masks) do
				if slot ~= 1 then
					name = name_converter[category]

					if crafted.blueprint[name].id == item_id and crafted.blueprint[name].global_value == global_value then
						has_item = true

						break
					end
				end
			end
		end
	end

	return not has_item
end

-- Lines 127-133
function InfamyManager:missing_player_styles(global_value, category, player_style, suit_variation)
	if suit_variation and suit_variation ~= "default" then
		return not managers.blackmarket:suit_variation_unlocked(player_style, suit_variation)
	end

	return not managers.blackmarket:player_style_unlocked(player_style)
end

-- Lines 134-137
function InfamyManager:missing_suit_variations(global_value, category, player_style, suit_variation)
	return not managers.blackmarket:suit_variation_unlocked(player_style, suit_variation)
end

-- Lines 140-143
function InfamyManager:missing_gloves(global_value, category, glove_id)
	return not managers.blackmarket:glove_id_unlocked(glove_id)
end

-- Lines 147-168
function InfamyManager:unlock_item(item)
	local infamy_item = tweak_data.infamy.items[item]

	if not infamy_item then
		debug_pause("InfamyManager:unlock_item]: Missing item = '" .. tostring(item) .. "'")

		return
	end

	if self:available(item) and not self:owned(item) then
		for bonus, entry in ipairs(infamy_item.upgrades) do
			local reward_func = self["reward_" .. tostring(entry[2])] or self.reward_item

			reward_func(self, unpack(entry))
		end

		if infamy_item.upgrades.join_stingers then
			for _, stinger_id in ipairs(infamy_item.upgrades.join_stingers) do
				self:unlock_join_stinger(stinger_id)
			end
		end

		self._global.unlocks[item] = true
	end
end

-- Lines 170-172
function InfamyManager:owned(item)
	return self._global.unlocks[item] or false
end

-- Lines 174-183
function InfamyManager:available(item)
	local current_rank = managers.experience:current_rank()

	for tree_rank, name in pairs(tweak_data.infamy.tree) do
		if item == name then
			return tree_rank <= current_rank
		end
	end

	return false
end

-- Lines 185-190
function InfamyManager:select_join_stinger(join_stinger)
	local stinger_data = self._global.join_stingers[join_stinger]

	if stinger_data and stinger_data.unlocked then
		self._global.selected_join_stinger = join_stinger
	end
end

-- Lines 192-194
function InfamyManager:selected_join_stinger()
	return self._global.selected_join_stinger
end

-- Lines 196-199
function InfamyManager:selected_join_stinger_index()
	local stinger_data = self._global.join_stingers[self._global.selected_join_stinger]

	return stinger_data and stinger_data.index or 0
end

-- Lines 201-204
function InfamyManager:is_join_stinger_unlocked(stinger_id)
	local stinger_data = self._global.join_stingers[stinger_id]

	return stinger_data and stinger_data.unlocked or false
end

-- Lines 206-214
function InfamyManager:unlock_join_stinger(stinger_id)
	local stinger_data = self._global.join_stingers[stinger_id]

	if stinger_data then
		stinger_data.unlocked = true

		if not self._global.selected_join_stinger then
			self._global.selected_join_stinger = stinger_id
		end
	end
end

-- Lines 216-228
function InfamyManager:get_unlocked_join_stingers()
	local unlocked_stingers = {}
	local stinger_data = nil

	for index = 0, tweak_data.infamy.join_stingers do
		stinger_data = self._global.join_stingers[index]

		if stinger_data.unlocked then
			table.insert(unlocked_stingers, index)
		end
	end

	return unlocked_stingers
end

-- Lines 230-240
function InfamyManager:get_all_join_stingers()
	local all_stingers = {}
	local join_stinger_data = nil

	for index = 0, tweak_data.infamy.join_stingers do
		join_stinger_data = self._global.join_stingers[index]

		table.insert(all_stingers, {
			id = index,
			unlocked = join_stinger_data.unlocked
		})
	end

	return all_stingers
end

-- Lines 242-245
function InfamyManager:get_join_stinger_name_id(stinger_name)
	local item_id = string.format("infamy_stinger_%03d", stinger_name)

	return "menu_" .. item_id .. "_name"
end

-- Lines 247-256
function InfamyManager:get_infamy_card_id_and_rect()
	local texture_id = "guis/dlcs/infamous/textures/pd2/infamous_tree/infamy_card_display"
	local inf_rank = math.min(managers.experience:current_rank(), tweak_data.infamy.ranks - 1) - 1
	local x_pos = 38 + (inf_rank - inf_rank % 100 - (inf_rank - inf_rank % 400)) / 100 * 256
	local y_pos = (inf_rank - inf_rank % 400) / 400 * 256
	local texture_rect = {
		x_pos,
		y_pos,
		180,
		256
	}

	return texture_id, texture_rect
end

-- Lines 258-263
function InfamyManager:reset_items()
	self:_reset_points()

	self._global.VERSION = InfamyManager.VERSION
	self._global.reset_message = true
end

-- Lines 265-273
function InfamyManager:check_reset_message()
	local show_reset_message = self._global.reset_message and true or false

	if show_reset_message then
		managers.menu:show_infamytree_reseted()

		self._global.reset_message = false

		MenuCallbackHandler:save_progress()
	end
end

-- Lines 275-286
function InfamyManager:save(data)
	local state = {
		points = self._global.points,
		unlocks = self._global.unlocks,
		selected_join_stinger = self._global.selected_join_stinger,
		VERSION = self._global.VERSION or 0,
		reset_message = self._global.reset_message
	}
	data.InfamyManager = state
end

-- Lines 288-340
function InfamyManager:load(data, version)
	local state = data.InfamyManager

	if state then
		self._global.points = state.points
		self._global.selected_join_stinger = state.selected_join_stinger
		local infamy_item = nil

		for item_id, unlocked in pairs(state.unlocks) do
			self._global.unlocks[item_id] = unlocked

			if unlocked then
				infamy_item = tweak_data.infamy.items[item_id]

				if infamy_item then
					for bonus, entry in ipairs(infamy_item.upgrades) do
						local missing_func = self["missing_" .. tostring(entry[2])] or self.missing_item

						if missing_func(self, unpack(entry)) then
							local reward_func = self["reward_" .. tostring(entry[2])] or self.reward_item

							reward_func(self, unpack(entry))
						end
					end

					if infamy_item.upgrades.join_stingers then
						for _, stinger_id in ipairs(infamy_item.upgrades.join_stingers) do
							self:unlock_join_stinger(stinger_id)
						end
					end
				end
			end
		end

		self._global.VERSION = state.VERSION
		self._global.reset_message = state.reset_message

		if not self._global.VERSION or self._global.VERSION < InfamyManager.VERSION then
			managers.savefile:add_load_done_callback(callback(self, self, "reset_items"))
		end

		self:_verify_loaded_data()
	end
end

-- Lines 342-367
function InfamyManager:_verify_loaded_data()
	local tree_map = {}

	for i, item in ipairs(tweak_data.infamy.tree) do
		tree_map[item] = i
	end

	for item, unlocked in pairs(clone(self._global.unlocks)) do
		if not tweak_data.infamy.items[item] then
			Application:error("[InfamyManager:_verify_loaded_data] Removing non-existing Infamy Item", item)

			self._global.unlocks[item] = nil
		elseif not tree_map[item] then
			Application:error("[InfamyManager:_verify_loaded_data] Removing unused Infamy Item", item)

			self._global.unlocks[item] = nil
		end
	end

	if not self:is_join_stinger_unlocked(self._global.selected_join_stinger) then
		self._global.selected_join_stinger = nil

		for id, data in pairs(self._global.join_stingers) do
			if data.unlocked then
				self._global.selected_join_stinger = id

				break
			end
		end
	end
end

-- Lines 369-372
function InfamyManager:reset()
	Global.infamy_manager = nil

	self:_setup()
end
