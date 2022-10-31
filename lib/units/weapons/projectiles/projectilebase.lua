ProjectileBase = ProjectileBase or class(UnitBase)
ProjectileBase.time_cheat = {}
local mvec1 = Vector3()
local mvec2 = Vector3()
local mrot1 = Rotation()

-- Lines 10-31
function ProjectileBase:init(unit)
	ProjectileBase.super.init(self, unit, true)

	self._unit = unit
	self._damage_results = {}
	self._spawn_position = self._unit:position()
	self._simulated = true
	self._orient_to_vel = true

	if self._setup_from_tweak_data then
		self:_setup_from_tweak_data()
	end

	if self._setup_server_data and Network:is_server() then
		self:_setup_server_data()
	end

	self._variant = "projectile"
end

-- Lines 35-48
function ProjectileBase:set_thrower_unit_by_peer_id(peer_id)
	if not peer_id then
		return
	end

	if managers.network:session() then
		local peer = managers.network:session():peer(peer_id)
		local thrower_unit = peer and peer:unit()

		if alive(thrower_unit) then
			self:set_thrower_unit(thrower_unit, true, false)
		end
	end
end

-- Lines 51-170
function ProjectileBase:set_thrower_unit(unit, proj_ignore_thrower, thrower_ignore_proj)
	if self._thrower_unit then
		if not unit or self._thrower_unit:key() ~= unit:key() then
			local has_destroy_listener = nil
			local listener_class = self._thrower_unit:base()

			if listener_class and listener_class.add_destroy_listener then
				has_destroy_listener = true
			else
				listener_class = self._thrower_unit:unit_data()

				if listener_class and listener_class.add_destroy_listener then
					has_destroy_listener = true
				end
			end

			if has_destroy_listener then
				listener_class:remove_destroy_listener(self._thrower_destroy_listener_key)
			end

			if self._ignore_units and table.contains(self._ignore_units, self._thrower_unit) then
				self:remove_ignore_unit(self._thrower_unit, true)

				local shield_unit = self._thrower_unit:inventory() and self._thrower_unit:inventory():shield_unit()

				if alive(shield_unit) and table.contains(self._ignore_units, shield_unit) then
					self:remove_ignore_unit(shield_unit)
				end
			end

			if self._thrower_ignore_proj then
				self._thrower_ignore_proj = nil

				self._thrower_unit:inventory():remove_ignore_unit(self._unit)
			end

			if not unit then
				return
			end
		else
			if proj_ignore_thrower then
				if not self._ignore_units or not table.contains(self._ignore_units, unit) then
					self._ignore_units = self._ignore_units or {}
					self._ignore_destroy_listener_key = self._ignore_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

					table.insert(self._ignore_units, unit)

					local shield_unit = unit:inventory() and unit:inventory():shield_unit()

					if alive(shield_unit) then
						self:add_ignore_unit(shield_unit)
					end
				end
			elseif self._ignore_units and table.contains(self._ignore_units, unit) then
				self:remove_ignore_unit(unit, true)

				local shield_unit = unit:inventory() and unit:inventory():shield_unit()

				if alive(shield_unit) and table.contains(self._ignore_units, shield_unit) then
					self:remove_ignore_unit(shield_unit)
				end
			end

			if thrower_ignore_proj then
				if not self._thrower_ignore_proj and unit:inventory() and unit:inventory().add_ignore_unit then
					self._thrower_ignore_proj = true

					unit:inventory():add_ignore_unit(self._unit)
				end
			elseif self._thrower_ignore_proj then
				self._thrower_ignore_proj = nil

				unit:inventory():remove_ignore_unit(self._unit)
			end
		end
	end

	local has_destroy_listener = nil
	local listener_class = unit:base()

	if listener_class and listener_class.add_destroy_listener then
		has_destroy_listener = true
	else
		listener_class = unit:unit_data()

		if listener_class and listener_class.add_destroy_listener then
			has_destroy_listener = true
		end
	end

	if not has_destroy_listener then
		print("[ProjectileBase:set_thrower_unit] Cannot set thrower unit as it lacks a destroy listener.", unit)

		return
	end

	self._thrower_destroy_listener_key = self._thrower_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

	listener_class:add_destroy_listener(self._thrower_destroy_listener_key, callback(self, self, "_clbk_thrower_unit_destroyed"))

	self._thrower_unit = unit

	if proj_ignore_thrower then
		self._ignore_units = self._ignore_units or {}
		self._ignore_destroy_listener_key = self._ignore_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

		table.insert(self._ignore_units, unit)

		local shield_unit = unit:inventory() and unit:inventory():shield_unit()

		if alive(shield_unit) then
			self:add_ignore_unit(shield_unit)
		end
	end

	if thrower_ignore_proj and unit:inventory() and unit:inventory().add_ignore_unit then
		self._thrower_ignore_proj = true

		unit:inventory():add_ignore_unit(self._unit)
	end
