require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreSetupCutsceneKeyBase = CoreSetupCutsceneKeyBase or class(CoreCutsceneKeyBase)

-- Lines 5-7
function CoreSetupCutsceneKeyBase:populate_from_editor(cutscene_editor)
end

-- Lines 9-12
function CoreSetupCutsceneKeyBase:frame()
	return 0
end

-- Lines 14-16
function CoreSetupCutsceneKeyBase:set_frame(frame)
end

-- Lines 18-20
function CoreSetupCutsceneKeyBase:on_gui_representation_changed(sender, sequencer_clip)
end

-- Lines 22-24
function CoreSetupCutsceneKeyBase:prime(player)
	error("Cutscene keys deriving from CoreSetupCutsceneKeyBase must define the \"prime\" method.")
end

-- Lines 26-28
function CoreSetupCutsceneKeyBase:play(player, undo, fast_forward)
end
