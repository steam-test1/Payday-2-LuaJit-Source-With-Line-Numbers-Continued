NetworkAccount = NetworkAccount or class()

-- Lines: 3 to 6
function NetworkAccount:init()
	self._postprocess_username = callback(self, self, "_standard_username")

	self:set_lightfx()
end

-- Lines: 8 to 9
function NetworkAccount:update()
end

-- Lines: 11 to 12
function NetworkAccount:create_account(name, password, email)
end

-- Lines: 14 to 15
function NetworkAccount:reset_password(name, email)
end

-- Lines: 17 to 18
function NetworkAccount:login(name, password, cdkey)
end

-- Lines: 20 to 21
function NetworkAccount:logout()
end

-- Lines: 23 to 24
function NetworkAccount:register_callback(event, callback)
end

-- Lines: 26 to 28
function NetworkAccount:register_post_username(cb)
	self._postprocess_username = cb
end

-- Lines: 30 to 31
function NetworkAccount:username()
	return self._postprocess_username(self:username_id())
end

-- Lines: 34 to 35
function NetworkAccount:username_id()
	return 0
end

-- Lines: 38 to 39
function NetworkAccount:username_by_id()
	return ""
end

-- Lines: 42 to 43
function NetworkAccount:signin_state()
	return "not signed in"
end

-- Lines: 46 to 60
function NetworkAccount:set_lightfx()
	if SystemInfo:platform() ~= Idstring("WIN32") then
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

-- Lines: 62 to 63
function NetworkAccount:has_alienware()
	return self._has_alienware
end

-- Lines: 66 to 70
function NetworkAccount:clan_tag()
	if managers.save.get_profile_setting and managers.save:get_profile_setting("clan_tag") and string.len(managers.save:get_profile_setting("clan_tag")) > 0 then
		return "[" .. managers.save:get_profile_setting("clan_tag") .. "]"
	end

	return ""
end

-- Lines: 73 to 74
function NetworkAccount:_standard_username(name)
	return name
end

-- Lines: 77 to 78
function NetworkAccount:set_playing(state)
end

-- Lines: 80 to 81
function NetworkAccount:_load_globals()
end

-- Lines: 83 to 84
function NetworkAccount:_save_globals()
end

-- Lines: 86 to 87
function NetworkAccount:inventory_load()
end

-- Lines: 89 to 90
function NetworkAccount:inventory_is_loading()
end

-- Lines: 92 to 93
function NetworkAccount:inventory_reward(item)
	return false
end

-- Lines: 96 to 97
function NetworkAccount:inventory_reward_dlc()
end

-- Lines: 99 to 100
function NetworkAccount:inventory_reward_unlock(box, key)
end

-- Lines: 102 to 103
function NetworkAccount:inventory_reward_open(item)
end

-- Lines: 105 to 106
function NetworkAccount:inventory_outfit_refresh()
end

-- Lines: 108 to 109
function NetworkAccount:inventory_outfit_verify(id, outfit_data, outfit_callback)
end

-- Lines: 111 to 112
function NetworkAccount:inventory_outfit_signature()
	return ""
end

-- Lines: 115 to 116
function NetworkAccount:inventory_repair_list(list)
end

-- Lines: 118 to 119
function NetworkAccount:is_ready_to_close()
	return true
end

