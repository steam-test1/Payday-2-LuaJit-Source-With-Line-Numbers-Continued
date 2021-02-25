require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreChangeShadowCutsceneKey = CoreChangeShadowCutsceneKey or class(CoreCutsceneKeyBase)
CoreChangeShadowCutsceneKey.ELEMENT_NAME = "change_shadow"
CoreChangeShadowCutsceneKey.NAME = "Shadow Change"

CoreChangeShadowCutsceneKey:register_serialized_attribute("name", "")

-- Lines 8-23
function CoreChangeShadowCutsceneKey:init(keycollection)
	self.super.init(self, keycollection)

	self._modify_func_map = {}
	self._shadow_interface_id_map = nil
	local list = {
		"slice0",
		"slice1",
		"slice2",
		"slice3",
		"shadow_slice_overlap",
		"shadow_slice_depths"
	}
	local suffix = "post_effect/shadow_processor/shadow_rendering/shadow_modifier/"

	for _, var in ipairs(list) do
		local data_path_key = Idstring(suffix .. var):key()

		-- Lines 17-19
		local function func()
			return managers.viewport:get_environment_value(self:name(), data_path_key), true
		end

		self._modify_func_map[data_path_key] = func
	end
end

-- Lines 25-27
function CoreChangeShadowCutsceneKey:__tostring()
	return "Change shadow settings to \"" .. self:name() .. "\"."
end

-- Lines 29-38
function CoreChangeShadowCutsceneKey:evaluate(player, fast_forward)
	local preceeding_key = self:preceeding_key({
		unit_name = self.unit_name and self:unit_name(),
		object_name = self.object_name and self:object_name()
	})

	if preceeding_key then
		preceeding_key:revert()
	end

	self._shadow_interface_id_map = {}

	for data_path_key, func in pairs(self._modify_func_map) do
		self._shadow_interface_id_map[data_path_key] = managers.viewport:first_active_viewport():create_environment_modifier(data_path_key, true, func)
	end
end

-- Lines 40-42
function CoreChangeShadowCutsceneKey:revert()
	self:_reset_interface()
end

-- Lines 44-46
function CoreChangeShadowCutsceneKey:unload()
	self:_reset_interface()
end

-- Lines 48-50
function CoreChangeShadowCutsceneKey:can_evaluate_with_player(player)
	return true
end

-- Lines 52-54
function CoreChangeShadowCutsceneKey:is_valid_name(name)
	return name and DB:has("environment", name)
end

CoreChangeShadowCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control

-- Lines 58-69
function CoreChangeShadowCutsceneKey:refresh_control_for_name(control)
	control:freeze()
	control:clear()

	local value = self:name()

	for _, setting_name in ipairs(managers.database:list_entries_of_type("environment")) do
		control:append(setting_name)

		if setting_name == value then
			control:set_value(setting_name)
		end
	end

	control:thaw()
end

-- Lines 71-79
function CoreChangeShadowCutsceneKey:_reset_interface()
	if self._shadow_interface_id_map then
		for data_path_key, id in pairs(self._shadow_interface_id_map) do
			managers.viewport:first_active_viewport():destroy_modifier(id)
		end

		self._shadow_interface_id_map = nil
	end
end
