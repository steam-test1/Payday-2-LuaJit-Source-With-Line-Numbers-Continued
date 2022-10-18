FeatureManager = FeatureManager or class()

-- Lines 3-5
function FeatureManager:init()
	self:_setup()
end

-- Lines 7-84
function FeatureManager:_setup()
	self._default = {
		announcements = {}
	}
	self._default.announcements.crimenet_heat = 3
	self._default.announcements.election_changes = 1
	self._default.announcements.crimenet_welcome = 0
	self._default.announcements.dlc_gage_pack_jobs = 1
	self._default.announcements.blackmarket_rename = 1
	self._default.announcements.join_pd2_clan = 50
	self._default.announcements.perk_deck = 3
	self._default.announcements.freed_old_hoxton = 1
	self._default.announcements.infamy_2_0 = 1
	self._default.announcements.thq_feature = 1
	self._default.announcements.crimenet_hacked = 1
	self._default.announcements.short_heist = 1
	self._default.announcements.short_heists_available = 1
	self._default.announcements.new_career = 1
	self._default.announcements.safehouse_dailies = 1
	self._default.announcements.tango_weapon_unlocked = 1
	self._default.announcements.movie_theater_unlocked = 1
	self._default.external_notifications = {
		dialog_texas_heat_drop_name = {
			"rat_oilbaron",
			"rat_ranchdiesel",
			"rat_mocow"
		},
		dialog_sbzacc_drop_name = {
			"prim_primtime",
			"prim_darkmat",
			"prim_newhorizon"
		}
	}

	if not Global.feature_manager then
		self:reset()
	end

	self._global = Global.feature_manager
end

-- Lines 86-94
function FeatureManager:save(data)
	Application:debug("[FeatureManager:save]")

	local save_data = {
		announcements = deep_clone(self._global.announcements),
		external_notifications = deep_clone(self._global.external_notifications)
	}
	data.feature_manager = save_data
end

-- Lines 96-116
function FeatureManager:load(data, version)
	Application:debug("[FeatureManager:load]")

	for announcement, default in pairs(self._default.announcements) do
		Global.feature_manager.announcements[announcement] = default
	end

	if data.feature_manager then
		local announcements = data.feature_manager.announcements or {}

		for announcement, num in pairs(announcements) do
			Global.feature_manager.announcements[announcement] = num
		end
	end

	if data.feature_manager then
		Global.feature_manager.external_notifications = data.feature_manager.external_notifications or {}
	else
		Global.feature_manager.external_notifications = {}
	end
end

-- Lines 118-147
function FeatureManager:reset()
	Global.feature_manager = {
		announcements = {}
	}

	for id, _ in pairs(self._default.announcements) do
		Global.feature_manager.announcements[id] = 0
	end

	Global.feature_manager.announcements.crimenet_welcome = 3
	Global.feature_manager.announcements.dlc_gage_pack_jobs = 1
	Global.feature_manager.announcements.join_pd2_clan = 50
	Global.feature_manager.announcements.freed_old_hoxton = 1
	Global.feature_manager.announcements.short_heist = 1
	Global.feature_manager.announcements.short_heists_available = 1
	Global.feature_manager.announcements.new_career = 1
	Global.feature_manager.announced = {}
	Global.feature_manager.external_notifications = {}
	self._global = Global.feature_manager
end

-- Lines 149-166
function FeatureManager:can_announce(feature_id)
	local announcement = self._global.announcements[feature_id]

	if not announcement then
		return false
	end

	if self._global.announced[feature_id] then
		return false
	end

	if type(announcement) ~= "number" then
		self._global.announcements[feature_id] = 0

		return false
	end

	if announcement <= 0 then
		return false
	end

	return true
end

-- Lines 168-198
function FeatureManager:announce_feature(feature_id)
	if Global.skip_menu_dialogs then
		return
	end

	local announcement = self._global.announcements[feature_id]

	if not announcement then
		return
	end

	if self._global.announced[feature_id] then
		print("[FeatureManager:announce_feature] Feture already announced.", feature_id)

		return
	end

	if type(announcement) ~= "number" then
		self._global.announcements[feature_id] = 0

		return
	end

	if announcement <= 0 then
		return
	end

	local func = self[feature_id]

	if not func or not func() then
		Application:error("[FeatureManager:announce_feature] Failed announcing feature!", feature_id)
	end

	announcement = announcement - 1
	self._global.announcements[feature_id] = announcement
	self._global.announced[feature_id] = true
end

-- Lines 200-206
function FeatureManager:set_feature_announce_times(feature_id, num)
	local announcement = self._global.announcements[feature_id]

	if not announcement then
		return
	end

	self._global.announcements[feature_id] = num
end

-- Lines 212-216
function FeatureManager:crimenet_heat()
	print("FeatureManager:crimenet_heat()")
	managers.menu:show_announce_crimenet_heat()

	return true
end

-- Lines 218-222
function FeatureManager:election_changes()
	print("FeatureManager:election_changes()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_election_changes_desc",
		title = "menu_feature_election_changes_title"
	})

	return true
end

-- Lines 224-228
function FeatureManager:crimenet_welcome()
	print("FeatureManager:crimenet_welcome()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_crimenet_welcome_desc",
		title = "menu_feature_crimenet_welcome_title"
	})

	return true
end

-- Lines 230-234
function FeatureManager:dlc_gage_pack_jobs()
	print("FeatureManager:dlc_gage_pack_jobs()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_crimenet_thanks_gagemod_desc",
		title = "menu_feature_crimenet_thanks_gagemod"
	})

	return true
