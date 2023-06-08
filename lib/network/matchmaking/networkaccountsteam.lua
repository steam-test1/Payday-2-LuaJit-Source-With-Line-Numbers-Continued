require("lib/network/matchmaking/NetworkAccount")

NetworkAccountSTEAM = NetworkAccountSTEAM or class(NetworkAccount)
NetworkAccountSTEAM.lb_diffs = {
	hard = "Hard",
	overkill = "Very Hard",
	overkill_145 = "Overkill",
	normal = "Normal",
	easy_wish = "Easy Wish",
	overkill_290 = "Death Wish",
	sm_wish = "SM Wish",
	easy = "Easy"
}
NetworkAccountSTEAM.lb_levels = {
	slaughter_house = "Slaughterhouse",
	diamond_heist = "Diamond Heist",
	hospital = "No Mercy",
	suburbia = "Counterfeit",
	bridge = "Green Bridge",
	secret_stash = "Undercover",
	apartment = "Panic Room",
	bank = "First World Bank",
	heat_street = "Heat Street"
}

-- Lines 32-67
function NetworkAccountSTEAM:init()
	NetworkAccount.init(self)
	Steam:init()
	Steam:request_listener(NetworkAccountSTEAM._on_join_request, NetworkAccountSTEAM._on_server_request)
	Steam:error_listener(NetworkAccountSTEAM._on_disconnected, NetworkAccountSTEAM._on_ipc_fail, NetworkAccountSTEAM._on_connect_fail)
	Steam:overlay_listener(callback(self, self, "_on_open_overlay"), callback(self, self, "_on_close_overlay"))

	if SystemInfo:matchmaking() == Idstring("MM_EPIC") and Steam.set_connect_string then
		self.connect_string = "-join_game"

		Steam:set_connect_string(self.connect_string)
	end

	self._gamepad_text_listeners = {}

	if Steam:overlay_open() then
		self:_on_open_overlay()
	end

	Steam:sa_handler():stats_store_callback(NetworkAccountSTEAM._on_stats_stored)
	Steam:sa_handler():init()
	self:_set_presences()
	managers.savefile:add_load_done_callback(callback(self, self, "_load_done"))
	Steam:lb_handler():register_storage_done_callback(NetworkAccountSTEAM._on_leaderboard_stored)
	Steam:lb_handler():register_mappings_done_callback(NetworkAccountSTEAM._on_leaderboard_mapped)
	self:inventory_load()
end

-- Lines 69-72
function NetworkAccountSTEAM:_load_done(...)
	print("NetworkAccountSTEAM:_load_done()", ...)
	self:_set_presences()
end

-- Lines 74-76
function NetworkAccountSTEAM:update()
	self:_chk_inventory_outfit_refresh()
end

-- Lines 78-90
function NetworkAccountSTEAM:_set_presences()
	managers.platform:set_rich_presence("level", managers.experience:current_level())

	if MenuCallbackHandler:is_modded_client() then
		managers.platform:set_rich_presence("is_modded", 1)
	else
		managers.platform:set_rich_presence("is_modded", 0)
	end
end

-- Lines 92-94
function NetworkAccountSTEAM:set_presences_peer_id(peer_id)
	managers.platform:set_rich_presence("peer_id", peer_id)
end

