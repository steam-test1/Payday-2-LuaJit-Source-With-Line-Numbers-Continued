require("lib/mutators/BaseMutator")
require("lib/mutators/MutatorEnemyHealth")
require("lib/mutators/MutatorEnemyDamage")
require("lib/mutators/MutatorFriendlyFire")
require("lib/mutators/MutatorShotgunTweak")
require("lib/mutators/MutatorExplodingEnemies")
require("lib/mutators/MutatorHydra")
require("lib/mutators/MutatorEnemyReplacer")
require("lib/mutators/MutatorCloakerEffect")
require("lib/mutators/MutatorShieldDozers")
require("lib/mutators/MutatorPiggyBank")
require("lib/mutators/MutatorCG22")
require("lib/mutators/MutatorPiggyRevenge")

MutatorsManager = MutatorsManager or class()
MutatorsManager.package = "packages/toxic"
MutatorsManager._atlas_file = "guis/textures/pd2/mutator_icons_atlas"
MutatorsManager._icon_size = 128
MutatorsManager._options_icon_coord = {
	8,
	2
}

-- Lines 31-130
function MutatorsManager:init()
	managers.mutators = self
	self._message_system = MessageSystem:new()
	self._lobby_delay = -1

	if not Global.mutators then
		Global.mutators = {
			mutator_values = {},
			active_on_load = {}
		}
	end

	self._mutators = {
		MutatorEnemyHealth:new(self),
		MutatorEnemyDamage:new(self),
		MutatorFriendlyFire:new(self),
		MutatorShotgunTweak:new(self),
		MutatorExplodingEnemies:new(self),
		MutatorHydra:new(self),
		MutatorEnemyReplacer:new(self),
		MutatorMediDozer:new(self),
		MutatorCloakerEffect:new(self),
		MutatorShieldDozers:new(self),
		MutatorTitandozers:new(self),
		MutatorPiggyBank:new(self),
		MutatorCG22:new(self),
		MutatorPiggyRevenge:new(self)
	}
	self._active_mutators = {}
	local activate = Global.mutators and Global.mutators.active_on_load

	if not self:can_mutators_be_active() then
		activate = false
	end

	if activate then
		for id, data in pairs(Global.mutators.active_on_load) do
			cat_print("jamwil", "[Mutators] Attempting to activate mutator: ", id)

			local mutator = self:get_mutator_from_id(id)

			if mutator then
				table.insert(self:active_mutators(), {
					mutator = mutator
				})
				cat_print("jamwil", "[Mutators] Activated mutator: ", id)
			else
				cat_print("jamwil", "[Mutators] No mutator with id: ", id)
			end

			for key, value in pairs(data) do
				if Network:is_client() then
					mutator:set_host_value(key, value)
				end
			end
		end
	end

	local setup_mutators = {}

	for _, active_mutator in pairs(self:active_mutators()) do
		table.insert(setup_mutators, active_mutator.mutator)
	end

	table.sort(setup_mutators, function (a, b)
		return b.load_priority < a.load_priority
	end)

	for _, mutator in pairs(setup_mutators) do
		cat_print("jamwil", "[Mutators] Setting up active mutator: ", mutator:id())
		mutator:setup(self)
	end
end

-- Lines 133-137
function MutatorsManager:on_game_started()
	for _, active_mutator in pairs(self:active_mutators()) do
		active_mutator.mutator:on_game_started(self)
	end
end

-- Lines 139-143
function MutatorsManager:sync_save(sync_data)
	for _, active_mutator in pairs(self:active_mutators()) do
		active_mutator.mutator:sync_save(self, sync_data)
	end
end

-- Lines 145-149
function MutatorsManager:sync_load(sync_data)
	for _, active_mutator in pairs(self:active_mutators()) do
		active_mutator.mutator:sync_load(self, sync_data)
	end
end

-- Lines 152-159
function MutatorsManager:update(t, dt)
	self:message_system():update(t, dt)

	for _, active_mutator in pairs(self:active_mutators()) do
		active_mutator.mutator:update(t, dt)
	end
