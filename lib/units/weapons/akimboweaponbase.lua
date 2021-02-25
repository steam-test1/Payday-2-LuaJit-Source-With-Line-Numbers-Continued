AkimboWeaponBase = AkimboWeaponBase or class(NewRaycastWeaponBase)
AkimboWeaponBase.AKIMBO = true

-- Lines 4-11
function AkimboWeaponBase:init(...)
	AkimboWeaponBase.super.init(self, ...)

	self._manual_fire_second_gun = self:weapon_tweak_data().manual_fire_second_gun

	self._unit:set_extension_update_enabled(Idstring("base"), true)

	self._fire_callbacks = {}
end

-- Lines 13-24
function AkimboWeaponBase:update(unit, t, dt)
	for i = #self._fire_callbacks, 1, -1 do
		local data = self._fire_callbacks[i]
		data.t = data.t - dt

		if data.t <= 0 then
			data.callback(self)
			table.remove(self._fire_callbacks, i)
		end
	end
end

-- Lines 26-62
function AkimboWeaponBase:_create_second_gun(unit_name)
	local factory_weapon = tweak_data.weapon.factory[self._factory_id]
	local ids_unit_name = Idstring(factory_weapon.unit)
	local new_unit = World:spawn_unit(ids_unit_name, Vector3(), Rotation())

	new_unit:base():set_factory_data(self._factory_id)

	if self._cosmetics_id then
		local cosmetics = {
			id = self._cosmetics_id,
			quality = self._cosmetics_quality,
			bonus = self._cosmetics_bonus,
			color_index = self._cosmetics_color_index
		}

		new_unit:base():set_cosmetics_data(cosmetics)
	end

	if self._blueprint then
		new_unit:base():assemble_from_blueprint(self._factory_id, self._blueprint)
	elseif not unit_name then
		new_unit:base():assemble(self._factory_id)
	end

	self._second_gun = new_unit
	self._second_gun:base().SKIP_AMMO = true
	self._second_gun:base().parent_weapon = self._unit

	if self:fire_mode() == "auto" then
		self._second_gun:base():mute_firing()
	end

	new_unit:base():setup(self._setup)

	self.akimbo = true

	if self._enabled then
		self._second_gun:base():on_enabled()
	else
		self._second_gun:base():on_disabled()
	end
end

-- Lines 64-80
function AkimboWeaponBase:toggle_firemode(skip_post_event)
	if AkimboWeaponBase.super.toggle_firemode(self, skip_post_event) then
		if alive(self._second_gun) then
			self._fire_callbacks = {}

			return self._second_gun:base():toggle_firemode(true)
		else
			return true
		end
	end

	return false
end

-- Lines 82-85
function AkimboWeaponBase:create_second_gun(create_second_gun)
	self:_create_second_gun(create_second_gun)
	self._setup.user_unit:camera()._camera_unit:link(Idstring("a_weapon_left"), self._second_gun, self._second_gun:orientation_object():name())
end

-- Lines 88-91
function AkimboWeaponBase:start_shooting()
	AkimboWeaponBase.super.start_shooting(self)

	self._fire_second_sound = not self._fire_second_gun_next and self:fire_mode() ~= "auto"
end

-- Lines 93-95
function AkimboWeaponBase:get_fire_time()
	return 0.025 + math.rand(0.075)
end

-- Lines 97-128
function AkimboWeaponBase:fire(...)
	if not self._manual_fire_second_gun then
		local result = AkimboWeaponBase.super.fire(self, ...)

		if alive(self._second_gun) then
			table.insert(self._fire_callbacks, {
				t = self:get_fire_time(),
				callback = callback(self, self, "_fire_second", {
					...
				})
			})
		end

		return result
	else
		local result = nil

		if self._fire_second_gun_next then
			if alive(self._second_gun) then
				result = self._second_gun:base().super.fire(self._second_gun:base(), ...)

				if result then
					if self._fire_second_sound then
						self._fire_second_sound = false

						self._second_gun:base():_fire_sound()
					end

					managers.hud:set_ammo_amount(self:selection_index(), self:ammo_info())
					self._second_gun:base():tweak_data_anim_play("fire")
				end
			end

			self._fire_second_gun_next = false
		else
			result = AkimboWeaponBase.super.fire(self, ...)
			self._fire_second_gun_next = true
		end

		return result
	end
end

