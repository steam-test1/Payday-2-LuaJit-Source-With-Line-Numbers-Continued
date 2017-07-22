core:import("CoreMissionScriptElement")

ElementPrePlanning = ElementPrePlanning or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 8
function ElementPrePlanning:init(...)
	ElementPrePlanning.super.init(self, ...)
end

-- Lines: 11 to 17
function ElementPrePlanning:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)

	if self._values.enabled then
		self._has_registered = true

		managers.preplanning:register_element(self)
	end
end

-- Lines: 20 to 29
function ElementPrePlanning:set_enabled(enabled)
	ElementPrePlanning.super.set_enabled(self, enabled)

	if enabled and not self._has_registered then
		self._has_registered = true

		managers.preplanning:register_element(self)
	elseif not enabled and self._has_registered then
		self._has_registered = nil

		managers.preplanning:unregister_element(self)
	end
end

-- Lines: 31 to 40
function ElementPrePlanning:on_executed(instigator, ...)
	if not self._values.enabled then
		return
	end

	ElementPrePlanning.super.on_executed(self, instigator, ...)
end

-- Lines: 42 to 44
function ElementPrePlanning:save(data)
	data.enabled = self._values.enabled
end

-- Lines: 46 to 48
function ElementPrePlanning:load(data)
	self:set_enabled(data.enabled)
end

return
