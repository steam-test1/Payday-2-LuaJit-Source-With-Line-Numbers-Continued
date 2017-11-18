require("lib/units/beings/player/states/vr/hand/PlayerHandState")

PlayerHandStateAkimbo = PlayerHandStateAkimbo or class(PlayerHandState)

-- Lines: 5 to 7
function PlayerHandStateAkimbo:init(hsm, name, hand_unit, sequence)
	PlayerHandStateAkimbo.super.init(self, name, hsm, hand_unit, sequence)
end

-- Lines: 9 to 21
function PlayerHandStateAkimbo:_link_weapon(weapon_unit)
	if not alive(self._weapon_unit) then
		self._weapon_unit = weapon_unit

		self._hand_unit:link(Idstring("g_glove"), weapon_unit, weapon_unit:orientation_object():name())
		self._weapon_unit:base():on_enabled()
		self._weapon_unit:set_visible(true)

		local tweak = tweak_data.vr.weapon_offsets.weapons[self._weapon_unit:base().name_id] or tweak_data.vr.weapon_offsets.default

		if tweak and tweak.position then
			self._weapon_unit:set_local_position(tweak.position)
		end
	end
end

-- Lines: 23 to 30
function PlayerHandStateAkimbo:_unlink_weapon()
	if alive(self._weapon_unit) then
		self._weapon_unit:set_visible(false)
		self._weapon_unit:base():on_disabled()
		self._weapon_unit:unlink()

		self._weapon_unit = nil
	end
end

-- Lines: 32 to 47
function PlayerHandStateAkimbo:at_enter(prev_state)
	PlayerHandStateAkimbo.super.at_enter(self, prev_state)

	local equipped_weapon = managers.player:player_unit():inventory():equipped_unit()

	if not equipped_weapon:base().akimbo then
		debug_pause("[PlayerHandStateAkimbo] Entered akimbo state without an akimbo equipped")
	end

	self:_link_weapon(equipped_weapon:base()._second_gun)
	self._hand_unit:melee():set_weapon_unit(self._weapon_unit)
	self:hsm():enter_controller_state("empty")
	self:hsm():enter_controller_state("akimbo")
end

-- Lines: 49 to 57
function PlayerHandStateAkimbo:at_exit(next_state)
	self:hsm():exit_controller_state("akimbo")
	self._hand_unit:melee():set_weapon_unit()
	self:_unlink_weapon()
	PlayerHandStateAkimbo.super.at_exit(self, next_state)
end

-- Lines: 59 to 61
function PlayerHandStateAkimbo:set_wanted_weapon_kick(amount)
	self._wanted_weapon_kick = math.min((self._wanted_weapon_kick or 0) + amount * tweak_data.vr.weapon_kick.kick_mul, tweak_data.vr.weapon_kick.max_kick)
end

-- Lines: 63 to 91
function PlayerHandStateAkimbo:update(t, dt)
	if self._weapon_kick then
		self._hand_unit:set_position(self:hsm():position() - self._hand_unit:rotation():y() * self._weapon_kick)
	end

	if self._wanted_weapon_kick then
		self._weapon_kick = self._weapon_kick or 0

		if self._weapon_kick < self._wanted_weapon_kick then
			self._weapon_kick = math.lerp(self._weapon_kick, self._wanted_weapon_kick, dt * tweak_data.vr.weapon_kick.kick_speed)
		else
			self._wanted_weapon_kick = 0
			self._weapon_kick = math.lerp(self._weapon_kick, self._wanted_weapon_kick, dt * tweak_data.vr.weapon_kick.return_speed)
		end
	end

	if managers.vr:hand_state_machine():controller():get_input_bool("warp_left") or managers.vr:hand_state_machine():controller():get_input_bool("warp_right") then
		if not self._warping then
			self._warping = true

			self:hsm():exit_controller_state("akimbo")
		end
	elseif self._warping then
		self._warping = false

		self:hsm():enter_controller_state("akimbo")
	end
end

