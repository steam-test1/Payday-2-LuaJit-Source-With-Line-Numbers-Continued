require("lib/utils/accelbyte/Telemetry")
require("lib/utils/accelbyte/TelemetryConst")

MoneyManager = MoneyManager or class()

-- Lines 9-11
function MoneyManager:init()
	self:_setup()
end

-- Lines 13-41
function MoneyManager:_setup()
	if not Global.money_manager then
		Global.money_manager = {
			total = Application:digest_value(0, true),
			total_collected = Application:digest_value(0, true),
			offshore = Application:digest_value(0, true),
			total_spent = Application:digest_value(0, true)
		}
	end

	self._global = Global.money_manager
	self._heist_total = 0
	self._heist_spending = 0
	self._heist_offshore = 0
	self._active_multipliers = {}
	self._stage_payout = 0
	self._job_payout = 0
	self._bag_payout = 0
	self._small_loot_payout = 0
	self._crew_payout = 0
	self._vehicle_payout = 0
	self._mutators_reduction = 0
	self._cash_tousand_separator = managers.localization:text("cash_tousand_separator")
	self._cash_sign = managers.localization:text("cash_sign")
	self._event_listener_holder = EventListenerHolder:new()
end

-- Lines 43-43
function MoneyManager:add_event_listener(...)
	self._event_listener_holder:add(...)
end

-- Lines 44-44
function MoneyManager:remove_event_listener(...)
	self._event_listener_holder:remove(...)
end

-- Lines 45-45
function MoneyManager:dispatch_event(...)
	self._event_listener_holder:call(...)
end

-- Lines 47-56
function MoneyManager:total_string_no_currency()
	local total = math.round(self:total())
	total = tostring(total)
	local reverse = string.reverse(total)
	local s = ""

	for i = 1, string.len(reverse) do
		s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and self._cash_tousand_separator or "")
	end

	return string.reverse(s)
end

-- Lines 58-67
function MoneyManager:total_string()
	local total = math.round(self:total())
	total = tostring(total)
	local reverse = string.reverse(total)
	local s = ""

	for i = 1, string.len(reverse) do
		s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and self._cash_tousand_separator or "")
	end

	return self._cash_sign .. string.reverse(s)
end

-- Lines 69-78
function MoneyManager:total_collected_string_no_currency()
	local total = math.round(self:total_collected())
	total = tostring(total)
	local reverse = string.reverse(total)
	local s = ""

	for i = 1, string.len(reverse) do
		s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and self._cash_tousand_separator or "")
	end

	return string.reverse(s)
end

-- Lines 80-89
function MoneyManager:total_collected_string()
	local total = math.round(self:total_collected())
	total = tostring(total)
	local reverse = string.reverse(total)
	local s = ""

	for i = 1, string.len(reverse) do
		s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and self._cash_tousand_separator or "")
	end

	return self._cash_sign .. string.reverse(s)
end

-- Lines 91-99
function MoneyManager:add_decimal_marks_to_string(string)
	local total = string
	local reverse = string.reverse(total)
	local s = ""

	for i = 1, string.len(reverse) do
		s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and self._cash_tousand_separator or "")
	end

	return string.reverse(s)
end

-- Lines 101-108
function MoneyManager:use_multiplier(multiplier)
	if not tweak_data.money_manager.multipliers[multiplier] then
		Application:error("Unknown multiplier \"" .. tostring(multiplier) .. " in money manager.")

		return
	end

	self._active_multipliers[multiplier] = tweak_data.money_manager.multipliers[multiplier]
end

-- Lines 110-117
function MoneyManager:remove_multiplier(multiplier)
	if not tweak_data.money_manager.multipliers[multiplier] then
		Application:error("Unknown multiplier \"" .. tostring(multiplier) .. " in money manager.")

		return
	end

	self._active_multipliers[multiplier] = nil
end

-- Lines 119-129
function MoneyManager:perform_action(action)
	return
end

-- Lines 131-140
function MoneyManager:perform_action_interact(name)
	return
end

-- Lines 142-144
function MoneyManager:perform_action_money_wrap(amount)
	self:_add(amount)
end

-- Lines 147-162
function MoneyManager:get_civilian_deduction()
	if managers.mutators:should_disable_statistics() then
		return 0
	end

	local has_active_job = managers.job:has_active_job()
	local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1

	if managers.crime_spree:is_active() then
		job_and_difficulty_stars = tweak_data.crime_spree.base_difficulty_index or job_and_difficulty_stars
	end

	local multiplier = 1
	multiplier = multiplier * managers.player:upgrade_value("player", "cleaner_cost_multiplier", 1)

	return math.round(self:get_tweak_value("money_manager", "killing_civilian_deduction", job_and_difficulty_stars) * multiplier)
end

-- Lines 164-176
function MoneyManager:civilian_killed()
	local deduct_amount = self:get_civilian_deduction()

	if deduct_amount == 0 then
		return
	end

	local text = managers.localization:text("hud_civilian_killed_message", {
		AMOUNT = managers.experience:cash_string(deduct_amount)
	})
	local title = managers.localization:text("hud_civilian_killed_title")

	managers.hud:present_mid_text({
		time = 4,
		text = text,
		title = title
	})
	self:_deduct_from_total(deduct_amount, TelemetryConst.economy_origin.civilian_killed)
end

-- Lines 180-219
function MoneyManager:on_mission_completed(num_winners)
	if managers.crime_spree:is_active() then
		managers.loot:clear_postponed_small_loot()

		return
	end

	if managers.job:skip_money() then
		managers.loot:set_postponed_small_loot()

		return
	end

	local stage_value, job_value, bag_value, vehicle_value, small_value, crew_value, total_payout, risk_table, payout_table, mutators_reduction = self:get_real_job_money_values(num_winners)

	managers.loot:clear_postponed_small_loot()
	self:_set_stage_payout(stage_value + risk_table.stage_risk)
	self:_set_job_payout(job_value + risk_table.job_risk)
	self:_set_bag_payout(bag_value + risk_table.bag_risk)
	self:_set_vehicle_payout(vehicle_value + risk_table.vehicle_risk)
	self:_set_small_loot_payout(small_value + risk_table.small_risk)
	self:_set_crew_payout(crew_value)

	self._mutators_reduction = mutators_reduction

	Telemetry:set_mission_payout(total_payout)
	self:_add_to_total(total_payout, nil, TelemetryConst.economy_origin.mission_complete_reward)
end

-- Lines 221-265
function MoneyManager:get_contract_money_by_stars(job_stars, risk_stars, job_days, job_id, level_id, extra_params)
	local job_and_difficulty_stars = job_stars + risk_stars
	local job_stars = job_stars
	local difficulty_stars = risk_stars
	local player_stars = managers.experience:level_to_stars()
	local params = {
		job_id = job_id,
		level_id = level_id,
		job_stars = job_stars,
		difficulty_stars = difficulty_stars,
		success = true,
		num_winners = 1,
		on_last_stage = true,
		player_stars = player_stars,
		bonus_bags_value = extra_params and extra_params.bonus_bags_value or 0,
		mandatory_bags_value = extra_params and extra_params.mandatory_bags_value or 0,
		small_value = extra_params and extra_params.small_value or 0,
		vehicle_value = extra_params and extra_params.vehicle_value or 0
	}
	local stage_value, job_value, bag_value, vehicle_value, small_value, crew_value, total_payout, risk_table, job_table = self:get_money_by_params(params)
	local stage_risk_value = risk_table.stage_risk
	local job_risk_value = risk_table.job_risk
	local total_stage_value = stage_value
	local total_stage_risk_value = stage_risk_value
	local total_job_value = job_value
	local total_job_risk_value = job_risk_value
	local base_payout = stage_value + job_value + bag_value + vehicle_value + small_value + crew_value
	local risk_payout = risk_table.stage_risk + risk_table.job_risk + risk_table.bag_risk + risk_table.vehicle_risk + risk_table.small_risk

	if base_payout + risk_payout ~= total_payout then
		Application:error("[MoneyManager:get_contract_money_by_stars] math not add up!", "total_payout", total_payout, "base_payout", base_payout, "risk_payout", risk_payout)

		total_payout = base_payout + risk_payout
	end

	return total_payout, base_payout, risk_payout
