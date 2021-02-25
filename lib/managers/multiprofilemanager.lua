MultiProfileManager = MultiProfileManager or class()

-- Lines 3-11
function MultiProfileManager:init()
	if not Global.multi_profile then
		Global.multi_profile = {}
	end

	self._global = self._global or Global.multi_profile
	self._global._profiles = self._global._profiles or {}
	self._global._current_profile = self._global._current_profile or 1

	self:_check_amount()
end

-- Lines 13-55
function MultiProfileManager:save_current()
	print("[MultiProfileManager:save_current] current profile:", self._global._current_profile)

	local profile = self:current_profile() or {}
	local blm = managers.blackmarket
	local skt = managers.skilltree._global
	profile.primary = blm:equipped_weapon_slot("primaries")
	profile.secondary = blm:equipped_weapon_slot("secondaries")
	profile.melee = blm:equipped_melee_weapon()
	profile.throwable = blm:equipped_grenade()
	profile.deployable = blm:equipped_deployable()
	profile.deployable_secondary = blm:equipped_deployable(2)
	profile.armor = blm:equipped_armor()
	profile.armor_skin = blm:equipped_armor_skin()
	profile.player_style = blm:equipped_player_style()
	profile.suit_variations = blm:get_suit_variations()
	profile.glove_id = blm:equipped_glove_id()
	profile.skillset = skt.selected_skill_switch
	profile.perk_deck = Application:digest_value(skt.specializations.current_specialization, false)
	profile.mask = blm:equipped_mask_slot()
	profile.henchmen_loadout = {}
	profile.preferred_henchmen = {}

	for i = 1, CriminalsManager.MAX_NR_TEAM_AI do
		profile.henchmen_loadout[i] = deep_clone(managers.blackmarket:henchman_loadout(i))
		profile.preferred_henchmen[i] = blm:preferred_henchmen(i)
	end

	profile.join_stinger = managers.infamy:selected_join_stinger()
	self._global._profiles[self._global._current_profile] = profile

	print("[MultiProfileManager:save_current] done")
end

-- Lines 57-127
function MultiProfileManager:load_current()
	Global.block_update_outfit_information = true
	Global.block_publish_equipped_to_steam = true
	local profile = self:current_profile()
	local blm = managers.blackmarket
	local skt = managers.skilltree

	skt:switch_skills(profile.skillset)
	managers.player:check_skills()
	skt:set_current_specialization(profile.perk_deck)
	blm:equip_weapon("primaries", profile.primary)
	blm:equip_weapon("secondaries", profile.secondary)
	blm:equip_melee_weapon(profile.melee)
	blm:equip_grenade(profile.throwable)
	blm:equip_deployable({
		target_slot = 1,
		name = profile.deployable
	})
	blm:equip_deployable({
		target_slot = 2,
		name = profile.deployable_secondary
	})
	blm:equip_armor(profile.armor)
	blm:set_equipped_armor_skin(profile.armor_skin)
	blm:set_equipped_player_style(profile.player_style or blm:get_default_player_style())
	blm:set_suit_variations(profile.suit_variations or {})
	blm:set_equipped_glove_id(profile.glove_id or blm:get_default_glove_id())
	blm:equip_mask(profile.mask)

	for i = 1, CriminalsManager.MAX_NR_TEAM_AI do
		if profile.henchmen_loadout and profile.henchmen_loadout[i] then
			blm:set_henchman_loadout(i, profile.henchmen_loadout[i])
		end

		if profile.preferred_henchmen and profile.preferred_henchmen[i] then
			blm:set_preferred_henchmen(i, profile.preferred_henchmen[i])
		end
	end

	managers.infamy:select_join_stinger(profile.join_stinger)

	local mcm = managers.menu_component

	if mcm._player_inventory_gui then
		local node = mcm._player_inventory_gui._node

		mcm:close_inventory_gui()
		mcm:create_inventory_gui(node)
	elseif mcm._mission_briefing_gui then
		managers.assets:on_profile_switch()
		managers.preplanning:on_multi_profile_changed()

		local node = mcm._mission_briefing_gui._node

		mcm:close_mission_briefing_gui()
		mcm:create_mission_briefing_gui(node)
	end

	Global.block_update_outfit_information = nil
	Global.block_publish_equipped_to_steam = nil

	MenuCallbackHandler:_update_outfit_information()

	if SystemInfo:distribution() == Idstring("STEAM") then
		managers.statistics:publish_equipped_to_steam()
	end
end

