require("lib/units/beings/player/PlayerDamage")

TeamAIDamage = TeamAIDamage or class()
TeamAIDamage._all_event_types = {
	"bleedout",
	"death",
	"hurt",
	"light_hurt",
	"heavy_hurt",
	"fatal",
	"none"
}
TeamAIDamage._RESULT_INDEX_TABLE = {
	light_hurt = 4,
	hurt = 1,
	bleedout = 2,
	heavy_hurt = 5,
	death = 3,
	fatal = 6
}
TeamAIDamage._HEALTH_GRANULARITY = CopDamage._HEALTH_GRANULARITY
TeamAIDamage.set_invulnerable = CopDamage.set_invulnerable
TeamAIDamage._hurt_severities = CopDamage._hurt_severities
TeamAIDamage.get_damage_type = CopDamage.get_damage_type

-- Lines 17-53
function TeamAIDamage:init(unit)
	self._unit = unit
	self._char_tweak = tweak_data.character[unit:base()._tweak_table]
	local damage_tweak = self._char_tweak.damage
	self._HEALTH_INIT = damage_tweak.HEALTH_INIT
	self._HEALTH_BLEEDOUT_INIT = damage_tweak.BLEED_OUT_HEALTH_INIT
	self._HEALTH_TOTAL = self._HEALTH_INIT + self._HEALTH_BLEEDOUT_INIT
	self._HEALTH_TOTAL_PERCENT = self._HEALTH_TOTAL / 100
	self._health = self._HEALTH_INIT
	self._health_ratio = self._health / self._HEALTH_INIT
	self._invulnerable = false
	self._char_dmg_tweak = damage_tweak
	self._focus_delay_mul = 1
	self._listener_holder = EventListenerHolder:new()
	self._bleed_out_paused_count = 0
	self._dmg_interval = damage_tweak.MIN_DAMAGE_INTERVAL
	self._next_allowed_dmg_t = -100
	self._last_received_dmg = 0
	self._spine2_obj = unit:get_object(Idstring("Spine2"))
	self._tase_effect_table = {
		effect = Idstring("effects/payday2/particles/character/taser_hittarget"),
		parent = self._unit:get_object(Idstring("e_taser"))
	}
end

-- Lines 57-101
function TeamAIDamage:update(unit, t, dt)
	if self._regenerate_t then
		if self._regenerate_t < t then
			self:_regenerated()
		end
	elseif self._arrested_timer and self._arrested_paused_counter == 0 then
		self._arrested_timer = self._arrested_timer - dt

		if self._arrested_timer <= 0 then
			self._arrested_timer = nil
			local action_data = {
				variant = "stand",
				body_part = 1,
				type = "act",
				blocks = {
					heavy_hurt = -1,
					hurt = -1,
					action = -1,
					aim = -1,
					walk = -1
				}
			}
			local res = self._unit:movement():action_request(action_data)

			self._unit:brain():on_recovered(self._unit)
			self._unit:network():send("from_server_unit_recovered")
			managers.groupai:state():on_criminal_recovered(self._unit)
			managers.hud:set_mugshot_normal(self._unit:unit_data().mugshot_id)
		end
	end

	if self._revive_reminder_line_t and self._revive_reminder_line_t < t then
		self._unit:sound():say("f11e_plu", true)

		self._revive_reminder_line_t = nil
	end
end

