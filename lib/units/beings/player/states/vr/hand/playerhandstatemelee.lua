require("lib/units/beings/player/states/vr/hand/PlayerHandState")

PlayerHandStateMelee = PlayerHandStateMelee or class(PlayerHandState)

-- Lines: 5 to 7
function PlayerHandStateMelee:init(hsm, name, hand_unit, sequence)
	PlayerHandStateWeapon.super.init(self, name, hsm, hand_unit, sequence)
end

-- Lines: 9 to 59
function PlayerHandStateMelee:_spawn_melee_unit()
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	self._melee_entry = melee_entry
	local unit_name = tweak_data.blackmarket.melee_weapons[melee_entry].third_unit

	if unit_name then
		local aligns = tweak_data.blackmarket.melee_weapons[melee_entry].align_objects or {"a_weapon_left"}
		local graphic_objects = tweak_data.blackmarket.melee_weapons[melee_entry].graphic_objects or {}
		local align = nil

		if #aligns > 1 then
			align = self._hsm:hand_id() == 1 and "a_weapon_left" or "a_weapon_right"

			if not table.contains(aligns, align) then
				Application:error("[PlayerHandStateMelee:_spawn_melee_unit] can't spawn melee weapon in this hand", melee_entry, self._hand_unit)

				return
			end
		else
			align = aligns[1]
		end

		local align_obj = self._hand_unit:get_object(Idstring("g_glove"))
		self._melee_unit = World:spawn_unit(Idstring(unit_name), align_obj:position(), align_obj:rotation())

		self._hand_unit:link(align_obj:name(), self._melee_unit, self._melee_unit:orientation_object():name())

		local offset = tweak_data.vr:get_offset_by_id(melee_entry)

		if offset then
			self._melee_unit:set_local_position(offset.position or Vector3())
			self._melee_unit:set_local_rotation(offset.rotation or Rotation())

			local sequence = self._sequence

			if offset.grip then
				sequence = offset.grip
			end

			if self._hand_unit and sequence and self._hand_unit:damage():has_sequence(sequence) then
				self._hand_unit:damage():run_sequence_simple(sequence)
			end
		end

		local align_obj_name = Idstring(align)

		for a_object, g_object in pairs(graphic_objects) do
			self._melee_unit:get_object(Idstring(g_object)):set_visibility(Idstring(a_object) == align_obj_name)
		end

		if alive(self._melee_unit) and self._melee_unit:damage() and self._melee_unit:damage():has_sequence("game") then
			self._melee_unit:damage():run_sequence_simple("game")
		end
	end
end

-- Lines: 61 to 77
function PlayerHandStateMelee:at_enter(prev_state, params)
	PlayerHandStateWeapon.super.at_enter(self, prev_state)
	managers.player:player_unit():movement():current_state():_interupt_action_reload()
	self:_spawn_melee_unit()
	self._hand_unit:melee():set_melee_unit(self._melee_unit)

	if self._melee_entry == "fists" or self._melee_entry == "fight" then
		self._hand_unit:melee():set_fist(self._melee_entry)
		self._hand_unit:damage():run_sequence_simple("grip")
	end

	self:hsm():enter_controller_state("item")
	managers.hud:belt():set_state("melee", "active")
end

-- Lines: 79 to 90
function PlayerHandStateMelee:at_exit(next_state)
	PlayerHandStateMelee.super.at_exit(self, next_state)
	self:hsm():exit_controller_state("item")
	self._hand_unit:melee():set_melee_unit()

	if alive(self._melee_unit) then
		self._melee_unit:unlink()
		World:delete_unit(self._melee_unit)
	end
end

-- Lines: 92 to 115
function PlayerHandStateMelee:update(t, dt)
	local controller = managers.vr:hand_state_machine():controller()

	if controller:get_input_pressed("unequip") then
		managers.hud:belt():set_state("melee", "default")
		self:hsm():change_to_default()
	end

	if controller:get_input_pressed("use_item_vr") then
		self._hand_unit:melee():set_charge_start_t(t)
	elseif controller:get_input_released("use_item_vr") then
		self._hand_unit:melee():set_charge_start_t(nil)
	elseif controller:get_input_bool("use_item_vr") and not self._hand_unit:melee():charge_start_t() then
		self._hand_unit:melee():set_charge_start_t(t)
	end

	if self._hand_unit:melee():charge_start_t() then
		local charge_value = managers.player:player_unit():movement():current_state():_get_melee_charge_lerp_value(t)

		managers.controller:get_vr_controller():trigger_haptic_pulse(self:hsm():hand_id() - 1, 0, charge_value * 1000 + 500)
	end
end