end

-- Lines 267-303
function MoneyManager:get_money_by_job(job_id, difficulty)
	if not job_id or not tweak_data.narrative.jobs[job_id] then
		Application:error("Error: Missing Job =", job_id)

		return 0, 0, 0
	end

	local tweak_job = tweak_data.narrative:job_data(job_id)

	if tweak_job.payout ~= nil then
		local tweak_payout = type(tweak_job.payout) == "table" and tweak_job.payout[1] or tweak_job.payout
		local tweak_multiplier = self:get_tweak_value("money_manager", "difficulty_multiplier_payout", difficulty) or 1
		local payout = tweak_payout * tweak_multiplier
		local base_payout = tweak_payout
		local risk_payout = payout - base_payout

		return payout, base_payout, risk_payout
	else
		local payout = 0
		local base_payout = 0
		local risk_payout = 0
		local job_chain = tweak_data.narrative:job_chain(job_id)

		for _, level in pairs(job_chain) do
			if tweak_data.levels[level.level_id] and tweak_data.levels[level.level_id].payout and tweak_data.levels[level.level_id].payout[difficulty] then
				local cash = tweak_data.levels[level.level_id].payout[difficulty] or 0
				local base_cash = tweak_data.levels[level.level_id].payout[1] or 0
				payout = payout + cash
				base_payout = base_payout + base_cash
				risk_payout = risk_payout + cash - base_cash
			end
		end

		return payout, base_payout, risk_payout
	end
end

-- Lines 305-526
function MoneyManager:get_money_by_params(params)
	local job_id = params.job_id
	local job_stars = params.job_stars or 0
	local difficulty_stars = params.difficulty_stars or params.risk_stars or 0
	local job_and_difficulty_stars = job_stars + difficulty_stars
	local success = params.success
	local num_winners = params.num_winners or 1
	local on_last_stage = params.on_last_stage
	local current_job_stage = params.current_stage or 1
	local total_stages = job_id and #tweak_data.narrative:job_chain(job_id) or 1
	local player_stars = params.player_stars or managers.experience:level_to_stars() or 0
	local total_stars = math.min(job_stars, player_stars)
	local total_difficulty_stars = difficulty_stars
	local money_multiplier = self:get_contract_difficulty_multiplier(total_difficulty_stars)
	local contract_money_multiplier = 1 + money_multiplier / 10
	local small_loot_multiplier = managers.money:get_small_loot_difficulty_multiplier(total_difficulty_stars) or 0
	local cash_skill_bonus, bag_skill_bonus = managers.player:get_skill_money_multiplier(managers.groupai and managers.groupai:state():whisper_mode())
	local bonus_bags = params.bonus_bags_value or managers.loot:get_secured_bonus_bags_value(params.level_id)
	local mandatory_bags = params.mandatory_bags_value or managers.loot:get_secured_mandatory_bags_value()
	local real_small_value = params.small_value or math.round(managers.loot:get_real_total_small_loot_value())
	local bonus_vehicles = params.vehicle_value or math.round(managers.loot:get_secured_bonus_bags_value(nil, true))
	local offshore_rate = self:get_tweak_value("money_manager", "offshore_rate")
	local total_payout = 0
	local stage_value = 0
	local job_value = 0
	local bag_value = 0
	local vehicle_value = 0
	local small_value = 0
	local crew_value = 0
	local stage_risk = 0
	local job_risk = 0
	local bag_risk = 0
	local vehicle_risk = 0
	local small_risk = 0
	local static_value, base_static_value, risk_static_value = self:get_money_by_job(job_id, difficulty_stars + 1)
	static_value = static_value * cash_skill_bonus
	base_static_value = static_value - risk_static_value

	if static_value then
		small_value = real_small_value + managers.loot:get_real_total_postponed_small_loot_value()

		if tweak_data:get_value("money_manager", "max_small_loot_value") < small_value then
			print("[MoneyManager:get_money_by_params] - Small Loot drop was too much", small_value, tweak_data.carry.max_small_loot_value)

			small_value = tweak_data:get_value("money_manager", "max_small_loot_value")
		end

		if on_last_stage then
			bag_value = bonus_bags
			bag_risk = math.round(bag_value * money_multiplier * bag_skill_bonus)
			bag_value = (bag_value + mandatory_bags) * bag_skill_bonus
			vehicle_value = bonus_vehicles
			vehicle_risk = math.round(vehicle_value * money_multiplier)
			total_payout = math.max(0, math.round((static_value + bag_value + bag_risk + vehicle_value + vehicle_risk) / offshore_rate + small_value))
			stage_value = 0
			bag_value = math.max(0, math.round(bag_value / offshore_rate))
			bag_risk = math.max(0, math.round(bag_risk / offshore_rate))
			vehicle_value = math.max(0, math.round(vehicle_value / offshore_rate))
			vehicle_risk = math.max(0, math.round(vehicle_risk / offshore_rate))
			crew_value = total_payout
			total_payout = math.max(0, math.round(total_payout * self:get_tweak_value("money_manager", "alive_humans_multiplier", num_winners)))
			crew_value = total_payout - crew_value
		else
			total_payout = small_value
		end

		local limited_bonus = self:get_tweak_value("money_manager", "limited_bonus_multiplier") or 1

		if limited_bonus > 1 then
			stage_value = stage_value * limited_bonus
			stage_risk = stage_risk * limited_bonus
			bag_value = bag_value * limited_bonus
			bag_risk = bag_risk * limited_bonus
			vehicle_value = vehicle_value * limited_bonus
			vehicle_risk = vehicle_risk * limited_bonus
			small_value = small_value * limited_bonus
			small_risk = small_risk * limited_bonus
			crew_value = crew_value * limited_bonus
			total_payout = total_payout * limited_bonus
		end

		if on_last_stage then
			job_risk = math.max(0, math.round(risk_static_value / offshore_rate))
			job_value = math.max(0, math.round(static_value / offshore_rate) - job_risk)
		end

		if managers.skirmish:is_skirmish() then
			local skirmish_payout = managers.skirmish:current_ransom_amount()
			total_payout = math.max(0, math.round(total_payout + skirmish_payout))
		end
	else
		stage_value = self:get_stage_payout_by_stars(total_stars) or 0
		local mandatory_bag_value = 0
		local bonus_bag_value = 0
		small_value = real_small_value + managers.loot:get_real_total_postponed_small_loot_value()

		if on_last_stage then
			job_value = self:get_job_payout_by_stars(total_stars) or 0
			bonus_bag_value = bonus_bags
			mandatory_bag_value = mandatory_bags
		end

		local is_level_limited = player_stars < job_stars

		if is_level_limited and stage_value > 0 then
			local unlimited_stage_value = self:get_stage_payout_by_stars(job_stars) or 0
			local unlimited_job_value = 0
			local unlimited_bonus_bag_value = 0
			local unlimited_mandatory_bag_value = 0
			local unlimited_small_value = real_small_value

			if managers.job:on_last_stage() then
				unlimited_job_value = self:get_job_payout_by_stars(job_stars) or 0
				unlimited_bonus_bag_value = bonus_bags * self:get_tweak_value("money_manager", "bag_value_multiplier", job_stars)
				unlimited_mandatory_bag_value = mandatory_bags
			end

			local unlimited_payout = unlimited_stage_value + unlimited_job_value + unlimited_bonus_bag_value + unlimited_mandatory_bag_value + unlimited_small_value
			total_payout = math.round(stage_value + job_value + bonus_bag_value + mandatory_bag_value + small_value)
			local diff_in_money = unlimited_payout - total_payout
			local diff_in_stars = job_stars - player_stars
			local tweak_multiplier = self:get_tweak_value("money_manager", "level_limit", "pc_difference_multipliers", diff_in_stars) or 0
			local new_total_payout = total_payout + math.round(diff_in_money * tweak_multiplier)
			local stage_ratio = stage_value / total_payout
			local small_ratio = small_value / total_payout
			local bonus_bag_ratio = bonus_bag_value / total_payout
			local mandatory_bag_ratio = mandatory_bag_value / total_payout
			local job_ratio = job_value / total_payout
			stage_value = math.round(new_total_payout * stage_ratio)
			small_value = math.round(new_total_payout * small_ratio)
			bonus_bag_value = math.round(new_total_payout * bonus_bag_ratio * bag_skill_bonus)
			mandatory_bag_value = math.round(new_total_payout * mandatory_bag_ratio * bag_skill_bonus)
			job_value = math.round(new_total_payout * job_ratio)
			local rounding_error = new_total_payout - (stage_value + small_value + bonus_bag_value + mandatory_bag_value + job_value)
			job_value = job_value + rounding_error
		end

		stage_risk = math.round(stage_value * contract_money_multiplier)
		job_risk = math.round(job_value * contract_money_multiplier)
		bag_risk = math.round(bonus_bag_value * money_multiplier)
		small_risk = math.round(small_value * small_loot_multiplier)
		total_payout = stage_value + job_value + bonus_bag_value + mandatory_bag_value + small_value
		total_payout = total_payout + stage_risk + job_risk + bag_risk + small_risk
		crew_value = math.round(total_payout)
		total_payout = math.round(total_payout * (self:get_tweak_value("money_manager", "alive_humans_multiplier", num_winners) or 1))
		crew_value = math.round(total_payout - crew_value)

		if not static_value then
			total_payout = total_payout + self:get_tweak_value("money_manager", "flat_stage_completion")
			stage_value = stage_value + self:get_tweak_value("money_manager", "flat_stage_completion")

			if on_last_stage then
				total_payout = total_payout + self:get_tweak_value("money_manager", "flat_job_completion")
				job_value = job_value + self:get_tweak_value("money_manager", "flat_job_completion")
			end
		end

		local bag_value = math.round((bonus_bag_value + mandatory_bag_value) / offshore_rate)
		bag_risk = math.round(bag_risk / offshore_rate)
	end

	local mutators_multiplier = managers.mutators:get_cash_multiplier()
	local original_total_payout = total_payout
	total_payout = total_payout * mutators_multiplier
	stage_value = stage_value * mutators_multiplier
	job_value = job_value * mutators_multiplier
	bag_value = bag_value * mutators_multiplier
	vehicle_value = vehicle_value * mutators_multiplier
	small_value = small_value * mutators_multiplier
	crew_value = crew_value * mutators_multiplier
	stage_risk = stage_risk * mutators_multiplier
	job_risk = job_risk * mutators_multiplier
	bag_risk = bag_risk * mutators_multiplier
	vehicle_risk = vehicle_risk * mutators_multiplier
	small_risk = small_risk * mutators_multiplier
	local mutators_reduction = original_total_payout - total_payout
	local ret = {
		stage_value,
		job_value,
		bag_value,
		vehicle_value,
		small_value,
		crew_value,
		total_payout,
		{
			stage_risk = stage_risk,
			job_risk = job_risk,
			bag_risk = bag_risk,
			vehicle_risk = vehicle_risk,
			small_risk = small_risk
		},
		{
			job_base_payout = base_static_value,
			job_risk_payout = risk_static_value
		},
		mutators_reduction
	}

	return unpack(ret)
