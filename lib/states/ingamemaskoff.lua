require("lib/states/GameState")

IngameMaskOffState = IngameMaskOffState or class(IngamePlayerBaseState)
IngameMaskOffState.immortal = true

-- Lines: 6 to 10
function IngameMaskOffState:init(game_state_machine)
	IngameMaskOffState.super.init(self, "ingame_mask_off", game_state_machine)

	self._MASK_OFF_HUD = Idstring("guis/mask_off_hud")
end

-- Lines: 12 to 37
function IngameMaskOffState:at_enter()
	local players = managers.player:players()

	for k, player in ipairs(players) do
		local vp = player:camera():viewport()

		if vp then
			vp:set_active(true)
		else
			Application:error("No viewport for player " .. tostring(k))
		end
	end

	if not managers.hud:exists(self._MASK_OFF_HUD) then
		managers.hud:load_hud(self._MASK_OFF_HUD, false, false, true, {})
	end

	managers.hud:show(self._MASK_OFF_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
	end
end

-- Lines: 50 to 60
function IngameMaskOffState:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
	end

	managers.hud:hide(self._MASK_OFF_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

-- Lines: 62 to 64
function IngameMaskOffState:on_server_left()
	IngameCleanState.on_server_left(self)
end

-- Lines: 66 to 68
function IngameMaskOffState:on_kicked()
	IngameCleanState.on_kicked(self)
end

-- Lines: 70 to 72
function IngameMaskOffState:on_disconnected()
	IngameCleanState.on_disconnected(self)
end

