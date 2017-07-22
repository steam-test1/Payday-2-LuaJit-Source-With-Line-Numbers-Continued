require("lib/states/GameState")

EditorState = EditorState or class(GameState)

-- Lines: 5 to 7
function EditorState:init(game_state_machine)
	GameState.init(self, "editor", game_state_machine)
end

-- Lines: 9 to 11
function EditorState:at_enter()
	cat_print("game_state_machine", "GAME STATE EditorState ENTER")
end

-- Lines: 13 to 15
function EditorState:at_exit()
	cat_print("game_state_machine", "GAME STATE EditorState ENTER")
end

return
