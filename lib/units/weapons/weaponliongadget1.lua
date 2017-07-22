WeaponLionGadget1 = WeaponLionGadget1 or class()
WeaponLionGadget1.GADGET_TYPE = "bipod"
WeaponLionGadget1._previous_state = nil
WeaponLionGadget1.bipod_length = nil

-- Lines: 7 to 28
function WeaponLionGadget1:init(unit)
	self._unit = unit
	self._is_npc = false


	-- Lines: 21 to 23
	local function on_cash_inspect_weapon()
		self:get_offsets()
	end

	managers.player:register_message(Message.OnCashInspectWeapon, self, on_cash_inspect_weapon)

	self._deployed = false
end

-- Lines: 34 to 35
function WeaponLionGadget1:update(unit, t, dt)
end

-- Lines: 40 to 42
function WeaponLionGadget1:set_npc()
	self._is_npc = true
end

-- Lines: 47 to 48
function WeaponLionGadget1:is_bipod()
	return true
end

-- Lines: 54 to 55
function WeaponLionGadget1:bipod_state()
	return self._on
end

-- Lines: 61 to 62
function WeaponLionGadget1:is_deployed()
	return self._deployed
end

-- Lines: 67 to 77
function WeaponLionGadget1:toggle()
	Application:trace("WeaponLionGadget1:toggle() is_deployed: ", self:is_deployed())

	if self:is_deployed() then
		self:_unmount()
	else
		self:check_state()
	end
end

-- Lines: 82 to 91
function WeaponLionGadget1:is_usable()
	if not self._center_ray_from or not self._center_ray_to then
		return nil
	end

	local ray_bipod_center = self._unit:raycast(self._center_ray_from, self._center_ray_to)
	local ray_bipod_left = self._unit:raycast(self._left_ray_from, self._left_ray_to)
	local ray_bipod_right = self._unit:raycast(self._right_ray_from, self._right_ray_to)

	return ray_bipod_center and (ray_bipod_left or ray_bipod_right)
end

-- Lines: 96 to 100
function WeaponLionGadget1:_unmount()
	managers.player:set_player_state(self._previous_state or "standard")

	self._previous_state = nil
	self._deployed = false
end

-- Lines: 105 to 116
function WeaponLionGadget1:_get_bipod_obj()
	if not self._bipod_obj and self._unit:parent() then
		print("No Bipod object. Trying to recover.")

		self._bipod_obj = self._unit:parent():get_object(Idstring("a_bp"))

		if not self._bipod_obj then
			print("Fail.")

			return false
		end

		print("Success.")
	end

	return self._bipod_obj
end

-- Lines: 121 to 125
function WeaponLionGadget1:_get_bipod_alignment_obj()
	if not self._bipod_align_obj and self._unit:parent() and self._unit:parent():parent() then
		self._bipod_align_obj = self._unit:parent():parent()
	end

	return self._bipod_align_obj
end

-- Lines: 132 to 142
function WeaponLionGadget1:_is_in_blocked_deployable_state()
	local is_reloading = false

	if managers.player:current_state() == "standard" and managers.player:player_unit():movement()._current_state then
		is_reloading = managers.player:player_unit():movement()._current_state:_is_reloading()
	end

	return not managers.player:player_unit():mover():standing() or managers.player:current_state() ~= "standard" and managers.player:current_state() ~= "carry" and managers.player:current_state() ~= "bipod" or managers.player:player_unit():inventory():equipped_unit():base():selection_index() ~= 2 or is_reloading
end

-- Lines: 148 to 186
function WeaponLionGadget1:_is_deployable()
	if self._is_npc or not self:_get_bipod_obj() then
		return false
	end

	if self:_is_in_blocked_deployable_state() then
		return false
	end

	local bipod_rays = self:_shoot_bipod_rays()

	if not bipod_rays then
		return false
	end

	local bipod_min_length = 5

	if bipod_rays.forward then
		return false
	end

	if bipod_rays.left and bipod_rays.left.distance < bipod_min_length then
		return false
	end

	if bipod_rays.right and bipod_rays.right.distance < bipod_min_length then
		return false
	end

	if (bipod_rays.left or bipod_rays.right) and bipod_rays.center or bipod_rays.center then
		return true
	end

	return false
end

-- Lines: 192 to 204
function WeaponLionGadget1:get_offsets()
	if not self:_get_bipod_obj() or not self:_get_bipod_alignment_obj() then
		return false
	end

	self._bipod_offsets = self._bipod_offsets or {}
	local dir = Vector3()
	self._bipod_offsets.distance = mvector3.direction(dir, self._bipod_obj:position(), self:_get_bipod_alignment_obj():position())

	mvector3.rotate_with(dir, self:_get_bipod_alignment_obj():rotation():inverse())

	self._bipod_offsets.direction = dir
end

