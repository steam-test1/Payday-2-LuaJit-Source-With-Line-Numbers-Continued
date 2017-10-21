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

-- Lines: 32 to 65
function NetworkAccountSTEAM:init()
	NetworkAccount.init(self)

	self._listener_holder = EventListenerHolder:new()

	Steam:init()
	Steam:request_listener(NetworkAccountSTEAM._on_join_request, NetworkAccountSTEAM._on_server_request)
	Steam:error_listener(NetworkAccountSTEAM._on_disconnected, NetworkAccountSTEAM._on_ipc_fail, NetworkAccountSTEAM._on_connect_fail)
	Steam:overlay_listener(callback(self, self, "_on_open_overlay"), callback(self, self, "_on_close_overlay"))

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
	self:set_lightfx()
	self:inventory_load()
end

-- Lines: 67 to 70
function NetworkAccountSTEAM:_load_done(...)
	print("NetworkAccountSTEAM:_load_done()", ...)
	self:_set_presences()
end

-- Lines: 72 to 74
function NetworkAccountSTEAM:update()
	self:_chk_inventory_outfit_refresh()
end

-- Lines: 77 to 88
function NetworkAccountSTEAM:_set_presences()
	Steam:set_rich_presence("level", managers.experience:current_level())

	if MenuCallbackHandler:is_modded_client() then
		Steam:set_rich_presence("is_modded", 1)
	else
		Steam:set_rich_presence("is_modded", 0)
	end
end

-- Lines: 90 to 92
function NetworkAccountSTEAM:set_presences_peer_id(peer_id)
	Steam:set_rich_presence("peer_id", peer_id)
end

-- Lines: 96 to 111
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

-- Lines: 117 to 128
function NetworkAccountSTEAM:set_lightfx()
	if managers.user:get_setting("use_lightfx") then
		print("[NetworkAccountSTEAM:init] Initializing LightFX...")

		self._has_alienware = LightFX:initialize() and LightFX:has_lamps()

		if self._has_alienware then
			LightFX:set_lamps(0, 255, 0, 255)
		end

		print("[NetworkAccountSTEAM:init] Initializing LightFX done")
	else
		self._has_alienware = nil
	end
end

