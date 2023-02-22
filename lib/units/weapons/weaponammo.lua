WeaponAmmo = WeaponAmmo or class()

-- Lines 4-11
function WeaponAmmo:init(weapon_id, ammo_max_per_clip, ammo_max)
	self._name_id = weapon_id
	self._digest_values = SystemInfo:platform() == Idstring("WIN32")

	self:set_ammo_max_per_clip(ammo_max_per_clip)
	self:set_ammo_max(ammo_max)
	self:replenish()
end

-- Lines 13-15
function WeaponAmmo:weapon_tweak_data()
	return tweak_data.weapon[self._name_id]
end

-- Lines 17-23
function WeaponAmmo:digest_value(value, digest)
	if self._digest_values then
		return Application:digest_value(value, digest)
	else
		return value
	end
end

-- Lines 27-48
function WeaponAmmo:replenish()
	local ammo_max_multiplier = managers.player:upgrade_value("player", "extra_ammo_multiplier", 1)

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value(category, "extra_ammo_multiplier", 1)
	end

	ammo_max_multiplier = managers.modifiers:modify_value("WeaponBase:GetMaxAmmoMultiplier", ammo_max_multiplier)
	local ammo_max_per_clip = self:calculate_ammo_max_per_clip()
	local ammo_max = math.round((self:weapon_tweak_data().AMMO_MAX + managers.player:upgrade_value(self._name_id, "clip_amount_increase") * ammo_max_per_clip) * ammo_max_multiplier)
	ammo_max_per_clip = math.min(ammo_max_per_clip, ammo_max)

	self:set_ammo_max(ammo_max)
	self:set_ammo_max_per_clip(ammo_max_per_clip)
	self:set_ammo_total(ammo_max)
	self:set_ammo_remaining_in_clip(ammo_max_per_clip)

	self._ammo_pickup = self:weapon_tweak_data().AMMO_PICKUP
end

-- Lines 50-62
function WeaponAmmo:calculate_ammo_max_per_clip()
	local ammo = self:weapon_tweak_data().CLIP_AMMO_MAX
	ammo = ammo + managers.player:upgrade_value(self._name_id, "clip_ammo_increase")

	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = ammo + managers.player:upgrade_value("weapon", "clip_ammo_increase", 0)
	end

	for _, category in ipairs(tweak_data.weapon[self._name_id].categories) do
		if not self:upgrade_blocked(category, "clip_ammo_increase") then
			ammo = ammo + managers.player:upgrade_value(category, "clip_ammo_increase", 0)
		end
	end

	return ammo
end

-- Lines 64-72
function WeaponAmmo:upgrade_blocked(category, upgrade)
	if not self:weapon_tweak_data().upgrade_blocks then
		return false
	end

	if not self:weapon_tweak_data().upgrade_blocks[category] then
		return false
	end

	return table.contains(self:weapon_tweak_data().upgrade_blocks[category], upgrade)
end

-- Lines 76-87
function WeaponAmmo:set_ammo_max_per_clip(ammo_max_per_clip)
	if self._ammo_max_per_clip then
		if self._ammo_max_per_clip2 then
			print("haxor")
		end

		self._ammo_max_per_clip2 = self:digest_value(ammo_max_per_clip, true)
		self._ammo_max_per_clip = nil
	else
		self._ammo_max_per_clip = self:digest_value(ammo_max_per_clip, true)
		self._ammo_max_per_clip2 = nil
	end
end

-- Lines 89-91
function WeaponAmmo:get_ammo_max_per_clip()
	return self._ammo_max_per_clip and self:digest_value(self._ammo_max_per_clip, false) or self:digest_value(self._ammo_max_per_clip2, false)
end

-- Lines 93-104
function WeaponAmmo:set_ammo_max(ammo_max)
	if self._ammo_max then
		if self._ammo_max2 then
			print("haxor")
		end

		self._ammo_max2 = self:digest_value(ammo_max, true)
		self._ammo_max = nil
	else
		self._ammo_max = self:digest_value(ammo_max, true)
		self._ammo_max2 = nil
	end
end