end

-- Lines 528-550
function MoneyManager:get_real_job_money_values(num_winners, potential_payout)
	local has_active_job = managers.job:has_active_job()
	local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
	local job_id = managers.job:current_job_id()
	local level_id = managers.job:current_level_id()
	local job_stars = has_active_job and managers.job:current_job_stars() or 1
	local difficulty_stars = has_active_job and managers.job:current_difficulty_stars() or 0
	local current_stage = has_active_job and managers.job:current_stage() or 1
	local is_professional = has_active_job and managers.job:is_current_job_professional() or false
	local on_last_stage = potential_payout and true or has_active_job and managers.job:on_last_stage()

	return self:get_money_by_params({
		success = true,
		job_id = job_id,
		level_id = level_id,
		job_stars = job_stars,
		difficulty_stars = difficulty_stars,
		current_stage = current_stage,
		professional = is_professional,
		num_winners = num_winners,
		on_last_stage = on_last_stage
	})
end

-- Lines 552-564
function MoneyManager:get_secured_bonus_bags_money()
	local job_id = managers.job:current_job_id()
	local stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
	local money_multiplier = self:get_contract_difficulty_multiplier(stars)
	local total_stages = job_id and #tweak_data.narrative:job_chain(job_id) or 1
	local bag_skill_bonus = managers.player:upgrade_value("player", "secured_bags_money_multiplier", 1)
	local bonus_bags = managers.loot:get_secured_bonus_bags_value(managers.job:current_level_id()) + managers.loot:get_secured_bonus_bags_value(managers.job:current_level_id(), true)
	local bag_value = bonus_bags
	local bag_risk = math.round(bag_value * money_multiplier)

	return math.round((bag_value + bag_risk) * bag_skill_bonus / self:get_tweak_value("money_manager", "offshore_rate"))
end

-- Lines 566-571
function MoneyManager:get_secured_mandatory_bags_money()
	local mandatory_value = managers.loot:get_secured_mandatory_bags_value()
	local bag_skill_bonus = managers.player:upgrade_value("player", "secured_bags_money_multiplier", 1)

	return math.round(mandatory_value * bag_skill_bonus / self:get_tweak_value("money_manager", "offshore_rate"))
end

-- Lines 573-593
function MoneyManager:get_secured_bonus_bag_value(carry_id, multiplier)
	local carry_value = managers.money:get_bag_value(carry_id, multiplier)
	local bag_value = 0
	local bag_risk = 0
	local bag_skill_bonus = managers.player:upgrade_value("player", "secured_bags_money_multiplier", 1)

	if managers.loot:is_bonus_bag(carry_id) then
		local job_id = managers.job:current_job_id()
		local stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
		local money_multiplier = self:get_contract_difficulty_multiplier(stars)
		local total_stages = job_id and #tweak_data.narrative:job_chain(job_id) or 1
		bag_value = carry_value
		bag_risk = math.round(bag_value * money_multiplier)
	else
		bag_value = carry_value
	end

	return math.round((bag_value + bag_risk) * bag_skill_bonus / self:get_tweak_value("money_manager", "offshore_rate"))
end

-- Lines 595-600
function MoneyManager:get_job_bag_value()
	local has_active_job = managers.job:has_active_job()
	local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1

	return self:get_tweak_value("money_manager", "bag_value_multiplier", job_and_difficulty_stars)
end

-- Lines 602-613
function MoneyManager:get_bag_value(carry_id, multiplier)
	local value = tweak_data.carry.small_loot[carry_id]

	if value then
		value = value * (multiplier or 1)
	else
		local bag_value_id = tweak_data.carry[carry_id].bag_value or "default"
		value = self:get_tweak_value("money_manager", "bag_values", bag_value_id)
	end

	return math.round(value)
end

-- Lines 617-621
function MoneyManager:debug_job_completed(stars)
	local amount = self:get_tweak_value("money_manager", "job_completion", stars)

	self:_add_to_total(amount, nil, TelemetryConst.debug.economy_origin.job_completed)
end

