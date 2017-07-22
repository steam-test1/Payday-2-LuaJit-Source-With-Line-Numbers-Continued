require("lib/states/GameState")

DisconnectedState = DisconnectedState or class(MissionEndState)

-- Lines: 5 to 7
function DisconnectedState:init(game_state_machine, setup)
	DisconnectedState.super.init(self, "disconnected", game_state_machine, setup)
end

-- Lines: 10 to 21
function DisconnectedState:at_enter(...)
	self._success = false
	self._completion_bonus_done = true

	DisconnectedState.super.at_enter(self, ...)
	managers.network.voice_chat:destroy_voice(true)

	if managers.network.matchmake then
		managers.network.matchmake._room_id = nil
	end

	self:_create_disconnected_dialog()
end

-- Lines: 25 to 27
function DisconnectedState:_create_disconnected_dialog()
	MenuMainState._create_disconnected_dialog(self)
end

-- Lines: 31 to 32
function DisconnectedState:on_server_left_ok_pressed()
end

-- Lines: 34 to 38
function DisconnectedState:on_disconnected()
	self._completion_bonus_done = true

	self:_set_continue_button_text()
end

-- Lines: 40 to 44
function DisconnectedState:on_server_left()
	self._completion_bonus_done = true

	self:_set_continue_button_text()
end

-- Lines: 46 to 50
function DisconnectedState:_load_start_menu()
	if not managers.job:stage_success() or not managers.job:on_last_stage() then
		setup:load_start_menu()
	end
end

return
