require("lib/utils/accelbyte/StatisticsAdaptor")

local json = require("lib/utils/accelbyte/json")
Telemetry = Telemetry or class()
local base_url = "https://analytics.starbreeze.com"
local telemetry_endpoint = "/payday2/v1/events/batch"
local payload_content_type = "application/json"
local default_event_namespace = "payday2"
local geolocation_endpoint = "/game-telemetry/v1/protected/location"
local get_playtime_endpoint_steam = "/game-telemetry/v1/protected/steamIds/{steamId}/playtime"
local update_playtime_endpoint_steam = "/game-telemetry/v1/protected/steamIds/{steamId}/playtime/{playtime}"
local send_period = 5
local log_name = "[Telemetry]"
local login_retry_limit = 50
local connection_errors = {
	no_conn_error = 1,
	request_timeout = 2,
	unknown_conn_error = 0
}
Telemetry.event_actions = {
	piggybank_fed = 1
}
local is_steam = SystemInfo:distribution() == Idstring("STEAM")
local is_epic = SystemInfo:distribution() == Idstring("EPIC")

-- Lines 44-47
local function multiline(s)
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end

	return s:gmatch("(.-)\n")
end

-- Lines 49-63
local function build_json(event_name, payload, event_namespace)
	event_namespace = event_namespace or default_event_namespace

	if type(payload) ~= "table" then
		error("unexpected payload type, expect \"table\" " .. " got \"" .. type(payload) .. "\"")

		return nil
	end

	local telemetry_body = {
		eventNamespace = event_namespace,
		eventName = event_name,
		payload = payload or {}
	}
	local telemetry_json = json.encode(telemetry_body)

	return telemetry_json
end

-- Lines 65-77
local function build_payload(event_name, payload, event_namespace)
	event_namespace = event_namespace or default_event_namespace

	if type(payload) ~= "table" then
		error("unexpected payload type, expect \"table\" " .. " got \"" .. type(payload) .. "\"")

		return nil
	end

	local telemetry_body = {
		eventNamespace = event_namespace,
		eventName = event_name,
		payload = payload or {}
	}

	return telemetry_body
end

-- Lines 79-91
local function get_platform_name()
	if SystemInfo:platform() == Idstring("X360") then
		return "X360"
	elseif SystemInfo:platform() == Idstring("WIN32") then
		return "WIN32"
	elseif SystemInfo:platform() == Idstring("PS3") then
		return "PS3"
	elseif SystemInfo:platform() == Idstring("XB1") then
		return "XB1"
	elseif SystemInfo:platform() == Idstring("PS4") then
		return "PS4"
	end
end

-- Lines 93-101
local function get_distribution()
	if is_steam then
		return "STEAM"
	elseif is_epic then
		return "EPIC"
	else
		return "NONE"
	end
end

-- Lines 103-110
local function clear_table(t)
	if table.getn(t) == 0 then
		return
	end

	for key, val in pairs(t) do
		t[key] = nil
	end
end

-- Lines 112-124
local function telemetry_callback(error_code, status_code, response_body)
	if error_code == connection_errors.no_conn_error then
		if status_code == 204 or status_code == 200 then
			cat_print("telemetry", log_name, "telemetry sent successfully")
		else
			cat_print("telemetry", log_name, "problem on telemetry transmission, http status: " .. status_code)
		end
	elseif error_code == connection_errors.request_timeout then
		cat_print("telemetry", log_name, "problem on telemetry transmission, Request Timed Out")
	else
		cat_print("telemetry", log_name, "fatal error on transmission, http status: " .. status_code)
	end
end

-- Lines 126-138
local function on_total_playtime_retrieved(success, response_body)
	if success then
		local response_json = json.decode(response_body)
		Global.telemetry._total_playtime = response_json.total_playtime

		cat_print("telemetry", log_name, "Got total playtime")
	else
		Global.telemetry._total_playtime = -1

		cat_print("telemetry", log_name, "Problem retrieving play time data")
	end

	if Global.telemetry._login_screen_passed == true then
		Telemetry:on_login()
	end
end

-- Lines 140-151
local function on_geolocation_retrieved(success, response_body)
	if success then
		Global.telemetry._geolocation = json.decode(response_body)

		cat_print("telemetry", log_name, "Got gelocation data")
	else
		Global.telemetry._geolocation = "invalid data"

		cat_print("telemetry", log_name, "Problem retrieving geolocation data")
	end

	if Global.telemetry._login_screen_passed == true then
		Telemetry:on_login()
	end
end

-- Lines 153-160
local function on_oldest_achievement_date_retrieved(oldest_achievement_date)
	cat_print("telemetry", log_name, "Got oldest achievement date")

	Global.telemetry._oldest_achievement_date = oldest_achievement_date

	if Global.telemetry._login_screen_passed == true then
		Telemetry:on_login()
	end
