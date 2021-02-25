SkirmishManager = SkirmishManager or class()
SkirmishManager.LOBBY_NORMAL = 1
SkirmishManager.LOBBY_WEEKLY = 2

-- Lines 7-11
function SkirmishManager:init()
	Global.skirmish_manager = Global.skirmish_manager or {}
	self._global = Global.skirmish_manager
end

-- Lines 13-32
function SkirmishManager:init_finalize()
	if not self:is_skirmish() then
		return
	end

	if self:is_weekly_skirmish() then
		self:_apply_weekly_modifiers()

		if Network:is_client() and not self:host_weekly_match() then
			self:block_weekly_progress()
		end
	end

	if Network:is_server() then
		managers.groupai:add_event_listener({}, "start_assault", callback(self, self, "on_start_assault"))
		managers.groupai:add_event_listener({}, "end_assault_late", callback(self, self, "on_end_assault"))
	end

	managers.network:add_event_listener({}, "on_set_dropin", callback(self, self, "block_weekly_progress"))
end

-- Lines 34-37
function SkirmishManager:is_skirmish()
	local level_tweak = managers.job:current_level_data()

	return level_tweak and level_tweak.group_ai_state == "skirmish"
end

-- Lines 39-41
function SkirmishManager:is_weekly_skirmish()
	return self:is_skirmish() and Global.game_settings.weekly_skirmish
end

