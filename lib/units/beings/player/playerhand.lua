require("lib/units/beings/player/PlayerHandStateMachine")
require("lib/units/beings/player/PlayerWatch")
require("lib/input/HandStateMachine")
require("lib/input/HandStatesPlayer")

PlayerHand = PlayerHand or class()
PlayerHand.RIGHT = 1
PlayerHand.LEFT = 2

-- Lines: 13 to 19
function PlayerHand.hand_id(arg)
	if arg == PlayerHand.RIGHT or string.lower(arg) == "right" then
		return PlayerHand.RIGHT
	elseif arg == PlayerHand.LEFT or string.lower(arg) == "left" then
		return PlayerHand.LEFT
	end
end

-- Lines: 21 to 22
function PlayerHand.other_hand_id(arg)
	return 3 - PlayerHand.hand_id(arg)
end

-- Lines: 25 to 133
function PlayerHand:init(unit)
	print("[PlayerHand] Init")

	if not PackageManager:loaded("packages/vr_base") then
		PackageManager:load("packages/vr_base")
	end

	local camera = unit:camera()
	local camera_unit = camera:camera_unit()
	local controller = unit:base():controller()
	local hand_states = {
		empty = EmptyHandState:new(),
		point = PointHandState:new(),
		weapon = WeaponHandState:new(),
		mask = MaskHandState:new(),
		item = ItemHandState:new(),
		ability = AbilityHandState:new(),
		equipment = EquipmentHandState:new(),
		akimbo = AkimboHandState:new(),
		tablet = TabletHandState:new(),
		belt = BeltHandState:new(),
		repeater = RepeaterHandState:new(),
		driving = DrivingHandState:new()
	}
	self._hand_state_machine = HandStateMachine:new(hand_states, hand_states.empty, hand_states.empty)

	self._hand_state_machine:attach_controller(controller, true)
	self._hand_state_machine:attach_controller(managers.menu:get_controller())
	managers.vr:set_hand_state_machine(self._hand_state_machine)

	self._controller = controller
	self._vr_controller = controller:get_controller("vr")
	local base_rotation = camera_unit:base():base_rotation()
	self._base_rotation = base_rotation
	self._unit = unit
	self._unit_movement_ext = unit:movement()
	self._camera_unit = camera_unit
	self._belt_yaw = base_rotation:yaw()
	self._prev_ghost_position = mvector3.copy(self._unit_movement_ext:ghost_position())
	self._hand_data = {}
	local l_hand_unit = World:spawn_unit(Idstring("units/pd2_dlc_vr/player/vr_hand_left"), Vector3(0, 0, 0), Rotation())
	local r_hand_unit = World:spawn_unit(Idstring("units/pd2_dlc_vr/player/vr_hand_right"), Vector3(0, 0, 0), Rotation())

	l_hand_unit:warp():set_player_unit(unit)
	r_hand_unit:warp():set_player_unit(unit)

	self._shadow_unit = World:spawn_unit(Idstring("units/pd2_dlc_vr/player/vr_shadow"), Vector3(0, 0, 0), Rotation())

	unit:link(l_hand_unit)
	unit:link(r_hand_unit)
	unit:link(self._shadow_unit)

	local controller_rotation = Rotation()

	if managers.vr:is_oculus() then
		controller_rotation = Rotation(math.X, -30)
	end

	table.insert(self._hand_data, {
		hand = "right",
		state = "idle",
		unit = r_hand_unit,
		base_rotation = Rotation(math.X, -50),
		base_rotation_controller = controller_rotation,
		base_position = Vector3(0, -2, -7),
		rotation_raw = Rotation()
	})
	table.insert(self._hand_data, {
		hand = "left",
		state = "idle",
		unit = l_hand_unit,
		base_rotation = Rotation(math.X, -50),
		base_rotation_controller = controller_rotation,
		base_position = Vector3(0, -2, -7),
		rotation_raw = Rotation()
	})

	self._watch = PlayerWatch:new(l_hand_unit)
	self._shared_transition_queue = StateMachineTransitionQueue:new()
	self._hand_data[PlayerHand.RIGHT].state_machine = PlayerHandStateMachine:new(self._hand_data[PlayerHand.RIGHT].unit, PlayerHand.RIGHT, self._shared_transition_queue)
	self._hand_data[PlayerHand.LEFT].state_machine = PlayerHandStateMachine:new(self._hand_data[PlayerHand.LEFT].unit, PlayerHand.LEFT, self._shared_transition_queue)

	self._hand_data[PlayerHand.RIGHT].state_machine:set_other_hand(self._hand_data[PlayerHand.LEFT].state_machine)
	self._hand_data[PlayerHand.LEFT].state_machine:set_other_hand(self._hand_data[PlayerHand.RIGHT].state_machine)

	self._belt_unit = World:spawn_unit(Idstring("units/pd2_dlc_vr/player/vr_hud_belt"), Vector3(0, 0, 0), Rotation())

	self._belt_unit:set_visible(false)

	local default_weapon_hand = self.hand_id(managers.vr:get_setting("default_weapon_hand") or "right")
	local default_tablet_hand = self.hand_id(managers.vr:get_setting("default_tablet_hand") or "left")

	managers.hud:bind_hud_to_vr_hand(self:hand_unit(default_weapon_hand), self:hand_unit(default_tablet_hand), self._belt_unit, default_weapon_hand, default_tablet_hand)
	self._hand_data[default_weapon_hand].state_machine:set_default_state("weapon")
	self._hand_data[self.other_hand_id(default_tablet_hand)].unit:damage():run_sequence_simple("hide_gadgets")

	self._tablet_hand_changed_clbk = callback(self, self, "on_tablet_hand_changed")

	managers.vr:add_setting_changed_callback("default_tablet_hand", self._tablet_hand_changed_clbk)

	self._belt_size_changed_clbk = callback(self, self, "on_belt_size_changed")

	managers.vr:add_setting_changed_callback("belt_size", self._belt_size_changed_clbk)
