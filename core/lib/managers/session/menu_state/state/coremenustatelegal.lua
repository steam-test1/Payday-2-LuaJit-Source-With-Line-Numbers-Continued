core:module("CoreMenuStateLegal")
core:import("CoreMenuStateIntroScreens")

Legal = Legal or class()

-- Lines: 6 to 8
function Legal:init()
	self._start_time = TimerManager:game():time()
end

-- Lines: 10 to 17
function Legal:transition()
	local current_time = TimerManager:game():time()
	local time_until_intro_screens = 1

	if self._start_time + time_until_intro_screens <= current_time then
		return CoreMenuStateIntroScreens.IntroScreens
	end
end

return
