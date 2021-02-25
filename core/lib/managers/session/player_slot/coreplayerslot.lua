core:module("CorePlayerSlot")
core:import("CoreRequester")
core:import("CoreFiniteStateMachine")
core:import("CorePlayerSlotStateInit")
core:import("CorePlayer")

PlayerSlot = PlayerSlot or class()

-- Lines 9-18
function PlayerSlot:init(player_slots_parent, local_user_manager)
	self._perform_local_user_binding = CoreRequester.Requester:new()
	self._perform_debug_local_user_binding = CoreRequester.Requester:new()
	self._init = CoreRequester.Requester:new()
	self._user_state = CoreFiniteStateMachine.FiniteStateMachine:new(CorePlayerSlotStateInit.Init, "player_slot", self)
	self._player_slots_parent = player_slots_parent
	self._local_user_manager = local_user_manager
end

-- Lines 20-25
function PlayerSlot:destroy()
	self._player_slots_parent:_remove_player_slot(self)

	if self._player then
		self._player:destroy()
	end
end

-- Lines 27-32
function PlayerSlot:clear_session()
	if self._player then
		self._player:destroy()

		self._player = nil
	end
end

-- Lines 34-36
function PlayerSlot:remove()
	self:destroy()
end

-- Lines 38-45
function PlayerSlot:_release_user_from_slot()
	if self._assigned_user then
		self._assigned_user:_player_slot_lost(self)
	end

	self._assigned_user = nil

	self._init:request()
end

-- Lines 47-49
function PlayerSlot:request_local_user_binding()
	self._perform_local_user_binding:request()
end

-- Lines 51-53
function PlayerSlot:stop_local_user_binding()
	self._perform_local_user_binding:cancel_request()
end

-- Lines 55-57
function PlayerSlot:request_debug_local_user_binding()
	self._perform_debug_local_user_binding:request()
end

-- Lines 59-61
function PlayerSlot:has_assigned_user()
	return self._assigned_user ~= nil
end

-- Lines 63-65
function PlayerSlot:assigned_user()
	return self._assigned_user
end

-- Lines 67-72
function PlayerSlot:assign_local_user(local_user)
	assert(local_user, "Must specify a valid user")
	assert(self._assigned_user == nil, "A user has already been assigned to this slot")

	self._assigned_user = local_user

	self._assigned_user:_player_slot_assigned(self)
end

-- Lines 74-76
function PlayerSlot:transition()
	self._user_state:transition()
end

-- Lines 78-91
function PlayerSlot:create_player()
	assert(self._player == nil, "Player already created for this slot")

	local factory = self._player_slots_parent._factory
	local player_handler = factory:create_player_handler()
	self._player = CorePlayer.Player:new(self, player_handler)
	player_handler.core_player = self._player

	if self._assigned_user then
		self._assigned_user:assign_player(self._player)
	end
end

-- Lines 93-99
function PlayerSlot:remove_player()
	if self._assigned_user then
		self._assigned_user:release_player(self._player)
	end

	self._player:destroy()

	self._player = nil
end

-- Lines 101-103
function PlayerSlot:has_player()
	return self._player ~= nil
end

-- Lines 105-107
function PlayerSlot:player()
	return self._player
end