-- Lines 623-630
function MoneyManager:get_job_payout_by_stars(stars, cap_stars)
	if cap_stars then
		stars = math.clamp(stars, 1, #tweak_data.money_manager.stage_completion)
	end

	local amount = self:get_tweak_value("money_manager", "job_completion", stars)

	return amount
end

-- Lines 632-639
function MoneyManager:get_stage_payout_by_stars(stars, cap_stars)
	if cap_stars then
		stars = math.clamp(stars, 1, #tweak_data.money_manager.stage_completion)
	end

	local amount = self:get_tweak_value("money_manager", "stage_completion", stars)

	return amount
end

-- Lines 641-647
function MoneyManager:get_small_loot_difficulty_multiplier(stars)
	if stars > 0 then
		return self:get_tweak_value("money_manager", "small_loot_difficulty_multiplier", stars)
	end

	return 0
end

-- Lines 649-651
function MoneyManager:get_contract_difficulty_multiplier(stars)
	return self:get_tweak_value("money_manager", "difficulty_multiplier", stars + 1) or 1
end

-- Lines 653-675
function MoneyManager:get_potential_payout_from_current_stage()
	local stage_value, job_value, bag_value, vehicle_value, small_value, crew_value, total_payout = self:get_real_job_money_values(1, true)

	return total_payout
end

-- Lines 679-681
function MoneyManager:can_afford_weapon(weapon_id)
	return self:get_weapon_price_modified(weapon_id) <= self:total()
end

-- Lines 683-705
function MoneyManager:get_weapon_price(weapon_id)
	local pc = self:_get_weapon_pc(weapon_id)

	if not tweak_data.money_manager.weapon_cost[pc] then
		if pc and pc > #tweak_data.money_manager.weapon_cost then
			pc = #tweak_data.money_manager.weapon_cost
		else
			pc = 1
		end
	end

	local cost = self:get_tweak_value("money_manager", "weapon_cost", pc)
	local cost_multiplier = 1
	local weapon_tweak_data = tweak_data.weapon[weapon_id]
	local category = weapon_tweak_data and weapon_tweak_data.categories[1]
	cost_multiplier = cost_multiplier * (category and tweak_data.upgrades.weapon_cost_multiplier[category] or 1)

	return math.round(cost * cost_multiplier)
end

-- Lines 707-731
function MoneyManager:get_weapon_price_modified(weapon_id)
	local pc = self:_get_weapon_pc(weapon_id)

	if not tweak_data.money_manager.weapon_cost[pc] then
		if pc and pc > #tweak_data.money_manager.weapon_cost then
			pc = #tweak_data.money_manager.weapon_cost
		else
			pc = 1
		end
	end

	local cost = self:get_tweak_value("money_manager", "weapon_cost", pc)
	local cost_multiplier = 1
	cost_multiplier = cost_multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
	cost_multiplier = cost_multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)
	local weapon_tweak_data = tweak_data.weapon[weapon_id]
	local category = weapon_tweak_data and weapon_tweak_data.categories[1]
	cost_multiplier = cost_multiplier * (category and tweak_data.upgrades.weapon_cost_multiplier[category] or 1)

	return math.round(cost * cost_multiplier)
end

-- Lines 733-758
function MoneyManager:get_weapon_slot_sell_value(category, slot)
	local crafted_item = managers.blackmarket:get_crafted_category_slot(category, slot)

	if not crafted_item then
		return 0
	end

	local weapon_id = crafted_item.weapon_id
	local blueprint = crafted_item.blueprint
	local base_value = self:get_weapon_price(weapon_id)
	local parts_value = 0

	return math.round((base_value + parts_value) * self:get_tweak_value("money_manager", "sell_weapon_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

-- Lines 760-763
function MoneyManager:get_weapon_sell_value(weapon_id)
	return math.round(self:get_weapon_price(weapon_id) * self:get_tweak_value("money_manager", "sell_weapon_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

-- Lines 765-785
function MoneyManager:_get_weapon_pc(weapon_id)
	local weapon_data = managers.blackmarket:get_weapon_data(weapon_id) or {}
	local weapon_level = weapon_data.level

	if not weapon_level then
		Application:error("DIDN'T FIND LEVEL FOR", weapon_id)

		weapon_level = 1
	end

	local pc = math.ceil(weapon_level)

	return pc
end

-- Lines 787-792
function MoneyManager:on_buy_weapon_platform(weapon_id, discount)
	local amount = self:get_weapon_price_modified(weapon_id)

	self:_deduct_from_total(math.round(amount * (discount and self:get_tweak_value("money_manager", "sell_weapon_multiplier") or 1)), TelemetryConst.economy_origin.buy_weapon_platform .. weapon_id)
end

-- Lines 794-799
function MoneyManager:on_sell_weapon(category, slot)
	local amount = self:get_weapon_slot_sell_value(category, slot)

	self:_add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.sell_weapon .. category)
end

-- Lines 802-820
function MoneyManager:get_weapon_part_sell_value(part_id, global_value)
	local part = tweak_data.weapon.factory.parts[part_id]
	local mod_price = 1000

	if part then
		local pc_value = self:_get_pc_entry(part)

		if pc_value then
			local star_value = math.ceil(pc_value / 10)
			mod_price = self:get_tweak_value("money_manager", "modify_weapon_cost", star_value)
		end

		local stats_value = part.stats
		stats_value = stats_value and stats_value.value or 1
		mod_price = mod_price * tweak_data.weapon.stats.value[math.clamp(stats_value, 1, #tweak_data.weapon.stats.value)]
	end

	return math.round(mod_price * self:get_tweak_value("money_manager", "sell_weapon_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

-- Lines 822-826
function MoneyManager:on_sell_weapon_part(part_id, global_value)
	local amount = self:get_weapon_part_sell_value(part_id, global_value)

	Application:debug("value of removed weapon part", amount)
	self:_add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.sell_weapon_part .. part_id)
end

-- Lines 828-831
function MoneyManager:on_sell_weapon_slot(category, slot)
	local amount = self:get_weapon_slot_sell_value(category, slot)

	self._add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.sell_weapon_slot)
end

-- Lines 835-837
function MoneyManager:can_afford_mission_asset(asset_id)
	return self:get_mission_asset_cost_by_id(asset_id) <= self:total()
end

-- Lines 839-846
function MoneyManager:on_buy_mission_asset(asset_id)
	local amount = self:get_mission_asset_cost_by_id(asset_id)

	self:_deduct_from_total(amount, TelemetryConst.economy_origin.buy_mission_asset .. asset_id)

	return amount
end

-- Lines 848-851
function MoneyManager:refund_mission_asset(asset_id)
	local amount = self:get_mission_asset_cost_by_id(asset_id)

	self:_add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.refund_mission_asset)
end

-- Lines 855-857
function MoneyManager:can_afford_spend_skillpoint(tree, tier, points)
	return self:get_skillpoint_cost(tree, tier, points) <= self:total()
end

-- Lines 858-860
function MoneyManager:can_afford_respec_skilltree(tree)
	return true
end

-- Lines 862-866
function MoneyManager:on_skillpoint_spent(tree, tier, points)
	local amount = self:get_skillpoint_cost(tree, tier, points)

	self:_deduct_from_total(amount, TelemetryConst.economy_origin.skillpoint_spent .. tree)
end

-- Lines 868-874
function MoneyManager:on_respec_skilltree(tree, forced_respec_multiplier)
	local amount = self:get_skilltree_tree_respec_cost(tree, forced_respec_multiplier)

	self:_add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.respec_skilltree .. tree)
end

-- Lines 878-893
function MoneyManager:refund_weapon_part(weapon_id, part_id, global_value)
	local pc_value = tweak_data.blackmarket.weapon_mods and tweak_data.blackmarket.weapon_mods[part_id] and tweak_data.blackmarket.weapon_mods[part_id].value or 1
	local mod_price = self:get_tweak_value("money_manager", "modify_weapon_cost", pc_value)
	local gv_tweak_data = tweak_data.lootdrop.global_values[global_value or "normal"]
	local global_value_multiplier = gv_tweak_data and gv_tweak_data.value_multiplier or 1

	self:_add_to_total(math.round(mod_price * global_value_multiplier), {
		no_offshore = true
	}, TelemetryConst.economy_origin.refund_weapon_part .. weapon_id .. "_" .. part_id)
end

-- Lines 895-928
function MoneyManager:get_weapon_modify_price(weapon_id, part_id, global_value)
	local star_value = nil
	local pc_value = tweak_data.blackmarket.weapon_mods and tweak_data.blackmarket.weapon_mods[part_id] and tweak_data.blackmarket.weapon_mods[part_id].value or 1
	local mod_price = self:get_tweak_value("money_manager", "modify_weapon_cost", pc_value)
	local gv_tweak_data = tweak_data.lootdrop.global_values[global_value or "normal"]
	local global_value_multiplier = gv_tweak_data and gv_tweak_data.value_multiplier or 1
	local cost_multiplier = 1
	local crafting_multiplier = managers.player:upgrade_value("player", "passive_crafting_weapon_multiplier", 1)
	crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crafting_weapon_multiplier", 1)
	crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
	crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)
	local weapon_tweak_data = tweak_data.weapon[weapon_id]
	local category = weapon_tweak_data and weapon_tweak_data.categories[1]
	cost_multiplier = cost_multiplier * (category and tweak_data.upgrades.weapon_cost_multiplier[category] or 1)
	local total_price = mod_price * crafting_multiplier * global_value_multiplier * cost_multiplier

	return math.round(total_price)
end

-- Lines 930-932
function MoneyManager:can_afford_weapon_modification(weapon_id, part_id, global_value)
	return self:get_weapon_modify_price(weapon_id, part_id, global_value) <= self:total()
end

-- Lines 934-938
function MoneyManager:on_buy_weapon_modification(weapon_id, part_id, global_value)
	local amount = self:get_weapon_modify_price(weapon_id, part_id, global_value)

	self:_deduct_from_total(amount, TelemetryConst.economy_origin.buy_weapon_modification .. weapon_id .. "_" .. part_id)
end

-- Lines 942-964
function MoneyManager:_get_pc_entry(entry)
	if not entry then
		Application:error("MoneyManager:_get_pc_entry. No entry")

		return 5
	end

	local pcs = entry.pcs
	local pc_value = nil

	if not pcs then
		local pc = entry.pc

		if pc then
			pc_value = pc
		end
	else
		pc_value = pcs[1]

		for _, pcv in ipairs(pcs) do
			pc_value = math.min(pc_value, pcv)
		end
	end

	return pc_value
end

-- Lines 968-974
function MoneyManager:get_buy_mask_slot_price()
	local multiplier = 1
	multiplier = multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
	multiplier = multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)

	return self:get_tweak_value("money_manager", "unlock_new_mask_slot_value")
end

-- Lines 976-978
function MoneyManager:can_afford_buy_mask_slot()
	return self:get_buy_mask_slot_price() <= self:total()
end

-- Lines 980-983
function MoneyManager:on_buy_mask_slot(slot)
	local amount = self:get_buy_mask_slot_price()

	self:_deduct_from_total(amount, TelemetryConst.economy_origin.buy_mask_slot)
end

-- Lines 987-993
function MoneyManager:get_buy_weapon_slot_price()
	local multiplier = 1
	multiplier = multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
	multiplier = multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)

	return self:get_tweak_value("money_manager", "unlock_new_weapon_slot_value")
end

-- Lines 995-997
function MoneyManager:can_afford_buy_weapon_slot()
	return self:get_buy_weapon_slot_price() <= self:total()
end

-- Lines 999-1002
function MoneyManager:on_buy_weapon_slot(slot)
	local amount = self:get_buy_weapon_slot_price()

	self:_deduct_from_total(amount, TelemetryConst.economy_origin.buy_weapon_slot)
end

-- Lines 1005-1012
function MoneyManager:get_mask_crafting_multipliers()
	local crafting_multiplier = managers.player:upgrade_value("player", "passive_crafting_mask_multiplier", 1)
	crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crafting_mask_multiplier", 1)
	crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
	crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)

	return crafting_multiplier