end

-- Lines 162-178
function MutatorsManager:save(data)
	local values = {}

	for i, mutator in ipairs(self:mutators()) do
		local mutator_values = {}

		for key, data in pairs(mutator:values()) do
			mutator_values[key] = data.current
		end

		values[mutator:id()] = mutator_values
	end

	local state = {
		save_values = values
	}
	data.Mutators = state
end

-- Lines 181-203
function MutatorsManager:load(data, version)
	cat_print("jamwil", "[Mutators] Begin loading...")

	local state = data.Mutators or {}

	for id, values in pairs(state.save_values or {}) do
		cat_print("jamwil", "[Mutators] Loading KVs for mutator: ", id)

		local mutator = self:get_mutator_from_id(id)

		if mutator then
			for key, value in pairs(values) do
				cat_print("jamwil", "           >: ", key, value)
				mutator:set_value(key, value)
			end
		else
			cat_print("jamwil", "[Mutators]            > no mutator")
		end
	end

	cat_print("jamwil", "[Mutators] Loading finished!")
end

-- Lines 207-219
function MutatorsManager:can_mutators_be_active()
	if Global.game_settings.gamemode ~= GamemodeStandard.id then
		return false
	end

	if managers.skirmish:is_skirmish() then
		return false
	end

	return true
end

-- Lines 222-233
function MutatorsManager:are_mutators_active()
	if not self:can_mutators_be_active() then
		return false
	end

	if Network:is_server() then
		return #self:active_mutators() > 0
	elseif Network:is_client() then
		return self:get_mutators_from_lobby_data()
	else
		return false
	end
end

-- Lines 236-250
function MutatorsManager:are_mutators_enabled()
	if not self:can_mutators_be_active() then
		return false
	end

	if Network:is_client() then
		return self:are_mutators_active()
	else
		for i, mutator in ipairs(self:mutators()) do
			if mutator:is_enabled() then
				return true
			end
		end

		return false
	end
end

-- Lines 253-255
function MutatorsManager:mutators()
	return self._mutators
end

-- Lines 257-259
function MutatorsManager:num_mutators()
	return #self._mutators
end

-- Lines 262-264
function MutatorsManager:active_mutators()
	return self._active_mutators
end

-- Lines 267-274
function MutatorsManager:is_mutator_active(mutator)
	for _, active_mutator in pairs(self:active_mutators()) do
		if mutator._type == active_mutator.mutator:id() then
			return true
		end
	end

	return false
end

-- Lines 276-282
function MutatorsManager:get_mutator(mutator_class)
	for i, mutator in pairs(self:mutators()) do
		if mutator_class._type == mutator:id() then
			return mutator
		end
	end
end

-- Lines 286-292
function MutatorsManager:allow_mutators_in_level(level_id)
	local level_data = tweak_data.levels[level_id]

	if level_data and level_data.disable_mutators then
		return false
	end

	return true
end

-- Lines 295-327
function MutatorsManager:globalize_active_mutators()
	Global.mutators.active_on_load = {}

	if not self:allow_mutators_in_level(Global.level_data.level_id) then
		return
	end

	if Network:is_server() then
		for i, mutator in ipairs(self:mutators()) do
			if mutator:is_enabled() then
				local data = {}

				for key, value in pairs(mutator:values()) do
					data[key] = value
				end

				Global.mutators.active_on_load[mutator:id()] = data
			end
		end
	elseif Network:is_client() then
		for id, mutator_data in pairs(self:get_mutators_from_lobby_data() or {}) do
			local data = {}

			for key, value in pairs(mutator_data) do
				data[key] = value
			end

			Global.mutators.active_on_load[id] = data
		end
	end
end

-- Lines 330-332
function MutatorsManager:clear_global_mutators()
	Global.mutators.active_on_load = {}
end

