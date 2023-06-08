NetworkAccount = NetworkAccount or class()

-- Lines 3-9
function NetworkAccount:init()
	self._postprocess_username = callback(self, self, "_standard_username")

	self:set_lightfx()

	self._friends = {}
	self._listener_holder = EventListenerHolder:new()
end

-- Lines 11-12
function NetworkAccount:update()
end

-- Lines 14-15
function NetworkAccount:create_account(name, password, email)
end

-- Lines 17-18
function NetworkAccount:reset_password(name, email)
end

-- Lines 20-21
function NetworkAccount:login(name, password, cdkey)
end

-- Lines 23-24
function NetworkAccount:logout()
end

-- Lines 26-27
function NetworkAccount:register_callback(event, callback)
end

-- Lines 29-31
function NetworkAccount:register_post_username(cb)
	self._postprocess_username = cb
end

-- Lines 33-35
function NetworkAccount:username()
	return self._postprocess_username(self:username_id())
end

-- Lines 37-39
function NetworkAccount:username_id()
	return 0
end

-- Lines 41-43
function NetworkAccount:username_by_id()
	return ""
end

-- Lines 45-47
function NetworkAccount:player_id()
	return ""
end

-- Lines 49-51
function NetworkAccount:is_achievements_fetched()
	return self._achievements_fetched
end

-- Lines 53-61
function NetworkAccount:is_player_friend(player_id)
	for _, friend in ipairs(self._friends) do
		if friend.id == player_id then
			return true
		end
	end

	return false
end

-- Lines 63-70
function NetworkAccount:add_friend(id, name)
	if self:is_player_friend(id) then
		return false
	end

	table.insert(self._friends, {
		id = id,
		name = name
	})

	return true
end

-- Lines 72-81
function NetworkAccount:remove_friend(id)
	for i, friend in ipairs(self._friends) do
		if friend.id == player_id then
			table.remove(self._friends, i)

			return true
		end
	end

	return false
end

-- Lines 83-85
function NetworkAccount:get_friend_user(player_id)
	return nil
end

-- Lines 87-89
function NetworkAccount:signin_state()
	return "not signed in"
end

-- Lines 91-110
function NetworkAccount:set_lightfx()
	if SystemInfo:platform() ~= Idstring("WIN32") then
		return
	end

	local LightFXClass = getmetatable(LightFX)

	if not LightFXClass then
		return
	end

	if managers.user:get_setting("use_lightfx") then
		print("[NetworkAccount:init] Initializing LightFX...")

		self._has_alienware = LightFX:initialize() and LightFX:has_lamps()

		if self._has_alienware then
			LightFX:set_lamps(0, 255, 0, 255)
		end
	else
		self._has_alienware = nil
	end
end

-- Lines 112-114
function NetworkAccount:has_alienware()
	return self._has_alienware
end

-- Lines 116-120
function NetworkAccount:_call_listeners(event, params)
	if self._listener_holder then
		self._listener_holder:call(event, params)
	end
end

-- Lines 122-124
function NetworkAccount:add_overlay_listener(key, events, clbk)
	self._listener_holder:add(key, events, clbk)
end

-- Lines 126-128
function NetworkAccount:remove_overlay_listener(key)
	self._listener_holder:remove(key)
end

-- Lines 130-132
function NetworkAccount:is_overlay_enabled()
	return false
end

-- Lines 134-135
function NetworkAccount:overlay_activate()
end

-- Lines 137-139
function NetworkAccount:open_dlc_store_page(dlc_data, context)
	return false
end

-- Lines 141-143
function NetworkAccount:open_new_heist_page(new_heist_data)
	return false
end

-- Lines 145-150
function NetworkAccount:clan_tag()
	if managers.save.get_profile_setting and managers.save:get_profile_setting("clan_tag") and string.len(managers.save:get_profile_setting("clan_tag")) > 0 then
		return "[" .. managers.save:get_profile_setting("clan_tag") .. "]"
	end

	return ""
end

-- Lines 152-154
function NetworkAccount:_standard_username(name)
	return name
end

-- Lines 156-157
function NetworkAccount:set_playing(state)
end

-- Lines 159-160
function NetworkAccount:set_played_with(id)
end

-- Lines 162-163
function NetworkAccount:_load_globals()
end

-- Lines 165-166
function NetworkAccount:_save_globals()
end

-- Lines 168-169
function NetworkAccount:inventory_load()
end

-- Lines 171-172
function NetworkAccount:inventory_is_loading()
end

-- Lines 174-176
function NetworkAccount:inventory_reward(item)
	return false
end

-- Lines 178-179
function NetworkAccount:inventory_reward_dlc()
end

-- Lines 181-182
function NetworkAccount:inventory_reward_unlock(box, key)
end

-- Lines 184-185
function NetworkAccount:inventory_reward_open(item)
end

-- Lines 187-188
function NetworkAccount:inventory_outfit_refresh()
end

-- Lines 190-191
function NetworkAccount:inventory_outfit_verify(id, outfit_data, outfit_callback)
end

-- Lines 193-195
function NetworkAccount:inventory_outfit_signature()
	return ""
end

-- Lines 197-198
function NetworkAccount:inventory_repair_list(list)
end

-- Lines 200-202
function NetworkAccount:is_ready_to_close()
	return true
end

-- Lines 204-205
function NetworkAccount:experience_loaded()
end

local sa_handler_funcs = {
	"init",
	"initialized",
	"store_data",
	"clear_all_stats",
	"stats_store_callback",
	"has_stat",
	"has_stat_float",
	"set_stats",
	"set_stat",
	"set_stat_float",
	"set_stat_avgrate",
	"get_stat",
	"get_stat_float",
	"get_global_stat",
	"get_global_stat_float",
	"get_lifetime_stat",
	"refresh_global_stats",
	"refresh_global_stats_cb",
	"initialized_callback",
	"achievement_store_callback",
	"set_achievement",
	"achievement_attribute",
	"clear_achievement",
	"has_achievement",
	"achievement_unlock_time",
	"achievement_achieved_percent",
	"achievement_icon",
	"indicate_achievement_progress",
	"friends_achievements_cache",
	"friends_achievements_clear",
	"friends_with_achievement",
	"concurrent_users_callback",
	"get_concurrent_users"
}
local sa_handler_stub = class()

for _, func_name in ipairs(sa_handler_funcs) do
	sa_handler_stub[func_name] = function (self)
		print("[NetworkAccount] sa_handler NYI", func_name)
	end
end

-- Lines 217-219
function NetworkAccount:get_sa_handler()
	return sa_handler_stub
end

-- Lines 221-222
function NetworkAccount:set_stat(key, value)
end

-- Lines 224-226
function NetworkAccount:get_stat(key)
	return 0
end

-- Lines 228-230
function NetworkAccount:has_stat(key)
	return false
end

-- Lines 232-234
function NetworkAccount:achievement_unlock_time(key)
	return nil
end

-- Lines 236-238
function NetworkAccount:get_lifetime_stat(key)
	return 0
end

-- Lines 240-242
function NetworkAccount:get_global_stat(key, days)
	return 0
end

-- Lines 244-245
function NetworkAccount:publish_statistics(stats, force_store)
end