end

-- Lines 1014-1020
function MoneyManager:get_mask_part_price_modified(category, id, global_value, mask_id)
	local mask_part_price = self:get_mask_part_price(category, id, global_value, mask_id)
	local crafting_multiplier = self:get_mask_crafting_multipliers()
	local total_price = mask_part_price * crafting_multiplier

	return math.round(total_price)
end

-- Lines 1022-1028
function MoneyManager:get_mask_crafting_price_modified(mask_id, global_value, blueprint, default_blueprint)
	local mask_price = self:get_mask_crafting_price(mask_id, global_value, blueprint, default_blueprint)
	local crafting_multiplier = self:get_mask_crafting_multipliers()
	local total_price = mask_price * crafting_multiplier

	return math.round(total_price)
end

-- Lines 1030-1036
function MoneyManager:get_mask_base_value_modified(mask_id, global_value)
	local base_value = self:get_mask_base_value(mask_id, global_value)
	local crafting_multiplier = self:get_mask_crafting_multipliers()
	local total_value = base_value * crafting_multiplier

	return math.round(total_value)
end

-- Lines 1038-1074
function MoneyManager:get_mask_part_price(category, id, global_value, mask_id)
	local cached_part_id = self:get_cached_mask_part_id(category, id, global_value, mask_id)
	self._cached_mask_part_prices = self._cached_mask_part_prices or {}

	if self._cached_mask_part_prices[cached_part_id] then
		return self._cached_mask_part_prices[cached_part_id]
	end

	local mask_default_blueprint = mask_id and managers.blackmarket:get_mask_default_blueprint(mask_id)

	if mask_default_blueprint and mask_default_blueprint[category] and mask_default_blueprint[category].id == id then
		return 0
	end

	local part_name_converter = {
		colors = "color",
		materials = "material",
		textures = "pattern"
	}
	part_name_converter.color_a = part_name_converter.colors
	part_name_converter.color_b = part_name_converter.colors
	part_name_converter.mask_colors = part_name_converter.colors
	part_name_converter.colors = nil
	local gv_tweak_data = tweak_data.lootdrop.global_values[global_value or "normal"]
	local gv_multiplier = gv_tweak_data and gv_tweak_data.value_multiplier or 1

	if category == "mask_colors" then
		gv_multiplier = gv_multiplier * 0.5
	end

	local value = tweak_data.blackmarket[category] and tweak_data.blackmarket[category][id] and tweak_data.blackmarket[category][id].value or 1
	local part_value = value > 0 and self:get_tweak_value("money_manager", "masks", part_name_converter[category] .. "_value", value) or 0
	local price = math.round(part_value * gv_multiplier)
	self._cached_mask_part_prices[cached_part_id] = price

	return price
end

-- Lines 1076-1122
function MoneyManager:get_mask_crafting_price(mask_id, global_value, blueprint, default_blueprint)
	local bonus_global_values = {
		infamous = 0,
		exceptional = 0,
		superior = 0,
		normal = 0
	}
	default_blueprint = default_blueprint or managers.blackmarket:get_mask_default_blueprint(mask_id) or {}
	blueprint = blueprint or default_blueprint
	local pc_value = tweak_data.blackmarket.masks and tweak_data.blackmarket.masks[mask_id] and tweak_data.blackmarket.masks[mask_id].value or 1
	local mask_gv = global_value or "normal"
	local base_value = self:get_mask_base_value(mask_id, global_value)
	bonus_global_values[mask_gv] = (bonus_global_values[mask_gv] or 0) + 1

	-- Lines 1090-1103
	local function get_part_price(category, data)
		if not data then
			return 0
		end

		local id = data.id
		local gv = data.global_value

		if not default_blueprint[category] or default_blueprint[category].id ~= id then
			return self:get_mask_part_price(category, id, gv or "normal", mask_id)
		end

		return 0
	end

	local pattern_price = get_part_price("textures", blueprint.pattern)
	local material_price = get_part_price("materials", blueprint.material)
	local color_a_price = get_part_price("mask_colors", blueprint.color_a)
	local color_b_price = get_part_price("mask_colors", blueprint.color_b)

	if blueprint.color_a and blueprint.color_b and blueprint.color_a.id == blueprint.color_b.id then
		color_b_price = 0
	end

	local parts_value = pattern_price + material_price + color_a_price + color_b_price

	return math.round(base_value + parts_value), bonus_global_values
end

-- Lines 1124-1139
function MoneyManager:get_mask_base_value(mask_id, global_value)
	local pc_value = tweak_data.blackmarket.masks[mask_id] and tweak_data.blackmarket.masks[mask_id].value or 1
	local mask_gv = global_value or "normal"
	local base_value = nil

	if pc_value > 0 then
		local gv_tweak_data = tweak_data.lootdrop.global_values[mask_gv]
		local global_value_multiplier = gv_tweak_data and gv_tweak_data.value_multiplier or 1
		base_value = self:get_tweak_value("money_manager", "masks", "mask_value", pc_value) * global_value_multiplier
	else
		base_value = 0
	end

	return base_value
