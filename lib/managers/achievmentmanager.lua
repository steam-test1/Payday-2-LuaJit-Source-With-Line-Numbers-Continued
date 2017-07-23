AchievmentManager = AchievmentManager or class()
AchievmentManager.PATH = "gamedata/achievments"
AchievmentManager.FILE_EXTENSION = "achievment"

-- Lines: 10 to 85
function AchievmentManager:init()
	self.exp_awards = {
		b = 1500,
		a = 500,
		c = 5000,
		none = 0
	}
	self.script_data = {}

	if SystemInfo:platform() == Idstring("WIN32") then
		if SystemInfo:distribution() == Idstring("STEAM") then
			AchievmentManager.do_award = AchievmentManager.award_steam

			if not Global.achievment_manager then
				self:_parse_achievments("Steam")

				self.handler = Steam:sa_handler()

				self.handler:initialized_callback(AchievmentManager.fetch_achievments)
				self.handler:init()

				Global.achievment_manager = {
					handler = self.handler,
					achievments = self.achievments
				}
			else
				self.handler = Global.achievment_manager.handler
				self.achievments = Global.achievment_manager.achievments
			end
		else
			AchievmentManager.do_award = AchievmentManager.award_none

			self:_parse_achievments()

			if not Global.achievment_manager then
				Global.achievment_manager = {achievments = self.achievments}
			end

			self.achievments = Global.achievment_manager.achievments
		end
	elseif SystemInfo:platform() == Idstring("PS3") then
		if not Global.achievment_manager then
			Global.achievment_manager = {trophy_requests = {}}
		end

		self:_parse_achievments("PSN")

		AchievmentManager.do_award = AchievmentManager.award_psn
	elseif SystemInfo:platform() == Idstring("PS4") then
		if not Global.achievment_manager then
			self:_parse_achievments("PS4")

			Global.achievment_manager = {
				trophy_requests = {},
				achievments = self.achievments
			}
		else
			self.achievments = Global.achievment_manager.achievments
		end

		AchievmentManager.do_award = AchievmentManager.award_psn
	elseif SystemInfo:platform() == Idstring("X360") then
		self:_parse_achievments("X360")

		AchievmentManager.do_award = AchievmentManager.award_x360
	elseif SystemInfo:platform() == Idstring("XB1") then
		if not Global.achievment_manager then
			self:_parse_achievments("XB1")

			Global.achievment_manager = {achievments = self.achievments}
		else
			self.achievments = Global.achievment_manager.achievments
		end

		AchievmentManager.do_award = AchievmentManager.award_x360
	else
		Application:error("[AchievmentManager:init] Unsupported platform")
	end

	self._mission_end_achievements = {}
end

-- Lines: 111 to 113
function AchievmentManager:init_finalize()
	managers.savefile:add_load_sequence_done_callback_handler(callback(self, self, "_load_done"))
end

-- Lines: 115 to 119
function AchievmentManager:fetch_trophies()
	if SystemInfo:platform() == Idstring("PS3") or SystemInfo:platform() == Idstring("PS4") then
		Trophies:get_unlockstate(AchievmentManager.unlockstate_result)
	end
end

-- Lines: 122 to 139
function AchievmentManager.unlockstate_result(error_str, table)
	if table then
		for i, data in ipairs(table) do
			local psn_id = data.index
			local unlocked = data.unlocked

			if unlocked then
				for id, ach in pairs(managers.achievment.achievments) do
					if ach.id == psn_id then
						ach.awarded = true
					end
				end
			end
		end
	end

	managers.network.account:achievements_fetched()
end

-- Lines: 142 to 160
function AchievmentManager.fetch_achievments(error_str)
	print("[AchievmentManager.fetch_achievments]", error_str)

	if error_str == "success" then
		for id, ach in pairs(managers.achievment.achievments) do
			if managers.achievment.handler:has_achievement(ach.id) then
				ach.awarded = true
			end
		end
	end

	managers.network.account:achievements_fetched()
end

-- Lines: 162 to 167
function AchievmentManager:_load_done()
	if SystemInfo:platform() == Idstring("XB1") then
		print("[AchievmentManager] _load_done()")

		self._is_fetching_achievments = XboxLive:achievements(0, 1000, true, callback(self, self, "_achievments_loaded"))
	end
