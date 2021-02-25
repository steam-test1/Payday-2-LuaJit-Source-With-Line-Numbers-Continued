HuskCopInventory = HuskCopInventory or class(HuskPlayerInventory)

-- Lines 3-5
function HuskCopInventory:init(unit)
	CopInventory.init(self, unit)
end

-- Lines 9-11
function HuskCopInventory:set_visibility_state(state)
	CopInventory.set_visibility_state(self, state)
end

-- Lines 15-34
function HuskCopInventory:add_unit_by_name(new_unit_name, equip)
	local new_unit = World:spawn_unit(new_unit_name, Vector3(), Rotation())

	managers.mutators:modify_value("CopInventory:add_unit_by_name", self)
	CopInventory._chk_spawn_shield(self, new_unit)

	local setup_data = {
		user_unit = self._unit,
		ignore_units = {
			self._unit,
			new_unit,
			self._shield_unit
		},
		expend_ammo = false,
		hit_slotmask = managers.slot:get_mask("bullet_impact_targets_no_AI"),
		hit_player = true,
		user_sound_variant = tweak_data.character[self._unit:base()._tweak_table].weapon_voice
	}

	new_unit:base():setup(setup_data)

	if new_unit:base().AKIMBO then
		new_unit:base():create_second_gun(new_unit_name)
	end

	CopInventory.add_unit(self, new_unit, equip)
end

-- Lines 38-40
function HuskCopInventory:get_weapon()
	CopInventory.get_weapon(self)
end

-- Lines 44-46
function HuskCopInventory:drop_weapon()
	CopInventory.drop_weapon(self)
end

-- Lines 50-52
function HuskCopInventory:drop_shield()
	CopInventory.drop_shield(self)
end

-- Lines 56-58
function HuskCopInventory:destroy_all_items()
	CopInventory.destroy_all_items(self)
end

-- Lines 62-64
function HuskCopInventory:add_unit(new_unit, equip)
	CopInventory.add_unit(self, new_unit, equip)
end

-- Lines 68-70
function HuskCopInventory:set_visibility_state(state)
	CopInventory.set_visibility_state(self, state)
end