end

-- Lines: 135 to 145
function PlayerHand:destroy()
	print("[PlayerHand] Destroy")

	for _, controller in ipairs(self._hand_data) do
		controller.unit:unlink()
		World:delete_unit(controller.unit)

		controller.unit = nil
	end

	managers.vr:remove_setting_changed_callback("default_tablet_hand", self._tablet_hand_changed_clbk)
	managers.vr:remove_setting_changed_callback("belt_size", self._belt_size_changed_clbk)
end

-- Lines: 147 to 159
function PlayerHand:on_tablet_hand_changed(setting, old, new)
	self:hand_unit(new):damage():run_sequence_simple("show_gadgets")
	self:hand_unit(old):damage():run_sequence_simple("hide_gadgets")

	local default_weapon_hand = self.hand_id(managers.vr:get_setting("default_weapon_hand") or "right")
	local default_tablet_hand = self.hand_id(managers.vr:get_setting("default_tablet_hand") or "left")

	managers.hud:bind_hud_to_vr_hand(self:hand_unit(default_weapon_hand), self:hand_unit(default_tablet_hand), self._belt_unit, default_weapon_hand, default_tablet_hand)

	local current_mask_hand_id = self:get_active_hand_id("mask")

	if current_mask_hand_id then
		self:current_hand_state(current_mask_hand_id):switch_hands()
	end
end

-- Lines: 161 to 163
function PlayerHand:on_belt_size_changed(setting, old, new)
	HUDManagerVR.link_belt(managers.hud:belt_workspace(), self._belt_unit)
end

-- Lines: 165 to 169
function PlayerHand:_set_hand_state(hand, state, params)
	if self._hand_data[hand].state_machine:can_change_state_by_name(state) then
		self._hand_data[hand].state_machine:change_state_by_name(state, params)
	end
end

-- Lines: 171 to 173
function PlayerHand:_change_hand_to_default(hand, params)
	self._hand_data[hand].state_machine:change_to_default(params)
end

-- Lines: 175 to 176
function PlayerHand:current_hand_state(hand)
	return self._hand_data[hand].state_machine:current_state()
end

-- Lines: 179 to 185
function PlayerHand:get_default_hand_id(state)
	for id, hand_data in ipairs(self._hand_data) do
		if hand_data.state_machine:default_state_name() == state then
			return id
		end
	end
end

-- Lines: 187 to 189
function PlayerHand:set_default_state(hand, state)
	self._hand_data[self.hand_id(hand)].state_machine:set_default_state(state)
end

-- Lines: 191 to 193
function PlayerHand:set_custom_belt_height_ratio(height)
	self._custom_belt_height_ratio = height
end
local pen = Draw:pen()
local prints = 20

