HuskTeamAIInventory = HuskTeamAIInventory or class(HuskCopInventory)
HuskTeamAIInventory.preload_mask = TeamAIInventory.preload_mask
HuskTeamAIInventory.clbk_mask_unit_loaded = TeamAIInventory.clbk_mask_unit_loaded
HuskTeamAIInventory._reset_mask_visibility = TeamAIInventory._reset_mask_visibility
HuskTeamAIInventory._ensure_weapon_visibility = TeamAIInventory._ensure_weapon_visibility
HuskTeamAIInventory.set_visibility_state = TeamAIInventory.set_visibility_state

-- Lines 11-30
function HuskTeamAIInventory:add_unit_by_name(new_unit_name, equip)
	local new_unit = World:spawn_unit(new_unit_name, Vector3(), Rotation())
	local ignore_units = {
		self._unit,
		new_unit
	}

	if self._ignore_units then
		for idx, ig_unit in pairs(self._ignore_units) do
			table.insert(ignore_units, ig_unit)
		end
	end

	local setup_data = {
		user_unit = self._unit,
		ignore_units = ignore_units,
		expend_ammo = false,
		hit_slotmask = managers.slot:get_mask("bullet_impact_targets_no_AI"),
		hit_player = false,
		user_sound_variant = tweak_data.character[self._unit:base()._tweak_table].weapon_voice
	}

	new_unit:base():setup(setup_data)
	CopInventory.add_unit(self, new_unit, equip)
end

-- Lines 32-35
function HuskTeamAIInventory:pre_destroy()
	HuskTeamAIInventory.super.pre_destroy(self)
	TeamAIInventory._unload_mask(self)
end

-- Lines 38-43
function HuskTeamAIInventory:add_unit(new_unit, equip)
	HuskTeamAIInventory.super.add_unit(self, new_unit, equip)
	self:_ensure_weapon_visibility(new_unit)
end

-- Lines 47-52
function HuskTeamAIInventory:equip_selection(selection_index, instant)
	local res = HuskTeamAIInventory.super.equip_selection(self, selection_index, instant)

	self:_ensure_weapon_visibility()

	return res
end