-- Lines 97-114
function NetworkAccountSTEAM:get_win_ratio(difficulty, level)
	local plays = Steam:sa_handler():get_global_stat(difficulty .. "_" .. level .. "_plays", 30)
	local wins = Steam:sa_handler():get_global_stat(difficulty .. "_" .. level .. "_wins", 30)
	local ratio = {}

	if #plays == 0 or #wins == 0 then
		return
	end

	for i, plays_n in pairs(plays) do
		ratio[i] = wins[i] / (plays_n == 0 and 1 or plays_n)
	end

	table.sort(ratio)

	return ratio[#ratio / 2]
end

-- Lines 116-124
function NetworkAccountSTEAM._on_troll_group_recieved(success, page)
	if success and string.find(page, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
		managers.network.account._masks.troll = true
	end

	HttpRequest:get("http://steamcommunity.com/gid/103582791432592205/memberslistxml/?xml=1", NetworkAccountSTEAM._on_com_group_recieved)
end

-- Lines 126-134
function NetworkAccountSTEAM._on_com_group_recieved(success, page)
	if success and string.find(page, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
		managers.network.account._masks.hockey_com = true
	end

	HttpRequest:get("http://steamcommunity.com/gid/103582791432508229/memberslistxml/?xml=1", NetworkAccountSTEAM._on_dev_group_recieved)
end

-- Lines 136-142
function NetworkAccountSTEAM._on_dev_group_recieved(success, page)
	if success and string.find(page, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
		managers.network.account._masks.developer = true
	end
end

-- Lines 144-146
function NetworkAccountSTEAM:is_overlay_enabled()
	return Steam:overlay_enabled() or false
end

-- Lines 148-154
function NetworkAccountSTEAM:overlay_activate(...)
	if self:is_overlay_enabled() then
		Steam:overlay_activate(...)
	else
		managers.menu:show_enable_steam_overlay()
	end
end

-- Lines 156-163
function NetworkAccountSTEAM:_on_open_overlay()
	if self._overlay_opened then
		return
	end

	self._overlay_opened = true

	self:_call_listeners("overlay_open")
	game_state_machine:_set_controller_enabled(false)
end

-- Lines 165-176
function NetworkAccountSTEAM:_on_close_overlay()
	if not self._overlay_opened then
		return
	end

	self._overlay_opened = false

	self:_call_listeners("overlay_close")
	game_state_machine:_set_controller_enabled(true)
	managers.dlc:chk_content_updated()
	Entitlement:CheckAndVerifyUserEntitlement()
end

-- Lines 178-184
function NetworkAccountSTEAM:_on_gamepad_text_submitted(submitted, submitted_text)
	print("[NetworkAccountSTEAM:_on_gamepad_text_submitted]", "submitted", submitted, "submitted_text", submitted_text)

	for id, clbk in pairs(self._gamepad_text_listeners) do
		clbk(submitted, submitted_text)
	end

	self._gamepad_text_listeners = {}
end

-- Lines 186-208
function NetworkAccountSTEAM:show_gamepad_text_input(id, callback, params)
	return false
end

-- Lines 210-215
function NetworkAccountSTEAM:add_gamepad_text_listener(id, clbk)
	if self._gamepad_text_listeners[id] then
		debug_pause("[NetworkAccountSTEAM:add_gamepad_text_listener] ID already added!", id, "Old Clbk", self._gamepad_text_listeners[id], "New Clbk", clbk)
	end

	self._gamepad_text_listeners[id] = clbk
end

-- Lines 217-222
function NetworkAccountSTEAM:remove_gamepad_text_listener(id)
	if not self._gamepad_text_listeners[id] then
		debug_pause("[NetworkAccountSTEAM:remove_gamepad_text_listener] ID do not exist!", id)
	end

	self._gamepad_text_listeners[id] = nil
end

-- Lines 224-226
function NetworkAccountSTEAM:achievements_fetched()
	self._achievements_fetched = true
end

-- Lines 228-230
function NetworkAccountSTEAM:challenges_loaded()
	self._challenges_loaded = true
end

-- Lines 232-234
function NetworkAccountSTEAM:experience_loaded()
	self._experience_loaded = true
end

-- Lines 236-238
function NetworkAccountSTEAM._on_leaderboard_stored(status)
	print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard stored, ", status, ".")
end

-- Lines 240-244
function NetworkAccountSTEAM._on_leaderboard_mapped()
	print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard mapped.")
	Steam:lb_handler():request_storage()
end

-- Lines 246-265
function NetworkAccountSTEAM._on_stats_stored(status)
	print("[NetworkAccountSTEAM:_on_stats_stored] Statistics stored, ", status, ". Publishing leaderboard score to Steam!")
end

-- Lines 267-269
function NetworkAccountSTEAM:get_sa_handler()
	return Steam:sa_handler()
end

-- Lines 271-273
function NetworkAccountSTEAM:set_stat(key, value)
	Steam:sa_handler():set_stat(key, value)
end

-- Lines 275-277
function NetworkAccountSTEAM:get_stat(key)
	return Steam:sa_handler():get_stat(key)
end

-- Lines 280-282
function NetworkAccountSTEAM:has_stat(key)
	return Steam:sa_handler():has_stat(key)
end

-- Lines 284-287
function NetworkAccountSTEAM:achievement_unlock_time(key)
	local res = Steam:sa_handler():achievement_unlock_time(key)

	return res ~= -1 and res or nil
end

-- Lines 290-292
function NetworkAccountSTEAM:get_lifetime_stat(key)
	return Steam:sa_handler():get_lifetime_stat(key)
end

-- Lines 294-320
function NetworkAccountSTEAM:get_global_stat(key, days)
	local value = 0
	local global_stat = nil

	if days and days < 0 then
		local day = math.abs(days) + 1
		global_stat = Steam:sa_handler():get_global_stat(key, day)

		return global_stat[day] or 0
	elseif days then
		global_stat = Steam:sa_handler():get_global_stat(key, days == 1 and 1 or days + 1)

		for i = days > 1 and 2 or 1, #global_stat do
			value = value + global_stat[i]
		end
	else
		global_stat = Steam:sa_handler():get_global_stat(key)

		for _, day in ipairs(global_stat) do
			value = value + day
		end
	end

	return value
end

-- Lines 322-416
function NetworkAccountSTEAM:publish_statistics(stats, force_store)
	if managers.dlc:is_trial() then
		return
	end

	local handler = Steam:sa_handler()

	print("[NetworkAccountSTEAM:publish_statistics] Publishing statistics to Steam!")

	local err = false

	for key, stat in pairs(stats) do
		local res = nil

		if stat.type == "int" then
			local val = math.max(0, handler:get_stat(key))

			if stat.method == "lowest" then
				if stat.value < val then
					res = handler:set_stat(key, stat.value)
				else
					res = true
				end
			elseif stat.method == "highest" then
				if val < stat.value then
					res = handler:set_stat(key, stat.value)
				else
					res = true
				end
			elseif stat.method == "set" then
				res = handler:set_stat(key, math.clamp(stat.value, 0, 2147483000))
			elseif stat.value > 0 then
				local mval = val / 1000 + stat.value / 1000

				if mval >= 2147483 then
					Application:error("[NetworkAccountSTEAM:publish_statistics] Warning, trying to set too high a value on stat " .. key)

					res = handler:set_stat(key, 2147483000)
				else
					res = handler:set_stat(key, val + stat.value)
				end
			else
				res = true
			end
		elseif stat.type == "float" then
			if stat.value > 0 then
				local val = handler:get_stat_float(key)
				res = handler:set_stat_float(key, val + stat.value)
			else
				res = true
			end
		elseif stat.type == "avgrate" then
			res = handler:set_stat_float(key, stat.value, stat.hours)
		end

		if not res then
			Application:error("[NetworkAccountSTEAM:publish_statistics] Error, could not set stat " .. key)

			err = true
		end
	end

	if not err then
		handler:store_data()
	end
end

-- Lines 418-432
function NetworkAccountSTEAM._on_disconnected(lobby_id, friend_id)
	print("[NetworkAccountSTEAM._on_disconnected]", lobby_id, friend_id)

	if Application:editor() then
		return
	end

	Application:warn("Disconnected from Steam!! Please wait", 12)

	local cur_game_state = game_state_machine and game_state_machine:current_state()

	if cur_game_state and cur_game_state.on_disconnected_from_service then
		cur_game_state:on_disconnected_from_service()
	end
end

-- Lines 434-436
function NetworkAccountSTEAM._on_ipc_fail(lobby_id, friend_id)
	print("[NetworkAccountSTEAM._on_ipc_fail]")
end

-- Lines 439-467
function NetworkAccountSTEAM._on_join_request(lobby_id, friend_id)
	print("[NetworkAccountSTEAM._on_join_request]")

	if managers.network.matchmake.lobby_handler and managers.network.matchmake.lobby_handler:id() == lobby_id then
		return
	end

	if managers.network:session() and managers.network:session():_local_peer_in_lobby() then
		Global.game_settings.single_player = false

		MenuCallbackHandler:_dialog_leave_lobby_yes()
		managers.network.matchmake:set_join_invite_pending(lobby_id)

		return
	elseif game_state_machine:current_state_name() ~= "menu_main" then
		print("INGAME INVITE")

		Global.game_settings.single_player = false
		Global.boot_invite = lobby_id

		MenuCallbackHandler:_dialog_end_game_yes()

		return
	else
		if not Global.user_manager.user_index or not Global.user_manager.active_user_state_change_quit then
			print("BOOT UP INVITE")

			Global.boot_invite = lobby_id

			return
		end

		Global.game_settings.single_player = false

		managers.network.matchmake:join_server_with_check(lobby_id, true)
	end
end

-- Lines 469-472
function NetworkAccountSTEAM._on_server_request(ip, pw)
	print("[NetworkAccountSTEAM._on_server_request]")
end

-- Lines 474-477
function NetworkAccountSTEAM._on_connect_fail(ip, pw)
	print("[NetworkAccountSTEAM._on_connect_fail]")
end

-- Lines 481-486
function NetworkAccountSTEAM:signin_state()
	if self:local_signin_state() == true then
		return "signed in"
	end

	return "not signed in"
end

-- Lines 488-490
function NetworkAccountSTEAM:local_signin_state()
	return Steam:logged_on()
end

-- Lines 492-494
function NetworkAccountSTEAM:username_id()
	return Steam:username()
end

-- Lines 496-498
function NetworkAccountSTEAM:username_by_id(id)
	return Steam:username(id)
end

-- Lines 500-502
function NetworkAccountSTEAM:player_id()
	return Steam:userid()
end

-- Lines 504-506
function NetworkAccountSTEAM:is_connected()
	return true
end

-- Lines 508-510
function NetworkAccountSTEAM:lan_connection()
	return true
end

-- Lines 512-514
function NetworkAccountSTEAM:set_playing(state)
	Steam:set_playing(state)
end

-- Lines 516-518
function NetworkAccountSTEAM:set_played_with(id)
	Steam:set_played_with(id)
end

-- Lines 520-527
function NetworkAccountSTEAM:get_friend_user(player_id)
	local friends = Steam:logged_on() and Steam:friends() or {}

	for _, friend in ipairs(friends) do
		if friend:id() == player_id then
			return friend
		end
	end
end

-- Lines 529-538
function NetworkAccountSTEAM:is_player_friend(player_id)
	local friends = Steam:logged_on() and Steam:friends() or {}

	for _, friend in ipairs(friends) do
		if friend:id() == player_id then
			return true
		end
	end

	return NetworkAccountSTEAM.super.is_player_friend(self, player_id)
end

-- Lines 540-550
function NetworkAccountSTEAM:_load_globals()
	if Global.steam and Global.steam.account then
		self._outfit_signature = Global.steam.account.outfit_signature and Global.steam.account.outfit_signature:get_data()

		if Global.steam.account.outfit_signature then
			Global.steam.account.outfit_signature:destroy()
		end

		Global.steam.account = nil
	end
end

-- Lines 552-557
function NetworkAccountSTEAM:_save_globals()
	Global.steam = Global.steam or {}
	Global.steam.account = {
		outfit_signature = self._outfit_signature and Application:create_luabuffer(self._outfit_signature)
	}
end

-- Lines 559-565
function NetworkAccountSTEAM:is_ready_to_close()
	return not self._inventory_is_loading and not self._inventory_outfit_refresh_requested and not self._inventory_outfit_refresh_in_progress
end

-- Lines 567-587
function NetworkAccountSTEAM:open_dlc_store_page(dlc_data, context)
	if dlc_data then
		if context == "buy_dlc" and dlc_data.webpage then
			return managers.network.account:overlay_activate("url", dlc_data.webpage)
		end

		if dlc_data.app_id then
			local url = string.format("https://store.steampowered.com/app/%s/?utm_source=%s&utm_medium=%s&utm_campaign=%s", tostring(dlc_data.app_id), "ingame", context and tostring(context) or "inventory", "ingameupsell")

			return self:overlay_activate("url", url)
		elseif dlc_data.source_id then
			return self:overlay_activate("game", "OfficialGameGroup")
		else
			return self:overlay_activate("url", tweak_data.gui.store_page)
		end
	end

	return false
end

-- Lines 589-594
function NetworkAccountSTEAM:open_new_heist_page(new_heist_data)
	if new_heist_data then
		return self:overlay_activate("url", new_heist_data.url)
	end

	return false
end

-- Lines 596-617
function NetworkAccountSTEAM:inventory_load()
	if self._inventory_is_loading then
		return
	end

	if self._inventory_is_converting_drills or self._inventory_is_converting_items then
		return
	end

	self._inventory_is_loading = true

	Steam:inventory_load(callback(self, self, "_clbk_inventory_load"))
end

-- Lines 619-625
function NetworkAccountSTEAM:inventory_is_loading()
	return self._inventory_is_loading or self._inventory_is_converting_drills or self._inventory_is_converting_items
end

-- Lines 627-643
function NetworkAccountSTEAM:inventory_reward(reward_callback, item)
	Steam:inventory_reward(reward_callback, item or 1)

	return true
end

-- Lines 645-679
function NetworkAccountSTEAM:inventory_reward_unlock(safe, safe_instance_id, drill_instance_id, reward_unlock_callback)
	local safe_tweak = tweak_data.economy.safes[safe]

	if not safe_tweak or not safe_tweak.content or not safe_tweak.drill then
		return
	end

	local drill_tweak = tweak_data.economy.drills[safe_tweak.drill]
	local content_tweak = tweak_data.economy.contents[safe_tweak.content]

	if not content_tweak or not drill_tweak then
		return
	end

	safe_instance_id = safe_instance_id or managers.blackmarket:tradable_instance_id("safes", safe)
	drill_instance_id = drill_instance_id or managers.blackmarket:tradable_instance_id("drills", safe_tweak.drill)
	local safe_item = managers.blackmarket:tradable_receive_item_by_instance_id(safe_instance_id)
	local drill_item = managers.blackmarket:tradable_receive_item_by_instance_id(drill_instance_id)

	if not safe_instance_id or not drill_instance_id then
		if reward_unlock_callback then
			reward_unlock_callback("invalid_open")
		end

		return
	end

	Steam:inventory_reward_unlock(safe_instance_id, drill_instance_id, content_tweak.def_id, reward_unlock_callback)
end

-- Lines 681-705
function NetworkAccountSTEAM:inventory_reward_open(safe, safe_instance_id, reward_unlock_callback)
	local safe_tweak = tweak_data.economy.safes[safe]
	local content_tweak = safe_tweak and tweak_data.economy.contents[safe_tweak.content]
	safe_instance_id = safe_instance_id or managers.blackmarket:tradable_instance_id("safes", safe)

	if not safe_instance_id then
		if reward_unlock_callback then
			reward_unlock_callback("invalid_open")
		end

		return
	end

	managers.blackmarket:tradable_receive_item_by_instance_id(safe_instance_id)
	Steam:inventory_reward_open(safe_instance_id, content_tweak.def_id, reward_unlock_callback)
end

-- Lines 707-722
function NetworkAccountSTEAM:inventory_reward_dlc(def_id, reward_promo_callback)
	Steam:inventory_reward_promo(def_id, reward_promo_callback)
end

-- Lines 724-733
function NetworkAccountSTEAM:inventory_outfit_refresh()
	self._inventory_outfit_refresh_requested = true
end

-- Lines 735-747
function NetworkAccountSTEAM:_inventory_outfit_refresh()
	local outfit = managers.blackmarket:tradable_outfit()

	print("[NetworkAccountSTEAM:_inventory_outfit_refresh]", "outfit: ", inspect(outfit))

	if table.size(outfit) > 0 then
		self._outfit_signature = nil
		self._inventory_outfit_refresh_in_progress = true

		Steam:inventory_signature_create(outfit, callback(self, self, "_clbk_tradable_outfit_data"))
	else
		self._outfit_signature = ""

		managers.network:session():check_send_outfit()
	end
end

-- Lines 749-761
function NetworkAccountSTEAM:_chk_inventory_outfit_refresh()
	if not self._inventory_outfit_refresh_requested then
		return
	end

	if self._inventory_outfit_refresh_in_progress then
		return
	end

	self._inventory_outfit_refresh_requested = nil

	self:_inventory_outfit_refresh()
end

-- Lines 763-769
function NetworkAccountSTEAM:inventory_outfit_verify(steam_id, outfit_data, outfit_callback)
	if outfit_data == "" then
		return outfit_callback and outfit_callback(nil, false, {})
	end

	Steam:inventory_signature_verify(steam_id, outfit_data, outfit_callback)
end

-- Lines 771-773
function NetworkAccountSTEAM:inventory_outfit_signature()
	return self._outfit_signature
end

-- Lines 775-793
function NetworkAccountSTEAM:_on_item_converted(error, items_new, items_removed)
	if not error then
		managers.blackmarket:tradable_exchange(items_new, items_removed)
	end

	self._inventory_is_converting_items = self._inventory_is_converting_items - 1
	self._item_convert_error = self._item_convert_error or error

	if self._inventory_is_converting_items == 0 then
		self._inventory_is_converting_items = nil

		managers.menu_component:set_blackmarket_tradable_loaded(self._item_convert_error)

		self._item_convert_error = nil

		if managers.menu_scene then
			managers.menu_scene:set_blackmarket_tradable_loaded()
		end
	end
end

-- Lines 795-824
function NetworkAccountSTEAM:inventory_repair_list(list)
	if list then
		self._inventory_is_converting_items = 0
		local item_convert = nil

		for _, item in pairs(list) do
			if not item.category or item.category == "" or not item.entry or item.entry == "" then
				print("[NetworkAccountSTEAM:inventory_repair_list] Item Def ID " .. tostring(item.def_id) .. " is missing information!")

				for category, category_data in pairs(tweak_data.economy) do
					for entry, entry_data in pairs(category_data) do
						if entry_data.def_id == item.def_id then
							item.category = category
							item.entry = entry

							print("[NetworkAccountSTEAM:inventory_repair_list] Item Def ID " .. tostring(item.def_id) .. " was repaired to " .. category .. "." .. entry)
						end
					end
				end
			end

			item_convert = tweak_data.economy.item_convert[item.def_id]

			if item_convert then
				Steam:inventory_reward_open(item.instance_id, item_convert.bundle_id, callback(self, self, "_on_item_converted"))

				self._inventory_is_converting_items = self._inventory_is_converting_items + 1
			end
		end

		if self._inventory_is_converting_items == 0 then
			self._inventory_is_converting_items = nil
		end
	end
end

-- Lines 826-848
function NetworkAccountSTEAM:_clbk_inventory_load(error, list)
	print("[NetworkAccountSTEAM:_clbk_inventory_load]", "error: ", error, "list: ", list)

	self._inventory_is_loading = nil

	if error then
		Application:error("[NetworkAccountSTEAM:_clbk_inventory_load] Failed to update tradable inventory (" .. tostring(error) .. ")")
	end

	if self.do_convert_drills then
		self:convert_drills_to_safes(list)

		self.do_convert_drills = false
	end

	self:inventory_repair_list(list)
	managers.blackmarket:tradable_update(list, not error)
	managers.menu_component:set_blackmarket_tradable_loaded(error)

	if managers.menu_scene then
		managers.menu_scene:set_blackmarket_tradable_loaded()
	end
end

-- Lines 850-867
function NetworkAccountSTEAM:_clbk_tradable_outfit_data(error, outfit_signature)
	print("[NetworkAccountSTEAM:_clbk_tradable_outfit_data] error: ", error, ", self._outfit_signature: ", self._outfit_signature, "\n outfit_signature: ", outfit_signature, "\n")

	self._inventory_outfit_refresh_in_progress = nil

	if self._inventory_outfit_refresh_requested then
		return
	end

	if error then
		Application:error("[NetworkAccountSTEAM:_clbk_tradable_outfit_data] Failed to check tradable inventory (" .. tostring(error) .. ")")
	end

	self._outfit_signature = outfit_signature

	if managers.network:session() then
		managers.network:session():check_send_outfit()
	end
end

-- Lines 870-890
function NetworkAccountSTEAM:_on_drill_converted(data, error, items_new, items_removed)
	local drills_to_convert, instance_id = unpack(data)
	drills_to_convert[instance_id] = nil

	if not error then
		managers.blackmarket:tradable_exchange(items_new, items_removed)
	end

	self._converting_drill_error = self._converting_drill_error or error

	if table.size(drills_to_convert) == 0 then
		self._inventory_is_converting_drills = nil

		managers.menu_component:set_blackmarket_tradable_loaded(self._converting_drill_error)

		self._converting_drill_error = nil

		if managers.menu_scene then
			managers.menu_scene:set_blackmarket_tradable_loaded()
		end
	end
end

-- Lines 892-924
function NetworkAccountSTEAM:convert_drills_to_safes(list)
	if not list then
		return
	end

	self._inventory_is_converting_drills = true
	local drills_to_convert = {}
	local drills_counter = {}
	local drill_tweak, safe_tweak = nil

	table.remove_condition(list, function (data)
		drill_tweak = data.category == "drills" and tweak_data.economy.drills[data.entry]
		safe_tweak = drill_tweak and tweak_data.economy.safes[drill_tweak.safe]

		if safe_tweak and safe_tweak.convert_drill then
			drills_to_convert[data.instance_id] = data.entry
			drills_counter[data.entry] = (drills_counter[data.entry] or 0) + 1

			Steam:inventory_reward_open(data.instance_id, safe_tweak.def_id, callback(self, self, "_on_drill_converted", {
				drills_to_convert,
				data.instance_id
			}))

			return true
		end

		return false
	end)

	if table.size(drills_to_convert) > 0 then
		managers.system_menu:force_close_all()
		managers.menu:show_accept_drills_to_safes(drills_to_convert, drills_counter)
	else
		self._inventory_is_converting_drills = false
	end
end

-- Lines 927-1046
function NetworkAccountSTEAM.output_global_stats(file)
	local num_days = 100
	local sa = Steam:sa_handler()
	local invalid = sa:get_global_stat("easy_slaughter_house_plays", num_days)
	invalid[1] = 1
	invalid[3] = 1
	invalid[11] = 1
	invalid[12] = 1
	invalid[19] = 1
	invalid[28] = 1
	invalid[51] = 1
	invalid[57] = 1

	-- Lines 943-965
	local function get_lvl_stat(diff, heist, stat, i)
		if i == 0 then
			local st = NetworkAccountSTEAM.lb_levels[heist] .. ", " .. NetworkAccountSTEAM.lb_diffs[diff] .. " - "

			if type(stat) == "string" then
				return st .. stat
			else
				return st .. stat[1] .. "/" .. stat[2]
			end
		end

		local num = nil

		if type(stat) == "string" then
			num = sa:get_global_stat(diff .. "_" .. heist .. "_" .. stat, num_days)[i] or 0
		else
			local f = sa:get_global_stat(diff .. "_" .. heist .. "_" .. stat[1], num_days)[i] or 0
			local s = sa:get_global_stat(diff .. "_" .. heist .. "_" .. stat[2], num_days)[i] or 1
			num = f / (s == 0 and 1 or s)
		end

		return num
	end

	-- Lines 968-990
	local function get_weapon_stat(weapon, stat, i)
		if i == 0 then
			local st = weapon .. " - "

			if type(stat) == "string" then
				return st .. stat
			else
				return st .. stat[1] .. "/" .. stat[2]
			end
		end

		local num = nil

		if type(stat) == "string" then
			num = sa:get_global_stat(weapon .. "_" .. stat, num_days)[i] or 0
		else
			local f = sa:get_global_stat(weapon .. "_" .. stat[1], num_days)[i] or 0
			local s = sa:get_global_stat(weapon .. "_" .. stat[2], num_days)[i] or 1
			num = f / (s == 0 and 1 or s)
		end

		return num
	end

	local diffs = {
		"easy",
		"normal",
		"hard",
		"overkill",
		"overkill_145",
		"easy_wish",
		"overkill_290",
		"sm_wish"
	}
	local heists = {
		"bank",
		"heat_street",
		"bridge",
		"apartment",
		"slaughter_house",
		"diamond_heist"
	}
	local weapons = {
		"beretta92",
		"c45",
		"raging_bull",
		"r870_shotgun",
		"mossberg",
		"m4",
		"mp5",
		"mac11",
		"m14",
		"hk21"
	}
	local lvl_stats = {
		"plays",
		{
			"wins",
			"plays"
		},
		{
			"kills",
			"plays"
		}
	}
	local wep_stats = {
		"kills",
		{
			"kills",
			"shots"
		},
		{
			"headshots",
			"shots"
		}
	}
	local lines = {}

	for i = 0, #invalid do
		if i == 0 or invalid[i] == 0 then
			local out = "" .. i

			for _, lvl_stat in ipairs(lvl_stats) do
				for _, diff in ipairs(diffs) do
					for _, heist in ipairs(heists) do
						out = out .. ";" .. get_lvl_stat(diff, heist, lvl_stat, i)
					end
				end
			end

			for _, wep_stat in ipairs(wep_stats) do
				for _, weapon in ipairs(weapons) do
					out = out .. ";" .. get_weapon_stat(weapon, wep_stat, i)
				end
			end

			table.insert(lines, out)
		end
	end

	local file_handle = SystemFS:open(file, "w")

	for i = 1, #lines do
		file_handle:puts(lines[i == 1 and 1 or #lines - i + 2])
	end
end