-- Lines: 130 to 138
function NetworkAccountSTEAM._on_troll_group_recieved(success, page)
	if success and string.find(page, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
		managers.network.account._masks.troll = true
	end

	Steam:http_request("http://steamcommunity.com/gid/103582791432592205/memberslistxml/?xml=1", NetworkAccountSTEAM._on_com_group_recieved)
end

-- Lines: 140 to 148
function NetworkAccountSTEAM._on_com_group_recieved(success, page)
	if success and string.find(page, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
		managers.network.account._masks.hockey_com = true
	end

	Steam:http_request("http://steamcommunity.com/gid/103582791432508229/memberslistxml/?xml=1", NetworkAccountSTEAM._on_dev_group_recieved)
end

-- Lines: 150 to 156
function NetworkAccountSTEAM._on_dev_group_recieved(success, page)
	if success and string.find(page, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
		managers.network.account._masks.developer = true
	end
end

-- Lines: 159 to 160
function NetworkAccountSTEAM:has_alienware()
	return self._has_alienware
end

-- Lines: 163 to 167
function NetworkAccountSTEAM:_call_listeners(event, params)
	if self._listener_holder then
		self._listener_holder:call(event, params)
	end
end

-- Lines: 169 to 171
function NetworkAccountSTEAM:add_overlay_listener(key, events, clbk)
	self._listener_holder:add(key, events, clbk)
end

-- Lines: 173 to 175
function NetworkAccountSTEAM:remove_overlay_listener(key)
	self._listener_holder:remove(key)
end

-- Lines: 177 to 184
function NetworkAccountSTEAM:_on_open_overlay()
	if self._overlay_opened then
		return
	end

	self._overlay_opened = true

	self:_call_listeners("overlay_open")
	game_state_machine:_set_controller_enabled(false)
end

-- Lines: 186 to 196
function NetworkAccountSTEAM:_on_close_overlay()
	if not self._overlay_opened then
		return
	end

	self._overlay_opened = false

	self:_call_listeners("overlay_close")
	game_state_machine:_set_controller_enabled(true)
	managers.dlc:chk_content_updated()
end

-- Lines: 198 to 204
function NetworkAccountSTEAM:_on_gamepad_text_submitted(submitted, submitted_text)
	print("[NetworkAccountSTEAM:_on_gamepad_text_submitted]", "submitted", submitted, "submitted_text", submitted_text)

	for id, clbk in pairs(self._gamepad_text_listeners) do
		clbk(submitted, submitted_text)
	end

	self._gamepad_text_listeners = {}
end

-- Lines: 226 to 227
function NetworkAccountSTEAM:show_gamepad_text_input(id, callback, params)
	return false
end

-- Lines: 230 to 235
function NetworkAccountSTEAM:add_gamepad_text_listener(id, clbk)
	if self._gamepad_text_listeners[id] then
		debug_pause("[NetworkAccountSTEAM:add_gamepad_text_listener] ID already added!", id, "Old Clbk", self._gamepad_text_listeners[id], "New Clbk", clbk)
	end

	self._gamepad_text_listeners[id] = clbk
end

-- Lines: 237 to 242
function NetworkAccountSTEAM:remove_gamepad_text_listener(id)
	if not self._gamepad_text_listeners[id] then
		debug_pause("[NetworkAccountSTEAM:remove_gamepad_text_listener] ID do not exist!", id)
	end

	self._gamepad_text_listeners[id] = nil
end

-- Lines: 244 to 246
function NetworkAccountSTEAM:achievements_fetched()
	self._achievements_fetched = true
end

-- Lines: 248 to 250
function NetworkAccountSTEAM:challenges_loaded()
	self._challenges_loaded = true
end

-- Lines: 252 to 254
function NetworkAccountSTEAM:experience_loaded()
	self._experience_loaded = true
end

-- Lines: 256 to 258
function NetworkAccountSTEAM._on_leaderboard_stored(status)
	print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard stored, ", status, ".")
end

-- Lines: 260 to 264
function NetworkAccountSTEAM._on_leaderboard_mapped()
	print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard mapped.")
	Steam:lb_handler():request_storage()
end

-- Lines: 266 to 285
function NetworkAccountSTEAM._on_stats_stored(status)
	print("[NetworkAccountSTEAM:_on_stats_stored] Statistics stored, ", status, ". Publishing leaderboard score to Steam!")
end

-- Lines: 287 to 288
function NetworkAccountSTEAM:get_stat(key)
	return Steam:sa_handler():get_stat(key)
end

-- Lines: 292 to 293
function NetworkAccountSTEAM:has_stat(key)
	return Steam:sa_handler():has_stat(key)
end

-- Lines: 296 to 298
function NetworkAccountSTEAM:achievement_unlock_time(key)
	local res = Steam:sa_handler():achievement_unlock_time(key)

	return res ~= -1 and res or nil
end

-- Lines: 301 to 302
function NetworkAccountSTEAM:get_lifetime_stat(key)
	return Steam:sa_handler():get_lifetime_stat(key)
end

-- Lines: 305 to 330
function NetworkAccountSTEAM:get_global_stat(key, days)
	local value = 0
	local global_stat = nil

	if days and days < 0 then
		local day = math.abs(days) + 1
		global_stat = Steam:sa_handler():get_global_stat(key, day)

		return global_stat[day] or 0
	elseif days then
		global_stat = Steam:sa_handler():get_global_stat(key, days == 1 and 1 or days + 1)

		for i = days > 1 and 2 or 1, #global_stat, 1 do
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

-- Lines: 344 to 427
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

-- Lines: 429 to 437
function NetworkAccountSTEAM._on_disconnected(lobby_id, friend_id)
	print("[NetworkAccountSTEAM._on_disconnected]", lobby_id, friend_id)

	if Application:editor() then
		return
	end

	Application:warn("Disconnected from Steam!! Please wait", 12)
end

-- Lines: 439 to 441
function NetworkAccountSTEAM._on_ipc_fail(lobby_id, friend_id)
	print("[NetworkAccountSTEAM._on_ipc_fail]")
end

-- Lines: 444 to 472
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

-- Lines: 474 to 477
function NetworkAccountSTEAM._on_server_request(ip, pw)
	print("[NetworkAccountSTEAM._on_server_request]")
end

-- Lines: 479 to 482
function NetworkAccountSTEAM._on_connect_fail(ip, pw)
	print("[NetworkAccountSTEAM._on_connect_fail]")
end

-- Lines: 486 to 490
function NetworkAccountSTEAM:signin_state()
	if self:local_signin_state() == true then
		return "signed in"
	end

	return "not signed in"
end

-- Lines: 493 to 494
function NetworkAccountSTEAM:local_signin_state()
	return Steam:logged_on()
end

-- Lines: 497 to 498
function NetworkAccountSTEAM:username_id()
	return Steam:username()
end

-- Lines: 501 to 502
function NetworkAccountSTEAM:username_by_id(id)
	return Steam:username(id)
end

-- Lines: 505 to 506
function NetworkAccountSTEAM:player_id()
	return Steam:userid()
end

-- Lines: 509 to 510
function NetworkAccountSTEAM:is_connected()
	return true
end

-- Lines: 513 to 514
function NetworkAccountSTEAM:lan_connection()
	return true
end

-- Lines: 517 to 519
function NetworkAccountSTEAM:set_playing(state)
	Steam:set_playing(state)
end

-- Lines: 522 to 532
function NetworkAccountSTEAM:_load_globals()
	if Global.steam and Global.steam.account then
		self._outfit_signature = Global.steam.account.outfit_signature and Global.steam.account.outfit_signature:get_data()

		if Global.steam.account.outfit_signature then
			Global.steam.account.outfit_signature:destroy()
		end

		Global.steam.account = nil
	end
end

-- Lines: 534 to 539
function NetworkAccountSTEAM:_save_globals()
	Global.steam = Global.steam or {}
	Global.steam.account = {}
	Global.steam.account.outfit_signature = self._outfit_signature and Application:create_luabuffer(self._outfit_signature)
end

-- Lines: 541 to 542
function NetworkAccountSTEAM:is_ready_to_close()
	return not self._inventory_is_loading and not self._inventory_outfit_refresh_requested and not self._inventory_outfit_refresh_in_progress
end

-- Lines: 555 to 562
function NetworkAccountSTEAM:inventory_load()
	if self._inventory_is_loading then
		return
	end

	self._inventory_is_loading = true

	Steam:inventory_load(callback(self, self, "_clbk_inventory_load"))
end

-- Lines: 564 to 565
function NetworkAccountSTEAM:inventory_is_loading()
	return self._inventory_is_loading
end

-- Lines: 581 to 583
function NetworkAccountSTEAM:inventory_reward(reward_callback, item)
	Steam:inventory_reward(reward_callback, item or 1)

	return true
end

-- Lines: 586 to 620
function NetworkAccount:inventory_reward_unlock(safe, safe_instance_id, drill_instance_id, reward_unlock_callback)
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

-- Lines: 622 to 646
function NetworkAccount:inventory_reward_open(safe, safe_instance_id, reward_unlock_callback)
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

-- Lines: 661 to 663
function NetworkAccountSTEAM:inventory_reward_dlc(def_id, reward_promo_callback)
	Steam:inventory_reward_promo(def_id, reward_promo_callback)
end

-- Lines: 672 to 674
function NetworkAccountSTEAM:inventory_outfit_refresh()
	self._inventory_outfit_refresh_requested = true
end

-- Lines: 676 to 688
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

-- Lines: 690 to 702
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

-- Lines: 704 to 710
function NetworkAccountSTEAM:inventory_outfit_verify(steam_id, outfit_data, outfit_callback)
	if outfit_data == "" then
		return outfit_callback and outfit_callback(nil, false, {})
	end

	Steam:inventory_signature_verify(steam_id, outfit_data, outfit_callback)
end

-- Lines: 712 to 713
function NetworkAccountSTEAM:inventory_outfit_signature()
	return self._outfit_signature
end

-- Lines: 716 to 733
function NetworkAccountSTEAM:inventory_repair_list(list)
	if list then
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
		end
	end
end

-- Lines: 735 to 750
function NetworkAccountSTEAM:_clbk_inventory_load(error, list)
	print("[NetworkAccountSTEAM:_clbk_inventory_load]", "error: ", error, "list: ", list)

	self._inventory_is_loading = nil

	if error then
		Application:error("[NetworkAccountSTEAM:_clbk_inventory_load] Failed to update tradable inventory (" .. tostring(error) .. ")")
	end

	self:inventory_repair_list(list)
	managers.blackmarket:tradable_update(list, not error)
	managers.menu_component:set_blackmarket_tradable_loaded(error)

	if managers.menu_scene then
		managers.menu_scene:set_blackmarket_tradable_loaded()
	end
end

-- Lines: 752 to 769
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

-- Lines: 777 to 896
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


	-- Lines: 793 to 814
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


	-- Lines: 818 to 839
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

	for i = 0, #invalid, 1 do
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

	for i = 1, #lines, 1 do
		file_handle:puts(lines[i == 1 and 1 or #lines - i + 2])
	end
end

