core:import("CoreElementTimer")

ElementHeistTimer = ElementHeistTimer or class(CoreElementTimer.ElementTimer)

-- Lines: 5 to 8
function ElementHeistTimer:timer_operation_start()
	ElementHeistTimer.super.timer_operation_start(self)
	managers.game_play_central:start_inverted_heist_timer(self._timer)
end

-- Lines: 10 to 13
function ElementHeistTimer:timer_operation_pause()
	ElementHeistTimer.super.timer_operation_pause(self)
	managers.game_play_central:stop_heist_timer()
end

-- Lines: 15 to 18
function ElementHeistTimer:timer_operation_add_time(time)
	ElementHeistTimer.super.timer_operation_add_time(self, time)
	managers.game_play_central:modify_heist_timer(time)
end

-- Lines: 20 to 23
function ElementHeistTimer:timer_operation_subtract_time(time)
	ElementHeistTimer.super.timer_operation_subtract_time(self, time)
	managers.game_play_central:modify_heist_timer(-time)
end

