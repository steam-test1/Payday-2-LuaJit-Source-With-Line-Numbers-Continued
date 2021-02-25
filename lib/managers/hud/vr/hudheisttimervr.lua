HUDHeistTimerVR = HUDHeistTimer
HUDHeistTimerVR.old_init = HUDHeistTimer.init

-- Lines 6-18
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
	VRManagerPD2.overlay_helper(managers.hud:watch_panel())
end

-- Lines 20-22
function HUDHeistTimerVR:hide()
	self._heist_timer_panel:hide()
end

-- Lines 24-26
function HUDHeistTimerVR:show()
	self._heist_timer_panel:show()
end