end

-- Lines 162-174
local function on_playtime_updated(error_code, status_code, response_body)
	if error_code == connection_errors.no_conn_error then
		if status_code == 200 then
			cat_print("telemetry", log_name, "playtime updated")
		else
			cat_print("telemetry", log_name, "problem on playtime update, http status: " .. status_code)
		end
	elseif error_code == connection_errors.request_timeout then
		cat_print("telemetry", log_name, "problem on playtime update, Request Timed Out")
	else
		cat_print("telemetry", log_name, "fatal error on playtime update, http status: " .. status_code)
	end
end

-- Lines 176-188
local function get_geolocation()
	if get_platform_name() ~= "WIN32" then
		return
	end

	if not Global.telemetry._geolocation then
		Global.telemetry._bearer_token = Global.telemetry._bearer_token or Utility:generate_token()
		local headers = {
			Authorization = "Bearer " .. Global.telemetry._bearer_token
		}

		HttpRequest:get(Utility:get_telemetry_url() .. geolocation_endpoint, on_geolocation_retrieved, headers)
	end
end

-- Lines 190-229
local function get_total_playtime()
	if get_platform_name() ~= "WIN32" then
		return
	end

	if not Global.telemetry._total_playtime then
		local time_text, time = managers.statistics:time_played()

		if time and type(time) == "number" then
			Global.telemetry._total_playtime = time
		else
			Global.telemetry._total_playtime = -1
		end

		if Global.telemetry._login_screen_passed == true then
			Telemetry:on_login()
		end
	end
end

-- Lines 231-238
local function get_oldest_achievement_date()
	if get_platform_name() ~= "WIN32" then
		return
	end

	if not Global.telemetry._oldest_achievement_date then
		managers.achievment:request_oldest_achievement_date(on_oldest_achievement_date_retrieved)
	end
end

-- Lines 240-259
local function update_total_playtime(new_playtime)
	local endpoint = nil

	if is_steam then
		endpoint = update_playtime_endpoint_steam
		endpoint = endpoint:gsub("%{steamId}", managers.network.account:player_id())
		endpoint = endpoint:gsub("%{playtime}", tostring(new_playtime))
	elseif is_epic then
		-- Nothing
	end

	if not endpoint then
		return
	end

	Global.telemetry._bearer_token = Global.telemetry._bearer_token or Utility:generate_token()
	local headers = {
		Authorization = "Bearer " .. Global.telemetry._bearer_token
	}

	HttpRequest:put(Utility:get_telemetry_url() .. endpoint, on_playtime_updated, payload_content_type, nil, headers)
end

-- Lines 261-308
local function gather_player_skill_information()
	if Application:editor() then
		return
	end

	local stats = {}
	local skill_amount = {}
	local skill_data = tweak_data.skilltree.skills
	local tree_data = tweak_data.skilltree.trees

	for tree_index, tree in ipairs(tree_data) do
		if tree.statistics ~= false then
			skill_amount[tree_index] = 0

			for _, tier in ipairs(tree.tiers) do
				for _, skill in ipairs(tier) do
					if skill_data[skill].statistics ~= false then
						local skill_points = managers.skilltree:next_skill_step(skill)
						local skill_bought = skill_points > 1 and 1 or 0
						local skill_aced = skill_points > 2 and 1 or 0
						stats["skill_" .. tree.skill .. "_" .. skill] = skill_bought
						stats["skill_" .. tree.skill .. "_" .. skill .. "_ace"] = skill_aced
						skill_amount[tree_index] = skill_amount[tree_index] + skill_bought + skill_aced
					end
				end
			end
		end
	end

	for tree_index, tree in ipairs(tree_data) do
		if tree.statistics ~= false then
			stats["skill_" .. tree.skill] = skill_amount[tree_index]
		end
	end

	local current_specialization_idx = managers.skilltree:get_specialization_value("current_specialization")
	stats.player_specialization_active = tweak_data.skilltree.specializations[current_specialization_idx].name_id
	stats.player_specialization_tier = managers.skilltree:current_specialization_tier()
	stats.player_specialization_points = managers.skilltree:specialization_points()

	return stats
end