end

-- Lines: 169 to 188
function AchievmentManager:_achievments_loaded(achievment_list)
	print("[AchievmentManager] Achievment loaded: " .. tostring(achievment_list and #achievment_list))

	if not self._is_fetching_achievments then
		print("[AchievmentManager] Achievment loading aborted.")

		return
	end

	for _, achievment in ipairs(achievment_list) do
		if achievment.type == "achieved" then
			for _, achievment2 in pairs(managers.achievment.achievments) do
				if achievment.id == tostring(achievment2.id) then
					print("[AchievmentManager] Awarded by load: " .. tostring(achievment.id))

					achievment2.awarded = true

					break
				end
			end
		end
	end
end

-- Lines: 190 to 199
function AchievmentManager:on_user_signout()
	if SystemInfo:platform() == Idstring("XB1") then
		print("[AchievmentManager] on_user_signout()")

		self._is_fetching_achievments = nil

		for id, ach in pairs(managers.achievment.achievments) do
			ach.awarded = false
		end
	end
end

-- Lines: 203 to 220
function AchievmentManager:_parse_achievments(platform)
	local list = PackageManager:script_data(self.FILE_EXTENSION:id(), self.PATH:id())
	self.achievments = {}

	for _, ach in ipairs(list) do
		if ach._meta == "achievment" then
			for _, reward in ipairs(ach) do
				if reward._meta == "reward" and (Application:editor() or not platform or platform == reward.platform) then
					self.achievments[ach.id] = {
						awarded = false,
						id = reward.id,
						name = ach.name,
						exp = self.exp_awards[ach.awards_exp],
						dlc_loot = reward.dlc_loot or false
					}
				end
			end
		end
	end
end

-- Lines: 224 to 225
function AchievmentManager:get_script_data(id)
	return self.script_data[id]
end

-- Lines: 228 to 230
function AchievmentManager:set_script_data(id, data)
	self.script_data[id] = data
end

-- Lines: 234 to 235
function AchievmentManager:exists(id)
	return self.achievments[id] ~= nil
end

-- Lines: 238 to 239
function AchievmentManager:get_info(id)
	return self.achievments[id]
end

-- Lines: 242 to 243
function AchievmentManager:total_amount()
	return table.size(self.achievments)
end

-- Lines: 246 to 253
function AchievmentManager:total_unlocked()
	local i = 0

	for _, ach in pairs(self.achievments) do
		if ach.awarded then
			i = i + 1
		end
	end

	return i
end

-- Lines: 259 to 261
function AchievmentManager:add_heist_success_award(id)
	self._mission_end_achievements[id] = {award = true}
end

-- Lines: 263 to 267
function AchievmentManager:add_heist_success_award_progress(id)
	local new_progress = (managers.job:get_memory(id, true) or 0) + 1

	managers.job:set_memory(id, new_progress, true)

	self._mission_end_achievements[id] = {
		stat = true,
		progress = new_progress
	}
end

-- Lines: 269 to 271
function AchievmentManager:clear_heist_success_awards()
	self._mission_end_achievements = {}
end

-- Lines: 273 to 274
function AchievmentManager:heist_success_awards()
	return self._mission_end_achievements
end

-- Lines: 288 to 319
function AchievmentManager:award(id)
	if not self:exists(id) then
		Application:error("[AchievmentManager:award] Awarding non-existing achievement", "id", id)

		return
	end

	managers.challenge:on_achievement_awarded(id)
	managers.custom_safehouse:on_achievement_awarded(id)

	if managers.mutators:are_achievements_disabled() then
		return
	end

	if self:get_info(id).awarded then
		return
	end

	if id == "christmas_present" then
		managers.network.account._masks.santa = true
	elseif id == "golden_boy" then
		managers.network.account._masks.gold = true
	end

	managers.mission:call_global_event(Message.OnAchievement, id)
	self:do_award(id)
end

-- Lines: 384 to 402
function AchievmentManager:_give_reward(id, skip_exp)
	print("[AchievmentManager:_give_reward] ", id)

	local data = self:get_info(id)
	data.awarded = true

	if data.dlc_loot then
		managers.dlc:on_achievement_award_loot()
	end
end

-- Lines: 405 to 437
function AchievmentManager:award_progress(stat, value)
	if Application:editor() then
		return
	end

	managers.challenge:on_achievement_progressed(stat)
	managers.custom_safehouse:on_achievement_progressed(stat, value)

	if managers.mutators:are_mutators_active() and game_state_machine:current_state_name() ~= "menu_main" then
		return
	end

	print("[AchievmentManager:award_progress]: ", stat .. " increased by " .. tostring(value or 1))

	if SystemInfo:platform() == Idstring("WIN32") then
		self.handler:achievement_store_callback(AchievmentManager.steam_unlock_result)
	end

	local stats = {[stat] = {
		type = "int",
		value = value or 1
	}}

	managers.network.account:publish_statistics(stats, true)
end

-- Lines: 441 to 445
function AchievmentManager:get_stat(stat)
	if SystemInfo:platform() == Idstring("WIN32") then
		return managers.network.account:get_stat(stat)
	end

	return false
end

-- Lines: 450 to 452
function AchievmentManager:award_none(id)
	Application:debug("[AchievmentManager:award_none] Awarded achievment", id)
end

-- Lines: 456 to 470
function AchievmentManager:award_steam(id)
	Application:debug("[AchievmentManager:award_steam] Awarded Steam achievment", id)
	self.handler:achievement_store_callback(AchievmentManager.steam_unlock_result)
	self.handler:set_achievement(self:get_info(id).id)
	self.handler:store_data()

	if tweak_data.achievement.inventory[id] then
		for category, category_data in pairs(tweak_data.achievement.inventory[id].rewards) do
			for id, entry in pairs(category_data) do
				managers.blackmarket:tradable_achievement(category, entry)
			end
		end
	end
end

-- Lines: 474 to 484
function AchievmentManager:clear_steam(id)
	print("[AchievmentManager:clear_steam]", id)

	if not self.handler:initialized() then
		print("[AchievmentManager:clear_steam] Achievments are not initialized. Cannot clear achievment:", id)

		return
	end

	self.handler:clear_achievement(self:get_info(id).id)
	self.handler:store_data()
end

-- Lines: 488 to 498
function AchievmentManager:clear_all_steam()
	print("[AchievmentManager:clear_all_steam]")

	if not self.handler:initialized() then
		print("[AchievmentManager:clear_steam] Achievments are not initialized. Cannot clear steam:")

		return
	end

	self.handler:clear_all_stats(true)
	self.handler:store_data()
end

-- Lines: 502 to 511
function AchievmentManager.steam_unlock_result(achievment)
	print("[AchievmentManager:steam_unlock_result] Awarded Steam achievment", achievment)

	for id, ach in pairs(managers.achievment.achievments) do
		if ach.id == achievment then
			managers.achievment:_give_reward(id)

			return
		end
	end
end

-- Lines: 514 to 530
function AchievmentManager:award_x360(id)
	print("[AchievmentManager:award_x360] Awarded X360 achievment", id)


	-- Lines: 522 to 527
	local function x360_unlock_result(result)
		print("result", result)
	end

	XboxLive:award_achievement(managers.user:get_platform_id(), self:get_info(id).id, x360_unlock_result)
end

-- Lines: 534 to 545
function AchievmentManager:award_psn(id)
	print("[AchievmentManager:award] Awarded PSN achievment", id, self:get_info(id).id)

	if not self._trophies_installed then
		print("[AchievmentManager:award] Trophies are not installed. Cannot award trophy:", id)

		return
	end

	local request = Trophies:unlock_id(self:get_info(id).id, AchievmentManager.psn_unlock_result)
	Global.achievment_manager.trophy_requests[request] = id
end

-- Lines: 547 to 555
function AchievmentManager.psn_unlock_result(request, error_str)
	print("[AchievmentManager:psn_unlock_result] Awarded PSN achievment", request, error_str)

	local id = Global.achievment_manager.trophy_requests[request]

	if error_str == "success" then
		Global.achievment_manager.trophy_requests[request] = nil

		managers.achievment:_give_reward(id)
	end
end

-- Lines: 559 to 569
function AchievmentManager:chk_install_trophies()
	if Trophies:is_installed() then
		print("[AchievmentManager:chk_install_trophies] Already installed")

		self._trophies_installed = true

		Trophies:get_unlockstate(self.unlockstate_result)
		self:fetch_trophies()
	elseif managers.dlc:has_full_game() then
		print("[AchievmentManager:chk_install_trophies] Installing")
		Trophies:install(callback(self, self, "clbk_install_trophies"))
	end
end

-- Lines: 573 to 579
function AchievmentManager:clbk_install_trophies(result)
	print("[AchievmentManager:clbk_install_trophies]", result)

	if result then
		self._trophies_installed = true

		self:fetch_trophies()
	end
end

-- Lines: 584 to 631
function AchievmentManager:check_complete_heist_stats_achivements()
	local job = nil

	for achievement, achievement_data in pairs(tweak_data.achievement.complete_heist_stats_achievements) do
		local available_jobs = nil

		if achievement_data.contact == "all" then
			available_jobs = {}

			for _, list in pairs(tweak_data.achievement.job_list) do
				for _, job in pairs(list) do
					table.insert(available_jobs, job)
				end
			end
		else
			available_jobs = deep_clone(tweak_data.achievement.job_list[achievement_data.contact])
		end

		for id = #available_jobs, 1, -1 do
			job = available_jobs[id]

			if type(job) == "table" then
				for _, job_id in ipairs(job) do
					local break_outer = false

					for _, difficulty in ipairs(achievement_data.difficulty) do
						if managers.statistics:completed_job(job_id, difficulty) > 0 then
							table.remove(available_jobs, id)

							break_outer = true

							break
						end
					end

					if break_outer then
						break
					end
				end
			else
				for _, difficulty in ipairs(achievement_data.difficulty) do
					if managers.statistics:completed_job(job, difficulty) > 0 then
						table.remove(available_jobs, id)
					end
				end
			end
		end

		if table.size(available_jobs) == 0 then
			self:_award_achievement(achievement_data)
		end
	end
end

-- Lines: 636 to 642
function AchievmentManager:check_autounlock_achievements()
	if SystemInfo:platform() == Idstring("WIN32") then
		self:_check_autounlock_complete_heist()
		self:_check_autounlock_difficulties()
	end

	self:_check_autounlock_infamy()
end

-- Lines: 646 to 665
function AchievmentManager:_check_autounlock_complete_heist()
	for achievement, achievement_data in pairs(tweak_data.achievement.complete_heist_achievements) do
		if table.size(achievement_data) == 3 and achievement_data.award and achievement_data.difficulty and (achievement_data.job or achievement_data.jobs) then
			if not achievement_data.jobs then
				local jobs = {achievement_data.job}
			end

			for i, job in pairs(jobs) do
				for _, difficulty in ipairs(achievement_data.difficulty) do
					if managers.statistics:completed_job(job, difficulty) > 0 then
						self:_award_achievement(achievement_data)

						break
					end
				end
			end
		end
	end
end

-- Lines: 668 to 670
function AchievmentManager:_check_autounlock_difficulties()
	self:check_complete_heist_stats_achivements()
end

-- Lines: 673 to 675
function AchievmentManager:_check_autounlock_infamy()
	managers.experience:_check_achievements()
end

-- Lines: 678 to 697
function AchievmentManager:_award_achievement(achievement_data, achievement_name)
	if achievement_name then
		print("[AchievmentManager] awarding: ", achievement_name)
	end

	if achievement_data.stat then
		managers.achievment:award_progress(achievement_data.stat)
	elseif achievement_data.award then
		managers.achievment:award(achievement_data.award)
	elseif achievement_data.challenge_stat then
		managers.challenge:award_progress(achievement_data.challenge_stat)
	elseif achievement_data.trophy_stat then
		managers.custom_safehouse:award(achievement_data.trophy_stat)
	elseif achievement_data.challenge_award then
		managers.challenge:award(achievement_data.challenge_award)
	end
end

