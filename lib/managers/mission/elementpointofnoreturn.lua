core:import("CoreMissionScriptElement")

ElementPointOfNoReturn = ElementPointOfNoReturn or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementPointOfNoReturn:init(...)
	ElementPointOfNoReturn.super.init(self, ...)
end

-- Lines 9-11
function ElementPointOfNoReturn:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-20
function ElementPointOfNoReturn:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:operation_add()
	ElementPointOfNoReturn.super.on_executed(self, instigator)
end

-- Lines 22-41
function ElementPointOfNoReturn:operation_add()
	local diff = Global.game_settings and Global.game_settings.difficulty or "hard"

	if diff == "easy" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_easy, self._id, self._values.tweak_id)
	elseif diff == "normal" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_normal, self._id, self._values.tweak_id)
	elseif diff == "hard" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_hard, self._id, self._values.tweak_id)
	elseif diff == "overkill" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_overkill, self._id, self._values.tweak_id)
	elseif diff == "overkill_145" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_overkill_145, self._id, self._values.tweak_id)
	elseif diff == "easy_wish" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_easy_wish, self._id, self._values.tweak_id)
	elseif diff == "overkill_290" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_overkill_290, self._id, self._values.tweak_id)
	elseif diff == "sm_wish" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_sm_wish, self._id, self._values.tweak_id)
	end
end

-- Lines 43-45
function ElementPointOfNoReturn:operation_remove()
	managers.groupai:state():remove_point_of_no_return_timer(self._id)
end