end

-- Lines 1141-1156
function MoneyManager:get_mask_sell_value(mask_id, global_value, blueprint)
	local sell_value, bonuses = self:get_mask_crafting_price(mask_id, global_value, blueprint)

	if sell_value == 0 then
		return sell_value
	end

	local bonus_multiplier = nil

	for gv, amount in pairs(bonuses) do
		bonus_multiplier = (self:get_tweak_value("money_manager", "global_value_bonus_multiplier", gv) or 0) * math.max(amount - 1, 0)
		sell_value = sell_value + sell_value * bonus_multiplier
	end

	return math.round(sell_value * (self:get_tweak_value("money_manager", "sell_mask_multiplier") or 0) * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

-- Lines 1158-1164
function MoneyManager:get_mask_slot_sell_value(slot)
	local mask = managers.blackmarket:get_crafted_category_slot("masks", slot)

	if not mask then
		return 0
	end

	return math.round(self:get_mask_sell_value(mask.mask_id, mask.global_value, mask.blueprint))
end

-- Lines 1166-1168
function MoneyManager:can_afford_mask_crafting(mask_id, global_value, blueprint)
	return self:get_mask_crafting_price_modified(mask_id, global_value, blueprint) <= self:total()
end

-- Lines 1170-1173
function MoneyManager:on_buy_mask(mask_id, global_value, blueprint, default_blueprint)
	local amount = self:get_mask_crafting_price_modified(mask_id, global_value, blueprint, default_blueprint)

	self:_deduct_from_total(amount, TelemetryConst.economy_origin.buy_mask .. mask_id)
end

-- Lines 1175-1178
function MoneyManager:on_sell_mask(mask_id, global_value, blueprint)
	local amount = self:get_mask_sell_value(mask_id, global_value, blueprint)

	self:_add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.sell_mask .. mask_id)
end

-- Lines 1180-1182
function MoneyManager:get_loot_drop_cash_value(value_id)
	return self:get_tweak_value("money_manager", "loot_drop_cash", value_id) or 100
end

-- Lines 1184-1188
function MoneyManager:on_loot_drop_cash(value_id)
	local amount = self:get_loot_drop_cash_value(value_id)

	self:_add_to_total(amount, {
		no_offshore = true
	}, TelemetryConst.economy_origin.loot_drop_cash)
end

-- Lines 1190-1193
function MoneyManager:on_loot_drop_offshore(value_id)
	local amount = self:get_loot_drop_cash_value(value_id)

	self:add_to_offshore(amount)
end

-- Lines 1195-1197
function MoneyManager:get_cached_mask_part_id(category, id, global_value, mask_id)
	return Idstring(string.format("%s%s%s%s", category, id, global_value, mask_id)):key()
end

-- Lines 1199-1206
function MoneyManager:get_tweak_value(...)
	local value = tweak_data:get_value(...)

	if not value then
		Application:error("[MoneyManager:get_tweak_value] tweak data value non existent!", inspect({
			...
		}))
		Application:stack_dump()
	end

	return value or 0
end

-- Lines 1210-1225
function MoneyManager:get_preplanning_type_cost(type)
	local cost = self:get_tweak_value("preplanning", "types", type, "cost") or 0
	local has_active_job = managers.job:has_active_job()
	local difficulty_stars = (has_active_job and managers.job:current_difficulty_stars() or 0) + 1
	cost = cost * (self:get_tweak_value("money_manager", "preplaning_asset_cost_multiplier_by_risk", difficulty_stars) or 1)
	cost = cost * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "assets_cost_multiplier_b", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1)

	return math.round(cost)
end

-- Lines 1227-1233
function MoneyManager:can_afford_preplanning_type(type)
	local cost = self:get_preplanning_type_cost(type)
	local reserved_cost = managers.preplanning:get_reserved_local_cost()

	return self:total() >= cost + reserved_cost
end

-- Lines 1235-1238
function MoneyManager:on_buy_preplanning_types()
	local cost = self:get_preplanning_types_cost()

	self:_deduct_from_total(cost, TelemetryConst.economy_origin.buy_preplanning_types)
end

-- Lines 1240-1242
function MoneyManager:get_preplanning_types_cost()
	return managers.preplanning:get_reserved_local_cost() or 0
end

-- Lines 1244-1251
function MoneyManager:get_preplanning_votes_cost()
	local total_cost = 0
	local plans = managers.preplanning:get_current_majority_votes()

	for plan, data in pairs(plans) do
		total_cost = total_cost + self:get_preplanning_type_cost(data[1])
	end

	return total_cost
end

-- Lines 1253-1255
function MoneyManager:get_preplanning_total_cost()
	return self:get_preplanning_types_cost() + self:get_preplanning_votes_cost()
end

-- Lines 1257-1260
function MoneyManager:on_buy_preplanning_votes()
	local total_cost = self:get_preplanning_votes_cost()

	self:_deduct_from_total(total_cost, TelemetryConst.economy_origin.buy_preplanning_votes)
end

-- Lines 1264-1287
function MoneyManager:get_skillpoint_cost(tree, tier, points)
	local respec_tweak_data = tweak_data.money_manager.skilltree.respec
	local exp_cost = 0
	local tier_cost = not tier and 0 or self:get_tweak_value("money_manager", "skilltree", "respec", "point_tier_cost", tier) * points
	local cost = self:get_tweak_value("money_manager", "skilltree", "respec", "base_point_cost") + tier_cost

	if managers.experience:current_rank() > 0 then
		for infamy, item in pairs(tweak_data.infamy.items) do
			if managers.infamy:owned(infamy) and item.upgrades and item.upgrades.skillcost then
				cost = cost * item.upgrades.skillcost.multiplier or 1
			end
		end
	end

	return math.round(cost)
end

-- Lines 1289-1337
function MoneyManager:get_skilltree_tree_respec_cost(tree, forced_respec_multiplier)
	local base_point_cost = self:get_tweak_value("money_manager", "skilltree", "respec", "base_point_cost")
	local value = base_point_cost

	for id, tier in ipairs(tweak_data.skilltree.trees[tree].tiers) do
		for _, skill_id in ipairs(tier) do
			local step = managers.skilltree:skill_step(skill_id)

			if step > 0 then
				for i = 1, step do
					value = value + base_point_cost + managers.skilltree:get_skill_points(skill_id, i) * self:get_tweak_value("money_manager", "skilltree", "respec", "point_tier_cost", id)
				end
			end
		end
	end

	return math.round(value * (forced_respec_multiplier or self:get_tweak_value("money_manager", "skilltree", "respec", "respec_refund_multiplier")))
end

