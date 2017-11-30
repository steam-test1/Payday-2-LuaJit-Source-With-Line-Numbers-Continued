require("lib/utils/StateMachine")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateStandard")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateReady")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateWeapon")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateItem")
require("lib/units/beings/player/states/vr/hand/PlayerHandStatePoint")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateBelt")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateMelee")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateSwipe")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateAkimbo")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateWeaponAssist")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateCuffed")
require("lib/units/beings/player/states/vr/hand/PlayerHandStateDriving")

PlayerHandStateMachine = PlayerHandStateMachine or class(StateMachine)

-- Lines: 18 to 135
function PlayerHandStateMachine:init(hand_unit, hand_id, transition_queue)
	self._hand_id = hand_id
	self._hand_unit = hand_unit
	local idle = PlayerHandStateStandard:new(self, "idle", hand_unit, "idle")
	local weapon = PlayerHandStateWeapon:new(self, "weapon", hand_unit, "grip_wpn")
	local item = PlayerHandStateItem:new(self, "item", hand_unit, "grip_wpn")
	local point = PlayerHandStatePoint:new(self, "point", hand_unit, "point")
	local ready = PlayerHandStateReady:new(self, "ready", hand_unit, "ready")
	local swipe = PlayerHandStateSwipe:new(self, "swipe", hand_unit, "point")
	local belt = PlayerHandStateBelt:new(self, "belt", hand_unit, "ready")
	local melee = PlayerHandStateMelee:new(self, "melee", hand_unit, "grip_wpn")
	local akimbo = PlayerHandStateAkimbo:new(self, "akimbo", hand_unit, "grip_wpn")
	local weapon_assist = PlayerHandStateWeaponAssist:new(self, "weapon_assist", hand_unit, "grip_wpn")
	local cuffed = PlayerHandStateCuffed:new(self, "cuffed", hand_unit, "grip")
	local driving = PlayerHandStateDriving:new(self, "driving", hand_unit, "idle")
	local idle_func = callback(nil, idle, "default_transition")
	local weapon_func = callback(nil, weapon, "default_transition")
	local item_func = callback(nil, item, "default_transition")
	local point_func = callback(nil, point, "default_transition")
	local ready_func = callback(nil, ready, "default_transition")
	local swipe_func = callback(nil, swipe, "default_transition")
	local belt_func = callback(nil, belt, "default_transition")
	local melee_func = callback(nil, melee, "default_transition")
	local akimbo_func = callback(nil, akimbo, "default_transition")
	local weapon_assist_func = callback(nil, weapon_assist, "default_transition")
	local cuffed_func = callback(nil, cuffed, "default_transition")
	local driving_func = callback(nil, driving, "default_transition")
	local item_to_swipe = callback(nil, item, "swipe_transition")
	local swipe_to_item = callback(nil, swipe, "item_transition")

	PlayerHandStateMachine.super.init(self, idle, transition_queue)
	self:add_transition(idle, weapon, idle_func)
	self:add_transition(idle, item, idle_func)
	self:add_transition(idle, point, idle_func)
	self:add_transition(idle, ready, idle_func)
	self:add_transition(idle, belt, idle_func)
	self:add_transition(idle, swipe, idle_func)
	self:add_transition(idle, akimbo, idle_func)
	self:add_transition(idle, weapon_assist, idle_func)
	self:add_transition(idle, cuffed, idle_func)
	self:add_transition(idle, driving, idle_func)
	self:add_transition(weapon, idle, weapon_func)
	self:add_transition(weapon, item, weapon_func)
	self:add_transition(weapon, point, weapon_func)
	self:add_transition(weapon, ready, weapon_func)
	self:add_transition(weapon, belt, weapon_func)
	self:add_transition(weapon, swipe, weapon_func)
	self:add_transition(weapon, akimbo, weapon_func)
	self:add_transition(weapon, cuffed, weapon_func)
	self:add_transition(weapon, driving, weapon_func)
	self:add_transition(point, idle, point_func)
	self:add_transition(point, weapon, point_func)
	self:add_transition(point, ready, point_func)
	self:add_transition(point, akimbo, point_func)
	self:add_transition(ready, idle, ready_func)
	self:add_transition(ready, weapon, ready_func)
	self:add_transition(ready, point, ready_func)
	self:add_transition(ready, akimbo, ready_func)
	self:add_transition(ready, driving, ready_func)
	self:add_transition(ready, item, ready_func)
	self:add_transition(belt, idle, belt_func)
	self:add_transition(belt, weapon, belt_func)
	self:add_transition(belt, item, belt_func)
	self:add_transition(belt, melee, belt_func)
	self:add_transition(belt, akimbo, belt_func)
	self:add_transition(swipe, idle, swipe_func)
	self:add_transition(swipe, weapon, swipe_func)
	self:add_transition(swipe, akimbo, swipe_func)
	self:add_transition(swipe, melee, swipe_func)
	self:add_transition(swipe, item, swipe_to_item)
	self:add_transition(melee, idle, melee_func)
	self:add_transition(melee, weapon, melee_func)
	self:add_transition(melee, akimbo, melee_func)
	self:add_transition(melee, swipe, melee_func)
	self:add_transition(item, idle, item_func)
	self:add_transition(item, weapon, item_func)
	self:add_transition(item, akimbo, item_func)
	self:add_transition(item, swipe, item_to_swipe)
	self:add_transition(akimbo, idle, akimbo_func)
	self:add_transition(akimbo, weapon, akimbo_func)
	self:add_transition(akimbo, item, akimbo_func)
	self:add_transition(akimbo, point, akimbo_func)
	self:add_transition(akimbo, ready, akimbo_func)
	self:add_transition(akimbo, belt, akimbo_func)
	self:add_transition(akimbo, swipe, akimbo_func)
	self:add_transition(akimbo, cuffed, akimbo_func)
	self:add_transition(akimbo, driving, akimbo_func)
	self:add_transition(weapon_assist, idle, weapon_assist_func)
	self:add_transition(cuffed, idle, cuffed_func)
	self:add_transition(cuffed, weapon, cuffed_func)
	self:add_transition(cuffed, akimbo, cuffed_func)
	self:add_transition(driving, idle, driving_func)
	self:add_transition(driving, weapon, driving_func)
	self:add_transition(driving, akimbo, driving_func)
	self:set_default_state("idle")

	self._weapon_hand_changed_clbk = callback(self, self, "on_default_weapon_hand_changed")

	managers.vr:add_setting_changed_callback("default_weapon_hand", self._weapon_hand_changed_clbk)