end

-- Lines 236-240
function FeatureManager:blackmarket_rename()
	print("FeatureManager:blackmarket_rename()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_blackmarket_rename_desc",
		title = "menu_feature_blackmarket_rename"
	})

	return true
end

-- Lines 242-268
function FeatureManager:join_pd2_clan()
	print("FeatureManager:join_pd2_clan()")

	local params = {
		texture = false,
		video = "movies/join_community",
		text = "menu_feature_join_pd2_clan_desc",
		image_blend_mode = "add",
		title = "menu_feature_join_pd2_clan",
		video_loop = true,
		formating_color = tweak_data.screen_colors.button_stage_2
	}
	local ok_button = {
		text = managers.localization:text("dialog_ok"),
		cancel_button = true
	}
	local joining_pd2_clan_button = {
		text = managers.localization:text("dialog_join_pd2_clan"),
		callback_func = function ()
			if MenuCallbackHandler:is_overlay_enabled() then
				Steam:overlay_activate("game", "OfficialGameGroup")
			else
				managers.menu:show_enable_steam_overlay()
			end
		end
	}
	params.button_list = {
		joining_pd2_clan_button,
		ok_button
	}
	params.focus_button = 1

	managers.menu:show_video_message_dialog(params)

	return true
end

-- Lines 270-274
function FeatureManager:perk_deck()
	print("FeatureManager:perk_deck()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_perk_deck_desc",
		title = "menu_feature_perk_deck"
	})

	return true
end

-- Lines 276-280
function FeatureManager:freed_old_hoxton()
	print("FeatureManager:freed_old_hoxton()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_freed_old_hoxton_desc",
		title = "menu_feature_freed_old_hoxton"
	})

	return true
end

-- Lines 282-286
function FeatureManager:infamy_2_0()
	print("FeatureManager:infamy_2_0()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_infamy_2_0_desc",
		title = "menu_feature_infamy_2_0"
	})

	return true
end

-- Lines 288-312
function FeatureManager:thq_feature()
	print("FeatureManager:thq_feature()")

	if managers.user:get_setting("use_thq_weapon_parts") then
		return
	end

	-- Lines 294-297
	local function yes_function()
		managers.user:set_setting("use_thq_weapon_parts", true)
		managers.savefile:save_setting(true)
	end

	local button_list = {}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = yes_function
	}
	local no_button = {
		text = managers.localization:text("dialog_no")
	}
	button_list = {
		yes_button,
		no_button
	}

	managers.menu:show_new_message_dialog({
		text = "dialog_feature_thq",
		title = "dialog_feature_thq_title",
		button_list = button_list
	})

	return true
end

-- Lines 314-318
function FeatureManager:crimenet_hacked()
	print("FeatureManager:crimenet_hacked()")
	managers.crimenet:set_getting_hacked(42.16)

	return true
end

-- Lines 321-341
function FeatureManager:short_heist()
	print("FeatureManager:short_heist()")

	-- Lines 324-331
	local function yes_func()
		if SystemInfo:distribution() == Idstring("STEAM") then
			managers.statistics:publish_custom_stat_to_steam("info_playing_tutorial_yes")
		end

		managers.system_menu:force_close_all()
		MenuCallbackHandler:play_short_heist()
	end

	-- Lines 333-337
	local function no_func()
		if SystemInfo:distribution() == Idstring("STEAM") then
			managers.statistics:publish_custom_stat_to_steam("info_playing_tutorial_no")
		end
	end

	managers.menu:show_question_start_short_heist({
		yes_func = yes_func,
		no_func = no_func
	})

	return true
end

-- Lines 343-347
function FeatureManager:short_heists_available()
	print("FeatureManager:short_heists_available()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_short_heists_available_desc",
		title = "menu_feature_short_heists_available"
	})

	return true
end

-- Lines 351-354
function FeatureManager:new_career()
	print("FeatureManager:new_career()")
	managers.menu:show_new_player_popup()
end

-- Lines 358-362
function FeatureManager:safehouse_dailies()
	print("FeatureManager:safehouse_dailies()")
	managers.menu:show_new_message_dialog({
		text = "menu_cs_daily_desc",
		title = "menu_cs_daily_title"
	})

	return true
end

-- Lines 366-370
function FeatureManager:tango_weapon_unlocked()
	print("FeatureManager:tango_weapon_unlocked()")
	managers.tango:announce_tango_weapon()

	return true
end

-- Lines 374-377
function FeatureManager:movie_theater_unlocked()
	managers.menu:show_movie_theater_unlocked_dialog()

	return true
end

-- Lines 388-391
function FeatureManager:pda9_event_explanation()
	managers.menu:show_pda9_event_dialog()

	return true
end

-- Lines 397-414
function FeatureManager:check_external_dlcs()
	local announce_drops = {}
	local show_dialog = false

	for group_id, drops in pairs(self._default.external_notifications) do
		for index, drop_id in ipairs(drops) do
			if not self._global.external_notifications[drop_id] and managers.dlc:is_dlc_unlocked(drop_id) then
				self._global.external_notifications[drop_id] = true
				announce_drops[group_id] = announce_drops[group_id] or {}

				table.insert(announce_drops[group_id], drop_id)

				show_dialog = true
			end
		end
	end

	if show_dialog then
		managers.menu:show_external_items_dialog(announce_drops)
	end
end
