core:module("CoreSmoketestEditorSuite")
core:import("CoreClass")
core:import("CoreSmoketestCommonSuite")

EditorSuite = EditorSuite or class(CoreSmoketestCommonSuite.CommonSuite)

-- Lines: 8 to 42
function EditorSuite:init()
	EditorSuite.super.init(self)
	self:add_step("load_editor", CoreSmoketestCommonSuite.WaitEventSubstep, CoreSmoketestCommonSuite.WaitEventSubstep.step_arguments(Idstring("game_state_editor")))
	self:add_step("load_level", CoreSmoketestCommonSuite.CallAndDoneSubstep, CoreSmoketestCommonSuite.CallAndDoneSubstep.step_arguments(callback(self, self, "load_level")))
end

-- Lines: 44 to 46
function EditorSuite:load_level()
	managers.editor:load_level(self:get_argument("editor_dir"), self:get_argument("editor_level"))
end

-- Lines: 48 to 50
function EditorSuite:run_mission_simulation()
	managers.editor:run_simulation_callback(true)
end

-- Lines: 52 to 54
function EditorSuite:stop_mission_simulation()
	managers.editor:run_simulation_callback(true)
end

-- Lines: 56 to 59
function EditorSuite:environment_editor()
	managers.toolhub:open("Environment Editor")
	managers.toolhub:close("Environment Editor")
end

return