-- Lines 105-131
function TeamAIDamage:damage_melee(attack_data)
	if self._invulnerable or self._dead or self._fatal or self._arrested_timer then
		return
	end

	if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		return
	end

	local result = {
		variant = "melee"
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
	local t = TimerManager:game():time()
	self._next_allowed_dmg_t = t + self._dmg_interval
	self._last_received_dmg_t = t

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_melee_attack_result(attack_data)

	return result
end

-- Lines 135-155
function TeamAIDamage:force_bleedout()
	local attack_data = {
		damage = 100000,
		pos = Vector3(),
		col_ray = {
			position = Vector3()
		}
	}
	local result = {
		type = "none",
		variant = "bullet"
	}
	attack_data.result = result
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
	self._next_allowed_dmg_t = TimerManager:game():time() + self._dmg_interval
	self._last_received_dmg = health_subtracted

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_bullet_attack_result(attack_data)
end

-- Lines 158-167
function TeamAIDamage:force_custody()
	self:force_bleedout()

	if self._to_dead_clbk_id then
		managers.enemy:remove_delayed_clbk(self._to_dead_clbk_id)

		self._to_dead_clbk_id = nil
	end

	self:clbk_exit_to_dead()
end

-- Lines 172-203
function TeamAIDamage:damage_bullet(attack_data)
	local result = {
		type = "none",
		variant = "bullet"
	}
	attack_data.result = result

	if self:_cannot_take_damage() then
		self:_call_listeners(attack_data)

		return
	elseif PlayerDamage._chk_dmg_too_soon(self, attack_data.damage) then
		self:_call_listeners(attack_data)

		return
	elseif PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)
	local t = TimerManager:game():time()
	self._next_allowed_dmg_t = t + self._dmg_interval
	self._last_received_dmg_t = t
	self._last_received_dmg = health_subtracted

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_bullet_attack_result(attack_data)

	return result
end

-- Lines 206-209
function TeamAIDamage:stun_hit(attack_data)
	return nil
end

-- Lines 212-214
function TeamAIDamage:accuracy_multiplier()
	return 1
end

