require("lib/states/GameState")

IngameFreefall = IngameFreefall or class(IngamePlayerBaseState)

-- Lines: 5 to 7
function IngameFreefall:init(game_state_machine)
	IngameFreefall.super.init(self, "ingame_freefall", game_state_machine)
end

-- Lines: 9 to 30
function IngameFreefall:at_enter()
	local players = managers.player:players()

	for k, player in ipairs(players) do
		local vp = player:camera():viewport()

		if vp then
			vp:set_active(true)
		else
			Application:error("No viewport for player " .. tostring(k))
		end
	end

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
	end

	managers.hud:show(PlayerBase.PLAYER_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

-- Lines: 33 to 41
function IngameFreefall:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
	end

	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

-- Lines: 43 to 45
function IngameFreefall:on_server_left()
	IngameCleanState.on_server_left(self)
end

-- Lines: 47 to 49
function IngameFreefall:on_kicked()
	IngameCleanState.on_kicked(self)
end

-- Lines: 51 to 53
function IngameFreefall:on_disconnected()
	IngameCleanState.on_disconnected(self)
end

