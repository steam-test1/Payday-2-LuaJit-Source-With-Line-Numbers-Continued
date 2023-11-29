TeamAIMovement = TeamAIMovement or class(CopMovement)
local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_len = mvector3.length

-- Lines 8-25
function TeamAIMovement:_post_init()
	if managers.groupai:state():whisper_mode() then
		if not self._heat_listener_clbk and Network:is_server() then
			self._heat_listener_clbk = "TeamAIMovement" .. tostring(self._unit:key())

			managers.groupai:state():add_listener(self._heat_listener_clbk, {
				"whisper_mode"
			}, callback(self, self, "heat_clbk"))
		end

		self._unit:base():set_slot(self._unit, 24)
	else
		self:set_cool(false)
	end

	self._standing_nav_seg_id = self._nav_tracker:nav_segment()

	self:play_redirect("idle")

	self._last_position = Vector3()
end

-- Lines 29-45
function TeamAIMovement:set_character_anim_variables()
	local char_name = managers.criminals:character_name_by_unit(self._unit)

	if char_name and self._unit:damage() then
		local ai_character_id = managers.criminals:character_static_data_by_name(char_name).ai_character_id
		local sequence = tweak_data.blackmarket.characters[ai_character_id].sequence

		if sequence ~= self._current_sequence then
			self._unit:damage():run_sequence_simple(sequence)

			self._current_sequence = sequence
		end
	end

	HuskPlayerMovement.set_character_anim_variables(self)
	self._unit:inventory():preload_mask()
end

-- Lines 47-48
function TeamAIMovement:check_visual_equipment()
end

-- Lines 52-73
function TeamAIMovement:add_weapons()
	if Network:is_server() then
		local char_name = self._ext_base._tweak_table
		local loadout = managers.criminals:get_loadout_for(char_name)
		local crafted = managers.blackmarket:get_crafted_category_slot("primaries", loadout.primary_slot)

		if crafted then
			self._unit:inventory():add_unit_by_factory_blueprint(loadout.primary, false, false, crafted.blueprint, crafted.cosmetics)
		elseif loadout.primary then
			self._unit:inventory():add_unit_by_factory_name(loadout.primary, false, false, nil, "")
		else
			local weapon = self._ext_base:default_weapon_name("primary")
			local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
		end

		local sec_weap_name = self._ext_base:default_weapon_name("secondary")
		local _ = sec_weap_name and self._unit:inventory():add_unit_by_name(sec_weap_name)
	else
		TeamAIMovement.super.add_weapons(self)
	end
end

-- Lines 78-80
function TeamAIMovement:m_detect_pos()
	return self._m_head_pos
end

-- Lines 84-87
function TeamAIMovement:set_position(pos)
	CopMovement.set_position(self, pos)
	self:_upd_location()
end

-- Lines 91-94
function TeamAIMovement:set_m_pos(pos)
	CopMovement.set_m_pos(self, pos)
	self:_upd_location()
end

-- Lines 98-104
function TeamAIMovement:_upd_location()
	local nav_seg_id = self._nav_tracker:nav_segment()

	if self._standing_nav_seg_id ~= nav_seg_id then
		self._standing_nav_seg_id = nav_seg_id

		managers.groupai:state():on_criminal_nav_seg_change(self._unit, nav_seg_id)
	end
end

-- Lines 108-111
function TeamAIMovement:get_location_id()
	local metadata = managers.navigation:get_nav_seg_metadata(self._standing_nav_seg_id)

	return metadata and metadata.location_id
end

-- Lines 115-119
function TeamAIMovement:on_cuffed()
	self._unit:brain():set_logic("surrender")
	self._unit:network():send("arrested")
	self._unit:character_damage():on_arrested()
end

-- Lines 123-138
function TeamAIMovement:on_SPOOCed(enemy_unit)
	local state = "incapacitated"
	state = managers.modifiers:modify_value("TeamAIMovement:OnSpooked", state)

	if state == "arrested" then
		self:on_cuffed()
	else
		self._unit:character_damage():on_incapacitated()
	end

	return true
end

-- Lines 142-147
function TeamAIMovement:is_SPOOC_attack_allowed()
	if alive(self.vehicle_unit) then
		return false
	end

	return true
end

-- Lines 151-155
function TeamAIMovement:on_discovered()
	if self._cool then
		self:_switch_to_not_cool()
	end
end

-- Lines 159-161
function TeamAIMovement:on_tase_ended()
	self._unit:character_damage():on_tase_ended()
end

-- Lines 165-167
function TeamAIMovement:tased()
	return self._unit:anim_data().tased
end

-- Lines 171-173
function TeamAIMovement:cool()
	return self._cool
end

-- Lines 177-179
function TeamAIMovement:downed()
	return self._unit:interaction()._active
end

