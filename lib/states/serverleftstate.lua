require("lib/states/GameState")

ServerLeftState = ServerLeftState or class(MissionEndState)

-- Lines 6-18
function ServerLeftState:init(game_state_machine, setup)
	ServerLeftState.super.init(self, "server_left", game_state_machine, setup)
end

-- Lines 21-52
function ServerLeftState:at_enter(...)
	self._success = false
	self._server_left = true
	self._completion_bonus_done = true

	ServerLeftState.super.at_enter(self, ...)

	if Network:multiplayer() then
		self:_shut_down_network()
	end

	if managers.network.matchmake then
		managers.network.matchmake._room_id = nil
	end

	if managers.crime_spree:is_active() then
		print("Server left CS")
		managers.system_menu:close("continue_crime_spree")
		MenuCallbackHandler:create_server_left_crime_spree_dialog()
	else
		self:_create_server_left_dialog()
	end
end

-- Lines 65-67
function ServerLeftState:on_server_left()
end

-- Lines 69-71
function ServerLeftState:_create_server_left_dialog()
	MenuMainState._create_server_left_dialog(self)
end

-- Lines 73-77
function ServerLeftState:_load_start_menu()
	if not managers.job:stage_success() or not managers.job:on_last_stage() then
		setup:load_start_menu()
	end
end

-- Lines 81-84
function ServerLeftState:on_server_left_ok_pressed()
	self._completion_bonus_done = true

	self:_set_continue_button_text()
end
