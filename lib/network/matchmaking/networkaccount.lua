NetworkAccount = NetworkAccount or class()

-- Lines 3-6
function NetworkAccount:init()
	self._postprocess_username = callback(self, self, "_standard_username")

	self:set_lightfx()
end

-- Lines 8-9
function NetworkAccount:update()
end

-- Lines 11-12
function NetworkAccount:create_account(name, password, email)
end

-- Lines 14-15
function NetworkAccount:reset_password(name, email)
end

-- Lines 17-18
function NetworkAccount:login(name, password, cdkey)
end

-- Lines 20-21
function NetworkAccount:logout()
end

-- Lines 23-24
function NetworkAccount:register_callback(event, callback)
end

-- Lines 26-28
function NetworkAccount:register_post_username(cb)
	self._postprocess_username = cb
end

-- Lines 30-32
function NetworkAccount:username()
	return self._postprocess_username(self:username_id())
end

-- Lines 34-36
function NetworkAccount:username_id()
	return 0
end

-- Lines 38-40
function NetworkAccount:username_by_id()
	return ""
end

-- Lines 42-44
function NetworkAccount:signin_state()
	return "not signed in"
end

-- Lines 46-60
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

-- Lines 62-64
function NetworkAccount:has_alienware()
	return self._has_alienware
end

-- Lines 66-71
function NetworkAccount:clan_tag()
	if managers.save.get_profile_setting and managers.save:get_profile_setting("clan_tag") and string.len(managers.save:get_profile_setting("clan_tag")) > 0 then
		return "[" .. managers.save:get_profile_setting("clan_tag") .. "]"
	end

	return ""
end

-- Lines 73-75
function NetworkAccount:_standard_username(name)
	return name
end

-- Lines 77-78
function NetworkAccount:set_playing(state)
end

-- Lines 80-81
function NetworkAccount:_load_globals()
end

-- Lines 83-84
function NetworkAccount:_save_globals()
end

-- Lines 86-87
function NetworkAccount:inventory_load()
end

-- Lines 89-90
function NetworkAccount:inventory_is_loading()
end

-- Lines 92-94
function NetworkAccount:inventory_reward(item)
	return false
end

-- Lines 96-97
function NetworkAccount:inventory_reward_dlc()
end

-- Lines 99-100
function NetworkAccount:inventory_reward_unlock(box, key)
end

-- Lines 102-103
function NetworkAccount:inventory_reward_open(item)
end

-- Lines 105-106
function NetworkAccount:inventory_outfit_refresh()
end

-- Lines 108-109
function NetworkAccount:inventory_outfit_verify(id, outfit_data, outfit_callback)
end

-- Lines 111-113
function NetworkAccount:inventory_outfit_signature()
	return ""
end

-- Lines 115-116
function NetworkAccount:inventory_repair_list(list)
end

-- Lines 118-120
function NetworkAccount:is_ready_to_close()
	return true
end
