local tmp_vec1 = Vector3()
QuickCsGrenade = QuickCsGrenade or class(GrenadeBase)

-- Lines 7-15
function QuickCsGrenade:init(unit)
	self._unit = unit
	self._state = 0
	self._has_played_VO = false

	self:_setup_from_tweak_data()
	unit:set_visible(false)
end

-- Lines 17-25
function QuickCsGrenade:_setup_from_tweak_data()
	local grenade_entry = self._tweak_projectile_entry or "cs_grenade_quick"
	self._tweak_data = tweak_data.projectiles[grenade_entry]
	self._radius = self._tweak_data.radius or 300
	self._radius_blurzone_multiplier = self._tweak_data.radius_blurzone_multiplier or 1.3
	self._damage_tick_period = self._tweak_data.damage_tick_period or 0.25
	self._damage_per_tick = self._tweak_data.damage_per_tick or 0.75
end

-- Lines 27-61
function QuickCsGrenade:update(unit, t, dt)
	if self._state == 1 then
		self._timer = self._timer - dt

		if self._timer <= 0 then
			self._timer = self._timer + 0.2
			self._state = 2

			self:_play_sound_and_effects()
		end
	elseif self._state == 2 then
		self._timer = self._timer - dt

		if self._timer <= 0 then
			self._timer = self._timer + 0.3
			self._state = 3

			self:_play_sound_and_effects()
		end
	elseif self._state == 3 then
		self._timer = self._timer - dt

		if self._timer <= 0 then
			self._state = 4

			self:detonate()
		end
	elseif self._state == 4 and (not self._last_damage_tick or t > self._last_damage_tick + self._damage_tick_period) then
		self:_do_damage()

		self._last_damage_tick = t
	end

	if self._remove_t and self._remove_t < t then
		self._unit:set_slot(0)
	end
end

-- Lines 65-67
function QuickCsGrenade:activate(position, duration)
	self:_activate(1, 0.5, position, duration)
end

-- Lines 69-72
function QuickCsGrenade:activate_immediately(position, duration)
	self._unit:set_visible(true)
	self:_activate(4, 0, position, duration)
end

-- Lines 74-85
function QuickCsGrenade:_activate(state, timer, position, duration)
	self._state = state
	self._timer = timer
	self._shoot_position = position
	self._duration = duration

	if state == 4 then
		self:detonate()
	else
		self:_play_sound_and_effects()
	end
end

-- Lines 89-92
function QuickCsGrenade:detonate()
	self:_play_sound_and_effects()

	self._remove_t = TimerManager:game():time() + self._duration
end

-- Lines 96-98
function QuickCsGrenade:sound_playback_complete_clbk(event_instance, sound_source, event_type, sound_source_again)
end

-- Lines 100-103
function QuickCsGrenade:preemptive_kill()
	self._unit:sound_source():post_event("grenade_gas_stop")
	self._unit:set_slot(0)
end

-- Lines 107-120
function QuickCsGrenade:_do_damage()
	local player_unit = managers.player:player_unit()

	if player_unit and mvector3.distance_sq(self._unit:position(), player_unit:position()) < self._tweak_data.radius * self._tweak_data.radius then
		local attack_data = {
			damage = self._damage_per_tick,
			col_ray = {
				ray = math.UP
			}
		}

		player_unit:character_damage():damage_killzone(attack_data)

		if not self._has_played_VO then
			PlayerStandard.say_line(player_unit:sound(), "g42x_any")

			self._has_played_VO = true
		end
	end
end

-- Lines 124-161
function QuickCsGrenade:_play_sound_and_effects()
	if self._state == 1 then
		if self._shoot_position then
			local sound_source = SoundDevice:create_source("grenade_fire_source")

			sound_source:set_position(self._shoot_position)
			sound_source:post_event("grenade_gas_npc_fire")
		end
	elseif self._state == 2 then
		if self._shoot_position then
			local bounce_point = tmp_vec1

			self._unit:m_position(bounce_point)
			mvector3.lerp(bounce_point, self._shoot_position, bounce_point, 0.65)

			local sound_source = SoundDevice:create_source("grenade_bounce_source")

			sound_source:set_position(bounce_point)
			sound_source:post_event("grenade_gas_bounce", callback(self, self, "sound_playback_complete_clbk"), sound_source, "end_of_event")
		else
			self._unit:sound_source():post_event("grenade_gas_bounce")
		end
	elseif self._state == 3 then
		self._unit:set_visible(true)
	elseif self._state == 4 then
		World:effect_manager():spawn({
			effect = Idstring("effects/particles/explosions/explosion_smoke_grenade"),
			position = self._unit:position(),
			normal = self._unit:rotation():y()
		})
		self._unit:sound_source():post_event("grenade_gas_explode")

		local parent = self._unit:orientation_object()
		self._smoke_effect = World:effect_manager():spawn({
			effect = Idstring("effects/payday2/environment/cs_gas_damage_area"),
			parent = parent
		})
		self._set_blurzone = true
		local blurzone_radius = self._radius * self._radius_blurzone_multiplier

		managers.environment_controller:set_blurzone(self._unit:key(), 1, self._unit:position(), blurzone_radius, 0, true)
	end
end

-- Lines 165-177
function QuickCsGrenade:destroy()
	if self._smoke_effect then
		World:effect_manager():fade_kill(self._smoke_effect)

		self._smoke_effect = nil
	end

	if self._set_blurzone then
		self._set_blurzone = nil

		managers.environment_controller:set_blurzone(self._unit:key(), 0)
	end
end
