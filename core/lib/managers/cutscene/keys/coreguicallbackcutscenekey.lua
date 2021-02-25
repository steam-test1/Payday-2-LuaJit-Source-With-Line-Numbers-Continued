require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreGuiCallbackCutsceneKey = CoreGuiCallbackCutsceneKey or class(CoreCutsceneKeyBase)
CoreGuiCallbackCutsceneKey.ELEMENT_NAME = "gui_callback"
CoreGuiCallbackCutsceneKey.NAME = "Gui Callback"

CoreGuiCallbackCutsceneKey:register_serialized_attribute("name", "")
CoreGuiCallbackCutsceneKey:register_serialized_attribute("function_name", "")
CoreGuiCallbackCutsceneKey:register_serialized_attribute("enabled", true, toboolean)

CoreGuiCallbackCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control

-- Lines 11-13
function CoreGuiCallbackCutsceneKey:__tostring()
	return "Call " .. self:function_name() .. " in gui \"" .. self:name() .. "\"."
end

-- Lines 15-19
function CoreGuiCallbackCutsceneKey:evaluate(player, fast_forward)
	if self:enabled() then
		player:invoke_callback_in_gui(self:name(), self:function_name(), player)
	end
end

-- Lines 21-23
function CoreGuiCallbackCutsceneKey:is_valid_name(name)
	return DB:has("gui", name)
end

-- Lines 25-36
function CoreGuiCallbackCutsceneKey:refresh_control_for_name(control)
	control:freeze()
	control:clear()

	local value = self:name()

	for _, name in ipairs(managers.database:list_entries_of_type("gui")) do
		control:append(name)

		if name == value then
			control:set_value(value)
		end
	end

	control:thaw()
end