-- Lines: 197 to 287
function PlayerHand:_update_controllers(t, dt)
	local hmd_pos = VRManager:hmd_position()
	local current_height = hmd_pos.z

	mvector3.set_z(hmd_pos, 0)

	local ghost_position = self._unit_movement_ext:ghost_position()

	if self._vr_controller then
		for i, controller in ipairs(self._hand_data) do
			local pos, rot = self._vr_controller:pose(i - 1)
			rot = self._base_rotation * rot
			pos = pos - hmd_pos

			mvector3.rotate_with(pos, self._base_rotation)

			pos = pos + ghost_position

			mrotation.set_zero(controller.rotation_raw)
			mrotation.multiply(controller.rotation_raw, rot)
			mrotation.multiply(controller.rotation_raw, controller.base_rotation_controller)
			mrotation.multiply(rot, controller.base_rotation)

			controller.rotation = rot
			pos = pos + controller.base_position:rotate_with(controller.rotation)
			controller.position = pos
			local forward = Vector3(0, 1, 0)
			controller.forward = forward:rotate_with(controller.rotation)

			controller.unit:set_position(pos)
			controller.unit:set_rotation(rot)
			controller.state_machine:set_position(pos)
			controller.state_machine:set_rotation(rot)

			if self._scheculed_wall_checks and self._scheculed_wall_checks[i] and self._scheculed_wall_checks[i].t < t then
				local custom_obj = self._scheculed_wall_checks[i].custom_obj
				self._scheculed_wall_checks[i] = nil

				if not self:check_hand_through_wall(i, custom_obj) then
					controller.unit:damage():run_sequence_simple(self:current_hand_state(i)._sequence)
				end
			end
		end

		for _, controller in ipairs(self._hand_data) do
			controller.state_machine:update(t, dt)
		end

		self._shared_transition_queue:do_state_change()
	end

	local rot = VRManager:hmd_rotation()
	rot = self._base_rotation * rot
	local forward = Vector3(0, 1, 0)
	local up = Vector3(0, 0, 1)

	mvector3.rotate_with(forward, rot)
	mvector3.rotate_with(up, rot)

	local v = forward

	if forward.y < 0.5 then
		v = up
	end

	mvector3.set_z(v, 0)
	mvector3.normalize(v)
	self._shadow_unit:set_position(ghost_position - v * 30 + Vector3(0, 0, 5))

	local max_angle = managers.vr:get_setting("belt_snap")
	local angle = rot:rotation_difference(Rotation(self._belt_yaw, 0, 0), Rotation(rot:yaw(), 0, 0)):yaw()
	local abs_angle = math.abs(angle)
	local distance = mvector3.distance_sq(self._prev_ghost_position, ghost_position)

	if rot:pitch() > -35 or max_angle < abs_angle or distance > 1600 then
		self._prev_ghost_position = mvector3.copy(ghost_position)
		self._belt_yaw = rot:yaw()
	end

	local belt_rot = Rotation(self._belt_yaw, 0, 0)

	self._belt_unit:set_position(ghost_position + Vector3(0, managers.vr:get_setting("belt_distance"), current_height * (self._custom_belt_height_ratio or managers.vr:get_setting("belt_height_ratio"))):rotate_with(belt_rot))
	self._belt_unit:set_rotation(belt_rot)

	local look_dot = math.clamp(mvector3.dot(rot:y(), Vector3(0, 0, -1)), 0, 1) - 0.6

	managers.hud:belt():set_alpha(look_dot * 1.5)

	for i = 1, 2, 1 do
		local closest = math.huge

		if managers.hud:belt():visible() then
			for _, interact_name in ipairs(managers.hud:belt():valid_interactions()) do
				local interact_pos = managers.hud:belt():get_interaction_point(interact_name)
				closest = math.min(closest, mvector3.distance_sq(self:hand_unit(i):position(), interact_pos))
			end
		end

		self:set_belt_active(closest < 100, i)
	end
end
local tablet_normal = Vector3(-1, 0, 0)
local rotated_tablet_normal = Vector3(0, 0, 0)

