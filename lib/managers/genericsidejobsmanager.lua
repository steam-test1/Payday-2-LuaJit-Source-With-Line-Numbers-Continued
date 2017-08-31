GenericSideJobsManager = GenericSideJobsManager or class()

-- Lines: 8 to 11
function GenericSideJobsManager:init()
	self._side_jobs = {}
end

-- Lines: 13 to 17
function GenericSideJobsManager:register(manager)
	table.insert(self._side_jobs, {manager = manager})
end

-- Lines: 19 to 20
function GenericSideJobsManager:side_jobs()
	return self._side_jobs
end

-- Lines: 23 to 30
function GenericSideJobsManager:get_challenge(id)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		local challenge = side_job_dlc.manager:get_challenge(id)

		if challenge then
			return challenge
		end
	end
end

-- Lines: 32 to 39
function GenericSideJobsManager:has_completed_and_claimed_rewards(id)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		local challenge = side_job_dlc.manager:get_challenge(id)

		if challenge then
			return side_job_dlc.manager:has_completed_and_claimed_rewards(id)
		end
	end

	return false
end

-- Lines: 42 to 46
function GenericSideJobsManager:award(id)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		side_job_dlc.manager:award(id)
	end
end

-- Lines: 48 to 52
function GenericSideJobsManager:save(cache)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		side_job_dlc.manager:save(cache)
	end
end

-- Lines: 54 to 58
function GenericSideJobsManager:load(cache, version)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		side_job_dlc.manager:load(cache, version)
	end
end

