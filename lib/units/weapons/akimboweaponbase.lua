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

-- Lines 26-58
function AkimboWeaponBase:_create_second_gun(unit_name)
	local factory_weapon = tweak_data.weapon.factory[self._factory_id]
	local ids_unit_name = Idstring(factory_weapon.unit)
	local new_unit = World:spawn_unit(ids_unit_name, Vector3(), Rotation())

	new_unit:base():set_factory_data(self._factory_id)

	if self._cosmetics then
		new_unit:base():set_cosmetics_data(self._cosmetics)
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

-- Lines 60-76
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

-- Lines 78-81
function AkimboWeaponBase:create_second_gun(create_second_gun)
	self:_create_second_gun(create_second_gun)
	self._setup.user_unit:camera()._camera_unit:link(Idstring("a_weapon_left"), self._second_gun, self._second_gun:orientation_object():name())
end

-- Lines 84-87
function AkimboWeaponBase:start_shooting()
	AkimboWeaponBase.super.start_shooting(self)

	self._fire_second_sound = not self._fire_second_gun_next and self:fire_mode() ~= "auto"
end

-- Lines 89-91
function AkimboWeaponBase:get_fire_time()
	return 0.025 + math.rand(0.075)
end

-- Lines 93-124
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

-- Lines 126-140
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

-- Lines 143-158
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

-- Lines 160-165
function AkimboWeaponBase:_update_bullet_objects(ammo_func)
	self:_do_update_bullet_objects(self, ammo_func, false)

	if alive(self._second_gun) then
		self:_do_update_bullet_objects(self._second_gun:base(), ammo_func, true)
	end
end

-- Lines 167-172
function AkimboWeaponBase:_check_magazine_empty()
	AkimboWeaponBase.super._check_magazine_empty(self)

	if alive(self._second_gun) then
		self._second_gun:base():_check_magazine_empty()
	end
end

-- Lines 175-180
function AkimboWeaponBase:on_enabled(...)
	AkimboWeaponBase.super.on_enabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_enabled(...)
	end
end

-- Lines 182-187
function AkimboWeaponBase:on_disabled(...)
	AkimboWeaponBase.super.on_disabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_disabled(...)
	end
end

