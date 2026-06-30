Steam = Steam or {}
Steam.SMALL_AVATAR = 0
Steam.MEDIUM_AVATAR = 1
Steam.LARGE_AVATAR = 2

-- Lines 6-10
local function shadow_class_instance_function(object, bad_name, new_name)
	if object and getmetatable(object) then
		getmetatable(object)[bad_name] = getmetatable(object)[new_name]
	end
end

-- Lines 12-12
function Steam:init()
	return
end

-- Lines 13-13
function Steam:update()
	return
end

-- Lines 15-17
function Steam:logged_on()
	return Distribution:logged_on()
end

-- Lines 21-26
function Steam:username(user_id)
	if user_id then
		return Distribution:user_from_id(user_id):username()
	end

	return Distribution:local_user():username()
end

-- Lines 29-31
function Steam:userid()
	return Distribution:local_user_id()
end

-- Lines 33-35
function Steam:is_local_account(user_id)
	return Distribution:user_from_id(user_id) == Distribution:local_user()
end

-- Lines 37-39
function Steam:user(user_id)
	return Distribution:user_from_id(user_id)
end

-- Lines 41-43
function Steam:friends()
	return Distribution:friends()
end

-- Lines 45-47
function Steam:coplay_friends()
	return Distribution:recently_played_with_friends()
end

-- Lines 49-65
function Steam:friend_avatar(size, user_id, callback)
	if size == Steam.SMALL_AVATAR then
		size = Distribution.ProfilePictureSize_Small
	elseif size == Steam.MEDIUM_AVATAR then
		size = Distribution.ProfilePictureSize_Medium
	elseif size == Steam.LARGE_AVATAR then
		size = Distribution.ProfilePictureSize_Large
	else
		return
	end

	-- Lines 60-62
	local function wrapped_callback(texture, status, distribution_texture_handle)
		callback(texture)
	end

	return Distribution:request_user_profile_picture(size, user_id, wrapped_callback)
end

-- Lines 70-72
function Steam:create_ticket(intended_verifier)
	return DistributionMatchmaking:create_secure_ticket_for_peer(intended_verifier)
end

-- Lines 73-75
function Steam:destroy_ticket(user_id)
	return DistributionMatchmaking:destroy_secure_ticket_for_peer(user_id)
end

-- Lines 78-80
function Steam:begin_ticket_session(user_id, ticket, callback)
	return DistributionMatchmaking:begin_secure_ticket_session_for_peer(user_id, ticket, callback)
end

-- Lines 81-83
function Steam:end_ticket_session(user_id)
	return DistributionMatchmaking:end_secure_ticket_session_for_peer(user_id)
end

-- Lines 85-87
function Steam:change_ticket_callback(user_id, new_callback)
	return
end

-- Lines 89-89
function Steam:bind_steam_ticket_validate_callback()
	return
end

-- Lines 94-96
function Steam:create_lobby(callback, max_members, type)
	return DistributionMatchmaking:create_lobby(callback, max_members, type)
end

-- Lines 97-99
function Steam:join_lobby(lobby_id, callback)
	return DistributionMatchmaking:join_lobby(lobby_id, callback)
end

-- Lines 101-103
function Steam:set_played_with(user_id)
	return Distribution:set_played_with(user_id)
end

-- Lines 105-108
function Steam:lobby(lobby_id)
	Application:error("Steam:lobby( lobby_id ) called, DistributionMatchmaking unfortunately had to implement a breaking change to this interface, please call DistributionMatchmaking:lobby_from_id( lobby_id, from_server_browser, function(lobby, result, intended_lobby_id) ) instead!")

	return nil
end

-- Lines 113-115
function Steam:is_product_owned(app_id)
	return Distribution:is_product_owned(app_id)
end

-- Lines 116-118
function Steam:is_product_installed(app_id)
	return Distribution:is_product_installed(app_id)
end

-- Lines 119-121
function Steam:is_app_installed(app_id)
	return Distribution:is_app_installed(app_id)
end

-- Lines 123-125
function Steam:is_user_product_owned(user_id, app_id)
	return DistributionMatchmaking:does_peer_own_product(user_id, app_id)
end

-- Lines 127-130
function Steam:is_user_in_source(user, group)
	return true
end

-- Lines 132-132
function Steam:install_dlc()
	return
end

-- Lines 133-133
function Steam:uninstall_dlc()
	return
end

-- Lines 137-139
function Steam:inventory_load(callback)
	return Distribution:inventory():load_inventory_items(callback)
end

-- Lines 140-142
function Steam:inventory_reward(callback, def_id)
	return Distribution:inventory():reward_item_drop(def_id, callback)
end

-- Lines 143-145
function Steam:inventory_reward_promo(def_id, callback)
	return Distribution:inventory():reward_item_promo(def_id, callback)
end

-- Lines 147-149
function Steam:inventory_reward_open(instance_id, def_id, callback)
	return Distribution:inventory():exchange_items({
		instance_id
	}, def_id, callback)
end

-- Lines 151-153
function Steam:inventory_reward_unlock(safe_instance_id, drill_instance_id, generator_def_id, callback)
	return Distribution:inventory():exchange_items({
		safe_instance_id,
		drill_instance_id
	}, generator_def_id, callback)
end

-- Lines 154-156
function Steam:inventory_signature_create(instance_ids, callback)
	callback(false, "")
end

-- Lines 157-159
function Steam:inventory_signature_verify(steam_id, outfit, callback)
	callback(false, {})
end

