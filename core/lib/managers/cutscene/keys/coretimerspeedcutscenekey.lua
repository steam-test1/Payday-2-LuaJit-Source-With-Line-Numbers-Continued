require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreTimerSpeedCutsceneKey = CoreTimerSpeedCutsceneKey or class(CoreCutsceneKeyBase)
CoreTimerSpeedCutsceneKey.ELEMENT_NAME = "timer_speed"
CoreTimerSpeedCutsceneKey.NAME = "Timer Speed"

CoreTimerSpeedCutsceneKey:register_serialized_attribute("speed", 1, tonumber)
CoreTimerSpeedCutsceneKey:register_serialized_attribute("duration", 0, tonumber)

-- Lines 9-11
function CoreTimerSpeedCutsceneKey:__tostring()
	return string.format("Change timer speed to \"%g\" over \"%g\" seconds.", self:speed(), self:duration())
end

-- Lines 13-15
function CoreTimerSpeedCutsceneKey:unload(player)
	self:_set_timer_speed(1, 0)
end

-- Lines 17-28
function CoreTimerSpeedCutsceneKey:play(player, undo, fast_forward)
	if undo then
		local preceeding_key = self:preceeding_key()

		if preceeding_key then
			self:_set_timer_speed(preceeding_key:speed(), preceeding_key:duration())
		else
			self:_set_timer_speed(1, 0)
		end
	else
		self:_set_timer_speed(self:speed(), self:duration())
	end
end

-- Lines 30-45
function CoreTimerSpeedCutsceneKey:_set_timer_speed(speed, duration)
	speed = math.max(speed, 0)
	duration = math.max(duration, 0)

	if speed > 0 and speed < 0.035 then
		speed = 0.035
	end

	if duration > 0 and duration < 0.035 then
		duration = 0
	end

	TimerManager:ramp_multiplier(TimerManager:game(), speed, duration, TimerManager:pausable())
	TimerManager:ramp_multiplier(TimerManager:game_animation(), speed, duration, TimerManager:pausable())
end

-- Lines 47-49
function CoreTimerSpeedCutsceneKey:is_valid_speed(speed)
	return speed ~= nil and speed >= 0.035
end

-- Lines 51-53
function CoreTimerSpeedCutsceneKey:is_valid_duration(duration)
	return duration ~= nil and duration >= 0
end