end

-- Lines 172-185
function ProjectileBase:_clbk_thrower_unit_destroyed(unit)
	self._thrower_unit = nil
	self._thrower_ignore_proj = nil

	if self._ignore_units and table.contains(self._ignore_units, unit) then
		self:remove_ignore_unit(unit, true)

		local shield_unit = unit:inventory() and unit:inventory():shield_unit()

		if alive(shield_unit) and table.contains(self._ignore_units, shield_unit) then
			self:remove_ignore_unit(shield_unit)
		end
	end
end

-- Lines 187-217
function ProjectileBase:add_ignore_unit(unit)
	local has_destroy_listener = nil
	local listener_class = unit:base()

	if listener_class and listener_class.add_destroy_listener then
		has_destroy_listener = true
	else
		listener_class = unit:unit_data()

		if listener_class and listener_class.add_destroy_listener then
			has_destroy_listener = true
		end
	end

	if has_destroy_listener then
		self._ignore_units = self._ignore_units or {}
		self._ignore_destroy_listener_key = self._ignore_destroy_listener_key or "ProjectileBase" .. tostring(self._unit:key())

		listener_class:add_destroy_listener(self._ignore_destroy_listener_key, callback(self, self, "_clbk_ignore_unit_destroyed"))
		table.insert(self._ignore_units, unit)
	else
		print("[ProjectileBase:add_ignore_unit] Cannot set unit for ignoring as it lacks a destroy listener.", unit)
	end
end

-- Lines 219-221
function ProjectileBase:_clbk_ignore_unit_destroyed(unit)
	self:remove_ignore_unit(unit, true)
end

-- Lines 223-252
function ProjectileBase:remove_ignore_unit(unit, no_listener_chk)
	if not self._ignore_units then
		return
	end

	table.delete(self._ignore_units, unit)

	if not next(self._ignore_units) then
		self._ignore_units = nil
	end

	if not no_listener_chk and alive(unit) then
		local has_destroy_listener = nil
		local listener_class = unit:base()

		if listener_class and listener_class.add_destroy_listener then
			has_destroy_listener = true
		else
			listener_class = unit:unit_data()

			if listener_class and listener_class.add_destroy_listener then
				has_destroy_listener = true
			end
		end

		if has_destroy_listener then
			listener_class:remove_destroy_listener(self._ignore_destroy_listener_key)
		end
	end
end

-- Lines 254-256
function ProjectileBase:thrower_unit()
	return alive(self._thrower_unit) and self._thrower_unit or nil
end

-- Lines 260-264
function ProjectileBase:set_weapon_unit(weapon_unit)
	self._weapon_unit = weapon_unit
	self._weapon_id = weapon_unit and weapon_unit:base():get_name_id()
	self._weapon_damage_mult = weapon_unit and weapon_unit:base().projectile_damage_multiplier and weapon_unit:base():projectile_damage_multiplier() or 1
end

-- Lines 266-268
function ProjectileBase:weapon_unit()
	return alive(self._weapon_unit) and self._weapon_unit or nil
end

-- Lines 272-274
function ProjectileBase:set_projectile_entry(projectile_entry)
	self._projectile_entry = projectile_entry
end

-- Lines 276-278
function ProjectileBase:projectile_entry()
	return self._projectile_entry or tweak_data.blackmarket:get_projectile_name_from_index(1)
end

-- Lines 280-282
function ProjectileBase:get_name_id()
	return alive(self._weapon_unit) and self._weapon_unit:base():get_name_id() or self._projectile_entry
end

-- Lines 284-291
function ProjectileBase:is_category(...)
	for _, cat in ipairs({
		...
	}) do
		if cat == "projectile" then
			return true
		end
	end

	return false
end

-- Lines 295-298
function ProjectileBase:set_active(active)
	self._active = active

	self._unit:set_extension_update_enabled(Idstring("base"), self._active)
