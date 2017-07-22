require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneAnimationPatchesPanel")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneEditorProject")

CoreCutsceneSettingsDialog = CoreCutsceneSettingsDialog or class()

-- Lines: 6 to 33
function CoreCutsceneSettingsDialog:init(parent)
	self.__window = EWS:Dialog(parent, "Project Settings", "", Vector3(100, 500, 0), Vector3(400, 500, 0), "DEFAULT_DIALOG_STYLE,RESIZE_BORDER")

	self.__window:set_icon(CoreEWS.image_path("film_reel_16x16.png"))
	self.__window:set_min_size(Vector3(400, 321, 0))
	self.__window:connect("EVT_CLOSE_WINDOW", callback(self, self, "_on_close"))

	local sizer = EWS:BoxSizer("VERTICAL")

	self.__window:set_sizer(sizer)

	local project_settings_sizer = EWS:StaticBoxSizer(self.__window, "VERTICAL", "Properties")
	self.__export_type_dropdown = EWS:ComboBox(self.__window, "", "", "CB_DROPDOWN,CB_READONLY")

	for _, export_type in ipairs(get_core_or_local("CutsceneEditorProject").VALID_EXPORT_TYPES) do
		self.__export_type_dropdown:append(export_type)
	end

	self.__export_type_dropdown:set_value(self:export_type())
	project_settings_sizer:add(EWS:StaticText(self.__window, "Export Type:"), 0, 5, "TOP,LEFT,RIGHT,EXPAND")
	project_settings_sizer:add(self.__export_type_dropdown, 1, 5, "ALL,EXPAND")
	sizer:add(project_settings_sizer, 0, 5, "ALL,EXPAND")

	local animation_patches_sizer = EWS:StaticBoxSizer(self.__window, "VERTICAL", "Animation Overrides when Optimizing")
	self.__animation_patches = core_or_local("CutsceneAnimationPatchesPanel", self.__window)

	self.__animation_patches:add_to_sizer(animation_patches_sizer, 1, 0, "EXPAND")
	sizer:add(animation_patches_sizer, 1, 5, "ALL,EXPAND")

	local buttons_panel = self:_create_buttons_panel(self.__window)

	sizer:add(buttons_panel, 0, 4, "ALL,EXPAND")
end

-- Lines: 35 to 39
function CoreCutsceneSettingsDialog:destroy()
	self.__animation_patches:destroy()
	self.__window:destroy()

	self.__window = nil
end

-- Lines: 41 to 44
function CoreCutsceneSettingsDialog:show()
	self.__revert_export_type = self:export_type()
	self.__revert_animation_patches = self.__animation_patches:patches()

	return self.__window:show_modal()
end

-- Lines: 47 to 49
function CoreCutsceneSettingsDialog:set_unit_types(unit_types)
	self.__animation_patches:set_unit_types(unit_types)
end

-- Lines: 51 to 55
function CoreCutsceneSettingsDialog:populate_from_project(project)
	self.__animation_patches:set_patches(project:animation_patches())

	self.__export_type = project:export_type()

	self.__export_type_dropdown:set_value(self.__export_type)
end

-- Lines: 57 to 58
function CoreCutsceneSettingsDialog:unit_animation_patches()
	return self.__animation_patches:patches()
end

-- Lines: 61 to 62
function CoreCutsceneSettingsDialog:export_type()
	return self.__export_type or get_core_or_local("CutsceneEditorProject").DEFAULT_EXPORT_TYPE
end

-- Lines: 65 to 79
function CoreCutsceneSettingsDialog:_create_buttons_panel(parent)
	local panel = EWS:Panel(parent)
	local sizer = EWS:BoxSizer("HORIZONTAL")

	panel:set_sizer(sizer)

	local ok_button = EWS:Button(panel, "OK")

	ok_button:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_on_ok_button_clicked"), ok_button)

	local cancel_button = EWS:Button(panel, "Cancel")

	cancel_button:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_on_close"), ok_button)
	sizer:add(ok_button, 1, 1, "RIGHT,EXPAND")
	sizer:add(cancel_button, 1, 2, "LEFT,EXPAND")

	return panel
end

-- Lines: 82 to 87
function CoreCutsceneSettingsDialog:_on_ok_button_clicked(sender)
	self.__export_type = self.__export_type_dropdown:get_value()
	self.__revert_export_type = nil
	self.__revert_animation_patches = nil

	self.__window:end_modal("OK")
end

-- Lines: 89 to 96
function CoreCutsceneSettingsDialog:_on_close()
	self.__window:set_visible(false)
	self.__export_type_dropdown:set_value(self.__revert_export_type)
	self.__animation_patches:set_patches(self.__revert_animation_patches)

	self.__revert_export_type = nil
	self.__revert_animation_patches = nil

	self.__window:end_modal("CANCEL")
end

return
