ConsolesSafehouseManager = ConsolesSafehouseManager or class()

-- Lines 10-22
function ConsolesSafehouseManager:init()
	self:_setup()

	self.prices_crew_boost = 2
	self.prices_crew_ability = 6
	self.prices_weapon_mod = 6
	self.prices_event_weapon_mod = 18
	self.rewards_experience_ratio = 500000
	self.level_limit = 0
end

-- Lines 24-26
function ConsolesSafehouseManager:unlocked()
	return true
end

-- Lines 28-32
function ConsolesSafehouseManager:reset()
	Global.consoles_safehouse_manager_manager = nil
	self._global = nil

	self:_setup()
end

-- Lines 34-38
function ConsolesSafehouseManager:init_finalize()
end

-- Lines 40-57
function ConsolesSafehouseManager:_setup()
	print("[ConsolesSafehouseManager:_setup]")

	if not Global.consoles_safehouse_manager_manager then
		Global.consoles_safehouse_manager_manager = {
			total = Application:digest_value(0, true),
			total_collected = Application:digest_value(0, true),
			prev_total = Application:digest_value(0, true)
		}
	end

	self._global = Global.consoles_safehouse_manager_manager
	self._global.prev_total = self._global.total

	self:attempt_give_initial_coins()
end

-- Lines 59-71
function ConsolesSafehouseManager:save(data)
	print("[ConsolesSafehouseManager:save]")

	local state = {
		total = self._global.total,
		total_collected = self._global.total_collected
	}
	data.ConsolesSafehouseManager = state
end

-- Lines 73-88
function ConsolesSafehouseManager:load(data, version)
	print("[ConsolesSafehouseManager:load]")

	local state = data.ConsolesSafehouseManager

	if state then
		self._global.total = state.total and Application:digest_value(math.max(0, Application:digest_value(state.total, false)), true) or Application:digest_value(0, true)
		self._global.total_collected = state.total_collected and Application:digest_value(math.max(0, Application:digest_value(state.total_collected, false)), true) or Application:digest_value(0, true)

		self:attempt_give_initial_coins()
	end
end

-- Lines 90-93
function ConsolesSafehouseManager:coins()
	print("[ConsolesSafehouseManager:coins]")

	return Application:digest_value(self._global.total, false)
end

-- Lines 95-98
function ConsolesSafehouseManager:previous_coins()
	print("[ConsolesSafehouseManager:previous_coins]")

	return Application:digest_value(self._global.prev_total, false)
end

-- Lines 100-103
function ConsolesSafehouseManager:total_coins_earned()
	print("[ConsolesSafehouseManager:total_coins_earned]")

	return Application:digest_value(self._global.total_collected, false)
end

-- Lines 105-108
function ConsolesSafehouseManager:coins_spent()
	print("[ConsolesSafehouseManager:coins_spent]")

	return self:total_coins_earned() - self:coins()
end

-- Lines 110-115
function ConsolesSafehouseManager:update_previous_coins()
end

-- Lines 117-133
function ConsolesSafehouseManager:add_coins(amount)
	print("[ConsolesSafehouseManager:add_coins]")

	local new_total = self:total_coins_earned() + amount
	local new_current = self:coins() + amount
	Global.consoles_safehouse_manager_manager.total = Application:digest_value(new_current, true)
	Global.consoles_safehouse_manager_manager.total_collected = Application:digest_value(new_total, true)

	print("Adding coins: ", amount, Application:digest_value(self._global.total, false))
end

-- Lines 135-139
function ConsolesSafehouseManager:deduct_coins(amount)
	print("[ConsolesSafehouseManager:deduct_coins]")

	amount = math.clamp(amount, 0, self:coins())
	Global.consoles_safehouse_manager_manager.total = Application:digest_value(self:coins() - amount, true)
end

-- Lines 141-149
function ConsolesSafehouseManager:attempt_give_initial_coins()
	print("[ConsolesSafehouseManager:attempt_give_initial_coins]")

	if self:total_coins_earned() == 0 then
		local initial_rewards = 10

		print("Adding initial coins! ", initial_rewards)
		self:add_coins(initial_rewards)
	end
end

-- Lines 151-154
function ConsolesSafehouseManager:get_coins_income()
	print("[ConsolesSafehouseManager:get_coins_income")

	return math.floor(Application:digest_value(self._global.total, false)) - math.floor(Application:digest_value(self._global.prev_total, false))
end

-- Lines 156-159
function ConsolesSafehouseManager:give_upgrade_points(exp)
	print("[ConsolesSafehouseManager:give_upgrade_points]: ", exp)
	self:add_coins(exp / self.rewards_experience_ratio)
end

-- Lines 168-170
function ConsolesSafehouseManager:add_coins_ingore_locked(amount)
end
