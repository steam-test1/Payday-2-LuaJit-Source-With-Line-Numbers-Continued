require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreSetupCutsceneKeyBase = CoreSetupCutsceneKeyBase or class(CoreCutsceneKeyBase)

-- Lines: 6 to 7
function CoreSetupCutsceneKeyBase:populate_from_editor(cutscene_editor)
end

-- Lines: 10 to 11
function CoreSetupCutsceneKeyBase:frame()
	return 0
end

-- Lines: 15 to 16
function CoreSetupCutsceneKeyBase:set_frame(frame)
end

-- Lines: 19 to 20
function CoreSetupCutsceneKeyBase:on_gui_representation_changed(sender, sequencer_clip)
end

-- Lines: 22 to 24
function CoreSetupCutsceneKeyBase:prime(player)
	error("Cutscene keys deriving from CoreSetupCutsceneKeyBase must define the \"prime\" method.")
end

-- Lines: 27 to 28
function CoreSetupCutsceneKeyBase:play(player, undo, fast_forward)
end

return
