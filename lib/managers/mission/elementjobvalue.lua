core:import("CoreMissionScriptElement")

ElementJobValue = ElementJobValue or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 5 to 7
function ElementJobValue:init(...)
	ElementJobValue.super.init(self, ...)
end

-- Lines: 10 to 14
function ElementJobValue:client_on_executed(...)
	if self._values.save then
		self:on_executed(...)
	end
end

-- Lines: 16 to 33
function ElementJobValue:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.key ~= "none" then
		if self._values.save then
			managers.mission:set_saved_job_value(self._values.key, self._values.value)
		else
			managers.mission:set_job_value(self._values.key, self._values.value)
		end
	elseif Application:editor() then
		managers.editor:output_error("Cant set job value with key none.")
	end

	ElementJobValue.super.on_executed(self, instigator)
end
ElementJobValueFilter = ElementJobValueFilter or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 39 to 41
function ElementJobValueFilter:init(...)
	ElementJobValueFilter.super.init(self, ...)
end

-- Lines: 44 to 45
function ElementJobValueFilter:client_on_executed(...)
end

-- Lines: 47 to 64
function ElementJobValueFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local value = nil
	value = self._values.save and managers.mission:get_saved_job_value(self._values.key) or managers.mission:get_job_value(self._values.key)

	if not self:_check_value(value) then
		return
	end

	ElementJobValueFilter.super.on_executed(self, instigator)
end

-- Lines: 66 to 100
function ElementJobValueFilter:_check_value(value)
	if self._values.check_type == "not_has_key" then
		return not value
	end

	if not value then
		return false
	end

	if self._values.check_type == "has_key" then
		return true
	end

	if not self._values.check_type or self._values.check_type == "equal" then
		return value == self._values.value
	end

	if self._values.check_type == "less_or_equal" then
		return value <= self._values.value
	end

	if self._values.check_type == "greater_or_equal" then
		return self._values.value <= value
	end

	if self._values.check_type == "less_than" then
		return value < self._values.value
	end

	if self._values.check_type == "greater_than" then
		return self._values.value < value
	end
end
ElementApplyJobValue = ElementApplyJobValue or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 106 to 108
function ElementApplyJobValue:init(...)
	ElementApplyJobValue.super.init(self, ...)
end

-- Lines: 113 to 114
function ElementApplyJobValue:client_on_executed(...)
end

-- Lines: 116 to 136
function ElementApplyJobValue:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local value = nil
	value = self._values.save and managers.mission:get_saved_job_value(self._values.key) or managers.mission:get_job_value(self._values.key)

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			element:apply_job_value(value)
		end
	end

	ElementApplyJobValue.super.on_executed(self, instigator)
end

