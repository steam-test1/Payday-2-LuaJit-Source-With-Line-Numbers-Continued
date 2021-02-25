require("lib/states/GameState")

IngameHost = IngameHost or class(GameState)

-- Lines 6-8
function IngameHost:init(game_state_machine)
	GameState.init(self, "ingame_host", game_state_machine)
end

-- Lines 10-14
function IngameHost:at_enter()
	print("[IngameHost] Enter")
	managers.network:session():local_peer():set_waiting_for_player_ready(true)
	managers.network:session():on_set_member_ready(managers.network:session():local_peer():id(), true, true, false)
end

-- Lines 16-18
function IngameHost:at_exit()
	print("[IngameHost] Exit")
end
