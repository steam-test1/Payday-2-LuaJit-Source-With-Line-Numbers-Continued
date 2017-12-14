require("lib/states/GameState")

IngameBleedOutState = IngameBleedOutState or class(IngamePlayerBaseState)

-- Lines: 5 to 7
function IngameBleedOutState:init(game_state_machine)
	IngameBleedOutState.super.init(self, "ingame_bleed_out", game_state_machine)
end

-- Lines: 9 to 24
function IngameBleedOutState:update(t, dt)
	local player = managers.player:player_unit()

	if not alive(player) then
		return
	end

	if player:movement():nav_tracker() and player:character_damage():update_downed(t, dt) then
		managers.player:on_enter_custody(player)
	end
end

-- Lines: 26 to 59
function IngameBleedOutState:at_enter()
	local players = managers.player:players()

	for k, player in ipairs(players) do
		local vp = player:camera():viewport()

		if vp then
			vp:set_active(true)
		else
			Application:error("No viewport for player " .. tostring(k))
		end
	end

	managers.statistics:downed({bleed_out = true})

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
	end

	managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
	managers.hud:show(PlayerBase.PLAYER_DOWNED_HUD)
end

-- Lines: 71 to 94
function IngameBleedOutState:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
	end

	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
	managers.hud:hide(PlayerBase.PLAYER_DOWNED_HUD)
end

-- Lines: 96 to 98
function IngameBleedOutState:on_server_left()
	IngameCleanState.on_server_left(self)
end

-- Lines: 100 to 102
function IngameBleedOutState:on_kicked()
	IngameCleanState.on_kicked(self)
end

-- Lines: 104 to 106
function IngameBleedOutState:on_disconnected()
	IngameCleanState.on_disconnected(self)
end