end

-- Lines 300-302
function ProjectileBase:active()
	return self._active
end

-- Lines 307-315
function ProjectileBase:create_sweep_data()
	self._sweep_data = {
		slot_mask = self._slot_mask
	}
	self._sweep_data.slot_mask = managers.mutators:modify_value("ProjectileBase:create_sweep_data:slot_mask", self._sweep_data.slot_mask)
	self._sweep_data.current_pos = self._unit:position()
	self._sweep_data.last_pos = mvector3.copy(self._sweep_data.current_pos)
end

-- Lines 319-373
function ProjectileBase:throw(params)
	self._owner = params.owner
	local velocity = params.dir
	local adjust_z = 50
	local launch_speed = 250
	local push_at_body_index = nil

	if params.projectile_entry and tweak_data.projectiles[params.projectile_entry] then
		adjust_z = tweak_data.projectiles[params.projectile_entry].adjust_z or adjust_z
		launch_speed = tweak_data.projectiles[params.projectile_entry].launch_speed or launch_speed
		push_at_body_index = tweak_data.projectiles[params.projectile_entry].push_at_body_index
	end

	velocity = velocity * launch_speed
	velocity = Vector3(velocity.x, velocity.y, velocity.z + adjust_z)
	local mass_look_up_modifier = self._mass_look_up_modifier or 2
	local mass = math.max(mass_look_up_modifier * (1 + math.min(0, params.dir.z)), 1)

	if self._simulated then
		if push_at_body_index then
			self._unit:push_at(mass, velocity, self._unit:body(push_at_body_index):center_of_mass())
		else
			self._unit:push_at(mass, velocity, self._unit:position())
		end
	else
		self._velocity = velocity
	end

	if params.projectile_entry and tweak_data.blackmarket.projectiles[params.projectile_entry] then
		local tweak_entry = tweak_data.blackmarket.projectiles[params.projectile_entry]
		local physic_effect = tweak_entry.physic_effect

		if physic_effect then
			World:play_physic_effect(physic_effect, self._unit)
		end

		if tweak_entry.add_trail_effect then
			self:add_trail_effect(tweak_entry.add_trail_effect)
		end

		local unit_name = tweak_entry.sprint_unit

		if unit_name then
			local new_dir = Vector3(params.dir.y * -1, params.dir.x, params.dir.z)
			local sprint = World:spawn_unit(Idstring(unit_name), self._unit:position() + new_dir * 50, self._unit:rotation())
			local rot = Rotation(params.dir, math.UP)

			mrotation.x(rot, mvec1)
			mvector3.multiply(mvec1, 0.15)
			mvector3.add(mvec1, new_dir)
			mvector3.add(mvec1, math.UP / 2)
			mvector3.multiply(mvec1, 100)
			sprint:push_at(mass, mvec1, sprint:position())
		end

		self:set_projectile_entry(params.projectile_entry)
	end
end

-- Lines 377-379
function ProjectileBase:sync_throw_projectile(dir, projectile_type)
	self:throw({
		dir = dir,
		projectile_entry = projectile_type
	})
end

-- Lines 383-427
function ProjectileBase:update(unit, t, dt)
	if not self._simulated and not self._collided then
		self._unit:m_position(mvec1)
		mvector3.set(mvec2, self._velocity * dt)
		mvector3.add(mvec1, mvec2)
		self._unit:set_position(mvec1)

		if self._orient_to_vel then
			mrotation.set_look_at(mrot1, mvec2, math.UP)
			self._unit:set_rotation(mrot1)
		end

		self._velocity = Vector3(self._velocity.x, self._velocity.y, self._velocity.z - 980 * dt)
	end

	if self._sweep_data and not self._collided then
		self._unit:m_position(self._sweep_data.current_pos)

		local ig_units = self._ignore_units
		local col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask, ig_units and "ignore_unit" or nil, ig_units or nil)

		if self._draw_debug_trail then
			Draw:brush(Color(1, 0, 0, 1), nil, 3):line(self._sweep_data.last_pos, self._sweep_data.current_pos)
		end

		if col_ray and col_ray.unit then
			mvector3.direction(mvec1, self._sweep_data.last_pos, self._sweep_data.current_pos)
			mvector3.add(mvec1, col_ray.position)
			self._unit:set_position(mvec1)
			self._unit:set_position(mvec1)

			if self._draw_debug_impact then
				Draw:brush(Color(0.5, 0, 0, 1), nil, 10):sphere(col_ray.position, 4)
				Draw:brush(Color(0.5, 1, 0, 0), nil, 10):sphere(self._unit:position(), 3)
			end

			col_ray.velocity = self._unit:velocity()
			self._collided = true

			self:_on_collision(col_ray)
		end

		self._unit:m_position(self._sweep_data.last_pos)
	end
