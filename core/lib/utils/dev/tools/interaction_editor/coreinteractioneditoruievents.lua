core:module("CoreInteractionEditorUIEvents")
core:import("CoreClass")
core:import("CoreCode")
core:import("CoreMath")
core:import("CoreInteractionEditorConfig")

InteractionEditorUIEvents = InteractionEditorUIEvents or CoreClass.class()

-- Lines 11-13
function InteractionEditorUIEvents:on_close()
	managers.toolhub:close(CoreInteractionEditorConfig.EDITOR_TITLE)
end

-- Lines 15-17
function InteractionEditorUIEvents:on_new()
	self:open_system()
end

-- Lines 19-21
function InteractionEditorUIEvents:on_close_system()
	self:close_system()
end

-- Lines 23-25
function InteractionEditorUIEvents:on_notebook_changing(data, event)
	self:activate_system(self:ui():get_nb_page(event:get_selection()))
end

-- Lines 27-29
function InteractionEditorUIEvents:on_show_graph_context_menu(system)
	self:ui():show_graph_context_menu(system)
end

-- Lines 31-33
function InteractionEditorUIEvents:on_add_node(func)
	func()
end

-- Lines 35-37
function InteractionEditorUIEvents:on_remove_node(func)
	func()
end

-- Lines 39-41
function InteractionEditorUIEvents:on_save()
	self:do_save()
end

-- Lines 43-45
function InteractionEditorUIEvents:on_save_as()
	self:do_save_as()
end

-- Lines 47-49
function InteractionEditorUIEvents:on_save_all()
	self:do_save_all()
end

-- Lines 51-56
function InteractionEditorUIEvents:on_open()
	local path, dir = managers.database:open_file_dialog(self:ui():frame(), "*.interaction_project")

	if path and managers.database:has(path) then
		self:open_system(path)
	end
end

-- Lines 58-60
function InteractionEditorUIEvents:on_undo()
end

-- Lines 62-64
function InteractionEditorUIEvents:on_redo()
end
