ElementTangoAward = ElementTangoAward or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 7-9
function ElementTangoAward:client_on_executed_end_screen(...)
	self:on_executed(...)
end

-- Lines 11-13
function ElementTangoAward:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 15-50
function ElementTangoAward:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local award_trophy = true

	if self:value("award_instigator") and type(instigator) == "userdata" and alive(instigator) then
		local local_player = managers.player:local_player()
		award_trophy = alive(local_player) and local_player == instigator

		if not award_trophy then
			if instigator:vehicle_driving() then
				local seat = instigator:vehicle_driving():find_seat_for_player(local_player)

				if seat and seat.driving then
					award_trophy = true
				end
			elseif false then
				-- Nothing
			end
		end
	end

	if self:value("players_from_start") and (managers.statistics:is_dropin() or game_state_machine:current_state_name() == "ingame_waiting_for_players") then
		award_trophy = false
	end

	if award_trophy then
		managers.tango:award(self:value("objective_id"))
	end

	ElementTangoAward.super.on_executed(self, self._unit or instigator)
end

ElementTangoFilter = ElementTangoFilter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 58-63
function ElementTangoFilter:on_script_activated()
	ElementTangoFilter.super.on_script_activated(self)

	if self:value("execute_on_startup") then
		self:on_executed()
	end
end

-- Lines 65-103
function ElementTangoFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local pass = true
	local unlocked = false
	local challenge = managers.tango:get_challenge(self:value("challenge"))

	if self:value("objective_id") == "all" then
		unlocked = true

		for _, objective_data in ipairs(challenge.objectives) do
			if not objective_data.completed then
				unlocked = false
			end
		end
	else
		for _, objective_data in ipairs(challenge.objectives) do
			if objective_data.id == self:value("objective_id") then
				unlocked = objective_data.completed
			end
		end
	end

	if self:value("check_type") == "complete" then
		pass = unlocked
	elseif self:value("check_type") == "incomplete" then
		pass = not unlocked
	end

	if pass then
		ElementTangoFilter.super.on_executed(self, self._unit or instigator)
	end
end
