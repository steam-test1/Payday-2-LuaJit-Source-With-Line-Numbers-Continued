CivilianDamage = CivilianDamage or class(CopDamage)

-- Lines: 3 to 7
function CivilianDamage:init(unit)
	CivilianDamage.super.init(self, unit)

	self._pickup = nil
end

-- Lines: 11 to 37
function CivilianDamage:die(variant)
	self._unit:base():set_slot(self._unit, 17)
	self:drop_pickup()

	if self._unit:unit_data().mission_element then
		self._unit:unit_data().mission_element:event("death", self._unit)

		if not self._unit:unit_data().alerted_event_called then
			self._unit:unit_data().alerted_event_called = true

			self._unit:unit_data().mission_element:event("alerted", self._unit)
		end
	end

	managers.crime_spree:run_func("OnCivilianKilled", self._unit)

	if alive(managers.interaction:active_unit()) then
		managers.interaction:active_unit():interaction():selected()
	end

	variant = variant or "bullet"
	self._health = 0
	self._health_ratio = 0
	self._dead = true

	self:set_mover_collision_state(false)
end

-- Lines: 41 to 60
function CivilianDamage:_on_damage_received(damage_info)
	self:_call_listeners(damage_info)

	if damage_info.result.type == "death" then
		self:_unregister_from_enemy_manager(damage_info)

		if Network:is_client() then
			self._unit:interaction():set_active(false, false)
		end
	end

	local attacker_unit = damage_info and damage_info.attacker_unit

	if alive(attacker_unit) and attacker_unit:base() then
		if attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
		elseif attacker_unit:base().sentry_gun then
			attacker_unit = attacker_unit:base():get_owner()
		end
	end

	if attacker_unit == managers.player:player_unit() and damage_info then
		managers.player:on_damage_dealt(self._unit, damage_info)
	end
end

-- Lines: 64 to 66
function CivilianDamage:print(...)
	cat_print("civ_damage", ...)
end

-- Lines: 70 to 72
function CivilianDamage:_unregister_from_enemy_manager(damage_info)
	managers.enemy:on_civilian_died(self._unit, damage_info)
end

-- Lines: 74 to 78
function CivilianDamage:no_intimidation_by_dmg()
	if self._unit and self._unit:anim_data() then
		return self._unit:anim_data().no_intimidation_by_dmg
	end

	return true
end

-- Lines: 83 to 95
function CivilianDamage:damage_bullet(attack_data)
	if managers.player:has_category_upgrade("player", "civ_harmless_bullets") and self.no_intimidation_by_dmg and not self:no_intimidation_by_dmg() and (not self._survive_shot_t or self._survive_shot_t < TimerManager:game():time()) then
		self._survive_shot_t = TimerManager:game():time() + 2.5

		self._unit:brain():on_intimidated(1, attack_data.attacker_unit)

		return
	end

	attack_data.damage = 10

	return CopDamage.damage_bullet(self, attack_data)
end

-- Lines: 100 to 104
function CivilianDamage:damage_explosion(attack_data)
	if attack_data.variant == "explosion" then
		attack_data.damage = 10
	end

	return CopDamage.damage_explosion(self, attack_data)
end

-- Lines: 110 to 114
function CivilianDamage:damage_fire(attack_data)
	if attack_data.variant == "fire" then
		attack_data.damage = 10
	end

	return CopDamage.damage_fire(self, attack_data)
end

-- Lines: 118 to 133
function CivilianDamage:stun_hit(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if not self._lie_down_clbk_id then
		self._lie_down_clbk_id = "lie_down_" .. tostring(self._unit:key())
		local rnd = math.random()
		local t = TimerManager:game():time()

		if not self._char_tweak.is_escort then
			managers.enemy:add_delayed_clbk(self._lie_down_clbk_id, callback(self, self, "_lie_down_clbk", attack_data.attacker_unit), t + rnd)
		end
	end
end

-- Lines: 135 to 139
function CivilianDamage:_lie_down_clbk(attacker_unit)
	local params = {force_lie_down = true}

	self._unit:brain():set_logic("surrender", params)

	self._lie_down_clbk_id = nil
end

-- Lines: 144 to 156
function CivilianDamage:damage_melee(attack_data)
	if managers.player:has_category_upgrade("player", "civ_harmless_melee") and self.no_intimidation_by_dmg and not self:no_intimidation_by_dmg() and (not self._survive_shot_t or self._survive_shot_t < TimerManager:game():time()) then
		self._survive_shot_t = TimerManager:game():time() + 2.5

		self._unit:brain():on_intimidated(1, attack_data.attacker_unit)

		return
	end

	attack_data.damage = 10

	return CopDamage.damage_melee(self, attack_data)
end

-- Lines: 161 to 173
function CivilianDamage:damage_tase(attack_data)
	if managers.player:has_category_upgrade("player", "civ_harmless_melee") and self.no_intimidation_by_dmg and not self:no_intimidation_by_dmg() and (not self._survive_shot_t or self._survive_shot_t < TimerManager:game():time()) then
		self._survive_shot_t = TimerManager:game():time() + 2.5

		self._unit:brain():on_intimidated(1, attack_data.attacker_unit)

		return
	end

	attack_data.damage = 10

	return CopDamage.damage_tase(self, attack_data)
end