-- Lines 310-335
local function gather_or_convert_loadout_data(loadout)
	local _, _, mask_list, weapon_list, melee_list, grenade_list, _, armor_list, character_list, deployable_list, suit_list, weapon_color_list, glove_list, charm_list = tweak_data.statistics:statistics_table()
	local loadout_data = loadout
	loadout_data = loadout_data or managers.statistics:gather_equipment_data()

	if not loadout_data then
		return
	end

	local converted_loadout = StatisticsAdaptor:run(loadout_data)
	converted_loadout.equipped_character = character_list[converted_loadout.equipped_character]
	converted_loadout.equipped_mask = mask_list[converted_loadout.equipped_mask]
	converted_loadout.equipped_grenade = grenade_list[converted_loadout.equipped_grenade]
	converted_loadout.equipped_secondary = weapon_list[converted_loadout.equipped_secondary]
	converted_loadout.equipped_primary = weapon_list[converted_loadout.equipped_primary]
	converted_loadout.equipped_melee = melee_list[converted_loadout.equipped_melee]
	converted_loadout.equipped_suit = suit_list[converted_loadout.equipped_suit]
	converted_loadout.equipped_armor = armor_list[converted_loadout.equipped_armor]
	converted_loadout.equipped_deployable = deployable_list[converted_loadout.equipped_deployable]
	converted_loadout.equipped_glove_id = glove_list[converted_loadout.equipped_glove_id]

	return converted_loadout
end

-- Lines 340-373
function Telemetry:init()
	if get_platform_name() ~= "WIN32" then
		return
	end

	if not Global.telemetry then
		Global.telemetry = {
			_geolocation = true,
			_telemetries_to_send_arr = {},
			_session_uuid = nil,
			_enabled = false,
			_gamesight_enabled = false,
			_start_time = os.time(),
			_mission_payout = 0,
			_last_quickplay_room_id = 0,
			_logged_in = false,
			_times_logged_in = 0,
			_total_playtime = nil,
			_login_screen_passed = false,
			_bearer_token = nil,
			_login_inprogress = false,
			_login_retries = 0,
			_oldest_achievement_date = nil,
			_achievement_list = {},
			_has_pdth = false,
			_has_overdrill = false,
			_objective_id = nil,
			_has_account_checked = false
		}

		cat_print("telemetry", log_name, "Telemetry initiated")
	end

	self._global = Global.telemetry
	self._dt = 0
end

-- Lines 375-399
function Telemetry:update(t, dt)
	if get_platform_name() ~= "WIN32" or not self._global._enabled then
		return
	end

	self._dt = self._dt + dt

	if Global.telemetry._login_screen_passed and not self._global._logged_in and send_period < self._dt then
		self._dt = 0

		if not Global.telemetry._login_inprogress and managers.menu:is_open("menu_main") then
			cat_print("telemetry", log_name, "initial login telemetry attempt, this shouldn't be called")
			self:on_login()
		end

		if login_retry_limit <= Global.telemetry._login_retries then
			cat_print("telemetry", log_name, "login attempts exceeded. disabling telemetry")
			self:enable(false)
		end

		return
	end

	if self._global._logged_in and send_period < self._dt then
		self:send_telemetry(self._global._telemetries_to_send_arr)
		clear_table(self._global._telemetries_to_send_arr)

		self._dt = 0
	end
end

-- Lines 401-427
function Telemetry:enable(is_enable)
	if get_platform_name() ~= "WIN32" then
		return
	end

	if self._global._enabled ~= is_enable then
		self._global._enabled = is_enable

		if is_enable then
			get_total_playtime()
			get_oldest_achievement_date()
		else
			-- Lines 414-421
			local function logout_callback(error_code, status_code, response_body)
				if error_code == connection_errors.no_conn_error and (status_code == 204 or status_code == 200) then
					cat_print("telemetry", log_name, "successfully logged out")

					Global.telemetry._logged_in = false
				end
			end

			self:send_on_player_logged_out("optout")
			self:send_batch_immediately(logout_callback)
		end
	end
end

-- Lines 430-436
function Telemetry:gamesight_enable(is_enable)
	if get_platform_name() ~= "WIN32" then
		return
	end

	self._global._gamesight_enabled = is_enable
end

-- Lines 442-448
function Telemetry:set_mission_payout(payout)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	Global.telemetry._mission_payout = payout
end

-- Lines 450-455
function Telemetry:last_quickplay_room_id(room_id)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	Global.telemetry._last_quickplay_room_id = room_id
end

-- Lines 457-462
function Telemetry:on_login_screen_passed()
	if get_platform_name() ~= "WIN32" then
		return
	end

	Global.telemetry._login_screen_passed = true
end

-- Lines 468-494
function Telemetry:send_telemetry(telemetry_body, callback)
	if get_platform_name() ~= "WIN32" then
		return
	end

	if table.getn(telemetry_body) == 0 then
		return
	end

	callback = callback or telemetry_callback

	if not Global.telemetry._logged_in and telemetry_body[1].eventName ~= "player_logged_in" then
		return
	end

	local telemetry_json = json.encode(telemetry_body)

	if telemetry_json then
		cat_print("telemetry", log_name, telemetry_json)

		local headers = {}
		Global.telemetry._bearer_token = Global.telemetry._bearer_token or Utility:generate_token()
		headers.Authorization = "Bearer " .. Global.telemetry._bearer_token

		HttpRequest:post(base_url .. telemetry_endpoint, callback, payload_content_type, telemetry_json, headers)
	else
		error("error on JSON encoding, cannot send telemetry")
	end