-- Lines: 208 to 318
function WeaponLionGadget1:_shoot_bipod_rays(debug_draw)
	local mvec1 = Vector3()
	local mvec2 = Vector3()
	local mvec3 = Vector3()
	local mvec_look_dir = Vector3()
	local mvec_gun_down_dir = Vector3()
	local from = mvec1
	local to = mvec2
	local from_offset = mvec3
	local bipod_max_length = WeaponLionGadget1.bipod_length or 90

	if not self._bipod_obj then
		return nil
	end

	if not self._bipod_offsets then
		self:get_offsets()
	end

	mrotation.y(self:_get_bipod_alignment_obj():rotation(), mvec_look_dir)
	mrotation.x(self:_get_bipod_alignment_obj():rotation(), mvec_gun_down_dir)

	local bipod_position = Vector3()

	mvector3.set(bipod_position, self._bipod_offsets.direction)
	mvector3.rotate_with(bipod_position, self:_get_bipod_alignment_obj():rotation())
	mvector3.multiply(bipod_position, (self._bipod_offsets.distance or bipod_max_length) * -1)
	mvector3.add(bipod_position, self:_get_bipod_alignment_obj():position())

	if debug_draw then
		Application:draw_line(bipod_position, bipod_position + Vector3(10, 0, 0), unpack({
			1,
			0,
			0
		}))
		Application:draw_line(bipod_position, bipod_position + Vector3(0, 10, 0), unpack({
			0,
			1,
			0
		}))
		Application:draw_line(bipod_position, bipod_position + Vector3(0, 0, 10), unpack({
			0,
			0,
			1
		}))
	end

	if mvec_look_dir:to_polar().pitch > 60 then
		return nil
	end

	mvector3.set(from, bipod_position)
	mvector3.set(to, mvec_gun_down_dir)
	mvector3.multiply(to, bipod_max_length)
	mvector3.rotate_with(to, Rotation(mvec_look_dir, 120))
	mvector3.add(to, from)

	local ray_bipod_left = self._unit:raycast(from, to)

	if not debug_draw then
		self._left_ray_from = Vector3(from.x, from.y, from.z)
		self._left_ray_to = Vector3(to.x, to.y, to.z)
	else
		local color = ray_bipod_left and {
			0,
			1,
			0
		} or {
			1,
			0,
			0
		}

		Application:draw_line(from, to, unpack(color))
	end

	mvector3.set(to, mvec_gun_down_dir)
	mvector3.multiply(to, bipod_max_length)
	mvector3.rotate_with(to, Rotation(mvec_look_dir, 60))
	mvector3.add(to, from)

	local ray_bipod_right = self._unit:raycast(from, to)

	if not debug_draw then
		self._right_ray_from = Vector3(from.x, from.y, from.z)
		self._right_ray_to = Vector3(to.x, to.y, to.z)
	else
		local color = ray_bipod_right and {
			0,
			1,
			0
		} or {
			1,
			0,
			0
		}

		Application:draw_line(from, to, unpack(color))
	end

	mvector3.set(to, mvec_gun_down_dir)
	mvector3.multiply(to, bipod_max_length * math.cos(30))
	mvector3.rotate_with(to, Rotation(mvec_look_dir, 90))
	mvector3.add(to, from)

	local ray_bipod_center = self._unit:raycast(from, to)

	if not debug_draw then
		self._center_ray_from = Vector3(from.x, from.y, from.z)
		self._center_ray_to = Vector3(to.x, to.y, to.z)
	else
		local color = ray_bipod_center and {
			0,
			1,
			0
		} or {
			1,
			0,
			0
		}

		Application:draw_line(from, to, unpack(color))
	end

	mvector3.set(from_offset, Vector3(0, -100, 0))
	mvector3.rotate_with(from_offset, self:_get_bipod_alignment_obj():rotation())
	mvector3.add(from, from_offset)
	mvector3.set(to, mvec_look_dir)
	mvector3.multiply(to, 500)
	mvector3.add(to, from)

	local ray_bipod_forward = self._unit:raycast(from, to)

	if debug_draw then
		local color = ray_bipod_forward and {
			1,
			0,
			0
		} or {
			0,
			1,
			0
		}

		Application:draw_line(from, to, unpack(color))
	end

	return {
		left = ray_bipod_left,
		right = ray_bipod_right,
		center = ray_bipod_center,
		forward = ray_bipod_forward
	}
end

-- Lines: 325 to 350
function WeaponLionGadget1:check_state()
	if self._is_npc then
		return false
	end

	local bipod_deployable = self:_is_deployable()

	if not bipod_deployable and not self:is_deployed() then
		managers.hud:show_hint({
			time = 2,
			text = managers.localization:text("hud_hint_bipod_nomount")
		})
	end

	self._deployed = false

	if not self._is_npc then
		if managers.player:current_state() ~= "bipod" and bipod_deployable then
			self._previous_state = managers.player:current_state()

			managers.player:set_player_state("bipod")

			self._deployed = true
		elseif managers.player:current_state() == "bipod" then
			self:_unmount()
		end
	end

	self._unit:set_extension_update_enabled(Idstring("base"), self._deployed)
end

-- Lines: 355 to 357
function WeaponLionGadget1:destroy(unit)
	managers.player:unregister_message(Message.OnCashInspectWeapon, self)
end

return
