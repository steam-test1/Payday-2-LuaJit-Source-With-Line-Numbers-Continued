require("lib/states/GameState")

IngameParachuting = IngameParachuting or class(IngamePlayerBaseState)

-- Lines: 5 to 7
function IngameParachuting:init(game_state_machine)
	IngameParachuting.super.init(self, "ingame_parachuting", game_state_machine)
end

-- Lines: 9 to 30
function IngameParachuting:at_enter()
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

-- Lines: 33 to 44
function IngameParachuting:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
	end

	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)

	local unit = safe_spawn_unit(Idstring("units/pd2_dlc_jerry/props/jry_equipment_parachute/jry_equipment_parachute_ragdoll"), player:position(), player:rotation())

	unit:damage():run_sequence_simple("make_dynamic")
end

-- Lines: 46 to 48
function IngameParachuting:on_server_left()
	IngameCleanState.on_server_left(self)
end

-- Lines: 50 to 52
function IngameParachuting:on_kicked()
	IngameCleanState.on_kicked(self)
end

-- Lines: 54 to 56
function IngameParachuting:on_disconnected()
	IngameCleanState.on_disconnected(self)
end