end

-- Lines 496-508
function Telemetry:send(event_name, payload, event_namespace)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	cat_print("telemetry", "send", event_name, payload, event_namespace)
	self:init()

	payload.eventTimestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
	payload.entityID = managers.network.account:player_id()
	local telemetry_body = build_payload(event_name, payload, event_namespace)

	table.insert(self._global._telemetries_to_send_arr, telemetry_body)
end

-- Lines 510-525
function Telemetry:send_telemetry_immediately(event_name, payload, event_namespace, callback)
	if get_platform_name() ~= "WIN32" or not self._global._enabled then
		return
	end

	cat_print("telemetry", "send_telemetry_immediately", event_name, payload, event_namespace)

	callback = callback or telemetry_callback

	self:init()

	payload.eventTimestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
	payload.entityID = managers.network.account:player_id()
	local telemetry_body = {
		build_payload(event_name, payload, event_namespace)
	}

	self:send_telemetry(telemetry_body, callback)
end

-- Lines 528-548
function Telemetry:send_gamesight_telemetry_immediately(event_name, payload, event_namespace, callback)
	if get_platform_name() ~= "WIN32" or not self._global._gamesight_enabled then
		return
	end

	callback = callback or telemetry_callback

	self:init()

	local telemetry_body = {
		build_payload(event_name, payload, event_namespace)
	}
	local telemetry_json = json.encode(telemetry_body)

	if telemetry_json then
		cat_print("telemetry", log_name, "send_gamesight_telemetry_immediately", telemetry_json)

		local headers = {}
		Global.telemetry._bearer_token = Global.telemetry._bearer_token or Utility:generate_token()
		headers.Authorization = "Bearer " .. Global.telemetry._bearer_token

		HttpRequest:post(Utility:get_telemetry_url() .. "/game-telemetry/v1/protected/events", callback, payload_content_type, telemetry_json, headers)
	else
		error("error on JSON encoding, cannot send telemetry")
	end
end

-- Lines 551-560
function Telemetry:send_batch_immediately(callback)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	cat_print("telemetry", "send_batch_immediately")
	self:send_telemetry(self._global._telemetries_to_send_arr, callback)
	clear_table(self._global._telemetries_to_send_arr)
end

-- Lines 565-576
function Telemetry:on_login()
	if get_platform_name() ~= "WIN32" or not self._global._enabled then
		return
	end

	local try_login = not Global.telemetry._logged_in and Global.telemetry._geolocation and Global.telemetry._total_playtime ~= nil and Global.telemetry._oldest_achievement_date ~= nil and Global.telemetry._login_retries < login_retry_limit and Global.telemetry._has_account_checked == true

	if try_login then
		self:send_on_player_logged_in()
	end
end