end

-- Lines 432-461
function ProjectileBase:clbk_impact(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	if self._sweep_data and not self._collided then
		mvector3.set(mvec2, position)
		mvector3.subtract(mvec2, self._sweep_data.last_pos)
		mvector3.multiply(mvec2, 2)
		mvector3.add(mvec2, self._sweep_data.last_pos)

		local ig_units = self._ignore_units
		local col_ray = World:raycast("ray", self._sweep_data.last_pos, mvec2, "slot_mask", self._sweep_data.slot_mask, ig_units and "ignore_unit" or nil, ig_units or nil)

		if col_ray and col_ray.unit then
			if self._draw_debug_impact then
				Draw:brush(Color(0.5, 0, 0, 1), nil, 10):sphere(col_ray.position, 4)
				Draw:brush(Color(0.5, 1, 0, 0), nil, 10):sphere(self._unit:position(), 3)
			end

			mvector3.direction(mvec1, self._sweep_data.last_pos, col_ray.position)
			mvector3.add(mvec1, col_ray.position)
			self._unit:set_position(mvec1)
			self._unit:set_position(mvec1)

			col_ray.velocity = velocity
			self._collided = true

			self:_on_collision(col_ray)
		end
	end
end

-- Lines 465-467
function ProjectileBase:_on_collision(col_ray)
	print("_on_collision", inspect(col_ray))
end

-- Lines 471-473
function ProjectileBase:_bounce(...)
	print("_bounce", ...)
end

-- Lines 477-482
function ProjectileBase:save(data)
	local state = {
		timer = self._timer
	}
	data.ProjectileBase = state
end

-- Lines 486-489
function ProjectileBase:load(data)
	local state = data.ProjectileBase
	self._timer = state.timer
end

-- Lines 493-552
function ProjectileBase:destroy(...)
	ProjectileBase.super.destroy(self, ...)

	if alive(self._thrower_unit) then
		local has_destroy_listener = nil
		local listener_class = self._thrower_unit:base()

		if listener_class and listener_class.add_destroy_listener then
			has_destroy_listener = true
		else
			listener_class = self._thrower_unit:unit_data()

			if listener_class and listener_class.add_destroy_listener then
				has_destroy_listener = true
			end
		end

		if has_destroy_listener then
			listener_class:remove_destroy_listener(self._thrower_destroy_listener_key)
		end

		if self._ignore_units and table.contains(self._ignore_units, self._thrower_unit) then
			table.delete(self._ignore_units, self._thrower_unit)
		end
	end

	self._thrower_unit = nil
	self._thrower_ignore_proj = nil
	self._thrower_destroy_listener_key = nil

	if self._ignore_units then
		local destroy_key = self._ignore_destroy_listener_key

		for _, ig_unit in pairs(self._ignore_units) do
			if alive(ig_unit) then
				local has_destroy_listener = nil
				local listener_class = ig_unit:base()

				if listener_class and listener_class.add_destroy_listener then
					has_destroy_listener = true
				else
					listener_class = ig_unit:unit_data()

					if listener_class and listener_class.add_destroy_listener then
						has_destroy_listener = true
					end
				end

				if has_destroy_listener then
					listener_class:remove_destroy_listener(destroy_key)
				end
			end
		end
	end

	self._ignore_units = nil
	self._ignore_destroy_listener_key = nil

	self:remove_trail_effect()
end

-- Lines 558-592
function ProjectileBase.throw_projectile(projectile_type, pos, dir, owner_peer_id)
	if not ProjectileBase.check_time_cheat(projectile_type, owner_peer_id) then
		return
	end

	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local unit = World:spawn_unit(unit_name, pos, Rotation(dir, math.UP))

	if owner_peer_id and managers.network:session() then
		local peer = managers.network:session():peer(owner_peer_id)
		local thrower_unit = peer and peer:unit()

		if alive(thrower_unit) then
			unit:base():set_thrower_unit(thrower_unit, true, false)

			if not tweak_entry.throwable and thrower_unit:movement() and thrower_unit:movement():current_state() then
				unit:base():set_weapon_unit(thrower_unit:movement():current_state()._equipped_unit)
			end
		end
	end

	unit:base():throw({
		dir = dir,
		projectile_entry = projectile_type
	})

	if unit:base().set_owner_peer_id then
		unit:base():set_owner_peer_id(owner_peer_id)
	end

	local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

	managers.network:session():send_to_peers_synched("sync_throw_projectile", unit:id() ~= -1 and unit or nil, pos, dir, projectile_type_index, owner_peer_id or 0)

	if tweak_data.blackmarket.projectiles[projectile_type].impact_detonation then
		unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
		unit:base():create_sweep_data()
	end

	return unit
end

-- Lines 596-619
function ProjectileBase.throw_projectile_npc(projectile_type, pos, dir, thrower_unit)
	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local unit = World:spawn_unit(unit_name, pos, Rotation(dir, math.UP))
	local sync_thrower_unit = nil

	if alive(thrower_unit) then
		unit:base():set_thrower_unit(thrower_unit, true, true)

		sync_thrower_unit = thrower_unit:id() ~= -1 and thrower_unit
	end

	unit:base():throw({
		dir = dir,
		projectile_entry = projectile_type
	})

	local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

	managers.network:session():send_to_peers_synched("sync_throw_projectile_npc", unit:id() ~= -1 and unit or nil, pos, dir, projectile_type_index, sync_thrower_unit or nil)

	if tweak_data.blackmarket.projectiles[projectile_type].impact_detonation then
		unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
		unit:base():create_sweep_data()
	end

	return unit
end

-- Lines 623-626
function ProjectileBase:add_trail_effect()
	managers.game_play_central:add_projectile_trail(self._unit, self._unit:orientation_object(), self.trail_effect)

	self._added_trail_effect = true
end

-- Lines 628-633
function ProjectileBase:remove_trail_effect()
	if self._added_trail_effect then
		managers.game_play_central:remove_projectile_trail(self._unit)

		self._added_trail_effect = nil
	end
end

-- Lines 637-654
function ProjectileBase.check_time_cheat(projectile_type, owner_peer_id)
	if not owner_peer_id then
		return true
	end

	local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

	if tweak_data.blackmarket.projectiles[projectile_type].time_cheat then
		ProjectileBase.time_cheat[projectile_type_index] = ProjectileBase.time_cheat[projectile_type_index] or {}

		if ProjectileBase.time_cheat[projectile_type_index][owner_peer_id] and Application:time() < ProjectileBase.time_cheat[projectile_type_index][owner_peer_id] then
			return false
		end

		ProjectileBase.time_cheat[projectile_type_index][owner_peer_id] = Application:time() + tweak_data.blackmarket.projectiles[projectile_type].time_cheat
	end

	return true
end

-- Lines 658-669
function ProjectileBase.spawn(unit_name, pos, rot)
	local unit = World:spawn_unit(Idstring(unit_name), pos, rot)

	return unit
end

-- Lines 673-674
function ProjectileBase._dispose_of_sound(...)
end

-- Lines 676-692
function ProjectileBase:_detect_and_give_dmg(hit_pos)
	local params = {
		hit_pos = hit_pos,
		collision_slotmask = self._collision_slotmask,
		user = self._user,
		damage = self._damage,
		player_damage = self._player_damage or self._damage,
		range = self._range,
		ignore_unit = self._ignore_unit,
		curve_pow = self._curve_pow,
		col_ray = self._col_ray,
		alert_filter = self._alert_filter,
		owner = self._owner
	}
	local hit_units, splinters = managers.explosion:detect_and_give_dmg(params)

	return hit_units, splinters
end

-- Lines 695-698
function ProjectileBase._explode_on_client(position, normal, user_unit, dmg, range, curve_pow, custom_params)
	managers.explosion:play_sound_and_effects(position, normal, range, custom_params)
	managers.explosion:client_damage_and_push(position, normal, user_unit, dmg, range, curve_pow)
end

-- Lines 700-702
function ProjectileBase._play_sound_and_effects(position, normal, range, custom_params)
	managers.explosion:play_sound_and_effects(position, normal, range, custom_params)
end