-- Lines 106-108
function WeaponAmmo:get_ammo_max()
	return self._ammo_max and self:digest_value(self._ammo_max, false) or self:digest_value(self._ammo_max2, false)
end

-- Lines 110-116
function WeaponAmmo:set_ammo_total(ammo_total)
	self._ammo_total = self:digest_value(ammo_total, true)

	if self:get_stored_pickup_ammo() and self:get_ammo_max() <= ammo_total then
		self:remove_pickup_ammo()
	end
end

-- Lines 119-130
function WeaponAmmo:add_ammo_to_pool(ammo, index)
	local max_ammo = self:get_ammo_max()
	local current_ammo = self:get_ammo_total()
	local new_ammo = current_ammo + ammo

	if max_ammo < new_ammo then
		new_ammo = max_ammo
	end

	self:set_ammo_total(new_ammo)
	managers.hud:set_ammo_amount(index, self:ammo_info())
end

-- Lines 132-134
function WeaponAmmo:get_ammo_total()
	return self._ammo_total and self:digest_value(self._ammo_total, false) or self:digest_value(self._ammo_total2, false)
end

-- Lines 136-140
function WeaponAmmo:get_ammo_ratio()
	local ammo_max = self:get_ammo_max()
	local ammo_total = self:get_ammo_total()

	return ammo_total / math.max(ammo_max, 1)
end

-- Lines 143-151
function WeaponAmmo:get_ammo_ratio_excluding_clip()
	local ammo_in_clip = self:get_ammo_max_per_clip()
	local max_ammo = self:get_ammo_max() - ammo_in_clip
	local current_ammo = self:get_ammo_total() - ammo_in_clip

	if current_ammo == 0 then
		return 0
	end

	return current_ammo / max_ammo
end

-- Lines 153-157
function WeaponAmmo:get_max_ammo_excluding_clip()
	local ammo_in_clip = self:get_ammo_max_per_clip()
	local max_ammo = self:get_ammo_max() - ammo_in_clip

	return max_ammo
end

-- Lines 159-167
function WeaponAmmo:remove_ammo_from_pool(percent)
	local ammo_in_clip = self:get_ammo_max_per_clip()
	local current_ammo = self:get_ammo_total() - ammo_in_clip

	if current_ammo > 0 then
		current_ammo = current_ammo * percent
		current_ammo = math.floor(current_ammo)

		self:set_ammo_total(ammo_in_clip + current_ammo)
	end
end

-- Lines 169-179
function WeaponAmmo:remove_ammo(percent)
	local total_ammo = self:get_ammo_total()
	local ammo = math.floor(total_ammo * percent)

	self:set_ammo_total(ammo)

	local ammo_in_clip = self:get_ammo_remaining_in_clip()

	if self:get_ammo_total() < ammo_in_clip then
		self:set_ammo_remaining_in_clip(ammo)
	end

	return total_ammo - ammo
end

-- Lines 181-192
function WeaponAmmo:set_ammo_remaining_in_clip(ammo_remaining_in_clip)
	if self._ammo_remaining_in_clip then
		if self._ammo_remaining_in_clip2 then
			print("haxor")
		end

		self._ammo_remaining_in_clip2 = self:digest_value(ammo_remaining_in_clip, true)
		self._ammo_remaining_in_clip = nil
	else
		self._ammo_remaining_in_clip = self:digest_value(ammo_remaining_in_clip, true)
		self._ammo_remaining_in_clip2 = nil
	end
end

-- Lines 194-196
function WeaponAmmo:get_ammo_remaining_in_clip()
	return self._ammo_remaining_in_clip and self:digest_value(self._ammo_remaining_in_clip, false) or self:digest_value(self._ammo_remaining_in_clip2, false)
end

-- Lines 200-202
function WeaponAmmo:get_stored_pickup_ammo()
	return self._stored_pickup_ammo and self:digest_value(self._stored_pickup_ammo, false)
end

-- Lines 204-206
function WeaponAmmo:store_pickup_ammo(ammo_to_store)
	self._stored_pickup_ammo = self:digest_value(ammo_to_store, true)
end

-- Lines 208-210
function WeaponAmmo:remove_pickup_ammo()
	self._stored_pickup_ammo = nil
end