-- Lines 218-244
function TeamAIDamage:damage_explosion(attack_data)
	if self:_cannot_take_damage() then
		return
	end

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if PlayerDamage.is_friendly_fire(self, attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	local result = {
		variant = attack_data.variant
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_explosion_attack_result(attack_data)

	return result
end

-- Lines 246-275
function TeamAIDamage:damage_fire(attack_data)
	if self:_cannot_take_damage() then
		return
	end

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and alive(attacker_unit) and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if attacker_unit and not alive(attacker_unit) then
		return
	end

	if attacker_unit and alive(attacker_unit) and PlayerDamage.is_friendly_fire(self, attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	local result = {
		variant = attack_data.variant
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_fire_attack_result(attack_data)

	return result
end

-- Lines 279-301
function TeamAIDamage:damage_mission(attack_data)
	if self._dead or self._invulnerable and not attack_data.forced then
		return
	end

	local result = nil
	local damage_percent = self._HEALTH_GRANULARITY
	attack_data.damage = self._health
	attack_data.variant = "explosion"
	local result = {
		variant = attack_data.variant
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	if health_subtracted > 0 then
		self:_send_damage_drama(attack_data, health_subtracted)
	end

	if self._dead then
		self:_unregister_unit()
	end

	self:_call_listeners(attack_data)
	self:_send_explosion_attack_result(attack_data)

	return result
end

-- Lines 305-351
function TeamAIDamage:damage_tase(attack_data)
	if attack_data ~= nil and PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then
		self:friendly_fire_hit()

		return
	end

	if self:_cannot_take_damage() then
		return
	end

	self._regenerate_t = nil
	local damage_info = {
		variant = "tase",
		result = {
			type = "hurt"
		}
	}

	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)

	if Network:is_server() then
		if math.random() < 0.25 then
			self._unit:sound():say("s07x_sin", true)
		end

		if not self._to_incapacitated_clbk_id then
			self._to_incapacitated_clbk_id = "TeamAIDamage_to_incapacitated" .. tostring(self._unit:key())

			managers.enemy:add_delayed_clbk(self._to_incapacitated_clbk_id, callback(self, self, "clbk_exit_to_incapacitated"), TimerManager:game():time() + self._char_dmg_tweak.TASED_TIME)
		end
	end

	self:_call_listeners(damage_info)

	if Network:is_server() then
		self:_send_tase_attack_result()
	end

	return damage_info
end

-- Lines 355-357
function TeamAIDamage:damage_dot(attack_data)
end

-- Lines 361-411
function TeamAIDamage:_apply_damage(attack_data, result)
	local damage = attack_data.damage
	damage = math.clamp(damage, self._HEALTH_TOTAL_PERCENT, self._HEALTH_TOTAL)
	local damage_percent = math.ceil(damage / self._HEALTH_TOTAL_PERCENT)
	damage = damage_percent * self._HEALTH_TOTAL_PERCENT
	attack_data.damage = damage
	local dodged = self:inc_dodge_count(damage_percent / 2)
	attack_data.pos = attack_data.pos or attack_data.col_ray.position
	attack_data.result = result

	if dodged or self._unit:anim_data().dodge then
		result.type = "none"

		return 0, 0
	end

	local health_subtracted = nil

	if self._bleed_out then
		health_subtracted = self._bleed_out_health
		self._bleed_out_health = self._bleed_out_health - damage

		self:_check_fatal()

		if self._fatal then
			result.type = "fatal"
			self._health_ratio = 0
		else
			health_subtracted = damage
			result.type = "hurt"
			self._health_ratio = self._bleed_out_health / self._HEALTH_BLEEDOUT_INIT
		end
	else
		health_subtracted = self._health
		self._health = self._health - damage

		self:_check_bleed_out()

		if self._bleed_out then
			result.type = "bleedout"
			self._health_ratio = 1
		else
			health_subtracted = damage
			result.type = self:get_damage_type(damage_percent, "bullet") or "none"

			self:_on_hurt()

			self._health_ratio = self._health / self._HEALTH_INIT
		end
	end

	managers.hud:set_mugshot_damage_taken(self._unit:unit_data().mugshot_id)

	return damage_percent, health_subtracted
end

-- Lines 415-417
function TeamAIDamage:friendly_fire_hit()
	self:inc_dodge_count(2)
end

-- Lines 421-445
function TeamAIDamage:inc_dodge_count(n)
	local t = Application:time()

	if not self._to_dodge_t or self._to_dodge_t - t < 0 then
		self._to_dodge_t = t
	end

	self._to_dodge_t = self._to_dodge_t + n

	if self._to_dodge_t - t < 3 then
		return
	end

	if self._dodge_t and t - self._dodge_t < 5 then
		return
	end

	self._to_dodge_t = nil
	self._dodge_t = nil

	if CopLogicBase.chk_start_action_dodge(self._unit:brain()._logic_data, "hit") then
		self._dodge_t = t

		self:_on_hurt()

		return true
	end
end

-- Lines 449-455
function TeamAIDamage:down_time()
	return self._char_dmg_tweak.DOWNED_TIME
end

-- Lines 459-492
function TeamAIDamage:_check_bleed_out()
	if self._health <= 0 then
		self._bleed_out_health = self._HEALTH_BLEEDOUT_INIT
		self._health = 0
		self._bleed_out = true
		self._regenerate_t = nil
		self._bleed_out_paused_count = 0

		if Network:is_server() then
			if self._unit:movement():carrying_bag() then
				self._unit:movement():throw_bag()
			end

			if not self._to_dead_clbk_id then
				self._to_dead_clbk_id = "TeamAIDamage_to_dead" .. tostring(self._unit:key())
				self._to_dead_t = TimerManager:game():time() + self:down_time()

				managers.enemy:add_delayed_clbk(self._to_dead_clbk_id, callback(self, self, "clbk_exit_to_dead"), self._to_dead_t)
			end

			self._unit:sound():say("f11e_plu", true)

			self._revive_reminder_line_t = self._to_dead_t - 10
		end

		managers.groupai:state():on_criminal_disabled(self._unit)

		if Network:is_server() then
			managers.groupai:state():report_criminal_downed(self._unit)
		end

		self._unit:interaction():set_tweak_data("revive")
		self._unit:interaction():set_active(true, false)
		managers.hud:set_mugshot_downed(self._unit:unit_data().mugshot_id)
	end
end

-- Lines 496-510
function TeamAIDamage:_check_fatal()
	if self._bleed_out_health <= 0 then
		if not self._bleed_out then
			self._unit:interaction():set_tweak_data("revive")
			self._unit:interaction():set_active(true, false)
		end

		self._bleed_out = nil
		self._bleed_death_t = nil
		self._bleed_out_health = nil
		self._health_ratio = 0
		self._fatal = true

		managers.groupai:state():on_criminal_disabled(self._unit)
		PlayerMovement.set_attention_settings(self._unit:brain(), nil, "team_AI")
	end
end

TeamAIDamage.get_paused_counter_name_by_peer = PlayerDamage.get_paused_counter_name_by_peer

-- Lines 518-534
function TeamAIDamage:pause_bleed_out(peer_id)
	self._bleed_out_paused_count = self._bleed_out_paused_count + 1

	PlayerDamage.set_peer_paused_counter(self, peer_id, "bleed_out")

	if (self._bleed_out or self._fatal) and self._bleed_out_paused_count == 1 then
		self._to_dead_remaining_t = self._to_dead_t - TimerManager:game():time()

		if self._to_dead_remaining_t < 0 then
			return
		end

		if Network:is_server() then
			managers.enemy:remove_delayed_clbk(self._to_dead_clbk_id)

			self._to_dead_clbk_id = nil
		end

		self._to_dead_t = nil
	end
end

-- Lines 538-551
function TeamAIDamage:unpause_bleed_out(peer_id)
	self._bleed_out_paused_count = self._bleed_out_paused_count - 1

	PlayerDamage.set_peer_paused_counter(self, peer_id, nil)

	if (self._bleed_out or self._fatal) and self._bleed_out_paused_count == 0 then
		self._to_dead_t = TimerManager:game():time() + self._to_dead_remaining_t

		if Network:is_server() and not self._dead and not self._to_dead_clbk_id then
			self._to_dead_clbk_id = "TeamAIDamage_to_dead" .. tostring(self._unit:key())

			managers.enemy:add_delayed_clbk(self._to_dead_clbk_id, callback(self, self, "clbk_exit_to_dead"), self._to_dead_t)
		end

		self._to_dead_remaining_t = nil
	end
end

-- Lines 555-557
function TeamAIDamage:stop_bleedout()
	self:_regenerated()
end

-- Lines 561-570
function TeamAIDamage:on_arrested()
	self:stop_bleedout()

	self._arrested_timer = self._char_dmg_tweak.ARRESTED_TIME
	self._arrested_paused_counter = 0

	managers.hud:set_mugshot_cuffed(self._unit:unit_data().mugshot_id)

	if Network:is_server() then
		managers.groupai:state():report_criminal_downed(self._unit)
	end
end

-- Lines 572-575
function TeamAIDamage:pause_arrested_timer(peer_id)
	self._arrested_paused_counter = self._arrested_paused_counter + 1

	PlayerDamage.set_peer_paused_counter(self, peer_id, "arrested")
end

-- Lines 577-580
function TeamAIDamage:unpause_arrested_timer(peer_id)
	self._arrested_paused_counter = self._arrested_paused_counter - 1

	PlayerDamage.set_peer_paused_counter(self, peer_id, nil)
end

-- Lines 584-599
function TeamAIDamage:_on_hurt()
	if self._to_incapacitated_clbk_id then
		return
	end

	local regen_time = self._char_dmg_tweak.REGENERATE_TIME_AWAY
	local dis_limit = 6250000

	for _, crim in pairs(managers.groupai:state():all_player_criminals()) do
		if mvector3.distance_sq(self._unit:movement():m_pos(), crim.unit:movement():m_pos()) < 6250000 then
			regen_time = self._char_dmg_tweak.REGENERATE_TIME

			break
		end
	end

	self._regenerate_t = TimerManager:game():time() + regen_time
end

-- Lines 603-605
function TeamAIDamage:bleed_out()
	return self._bleed_out
end

-- Lines 609-611
function TeamAIDamage:fatal()
	return self._fatal
end

-- Lines 615-617
function TeamAIDamage:is_downed()
	return self._bleed_out or self._fatal
end

-- Lines 621-636
function TeamAIDamage:_regenerated()
	self._health = self._HEALTH_INIT
	self._health_ratio = 1

	if self._bleed_out then
		self._bleed_out = nil
		self._bleed_death_t = nil
		self._bleed_out_health = nil
	elseif self._fatal then
		self._fatal = nil
	end

	self._bleed_out_paused_count = 0
	self._to_dead_t = nil
	self._to_dead_remaining_t = nil

	self:_clear_damage_transition_callbacks()

	self._regenerate_t = nil
end

-- Lines 640-641
function TeamAIDamage:_convert_to_health_percentage(health_abs)
end

-- Lines 645-650
function TeamAIDamage:_clamp_health_percentage(health_abs)
	health_abs = math.clamp(health_abs, self._HEALTH_TOTAL_PERCENT, self._HEALTH_TOTAL)
	local health_percent = math.ceil(health_abs / self._HEALTH_TOTAL_PERCENT)
	health_abs = health_percent * self._HEALTH_TOTAL_PERCENT

	return health_abs, health_percent
end

-- Lines 656-688
function TeamAIDamage:_get_closest_player(ignore_constraints)
	local desired_player = nil
	local player_distance = math.huge
	local ai_pos = self._unit:movement():m_pos()

	for _, data in ipairs(managers.criminals:characters()) do
		if data.taken and not data.ai and alive(data.unit) and self._unit ~= data.unit then
			local new_dist = mvector3.distance(ai_pos, data.unit:position())

			if new_dist < player_distance then
				local peer = managers.network:session():peer_by_unit(data.unit)

				if peer then
					local peer_id = peer:id()
					local vehicle_data = managers.player:get_vehicle_for_peer(peer_id)
					local zipline_unit = data.unit:movement():zipline_unit()
					local being_tased = data.unit:movement():tased()
					local is_valid = not vehicle_data and not zipline_unit and not being_tased

					if ignore_constraints or is_valid then
						desired_player = data.unit
						player_distance = new_dist
					end
				end
			end
		end
	end

	return desired_player
end

-- Lines 690-727
function TeamAIDamage:_teleport_carried_bag()
	if self._unit:movement()._carry_unit then
		self._unit:movement():throw_bag()
	end

	local dropped_bag = self._unit:movement():was_carrying_bag()

	if dropped_bag and alive(dropped_bag.unit) then
		local distance = mvector3.distance_sq(self._unit:movement():m_pos(), dropped_bag.unit:position())
		local max_distance = math.pow(tweak_data.ai_carry.death_distance_teleport, 2)

		if distance <= max_distance then
			local desired_player = self:_get_closest_player(false)
			desired_player = desired_player or self:_get_closest_player(true)

			if desired_player then
				local pos = desired_player:movement():m_head_pos()
				local dir = desired_player:movement():m_head_rot():z()

				if managers.player:player_unit() == desired_player then
					dir = desired_player:camera():forward()
				end

				dropped_bag.unit:carry_data():set_position_and_throw(pos, dir * 5000, 1)

				return true
			else
				Application:error("Couldn't find a valid player to teleport AI carried bag to: ", dropped_bag.unit)
			end
		end
	end

	return false
end

-- Lines 731-754
function TeamAIDamage:_die()
	self:_teleport_carried_bag()

	self._dead = true
	self._revive_reminder_line_t = nil

	if self._bleed_out or self._fatal then
		self._unit:interaction():set_active(false, false)

		self._bleed_out = nil
		self._bleed_out_health = nil
	end

	self._regenerate_t = nil
	self._health_ratio = 0

	self._unit:base():set_slot(self._unit, 17)
	self:_clear_damage_transition_callbacks()
end

-- Lines 758-766
function TeamAIDamage:_unregister_unit()
	local char_name = managers.criminals:character_name_by_unit(self._unit)

	managers.groupai:state():on_AI_criminal_death(char_name, self._unit)
	managers.groupai:state():on_criminal_neutralized(self._unit)
	self._unit:base():unregister()
	self:_clear_damage_transition_callbacks()
	Network:detach_unit(self._unit)
end

-- Lines 770-772
function TeamAIDamage:_send_damage_drama(attack_data, health_subtracted)
	PlayerDamage._send_damage_drama(self, attack_data, health_subtracted)
end

-- Lines 776-781
function TeamAIDamage:_call_listeners(damage_info)
	CopDamage._call_listeners(self, damage_info)
end

-- Lines 785-787
function TeamAIDamage:add_listener(...)
	CopDamage.add_listener(self, ...)
end

-- Lines 791-793
function TeamAIDamage:remove_listener(key)
	CopDamage.remove_listener(self, key)
end

-- Lines 797-799
function TeamAIDamage:health_ratio()
	return self._health_ratio
end

-- Lines 803-805
function TeamAIDamage:focus_delay_mul()
	return 1
end

-- Lines 809-811
function TeamAIDamage:dead()
	return self._dead
end

-- Lines 815-851
function TeamAIDamage:sync_damage_bullet(attacker_unit, damage, i_body, hit_offset_height)
	if self:_cannot_take_damage() then
		return
	end

	local body = self._unit:body(i_body)
	damage = damage * self._HEALTH_TOTAL_PERCENT
	local result = {
		variant = "bullet"
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_pos())

	mvector3.set_z(hit_pos, hit_pos.z + hit_offset_height)

	local attack_dir = nil

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:movement():m_head_pos()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		variant = "bullet",
		attacker_unit = attacker_unit,
		damage = damage,
		attack_dir = attack_dir,
		pos = hit_pos
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_bullet_attack_result(attack_data, hit_offset_height)
	self:_call_listeners(attack_data)
end

-- Lines 855-889
function TeamAIDamage:sync_damage_explosion(attacker_unit, damage, i_attack_variant)
	if self:_cannot_take_damage() then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]
	damage = damage * self._HEALTH_TOTAL_PERCENT
	local result = {
		variant = variant
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_com())
	local attack_dir = nil

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		variant = variant,
		attacker_unit = attacker_unit,
		damage = damage,
		attack_dir = attack_dir,
		pos = hit_pos
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_explosion_attack_result(attack_data)
	self:_call_listeners(attack_data)
end

-- Lines 893-927
function TeamAIDamage:sync_damage_fire(attacker_unit, damage, i_attack_variant)
	if self:_cannot_take_damage() then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]
	damage = damage * self._HEALTH_TOTAL_PERCENT
	local result = {
		variant = variant
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_com())
	local attack_dir = nil

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:position()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		variant = variant,
		attacker_unit = attacker_unit,
		damage = damage,
		attack_dir = attack_dir,
		pos = hit_pos
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_fire_attack_result(attack_data)
	self:_call_listeners(attack_data)
end

-- Lines 931-968
function TeamAIDamage:sync_damage_melee(attacker_unit, damage, damage_effect_percent, i_body, hit_offset_height)
	if self:_cannot_take_damage() then
		return
	end

	local body = self._unit:body(i_body)
	damage = damage * self._HEALTH_TOTAL_PERCENT
	local result = {
		variant = "melee"
	}
	local hit_pos = mvector3.copy(self._unit:movement():m_pos())

	mvector3.set_z(hit_pos, hit_pos.z + hit_offset_height)

	local attack_dir = nil

	if attacker_unit then
		attack_dir = hit_pos - attacker_unit:movement():m_head_pos()

		mvector3.normalize(attack_dir)
	else
		attack_dir = self._unit:rotation():y()

		mvector3.negate(attack_dir)
	end

	if not self._no_blood then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	local attack_data = {
		variant = "melee",
		attacker_unit = attacker_unit,
		damage = damage,
		attack_dir = attack_dir,
		pos = hit_pos
	}
	local damage_percent, health_subtracted = self:_apply_damage(attack_data, result)

	self:_send_damage_drama(attack_data, health_subtracted)
	self:_send_melee_attack_result(attack_data, hit_offset_height)
	self:_call_listeners(attack_data)
end

-- Lines 972-974
function TeamAIDamage:shoot_pos_mid(m_pos)
	self._spine2_obj:m_position(m_pos)
end

-- Lines 978-980
function TeamAIDamage:need_revive()
	return (self._bleed_out or self._fatal) and not self._dead
end

-- Lines 984-986
function TeamAIDamage:arrested()
	return self._arrested_timer
end

-- Lines 990-1006
function TeamAIDamage:revive_instant()
	if self._bleed_out or self._fatal then
		self:_regenerated()
		self._unit:interaction():set_active(false, false)
		PlayerMovement.set_attention_settings(self._unit:brain(), {
			"team_enemy_cbt"
		}, "team_AI")
		self._unit:network():send("from_server_unit_recovered")
	end

	managers.hud:set_mugshot_normal(self._unit:unit_data().mugshot_id)
	self:pickup_dropped_bag()
end

-- Lines 1008-1070
function TeamAIDamage:revive(reviving_unit, silent)
	if self._dead then
		return
	end

	self._revive_reminder_line_t = nil

	if self._bleed_out or self._fatal then
		self:_regenerated()

		local action_data = {
			variant = "stand",
			body_part = 1,
			type = "act",
			blocks = {
				heavy_hurt = -1,
				hurt = -1,
				action = -1,
				aim = -1,
				walk = -1
			}
		}
		local res = self._unit:movement():action_request(action_data)

		self._unit:interaction():set_active(false, false)
		self._unit:brain():on_recovered(reviving_unit)
		PlayerMovement.set_attention_settings(self._unit:brain(), {
			"team_enemy_cbt"
		}, "team_AI")
		self._unit:network():send("from_server_unit_recovered")
		managers.groupai:state():on_criminal_recovered(self._unit)
		managers.mission:call_global_event("player_revive_ai")
	elseif self._arrested_timer then
		self._arrested_timer = nil
		local action_data = {
			variant = "stand",
			body_part = 1,
			type = "act",
			blocks = {
				heavy_hurt = -1,
				hurt = -1,
				action = -1,
				aim = -1,
				walk = -1
			}
		}
		local res = self._unit:movement():action_request(action_data)

		self._unit:brain():on_recovered(reviving_unit)
		PlayerMovement.set_attention_settings(self._unit:brain(), {
			"team_enemy_cbt"
		}, "team_AI")
		self._unit:network():send("from_server_unit_recovered")
		managers.groupai:state():on_criminal_recovered(self._unit)
	end

	managers.hud:set_mugshot_normal(self._unit:unit_data().mugshot_id)

	if not silent then
		self._unit:sound():say("s05x_sin", true)
	end

	self:pickup_dropped_bag()
end

-- Lines 1074-1086
function TeamAIDamage:pickup_dropped_bag()
	local dropped_bag = self._unit:movement():was_carrying_bag()

	if dropped_bag and alive(dropped_bag.unit) then
		local distance = mvector3.distance_sq(self._unit:movement():m_pos(), dropped_bag.unit:position())
		local max_distance = math.pow(tweak_data.ai_carry.revive_distance_autopickup, 2)

		if distance <= max_distance then
			dropped_bag.unit:carry_data():link_to(self._unit, false)

			if self._unit:movement().set_carrying_bag then
				self._unit:movement():set_carrying_bag(dropped_bag.unit)
			end
		end
	end
end

-- Lines 1092-1100
function TeamAIDamage:_send_bullet_attack_result(attack_data, hit_offset_height)
	hit_offset_height = hit_offset_height or math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)
	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_bullet", attacker, hit_offset_height, result_index)
end

-- Lines 1104-1111
function TeamAIDamage:_send_explosion_attack_result(attack_data)
	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_explosion_fire", attacker, result_index, CopDamage._get_attack_variant_index(self, attack_data.variant))
end

-- Lines 1113-1120
function TeamAIDamage:_send_fire_attack_result(attack_data)
	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_explosion_fire", attacker, result_index, CopDamage._get_attack_variant_index(self, attack_data.variant))
end

-- Lines 1124-1132
function TeamAIDamage:_send_melee_attack_result(attack_data, hit_offset_height)
	hit_offset_height = hit_offset_height or math.clamp(attack_data.col_ray.position.z - self._unit:movement():m_pos().z, 0, 300)
	local attacker = attack_data.attacker_unit

	if not attacker or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_index = self._RESULT_INDEX_TABLE[attack_data.result.type] or 0

	self._unit:network():send("from_server_damage_melee", attacker, hit_offset_height, result_index)
end

-- Lines 1136-1138
function TeamAIDamage:_send_tase_attack_result()
	self._unit:network():send("from_server_damage_tase")
end

-- Lines 1142-1170
function TeamAIDamage:on_tase_ended()
	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)
	end

	if self._to_incapacitated_clbk_id then
		self._regenerate_t = TimerManager:game():time() + self._char_dmg_tweak.REGENERATE_TIME

		managers.enemy:remove_delayed_clbk(self._to_incapacitated_clbk_id)

		self._to_incapacitated_clbk_id = nil
		local action_data = {
			variant = "stand",
			body_part = 1,
			type = "act",
			blocks = {
				heavy_hurt = -1,
				hurt = -1,
				action = -1,
				walk = -1
			}
		}
		local res = self._unit:movement():action_request(action_data)

		self._unit:network():send("from_server_unit_recovered")
		managers.groupai:state():on_criminal_recovered(self._unit)
		self._unit:brain():on_recovered()
	end