-- Lines 43-46
function SkirmishManager:random_skirmish_job_id()
	local job_list = tweak_data.skirmish.job_list

	return job_list[math.random(1, #job_list)]
end

-- Lines 48-50
function SkirmishManager:is_unlocked()
	return managers.experience:current_level() >= 65 or managers.experience:current_rank() > 0
end

-- Lines 52-55
function SkirmishManager:wave_range()
	return 1, 9
end

-- Lines 67-81
function SkirmishManager:host_weekly_match()
	if Network:is_server() then
		return true
	end

	if not self:active_weekly() then
		return false
	end

	local host_job = managers.job:current_job_id()
	local end_timestamp = self:active_weekly().end_timestamp
	local host_weekly_string = string.join(";", table.list_add({
		host_job,
		end_timestamp
	}, self:weekly_modifiers()))

	return self:active_weekly().key == host_weekly_string:key()
end

-- Lines 83-98
function SkirmishManager:_apply_modifiers_for_wave(wave_number)
	local modifiers_data = tweak_data.skirmish.wave_modifiers[wave_number]

	if not modifiers_data then
		return
	end

	for _, modifier_data in ipairs(modifiers_data) do
		local modifier_class = _G[modifier_data.class]
		local modifier_opts = modifier_data.data
		local modifier = modifier_class:new(modifier_opts)

		managers.modifiers:add_modifier(modifier, "skirmish_wave")
	end
end

-- Lines 100-110
function SkirmishManager:_apply_weekly_modifiers()
	for _, modifier_name in ipairs(self:weekly_modifiers()) do
		local modifier_data = tweak_data.skirmish.weekly_modifiers[modifier_name]
		local modifier_class = _G[modifier_data.class]
		local modifier_opts = modifier_data.data
		local modifier = modifier_class:new(modifier_opts)

		managers.modifiers:add_modifier(modifier, "skirmish_weekly")
	end
end

-- Lines 112-118
function SkirmishManager:current_wave_number()
	if Network:is_server() then
		return managers.groupai and managers.groupai:state():get_assault_number()
	else
		return self._synced_wave_number or 0
	end
end

-- Lines 120-129
function SkirmishManager:sync_start_assault(wave_number)
	if not self:is_skirmish() then
		return
	end

	for i = (self._synced_wave_number or 0) + 1, wave_number do
		self:_apply_modifiers_for_wave(i)
	end

	self._synced_wave_number = wave_number
end

-- Lines 131-135
function SkirmishManager:on_start_assault()
	local wave_number = managers.groupai:state():get_assault_number()

	self:_apply_modifiers_for_wave(wave_number)
	self:update_matchmake_attributes()
end

-- Lines 137-144
function SkirmishManager:on_end_assault()
	local new_ransom_amount = tweak_data.skirmish.ransom_amounts[self:current_wave_number()]

	self:set_ransom_amount(new_ransom_amount)

	if Network:is_server() then
		managers.network:session():send_to_peers("sync_end_assault_skirmish")
	end
end

-- Lines 146-155
function SkirmishManager:set_ransom_amount(amount)
	self._current_ransom_amount = amount

	managers.hud:loot_value_updated()
	managers.hud:present_mid_text({
		time = 2,
		text = managers.localization:to_upper_text("hud_skirmish_ransom_popup", {
			money = managers.experience:cash_string(math.round(amount))
		})
	})
end

-- Lines 157-159
function SkirmishManager:current_ransom_amount()
	return self._current_ransom_amount or 0
end

-- Lines 161-176
function SkirmishManager:_has_players_in_custody()
	local session = managers.network:session()
	local all_peers = session and session:all_peers()

	if not all_peers then
		return
	end

	for _, peer in ipairs(all_peers) do
		if managers.trade:is_peer_in_custody(peer:id()) then
			return true
		end
	end

	return false
end

-- Lines 178-184
function SkirmishManager:check_gameover_conditions()
	if not self:is_skirmish() or not self._game_over_delay then
		return false
	end

	return self._game_over_delay < Application:time()
end

-- Lines 186-201
function SkirmishManager:update()
	if self:_has_players_in_custody() then
		if not self._game_over_delay then
			self._game_over_delay = Application:time() + tweak_data.skirmish.custody_game_over_delay
			self._game_over_check_needed = true
		end
	else
		self._game_over_delay = nil
		self._game_over_check_needed = false
	end

	if self._game_over_check_needed and self._game_over_delay < Application:time() then
		managers.groupai:state():check_gameover_conditions()

		self._game_over_check_needed = false
	end
end

-- Lines 203-208
function SkirmishManager:sync_save(data)
	local state = {
		wave_number = self:current_wave_number()
	}
	data.SkirmishManager = state
end

-- Lines 210-213
function SkirmishManager:sync_load(data)
	local state = data.SkirmishManager

	self:sync_start_assault(state.wave_number)
end

-- Lines 215-226
function SkirmishManager:apply_matchmake_attributes(lobby_attributes)
	lobby_attributes.skirmish = 0

	if self:is_skirmish() then
		lobby_attributes.skirmish = self:is_weekly_skirmish() and SkirmishManager.LOBBY_WEEKLY or SkirmishManager.LOBBY_NORMAL
		lobby_attributes.skirmish_wave = math.max(self:current_wave_number() or 0, 1)

		if self:is_weekly_skirmish() then
			lobby_attributes.skirmish_weekly_modifiers = string.join(";", self._global.active_weekly.modifiers)
		end
	end
end

-- Lines 228-230
function SkirmishManager:update_matchmake_attributes()
	managers.network.matchmake:set_server_attributes(MenuCallbackHandler:get_matchmake_attributes())
end

-- Lines 232-237
function SkirmishManager:on_joined_server(lobby_data)
	if not lobby_data then
		return
	end

	Global.game_settings.weekly_skirmish = tonumber(lobby_data.skirmish) == SkirmishManager.LOBBY_WEEKLY
end

-- Lines 239-241
function SkirmishManager:on_left_lobby()
	Global.game_settings.weekly_skirmish = nil
end

-- Lines 243-250
function SkirmishManager:save(data)
	data.skirmish = {
		active_weekly = self._global.active_weekly,
		weekly_progress = self._global.weekly_progress,
		weekly_rewards = self._global.weekly_rewards,
		claimed_rewards = self._global.claimed_rewards
	}
end

-- Lines 252-262
function SkirmishManager:load(data)
	data = data.skirmish

	if not data then
		return
	end

	self._global.active_weekly = data.active_weekly
	self._global.weekly_progress = data.weekly_progress
	self._global.weekly_rewards = data.weekly_rewards
	self._global.claimed_rewards = data.claimed_rewards
end

-- Lines 264-295
function SkirmishManager:activate_weekly_skirmish(weekly_skirmish_string, force)
	local active_weekly = self._global.active_weekly or {}
	local weekly_skirmish_key = Idstring(weekly_skirmish_string):key()

	if active_weekly.key == weekly_skirmish_key and not force then
		return
	end

	local job_id, end_timestamp = nil
	local modifier_ids = {}

	for token in string.gmatch(weekly_skirmish_string, "([^;]+)") do
		if not job_id then
			job_id = token
		elseif not end_timestamp then
			end_timestamp = tonumber(token)
		else
			table.insert(modifier_ids, token)
		end
	end

	active_weekly.key = weekly_skirmish_key
	active_weekly.id = job_id
	active_weekly.end_timestamp = end_timestamp
	active_weekly.modifiers = modifier_ids
	self._global.active_weekly = active_weekly
	self._global.weekly_progress = nil
	self._global.weekly_rewards = nil
end

-- Lines 297-299
function SkirmishManager:active_weekly()
	return self._global.active_weekly
end

-- Lines 301-312
function SkirmishManager:weekly_modifiers()
	if self:is_weekly_skirmish() and Network:is_client() then
		if not self._host_weekly_modifiers then
			local modifiers_string = managers.network.matchmake.lobby_handler:get_lobby_data("skirmish_weekly_modifiers")
			self._host_weekly_modifiers = string.split(modifiers_string, ";")
		end

		return self._host_weekly_modifiers
	end

	return self._global.active_weekly.modifiers
end

-- Lines 314-321
function SkirmishManager:weekly_time_left_params()
	local diff = math.max(self:active_weekly().end_timestamp - os.time(), 0)

	return {
		hours = math.floor(diff / 3600),
		minutes = math.mod(math.floor(diff / 60), 60),
		seconds = math.mod(diff, 60)
	}
end

-- Lines 323-329
function SkirmishManager:weekly_progress()
	if not self._global.weekly_progress then
		return 0
	end

	return Application:digest_value(self._global.weekly_progress, false)
end

-- Lines 331-333
function SkirmishManager:block_weekly_progress()
	self._weekly_progress_blocked = true
end

-- Lines 335-344
function SkirmishManager:on_weekly_completed()
	if self._weekly_progress_blocked then
		return
	end

	local wave = self:current_wave_number()

	if self:weekly_progress() < wave then
		self._global.weekly_progress = Application:digest_value(wave, true)
	end
end

-- Lines 346-356
function SkirmishManager:unclaimed_rewards()
	local tier_to_id = {
		3,
		5,
		9
	}
	local unclaimed = {}

	for _, id in ipairs(tier_to_id) do
		if not self:claimed_reward_by_id(id) and id <= self:weekly_progress() then
			table.insert(unclaimed, id)
		end
	end

	return unclaimed
end

-- Lines 358-398
function SkirmishManager:claim_reward(id)
	local id_to_tier = {
		[3.0] = 1,
		[5.0] = 2,
		[9.0] = 3
	}
	self._global.claimed_rewards = self._global.claimed_rewards or {}
	self._global.weekly_rewards = self._global.weekly_rewards or {}
	local tier_tweak = tweak_data.skirmish.weekly_rewards[id_to_tier[id]]
	local reward_type = table.random_key(tier_tweak)
	local reward_list = tier_tweak[reward_type]
	local claimed_rewards = self._global.claimed_rewards[reward_type] or {}
	local unclaimed_rewards = {}

	for _, reward_id in ipairs(reward_list) do
		if not claimed_rewards[reward_id] then
			table.insert(unclaimed_rewards, reward_id)
		end
	end

	if #unclaimed_rewards == 0 then
		unclaimed_rewards = reward_list
		claimed_rewards = {}
	end

	local reward = table.random(unclaimed_rewards)
	claimed_rewards[reward] = true
	self._global.claimed_rewards[reward_type] = claimed_rewards
	local tweak = tweak_data.blackmarket[reward_type][reward]

	managers.blackmarket:add_to_inventory(tweak.global_value or "normal", reward_type, reward)

	self._global.weekly_rewards[id] = {
		reward_type,
		reward
	}

	managers.savefile:save_progress()
end

-- Lines 400-402
function SkirmishManager:claimed_reward_by_id(id)
	return self._global.weekly_rewards and self._global.weekly_rewards[id]
end
