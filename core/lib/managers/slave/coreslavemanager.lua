core:module("CoreSlaveManager")
core:import("CoreCode")
core:import("CoreSlaveUpdators")

SlaveManager = SlaveManager or class()

-- Lines: 12 to 15
function SlaveManager:init()
	self._updator = nil
	self._status = false
end

-- Lines: 17 to 21
function SlaveManager:update(t, dt)
	if self._status then
		self._updator:update(t, dt)
	end
end

-- Lines: 23 to 25
function SlaveManager:paused_update(t, dt)
	self:update(t, dt)
end

-- Lines: 27 to 30
function SlaveManager:start(vp, port)
	assert(not self._status, "[SlaveManager] Already started!")

	self._updator, self._status = CoreSlaveUpdators.SlaveUpdator:new(vp, port)

	return self._status
end

-- Lines: 37 to 39
function SlaveManager:act_master(host, port, lsport, manual_pumping)
	self._updator, self._status = CoreSlaveUpdators.MasterUpdator:new(assert(managers.viewport:first_active_viewport()), host, port, lsport, manual_pumping)

	return self._status
end

-- Lines: 42 to 45
function SlaveManager:set_batch_count(count)
	assert(not count or count > 0, "[SlaveManager] Batch count must be more then 0!")
	self._updator:set_batch_count(count)
end

-- Lines: 47 to 48
function SlaveManager:connected()
	return self._status
end

-- Lines: 51 to 52
function SlaveManager:type()
	return self._updator and self._updator:type() or nil
end

-- Lines: 55 to 56
function SlaveManager:peer()
	return self._updator and self._updator:peer() or nil
end