-- Lines 130-144
function AkimboWeaponBase:_fire_second(params)
	if alive(self._second_gun) and self._setup and alive(self._setup.user_unit) then
		local fired = self._second_gun:base().super.fire(self._second_gun:base(), unpack(params))

		if fired then
			if self._fire_second_sound then
				self._fire_second_sound = false

				self._second_gun:base():_fire_sound()
			end

			managers.hud:set_ammo_amount(self:selection_index(), self:ammo_info())
			self._second_gun:base():tweak_data_anim_play("fire")
		end

		return fired
	end
end

-- Lines 147-162
function AkimboWeaponBase:_do_update_bullet_objects(weapon_base, ammo_func, is_second_gun)
	if weapon_base._bullet_objects then
		for i, objects in pairs(weapon_base._bullet_objects) do
			for _, object in ipairs(objects) do
				local ammo_base = weapon_base:ammo_base()
				local ammo = ammo_base[ammo_func](ammo_base) / 2

				if is_second_gun then
					ammo = math.ceil(ammo)
				else
					ammo = math.floor(ammo)
				end

				object[1]:set_visibility(i <= ammo)
			end
		end
	end
end

-- Lines 164-169
function AkimboWeaponBase:_update_bullet_objects(ammo_func)
	self:_do_update_bullet_objects(self, ammo_func, false)

	if alive(self._second_gun) then
		self:_do_update_bullet_objects(self._second_gun:base(), ammo_func, true)
	end
end

-- Lines 171-176
function AkimboWeaponBase:_check_magazine_empty()
	AkimboWeaponBase.super._check_magazine_empty(self)

	if alive(self._second_gun) then
		self._second_gun:base():_check_magazine_empty()
	end
end

-- Lines 179-184
function AkimboWeaponBase:on_enabled(...)
	AkimboWeaponBase.super.on_enabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_enabled(...)
	end
end

-- Lines 186-191
function AkimboWeaponBase:on_disabled(...)
	AkimboWeaponBase.super.on_disabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_disabled(...)
	end
end

