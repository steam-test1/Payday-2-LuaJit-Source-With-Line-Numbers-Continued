NewRaycastWeaponBaseVR = NewRaycastWeaponBase or Application:error("NewRaycastWeaponBaseVR requires NewRaycastWeaponBase!")

require("lib/units/weapons/ReloadTimeline")

local __check_autoaim = NewRaycastWeaponBase.check_autoaim
local __get_spread = NewRaycastWeaponBase._get_spread
local __reload_speed_multiplier = NewRaycastWeaponBase.reload_speed_multiplier

-- Lines: 9 to 21
function NewRaycastWeaponBaseVR:check_autoaim(from_pos, direction, max_dist, use_aim_assist, autohit_override_data)
	local spread_x, spread_y = __get_spread(self, self._setup.user_unit)
	local spread = math.max((spread_x + spread_y) / 2, 1)
	local autohit = use_aim_assist and self._aim_assist_data or self._autohit_data
	autohit = autohit_override_data or autohit
	autohit = clone(autohit)
	autohit.near_angle = autohit.near_angle * 2 / spread
	autohit.far_angle = autohit.far_angle * 3 / spread

	return __check_autoaim(self, from_pos, direction, max_dist, use_aim_assist, autohit)
end

-- Lines: 24 to 35
function NewRaycastWeaponBaseVR:_get_spread(user_unit)
	local spread_x, spread_y = __get_spread(self, user_unit)
	local fps_camera = user_unit:camera() and user_unit:camera():camera_unit():base()

	if fps_camera then
		local recoil_v = (fps_camera._recoil_kick.current or 0) / 10
		local recoil_h = (fps_camera._recoil_kick.h.current or 0) / 10
		spread_x = spread_x + recoil_h
		spread_y = spread_y + recoil_v
	end

	return spread_x, spread_y
end

-- Lines: 38 to 40
function NewRaycastWeaponBaseVR:reload_speed_multiplier()
	local mul = __reload_speed_multiplier(self)

	return mul * tweak_data.vr.reload_speed_mul
end

-- Lines: 43 to 65
function NewRaycastWeaponBaseVR:start_reload(total_time)
	NewRaycastWeaponBaseVR.super.start_reload(self)

	local mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("magazine", self._factory_id, self._blueprint)
	local mag_id = mag_list and mag_list[1]

	if mag_id then
		local mag = self._parts[mag_id]

		if mag then
			self._reload_mag_id = mag_id
			self._reload_mag_unit = mag.unit
			self._timeline = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].start and ReloadTimeline:new(tweak_data.vr.reload_timelines[self.name_id].start)
			self._total_reload_time = total_time
			self._current_reload_time = 0

			if mag.reload_objects then
				local reload_object_name = self:clip_empty() and mag.reload_objects.reload or mag.reload_objects.reload_not_empty
				self._reload_object = self._reload_mag_unit:get_object(Idstring(reload_object_name))
			end
		end
	end
end
local __on_reload = NewRaycastWeaponBaseVR.on_reload

-- Lines: 68 to 74
function NewRaycastWeaponBaseVR:on_reload(...)
	__on_reload(self, ...)
	self:stop_reload()
end

-- Lines: 76 to 91
function NewRaycastWeaponBaseVR:finish_reload()
	if alive(self._reload_mag_unit) then
		self._reload_finish_total_time = nil
		self._reload_finish_current_time = nil
		self._reload_mag_id = nil
		self._reload_mag_unit = nil
		self._timeline = nil

		if self._reload_object then
			self._reload_object:set_visibility(false)

			self._reload_object = nil
		end
	end

	self:tweak_data_anim_stop("magazine_empty")
end

-- Lines: 93 to 105
function NewRaycastWeaponBaseVR:stop_reload()
	if alive(self._reload_mag_unit) then
		self._reload_finish_total_time = tweak_data.vr.reload_buff
		self._reload_finish_current_time = 0
		self._total_reload_time = nil
		self._current_reload_time = nil
		self._timeline = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].finish and ReloadTimeline:new(tweak_data.vr.reload_timelines[self.name_id].finish)

		if self._reload_object then
			self._reload_object:set_position(self._reload_mag_unit:position())
			self._reload_object:set_visibility(true)
		end
	end
end
local __update_reloading = NewRaycastWeaponBaseVR.update_reloading

