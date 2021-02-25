require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreGuiCutsceneKey = CoreGuiCutsceneKey or class(CoreCutsceneKeyBase)
CoreGuiCutsceneKey.ELEMENT_NAME = "gui"
CoreGuiCutsceneKey.NAME = "Gui"
CoreGuiCutsceneKey.VALID_ACTIONS = {
	"show",
	"hide"
}

CoreGuiCutsceneKey:register_serialized_attribute("action", "show")
CoreGuiCutsceneKey:register_serialized_attribute("name", "")

CoreGuiCutsceneKey.control_for_action = CoreCutsceneKeyBase.standard_combo_box_control
CoreGuiCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreGuiCutsceneKey.refresh_control_for_action = CoreCutsceneKeyBase:standard_combo_box_control_refresh("action", CoreGuiCutsceneKey.VALID_ACTIONS)

-- Lines 13-15
function CoreGuiCutsceneKey:__tostring()
	return string.capitalize(self:action()) .. " gui \"" .. self:name() .. "\"."
end

-- Lines 17-21
function CoreGuiCutsceneKey:prime(player)
	if self:action() == "show" and self:is_valid_name(self:name()) then
		player:load_gui(self:name())
	end
end

-- Lines 23-27
function CoreGuiCutsceneKey:unload(player)
	if player then
		self:play(player, true)
	end
end

-- Lines 29-38
function CoreGuiCutsceneKey:play(player, undo, fast_forward)
	if undo then
		local preceeding_key = self:preceeding_key({
			name = self:name()
		})

		if preceeding_key == nil or preceeding_key:action() == self:inverse_action() then
			self:_perform_action(self:inverse_action(), player)
		end
	else
		self:_perform_action(self:action(), player)
	end
end

-- Lines 40-42
function CoreGuiCutsceneKey:inverse_action()
	return self:action() == "show" and "hide" or "show"
end

-- Lines 44-46
function CoreGuiCutsceneKey:_perform_action(action, player)
	player:set_gui_visible(self:name(), action == "show")
end

-- Lines 48-50
function CoreGuiCutsceneKey:is_valid_action(action)
	return table.contains(self.VALID_ACTIONS, action)
end

-- Lines 52-54
function CoreGuiCutsceneKey:is_valid_name(name)
	return DB:has("gui", name)
end

-- Lines 56-67
function CoreGuiCutsceneKey:refresh_control_for_name(control)
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
