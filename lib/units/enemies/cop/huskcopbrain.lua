local IDS_BRAIN = Idstring("brain")

HuskCopBrain = HuskCopBrain or class()
HuskCopBrain._get_radio_id = CopBrain._get_radio_id
HuskCopBrain._setup_attention_handler = CopBrain._setup_attention_handler
HuskCopBrain.attention_handler = CopBrain.attention_handler
HuskCopBrain._NET_EVENTS = {
	surrender_civilian_tied = 5,
	surrender_civilian_untied = 6,
	surrender_cop_tied = 3,
	surrender_cop_untied = 4,
	weapon_laser_off = 2,
	weapon_laser_on = 1
}
HuskCopBrain._ENABLE_LASER_TIME = 3

-- Lines 57-69
function HuskCopBrain:init(unit)
	self._unit = unit
	self._is_hostage = false
	self._surrendered = false
	self._converted = false

	unit:set_extension_update_enabled(IDS_BRAIN, false)
end

-- Lines 73-104
function HuskCopBrain:post_init()
	local base_ext = self._unit:base()

	self._is_criminal = base_ext._is_team_ai or false
	self._is_civilian = base_ext._is_civilian or false

	self._unit:character_damage():add_listener("HuskCopBrain_death" .. tostring(self._unit:key()), {
		"death"
	}, callback(self, self, "clbk_death"))
	self:_setup_attention_handler()

	self._post_init_complete = true
end

-- Lines 108-110
function HuskCopBrain:interaction_voice()
	return self._interaction_voice
end

-- Lines 114-119
function HuskCopBrain:on_intimidated(amount, aggressor_unit)
	amount = math.clamp(math.ceil(amount * 10), 0, 10)

	self._unit:network():send_to_host("long_dis_interaction", amount, aggressor_unit, false)

	return self._interaction_voice
end

-- Lines 123-151
function HuskCopBrain:clbk_death(my_unit, damage_info)
	self._dead = true
	self._is_hostage = false
	self._surrendered = false
	self._converted = false
	self._add_laser_t = nil

	self._unit:set_extension_update_enabled(IDS_BRAIN, false)

	if self._weapon_laser_on then
		self:disable_weapon_laser()
	end

	if self._alert_listen_key then
		managers.groupai:state():remove_alert_listener(self._alert_listen_key)

		self._alert_listen_key = nil
	end

	if self._following_hostage_contour_id then
		self._unit:contour():remove_by_id(self._following_hostage_contour_id)

		self._following_hostage_contour_id = nil
	end

	self._unit:movement():synch_attention()
end

-- Lines 155-157
function HuskCopBrain:set_interaction_voice(voice)
	self._interaction_voice = voice
end

-- Lines 161-198
function HuskCopBrain:load(load_data)
	local my_load_data = load_data.brain

	self._dead = my_load_data.dead

	self:set_interaction_voice(my_load_data.interaction_voice)

	if my_load_data.weapon_laser_on then
		self:sync_net_event(self._NET_EVENTS.weapon_laser_on)
	end

	if my_load_data.trade_flee_contour then
		self._unit:contour():add("hostage_trade", nil, nil)
	end

	if my_load_data.following_hostage_contour then
		self._unit:contour():add("friendly", nil, nil)
	end

	self._surrendered = my_load_data.surrendered

	if my_load_data.is_civilian_tied then
		self:sync_net_event(self._NET_EVENTS.surrender_civilian_tied)
	elseif my_load_data.is_cop_tied then
		self:sync_net_event(self._NET_EVENTS.surrender_cop_tied)
	end
end

-- Lines 202-204
function HuskCopBrain:on_tied(aggressor_unit, not_tied, can_flee)
	self._unit:network():send_to_host("unit_tied", aggressor_unit, can_flee)
end

-- Lines 208-210
function HuskCopBrain:on_trade(position, rotation)
	self._unit:network():send_to_host("unit_traded", position, rotation)
end

-- Lines 214-215
function HuskCopBrain:on_cool_state_changed(state)
	return
end

-- Lines 219-220
function HuskCopBrain:action_complete_clbk(action)
	return
end

-- Lines 234-250
function HuskCopBrain:on_alert(alert_data)
	return
end

-- Lines 254-260
function HuskCopBrain:sync_surrender(surrendered)
	if self._dead then
		return
	end

	self._surrendered = surrendered
end

