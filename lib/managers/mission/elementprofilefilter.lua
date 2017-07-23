core:import("CoreMissionScriptElement")

ElementProfileFilter = ElementProfileFilter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementProfileFilter:init(...)
	ElementProfileFilter.super.init(self, ...)
end

-- Lines: 10 to 11
function ElementProfileFilter:client_on_executed(...)
end

-- Lines: 13 to 40
function ElementProfileFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not self:_check_player_lvl() then
		return
	end

	if not self:_check_total_money_earned() then
		return
	end

	if not self:_check_total_money_offshore() then
		return
	end

	if not self:_check_achievement() then
		return
	end

	ElementProfileFilter.super.on_executed(self, instigator)
end

-- Lines: 42 to 45
function ElementProfileFilter:_check_player_lvl()
	local pass = self._values.player_lvl <= managers.experience:current_level()

	return pass
end

-- Lines: 48 to 51
function ElementProfileFilter:_check_total_money_earned()
	local pass = self._values.money_earned * 1000 <= managers.money:total_collected()

	return pass
end

-- Lines: 54 to 60
function ElementProfileFilter:_check_total_money_offshore()
	if not self._values.money_offshore then
		return false
	end

	local pass = self._values.money_offshore * 1000 <= managers.money:offshore()

	return pass
end

-- Lines: 63 to 71
function ElementProfileFilter:_check_achievement()
	if self._values.achievement == "none" then
		return true
	end

	local info = managers.achievment:get_info(self._values.achievement)
	local pass = info and info.awarded

	return pass
end