-- Lines 578-650
function Telemetry:send_on_player_logged_in(reason)
	if get_platform_name() ~= "WIN32" or not self._global._enabled then
		return
	end

	self._global._session_uuid = self._global._session_uuid or Utility:generate_uuid()
	local rev = Application:version()

	if Global.revision and Global.revision ~= "" then
		rev = Global.revision
	end

	local total_playtime_hours = nil

	if Global.telemetry._total_playtime ~= -1 then
		total_playtime_hours = math.floor(Global.telemetry._total_playtime / 60)
	end

	local telemetry_payload = {
		platform = get_distribution(),
		platformUserID = managers.network.account:player_id(),
		sourceType = "",
		revision = rev,
		gameSessionGUID = self._global._session_uuid,
		totalHeistTime = managers.statistics:get_play_time(),
		totalPlayTime = total_playtime_hours,
		titleID = Global.dlc_manager.all_dlc_data.full_game.app_id,
		oldestAchievement = self._global._oldest_achievement_date,
		playerLevel = managers.experience:current_level(),
		infamyLevel = managers.experience:current_rank(),
		reason = Global.telemetry._times_logged_in == 0 and "startup" or "optin",
		pd2StarbreezeAccountID = Login.player_session.user_id or ""
	}
	local installed_dlc_list = {}
	local installed_entitlement_list = {}

	for _, dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
		if dlc_data.verified and dlc_data.verified == true then
			if is_steam and dlc_data.app_id and dlc_data.app_id ~= Global.dlc_manager.all_dlc_data.full_game.app_id then
				table.insert(installed_dlc_list, dlc_data.app_id)
			elseif is_steam and dlc_data.source_id then
				table.insert(installed_dlc_list, dlc_data.source_id)
			elseif is_epic and dlc_data.epic_id and dlc_data.epic_id ~= Global.dlc_manager.all_dlc_data.full_game.epic_id then
				table.insert(installed_dlc_list, dlc_data.epic_id)
			elseif dlc_data.entitlement_id then
				table.insert(installed_entitlement_list, dlc_data.entitlement_id)
			end
		end
	end

	telemetry_payload.installedDLCs = installed_dlc_list
	telemetry_payload.installedEntitlements = installed_entitlement_list

	-- Lines 627-645
	local function login_callback(error_code, status_code, response_body)
		if error_code == connection_errors.no_conn_error then
			if status_code == 204 or status_code == 200 then
				cat_print("telemetry", log_name, "successfully logged in")

				Global.telemetry._logged_in = true
				Global.telemetry._times_logged_in = Global.telemetry._times_logged_in + 1

				self:send_on_player_achievements()
				self:send_on_player_steam_stats_overdrill()
				self:send_on_player_hardware_survey()
			else
				cat_print("telemetry", log_name, "problem on login, http status: " .. status_code)
			end
		elseif error_code == connection_errors.request_timeout then
			cat_print("telemetry", log_name, "problem on login, Request Timed Out")
		else
			cat_print("telemetry", log_name, "fatal error on login, http status: " .. status_code)
		end

		Global.telemetry._login_inprogress = false
	end

	Global.telemetry._login_inprogress = true
	Global.telemetry._login_retries = Global.telemetry._login_retries + 1

	self:send_telemetry_immediately("player_logged_in", telemetry_payload, nil, login_callback)
end

-- Lines 652-665
function Telemetry:send_on_player_economy_event(event_origin, currency, amount, transaction_type)
	if get_platform_name() ~= "WIN32" or not self._global or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		origin = event_origin,
		currency = currency,
		amount = amount,
		transactionType = transaction_type
	}

	self:send("player_economy", telemetry_payload)
end

-- Lines 667-685
function Telemetry:send_on_player_logged_out(reason)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {}
	local play_duration = os.time() - Global.telemetry._start_time
	telemetry_payload.gameSessionGUID = self._global._session_uuid
	telemetry_payload.timePlayed = play_duration
	telemetry_payload.reason = reason

	if Global.telemetry._total_playtime ~= -1 then
		local total_playtime_minutes = math.floor(Global.telemetry._total_playtime + math.floor(play_duration / 60))
	end

	self:send("player_logged_out", telemetry_payload)
end

-- Lines 687-712
function Telemetry:on_start_heist()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	if managers.network.matchmake.lobby_handler then
		self._heist_id = managers.network.matchmake.lobby_handler:id()
	else
		self._heist_id = Utility:generate_uuid()
	end

	self._heist_name = "invalid heist name"
	self._map_name = "invalid map name"

	if managers.job:current_level_data() then
		self._heist_name = managers.job:current_job_variant() or managers.job:current_level_data().name_id
		self._map_name = managers.job:current_level_data().world_name
	end

	self._heist_type = "invalid heist type"

	if managers.job:current_stage_data() then
		self._heist_type = managers.job:current_stage_data().type_id
	end

	self:send_on_heist_start()
	self:send_on_player_heist_start()
	self:send_on_player_lobby_setting()
	self:send_batch_immediately()
end

-- Lines 714-743
function Telemetry:on_end_heist(end_reason, total_exp_earned, moneythrower_spent)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	if not self._heist_id then
		return
	end

	if game_state_machine:current_state_name() == "kicked" then
		end_reason = "kicked"
	elseif game_state_machine:current_state_name() == "server_left" then
		end_reason = "server_left"
	end

	self._end_reason = end_reason
	self._total_exp_earned = total_exp_earned
	self._heist_duration = select(2, managers.statistics:session_time_played())
	self._moneythrower_spent = moneythrower_spent

	self:send_on_heist_end()
	self:send_on_player_heist_end()
	self:send_batch_immediately()

	self._heist_id = nil
end

