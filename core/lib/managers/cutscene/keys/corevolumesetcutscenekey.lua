require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreVolumeSetCutsceneKey = CoreVolumeSetCutsceneKey or class(CoreCutsceneKeyBase)
CoreVolumeSetCutsceneKey.ELEMENT_NAME = "volume_set"
CoreVolumeSetCutsceneKey.NAME = "Volume Set"
CoreVolumeSetCutsceneKey.VALID_ACTIONS = {
	"activate",
	"deactivate"
}

CoreVolumeSetCutsceneKey:register_serialized_attribute("action", "activate")
CoreVolumeSetCutsceneKey:register_serialized_attribute("name", "")

CoreVolumeSetCutsceneKey.control_for_action = CoreCutsceneKeyBase.standard_combo_box_control
CoreVolumeSetCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreVolumeSetCutsceneKey.refresh_control_for_action = CoreCutsceneKeyBase:standard_combo_box_control_refresh("action", CoreVolumeSetCutsceneKey.VALID_ACTIONS)

-- Lines 13-15
function CoreVolumeSetCutsceneKey:__tostring()
	return string.capitalize(self:action()) .. " volume set \"" .. self:name() .. "\"."
end

-- Lines 17-19
function CoreVolumeSetCutsceneKey:unload(player)
	self:play(player, true)
end

-- Lines 21-32
function CoreVolumeSetCutsceneKey:play(player, undo, fast_forward)
	if managers.volume == nil then
		return
	end

	if undo then
		local preceeding_key = self:preceeding_key({
			name = self:name()
		})

		if preceeding_key == nil or preceeding_key:action() == self:inverse_action() then
			self:_perform_action(self:inverse_action())
		end
	else
		self:_perform_action(self:action())
	end
end

-- Lines 34-36
function CoreVolumeSetCutsceneKey:inverse_action()
	return self:action() == "activate" and "deactivate" or "activate"
end

-- Lines 38-44
function CoreVolumeSetCutsceneKey:_perform_action(action)
	if action == "deactivate" and managers.volume:is_active(self:name()) then
		managers.volume:deactivate_set(self:name())
	elseif action == "activate" and not managers.volume:is_active(self:name()) then
		managers.volume:activate_set(self:name())
	end
end

-- Lines 46-48
function CoreVolumeSetCutsceneKey:is_valid_action(action)
	return table.contains(self.VALID_ACTIONS, action)
end

-- Lines 50-52
function CoreVolumeSetCutsceneKey:is_valid_name(name)
	return managers.volume and managers.volume:is_valid_volume_set_name(name) or false
end

-- Lines 54-67
function CoreVolumeSetCutsceneKey:refresh_control_for_name(control)
	control:freeze()
	control:clear()

	if managers.volume then
		local value = self:name()

		for _, entry in ipairs(managers.volume:volume_set_names()) do
			control:append(entry)

			if entry == value then
				control:set_value(value)
			end
		end
	end

	control:thaw()
end
