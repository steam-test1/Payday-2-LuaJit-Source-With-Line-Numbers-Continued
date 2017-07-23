require("lib/states/GameState")

IngameCivilianState = IngameCivilianState or class(IngamePlayerBaseState)

-- Lines: 6 to 8
function IngameCivilianState:init(game_state_machine)
	IngameCivilianState.super.init(self, "ingame_civilian", game_state_machine)
end

-- Lines: 10 to 32
function IngameCivilianState:at_enter()
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
	managers.hud:hide_local_player_gear()

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
		player:character_damage():set_invulnerable(true)
	end
end

-- Lines: 35 to 45
function IngameCivilianState:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
		player:character_damage():set_invulnerable(false)
	end

	managers.hud:show_local_player_gear()
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

-- Lines: 47 to 50
function IngameCivilianState:on_server_left()
	print("[IngameCivilianState:on server_left]")
	game_state_machine:change_state_by_name("server_left")
end

-- Lines: 52 to 55
function IngameCivilianState:on_kicked()
	print("[IngameCivilianState:on on_kicked]")
	game_state_machine:change_state_by_name("kicked")
end

-- Lines: 57 to 59
function IngameCivilianState:on_disconnected()
	game_state_machine:change_state_by_name("disconnected")
end

