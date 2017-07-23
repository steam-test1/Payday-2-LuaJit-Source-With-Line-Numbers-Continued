HUDWaitingLegend = HUDWaitingLegend or class()
local PADDING = 8

-- Lines: 5 to 23
function HUDWaitingLegend:init(hud)
	self._hud_panel = hud.panel
	self._panel = self._hud_panel:panel({
		valign = "bottom",
		halign = "grow",
		h = tweak_data.hud_players.name_size + 16
	})
	self._all_buttons = {
		self:create_button("hud_waiting_accept", "drop_in_accept", "spawn"),
		self:create_button("hud_waiting_return", "drop_in_return", "return_back"),
		self:create_button("hud_waiting_kick", "drop_in_kick", "kick")
	}
	self._icon = self._panel:bitmap({
		texture = "guis/textures/pd2/hud_icon_objectivebox",
		name = "icon_objectivebox",
		h = 24,
		layer = 0,
		w = 24,
		y = 0,
		visible = true,
		blend_mode = "normal",
		halign = "left",
		x = 0,
		valign = "top"
	})
	self._btn_panel = self._panel:panel()

	self._btn_panel:set_left(self._icon:right() + 4)

	self._btn_text = self._btn_panel:text({
		text = "",
		font_size = tweak_data.hud_players.name_size,
		font = tweak_data.hud_players.name_font,
		y = PADDING
	})

	managers.hud:make_fine_text(self._btn_text)
	self._panel:set_visible(false)
end

-- Lines: 25 to 30
function HUDWaitingLegend:create_button(text, binding, func_name)
	return {
		text = text,
		binding = binding,
		callback = callback(self, self, func_name)
	}
end

-- Lines: 33 to 65
function HUDWaitingLegend:update_buttons()
	local str = ""

	for k, btn in pairs(self._all_buttons) do
		local button_text = managers.localization:btn_macro(btn.binding, true, true)

		if button_text then
			str = str .. (str == "" and "" or "  ") .. managers.localization:text(btn.text, {MY_BTN = button_text})
		end
	end

	if str == "" then
		str = managers.localization:text("hud_waiting_no_binding_text")
	end

	self._btn_text:set_text("  " .. str .. "  ")
	managers.hud:make_fine_text(self._btn_text)
	self._btn_panel:set_w(self._btn_text:w())
	self._btn_panel:set_h(self._btn_text:bottom() + PADDING)

	if self._box then
		self._btn_panel:remove(self._box)

		self._box = nil
	end

	self._box = HUDBGBox_create(self._btn_panel)

	if not self._panel:visible() then
		self:animate_open()
	end

	self._panel:set_visible(true)
end

-- Lines: 67 to 78
function HUDWaitingLegend:on_input(button)
	if not self._current_peer or self._block_input_until and Application:time() < self._block_input_until then
		return
	end

	for _, btn in pairs(self._all_buttons) do
		if btn.binding == button and btn.callback then
			btn.callback()

			return
		end
	end
end

-- Lines: 80 to 93
function HUDWaitingLegend:show_on(teammate_hud, peer)
	if self._box then
		self._box:stop()
	end

	local panel = teammate_hud._panel

	self._panel:set_world_leftbottom(panel:world_left(), panel:world_top() + 20)

	self._current_peer = peer or managers.network:session():local_peer()

	self:update_buttons()

	self._block_input_until = Application:time() + 0.5
end

-- Lines: 95 to 120
function HUDWaitingLegend:animate_open()
	self._btn_text:set_visible(false)
	self._box:stop()
	self._box:animate(callback(nil, _G, "HUDBGBox_animate_open_right"), nil, self._box:w(), function ()
		self._btn_text:set_visible(true)
	end)
	self._icon:stop()
	self._icon:animate(function ()
		local TOTAL_T = 3
		local t = TOTAL_T

		self._icon:set_y(0)

		while t > 0 do
			local dt = coroutine.yield()
			t = t - dt

			self._icon:set_y(math.round((1 + math.sin((TOTAL_T - t) * 450 * 2)) * 6 * t / TOTAL_T))
		end

		self._icon:set_y(0)
	end)
end

-- Lines: 122 to 123
function HUDWaitingLegend:peer()
	return self._current_peer
end

-- Lines: 127 to 128
function HUDWaitingLegend:is_set()
	return not not self._current_peer
end

-- Lines: 131 to 134
function HUDWaitingLegend:turn_off()
	self._current_peer = nil

	self._panel:set_visible(false)
end

-- Lines: 136 to 140
function HUDWaitingLegend:spawn()
	if self._current_peer then
		managers.wait:spawn_waiting(self._current_peer:id())
	end
end

-- Lines: 142 to 146
function HUDWaitingLegend:return_back()
	if self._current_peer then
		managers.wait:kick_to_briefing(self._current_peer:id())
	end
end

-- Lines: 148 to 152
function HUDWaitingLegend:kick()
	if self._current_peer then
		managers.vote:message_host_kick(self._current_peer)
	end
end

