core:module("CoreFakeLocalUserStorage")
core:import("CoreLocalUserStorage")

Storage = Storage or class(CoreLocalUserStorage.Storage)

-- Lines 6-7
function Storage:save()
end

-- Lines 9-11
function Storage:_start_load_task()
	self._load_started_time = TimerManager:game():time()
end

-- Lines 13-19
function Storage:_load_status()
	local current_time = TimerManager:game():time()

	if current_time > self._load_started_time + 0.8 then
		self:_create_profile_data()

		return SaveData.OK
	end
end

-- Lines 21-23
function Storage:_close_load_task()
	self._load_started_time = nil
end
