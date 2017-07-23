core:module("CoreLocalUser")
core:import("CorePortableLocalUserStorage")
core:import("CoreSessionGenericState")

User = User or class(CoreSessionGenericState.State)

-- Lines: 7 to 14
function User:init(local_user_handler, input_input_provider, user_index, profile_settings_handler, profile_progress_handler)
	self._local_user_handler = local_user_handler
	self._input_input_provider = input_input_provider
	self._user_index = user_index
	self._storage = CorePortableLocalUserStorage.Storage:new(self, profile_settings_handler, profile_progress_handler, profile_data_loaded_callback)
	self._game_name = "Player #" .. tostring(self._user_index)
end

-- Lines: 16 to 17
function User.default_data(data)
end

-- Lines: 19 to 20
function User:save(data)
end

-- Lines: 22 to 24
function User:transition()
	self._storage:transition()
end

-- Lines: 26 to 30
function User:_player_slot_assigned(player_slot)
	assert(self._player_slot == nil, "This user already has an assigned player slot")

	self._player_slot = player_slot

	self._storage:request_load()
end

-- Lines: 32 to 36
function User:_player_slot_lost(player_slot)
	assert(self._player_slot ~= nil, "This user can get a lost player slot, no slot was assigned to begin with")
	assert(self._player_slot == player_slot, "Player has lost a player slot that wasn't assigned")

	self._player_slot = nil
end

-- Lines: 38 to 39
function User:profile_data_is_loaded()
	return self._storage:profile_data_is_loaded()
end

-- Lines: 42 to 44
function User:enter_level(level_handler)
	self._local_user_handler:enter_level(level_handler)
end

-- Lines: 46 to 49
function User:leave_level(level_handler)
	self._local_user_handler:leave_level(level_handler)
	self:release_player()
end

-- Lines: 51 to 52
function User:gamer_name()
	return self._game_name
end

-- Lines: 55 to 56
function User:is_stable_for_loading()
	return self._storage:is_stable_for_loading()
end

-- Lines: 59 to 62
function User:assign_player(player)
	self._player = player

	self._local_user_handler:player_assigned(self)
end

-- Lines: 64 to 68
function User:release_player()
	self._local_user_handler:player_removed()

	self._player = nil
	self._avatar = nil
end

-- Lines: 70 to 71
function User:assigned_player()
	return self._player
end

-- Lines: 74 to 75
function User:local_user_handler()
	return self._local_user_handler
end

-- Lines: 78 to 79
function User:profile_settings()
	return self._storage:profile_settings()
end

-- Lines: 82 to 83
function User:profile_progress()
	return self._storage:profile_progress()
end

-- Lines: 86 to 87
function User:save_profile_settings()
	return self._storage:request_save()
end

-- Lines: 90 to 91
function User:save_profile_progress()
	return self._storage:request_save()
end

-- Lines: 94 to 95
function User:engine_input_input_input_provider()
	return self._input_input_provider
end

-- Lines: 98 to 108
function User:update(t, dt)
	if not self._avatar and self._player and self._player:has_avatar() then
		local input_input_provider = self:engine_input_input_input_provider()
		local avatar = self._player:avatar()

		avatar:set_input(input_input_provider)

		self._avatar = avatar
	end

	self._local_user_handler:update(t, dt)
end