-- Lines 335-347
function MutatorsManager:reset_all_mutators()
	for _, mutator in ipairs(self:mutators()) do
		self:set_enabled(mutator, false)
		mutator:clear_values()
	end

	if not Global.game_settings.single_player then
		self:update_lobby_info()
		MenuCallbackHandler:update_matchmake_attributes()
	end
end

-- Lines 351-358
function MutatorsManager:get_mutator_from_id(id)
	for _, mutator in ipairs(self:mutators()) do
		if mutator:id() == id then
			return mutator
		end
	end

	return nil
end

-- Lines 360-367
function MutatorsManager:can_enable_mutator(mutator)
	for _, imutator in ipairs(self:mutators()) do
		if imutator:id() ~= mutator:id() and imutator:is_enabled() and imutator:is_incompatible_with(mutator) then
			return false, imutator
		end
	end

	return true
end

-- Lines 369-387
function MutatorsManager:set_enabled(mutator, enabled)
	if enabled == nil then
		enabled = true
	end

	if type(mutator) == "string" then
		mutator = self:get_mutator_from_id(mutator)
	end

	if not mutator then
		return false
	end

	if enabled and self:can_enable_mutator(mutator) then
		mutator:set_enabled(enabled)
	else
		mutator:set_enabled(false)
	end
end

-- Lines 391-397
function MutatorsManager:categories()
	return {
		"all",
		"enemies",
		"gameplay"
	}
end

-- Lines 401-403
function MutatorsManager:message_system()
	return self._message_system
end

-- Lines 405-407
function MutatorsManager:notify(message, ...)
	self._message_system:notify(message, nil, ...)
end

-- Lines 409-411
function MutatorsManager:register_message(message, uid, func)
	self._message_system:register(message, uid, func)
end

-- Lines 413-415
function MutatorsManager:unregister_message(message, uid)
	self._message_system:unregister(message, uid)
end

-- Lines 419-427
function MutatorsManager:_get_reduction(func)
	local max_reduction = 0

	for _, mutator in pairs(self:mutators()) do
		if mutator:is_enabled() or mutator:is_active() then
			max_reduction = math.max(max_reduction, mutator[func](mutator))
		end
	end

	return max_reduction
end

-- Lines 429-431
function MutatorsManager:get_cash_multiplier()
	return 1 - self:_get_reduction("get_cash_reduction")
end

-- Lines 433-435
function MutatorsManager:get_cash_reduction()
	return self:_get_reduction("get_cash_reduction")
end

-- Lines 437-439
function MutatorsManager:get_experience_multiplier()
	return 1 - self:_get_reduction("get_experience_reduction")
end

-- Lines 441-443
function MutatorsManager:get_experience_reduction()
	return self:_get_reduction("get_experience_reduction")
end

-- Lines 447-457
function MutatorsManager:are_achievements_disabled()
	if game_state_machine:current_state_name() ~= "menu_main" then
		for _, mutator in pairs(self:mutators()) do
			if mutator:is_active() and mutator.disables_achievements then
				return true
			end
		end
	else
		return false
	end
end

-- Lines 459-461
function MutatorsManager:are_challenges_disabled()
	return self:are_achievements_disabled()
end

-- Lines 463-465
function MutatorsManager:are_trophies_disabled()
	return self:are_achievements_disabled()
end

-- Lines 467-469
function MutatorsManager:should_disable_statistics()
	return self:get_cash_reduction() > 0 or self:get_experience_reduction() > 0 or self:are_achievements_disabled()
end

-- Lines 473-475
function MutatorsManager:delay_lobby_time()
	return 16
end

-- Lines 477-479
function MutatorsManager:lobby_delay()
	return self._lobby_delay or 0
end

-- Lines 481-484
function MutatorsManager:set_lobby_delay(delay)
	print("[Mutators] Delaying lobby start by ", delay)

	self._lobby_delay = TimerManager:main():time() + delay
end

