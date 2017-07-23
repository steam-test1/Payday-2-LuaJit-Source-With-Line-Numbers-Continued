CrimeSpreeContractBoxGui = CrimeSpreeContractBoxGui or class()

-- Lines: 5 to 21
function CrimeSpreeContractBoxGui:init(ws, fullscreen_ws)
	self._ws = ws
	self._fullscreen_ws = fullscreen_ws
	self._panel = self._ws:panel():panel()
	self._fullscreen_panel = self._fullscreen_ws:panel():panel()
	self._peer_panels = {}

	if not self:_can_update() then
		for i = 1, tweak_data.max_players, 1 do
			self:_check_create_peer_panel(i)
		end
	end

	self._enabled = true
end

-- Lines: 23 to 25
function CrimeSpreeContractBoxGui:set_enabled(enabled)
	self._enabled = enabled
end

-- Lines: 27 to 30
function CrimeSpreeContractBoxGui:close()
	self._ws:panel():remove(self._panel)
	self._fullscreen_ws:panel():remove(self._fullscreen_panel)
end

-- Lines: 34 to 35
function CrimeSpreeContractBoxGui:_can_update()
	return not Global.game_settings.single_player
end

-- Lines: 38 to 46
function CrimeSpreeContractBoxGui:_check_create_peer_panel(peer_id)
	if not self._peer_panels[peer_id] then
		local peer = managers.network:session():peer(peer_id)

		if peer then
			local char_data = LobbyCharacterData:new(self._panel, peer)
			self._peer_panels[peer_id] = char_data
		end
	end

	return self._peer_panels[peer_id]
end

-- Lines: 50 to 61
function CrimeSpreeContractBoxGui:update_character_menu_state(peer_id, state)
	if not self:_can_update() then
		return
	end

	local panel = self:_check_create_peer_panel(peer_id)

	if panel then
		panel:update_peer_id(peer_id)
		panel:update_character_menu_state(state)
	end
end

-- Lines: 64 to 75
function CrimeSpreeContractBoxGui:update_character(peer_id)
	if not self:_can_update() then
		return
	end

	local panel = self:_check_create_peer_panel(peer_id)

	if panel then
		panel:update_peer_id(peer_id)
		panel:update_character()
	end
end

-- Lines: 78 to 79
function CrimeSpreeContractBoxGui:update_bg_state(peer_id, state)
end

-- Lines: 82 to 93
function CrimeSpreeContractBoxGui:set_character_panel_alpha(peer_id, alpha)
	if not self:_can_update() then
		return
	end

	local panel = self:_check_create_peer_panel(peer_id)

	if panel then
		panel:update_peer_id(peer_id)
		panel:set_alpha(alpha)
	end
end

-- Lines: 97 to 98
function CrimeSpreeContractBoxGui:refresh()
end

-- Lines: 100 to 107
function CrimeSpreeContractBoxGui:update(t, dt)
	if not self:_can_update() then
		return
	end

	for i = 1, 4, 1 do
		self:update_character(i)
	end
end

-- Lines: 110 to 130
function CrimeSpreeContractBoxGui:mouse_pressed(button, x, y)
	if not self:can_take_input() or not self:_can_update() then
		return
	end

	if button == Idstring("0") and self._peer_panels and SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_overlay_enabled() then
		for peer_id, object in pairs(self._peer_panels) do
			if alive(object:panel()) and object:panel():inside(x, y) then
				local peer = managers.network:session() and managers.network:session():peer(peer_id)

				if peer then
					Steam:overlay_activate("url", tweak_data.gui.fbi_files_webpage .. "/suspect/" .. peer:user_id() .. "/")

					return
				end
			end
		end
	end
end

-- Lines: 133 to 153
function CrimeSpreeContractBoxGui:mouse_moved(x, y)
	if not self:can_take_input() or not self:_can_update() then
		return
	end

	local used = false
	local pointer = "arrow"

	if self._peer_panels and SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_overlay_enabled() then
		for peer_id, object in pairs(self._peer_panels) do
			if alive(object:panel()) and object:panel():inside(x, y) then
				used = true
				pointer = "link"
			end
		end
	end

	if used then
		return used, pointer
	end
end

-- Lines: 155 to 159
function CrimeSpreeContractBoxGui:can_take_input()
	if managers.menu_component and managers.menu_component:crime_spree_modifiers() then
		return false
	end

	return true
end

-- Lines: 162 to 163
function CrimeSpreeContractBoxGui:check_minimize()
	return false
end

-- Lines: 166 to 167
function CrimeSpreeContractBoxGui:moved_scroll_bar()
end

-- Lines: 169 to 170
function CrimeSpreeContractBoxGui:mouse_wheel_down()
end

-- Lines: 172 to 173
function CrimeSpreeContractBoxGui:mouse_wheel_up()
end

-- Lines: 175 to 176
function CrimeSpreeContractBoxGui:check_grab_scroll_bar()
	return false
end

-- Lines: 179 to 180
function CrimeSpreeContractBoxGui:release_scroll_bar()
	return false
end