-- Lines 745-804
function Telemetry:send_on_player_heist_start()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local job_plan = "any"

	if Global.game_settings.job_plan == 1 then
		job_plan = "loud"
	elseif Global.game_settings.job_plan == 2 then
		job_plan = "stealth"
	end

	local weapon_mods = {}
	local weapon_mods_category = {
		"primary_weapon",
		"secondary_weapon"
	}
	local weapon_categories = {
		"primaries",
		"secondaries"
	}

	for idx, category in pairs(weapon_categories) do
		local slot = BlackMarketManager:equipped_weapon_slot(category)
		local blueprint = managers.blackmarket:get_weapon_blueprint(category, slot)
		local cosmetics = managers.blackmarket:get_weapon_cosmetics(category, slot)
		weapon_mods[weapon_mods_category[idx]] = {}

		for _, mod_name in pairs(blueprint) do
			local mod = tweak_data.weapon.factory.parts[mod_name]

			if mod then
				weapon_mods[weapon_mods_category[idx]][mod.type] = mod_name
			end
		end

		if cosmetics then
			weapon_mods[weapon_mods_category[idx]].cosmetics = cosmetics.id
		end
	end

	if next(weapon_mods) == nil then
		weapon_mods = nil
	end

	local is_quickplay = false

	if managers.network.matchmake.lobby_handler then
		is_quickplay = Global.telemetry._last_quickplay_room_id == managers.network.matchmake.lobby_handler:id()
	end

	local telemetry_payload = {
		mapName = self._map_name,
		heistName = self._heist_name,
		heistID = self._heist_id,
		heistType = self._heist_type,
		contractorName = managers.job:current_contact_id(),
		quickPlay = is_quickplay,
		difficulty = managers.job:current_difficulty_stars(),
		tactic = job_plan,
		mods = weapon_mods,
		loadout = gather_or_convert_loadout_data(),
		skills = gather_player_skill_information(),
		story = managers.story:is_heist_story_started(managers.job:current_level_id()),
		mutators = managers.mutators:get_mutators_from_lobby_data()
	}

	self:send("player_heist_start", telemetry_payload)
end

-- Lines 806-844
function Telemetry:send_on_player_heist_end()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local job_plan = "any"

	if managers.groupai then
		if managers.groupai:state():whisper_mode() then
			job_plan = "stealth"
		else
			job_plan = "loud"
		end
	end

	local telemetry_payload = {
		mapName = self._map_name,
		heistName = self._heist_name,
		heistID = self._heist_id,
		heistEndReason = self._end_reason,
		heistDuration = self._heist_duration,
		tactic = job_plan,
		totalCashEarned = Global.telemetry._mission_payout,
		totalExpEarned = self._total_exp_earned
	}
	local total_spoons = 0

	if managers.blackmarket:equipped_melee_weapon() == "spoon" and Global.statistics_manager and Global.statistics_manager.session and Global.statistics_manager.session.killed_by_melee then
		for name_id, kills in pairs(Global.statistics_manager.session.killed_by_melee) do
			if not CopDamage.is_civilian(name_id) then
				total_spoons = total_spoons + kills
			end
		end
	end

	telemetry_payload.totalSpoons = total_spoons
	telemetry_payload.totalRetired = self._moneythrower_spent

	self:send("player_heist_end", telemetry_payload)
end

-- Lines 846-866
function Telemetry:send_on_heist_start()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	if not CrimeSpreeManager:_is_host() then
		-- Nothing
	end

	local player_count = 0

	if managers.network:session() then
		player_count = table.size(managers.network:session():all_peers())
	end

	local telemetry_payload = {
		heistName = self._heist_name,
		heistID = self._heist_id,
		heistType = self._heist_type,
		playerCount = player_count
	}

	self:send("heist_start", telemetry_payload)
end

-- Lines 868-890
function Telemetry:send_on_heist_end(end_reason)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	if not CrimeSpreeManager:_is_host() then
		-- Nothing
	end

	local player_count = 0

	if managers.network:session() then
		player_count = table.size(managers.network:session():all_peers())
	end

	local telemetry_payload = {
		heistName = self._heist_name,
		heistID = self._heist_id,
		heistType = self._heist_type,
		endReason = self._end_reason,
		playerCount = player_count,
		heistDuration = self._heist_duration
	}

	self:send("heist_end", telemetry_payload)
end

-- Lines 892-917
function Telemetry:send_on_player_heartbeat()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local map_name = "invalid map name"

	if managers.menu:active_menu() then
		map_name = managers.menu:active_menu().id
	elseif managers.job:current_level_data() then
		map_name = managers.job:current_level_data().name_id
	end

	local game_mode = Global.game_settings.gamemode

	if managers.skirmish:is_skirmish() then
		game_mode = managers.job:current_level_data().group_ai_state
	end

	local telemetry_payload = {
		mapName = map_name,
		gameMode = game_mode,
		gameState = game_state_machine:current_state_name(),
		gameSessionGUID = self._global._session_uuid,
		playerState = managers.player:current_state(),
		playerLevel = managers.experience:current_level(),
		infamyLevel = managers.experience:current_rank()
	}

	self:send("player_heartbeat", telemetry_payload)
end