-- Lines 486-501
function MutatorsManager:should_delay_game_start()
	if BaseNetworkHandler._verify_gamestate(BaseNetworkHandler._gamestate_filter.any_ingame) then
		return false
	end

	local peers_table = managers.network and managers.network:session() and managers.network:session():peers()

	if table.size(peers_table or {}) == 0 then
		return false
	end

	if not self:are_mutators_enabled() then
		return false
	end

	if not self:_check_all_peers_are_ready() then
		return true
	end

	return self:lobby_delay() - TimerManager:main():time() > 0
end

-- Lines 505-510
function MutatorsManager:use_start_the_game_initial_delay()
	if not self._used_start_game_delay then
		self:set_lobby_delay(self:delay_lobby_time())

		self._used_start_game_delay = true
	end
end

-- Lines 512-514
function MutatorsManager:start_the_game_countdown_cancelled()
	self._used_start_game_delay = nil
end

-- Lines 518-525
function MutatorsManager:_run_func(func_name, ...)
	for i, active_mutator in pairs(self:active_mutators()) do
		local mutator = active_mutator.mutator

		if mutator and mutator[func_name] then
			mutator[func_name](mutator, ...)
		end
	end
end

-- Lines 527-529
function MutatorsManager:modify_character_tweak_data(character_tweak)
	self:_run_func("modify_character_tweak_data", character_tweak)
end

-- Lines 531-533
function MutatorsManager:modify_tweak_data(id, value)
	self:_run_func("modify_tweak_data", id, value)
end

-- Lines 535-546
function MutatorsManager:modify_value(id, value)
	for i, active_mutator in pairs(self:active_mutators()) do
		local mutator = active_mutator.mutator

		if mutator and mutator.modify_value then
			local new_value, override = mutator:modify_value(id, value)

			if new_value ~= nil or override then
				value = new_value
			end
		end
	end

	return value
end

-- Lines 550-567
function MutatorsManager:update_lobby_info()
	print("[Mutators] Updating lobby info...")

	if Network:is_server() and self:are_mutators_enabled() and table.size(managers.network:session():peers()) > 0 then
		self:send_mutators_notification_to_clients(0)

		if not self:_check_all_peers_are_ready() then
			self:set_lobby_delay(self:delay_lobby_time())
		end
	end
end

-- Lines 569-583
function MutatorsManager:apply_matchmake_attributes(lobby_attributes)
	print("[Mutators] Applying lobby attributes...")

	local count = 0

	for i, mutator in ipairs(self:mutators()) do
		if mutator:is_enabled() then
			count = count + 1
			lobby_attributes["mutator_" .. tostring(count)] = mutator:build_matchmaking_key()
		end
	end

	lobby_attributes.mutators = count
end

-- Lines 585-602
function MutatorsManager:matchmake_pack_string(num_strings)
	local ret = {}

	for i = 1, num_strings do
		ret[i] = ""
	end

	local k = 0

	for j, mutator in ipairs(self:mutators()) do
		if mutator:is_enabled() then
			local index = k % num_strings + 1
			ret[index] = ret[index] .. mutator:build_compressed_data(j)
			k = k + 1
		end
	end

	return ret
end

