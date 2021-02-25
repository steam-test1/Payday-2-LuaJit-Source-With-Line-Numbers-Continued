core:module("CoreMenuStateLegal")
core:import("CoreMenuStateIntroScreens")

Legal = Legal or class()

-- Lines 6-8
function Legal:init()
	self._start_time = TimerManager:game():time()
end

-- Lines 10-17
function Legal:transition()
	local current_time = TimerManager:game():time()
	local time_until_intro_screens = 1

	if current_time >= self._start_time + time_until_intro_screens then
		return CoreMenuStateIntroScreens.IntroScreens
	end
end
