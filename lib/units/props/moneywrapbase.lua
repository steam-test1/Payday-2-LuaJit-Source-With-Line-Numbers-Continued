MoneyWrapBase = MoneyWrapBase or class(UnitBase)
MoneyWrapBase.taken_wraps = MoneyWrapBase.taken_wraps or 0

-- Lines: 7 to 12
function MoneyWrapBase:init(unit)
	UnitBase.init(self, unit, false)

	self._unit = unit

	self:_setup()
end

-- Lines: 16 to 20
function MoneyWrapBase:_setup()
	self._MONEY_MAX = self.max_amount or 1000000
	self._money_amount = self._MONEY_MAX
	self._sequence_stage = 10
end

-- Lines: 24 to 51
function MoneyWrapBase:take_money(unit)
	if self._empty then
		return
	end

	if self.give_exp then
		unit:sound():play("money_grab")
		managers.network:session():send_to_peers_synched("sync_money_wrap_money_taken", self._unit)

		self._money_amount = 0
		MoneyWrapBase.taken_wraps = MoneyWrapBase.taken_wraps + 1
	else
		local taken = self:_take_money(unit)

		if taken > 0 then
			unit:sound():play("money_grab")
			managers.network:session():send_to_peers_synched("sync_money_wrap_money_taken", self._unit)
		end

		managers.money:perform_action_money_wrap(taken)
	end

	if self._money_amount <= 0 then
		self:_set_empty()
	end

	self:_update_sequences()
end

-- Lines: 53 to 68
function MoneyWrapBase:sync_money_taken()
	if self.give_exp then
		self._money_amount = 0
	else
		local amount = self.money_action and tweak_data:get_value("money_manager", "actions", self.money_action) or self._MONEY_MAX / 2

		managers.money:perform_action_money_wrap(amount)

		self._money_amount = math.max(self._money_amount - amount, 0)
	end

	if self._money_amount <= 0 then
		self:_set_empty()
	end

	self:_update_sequences()
end

-- Lines: 71 to 79
function MoneyWrapBase:_take_money(unit)
	local took = self.money_action and tweak_data:get_value("money_manager", "actions", self.money_action) or self._MONEY_MAX / 2
	self._money_amount = math.max(self._money_amount - took, 0)

	if self._money_amount <= 0 then
		self:_set_empty()
	end

	return took
end

-- Lines: 82 to 89
function MoneyWrapBase:_update_sequences()
	local stage = math.round(self._money_amount / self._MONEY_MAX * 9) + 1

	if stage < self._sequence_stage then
		self._sequence_stage = stage

		self._unit:damage():run_sequence_simple("money_wrap_" .. self._sequence_stage)
	end
end

-- Lines: 91 to 97
function MoneyWrapBase:_set_empty()
	self._empty = true

	if not self.skip_remove_unit then
		self._unit:set_slot(0)
	end
end

-- Lines: 102 to 103
function MoneyWrapBase:update(unit, t, dt)
end

-- Lines: 107 to 112
function MoneyWrapBase:save(data)
	MoneyWrapBase.super.save(self, data)

	local state = {money_amount = self._money_amount}
	data.MoneyWrapBase = state
end

-- Lines: 114 to 118
function MoneyWrapBase:load(data)
	MoneyWrapBase.super.load(self, data)

	local state = data.MoneyWrapBase
	self._money_amount = state.money_amount
end

-- Lines: 123 to 124
function MoneyWrapBase:destroy()
end

return