-- Lines 161-164
function Steam:inventory_split_item(instance_id, callback)
	return Distribution:inventory():split_item_stack(instance_id, "", 1, callback)
end

-- Lines 165-167
function Steam:inventory_alter_stacks(source_instance_id, destination_instance_id, quantity, callback)
	return Distribution:inventory():split_item_stack(source_instance_id, destination_instance_id, quantity, callback)
end

-- Lines 168-168
function Steam:inventory_remove(instance_id)
	return
end

-- Lines 181-183
function Steam:set_rich_presence(key, value)
	Distribution:set_rich_presence(key, value)
end

-- Lines 184-186
function Steam:clear_rich_presence()
	Distribution:clear_rich_presence()
end

-- Lines 188-190
function Steam:set_connect_string(connect_string)
	Distribution:set_connect_string(connect_string)
end

-- Lines 192-194
function Steam:get_connect_string()
	return Distribution:connect_string()
end

-- Lines 199-199
function Steam:check_migration_status()
	return
end

-- Lines 200-200
function Steam:copy_file()
	return
end

-- Lines 201-201
function Steam:delete_cloud_file()
	return
end

-- Lines 202-202
function Steam:delete_cloud_linux()
	return
end

-- Lines 203-203
function Steam:delete_cloud_windows()
	return
end

-- Lines 204-204
function Steam:display_cloud_files()
	return
end

-- Lines 209-209
function Steam:gamepad_text_listener(callback)
	return
end

-- Lines 211-211
function Steam:overlay_set_position(position)
	return
end

-- Lines 212-212
function Steam:show_gamepad_text_input(input_mode, input_line_mode, description, char_max, existing_text)
	return
end

-- Lines 213-213
function Steam:usa_viewer(user_id)
	return
end

-- Lines 216-218
function Steam:request_listener(join_request_callback, server_join_request_callback)
	Distribution:set_join_callbacks(join_request_callback, server_join_request_callback)
end

-- Lines 220-222
function Steam:error_listener(disconnected_callback, ipc_fail_callback, connect_fail_callback)
	Distribution:set_error_callbacks(disconnected_callback)
end

-- Lines 224-226
function Steam:overlay_listener(open_overlay_callback, close_overlay_callback)
	Distribution:set_overlay_callbacks(open_overlay_callback, close_overlay_callback)
end

-- Lines 229-230
function Steam:set_playing(state)
	return
end

-- Lines 232-234
function Steam:overlay_open()
	return Distribution:overlay_open()
end

-- Lines 236-238
function Steam:overlay_enabled()
	return Distribution:overlay_available()
end

-- Lines 240-246
function Steam:overlay_activate(type, destination, extra_flags)
	if type == "invite" then
		type = "game"
		destination = "LobbyInvite"
	end

	return Distribution:open_overlay(type, destination, extra_flags)
end

-- Lines 248-250
function Steam:current_language()
	return Distribution:language()
end

-- Lines 252-254
function Steam:available_languages()
	return Distribution:available_languages()
end

-- Lines 256-258
function Steam:is_low_violence()
	return false
end

-- Lines 260-262
function Steam:ugc_handler()
	return getmetatable(Distribution).ugc and Distribution:ugc()
end

-- Lines 264-276
function Steam:sa_handler()
	local achievements = Distribution:achievements()

	shadow_class_instance_function(achievements, "set_achievement", "grant_achievement")
	shadow_class_instance_function(achievements, "clear_achievement", "remove_achievement")
	shadow_class_instance_function(achievements, "clear_achievement", "remove_achievement")
	shadow_class_instance_function(achievements, "friends_achievements_cache", "start_using_friends_achievements_cache")
	shadow_class_instance_function(achievements, "friends_achievements_clear", "stop_using_friends_achievements_cache")
	shadow_class_instance_function(achievements, "refresh_global_stats_cb", "refresh_global_stats_callback")

	getmetatable(achievements).initialized = function(self)
		return true
	end

	return achievements
end

-- Lines 278-280
function Steam:lb_handler()
	return Distribution:leaderboard()
end

-- Lines 282-284
function Steam:client_running()
	return true
end

-- Lines 286-288
function Steam:steam_texture(handle)
	return Distribution:distribution_texture(handle)
end

-- Lines 290-292
function Steam:clear_image_cache()
	Distribution:clear_distribution_texture_cache()
end

-- Lines 294-296
function Steam:voip_handler()
	return DistributionMatchmaking:voice_chat()
end

-- Lines 298-300
function Steam:server_time()
	return Distribution:server_time()
end

-- Lines 302-313
function Steam:http_request(url, callback, headers)
	-- Lines 304-310
	local function new_callback(error_code, status_code, response_body)
		if status_code >= 200 and status_code <= 206 then
			callback(true, response_body)
		else
			callback(false)
		end
	end

	Distribution:make_http_request("GET", url, new_callback, headers)
end

-- Lines 314-316
function Steam:http_request_post(url, callback, content_type, body, body_size, headers)
	Distribution:make_http_request("POST", url, callback, headers, content_type, body, body_size)
end

-- Lines 317-319
function Steam:http_request_put(url, callback, content_type, body, body_size, headers)
	Distribution:make_http_request("PUT", url, callback, headers, content_type, body, body_size)
end

-- Lines 321-323
function LobbyBrowser(on_match_callback, on_update_callback)
	return DistributionMatchmaking:create_lobby_browser(on_match_callback, on_update_callback)
end

-- Lines 325-327
function __classes.SystemInfo:matchmaking_protocol()
	return DistributionMatchmaking:network_protocol()
end
