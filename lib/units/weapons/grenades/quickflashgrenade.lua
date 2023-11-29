local tmp_vec1 = Vector3()
QuickFlashGrenade = QuickFlashGrenade or class()
QuickFlashGrenade.States = {
	{
		"_state_launched",
		0.5
	},
	{
		"_state_bounced",
		0.5
	},
	{
		"_state_armed"
	},
	{
		"_state_detonated"
	}
}
QuickFlashGrenade.Events = {
	DestroyedByPlayer = 1,
	[1.0] = "on_flashbang_destroyed"
}

-- Lines 21-46
function QuickFlashGrenade:init(unit)
	self._unit = unit
	self._state = 0
	local td = tweak_data.group_ai.flash_grenade
	self._range = td.range
	self._light_range = td.light_range
	self._light_color = td.light_color
	self._light_specular = td.light_specular
	self._beep_mul = td.beep_multi
	self._beep_fade_speed = td.beep_fade_speed
	self._beep_speeds = td.beep_speed
	QuickFlashGrenade.States[3][3] = QuickFlashGrenade.States[3][3] or td.timer

	if Network:is_client() then
		self._unit:set_enabled(false)
	end

	self._unit:set_extension_update_enabled(Idstring("base"), false)
end

-- Lines 48-88
function QuickFlashGrenade:update(unit, t, dt)
	if self._destroyed then
		return
	end

	if self._timer then
		self._timer = self._timer - dt

		if self._timer <= 0 then
			self._state = self._state + 1
			local state = QuickFlashGrenade.States[self._state]

			if state then
				self[state[1]](self)

				self._timer = state[2]
			else
				self._timer = nil
			end
		end
	end

	if self._beep_t then
		self._beep_t = self._beep_t - dt

		if self._beep_t < 0 then
			self:_beep()
		end
	end

	if alive(self._light) then
		self._light_multiplier = math.clamp(self._light_multiplier - dt * self._beep_fade_speed, 0, 1)

		self._light:set_multiplier(self._light_multiplier)
		self._light:set_far_range(self._light_range * self._light_multiplier)
	end
end

-- Lines 90-94
function QuickFlashGrenade:_beep()
	self._unit:sound_source():post_event("pfn_beep")

	self._beep_t = self:_get_next_beep_time()
	self._light_multiplier = self._beep_mul
end

-- Lines 96-102
function QuickFlashGrenade:timer(new)
	if not self._timer then
		self._timer = 3
	end

	self._timer = new or self._timer

	return self._timer
end

-- Lines 104-107
function QuickFlashGrenade:_get_next_beep_time()
	local beep_speeds = self._beep_speeds

	return self:timer() / beep_speeds[1] * beep_speeds[2]
end

-- Lines 109-111
function QuickFlashGrenade:activate(position)
	self:_activate(0, 0, position)
end

-- Lines 113-117
function QuickFlashGrenade:activate_immediately(position)
	self:_activate(4, nil, position)
	self:_state_detonated()
end

-- Lines 119-129
function QuickFlashGrenade:_activate(state, timer, position)
	self._state = state
	self._timer = timer
	self._shoot_position = position

	if Network:is_client() then
		self._unit:set_enabled(true)
	end

	self._unit:set_extension_update_enabled(Idstring("base"), true)
end

-- Lines 131-141
function QuickFlashGrenade:_state_launched()
	self._unit:damage():run_sequence_simple("insert")

	if self._shoot_position then
		local sound_source = SoundDevice:create_source("grenade_fire_source")

		sound_source:set_position(self._shoot_position)
		sound_source:post_event("grenade_gas_npc_fire", callback(self, self, "sound_playback_complete_clbk"), sound_source, "end_of_event")
	end
end

-- Lines 143-163
function QuickFlashGrenade:_state_bounced()
	self._unit:sound_source():post_event("flashbang_bounce")
end

-- Lines 165-185
function QuickFlashGrenade:_state_armed()
	self._unit:damage():run_sequence_simple("activate")
	self:_beep()

	local pos = tmp_vec1

	self._unit:m_position(pos)

	local light = World:create_light("omni|specular")

	light:set_far_range(self._light_range)
	light:set_color(self._light_color)
	light:set_position(pos)
	light:set_specular_multiplier(self._light_specular)
	light:set_enable(true)
	light:set_multiplier(0)
	light:set_falloff_exponent(0.5)

	self._light = light
	self._light_multiplier = 0
end

-- Lines 187-198
function QuickFlashGrenade:_state_detonated()
	self._beep_t = nil
	local detonate_pos = self._unit:position()

	self:make_flash(detonate_pos, self._range)

	if Network:is_server() then
		managers.groupai:state():propagate_alert({
			"aggression",
			detonate_pos,
			10000,
			managers.groupai:state():get_unit_type_filter("civilians_enemies")
		})
	end

	self._unit:damage():run_sequence_simple("detonate")
	self:_handle_hiding_and_destroying(true, 3)
end

