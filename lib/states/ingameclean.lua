require("lib/states/GameState")

IngameCleanState = IngameCleanState or class(IngamePlayerBaseState)

-- Lines 5-7
function IngameCleanState:init(game_state_machine)
	IngameCleanState.super.init(self, "ingame_clean", game_state_machine)
end

-- Lines 9-30
function IngameCleanState:at_enter()
	local players = managers.player:players()

	for k, player in ipairs(players) do
		local vp = player:camera():viewport()

		if vp then
			vp:set_active(true)
		else
			Application:error("No viewport for player " .. tostring(k))
		end
	end

	managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
		player:character_damage():set_invulnerable(true)
	end
end

-- Lines 32-42
function IngameCleanState:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
		player:character_damage():set_invulnerable(false)
	end

	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

-- Lines 44-47
function IngameCleanState:on_server_left()
	print("[IngameCleanState:on server_left]")
	game_state_machine:change_state_by_name("server_left")
end

-- Lines 49-52
function IngameCleanState:on_kicked()
	print("[IngameCleanState:on on_kicked]")
	game_state_machine:change_state_by_name("kicked")
end

-- Lines 54-56
function IngameCleanState:on_disconnected()
	game_state_machine:change_state_by_name("disconnected")
end
