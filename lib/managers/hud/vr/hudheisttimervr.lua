HUDHeistTimerVR = HUDHeistTimer
HUDHeistTimerVR.old_init = HUDHeistTimer.init

-- Lines: 5 to 15
function HUDHeistTimerVR:init(hud, tweak_hud)
	hud.old_panel = hud.panel
	hud.panel = managers.hud:watch_panel()

	self:old_init(hud, tweak_hud)

	hud.panel = hud.old_panel
	hud.old_panel = nil

	self._heist_timer_panel:set_valign("center")
	self._heist_timer_panel:set_center_y(self._hud_panel:center_y())
	self._timer_text:set_font_size(26)
	self._timer_text:set_vertical("center")
end

-- Lines: 17 to 19
function HUDHeistTimerVR:hide()
	self._heist_timer_panel:hide()
end

-- Lines: 21 to 23
function HUDHeistTimerVR:show()
	self._heist_timer_panel:show()
end