-- Lines 262-264
function HuskCopBrain:surrendered()
	return self._surrendered
end

-- Lines 266-268
function HuskCopBrain:is_tied()
	return self._is_hostage
end

-- Lines 270-272
function HuskCopBrain:is_hostage()
	return self._is_hostage
end

-- Lines 276-282
function HuskCopBrain:sync_converted()
	if self._dead then
		return
	end

	self._converted = true
end

-- Lines 284-286
function HuskCopBrain:converted()
	return self._converted
end

-- Lines 290-292
function HuskCopBrain:is_hostile()
	return not self._surrendered and not self._converted
end

-- Lines 296-300
function HuskCopBrain:on_long_dis_interacted(amount, aggressor_unit, secondary)
	secondary = secondary or false
	amount = math.clamp(math.ceil(amount * 10), 0, 10)

	self._unit:network():send_to_host("long_dis_interaction", amount, aggressor_unit, secondary)
end

-- Lines 303-305
function HuskCopBrain:player_ignore()
	return false
end

-- Lines 310-310
function HuskCopBrain:on_team_set(team_data)
	return
end

-- Lines 314-322
function HuskCopBrain:update(unit, t, dt)
	if self._post_init_complete and self._add_laser_t then
		self._add_laser_t = self._add_laser_t - dt

		if self._add_laser_t < 0 then
			self:enable_weapon_laser()

			self._add_laser_t = nil
		end
	end
end

-- Lines 386-442
function HuskCopBrain:sync_net_event(event_id)
	if self._dead then
		return
	end

	if event_id == self._NET_EVENTS.weapon_laser_on then
		self._add_laser_t = HuskCopBrain._ENABLE_LASER_TIME

		self._unit:set_extension_update_enabled(Idstring("brain"), true)
	elseif event_id == self._NET_EVENTS.weapon_laser_off then
		if self._weapon_laser_on then
			self:disable_weapon_laser()
		elseif self._add_laser_t then
			self._add_laser_t = nil

			self._unit:set_extension_update_enabled(Idstring("brain"), false)
		end
	elseif event_id == self._NET_EVENTS.surrender_cop_tied then
		self._is_hostage = true

		self._unit:inventory():destroy_all_items()
		self._unit:base():set_slot(self._unit, 22)
	elseif event_id == self._NET_EVENTS.surrender_civilian_tied then
		self._surrendered = true
		self._is_hostage = true

		self._unit:inventory():destroy_all_items()
		self._unit:base():set_slot(self._unit, 22)
	elseif event_id == self._NET_EVENTS.surrender_cop_untied then
		self._surrendered = false
		self._is_hostage = false

		if self._converted then
			self._unit:base():set_slot(self._unit, 16)
		else
			self._unit:base():set_slot(self._unit, 12)
		end
	elseif event_id == self._NET_EVENTS.surrender_civilian_untied then
		self._surrendered = false
		self._is_hostage = false

		self._unit:base():set_slot(self._unit, 21)
	end
end

-- Lines 445-466
function HuskCopBrain:enable_weapon_laser()
	self._add_laser_t = nil

	local weapon = self._unit:inventory():equipped_unit()
	local weap_base_ext = weapon and weapon:base()

	if weap_base_ext and weap_base_ext.set_laser_enabled then
		self._weapon_laser_on = true

		weap_base_ext:set_laser_enabled(true)
		self._unit:base():prevent_main_bones_disabling(true)
	end

	self._unit:set_extension_update_enabled(IDS_BRAIN, false)
end

-- Lines 468-495
function HuskCopBrain:disable_weapon_laser()
	self._add_laser_t = nil

	if self._weapon_laser_on then
		self._weapon_laser_on = nil

		local weapon = self._unit:inventory():equipped_unit()
		local weap_base_ext = weapon and weapon:base()

		if weap_base_ext and weap_base_ext.set_laser_enabled then
			weap_base_ext:set_laser_enabled(false)
		end

		self._unit:base():prevent_main_bones_disabling(false)
	end

	self._unit:set_extension_update_enabled(IDS_BRAIN, false)
end

-- Lines 499-515
function HuskCopBrain:pre_destroy()
	self._unit:movement():synch_attention()

	self._add_laser_t = nil

	if self._weapon_laser_on then
		self:disable_weapon_laser()
	end
end

-- Lines 521-522
function HuskCopBrain:_setup_fake_attention_handler()
	return
end
