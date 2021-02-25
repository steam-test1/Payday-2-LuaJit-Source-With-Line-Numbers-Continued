require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreChangeEnvCutsceneKey = CoreChangeEnvCutsceneKey or class(CoreCutsceneKeyBase)
CoreChangeEnvCutsceneKey.ELEMENT_NAME = "change_env"
CoreChangeEnvCutsceneKey.NAME = "Environment Change"

CoreChangeEnvCutsceneKey:register_serialized_attribute("name", "")
CoreChangeEnvCutsceneKey:register_serialized_attribute("transition_time", 0, tonumber)

-- Lines 9-11
function CoreChangeEnvCutsceneKey:__tostring()
	return "Change environment to \"" .. self:name() .. "\"."
end

-- Lines 13-15
function CoreChangeEnvCutsceneKey:prime(player)
	managers.environment:preload_environment(self:name(), false)
end

-- Lines 17-22
function CoreChangeEnvCutsceneKey:unload(player)
	if self.__previous_environment_name then
		managers.viewport:first_active_viewport():set_environment(self.__previous_environment_name)
	end
end

-- Lines 24-39
function CoreChangeEnvCutsceneKey:evaluate(player, fast_forward)
	self.__previous_environment_name = self.__previous_environment_name or managers.environment:get_current_environment_name()
	local transition_time = self:transition_time()

	if transition_time and transition_time > 0 then
		managers.viewport:first_active_viewport():set_environment(self:name(), transition_time)
	else
		managers.viewport:first_active_viewport():set_environment(self:name())
	end
end

-- Lines 41-43
function CoreChangeEnvCutsceneKey:can_evaluate_with_player(player)
	return true
end

-- Lines 45-47
function CoreChangeEnvCutsceneKey:is_valid_name(name)
	return Database:has("environment", name)
end

-- Lines 49-51
function CoreChangeEnvCutsceneKey:is_valid_transition_time(value)
	return value and value >= 0
end

CoreChangeEnvCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control

-- Lines 55-66
function CoreChangeEnvCutsceneKey:refresh_control_for_name(control)
	control:freeze()
	control:clear()

	local value = self:name()

	for _, name in ipairs(managers.database:list_entries_of_type("environment")) do
		control:append(name)

		if name == value then
			control:set_value(value)
		end
	end

	control:thaw()
end