-- Lines 604-634
function MutatorsManager:matchmake_unpack_string(str_dat)
	local mutators_list = {}
	local limit = 0

	while #str_dat > 0 and limit < 50 do
		local mutator_index = string.byte(str_dat, 1) - string.byte("a")
		local mutator = self:mutators()[mutator_index]

		if #str_dat > 1 then
			str_dat = string.sub(str_dat, -(#str_dat - 1))
		else
			str_dat = ""
		end

		if mutator then
			local mutator_data, new_str_dat = mutator:uncompress_data(str_dat)

			if mutator_data == nil then
				return mutators_list
			end

			mutators_list[mutator:id()] = mutator_data
			str_dat = new_str_dat
		else
			return mutators_list
		end

		limit = limit + 1
	end

	return mutators_list
end

-- Lines 636-670
function MutatorsManager:matchmake_partial_unpack_string(str_dat)
	local mutators = {}
	local count = 0

	while #str_dat > 0 and count < 50 do
		local mutator_index = string.byte(str_dat, 1) - string.byte("a")
		local mutator = self:mutators()[mutator_index]

		if #str_dat > 1 then
			str_dat = string.sub(str_dat, -(#str_dat - 1))
		else
			str_dat = ""
		end

		if mutator then
			local mutator_data, new_str_dat = mutator:partial_uncompress_data(str_dat)

			if mutator_data == nil then
				return mutators
			end

			mutators["mutator_" .. tostring(count + 1)] = mutator_data
			str_dat = new_str_dat
		else
			return mutators
		end

		count = count + 1
	end

	if count > 0 then
		mutators.mutators = count
	end

	return mutators
end

-- Lines 672-681
function MutatorsManager:send_mutators_notification_to_clients(countdown)
	for i, peer in pairs(managers.network:session():peers()) do
		if not self:has_peer_been_notified(peer:id()) then
			managers.network:session():send_to_peer(peer, "sync_mutators_launch", countdown or 0)
			self:set_peer_notified(peer:id(), true)
		end
	end
end

-- Lines 685-701
function MutatorsManager:get_mutators_from_lobby_data()
	if not managers.network or not managers.network.matchmake then
		return false
	end

	local lobby_data = managers.network.matchmake:get_lobby_data()

	if not lobby_data then
		return false
	end

	-- Lines 696-698
	local function func(key)
		return lobby_data[key]
	end

	return self:_get_mutators_data(func)
end

-- Lines 703-714
function MutatorsManager:get_mutators_from_lobby(lobby)
	if not lobby then
		return false
	end

	-- Lines 709-711
	local function func(key)
		return lobby:key_value(key)
	end

	return self:_get_mutators_data(func)
end

-- Lines 716-718
function MutatorsManager:set_crimenet_lobby_data(lobby_data)
	self._crimenet_lobby_data = lobby_data
end

-- Lines 720-722
function MutatorsManager:crimenet_lobby_data()
	return self._crimenet_lobby_data
end

-- Lines 724-753
function MutatorsManager:_get_mutators_data(get_data_func)
	local num_mutators = 0
	local mutators_kv = get_data_func("mutators")

	if mutators_kv ~= nil and mutators_kv ~= "value_missing" and mutators_kv ~= "value_pending" then
		num_mutators = tonumber(mutators_kv)
	end

	if num_mutators > 0 then
		local mutators_strs = {}

		for i = 1, num_mutators do
			local mutator_str = get_data_func("mutator_" .. tostring(i))

			if mutator_str then
				table.insert(mutators_strs, mutator_str)
			end
		end

		return self:_parse_mutator_strings(unpack(mutators_strs))
	else
		return false
	end
end

-- Lines 755-781
function MutatorsManager:_parse_mutator_strings(...)
	local mutators_list = {}

	for i, str in ipairs({
		...
	}) do
		local splits = string.split(str, "[ ]")

		if splits then
			local mutator = self:get_mutator_from_id(splits[1])

			if mutator then
				table.remove(splits, 1)

				local data = mutator:get_data_from_attribute_string(splits)

				if data then
					mutators_list[mutator:id()] = data
				end
			end
		end
	end

	return mutators_list
end

-- Lines 785-807
function MutatorsManager:get_enabled_active_mutator_category()
	if not self:can_mutators_be_active() then
		return "mutator"
	end

	local mutators_to_check = nil

	if Network:is_client() then
		for mutator_id, content in pairs(self:get_mutators_from_lobby_data() or {}) do
			if self:get_mutator_from_id(mutator_id):main_category() == "event" then
				return "event"
			end
		end
	else
		for _, mutator in ipairs(self._mutators) do
			if (mutator:is_enabled() or mutator:is_active()) and mutator:main_category() == "event" then
				return "event"
			end
		end
	end

	return "mutator"
end

-- Lines 809-816
function MutatorsManager:get_category_color(category)
	if category == "mutator" then
		return tweak_data.screen_colors.mutators_color
	elseif category == "event" then
		return tweak_data.screen_colors.event_color
	end

	return tweak_data.screen_colors.mutators_color
end

-- Lines 818-825
function MutatorsManager:get_category_text_color(category)
	if category == "mutator" then
		return tweak_data.screen_colors.mutators_color_text
	elseif category == "event" then
		return tweak_data.screen_colors.event_color
	end

	return tweak_data.screen_colors.mutators_color_text
end

-- Lines 828-836
function MutatorsManager:get_outro_event(default_outro_event)
	for _, active_mutator in pairs(self:active_mutators()) do
		if active_mutator.mutator.get_outro_event then
			return active_mutator.mutator:get_outro_event(default_outro_event)
		end
	end

	return default_outro_event
end

-- Lines 838-845
function MutatorsManager:get_briefing_override()
	for _, mutator in ipairs(self._mutators) do
		if mutator:is_enabled() or mutator:is_active() then
			return mutator.briefing_event or nil
		end
	end

	return nil
end

-- Lines 849-858
function MutatorsManager:get_track_override(track)
	for _, mutator in ipairs(self._mutators) do
		if (mutator:is_enabled() or mutator:is_active()) and mutator.track_overrides then
			return mutator.track_overrides[track]
		end
	end

	return nil
end

-- Lines 859-868
function MutatorsManager:get_mass_drop_mutator()
	for _, mutator in ipairs(self._mutators) do
		if (mutator:is_enabled() or mutator:is_active()) and mutator.got_mass_drop and mutator:got_mass_drop() then
			return mutator
		end
	end

	return nil
end

-- Lines 872-881
function MutatorsManager:get_interupt_stage_override(interupt)
	for _, mutator in ipairs(self._mutators) do
		if (mutator:is_enabled() or mutator:is_active()) and mutator.next_interupt_stage then
			return mutator:next_interupt_stage(interupt)
		end
	end

	return interupt
end

-- Lines 882-891
function MutatorsManager:get_briefing_dialog_override()
	for _, mutator in ipairs(self._mutators) do
		if (mutator:is_enabled() or mutator:is_active()) and mutator.briefing_dialog then
			return mutator.briefing_dialog
		end
	end

	return nil
end

-- Lines 896-950
function MutatorsManager:show_mutators_launch_countdown(countdown)
	if Network:is_server() then
		return
	end

	if countdown ~= nil and countdown > 0 then
		local dialog_data = {
			title = managers.localization:text("dialog_warning_title"),
			text = managers.localization:text("dialog_mutators_active_text"),
			id = "mutators_warning"
		}
		local yes_button = {
			text = managers.localization:text("dialog_yes"),
			callback_func = callback(self, self, "_dialog_mutators_accept")
		}
		local no_button = {
			text = managers.localization:text("dialog_leave_lobby"),
			callback_func = callback(self, self, "_dialog_mutators_decline"),
			cancel_button = true
		}
		dialog_data.button_list = {
			yes_button,
			no_button
		}

		managers.system_menu:show(dialog_data)
	else
		local dialog_data = {
			title = managers.localization:text("dialog_warning_title"),
			text = managers.localization:text("dialog_mutators_active_text"),
			id = "mutators_warning"
		}
		local yes_button = {
			text = managers.localization:text("dialog_yes"),
			callback_func = callback(self, self, "_dialog_mutators_accept")
		}
		local no_button = {
			text = managers.localization:text("dialog_leave_lobby"),
			callback_func = callback(self, self, "_dialog_mutators_decline"),
			cancel_button = true
		}
		dialog_data.button_list = {
			yes_button,
			no_button
		}

		managers.system_menu:show(dialog_data)
	end
end

-- Lines 952-955
function MutatorsManager:_dialog_mutators_accept()
	managers.network:session():send_to_host("sync_mutators_launch_ready", managers.network:session():local_peer():id(), true)
end

-- Lines 957-959
function MutatorsManager:_dialog_mutators_decline()
	MenuCallbackHandler:_dialog_leave_lobby_yes()
end

-- Lines 963-966
function MutatorsManager:set_peer_notified(peer_id, is_notified)
	Global.mutators._peers_notified = Global.mutators._peers_notified or {}
	Global.mutators._peers_notified[peer_id] = is_notified
end

-- Lines 968-973
function MutatorsManager:has_peer_been_notified(peer_id)
	if Global.mutators._peers_notified then
		return Global.mutators._peers_notified[peer_id] or false
	end

	return false
end

-- Lines 975-985
function MutatorsManager:set_peer_is_ready(peer_id, is_ready, disable_check)
	Global.mutators._peers_ready = Global.mutators._peers_ready or {}
	Global.mutators._peers_ready[peer_id] = is_ready

	if not disable_check and self:_check_all_peers_are_ready() then
		self:set_lobby_delay(math.min(self:lobby_delay(), 3))
	end
end

-- Lines 987-992
function MutatorsManager:is_peer_ready(peer_id)
	if Global.mutators._peers_ready then
		return Global.mutators._peers_ready[peer_id] or false
	end

	return false
end

-- Lines 994-999
function MutatorsManager:force_all_ready()
	for i, peer in pairs(managers.network:session():peers()) do
		self:set_peer_notified(peer:id(), true)
		self:set_peer_is_ready(peer:id(), true, true)
	end
end

-- Lines 1001-1008
function MutatorsManager:_check_all_peers_are_ready()
	for i, peer in pairs(managers.network:session():peers()) do
		if not self:has_peer_been_notified(peer:id()) or not self:is_peer_ready(peer:id()) then
			return false
		end
	end

	return true
end

-- Lines 1010-1026
function MutatorsManager:on_peer_added(peer, peer_id)
	if self:are_mutators_active() or self:are_mutators_enabled() then
		self._used_start_game_delay = nil

		if game_state_machine:current_state_name() ~= "menu_main" then
			self:set_peer_notified(peer_id, true)
			self:set_peer_is_ready(peer_id, true)
		end
	end
end

-- Lines 1028-1039
function MutatorsManager:on_peer_removed(peer, peer_id, reason)
	self:set_peer_notified(peer_id, false)
	self:set_peer_is_ready(peer_id, false)

	if managers.menu and managers.menu:active_menu() and managers.menu:active_menu().renderer and managers.menu:active_menu().renderer:active_node_gui() and managers.menu:active_menu().renderer:active_node_gui().name == "start_the_game_countdown" then
		managers.menu:back()
		managers.menu:open_node("start_the_game_countdown")
	end
end

-- Lines 1041-1044
function MutatorsManager:on_lobby_left()
	Global.mutators._peers_notified = nil
	Global.mutators._peers_ready = nil
end

-- Lines 1048-1095
function MutatorsManager:check_achievements(achievement_data)
	if not achievement_data.mutators then
		return not self:are_achievements_disabled()
	end

	if achievement_data.mutators == true then
		return managers.mutators:are_mutators_active()
	elseif type(achievement_data.mutators) == "number" then
		return achievement_data.mutators <= table.size(managers.mutators:active_mutators())
	elseif #achievement_data.mutators == table.size(managers.mutators:active_mutators()) then
		local required_mutators = deep_clone(achievement_data.mutators)

		for _, active_mutator in pairs(managers.mutators:active_mutators()) do
			if table.contains(required_mutators, active_mutator.mutator:id()) then
				table.delete(required_mutators, active_mutator.mutator:id())
			end
		end

		for i = #required_mutators, 1, -1 do
			local mutator_data = required_mutators[i]

			for _, active_mutator in pairs(managers.mutators:active_mutators()) do
				if mutator_data.id == active_mutator.mutator:id() then
					local all_values = true

					for key, value in pairs(mutator_data) do
						if key ~= "id" and active_mutator.mutator:value(key) ~= value then
							all_values = false

							break
						end
					end

					if all_values then
						table.remove(required_mutators, i)
					end

					break
				end
			end
		end

		return #required_mutators == 0
	end
end
