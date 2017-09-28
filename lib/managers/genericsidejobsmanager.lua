GenericSideJobsManager = GenericSideJobsManager or class()

-- Lines: 8 to 11
function GenericSideJobsManager:init()
	self._side_jobs = {}
end

-- Lines: 13 to 19
function GenericSideJobsManager:register(manager)
	if table.find_value(self._side_jobs, function (v)
		return v.manager == manager
	end) then
		return
	end

	table.insert(self._side_jobs, {manager = manager})
end

-- Lines: 21 to 22
function GenericSideJobsManager:side_jobs()
	return self._side_jobs
end

-- Lines: 25 to 32
function GenericSideJobsManager:get_challenge(id)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		local challenge = side_job_dlc.manager:get_challenge(id)

		if challenge then
			return challenge
		end
	end
end

-- Lines: 34 to 41
function GenericSideJobsManager:has_completed_and_claimed_rewards(id)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		local challenge = side_job_dlc.manager:get_challenge(id)

		if challenge then
			return side_job_dlc.manager:has_completed_and_claimed_rewards(id)
		end
	end

	return false
end

-- Lines: 44 to 48
function GenericSideJobsManager:award(id)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		side_job_dlc.manager:award(id)
	end
end

-- Lines: 50 to 54
function GenericSideJobsManager:save(cache)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		side_job_dlc.manager:save(cache)
	end
end

-- Lines: 56 to 60
function GenericSideJobsManager:load(cache, version)
	for _, side_job_dlc in ipairs(self._side_jobs) do
		side_job_dlc.manager:load(cache, version)
	end
end

-- Lines: 62 to 67
function GenericSideJobsManager:reset()
	local list = table.list_copy(self._side_jobs)

	for _, side_job_dlc in ipairs(list) do
		side_job_dlc.manager:reset()
	end
end