-- Lines 1341-1345
function MoneyManager:get_mission_asset_cost()
	local stars = managers.job:has_active_job() and managers.job:current_job_and_difficulty_stars() or 1

	return math.round(self:get_tweak_value("money_manager", "mission_asset_cost", stars) * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "assets_cost_multiplier_b", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

-- Lines 1347-1350
function MoneyManager:get_mission_asset_cost_by_stars(stars)
	return math.round(self:get_tweak_value("money_manager", "mission_asset_cost", stars) * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "assets_cost_multiplier_b", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

-- Lines 1352-1369
function MoneyManager:get_mission_asset_cost_by_id(id)
	local asset_tweak_data = managers.assets:get_asset_tweak_data_by_id(id)
	local value = asset_tweak_data and asset_tweak_data.money_lock or 0
	local has_active_job = managers.job:has_active_job()
	local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
	local job_stars = has_active_job and managers.job:current_job_stars() or 1
	local difficulty_stars = has_active_job and managers.job:current_difficulty_stars() or 0
	local pc_multiplier = self:get_tweak_value("money_manager", "mission_asset_cost_multiplier_by_pc", job_stars) or 0
	local risk_multiplier = difficulty_stars > 0 and self:get_tweak_value("money_manager", "mission_asset_cost_multiplier_by_risk", difficulty_stars) or 0
	value = value + value * pc_multiplier + value * risk_multiplier

	return math.round(value * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "assets_cost_multiplier_b", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

-- Lines 1373-1391
function MoneyManager:get_cost_of_premium_contract(job_id, difficulty_id)
	local job_data = tweak_data.narrative:job_data(job_id)

	if not job_data then
		return 0
	end

	local stars = job_data.jc / 10
	local total_payout, base_payout, risk_payout = self:get_contract_money_by_stars(stars, difficulty_id - 2, #tweak_data.narrative:job_chain(job_id), job_id)
	local diffs = {
		"easy",
		"normal",
		"hard",
		"overkill",
		"overkill_145",
		"easy_wish",
		"overkill_290",
		"sm_wish"
	}
	local value = total_payout * self:get_tweak_value("money_manager", "buy_premium_multiplier", diffs[difficulty_id]) + self:get_tweak_value("money_manager", "buy_premium_static_fee", diffs[difficulty_id])
	local total_value = value
	local multiplier = 1 * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1) * managers.player:upgrade_value("player", "premium_contract_cost_multiplier", 1)
	total_value = total_value + (job_data.contract_cost and job_data.contract_cost[difficulty_id - 1] / self:get_tweak_value("money_manager", "offshore_rate") or 0)
	total_value = total_value * multiplier

	return total_value
end

-- Lines 1393-1398
function MoneyManager:can_afford_buy_premium_contract(job_id, difficulty_id)
	local amount = self:get_cost_of_premium_contract(job_id, difficulty_id)

	return amount <= self:offshore()
end

-- Lines 1400-1403
function MoneyManager:on_buy_premium_contract(job_id, difficulty_id)
	local amount = self:get_cost_of_premium_contract(job_id, difficulty_id)

	self:deduct_from_offshore(amount)
end

-- Lines 1407-1425
function MoneyManager:get_cost_of_casino_entrance()
	local current_level = managers.experience:current_level()
	local level = 1

	if managers.experience:current_rank() > 0 then
		level = #tweak_data.casino.entrance_level
	else
		for i = 1, #tweak_data.casino.entrance_level do
			level = i

			if current_level < self:get_tweak_value("casino", "entrance_level", i) then
				break
			end
		end
	end

	return self:get_tweak_value("casino", "entrance_fee", level)
end

-- Lines 1427-1443
function MoneyManager:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card)
	local fee = self:get_cost_of_casino_entrance()

	for i = 1, secured_cards do
		fee = fee + self:get_tweak_value("casino", "secure_card_cost", i)
	end

	if increase_infamous then
		fee = fee + self:get_tweak_value("casino", "infamous_cost")
	end

	if preferred_card and preferred_card ~= "none" then
		fee = fee + self:get_tweak_value("casino", "prefer_cost")
	end

	return fee
end

-- Lines 1445-1447
function MoneyManager:can_afford_casino_fee(secured_cards, increase_infamous, preferred_card)
	return self:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card) <= self:offshore()
end

-- Lines 1449-1455
function MoneyManager:on_buy_casino_fee(secured_cards, increase_infamous, preferred_card)
	local amount = self:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card)

	self:deduct_from_offshore(amount)
	self:dispatch_event("casino_fee_paid", amount)
end

-- Lines 1460-1462
function MoneyManager:has_unlock_skill_switch_cost(selected_skill_switch)
	return self:get_unlock_skill_switch_spending_cost(selected_skill_switch) ~= 0 or self:get_unlock_skill_switch_offshore_cost(selected_skill_switch) ~= 0
end

-- Lines 1464-1466
function MoneyManager:get_unlock_skill_switch_spending_cost(selected_skill_switch)
	return self:get_tweak_value("money_manager", "skill_switch_cost", selected_skill_switch, "spending")
end

-- Lines 1468-1470
function MoneyManager:get_unlock_skill_switch_offshore_cost(selected_skill_switch)
	return self:get_tweak_value("money_manager", "skill_switch_cost", selected_skill_switch, "offshore")
end

-- Lines 1472-1476
function MoneyManager:can_afford_unlock_skill_switch(selected_skill_switch)
	local spending_cost = self:get_unlock_skill_switch_spending_cost(selected_skill_switch)
	local offshore_cost = self:get_unlock_skill_switch_offshore_cost(selected_skill_switch)

	return spending_cost <= self:total() and offshore_cost <= self:offshore()
end

-- Lines 1478-1483
function MoneyManager:on_unlock_skill_switch(selected_skill_switch)
	local spending_cost = self:get_unlock_skill_switch_spending_cost(selected_skill_switch)
	local offshore_cost = self:get_unlock_skill_switch_offshore_cost(selected_skill_switch)

	self:deduct_from_total(spending_cost, TelemetryConst.economy_origin.unlock_skill_switch .. selected_skill_switch)
	self:deduct_from_offshore(offshore_cost)
end