-- Lines: 291 to 342
function PlayerHand:update(unit, t, dt)
	if self._block_input then
		return
	end

	self:_update_controllers(t, dt)

	local hmd_forward = (self._base_rotation * VRManager:hmd_rotation()):y()
	local weapon_hand_id = self:get_active_hand_id("weapon")

	if weapon_hand_id then
		local dot = mvector3.dot(self:hand_unit(weapon_hand_id):rotation():y(), hmd_forward)

		managers.hud:set_ammo_alpha(math.clamp(dot * math.abs(dot) - 0.5, 0, 0.5) * 2)
	end

	local default_tablet_hand = self.hand_id(managers.vr:get_setting("default_tablet_hand") or "left")

	mvector3.set(rotated_tablet_normal, tablet_normal)

	if default_tablet_hand == PlayerHand.RIGHT then
		mvector3.negate(rotated_tablet_normal)
	end

	mvector3.rotate_with(rotated_tablet_normal, self:hand_unit(default_tablet_hand):rotation())
	mvector3.negate(hmd_forward)

	self._looking_at_tablet = mvector3.dot(rotated_tablet_normal, hmd_forward) > 0.8
	local tablet_to_hmd = mvector3.copy(self._unit_movement_ext:ghost_position():with_z(0))

	mvector3.subtract(tablet_to_hmd, self:hand_unit(default_tablet_hand):position():with_z(0))
	mvector3.normalize(tablet_to_hmd)

	if mvector3.dot(hmd_forward, tablet_to_hmd) < -0.2 then
		self._looking_at_tablet = false
	end

	local other_hand_to_tablet = self:hand_unit(self.other_hand_id(default_tablet_hand)):position():with_z(0)

	mvector3.subtract(other_hand_to_tablet, self:hand_unit(default_tablet_hand):position():with_z(0))
	mvector3.normalize(other_hand_to_tablet)

	if mvector3.dot(other_hand_to_tablet, rotated_tablet_normal) < 0.2 then
		self._looking_at_tablet = false
	end

	if self._looking_at_tablet then
		self:set_point_at_tablet(true)
	else
		self:set_point_at_tablet(false)
	end

	if not self._looking_at_tablet and managers.hud:current_tablet_page() ~= "main" then
		managers.hud:set_tablet_page("main")
	end
end

-- Lines: 344 to 350
function PlayerHand:raw_hand_rotation(hand)
	if hand == 1 or hand == "right" then
		return self._hand_data[PlayerHand.RIGHT].rotation_raw
	elseif hand == 2 or hand == "left" then
		return self._hand_data[PlayerHand.LEFT].rotation_raw
	end

	return nil
end

-- Lines: 353 to 359
function PlayerHand:hand_unit(hand)
	if hand == 1 or hand == "right" then
		return self._hand_data[PlayerHand.RIGHT].unit
	elseif hand == 2 or hand == "left" then
		return self._hand_data[PlayerHand.LEFT].unit
	end

	return nil
end

-- Lines: 362 to 364
function PlayerHand:mask_hand_id()
	local default_tablet_hand = self.hand_id(managers.vr:get_setting("default_tablet_hand") or "left")

	return self.other_hand_id(default_tablet_hand)
end

-- Lines: 367 to 368
function PlayerHand:mask_hand_unit()
	return self:hand_unit(self:mask_hand_id())
end

-- Lines: 371 to 378
function PlayerHand:link_mask(mask_unit)
	local default_weapon_hand = self.hand_id(managers.vr:get_setting("default_weapon_hand") or "right")

	self._hand_data[default_weapon_hand].state_machine:set_default_state("idle")
	self:_set_hand_state(self:mask_hand_id(), "item", {
		type = "mask",
		unit = mask_unit,
		prompt = {
			text_id = "hud_instruct_mask_on",
			macros = {BTN_USE_ITEM = managers.localization:btn_macro("use_item")}
		}
	})
	self:_set_hand_state(self.other_hand_id(self:mask_hand_id()), "idle")

	self._mask_unit = mask_unit
end

-- Lines: 380 to 392
function PlayerHand:unlink_mask(next_state)
	local default_weapon_hand = self.hand_id(managers.vr:get_setting("default_weapon_hand") or "right")
	self._mask_unit = nil

	self._hand_data[default_weapon_hand].state_machine:set_default_state("weapon")
	self:_change_hand_to_default(default_weapon_hand)
	self:_change_hand_to_default(self.other_hand_id(default_weapon_hand))
end