-- Lines: 108 to 114
function NewRaycastWeaponBaseVR:update_reloading(t, dt, time_left)
	if self._reload_mag_unit and self._current_reload_time and self._current_reload_time <= self._total_reload_time then
		self._current_reload_time = self._current_reload_time + dt

		self:update_reload_mag(self._current_reload_time / self._total_reload_time)
	end

	return __update_reloading(self, t, dt, time_left)
end

-- Lines: 117 to 124
function NewRaycastWeaponBaseVR:update_reload_finish(t, dt)
	if self._reload_finish_current_time <= self._reload_finish_total_time then
		self._reload_finish_current_time = self._reload_finish_current_time + dt

		self:update_reload_mag(self._reload_finish_current_time / self._reload_finish_total_time)
	else
		self:finish_reload()
	end
end

-- Lines: 126 to 137
function NewRaycastWeaponBase:_play_reload_anim(anim_group_id, to, from, unit)
	unit = unit or self._unit

	unit:anim_stop(anim_group_id)

	if from then
		unit:anim_set_time(anim_group_id, from)
	end

	if to then
		unit:anim_play_to(anim_group_id, to)
	else
		unit:anim_play(anim_group_id)
	end
end

-- Lines: 139 to 169
function NewRaycastWeaponBaseVR:update_reload_mag(time)
	if not self._timeline then
		return
	end

	local mag_data = self._timeline:get_data(time)

	self._reload_mag_unit:set_local_position(mag_data.pos)
	self._reload_mag_unit:set_local_rotation(mag_data.rot)

	if mag_data.visible ~= nil then
		self._reload_mag_unit:set_visible(mag_data.visible)
		self:_set_part_temporary_visibility(self._reload_mag_id, mag_data.visible)
	end

	if mag_data.sound then
		self:play_sound(mag_data.sound)
	end

	if mag_data.anims then
		for _, anim_data in ipairs(mag_data.anims) do
			local anim_group_id = Idstring(anim_data.anim_group)

			if anim_data.part then
				local part_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(anim_data.part, self._factory_id, self._blueprint)

				for _, part_name in ipairs(part_list or {}) do
					local part_data = self._parts[part_name]

					if part_data.animations and part_data.animations[anim_data.anim_group] then
						self:_play_reload_anim(anim_group_id, anim_data.to, anim_data.from, part_data.unit)
					end
				end
			else
				self:_play_reload_anim(anim_group_id, anim_data.to, anim_data.from)
			end
		end
	end
end

-- Lines: 171 to 172
function NewRaycastWeaponBaseVR:is_finishing_reload()
	return not not self._reload_finish_current_time
end

-- Lines: 175 to 176
function NewRaycastWeaponBaseVR:get_reload_mag_unit()
	return self._reload_mag_unit
end

-- Lines: 179 to 185
function NewRaycastWeaponBaseVR:_mag_data()
	local mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("magazine", self._factory_id, self._blueprint)
	local mag_id = mag_list and mag_list[1]

	if mag_id then
		return managers.weapon_factory:get_part_data_by_part_id_from_weapon(mag_id, self._factory_id, self._blueprint)
	end
end

-- Lines: 187 to 192
function NewRaycastWeaponBaseVR:magazine_unit_name()
	if tweak_data.vr.reload_timelines[self.name_id].custom_mag_unit then
		return tweak_data.vr.reload_timelines[self.name_id].custom_mag_unit
	end

	local mag_data = self:_mag_data()

	return mag_data and mag_data.unit
end

-- Lines: 195 to 200
function NewRaycastWeaponBaseVR:reload_object_name()
	local mag_data = self:_mag_data()

	if mag_data and mag_data.reload_objects then
		return self:clip_empty() and mag_data.reload_objects.reload or mag_data.reload_objects.reload_not_empty
	end
end

-- Lines: 202 to 205
function NewRaycastWeaponBaseVR:_set_part_temporary_visibility(part_id, visible)
	self._invisible_parts = self._invisible_parts or {}
	self._invisible_parts[part_id] = not visible
end

-- Lines: 207 to 208
function NewRaycastWeaponBaseVR:_is_part_visible(part_id)
	return not self._invisible_parts or not self._invisible_parts[part_id]
end
local __get_sound_event = NewRaycastWeaponBase._get_sound_event

-- Lines: 212 to 221
function NewRaycastWeaponBaseVR:_get_sound_event(event, alternative_event)
	local sound_overrides = tweak_data.vr.weapon_sound_overrides[self.name_id]

	if sound_overrides then
		local new_event = sound_overrides.sounds[event] or sound_overrides.sounds[alternative_event]

		if new_event then
			return new_event
		end
	end

	return __get_sound_event(self, event, alternative_event)
end