-- Lines 194-199
function AkimboWeaponBase:on_equip(...)
	AkimboWeaponBase.super.on_equip(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_equip(...)
	end
end

-- Lines 201-206
function AkimboWeaponBase:set_magazine_empty(...)
	AkimboWeaponBase.super.set_magazine_empty(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_magazine_empty(...)
	end
end

-- Lines 209-214
function AkimboWeaponBase:set_gadget_on(...)
	AkimboWeaponBase.super.set_gadget_on(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_gadget_on(...)
	end
end

-- Lines 217-231
function AkimboWeaponBase:set_gadget_color(...)
	if not self._enabled then
		return
	end

	if not self._assembly_complete then
		return
	end

	AkimboWeaponBase.super.set_gadget_color(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_gadget_color(...)
	end
end

-- Lines 234-239
function AkimboWeaponBase:_second_gun_tweak_data_anim_version(anim)
	if not self:weapon_tweak_data().animations.second_gun_versions then
		return anim
	end

	return self:weapon_tweak_data().animations.second_gun_versions[anim] or anim
end

-- Lines 241-249
function AkimboWeaponBase:tweak_data_anim_play(anim, ...)
	if alive(self._second_gun) and anim ~= "fire" then
		local second_gun_anim = self:_second_gun_tweak_data_anim_version(anim)

		self._second_gun:base():tweak_data_anim_play(second_gun_anim, ...)
	end

	return AkimboWeaponBase.super.tweak_data_anim_play(self, anim, ...)
end

-- Lines 251-257
function AkimboWeaponBase:tweak_data_anim_stop(anim, ...)
	AkimboWeaponBase.super.tweak_data_anim_stop(self, anim, ...)

	if alive(self._second_gun) then
		local second_gun_anim = self:_second_gun_tweak_data_anim_version(anim)

		self._second_gun:base():tweak_data_anim_stop(second_gun_anim, ...)
	end
end

-- Lines 259-264
function AkimboWeaponBase:destroy(...)
	AkimboWeaponBase.super.destroy(self, ...)

	if alive(self._second_gun) then
		self._second_gun:set_slot(0)
	end
end

-- Lines 266-269
function AkimboWeaponBase:mute_firing()
	self._firing_muted = true

	self._sound_fire:stop()
end

-- Lines 271-273
function AkimboWeaponBase:unmute_firing()
	self._firing_muted = nil
end

-- Lines 275-280
function AkimboWeaponBase:_sound_autofire_start(...)
	if self._firing_muted then
		return
	end

	AkimboWeaponBase.super._sound_autofire_start(self, ...)
end

-- Lines 282-287
function AkimboWeaponBase:_sound_singleshot()
	if self._firing_muted then
		return
	end

	AkimboWeaponBase.super._sound_singleshot(self)
end

NPCAkimboWeaponBase = NPCAkimboWeaponBase or class(NewNPCRaycastWeaponBase)
NPCAkimboWeaponBase.AKIMBO = true

-- Lines 294-301
function NPCAkimboWeaponBase:init(...)
	NPCAkimboWeaponBase.super.init(self, ...)

	self._manual_fire_second_gun = self:weapon_tweak_data().manual_fire_second_gun

	self._unit:set_extension_update_enabled(Idstring("base"), true)

	self._fire_callbacks = {}
end

-- Lines 303-314
function NPCAkimboWeaponBase:update(unit, t, dt)
	for i = #self._fire_callbacks, 1, -1 do
		local data = self._fire_callbacks[i]
		data.t = data.t - dt

		if data.t <= 0 then
			data.callback(self)
			table.remove(self._fire_callbacks, i)
		end
	end
end

-- Lines 316-320
function NPCAkimboWeaponBase:link_secondary_weapon(secondary)
	if alive(self._second_gun) then
		self._setup.user_unit:link(secondary or Idstring("a_weapon_left_front"), self._second_gun, self._second_gun:orientation_object():name())
	end
end

-- Lines 322-325
function NPCAkimboWeaponBase:create_second_gun(create_second_gun, align_point)
	AkimboWeaponBase._create_second_gun(self, create_second_gun)
	self._setup.user_unit:link(align_point or Idstring("a_weapon_left_front"), self._second_gun, self._second_gun:orientation_object():name())
end

-- Lines 327-329
function NPCAkimboWeaponBase:get_fire_time()
	return AkimboWeaponBase.get_fire_time(self)
end

-- Lines 331-359
function NPCAkimboWeaponBase:fire_blank(direction, impact, sub_id, override_direction)
	if sub_id == 0 then
		if not self._manual_fire_second_gun then
			NPCAkimboWeaponBase.super.fire_blank(self, direction, impact, sub_id, override_direction)

			if alive(self._second_gun) then
				if self._setup.user_unit:movement():current_state_name() == "bleed_out" or self._setup.user_unit:movement():zipline_unit() then
					return
				end

				managers.enemy:add_delayed_clbk("NPCAkimboWeaponBase", callback(self, self, "_fire_blank_second", {
					direction,
					impact,
					sub_id,
					override_direction
				}), TimerManager:game():time() + self:get_fire_time())
			end
		elseif self._fire_second_gun_next then
			if alive(self._second_gun) and alive(self._setup.user_unit) then
				self._second_gun:base():fire_blank(direction, impact, sub_id, override_direction)
			end

			self._fire_second_gun_next = false
		else
			NPCAkimboWeaponBase.super.fire_blank(self, direction, impact, sub_id, override_direction)

			self._fire_second_gun_next = true
		end
	elseif sub_id == 1 then
		NPCAkimboWeaponBase.super.fire_blank(self, direction, impact, sub_id, override_direction)
	elseif sub_id == 2 then
		NPCAkimboWeaponBase.super.fire_blank(self._second_gun:base(), direction, impact, sub_id, override_direction)
	end
end

-- Lines 361-365
function NPCAkimboWeaponBase:_fire_blank_second(params)
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():fire_blank(unpack(params))
	end
end

-- Lines 367-387
function NPCAkimboWeaponBase:auto_fire_blank(direction, impact, sub_ids, override_direction)
	if not sub_ids or sub_ids == 0 then
		NPCAkimboWeaponBase.super.auto_fire_blank(self, direction, impact, sub_ids, override_direction)

		if alive(self._second_gun) and impact then
			table.insert(self._fire_callbacks, {
				t = self:get_fire_time(),
				callback = callback(self, self, "_auto_fire_blank_second", {
					direction,
					impact,
					sub_ids,
					override_direction
				})
			})
		end
	end

	if bit.band(sub_ids, 1) == 1 then
		NPCAkimboWeaponBase.super.auto_fire_blank(self, direction, impact, 1, override_direction)
	end

	if bit.band(sub_ids, 2) == 2 then
		NPCAkimboWeaponBase.super.auto_fire_blank(self._second_gun:base(), direction, impact, 1, override_direction)
	end

	return true
end

-- Lines 389-393
function NPCAkimboWeaponBase:_auto_fire_blank_second(params)
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():auto_fire_blank(unpack(params))
	end
end

-- Lines 395-414
function NPCAkimboWeaponBase:start_autofire(nr_shots, sub_id)
	if not sub_id or sub_id == 0 then
		NPCAkimboWeaponBase.super.start_autofire(self, nr_shots)

		if alive(self._second_gun) then
			table.insert(self._fire_callbacks, {
				t = self:get_fire_time(),
				callback = callback(self, self, "_start_autofire_second", nr_shots or false)
			})
		end
	end

	if sub_id == 1 then
		NPCAkimboWeaponBase.super.start_autofire(self, nr_shots)
	end

	if sub_id == 2 then
		self._next_fire_allowed = math.max(self._next_fire_allowed, Application:time())

		NPCAkimboWeaponBase.super.start_autofire(self._second_gun:base(), nr_shots)
	end
end

-- Lines 416-420
function NPCAkimboWeaponBase:_start_autofire_second(nr_shots)
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():start_autofire(nr_shots or nil)
	end
end

-- Lines 422-436
function NPCAkimboWeaponBase:stop_autofire(sub_id)
	if not sub_id then
		NPCAkimboWeaponBase.super.stop_autofire(self)

		if alive(self._second_gun) then
			table.insert(self._fire_callbacks, {
				t = self:get_fire_time(),
				callback = callback(self, self, "_stop_autofire_second")
			})
		end
	elseif sub_id == 1 then
		NPCAkimboWeaponBase.super.stop_autofire(self)
	elseif sub_id == 2 then
		NPCAkimboWeaponBase.super.stop_autofire(self._second_gun:base())
	end
end

-- Lines 438-442
function NPCAkimboWeaponBase:_stop_autofire_second()
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():stop_autofire()
	end
end

-- Lines 444-449
function NPCAkimboWeaponBase:on_enabled(...)
	NPCAkimboWeaponBase.super.on_enabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_enabled(...)
	end
end

-- Lines 451-456
function NPCAkimboWeaponBase:on_disabled(...)
	NPCAkimboWeaponBase.super.on_disabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_disabled(...)
	end
end

-- Lines 458-466
function NPCAkimboWeaponBase:on_melee_item_shown(use_primary)
	if use_primary then
		NPCAkimboWeaponBase.super.on_disabled(self)
	elseif alive(self._second_gun) then
		self._second_gun:base():on_disabled()
	end
end

-- Lines 468-498
function NPCAkimboWeaponBase:on_melee_item_hidden(use_primary)
	if use_primary then
		NPCAkimboWeaponBase.super.on_enabled(self)

		local active, part_id = self:get_active_gadget()

		if part_id then
			self:set_gadget_on_by_part_id(part_id)

			if self.gadget_color and self:gadget_color() then
				self:set_gadget_color(self:gadget_color())
			end
		end
	elseif alive(self._second_gun) then
		self._second_gun:base():on_enabled()

		local active, part_id = self:get_active_gadget()

		if part_id then
			self._second_gun:base():set_gadget_on_by_part_id(part_id)

			if self._second_gun:base().gadget_color and self._second_gun:base():gadget_color() then
				self._second_gun:base():set_gadget_color(self._second_gun:base():gadget_color())
			end
		end
	end
end

-- Lines 500-505
function NPCAkimboWeaponBase:set_gadget_on(...)
	NPCAkimboWeaponBase.super.set_gadget_on(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_gadget_on(...)
	end
end

-- Lines 508-510
function NPCAkimboWeaponBase:gadget_color()
	return self._gadget_color
end

-- Lines 512-528
function NPCAkimboWeaponBase:set_gadget_color(color)
	if not self._enabled then
		return
	end

	if not self._assembly_complete then
		return
	end

	self._gadget_color = color

	NPCAkimboWeaponBase.super.set_gadget_color(self, color)

	if alive(self._second_gun) then
		self._second_gun:base():set_gadget_color(color)
	end
end

-- Lines 531-536
function NPCAkimboWeaponBase:destroy(...)
	NPCAkimboWeaponBase.super.destroy(self, ...)

	if alive(self._second_gun) then
		self._second_gun:set_slot(0)
	end
end

-- Lines 538-538
function NPCAkimboWeaponBase:mute_firing()
	AkimboWeaponBase.mute_firing(self)
end

-- Lines 539-539
function NPCAkimboWeaponBase:unmute_firing()
	AkimboWeaponBase.unmute_firing(self)
end

-- Lines 541-546
function NPCAkimboWeaponBase:_sound_autofire_start(...)
	if self._firing_muted then
		return
	end

	NPCAkimboWeaponBase.super._sound_autofire_start(self, ...)
end

-- Lines 548-553
function NPCAkimboWeaponBase:_sound_singleshot()
	if self._firing_muted then
		return
	end

	NPCAkimboWeaponBase.super._sound_singleshot(self)
end

EnemyAkimboWeaponBase = EnemyAkimboWeaponBase or class(NPCRaycastWeaponBase)
EnemyAkimboWeaponBase.AKIMBO = true

-- Lines 560-562
function EnemyAkimboWeaponBase:init(...)
	NPCRaycastWeaponBase.init(self, ...)
end

-- Lines 564-596
function EnemyAkimboWeaponBase:create_second_gun(unit_name)
	local new_unit = World:spawn_unit(unit_name, Vector3(), Rotation())

	if self._cosmetics_id then
		local cosmetics = {
			id = self._cosmetics_id,
			quality = self._cosmetics_quality,
			bonus = self._cosmetics_bonus,
			color_index = self._cosmetics_color_index
		}

		new_unit:base():set_cosmetics_data(cosmetics)
	end

	self._second_gun = new_unit
	self._second_gun:base().SKIP_AMMO = true
	self._second_gun:base().parent_weapon = self._unit

	if self:fire_mode() == "auto" then
		self._second_gun:base():mute_firing()
	end

	new_unit:base():setup(self._setup)

	if self._enabled then
		self._second_gun:base():on_enabled()
	else
		self._second_gun:base():on_disabled()
	end

	self._setup.user_unit:link(Idstring("a_weapon_left_front"), self._second_gun, self._second_gun:orientation_object():name())

	self._muzzle_effect_table_second = {
		effect = self._muzzle_effect_table.effect,
		force_synch = self._muzzle_effect_table.force_synch,
		parent = self._second_gun:get_object(Idstring("fire"))
	}
end

-- Lines 598-601
function EnemyAkimboWeaponBase:_spawn_muzzle_effect(from_pos, direction)
	World:effect_manager():spawn(self._muzzle_effect_table_second)
	RaycastWeaponBase._spawn_muzzle_effect(self, from_pos, direction)
end

-- Lines 603-610
function EnemyAkimboWeaponBase:tweak_data_anim_play(anim, ...)
	local animations = self:weapon_tweak_data().animations

	if animations and animations[anim] then
		self:anim_play(animations[anim], ...)

		return RaycastWeaponBase.tweak_data_anim_play(self, anim, ...)
	end

	return RaycastWeaponBase.tweak_data_anim_play(self, anim, ...)
end

-- Lines 612-619
function EnemyAkimboWeaponBase:anim_play(anim, speed_multiplier)
	if anim then
		local length = self._unit:anim_length(Idstring(anim))
		speed_multiplier = speed_multiplier or 1

		self._second_gun:anim_stop(Idstring(anim))
		self._second_gun:anim_play_to(Idstring(anim), length, speed_multiplier)
	end
end

-- Lines 621-628
function EnemyAkimboWeaponBase:tweak_data_anim_stop(anim, ...)
	local animations = self:weapon_tweak_data().animations

	if animations and animations[anim] then
		self:anim_stop(self:weapon_tweak_data().animations[anim], ...)

		return RaycastWeaponBase.tweak_data_anim_stop(self, anim, ...)
	end

	return RaycastWeaponBase.tweak_data_anim_stop(self, anim, ...)
end

-- Lines 630-632
function EnemyAkimboWeaponBase:anim_stop(anim)
	self._second_gun:anim_stop(Idstring(anim))
end

if _G.IS_VR then
	require("lib/units/weapons/vr/AkimboWeaponBaseVR")
end

-- Lines 640-640
function EnemyAkimboWeaponBase:mute_firing()
	AkimboWeaponBase.mute_firing(self)
end

-- Lines 641-641
function EnemyAkimboWeaponBase:unmute_firing()
	AkimboWeaponBase.unmute_firing(self)
end

-- Lines 643-648
function EnemyAkimboWeaponBase:_sound_autofire_start(...)
	if self._firing_muted then
		return
	end

	EnemyAkimboWeaponBase.super._sound_autofire_start(self, ...)
end

-- Lines 650-655
function EnemyAkimboWeaponBase:_sound_singleshot()
	if self._firing_muted then
		return
	end

	EnemyAkimboWeaponBase.super._sound_singleshot(self)
end
