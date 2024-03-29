HuskPlayerInventory = HuskPlayerInventory or class(PlayerInventory)
local ids_unit = Idstring("unit")

-- Lines 5-11
function HuskPlayerInventory:init(unit)
	HuskPlayerInventory.super.init(self, unit)

	self._align_places.right_hand = {
		on_body = true,
		obj3d_name = Idstring("a_weapon_right_front")
	}
	self._align_places.left_hand = {
		on_body = true,
		obj3d_name = Idstring("a_weapon_left_front")
	}
	self._peer_weapons = {}
	self._primary_hand = nil
end

-- Lines 15-16
function HuskPlayerInventory:_send_equipped_weapon()
end

-- Lines 20-25
function HuskPlayerInventory:synch_equipped_weapon(weap_index, blueprint_string, cosmetics_string, peer)
	self:_perform_switch_equipped_weapon(weap_index, blueprint_string, cosmetics_string, peer)

	if self._unit:movement().sync_equip_weapon then
		self._unit:movement():sync_equip_weapon()
	end
end

-- Lines 27-34
function HuskPlayerInventory:_perform_switch_equipped_weapon(weap_index, blueprint_string, cosmetics_string, peer)
	local weapon_name = self._get_weapon_name_from_sync_index(weap_index)

	if type(weapon_name) == "string" then
		self:add_unit_by_factory_name(weapon_name, true, true, blueprint_string, cosmetics_string or self:cosmetics_string_from_peer(peer, weapon_name))
	else
		self:add_unit_by_name(weapon_name, true, true)
	end
end

-- Lines 36-53
function HuskPlayerInventory:check_peer_weapon_spawn()
	if SystemInfo:platform() ~= Idstring("PS3") then
		return true
	end

	local next_in_line = self._peer_weapons[1]

	if next_in_line then
		if type(next_in_line) == "table" then
			print("[HuskPlayerInventory:check_peer_weapon_spawn()] Adding weapon to inventory.", inspect(next_in_line))
			self:add_unit_by_factory_blueprint(unpack(next_in_line))
		else
			print("[HuskPlayerInventory:check_peer_weapon_spawn()] waiting")
		end

		table.remove(self._peer_weapons, 1)
	else
		return true
	end
end

-- Lines 58-73
function HuskPlayerInventory:refresh_primary_hand()
	local hand = self._unit:movement():primary_hand()

	if hand ~= self._primary_hand then
		self._primary_hand = hand
		local selection = self._available_selections[self._equipped_selection]

		if selection and alive(selection.unit) then
			local align_place = hand == 0 and "right_hand" or "left_hand"
			local secondary = hand == 0 and "left_hand" or "right_hand"

			self:_link_weapon(selection.unit, self._align_places[align_place])

			if selection.unit:base().AKIMBO then
				selection.unit:base():link_secondary_weapon(self._align_places[secondary].obj3d_name)
			end

			selection.unit:base():apply_grip(true)
		end
	end
end

-- Lines 75-78
function HuskPlayerInventory:on_weapon_add()
	local ext = self._unit:movement()

	ext:on_weapon_add()
end

-- Lines 83-88
function HuskPlayerInventory:set_melee_weapon_by_peer(peer)
	local blackmarket_outfit = peer and peer:blackmarket_outfit()

	if blackmarket_outfit then
		self:set_melee_weapon(blackmarket_outfit.melee_weapon, true)
	end
end

-- Lines 92-114
function HuskPlayerInventory:add_unit_by_name(new_unit_name, equip, instant)
	managers.dyn_resource:load(ids_unit, new_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)

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
		autoaim = false,
		alert_AI = false,
		user_sound_variant = "1"
	}

	new_unit:base():setup(setup_data)
	self:add_unit(new_unit, equip, instant)
end