end

-- Lines 1174-1177
function TeamAIDamage:clbk_exit_to_incapacitated()
	self._to_incapacitated_clbk_id = nil

	self:_on_incapacitated()
end

-- Lines 1181-1186
function TeamAIDamage:on_incapacitated()
	if self:_cannot_take_damage() then
		return
	end

	self:_on_incapacitated()
end

-- Lines 1190-1216
function TeamAIDamage:_on_incapacitated()
	if self._tase_effect then
		World:effect_manager():fade_kill(self._tase_effect)

		self._tase_effect = nil
	end

	if self._to_incapacitated_clbk_id then
		managers.enemy:remove_delayed_clbk(self._to_incapacitated_clbk_id)

		self._to_incapacitated_clbk_id = nil
	end

	self._regenerate_t = nil
	local dmg_info = {
		variant = "bleeding",
		result = {
			type = "fatal"
		}
	}
	self._bleed_out_health = 0

	self:_check_fatal()

	if not self._to_dead_clbk_id then
		self._to_dead_clbk_id = "TeamAIDamage_to_dead" .. tostring(self._unit:key())
		self._to_dead_t = TimerManager:game():time() + self._char_dmg_tweak.INCAPACITATED_TIME

		managers.enemy:add_delayed_clbk(self._to_dead_clbk_id, callback(self, self, "clbk_exit_to_dead"), self._to_dead_t)
	end

	self:_call_listeners(dmg_info)
	self._unit:network():send("from_server_damage_incapacitated")