-- Lines 190-195
function AkimboWeaponBase:on_equip(...)
	AkimboWeaponBase.super.on_equip(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_equip(...)
	end
end

-- Lines 197-202
function AkimboWeaponBase:set_magazine_empty(...)
	AkimboWeaponBase.super.set_magazine_empty(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_magazine_empty(...)
	end
end

-- Lines 205-210
function AkimboWeaponBase:set_gadget_on(...)
	AkimboWeaponBase.super.set_gadget_on(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_gadget_on(...)
	end
end

-- Lines 213-227
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

-- Lines 230-235
function AkimboWeaponBase:_second_gun_tweak_data_anim_version(anim)
	if not self:weapon_tweak_data().animations.second_gun_versions then
		return anim
	end

	return self:weapon_tweak_data().animations.second_gun_versions[anim] or anim
end

-- Lines 237-245
function AkimboWeaponBase:tweak_data_anim_play(anim, ...)
	if alive(self._second_gun) and anim ~= "fire" then
		local second_gun_anim = self:_second_gun_tweak_data_anim_version(anim)

		self._second_gun:base():tweak_data_anim_play(second_gun_anim, ...)
	end

	return AkimboWeaponBase.super.tweak_data_anim_play(self, anim, ...)
end

-- Lines 247-253
function AkimboWeaponBase:tweak_data_anim_stop(anim, ...)
	AkimboWeaponBase.super.tweak_data_anim_stop(self, anim, ...)

	if alive(self._second_gun) then
		local second_gun_anim = self:_second_gun_tweak_data_anim_version(anim)

		self._second_gun:base():tweak_data_anim_stop(second_gun_anim, ...)
	end
end

-- Lines 255-260
function AkimboWeaponBase:destroy(...)
	AkimboWeaponBase.super.destroy(self, ...)

	if alive(self._second_gun) then
		self._second_gun:set_slot(0)
	end
end

-- Lines 262-265
function AkimboWeaponBase:mute_firing()
	self._firing_muted = true

	self._sound_fire:stop()
end

-- Lines 267-269
function AkimboWeaponBase:unmute_firing()
	self._firing_muted = nil
end

-- Lines 271-276
function AkimboWeaponBase:_sound_autofire_start(...)
	if self._firing_muted then
		return
	end

	AkimboWeaponBase.super._sound_autofire_start(self, ...)
end

-- Lines 278-283
function AkimboWeaponBase:_sound_singleshot()
	if self._firing_muted then
		return
	end

	AkimboWeaponBase.super._sound_singleshot(self)
end

NPCAkimboWeaponBase = NPCAkimboWeaponBase or class(NewNPCRaycastWeaponBase)
NPCAkimboWeaponBase.AKIMBO = true

-- Lines 290-297
function NPCAkimboWeaponBase:init(...)
	NPCAkimboWeaponBase.super.init(self, ...)

	self._manual_fire_second_gun = self:weapon_tweak_data().manual_fire_second_gun

	self._unit:set_extension_update_enabled(Idstring("base"), true)

	self._fire_callbacks = {}
end

-- Lines 299-310
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

-- Lines 312-316
function NPCAkimboWeaponBase:link_secondary_weapon(secondary)
	if alive(self._second_gun) then
		self._setup.user_unit:link(secondary or Idstring("a_weapon_left_front"), self._second_gun, self._second_gun:orientation_object():name())
	end
end

-- Lines 318-321
function NPCAkimboWeaponBase:create_second_gun(create_second_gun, align_point)
	AkimboWeaponBase._create_second_gun(self, create_second_gun)
	self._setup.user_unit:link(align_point or Idstring("a_weapon_left_front"), self._second_gun, self._second_gun:orientation_object():name())
end

-- Lines 323-325
function NPCAkimboWeaponBase:get_fire_time()
	return AkimboWeaponBase.get_fire_time(self)
end

-- Lines 327-355
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

-- Lines 357-361
function NPCAkimboWeaponBase:_fire_blank_second(params)
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():fire_blank(unpack(params))
	end
end

-- Lines 363-383
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

-- Lines 385-389
function NPCAkimboWeaponBase:_auto_fire_blank_second(params)
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():auto_fire_blank(unpack(params))
	end
end

-- Lines 391-410
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

-- Lines 412-416
function NPCAkimboWeaponBase:_start_autofire_second(nr_shots)
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():start_autofire(nr_shots or nil)
	end
end

-- Lines 418-432
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

-- Lines 434-438
function NPCAkimboWeaponBase:_stop_autofire_second()
	if alive(self._second_gun) and alive(self._setup.user_unit) then
		self._second_gun:base():stop_autofire()
	end
end

-- Lines 440-445
function NPCAkimboWeaponBase:on_enabled(...)
	NPCAkimboWeaponBase.super.on_enabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_enabled(...)
	end
end

-- Lines 447-452
function NPCAkimboWeaponBase:on_disabled(...)
	NPCAkimboWeaponBase.super.on_disabled(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():on_disabled(...)
	end
end

-- Lines 454-462
function NPCAkimboWeaponBase:on_melee_item_shown(use_primary)
	if use_primary then
		NPCAkimboWeaponBase.super.on_disabled(self)
	elseif alive(self._second_gun) then
		self._second_gun:base():on_disabled()
	end
end

-- Lines 464-494
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

-- Lines 496-501
function NPCAkimboWeaponBase:set_gadget_on(...)
	NPCAkimboWeaponBase.super.set_gadget_on(self, ...)

	if alive(self._second_gun) then
		self._second_gun:base():set_gadget_on(...)
	end
end

-- Lines 504-506
function NPCAkimboWeaponBase:gadget_color()
	return self._gadget_color
end

-- Lines 508-524
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

-- Lines 527-532
function NPCAkimboWeaponBase:destroy(...)
	NPCAkimboWeaponBase.super.destroy(self, ...)

	if alive(self._second_gun) then
		self._second_gun:set_slot(0)
	end
end

-- Lines 534-534
function NPCAkimboWeaponBase:mute_firing()
	AkimboWeaponBase.mute_firing(self)
end

-- Lines 535-535
function NPCAkimboWeaponBase:unmute_firing()
	AkimboWeaponBase.unmute_firing(self)
end

-- Lines 537-542
function NPCAkimboWeaponBase:_sound_autofire_start(...)
	if self._firing_muted then
		return
	end

	NPCAkimboWeaponBase.super._sound_autofire_start(self, ...)
end

-- Lines 544-549
function NPCAkimboWeaponBase:_sound_singleshot()
	if self._firing_muted then
		return
	end

	NPCAkimboWeaponBase.super._sound_singleshot(self)
end

EnemyAkimboWeaponBase = EnemyAkimboWeaponBase or class(NPCRaycastWeaponBase)
EnemyAkimboWeaponBase.AKIMBO = true

-- Lines 556-558
function EnemyAkimboWeaponBase:init(...)
	NPCRaycastWeaponBase.init(self, ...)
end

-- Lines 560-588
function EnemyAkimboWeaponBase:create_second_gun(unit_name)
	local new_unit = World:spawn_unit(unit_name, Vector3(), Rotation())

	if self._cosmetics then
		new_unit:base():set_cosmetics_data(self._cosmetics)
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

-- Lines 590-593
function EnemyAkimboWeaponBase:_spawn_muzzle_effect(from_pos, direction)
	World:effect_manager():spawn(self._muzzle_effect_table_second)
	RaycastWeaponBase._spawn_muzzle_effect(self, from_pos, direction)
end

-- Lines 595-602
function EnemyAkimboWeaponBase:tweak_data_anim_play(anim, ...)
	local animations = self:weapon_tweak_data().animations

	if animations and animations[anim] then
		self:anim_play(animations[anim], ...)

		return RaycastWeaponBase.tweak_data_anim_play(self, anim, ...)
	end

	return RaycastWeaponBase.tweak_data_anim_play(self, anim, ...)
end

-- Lines 604-611
function EnemyAkimboWeaponBase:anim_play(anim, speed_multiplier)
	if anim then
		local length = self._unit:anim_length(Idstring(anim))
		speed_multiplier = speed_multiplier or 1

		self._second_gun:anim_stop(Idstring(anim))
		self._second_gun:anim_play_to(Idstring(anim), length, speed_multiplier)
	end
end

-- Lines 613-620
function EnemyAkimboWeaponBase:tweak_data_anim_stop(anim, ...)
	local animations = self:weapon_tweak_data().animations

	if animations and animations[anim] then
		self:anim_stop(self:weapon_tweak_data().animations[anim], ...)

		return RaycastWeaponBase.tweak_data_anim_stop(self, anim, ...)
	end

	return RaycastWeaponBase.tweak_data_anim_stop(self, anim, ...)
end

-- Lines 622-624
function EnemyAkimboWeaponBase:anim_stop(anim)
	self._second_gun:anim_stop(Idstring(anim))
end

if _G.IS_VR then
	require("lib/units/weapons/vr/AkimboWeaponBaseVR")
end

-- Lines 632-632
function EnemyAkimboWeaponBase:mute_firing()
	AkimboWeaponBase.mute_firing(self)
end

-- Lines 633-633
function EnemyAkimboWeaponBase:unmute_firing()
	AkimboWeaponBase.unmute_firing(self)
end

-- Lines 635-640
function EnemyAkimboWeaponBase:_sound_autofire_start(...)
	if self._firing_muted then
		return
	end

	EnemyAkimboWeaponBase.super._sound_autofire_start(self, ...)
end

-- Lines 642-647
function EnemyAkimboWeaponBase:_sound_singleshot()
	if self._firing_muted then
		return
	end

	EnemyAkimboWeaponBase.super._sound_singleshot(self)
end