-- Lines 118-131
function HuskPlayerInventory:add_unit_by_factory_name(factory_name, equip, instant, blueprint_string, cosmetics_string)
	local factory_weapon = tweak_data.weapon.factory[factory_name]
	local ids_unit_name = Idstring(factory_weapon.unit)
	local blueprint = nil

	if blueprint_string and blueprint_string ~= "" then
		blueprint = managers.weapon_factory:unpack_blueprint_from_string(factory_name, blueprint_string)
	else
		blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_name)
	end

	local cosmetics = managers.blackmarket:cosmetics_from_outfit_string(cosmetics_string)

	self:add_unit_by_factory_blueprint(factory_name, equip, instant, blueprint, cosmetics)
end

-- Lines 135-170
function HuskPlayerInventory:add_unit_by_factory_blueprint(factory_name, equip, instant, blueprint, cosmetics)
	local factory_weapon = tweak_data.weapon.factory[factory_name]
	local ids_unit_name = Idstring(factory_weapon.unit)

	managers.dyn_resource:load(ids_unit, ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)

	local new_unit = World:spawn_unit(Idstring(factory_weapon.unit), Vector3(), Rotation())

	new_unit:base():set_factory_data(factory_name)
	new_unit:base():set_cosmetics_data(cosmetics)
	new_unit:base():assemble_from_blueprint(factory_name, blueprint)
	new_unit:base():check_npc()

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
		autoaim = false,
		alert_AI = false,
		user_sound_variant = "1"
	}

	new_unit:base():setup(setup_data)

	if new_unit:base().AKIMBO then
		local first, second = self:_align_place(equip, new_unit, "left_hand")

		new_unit:base():create_second_gun(nil, second and second.obj3d_name or first.obj3d_name)
	end

	self:add_unit(new_unit, equip, instant)
end

-- Lines 172-181
function HuskPlayerInventory:synch_weapon_gadget_state(state)
	if self:equipped_unit():base().set_gadget_on and self._unit:movement().set_cbt_permanent then
		self:equipped_unit():base():set_gadget_on(state, true)

		if state and state > 0 then
			self._unit:movement():set_cbt_permanent(true)
		else
			self._unit:movement():set_cbt_permanent(false)
		end
	end
end

-- Lines 184-188
function HuskPlayerInventory:sync_weapon_gadget_color(color)
	if self:equipped_unit():base().set_gadget_color then
		self:equipped_unit():base():set_gadget_color(color)
	end
end

-- Lines 193-204
function HuskPlayerInventory:on_melee_item_shown()
	local selection = self._available_selections[self._equipped_selection]

	if not selection then
		return
	end

	if selection.use_data.equip.align_place == "left_hand" and alive(selection.unit) then
		self:_link_weapon(selection.unit, self._align_places.right_hand)
	end
end

-- Lines 206-216
function HuskPlayerInventory:on_melee_item_hidden()
	local selection = self._available_selections[self._equipped_selection]

	if not selection then
		return
	end

	if selection.use_data.equip.align_place == "left_hand" and alive(selection.unit) then
		self:_link_weapon(selection.unit, self._align_places.left_hand)
	end
end

-- Lines 220-235
function HuskPlayerInventory._get_weapon_name_from_sync_index(w_index)
	if w_index <= #tweak_data.character.weap_unit_names then
		return tweak_data.character.weap_unit_names[w_index]
	end

	w_index = w_index - #tweak_data.character.weap_unit_names

	HuskPlayerInventory._chk_create_w_factory_indexes()

	local fps_id = PlayerInventory._weapon_factory_indexed[w_index]

	if tweak_data.weapon.factory[fps_id .. "_npc"] then
		return fps_id .. "_npc"
	else
		return fps_id
	end
end

-- Lines 240-249
function HuskPlayerInventory:set_weapon_underbarrel(selection_index, underbarrel_id, is_on)
	selection_index = (tonumber(selection_index) - 1) % 2 + 1
	local selection = self._available_selections[selection_index]

	if not selection then
		return
	end

	if selection.unit:base().set_underbarrel then
		selection.unit:base():set_underbarrel(underbarrel_id, is_on)
	end
end

-- Lines 254-261
function HuskPlayerInventory:set_visibility_state(state)
	local state_name = self._unit:movement():current_state_name()
	local is_clean = HuskPlayerMovement.clean_states[state_name]

	if state and is_clean then
		return
	end

	HuskPlayerInventory.super.set_visibility_state(self, state)
end
