CopActionReload = CopActionReload or class()

-- Lines 4-43
function CopActionReload:init(action_desc, common_data)
	self._common_data = common_data
	self._body_part = action_desc.body_part
	self._unit = common_data.unit
	self._machine = common_data.machine
	self._ext_movement = common_data.ext_movement
	self._ext_anim = common_data.ext_anim
	self._ext_inventory = common_data.ext_inventory

	local weapon_unit = self._ext_inventory:equipped_unit()

	if not weapon_unit then
		return false
	end

	self._reload_speed = common_data.ext_movement:get_reload_speed_multiplier()
	self._looped_expire_time = common_data.ext_movement:get_looped_reload_time()

	if self._ext_anim.reload or self:_play_reload() then
		return true
	else
		cat_error("george", "[CopActionReload:init] failed in", self._machine:segment_state(Idstring("upper_body")))
	end
end

-- Lines 47-62
function CopActionReload:on_inventory_event(event)
	if self._expired or event ~= "equip" and event ~= "unequip" then
		return
	end

	self._expired = true

	if self._ext_anim.reload then
		if self._looped_expire_t then
			self._looped_expire_t = nil

			self._ext_movement:play_redirect("reload_looped_exit")
		else
			self._ext_movement:play_redirect("up_idle")
		end
	end
end

-- Lines 80-86
function CopActionReload:on_exit()
	if self._expired or not self._looped_expire_t or not self._ext_anim.reload then
		return
	end

	self._ext_movement:play_redirect("reload_looped_exit")
end

-- Lines 91-93
function CopActionReload:type()
	return "reload"
end

-- Lines 97-118
function CopActionReload:update(t)
	if not self._ext_anim.reload then
		self._expired = true
	else
		if self._looped_expire_t and t > self._looped_expire_t then
			self._looped_expire_t = nil

			self._ext_movement:play_redirect("reload_looped_exit")
		end

		if self._ext_anim.base_need_upd then
			self._ext_movement:upd_m_head_pos()
		end
	end
end

-- Lines 122-140
function CopActionReload:_play_reload()
	local redir_res = self._ext_movement:play_redirect(self._looped_expire_time and "reload_looped_start" or "reload")

	if not redir_res then
		cat_print("george", "[CopActionReload:_play_reload] reload redirect failed in", self._machine:segment_state(Idstring("upper_body")))

		return
	end

	if self._reload_speed and not self._looped_expire_time then
		self._machine:set_speed(redir_res, self._reload_speed)
	end

	if Network:is_server() then
		managers.network:session():send_to_peers("reload_weapon_cop", self._unit)
	end

	return redir_res
end

-- Lines 142-159
function CopActionReload:_play_bleedout_reload()
	local redir_res = self._ext_movement:play_redirect("reload")

	if not redir_res then
		cat_print("george", "[CopActionReload:_play_reload] reload redirect failed in", self._machine:segment_state(Idstring("base")))

		return
	end

	if self._reload_speed then
		self._machine:set_speed(redir_res, self._reload_speed)
	end

	if Network:is_server() then
		managers.network:session():send_to_peers("reload_weapon_cop", self._unit)
	end

	return redir_res
end

-- Lines 161-165
function CopActionReload:on_looped_reload_looping()
	if self._looped_expire_time then
		self._looped_expire_t = TimerManager:game():time() + self._looped_expire_time
	end
end

-- Lines 169-171
function CopActionReload:body_part()
	return self._body_part
end

-- Lines 175-177
function CopActionReload:expired()
	return self._expired
end

-- Lines 181-183
function CopActionReload:need_upd()
	return true
end