-- Lines 1487-1493
function MoneyManager:get_infamous_cost(rank)
	return Application:digest_value(tweak_data.infamy.offshore_cost[rank] or tweak_data.infamy.offshore_cost[#tweak_data.infamy.offshore_cost], false)
end

-- Lines 1517-1519
function MoneyManager:total()
	return Application:digest_value(self._global.total, false)
end

-- Lines 1521-1526
function MoneyManager:_set_total(value)
	self._global.total = Application:digest_value(value, true)

	if SystemInfo:platform() == Idstring("XB1") then
		XboxLive:write_hero_stat("cash", value)
	end
end

-- Lines 1528-1530
function MoneyManager:total_collected()
	return Application:digest_value(self._global.total_collected, false)
end

-- Lines 1532-1534
function MoneyManager:_set_total_collected(value)
	self._global.total_collected = Application:digest_value(value, true)
end

-- Lines 1536-1538
function MoneyManager:offshore()
	return Application:digest_value(self._global.offshore, false)
end

-- Lines 1540-1545
function MoneyManager:_set_offshore(value)
	self._global.offshore = Application:digest_value(value, true)

	if SystemInfo:platform() == Idstring("XB1") then
		XboxLive:write_hero_stat("offshore", value)
	end
end

-- Lines 1547-1549
function MoneyManager:total_spent()
	return Application:digest_value(self._global.total_spent, false)
end

-- Lines 1551-1553
function MoneyManager:_set_total_spent(value)
	self._global.total_spent = Application:digest_value(value, true)
end

-- Lines 1555-1559
function MoneyManager:add_to_total(amount, reason)
	amount = math.round(amount)

	print("MoneyManager:add_to_total", amount)
	self:_add_to_total(amount, nil, reason)
end

-- Lines 1561-1586
function MoneyManager:_add_to_total(amount, params, reason)
	local no_offshore = params and params.no_offshore
	local offshore = math.round(no_offshore and 0 or amount * (1 - self:get_tweak_value("money_manager", "offshore_rate")))
	local spending_cash = math.round(no_offshore and amount or amount * self:get_tweak_value("money_manager", "offshore_rate"))
	local rounding_error = math.round(amount - (offshore + spending_cash))
	spending_cash = spending_cash + rounding_error
	local total_cash = self:total() + spending_cash
	local total_collected_cash = self:total_collected() + math.round(amount)
	local offshore_cash = self:offshore() + offshore

	self:_set_total(total_cash)
	self:_set_total_collected(total_collected_cash)
	self:_set_offshore(offshore_cash)
	self:_on_total_changed(amount, spending_cash, offshore)

	reason = reason or "generic"

	Telemetry:send_on_player_economy_event(reason, "cash", amount, "earn")

	if managers.challenge then
		managers.challenge:award_progress("earn_cash", math.max(spending_cash, 0))
		managers.challenge:award_progress("earn_offshore_cash", math.max(offshore, 0))
	end
end

-- Lines 1588-1592
function MoneyManager:deduct_from_total(amount, reason)
	amount = math.round(amount)

	print("[MoneyManager] deduct_from_total", amount)
	self:_deduct_from_total(amount, reason)
end

-- Lines 1594-1601
function MoneyManager:_deduct_from_total(amount, reason)
	amount = math.min(amount, self:total())

	self:_set_total(math.max(0, self:total() - amount))
	self:_set_total_spent(self:total_spent() + amount)
	self:_on_total_changed(-amount, -amount, 0)

	reason = reason or "generic"

	Telemetry:send_on_player_economy_event(reason, "cash", amount, "spend")
end

-- Lines 1603-1611
function MoneyManager:add_to_spending(amount)
	amount = math.round(amount)

	print("[MoneyManager] add_to_offshore", amount)
	self:_set_total(math.max(0, self:total() + amount))
	self:_on_total_changed(0, amount, 0)

	if managers.challenge then
		managers.challenge:award_progress("earn_cash", math.max(amount, 0))
	end
end

-- Lines 1613-1619
function MoneyManager:deduct_from_spending(amount)
	amount = math.round(amount)

	print("[MoneyManager] deduct_from_spending", amount)

	amount = math.min(amount, self:total())

	self:_set_total(math.max(0, self:total() - amount))
	self:_on_total_changed(0, -amount, 0)
end

-- Lines 1621-1629
function MoneyManager:add_to_offshore(amount)
	amount = math.round(amount)

	print("[MoneyManager] add_to_offshore", amount)
	self:_set_offshore(math.max(0, self:offshore() + amount))
	self:_on_total_changed(0, 0, amount)

	if managers.challenge then
		managers.challenge:award_progress("earn_offshore_cash", math.max(amount, 0))
	end
end

-- Lines 1631-1635
function MoneyManager:deduct_from_offshore(amount)
	amount = math.round(amount)

	print("[MoneyManager] deduct_from_offshore", amount)
	self:_deduct_from_offshore(amount)
end

-- Lines 1637-1641
function MoneyManager:_deduct_from_offshore(amount)
	amount = math.min(amount, self:offshore())

	self:_set_offshore(math.max(0, self:offshore() - amount))
	self:_on_total_changed(0, 0, -amount)
end

-- Lines 1643-1662
function MoneyManager:_on_total_changed(amount, spending_cash, offshore)
	self._heist_total = self._heist_total + amount
	self._heist_offshore = self._heist_offshore + offshore

	if offshore and offshore > 0 then
		self._heist_spending = self._heist_spending + spending_cash
	end

	if tweak_data.achievement.going_places <= self:total() then
		managers.achievment:award("going_places")
	end

	if tweak_data.achievement.spend_money_to_make_money <= self:total_spent() then
		managers.achievment:award("spend_money_to_make_money")
	end
end

-- Lines 1664-1666
function MoneyManager:heist_total()
	return self._heist_total or 0
end

-- Lines 1668-1670
function MoneyManager:heist_spending()
	return self._heist_spending or 0
end

-- Lines 1672-1674
function MoneyManager:heist_offshore()
	return self._heist_offshore or 0
end

-- Lines 1676-1691
function MoneyManager:get_payouts()
	return {
		stage_payout = self._stage_payout,
		job_payout = self._job_payout,
		bag_payout = self._bag_payout,
		vehicle_payout = self._vehicle_payout,
		small_loot_payout = self._small_loot_payout,
		crew_payout = self._crew_payout,
		mutators_reduction = self._mutators_reduction or 0,
		skirmish_payout = managers.skirmish:current_ransom_amount()
	}
end

-- Lines 1693-1695
function MoneyManager:_set_stage_payout(amount)
	self._stage_payout = amount
end

-- Lines 1697-1699
function MoneyManager:_set_job_payout(amount)
	self._job_payout = amount
end

-- Lines 1701-1703
function MoneyManager:_set_bag_payout(amount)
	self._bag_payout = amount
end

-- Lines 1705-1707
function MoneyManager:_set_small_loot_payout(amount)
	self._small_loot_payout = amount
end

-- Lines 1709-1711
function MoneyManager:_set_crew_payout(amount)
	self._crew_payout = amount
end

-- Lines 1713-1715
function MoneyManager:_set_vehicle_payout(amount)
	self._vehicle_payout = amount
end

-- Lines 1717-1722
function MoneyManager:_add(amount)
	amount = self:_check_multipliers(amount)
	self._heist_total = self._heist_total + amount

	self:_present(amount)
end

-- Lines 1724-1729
function MoneyManager:_check_multipliers(amount)
	for _, multiplier in pairs(self._active_multipliers) do
		amount = amount * multiplier
	end

	return math.round(amount)
end

-- Lines 1731-1748
function MoneyManager:_present(amount)
	local s_amount = tostring(amount)
	local reverse = string.reverse(s_amount)
	local present = ""

	for i = 1, string.len(reverse) do
		present = present .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and "," or "")
	end

	local event = "money_collect_small"

	if amount > 999 then
		event = "money_collect_large"
	elseif amount > 101 then
		event = "money_collect_medium"
	end
end

-- Lines 1751-1758
function MoneyManager:actions()
	local t = {}

	for action, _ in pairs(tweak_data.money_manager.actions) do
		table.insert(t, action)
	end

	table.sort(t)

	return t
end

-- Lines 1761-1768
function MoneyManager:multipliers()
	local t = {}

	for multiplier, _ in pairs(tweak_data.money_manager.multipliers) do
		table.insert(t, multiplier)
	end

	table.sort(t)

	return t
end

-- Lines 1770-1773
function MoneyManager:reset()
	Global.money_manager = nil

	self:_setup()
end

-- Lines 1775-1784
function MoneyManager:save(data)
	local state = {
		total = self._global.total,
		total_collected = self._global.total_collected,
		offshore = self._global.offshore,
		total_spent = self._global.total_spent
	}
	data.MoneyManager = state
end

-- Lines 1786-1797
function MoneyManager:load(data)
	local state = data.MoneyManager
	self._global.total = state.total and Application:digest_value(math.max(0, Application:digest_value(state.total, false)), true) or self._global.total
	self._global.total_collected = state.total_collected and Application:digest_value(math.max(0, Application:digest_value(state.total_collected, false)), true) or self._global.total_collected
	self._global.offshore = state.offshore and Application:digest_value(math.max(0, Application:digest_value(state.offshore, false)), true) or self._global.offshore
	self._global.total_spent = state.total_spent and Application:digest_value(math.max(0, Application:digest_value(state.total_spent, false)), true) or self._global.total_spent

	if SystemInfo:platform() == Idstring("XB1") then
		XboxLive:write_hero_stat("cash", self._global.total)
		XboxLive:write_hero_stat("offshore", self._global.offshore)
	end
end

-- Lines 1800-1802
function MoneyManager:session_moneythrower_spending()
	return managers.statistics:session_killed_by_weapon("money") > 0 and tweak_data:get_value("money_manager", "moneythrower", "kill_to_offshore_multiplier") <= self:offshore()
end

-- Lines 1804-1812
function MoneyManager:get_session_moneythrower_kills()
	local offshore_multiplier = tweak_data:get_value("money_manager", "moneythrower", "kill_to_offshore_multiplier")
	local max_kills_per_session = tweak_data:get_value("money_manager", "moneythrower", "max_kills_per_session")
	local offshore_kills = self:offshore() % offshore_multiplier
	local session_kills = managers.statistics:session_killed_by_weapon("money")

	return math.min(session_kills, offshore_kills, max_kills_per_session)
end

-- Lines 1814-1819
function MoneyManager:get_session_moneythrower_spending()
	local offshore_multiplier = tweak_data:get_value("money_manager", "moneythrower", "kill_to_offshore_multiplier")
	local kills_to_spend = self:get_session_moneythrower_kills()

	return kills_to_spend * offshore_multiplier
end

-- Lines 1821-1835
function MoneyManager:on_spend_session_moneythrower()
	local offshore_multiplier = tweak_data:get_value("money_manager", "moneythrower", "kill_to_offshore_multiplier")
	local max_kills_per_session = tweak_data:get_value("money_manager", "moneythrower", "max_kills_per_session")
	local offshore_kills = math.floor(self:offshore() / offshore_multiplier)
	local session_kills = managers.statistics:session_killed_by_weapon("money")
	local spending_kills = math.min(session_kills, offshore_kills, max_kills_per_session)
	local spendings = spending_kills * offshore_multiplier

	if spendings > 0 then
		self:deduct_from_offshore(spendings)
	end

	return spending_kills, spendings
end
