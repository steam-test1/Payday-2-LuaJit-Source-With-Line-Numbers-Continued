MutatorShotgunTweak = MutatorShotgunTweak or class(BaseMutator)
MutatorShotgunTweak._type = "MutatorShotgunTweak"
MutatorShotgunTweak.name_id = "mutator_shotgun_tweak"
MutatorShotgunTweak.desc_id = "mutator_shotgun_tweak_desc"
MutatorShotgunTweak.has_options = true
MutatorShotgunTweak.reductions = {
	money = 0,
	exp = 0
}
MutatorShotgunTweak.disables_achievements = true
MutatorShotgunTweak.icon_coords = {
	7,
	1
}

-- Lines: 15 to 18
function MutatorShotgunTweak:register_values(mutator_manager)
	self:register_value("pull_strength", 3, "ps")
	self:register_value("mothership", false, "ms")
end

-- Lines: 20 to 23
function MutatorShotgunTweak:setup(mutator_manager)
	mutator_manager:register_message(Message.OnShotgunPush, "ShotgunTweak", callback(self, self, "_on_shotgun_push"))

	self._sound_device = SoundDevice:create_source("MutatorShotgunTweak")
end

-- Lines: 25 to 34
function MutatorShotgunTweak:name()
	local name = MutatorShotgunTweak.super.name(self)

	if self:_mutate_name("mothership") then
		return string.format("%s - %s", name, managers.localization:text("mutator_shotgun_tweak_mothership"))
	elseif self:_mutate_name("pull_strength") then
		return string.format("%s - %.2fx", name, tonumber(self:value("pull_strength")))
	else
		return name
	end
end

-- Lines: 38 to 44
function MutatorShotgunTweak:get_pull_strength()
	if self:get_to_the_mothership() then
		return self:to_the_mothership_strength()
	else
		return self:value("pull_strength")
	end
end

-- Lines: 46 to 53
function MutatorShotgunTweak:get_to_the_mothership()
	local value = self:value("mothership")

	if type(value) == "table" then
		return value.current
	else
		return value
	end
end

-- Lines: 55 to 56
function MutatorShotgunTweak:to_the_mothership_strength()
	return 0.01
end

-- Lines: 62 to 83
function MutatorShotgunTweak:_on_shotgun_push(unit, hit_pos, dir, distance, attacker)
	if alive(unit) and alive(attacker) then
		local str = self:get_pull_strength()

		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_Head"), attacker:body("inflict_reciever"), str)
		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_Hips"), attacker:body("inflict_reciever"), str)
		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_Spine"), attacker:body("inflict_reciever"), str)
		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_Spine1"), attacker:body("inflict_reciever"), str)
		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_Spine2"), attacker:body("inflict_reciever"), str)
		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_RightForeArm"), attacker:body("inflict_reciever"), str)
		World:play_physic_effect(Idstring("physic_effects/shotgun_wat"), unit:body("rag_LeftForeArm"), attacker:body("inflict_reciever"), str)

		if attacker == managers.player:player_unit() and self._sound_device then
			self._sound_device:stop()
			self._sound_device:set_position(attacker:position())
			self._sound_device:set_orientation(attacker:rotation())
			self._sound_device:post_event("mutators_hfos_01")
		end
	end
end

-- Lines: 85 to 108
function MutatorShotgunTweak:modify_value(id, value)
	if id == "GamePlayCentralManager:get_shotgun_push_range" then
		return math.huge
	elseif id == "EnemyManager:corpse_limit" then
		if self:get_to_the_mothership() then
			return 4
		else
			return math.min(value, 16)
		end
	elseif id == "ShotgunBase:_fire_raycast" then
		if value and value.hit_enemy and value.hit_enemy.type == "death" then
			value.type = "death"
		end

		if value and value.variant == "explosion" then
			value.type = "death"
		end

		return value
	end
end

-- Lines: 110 to 114
function MutatorShotgunTweak:OnEnemyKilledByExplosion(unit, was_shotgun)
	if was_shotgun then
		self:_on_shotgun_push(unit, nil, nil, nil, managers.player:player_unit())
	end
end

-- Lines: 118 to 119
function MutatorShotgunTweak:_min_strength()
	return 1
end

-- Lines: 122 to 123
function MutatorShotgunTweak:_max_strength()
	return 5
end

-- Lines: 127 to 162
function MutatorShotgunTweak:setup_options_gui(node)
	local params = {
		name = "pull_strength_slider",
		callback = "_update_mutator_value",
		text_id = "menu_shotgun_tweak",
		update_callback = callback(self, self, "_update_pull_strength")
	}
	local data_node = {
		show_value = true,
		step = 0.1,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 2,
		min = self:_min_strength(),
		max = self:_max_strength()
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_value(self:get_pull_strength())
	node:add_item(new_item)

	local params = {
		name = "mothership_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_shotgun_tweak_mothership",
		update_callback = callback(self, self, "_update_mothership_toggle")
	}
	local data = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox"
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox"
		},
		type = "CoreMenuItemToggle.ItemToggle"
	}
	local new_item = node:create_item(data, params)

	new_item:set_value(self:get_to_the_mothership() and "on" or "off")
	node:add_item(new_item)

	self._node = node

	return new_item
end

-- Lines: 166 to 168
function MutatorShotgunTweak:_update_pull_strength(item)
	self:set_value("pull_strength", item:value())
end

-- Lines: 170 to 182
function MutatorShotgunTweak:_update_mothership_toggle(item)
	local value = item:value() == "on" and true or false

	self:set_value("mothership", value)

	if self._node then
		local slider = self._node:item("pull_strength_slider")

		if slider then
			if value then
				slider:set_value(self:to_the_mothership_strength())
			end

			slider:set_enabled(not value)
		end
	end
end

-- Lines: 185 to 203
function MutatorShotgunTweak:reset_to_default()
	self:clear_values()

	if self._node then
		local slider = self._node:item("pull_strength_slider")

		if slider then
			slider:set_value(self:get_pull_strength())
			slider:set_enabled(true)
		end

		local toggle = self._node:item("mothership_toggle")

		if toggle then
			toggle:set_value(self:get_to_the_mothership() and "on" or "off")
		end
	end
end

-- Lines: 205 to 206
function MutatorShotgunTweak:options_fill()
	return self:_get_percentage_fill(self:_min_strength(), self:_max_strength(), self:get_pull_strength())
end