-- Lines 129-134
function MultiProfileManager:current_profile_name()
	if not self:current_profile() then
		return "Error"
	end

	return self:current_profile().name or "Profile " .. self._global._current_profile
end

-- Lines 136-138
function MultiProfileManager:profile_count()
	return math.max(#self._global._profiles, 1)
end

-- Lines 140-153
function MultiProfileManager:set_current_profile(index)
	if index < 0 or self:profile_count() < index then
		return
	end

	if index == self._global._current_profile then
		return
	end

	self:save_current()

	self._global._current_profile = index

	self:load_current()
	print("[MultiProfileManager:set_current_profile] current profile:", self._global._current_profile)
end

-- Lines 155-157
function MultiProfileManager:current_profile()
	return self:profile(self._global._current_profile)
end

-- Lines 159-161
function MultiProfileManager:profile(index)
	return self._global._profiles[index]
end

-- Lines 163-167
function MultiProfileManager:_add_profile(profile, index)
	index = index or #self._global._profiles + 1
	self._global._profiles[index] = profile
end

-- Lines 169-171
function MultiProfileManager:next_profile()
	self:set_current_profile(self._global._current_profile + 1)
end

-- Lines 173-175
function MultiProfileManager:previous_profile()
	self:set_current_profile(self._global._current_profile - 1)
end

-- Lines 177-179
function MultiProfileManager:has_next()
	return self._global._current_profile < self:profile_count()
end

-- Lines 181-183
function MultiProfileManager:has_previous()
	return self._global._current_profile > 1
end

-- Lines 185-231
function MultiProfileManager:open_quick_select()
	local dialog_data = {
		title = "",
		text = "",
		button_list = {}
	}

	for idx, profile in pairs(self._global._profiles) do
		local text = profile.name or "Profile " .. idx

		table.insert(dialog_data.button_list, {
			text = text,
			callback_func = function ()
				self:set_current_profile(idx)
			end,
			focus_callback_func = function ()
			end
		})
	end

	local divider = {
		no_text = true,
		no_selection = true
	}

	table.insert(dialog_data.button_list, divider)

	local no_button = {
		text = managers.localization:text("dialog_cancel"),
		focus_callback_func = function ()
		end,
		cancel_button = true
	}

	table.insert(dialog_data.button_list, no_button)

	dialog_data.image_blend_mode = "normal"
	dialog_data.text_blend_mode = "add"
	dialog_data.use_text_formating = true
	dialog_data.w = 480
	dialog_data.h = 532
	dialog_data.title_font = tweak_data.menu.pd2_medium_font
	dialog_data.title_font_size = tweak_data.menu.pd2_medium_font_size
	dialog_data.font = tweak_data.menu.pd2_small_font
	dialog_data.font_size = tweak_data.menu.pd2_small_font_size
	dialog_data.text_formating_color = Color.white
	dialog_data.text_formating_color_table = {}
	dialog_data.clamp_to_screen = true

	managers.system_menu:show_buttons(dialog_data)
end

-- Lines 233-239
function MultiProfileManager:save(data)
	local save_data = deep_clone(self._global._profiles)
	save_data.current_profile = self._global._current_profile
	data.multi_profile = save_data
end

-- Lines 241-250
function MultiProfileManager:load(data)
	if data.multi_profile then
		for i, profile in ipairs(data.multi_profile) do
			self:_add_profile(profile, i)
		end

		self._global._current_profile = data.multi_profile.current_profile
	end

	self:_check_amount()
end

-- Lines 252-264
function MultiProfileManager:reset()
	local name = nil
	local current_profile = self._global._current_profile

	for idx, profile in pairs(self._global._profiles) do
		name = profile.name
		self._global._current_profile = idx

		self:save_current()

		self:current_profile().name = nil
	end

	self._global._current_profile = current_profile
end

-- Lines 266-270
function MultiProfileManager:infamy_reset()
	for idx, profile in pairs(self._global._profiles) do
		profile.skillset = 1
	end
end

-- Lines 272-292
function MultiProfileManager:_check_amount()
	local wanted_amount = 15

	if not self:current_profile() then
		self:save_current()
	end

	if wanted_amount < self:profile_count() then
		table.crop(self._global._profiles, wanted_amount)

		self._global._current_profile = math.min(self._global._current_profile, wanted_amount)
	elseif self:profile_count() < wanted_amount then
		local prev_current = self._global._current_profile
		self._global._current_profile = self:profile_count()

		while self._global._current_profile < wanted_amount do
			self._global._current_profile = self._global._current_profile + 1

			self:save_current()
		end

		self._global._current_profile = prev_current
	end
end