-- Lines: 394 to 405
function PlayerHand:set_point_at_tablet(point)
	local non_tablet_hand_id = self.other_hand_id(managers.vr:get_setting("default_tablet_hand") or "left")

	if point then
		self:_set_hand_state(non_tablet_hand_id, "swipe", {flick_callback = callback(managers.hud, managers.hud, "on_flick")})
	else
		local current = self:current_hand_state(non_tablet_hand_id)

		if current:name() == "swipe" then
			self:_set_hand_state(non_tablet_hand_id, current.prev_state)
		end
	end
end

-- Lines: 407 to 422
function PlayerHand:set_belt_active(active, hand)
	if not hand then
		self:set_belt_active(active, PlayerHand.RIGHT)
		self:set_belt_active(active, PlayerHand.LEFT)

		return
	end

	if active then
		self:_set_hand_state(hand, "belt")
	else
		local current = self:current_hand_state(hand)

		if current:name() == "belt" then
			self:_change_hand_to_default(hand)
		end
	end
end

-- Lines: 424 to 425
function PlayerHand:warp()
	return self._hand_data[PlayerHand.LEFT].unit:warp()
end

-- Lines: 428 to 429
function PlayerHand:watch()
	return self._watch
end

-- Lines: 432 to 452
function PlayerHand:interaction_ids()
	local weapon_hand_id = self:get_active_hand_id("weapon")

	if not weapon_hand_id then
		for id, hand_data in ipairs(self._hand_data) do
			if hand_data.state_machine:default_state_name() == "weapon" then
				weapon_hand_id = id

				break
			end
		end
	end

	if weapon_hand_id then
		if self:current_hand_state(self.other_hand_id(weapon_hand_id)):name() == "point" then
			return {}
		else
			return {self.other_hand_id(weapon_hand_id)}
		end
	else
		return {
			PlayerHand.LEFT,
			PlayerHand.RIGHT
		}
	end
end

-- Lines: 454 to 459
function PlayerHand:interaction_units()
	local units = {}

	for _, id in ipairs(self:interaction_ids()) do
		table.insert(units, self._hand_data[id].unit)
	end

	return units
end

-- Lines: 462 to 469
function PlayerHand:start_show_intrest(blocked, hand)
	if self:current_hand_state(hand):name() == "ready" then
		self:current_hand_state(hand):set_blocked(blocked)
	else
		self:_set_hand_state(hand, "ready", blocked)
	end

	self._vr_controller:trigger_haptic_pulse(hand - 1, 0, 700)
end

-- Lines: 471 to 475
function PlayerHand:end_show_intrest(hand)
	if self:current_hand_state(hand):name() == "ready" then
		self:_change_hand_to_default(hand)
	end
end

-- Lines: 477 to 479
function PlayerHand:intimidate(hand)
	self:_set_hand_state(hand, "point")
end

-- Lines: 481 to 482
function PlayerHand:belt_unit()
	return self._belt_unit
end

-- Lines: 485 to 512
function PlayerHand:set_carry(carry, skip_hand)
	self._carry = carry

	if carry then
		managers.hud:belt():set_state("bag", skip_hand and "default" or "active")

		if not skip_hand then
			local carry_id = managers.player:get_my_carry_data().carry_id
			local unit_name = tweak_data.carry[carry_id].unit

			if unit_name then
				unit_name = string.match(unit_name, "/([^/]*)$")
				unit_name = "units/pd2_dlc_vr/equipment/" .. unit_name .. "_vr"
			else
				unit_name = "units/pd2_dlc_vr/equipment/gen_pku_lootbag_vr"
			end

			local hand_id = self._unit_movement_ext:current_state()._interact_hand or self:interaction_ids()[1]
			local hand_unit = self:hand_unit(hand_id)
			local unit = World:spawn_unit(Idstring(unit_name), hand_unit:position(), hand_unit:rotation() * Rotation(0, 0, -90))

			self:_set_hand_state(hand_id, "item", {
				body = "hinge_body_1",
				type = "bag",
				unit = unit,
				offset = Vector3(0, 15, 0),
				prompt = {
					text_id = "hud_instruct_throw_bag",
					btn_macros = {BTN_USE_ITEM = "use_item"}
				}
			})
		end
	else
		managers.hud:belt():set_state("bag", "inactive")

		local bag_hand = self:get_active_hand_id("bag")

		if bag_hand then
			self:_change_hand_to_default(bag_hand)
		end
	end
end

-- Lines: 517 to 522
function PlayerHand:get_active_hand(item)
	local id = self:get_active_hand_id(item)

	if id then
		return self._hand_data[id].unit
	end
