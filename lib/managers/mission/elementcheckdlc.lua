core:import("CoreMissionScriptElement")

ElementCheckDLC = ElementCheckDLC or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementCheckDLC:init(...)
	ElementCheckDLC.super.init(self, ...)
end

-- Lines 9-29
function ElementCheckDLC:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local can_execute = nil

	if self._values.require_all then
		can_execute = self:check_all_dlcs_owned(self._values.dlc_ids)
	else
		can_execute = self:check_any_dlc_owned(self._values.dlc_ids)
	end

	if self._values.invert then
		can_execute = not can_execute
	end

	if can_execute then
		ElementCheckDLC.super.on_executed(self, instigator)
	end
end

-- Lines 31-33
function ElementCheckDLC:client_on_executed(...)
end

-- Lines 35-42
function ElementCheckDLC:check_any_dlc_owned(dlc_list)
	for i, dlc in ipairs(dlc_list) do
		if managers.dlc:is_dlc_unlocked(dlc) then
			return true
		end
	end

	return false
end

-- Lines 44-51
function ElementCheckDLC:check_all_dlcs_owned(dlc_list)
	for i, dlc in ipairs(dlc_list) do
		if not managers.dlc:is_dlc_unlocked(dlc) then
			return false
		end
	end

	return true
end