end

-- Lines 1220-1240
function TeamAIDamage:clbk_exit_to_dead()
	managers.mission:call_global_event("ai_in_custody")

	self._to_dead_clbk_id = nil
	self._to_dead_t = nil

	self:_die()
	self._unit:network():send("from_server_damage_bleeding")

	local dmg_info = {
		variant = "bleeding",
		result = {
			type = "death"
		}
	}

	self:_call_listeners(dmg_info)
	self:_unregister_unit()
end

-- Lines 1244-1246
function TeamAIDamage:pre_destroy()
	self:_clear_damage_transition_callbacks()
end

-- Lines 1250-1258
function TeamAIDamage:_cannot_take_damage()
	return self._invulnerable or self._dead or self._fatal or self._arrested_timer
end

-- Lines 1262-1264
function TeamAIDamage:disable()
	self:_clear_damage_transition_callbacks()
end

-- Lines 1268-1277
function TeamAIDamage:_clear_damage_transition_callbacks()
	if self._to_incapacitated_clbk_id then
		managers.enemy:remove_delayed_clbk(self._to_incapacitated_clbk_id)

		self._to_incapacitated_clbk_id = nil
	end

	if self._to_dead_clbk_id then
		managers.enemy:remove_delayed_clbk(self._to_dead_clbk_id)

		self._to_dead_clbk_id = nil
	end
end

-- Lines 1281-1283
function TeamAIDamage:last_suppression_t()
	return self._last_received_dmg_t
end

-- Lines 1287-1289
function TeamAIDamage:can_attach_projectiles()
	return false
end

-- Lines 1293-1306
function TeamAIDamage:save(data)
	if self._arrested_timer then
		data.char_dmg = data.char_dmg or {}
		data.char_dmg.arrested = true
	end

	if self._bleed_out then
		data.char_dmg = data.char_dmg or {}
		data.char_dmg.bleedout = true
	end

	if self._fatal then
		data.char_dmg = data.char_dmg or {}
		data.char_dmg.fatal = true
	end
end
