core:import("CoreMissionScriptElement")

ElementMoney = ElementMoney or class(CoreMissionScriptElement.MissionScriptElement)
ElementMoney.NONE = "none"
ElementMoney.ADD_OFFSHORE = "AddOffshore"
ElementMoney.DEDUCT_OFFSHORE = "DeductOffshore"
ElementMoney.ADD_SPENDING = "AddSpending"
ElementMoney.DEDUCT_SPENDING = "DeductSpending"

-- Lines: 10 to 12
function ElementMoney:init(...)
	ElementMoney.super.init(self, ...)
end

-- Lines: 14 to 16
function ElementMoney:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 19 to 51
function ElementMoney:on_executed(instigator)
	if not self._values.enabled or not self._values.amount then
		return
	end

	if self._values.only_local_player and instigator ~= managers.player:local_player() then
		print("ElementMoney ", self, "can only run if the local player instigates the event!", instigator, managers.player:local_player())

		return
	end

	local action = self:value("action")
	local amount = self:value("amount")
	local remove_all = self:value("remove_all")

	if action == ElementMoney.ADD_OFFSHORE then
		managers.money:add_to_offshore(amount)
	elseif action == ElementMoney.DEDUCT_OFFSHORE then
		if remove_all then
			amount = managers.money:offshore()
		end

		managers.money:deduct_from_offshore(amount)
	elseif action == ElementMoney.ADD_SPENDING then
		managers.money:add_to_spending(amount)
	elseif action == ElementMoney.DEDUCT_SPENDING then
		if remove_all then
			amount = managers.money:total()
		end

		managers.money:deduct_from_spending(amount)
	elseif action ~= ElementMoney.NONE then
		managers.editor:output_error("Cant perform money action " .. action .. " in element " .. self._editor_name .. ".")
	end

	ElementMoney.super.on_executed(self, instigator)
end
ElementMoneyFilter = ElementMoneyFilter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 57 to 59
function ElementMoneyFilter:init(...)
	ElementMoneyFilter.super.init(self, ...)
end

-- Lines: 61 to 63
function ElementMoneyFilter:client_on_executed(...)
	self:on_executed(...)
end

-- Lines: 66 to 89
function ElementMoneyFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.only_local_player and instigator ~= managers.player:local_player() then
		print("ElementMoneyFilter ", self, "can only run if the local player instigates the event!", instigator, managers.player:local_player())

		return
	end

	local pass = false
	local account = self:value("account")

	if account == "offshore" then
		pass = self:_check_value(managers.money:offshore())
	elseif account == "spending" then
		pass = self:_check_value(managers.money:total())
	else
		Application:error("ElementMoneyFilter found an invalid account request: ", account, self)
	end

	if pass then
		ElementMoneyFilter.super.on_executed(self, instigator)
	end
end

-- Lines: 91 to 105
function ElementMoneyFilter:_check_value(account_amt)
	local value = self:value("value")
	local check_type = self:value("check_type")

	if check_type == "equal" then
		return account_amt == value
	elseif check_type == "less_than" then
		return account_amt < value
	elseif check_type == "greater_than" then
		return value < account_amt
	elseif check_type == "less_or_equal" then
		return account_amt <= value
	elseif check_type == "greater_or_equal" then
		return value <= account_amt
	end

	return false
end

return
