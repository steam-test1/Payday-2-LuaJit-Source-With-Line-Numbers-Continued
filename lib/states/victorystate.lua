require("lib/states/GameState")

VictoryState = VictoryState or class(MissionEndState)

-- Lines: 5 to 9
function VictoryState:init(game_state_machine, setup)
	VictoryState.super.init(self, "victoryscreen", game_state_machine, setup)

	self._type = "victory"
end

-- Lines: 12 to 24
function VictoryState:at_enter(...)
	self._success = true

	VictoryState.super.at_enter(self, ...)

	if not self._safehouse_raid_rewarded then
		local was_safehouse_raid = managers.job:current_job_id() == "chill_combat"

		if was_safehouse_raid then
			managers.custom_safehouse:add_coins(tweak_data.safehouse.rewards.raid)

			self._safehouse_raid_rewarded = true
		end
	end
end

-- Lines: 26 to 31
function VictoryState:at_exit(...)
	if self._post_event then
		self._post_event:stop()
	end

	VictoryState.super.at_exit(self, ...)
end

-- Lines: 33 to 37
function VictoryState:_shut_down_network()
	if managers.dlc:is_trial() then
		VictoryState.super._shut_down_network(self)
	end
end

-- Lines: 39 to 44
function VictoryState:_load_start_menu()
	if managers.dlc:is_trial() then
		Global.open_trial_buy = true

		setup:load_start_menu()
	end
end

-- Lines: 46 to 55
function VictoryState:_set_continue_button_text()
	local is_server_or_trial = Network:is_server() or managers.dlc:is_trial()
	local text_id = not is_server_or_trial and "victory_client_waiting_for_server" or self._completion_bonus_done == false and "menu_es_calculating_experience" or managers.job:on_last_stage() and "menu_victory_goto_payday" or "menu_victory_goto_next_stage"
	local continue_button = managers.menu:is_pc_controller() and "[ENTER]" or nil
	local text = utf8.to_upper(managers.localization:text(text_id, {CONTINUE = continue_button}))

	managers.menu_component:set_endscreen_continue_button_text(text, not is_server_or_trial or not self._completion_bonus_done)
end

-- Lines: 57 to 61
function VictoryState:_continue()
	if Network:is_server() or managers.dlc:is_trial() then
		self:continue()
	end
end

-- Lines: 63 to 84
function VictoryState:continue()
	if self:_continue_blocked() then
		return
	end

	if Network:is_server() and not managers.dlc:is_trial() then
		managers.network:session():send_to_peers_loaded("enter_ingame_lobby_menu", managers.network:session():load_counter())
	end

	if managers.dlc:is_trial() then
		self:gsm():change_state_by_name("empty")

		return
	end

	if self._old_state then
		self:_clear_controller()
		managers.menu_component:close_stage_endscreen_gui()
		self:gsm():change_state_by_name("ingame_lobby_menu")
	else
		Application:error("Trying to continue from victory screen, but I have no state to goto")
	end
end

return
