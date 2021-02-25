core:module("CoreElementPlayEffect")
core:import("CoreEngineAccess")
core:import("CoreMissionScriptElement")

ElementPlayEffect = ElementPlayEffect or class(CoreMissionScriptElement.MissionScriptElement)
ElementPlayEffect.IDS_EFFECT = Idstring("effect")

-- Lines 8-18
function ElementPlayEffect:init(...)
	ElementPlayEffect.super.init(self, ...)

	if Application:editor() then
		if self._values.effect ~= "none" then
			CoreEngineAccess._editor_load(self.IDS_EFFECT, self._values.effect:id())
		else
			managers.editor:output_error("Cant load effect named \"none\" [" .. self._editor_name .. "]")
		end
	end
end

-- Lines 20-22
function ElementPlayEffect:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 24-32
function ElementPlayEffect:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	self:play_effect()
	ElementPlayEffect.super.on_executed(self, instigator)
end

-- Lines 34-48
function ElementPlayEffect:play_effect()
	if self._values.effect ~= "none" then
		local params = {
			effect = Idstring(self._values.effect)
		}
		local pos, rot = self:get_orientation()
		params.position = self._values.screen_space and Vector3() or pos
		params.rotation = self._values.screen_space and Rotation() or rot
		params.base_time = self._values.base_time or 0
		params.random_time = self._values.random_time or 0
		params.max_amount = self._values.max_amount ~= 0 and self._values.max_amount or nil

		managers.environment_effects:spawn_mission_effect(self._id, params)
	elseif Application:editor() then
		managers.editor:output_error("Cant spawn effect named \"none\" [" .. self._editor_name .. "]")
	end
end

-- Lines 50-52
function ElementPlayEffect:kill()
	managers.environment_effects:kill_mission_effect(self._id)
end

-- Lines 54-56
function ElementPlayEffect:fade_kill()
	managers.environment_effects:fade_kill_mission_effect(self._id)
end

ElementStopEffect = ElementStopEffect or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 62-64
function ElementStopEffect:init(...)
	ElementStopEffect.super.init(self, ...)
end

-- Lines 66-68
function ElementStopEffect:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 70-87
function ElementStopEffect:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.operation == "kill" then
				element:kill()
			elseif self._values.operation == "fade_kill" then
				element:fade_kill()
			end
		end
	end

	ElementStopEffect.super.on_executed(self, instigator)
end
