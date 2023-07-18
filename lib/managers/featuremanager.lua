FeatureManager = FeatureManager or class()

-- Lines 3-5
function FeatureManager:init()
	self:_setup()
end

-- Lines 7-99
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
	self._default.announcements.cg22_event_explanation = 1
	self._default.announcements.lron_event_explanation = 1
	self._default.announcements.lrtw_event_explanation = 1
	self._default.announcements.lrth_event_explanation = 1
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
		},
		dialog_texas_heat_drop_name = {
			"trt_railhat",
			"trt_railwork",
			"trt_railroad"
		},
		dialog_texas_halloween_name = {
			"h22_deadman",
			"h22_nightwalker",
			"h22_tasslefringe",
			"h22_bloodysnarl",
			"h22_ghostly",
			"h22_tornrags",
			"h22_banshee",
			"h22_darkprince",
			"h22_devilclaws",
			"h22_devilhorn"
		}
	}

	if not Global.feature_manager then
		self:reset()
	end

	self._global = Global.feature_manager
end

-- Lines 101-109
function FeatureManager:save(data)
	Application:debug("[FeatureManager:save]")

	local save_data = {
		announcements = deep_clone(self._global.announcements),
		external_notifications = deep_clone(self._global.external_notifications)
	}
	data.feature_manager = save_data
end

-- Lines 111-131
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

-- Lines 133-177
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
	Global.feature_manager.announcements.cg22_event_explanation = 1
	Global.feature_manager.announcements.lron_event_explanation = 1
	Global.feature_manager.announcements.lrtw_event_explanation = 1
	Global.feature_manager.announcements.lrth_event_explanation = 1
	Global.feature_manager.announced = {}
	Global.feature_manager.external_notifications = {}
	self._global = Global.feature_manager
end

-- Lines 179-196
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

-- Lines 198-228
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

-- Lines 230-236
function FeatureManager:set_feature_announce_times(feature_id, num)
	local announcement = self._global.announcements[feature_id]

	if not announcement then
		return
	end

	self._global.announcements[feature_id] = num
end

-- Lines 242-246
function FeatureManager:crimenet_heat()
	print("FeatureManager:crimenet_heat()")
	managers.menu:show_announce_crimenet_heat()

	return true
end

-- Lines 248-252
function FeatureManager:election_changes()
	print("FeatureManager:election_changes()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_election_changes_desc",
		title = "menu_feature_election_changes_title"
	})

	return true
end

-- Lines 254-258
function FeatureManager:crimenet_welcome()
	print("FeatureManager:crimenet_welcome()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_crimenet_welcome_desc",
		title = "menu_feature_crimenet_welcome_title"
	})

	return true
end

-- Lines 260-264
function FeatureManager:dlc_gage_pack_jobs()
	print("FeatureManager:dlc_gage_pack_jobs()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_crimenet_thanks_gagemod_desc",
		title = "menu_feature_crimenet_thanks_gagemod"
	})

	return true
end

-- Lines 266-270
function FeatureManager:blackmarket_rename()
	print("FeatureManager:blackmarket_rename()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_blackmarket_rename_desc",
		title = "menu_feature_blackmarket_rename"
	})

	return true
end

-- Lines 272-310
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
	local button_list = {}

	if SystemInfo:distribution() == Idstring("STEAM") then
		local joining_pd2_clan_button = {
			text = managers.localization:text("dialog_join_pd2_clan"),
			callback_func = function ()
				managers.network.account:overlay_activate("game", "OfficialGameGroup")
			end
		}

		table.insert(button_list, joining_pd2_clan_button)
	end

	local joining_nebula_button = {
		text = managers.localization:text("menu_no_sbz_account"),
		callback_func = function ()
			managers.network.account:overlay_activate("url", tweak_data.gui.sbz_account_webpage)
		end
	}

	table.insert(button_list, joining_nebula_button)
	table.insert(button_list, ok_button)

	params.button_list = button_list
	params.focus_button = 1

	managers.menu:show_video_message_dialog(params)

	return true
end

-- Lines 312-316
function FeatureManager:perk_deck()
	print("FeatureManager:perk_deck()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_perk_deck_desc",
		title = "menu_feature_perk_deck"
	})

	return true
end

-- Lines 318-322
function FeatureManager:freed_old_hoxton()
	print("FeatureManager:freed_old_hoxton()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_freed_old_hoxton_desc",
		title = "menu_feature_freed_old_hoxton"
	})

	return true
end

-- Lines 324-328
function FeatureManager:infamy_2_0()
	print("FeatureManager:infamy_2_0()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_infamy_2_0_desc",
		title = "menu_feature_infamy_2_0"
	})

	return true
end

-- Lines 330-354
function FeatureManager:thq_feature()
	print("FeatureManager:thq_feature()")

	if managers.user:get_setting("use_thq_weapon_parts") then
		return
	end

	-- Lines 336-339
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

-- Lines 356-360
function FeatureManager:crimenet_hacked()
	print("FeatureManager:crimenet_hacked()")
	managers.crimenet:set_getting_hacked(42.16)

	return true
end

-- Lines 363-383
function FeatureManager:short_heist()
	print("FeatureManager:short_heist()")

	-- Lines 366-373
	local function yes_func()
		if SystemInfo:distribution() == Idstring("STEAM") then
			managers.statistics:publish_custom_stat_to_steam("info_playing_tutorial_yes")
		end

		managers.system_menu:force_close_all()
		MenuCallbackHandler:play_short_heist()
	end

	-- Lines 375-379
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

-- Lines 385-389
function FeatureManager:short_heists_available()
	print("FeatureManager:short_heists_available()")
	managers.menu:show_new_message_dialog({
		text = "menu_feature_short_heists_available_desc",
		title = "menu_feature_short_heists_available"
	})

	return true
end

-- Lines 393-396
function FeatureManager:new_career()
	print("FeatureManager:new_career()")
	managers.menu:show_new_player_popup()
end

-- Lines 400-404
function FeatureManager:safehouse_dailies()
	print("FeatureManager:safehouse_dailies()")
	managers.menu:show_new_message_dialog({
		text = "menu_cs_daily_desc",
		title = "menu_cs_daily_title"
	})

	return true
end

-- Lines 408-412
function FeatureManager:tango_weapon_unlocked()
	print("FeatureManager:tango_weapon_unlocked()")
	managers.tango:announce_tango_weapon()

	return true
end

-- Lines 416-419
function FeatureManager:movie_theater_unlocked()
	managers.menu:show_movie_theater_unlocked_dialog()

	return true
end

-- Lines 430-433
function FeatureManager:pda9_event_explanation()
	managers.menu:show_pda9_event_dialog()

	return true
end

-- Lines 437-440
function FeatureManager:cg22_event_explanation()
	managers.menu:show_cg22_event_dialog()

	return true
end

-- Lines 444-447
function FeatureManager:lron_event_explanation()
	managers.menu:show_lron_dialog()

	return true
end

-- Lines 450-453
function FeatureManager:lrtw_event_explanation()
	managers.menu:show_lrtw_dialog()

	return true
end

-- Lines 456-459
function FeatureManager:lrth_event_explanation()
	managers.menu:show_lrth_dialog()

	return true
end

-- Lines 471-488
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