-- Lines 919-950
function Telemetry:send_on_player_tutorial(id)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local tutorial_name = ""

	if managers.job:current_job_id() then
		if managers.job:current_job_id() ~= "short1" and managers.job:current_job_id() ~= "short2" then
			return
		end

		if managers.job:current_job_id() == "short1" then
			tutorial_name = "FlashDrive"
		elseif managers.job:current_job_id() == "short2" then
			tutorial_name = "GetTheCoke"
		end
	else
		return
	end

	local step = ""

	if managers.job:current_level_id() then
		step = string.sub(managers.job:current_level_id(), 8)
	else
		return
	end

	local telemetry_payload = {
		tutorialName = tutorial_name,
		tutorialStep = step,
		tutorialObjective = id
	}

	self:send("player_tutorial", telemetry_payload)
	self:send_batch_immediately()
end

-- Lines 952-967
function Telemetry:send_on_player_lobby_setting()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local status = ""

	if managers.network.matchmake:get_lobby_data() then
		status = managers.network.matchmake:get_lobby_data().lobby_type
	else
		return
	end

	local telemetry_payload = {
		status = status
	}

	self:send("player_lobby_setting", telemetry_payload)
end

-- Lines 969-978
function Telemetry:send_on_player_change_loadout(loadout)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		loadout = gather_or_convert_loadout_data(),
		skills = gather_player_skill_information()
	}

	self:send("player_loadout", telemetry_payload)
end

-- Lines 980-1002
function Telemetry:send_on_player_hardware_survey()
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		gameSessionGUID = self._global._session_uuid,
		os = Utility:get_os_acrhitecture(),
		osVersion = Utility:get_os_version(),
		gpuName = Utility:get_gpu_brand(),
		gpuType = Utility:get_gpu_model(),
		gpuMemory = Utility:get_gpu_memory_gb(),
		ram = Utility:get_ram_gb(),
		processorType = Utility:get_cpu_vendor(),
		processor = Utility:get_cpu_freq_ghz(),
		cpu = Utility:get_cpu_model(),
		hardDriveSizeTotal = Utility:get_strg_capacity(),
		hardDriveSizeAvailable = Utility:get_strg_freespace(),
		hardDriveType = Utility:get_strg_type(),
		vrHardware = _G.IS_VR
	}

	self:send("player_hardware_survey", telemetry_payload)
end

-- Lines 1004-1013
function Telemetry:on_start_objective(id)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	Global.telemetry._objective_start_time = os.time()
	Global.telemetry._objective_id = id

	self:send_on_player_heist_objective_start()
end

-- Lines 1015-1032
function Telemetry:on_end_objective(id)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	if id ~= Global.telemetry._objective_id then
		Global.telemetry._objective_id = nil
		Global.telemetry._objective_start_time = nil

		return
	end

	self:send_on_player_heist_objective_end()

	Global.telemetry._objective_id = nil
	Global.telemetry._objective_start_time = nil
end

-- Lines 1038-1096
function Telemetry:send_on_game_launch()
	if get_platform_name() ~= "WIN32" or not self._global._gamesight_enabled then
		return
	end

	cat_print("telemetry", log_name, "Sending on game launch event")

	local event_name = "game_launch"

	-- Lines 1051-1063
	local function telemetry_callback(error_code, status_code, response_body)
		if error_code == connection_errors.no_conn_error then
			if status_code == 204 or status_code == 200 then
				cat_print("telemetry", log_name, "Gamesight payload successfully sent")
			else
				cat_print("telemetry", log_name, "problem on sending gamesight telemetry, http status: " .. status_code)
			end
		elseif error_code == connection_errors.request_timeout then
			cat_print("telemetry", log_name, "problem on login, Request Timed Out")
		else
			cat_print("telemetry", log_name, "fatal error on sending gamesight telemetry, http status: " .. status_code)
		end
	end

	local gamesight_identifiers = {}
	local resolution = RenderSettings.resolution.x .. "x" .. RenderSettings.resolution.y
	gamesight_identifiers.resolution = resolution
	local os_name = Utility:get_os_name()

	if os_name == "error" then
		cat_print("telemetry", log_name, "problem on getting OS Name.")

		os_name = ""
	end

	gamesight_identifiers.os = os_name
	local os_language = Utility:get_current_language()

	if string.len(os_language) > 6 then
		cat_print("telemetry", log_name, os_language)

		os_language = ""
	end

	gamesight_identifiers.language = os_language
	local os_timezone = Utility:get_current_timezone()

	if os_timezone == -1 then
		cat_print("telemetry", log_name, "Unable to get the timezone properly")
	end

	gamesight_identifiers.timezone = os_timezone
	local telemetry_payload = {
		user_id = managers.network.account:player_id(),
		type = event_name,
		identifiers = gamesight_identifiers or {}
	}

	self:send_gamesight_telemetry_immediately(event_name, telemetry_payload, Utility:get_telemetry_namespace(), telemetry_callback)