-- Lines 200-220
function QuickFlashGrenade:make_flash(detonate_pos, range, ignore_units)
	local range = range or 1000
	local effect_params = {
		sound_event = "flashbang_explosion",
		effect = "effects/particles/explosions/explosion_flash_grenade",
		camera_shake_max_mul = 4,
		feedback_range = range * 2
	}

	managers.explosion:play_sound_and_effects(detonate_pos, math.UP, range, effect_params)

	ignore_units = ignore_units or {}

	table.insert(ignore_units, self._unit)

	local affected, line_of_sight, travel_dis, linear_dis = self:_chk_dazzle_local_player(detonate_pos, range, ignore_units)

	if affected then
		managers.environment_controller:set_flashbang(detonate_pos, line_of_sight, travel_dis, linear_dis, tweak_data.character.flashbang_multiplier, nil, true)

		local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.3, 1)

		managers.player:player_unit():character_damage():on_flashbanged(sound_eff_mul)
	end
end

-- Lines 222-295
function QuickFlashGrenade:_chk_dazzle_local_player(detonate_pos, range, ignore_units)
	local player = managers.player:player_unit()

	if not alive(player) then
		return
	end

	local detonate_pos = detonate_pos or self._unit:position() + math.UP * 150
	local m_pl_head_pos = player:movement():m_head_pos()
	local linear_dis = mvector3.distance(detonate_pos, m_pl_head_pos)

	if range < linear_dis then
		return
	end

	local slotmask = managers.slot:get_mask("bullet_impact_targets")

	-- Lines 247-253
	local function _vis_ray_func(from, to, boolean)
		if ignore_units then
			return World:raycast("ray", from, to, "ignore_unit", ignore_units, "slot_mask", slotmask, boolean and "report" or nil)
		else
			return World:raycast("ray", from, to, "slot_mask", slotmask, boolean and "report" or nil)
		end
	end

	if not _vis_ray_func(m_pl_head_pos, detonate_pos, true) then
		return true, true, nil, linear_dis
	end

	local random_rotation = Rotation(360 * math.random(), 360 * math.random(), 360 * math.random())
	local raycast_dir = Vector3()
	local bounce_pos = Vector3()

	for _, axis in ipairs({
		"x",
		"y",
		"z"
	}) do
		for _, polarity in ipairs({
			1,
			-1
		}) do
			mvector3.set_zero(raycast_dir)
			mvector3["set_" .. axis](raycast_dir, polarity)
			mvector3.rotate_with(raycast_dir, random_rotation)
			mvector3.set(bounce_pos, raycast_dir)
			mvector3.multiply(bounce_pos, range)
			mvector3.add(bounce_pos, detonate_pos)

			local bounce_ray = _vis_ray_func(detonate_pos, bounce_pos)

			if bounce_ray then
				mvector3.set(bounce_pos, raycast_dir)
				mvector3.multiply(bounce_pos, -1 * math.min(bounce_ray.distance, 10))
				mvector3.add(bounce_pos, bounce_ray.position)

				local return_ray = _vis_ray_func(m_pl_head_pos, bounce_pos, true)

				if not return_ray then
					local travel_dis = bounce_ray.distance + mvector3.distance(m_pl_head_pos, bounce_pos)

					if range > travel_dis then
						return true, false, travel_dis, linear_dis
					end
				end
			end
		end
	end
end

-- Lines 297-299
function QuickFlashGrenade:sound_playback_complete_clbk(event_instance, sound_source, event_type, sound_source_again)
end

-- Lines 302-304
function QuickFlashGrenade:preemptive_kill()
	self:_handle_hiding_and_destroying(true)
end

-- Lines 306-331
function QuickFlashGrenade:_handle_hiding_and_destroying(destroy, destruction_delay)
	self._beep_t = nil
	self._destroyed = true

	self._unit:set_extension_update_enabled(Idstring("base"), false)
	self:remove_light()
	self._unit:set_visible(false)
	self._unit:set_enabled(false)

	if destroy and (Network:is_server() or self._unit:id() == -1) then
		if destruction_delay then
			if not self._destroy_clbk_id then
				self._destroy_clbk_id = "quick_flash_destroy" .. tostring(self._unit:key())

				managers.enemy:add_delayed_clbk(self._destroy_clbk_id, callback(self, self, "_clbk_destroy"), TimerManager:game():time() + destruction_delay)
			end
		else
			self._unit:set_slot(0)
		end
	end
end

-- Lines 333-339
function QuickFlashGrenade:_clbk_destroy()
	self._destroy_clbk_id = nil

	if alive(self._unit) then
		self._unit:set_slot(0)
	end
end

-- Lines 341-347
function QuickFlashGrenade:remove_light()
	if alive(self._light) then
		World:delete_light(self._light)

		self._light = nil
	end
end

-- Lines 350-366
function QuickFlashGrenade:on_flashbang_destroyed(prevent_network)
	if self._destroyed then
		return
	end

	self._destroyed = true

	if not prevent_network then
		managers.network:session():send_to_peers_synched("sync_flashbang_event", self._unit, QuickFlashGrenade.Events.DestroyedByPlayer)
	end

	self._unit:sound_source():post_event("pfn_beep_end")
	self:_handle_hiding_and_destroying(true, 3)
end

-- Lines 369-376
function QuickFlashGrenade:on_network_event(event_id)
	local event = QuickFlashGrenade.Events[event_id]

	if event and self[event] then
		self[event](self, true)
	else
		Application:error("Received a network event id that is not mapped!")
	end
end

-- Lines 378-385
function QuickFlashGrenade:destroy()
	self:remove_light()

	if self._destroy_clbk_id then
		managers.enemy:remove_delayed_clbk(self._destroy_clbk_id)

		self._destroy_clbk_id = nil
	end
end