end

-- Lines: 524 to 533
function PlayerHand:get_active_hand_id(item)
	for i in ipairs(self._hand_data) do
		local state = self:current_hand_state(i)

		if state:name() == item then
			return i
		elseif state:name() == "item" and state:item_type() == item then
			return i
		end
	end
end

-- Lines: 535 to 540
function PlayerHand:apply_weapon_kick(amount, akimbo)
	local id = self:get_active_hand_id(akimbo and "akimbo" or "weapon")

	if id then
		self:current_hand_state(id):set_wanted_weapon_kick(amount)
	end
end

-- Lines: 542 to 551
function PlayerHand:set_cuffed(cuffed)
	for hand in ipairs(self._hand_data) do
		if cuffed then
			self:_set_hand_state(hand, "cuffed")
		else
			self:_change_hand_to_default(hand)
		end
	end
end

-- Lines: 553 to 555
function PlayerHand:set_block_input(block)
	self._block_input = block
end

-- Lines: 557 to 559
function PlayerHand:set_base_rotation(rot)
	self._base_rotation = rot
end

-- Lines: 562 to 569
function PlayerHand:set_warping(warping)
	for hand in ipairs(self._hand_data) do
		local state = self:current_hand_state(hand)

		if state.set_warping then
			state:set_warping(warping)
		end
	end
end

-- Lines: 571 to 588
function PlayerHand:set_tased(tased)
	if self._tase_effects then
		for _, id in ipairs(self._tase_effects) do
			World:effect_manager():fade_kill(id)
		end

		self._tase_effects = nil
	end

	if tased then
		self._tase_effects = {}

		for _, hand_data in ipairs(self._hand_data) do
			table.insert(self._tase_effects, World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/vr/vr_taser"),
				parent = hand_data.unit:orientation_object()
			}))
		end
	end
end

-- Lines: 592 to 627
function PlayerHand:check_hand_through_wall(hand, custom_obj)
	local hand_unit = self:hand_unit(hand)
	local head_pos = self._unit_movement_ext:m_head_pos()
	local hand_pos = hand_unit:position()
	local custom_pos = alive(custom_obj) and custom_obj:position()
	local ray = nil
	local raycasts = {
		{ray = {
			custom_pos or hand_pos,
			head_pos
		}},
		{points = {
			custom_pos or hand_pos,
			hand_pos - hand_unit:rotation():y() * 50,
			head_pos
		}},
		{points = {
			custom_pos or hand_pos,
			hand_pos - hand_unit:rotation():y() * 30 + hand_unit:rotation():x() * 30,
			head_pos
		}},
		{points = {
			custom_pos or hand_pos,
			(hand_pos - hand_unit:rotation():y() * 30) - hand_unit:rotation():x() * 30,
			head_pos
		}},
		{points = {
			custom_pos or hand_pos,
			hand_pos - hand_unit:rotation():y() * 30 + hand_unit:rotation():z() * 30,
			head_pos
		}},
		{points = {
			custom_pos or hand_pos,
			(hand_pos - hand_unit:rotation():y() * 30) - hand_unit:rotation():z() * 30,
			head_pos
		}}
	}

	for _, cast in ipairs(raycasts) do
		if cast.ray then
			ray = hand_unit:raycast("slot_mask", 1, "ray", unpack(cast.ray))
		elseif cast.points then
			ray = hand_unit:raycast("points", cast.points, "slot_mask", 1)
		end

		if not ray then
			if self._scheculed_wall_checks and self._scheculed_wall_checks[hand] then
				self:hand_unit(hand):damage():run_sequence_simple(self:current_hand_state(hand)._sequence)

				self._scheculed_wall_checks[hand] = nil
			end

			return false
		end
	end

	self._scheculed_wall_checks = self._scheculed_wall_checks or {}
	self._scheculed_wall_checks[hand] = {
		t = TimerManager:game():time() + tweak_data.vr.wall_check_delay,
		custom_obj = custom_obj
	}

	self:hand_unit(hand):damage():run_sequence_simple("warning")

	return true
end

-- Lines: 630 to 632
function PlayerHand:warp_hand()
	local hand_index = self._hand_state_machine:hand_from_connection("warp") or PlayerHand.other_hand_id(managers.vr:get_setting("default_weapon_hand"))

	return hand_index == PlayerHand.RIGHT and "right" or "left"
end