end

-- Lines 1101-1110
function Telemetry:send_on_player_heist_objective_start()
	local telemetry_payload = {
		mapName = self._map_name,
		heistName = self._heist_name,
		heistID = self._heist_id,
		objectiveID = Global.telemetry._objective_id .. "_hl",
		difficulty = managers.job:current_difficulty_stars(),
		objectiveState = "started"
	}

	self:send("player_heist_objective", telemetry_payload)
end

-- Lines 1112-1134
function Telemetry:send_on_player_heist_objective_end()
	local job_plan = "any"

	if managers.groupai then
		if managers.groupai:state():whisper_mode() then
			job_plan = "stealth"
		else
			job_plan = "loud"
		end
	end

	local duration = os.time() - Global.telemetry._objective_start_time
	local telemetry_payload = {
		mapName = self._map_name,
		heistName = self._heist_name,
		heistID = self._heist_id,
		objectiveID = Global.telemetry._objective_id .. "_hl",
		difficulty = managers.job:current_difficulty_stars(),
		objectiveState = "completed",
		objectiveTactic = job_plan,
		objectiveDuration = duration
	}

	self:send("player_heist_objective", telemetry_payload)
end

-- Lines 1136-1138
function Telemetry:append_achievement_list(achievement_id)
	table.insert(self._global._achievement_list, achievement_id)
end

-- Lines 1140-1161
function Telemetry:send_on_player_achievements(achievements)
	if not self._global._logged_in then
		return
	end

	local achievement_list = {}

	for _, ach in ipairs(self._global._achievement_list) do
		table.insert(achievement_list, ach)
	end

	local telemetry_payload = {
		achievements = achievement_list
	}

	if is_steam then
		self:send("player_steam_achievements", telemetry_payload)
	elseif is_epic then
		-- Nothing
	end

	self._global._achievement_list = {}
end

-- Lines 1163-1165
function Telemetry:set_steam_stats_overdrill_true()
	self._global._has_overdrill = true
end

-- Lines 1167-1169
function Telemetry:set_steam_stats_pdth_true()
	self._global._has_pdth = true
end

-- Lines 1171-1182
function Telemetry:send_on_player_steam_stats_overdrill()
	if get_distribution() ~= "STEAM" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		overdrill = self._global._has_overdrill,
		pdth = self._global._has_pdth
	}

	self:send("player_steam_stats_overdrill", telemetry_payload)
end

-- Lines 1213-1225
function Telemetry:send_on_game_event_piggybank_fed(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local total_kills = managers.statistics:session_anyone_killed_by_grenade() + managers.statistics:session_anyone_killed_by_melee() + managers.statistics:session_anyone_killed_by_weapons()
	local telemetry_payload = {
		heistID = self._heist_id,
		totalKills = total_kills
	}

	self:send("piggybank_fed", telemetry_payload)
end

-- Lines 1228-1239
function Telemetry:send_on_game_event_on_bag_collected(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		heistID = self._heist_id,
		bagType = params.bag_type,
		collectedType = params.collection_type
	}

	self:send("cg22_bag_collected", telemetry_payload)
end

-- Lines 1241-1251
function Telemetry:send_on_game_event_snoman_death(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		heistID = self._heist_id,
		weaponID = params.weapon_id
	}

	self:send("cg22_snowman_death", telemetry_payload)
end

-- Lines 1253-1262
function Telemetry:send_on_game_event_tree_interacted(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		heistID = self._heist_id
	}

	self:send("cg22_tree_interacted", telemetry_payload)
end

-- Lines 1265-1274
function Telemetry:send_on_leakedrecording_played(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		recordingID = params.recording_id
	}

	self:send("leakedrecording_played", telemetry_payload)
end

-- Lines 1277-1289
function Telemetry:send_on_game_event_piggyrevenge_fed(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local total_kills = managers.statistics:session_anyone_killed_by_grenade() + managers.statistics:session_anyone_killed_by_melee() + managers.statistics:session_anyone_killed_by_weapons()
	local telemetry_payload = {
		heistID = self._heist_id,
		totalKills = total_kills
	}

	self:send("piggyrevenge_fed", telemetry_payload)
end

-- Lines 1291-1302
function Telemetry:send_on_game_event_piggyrevenge_exploded(params)
	if get_platform_name() ~= "WIN32" or not self._global._logged_in then
		return
	end

	local telemetry_payload = {
		heistID = self._heist_id,
		piggyStage = params.stage,
		bagProcess = params.progress
	}

	self:send("piggyrevenge_exploded", telemetry_payload)
end