-- Lines 183-221
function TeamAIMovement:set_cool(state)
	state = state and true or false

	if state == self._cool then
		return
	end

	if Network:is_server() then
		self._ext_network:send("set_cool_state", state)
	end

	local old_state = self._cool

	if state then
		self._cool = true

		if not self._heat_listener_clbk and Network:is_server() then
			self._heat_listener_clbk = "TeamAIMovement" .. tostring(self._unit:key())

			managers.groupai:state():add_listener(self._heat_listener_clbk, {
				"whisper_mode"
			}, callback(self, self, "heat_clbk"))
		end

		self._unit:base():set_slot(self._unit, 24)

		if self._unit:brain().on_cool_state_changed then
			self._unit:brain():on_cool_state_changed(true)
		end

		self:set_stance_by_code(1)
		self._unit:inventory():set_visibility_state(false)
	else
		self._not_cool_t = TimerManager:game():time()

		self:_switch_to_not_cool(true)
	end
end

-- Lines 225-229
function TeamAIMovement:heat_clbk(state)
	if self._cool and not state then
		self:_switch_to_not_cool()
	end
end

-- Lines 233-259
function TeamAIMovement:_switch_to_not_cool(instant)
	if not Network:is_server() then
		if instant then
			self._unit:inventory():set_visibility_state(true)
		end

		self._cool = false

		return
	end

	if self._heat_listener_clbk then
		managers.groupai:state():remove_listener(self._heat_listener_clbk)

		self._heat_listener_clbk = nil
	end

	if instant then
		if self._switch_to_not_cool_clbk_id then
			local mute_debug_pause = self._switch_to_not_cool_clbk_id == "dummy"

			managers.enemy:remove_delayed_clbk(self._switch_to_not_cool_clbk_id, mute_debug_pause)
		end

		self._switch_to_not_cool_clbk_id = "dummy"

		self:_switch_to_not_cool_clbk_func()
	elseif not self._switch_to_not_cool_clbk_id then
		self._switch_to_not_cool_clbk_id = "switch_to_not_cool_clbk" .. tostring(self._unit:key())

		managers.enemy:add_delayed_clbk(self._switch_to_not_cool_clbk_id, callback(self, self, "_switch_to_not_cool_clbk_func"), TimerManager:game():time() + math.random() * 1 + 0.5)
	end
end

-- Lines 263-282
function TeamAIMovement:_switch_to_not_cool_clbk_func()
	if self._switch_to_not_cool_clbk_id and self._cool then
		if self._unit:inventory():is_mask_unit_loaded() then
			self._switch_to_not_cool_clbk_id = nil
			self._cool = false
			self._not_cool_t = TimerManager:game():time()

			self._unit:base():set_slot(self._unit, 16)

			if self._unit:brain()._logic_data and self._unit:brain():is_available_for_assignment() then
				self._unit:brain():set_objective()
				self._unit:movement():action_request({
					sync = true,
					body_part = 1,
					type = "idle"
				})
			end

			self:set_stance_by_code(2)
			self._unit:brain():on_cool_state_changed(false)
			self._unit:inventory():set_visibility_state(true)
		else
			managers.enemy:add_delayed_clbk(self._switch_to_not_cool_clbk_id, callback(self, self, "_switch_to_not_cool_clbk_func"), TimerManager:game():time() + 1)
		end
	end
end

-- Lines 286-288
function TeamAIMovement:zipline_unit()
	return nil
end

-- Lines 290-292
function TeamAIMovement:current_state_name()
	return nil
end

-- Lines 296-310
function TeamAIMovement:pre_destroy(...)
	TeamAIMovement.super.pre_destroy(self, ...)

	if self._heat_listener_clbk then
		managers.groupai:state():remove_listener(self._heat_listener_clbk)

		self._heat_listener_clbk = nil
	end

	if self._switch_to_not_cool_clbk_id then
		managers.enemy:remove_delayed_clbk(self._switch_to_not_cool_clbk_id)

		self._switch_to_not_cool_clbk_id = nil
	end
end

-- Lines 314-321
function TeamAIMovement:save(save_data)
	TeamAIMovement.super.save(self, save_data)

	save_data.movement = save_data.movement or {}
	save_data.movement.should_stay = self._should_stay
end

-- Lines 323-331
function TeamAIMovement:load(load_data)
	TeamAIMovement.super.load(self, load_data)

	if load_data.movement then
		self:set_should_stay(load_data.movement.should_stay)
	end
end

-- Lines 334-347
function TeamAIMovement:set_should_stay(should_stay)
	if self._should_stay ~= should_stay then
		local panel = managers.criminals:character_data_by_unit(self._unit)

		if panel then
			managers.hud:set_ai_stopped(panel.panel_id, should_stay)
		end

		self._should_stay = should_stay

		managers.network:session():send_to_peers_synched("sync_team_ai_stopped", self._unit, should_stay)

		if should_stay then
			managers.groupai:state():upd_team_AI_distance()
		end
	end
end

-- Lines 351-363
function TeamAIMovement:chk_action_forbidden(action_type)
	if action_type == "walk" and self._should_stay then
		if Network:is_server() and self._unit:brain():objective() and (self._unit:brain():objective().type == "revive" or self._unit:brain():objective().forced) then
			return false
		end

		return true
	end

	return TeamAIMovement.super.chk_action_forbidden(self, action_type)
end

-- Lines 368-399
function TeamAIMovement:update(...)
	TeamAIMovement.super.update(self, ...)

	if self._pre_destroyed then
		return
	end
end