end

-- Lines: 137 to 141
function PlayerHandStateMachine:destroy()
	PlayerHandStateMachine.super.destroy(self)
	managers.vr:remove_setting_changed_callback("default_weapon_hand", self._weapon_hand_changed_clbk)
end

-- Lines: 143 to 156
function PlayerHandStateMachine:on_default_weapon_hand_changed(setting, old, new)
	if old == new then
		return
	end

	local old_hand_id = PlayerHand.hand_id(old)

	if old_hand_id == self:hand_id() and self:default_state_name() == "weapon" then
		self:queue_default_state_switch(self:other_hand():default_state_name(), self:default_state_name())
	end
end

-- Lines: 158 to 160
function PlayerHandStateMachine:queue_default_state_switch(state, other_hand_state)
	self._queued_default_state_switch = {
		state,
		other_hand_state
	}
end

-- Lines: 163 to 174
function PlayerHandStateMachine:set_default_state(state_name)
	if self._default_state and state_name == self._default_state:name() then
		return
	end

	local new_default = assert(self._states[state_name], "[PlayerHandStateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	if self._default_state == self:current_state() and self:can_change_state(new_default) then
		self:change_state(new_default)
	end

	self._default_state = new_default
end

-- Lines: 176 to 180
function PlayerHandStateMachine:change_to_default(params, front)
	if self:can_change_state(self._default_state) then
		self:change_state(self._default_state, params, front)
	end
end

-- Lines: 182 to 183
function PlayerHandStateMachine:default_state_name()
	return self._default_state and self._default_state:name()
end

-- Lines: 186 to 187
function PlayerHandStateMachine:hand_id()
	return self._hand_id
end

-- Lines: 190 to 191
function PlayerHandStateMachine:hand_unit()
	return self._hand_unit
end

-- Lines: 194 to 196
function PlayerHandStateMachine:enter_controller_state(state_name)
	managers.vr:hand_state_machine():enter_hand_state(self._hand_id, state_name)
end

-- Lines: 198 to 200
function PlayerHandStateMachine:exit_controller_state(state_name)
	managers.vr:hand_state_machine():exit_hand_state(self._hand_id, state_name)
end

-- Lines: 202 to 204
function PlayerHandStateMachine:set_other_hand(hsm)
	self._other_hand = hsm
end

-- Lines: 206 to 207
function PlayerHandStateMachine:other_hand()
	return self._other_hand
end

-- Lines: 210 to 212
function PlayerHandStateMachine:can_change_state_by_name(state_name)
	local state = assert(self._states[state_name], "[PlayerHandStateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	return self:can_change_state(state)
end

-- Lines: 215 to 218
function PlayerHandStateMachine:change_state_by_name(state_name, params, front)
	local state = assert(self._states[state_name], "[PlayerHandStateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	self:change_state(state, params, front)
end

-- Lines: 220 to 221
function PlayerHandStateMachine:is_controller_enabled()
	return true
end

-- Lines: 224 to 231
function PlayerHandStateMachine:update(t, dt)
	if self._queued_default_state_switch then
		self:set_default_state(self._queued_default_state_switch[1])
		self:other_hand():set_default_state(self._queued_default_state_switch[2])

		self._queued_default_state_switch = nil
	end

	return PlayerHandStateMachine.super.update(self, t, dt)
end

-- Lines: 234 to 236
function PlayerHandStateMachine:set_position(pos)
	self._position = pos
end

-- Lines: 238 to 239
function PlayerHandStateMachine:position()
	return self._position or self:hand_unit():position()
end

