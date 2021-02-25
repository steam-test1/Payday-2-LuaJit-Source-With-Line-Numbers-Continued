HUDChatVR = HUDChat
HUDChatVR.old_init = HUDChat.init

-- Lines 6-16
function HUDChatVR:init(ws, hud)
	local old_panel = hud.panel
	hud.panel = managers.hud:tablet_page("left_page")

	self:old_init(managers.hud:tablet_ws(), hud)
	self._panel:set_bottom(self._hud_panel:h())

	hud.panel = old_panel
end

HUDChatVR.default_layout_output_panel = HUDChat._layout_output_panel

-- Lines 19-23
function HUDChatVR:_layout_output_panel()
	self:default_layout_output_panel()
	self._panel:child("output_panel"):set_bottom(self._panel:h())
end

-- Lines 42-43
function HUDChatVR:_animate_fade_output()
end

-- Lines 46-48
function HUDChatVR:_animate_show_component(o)
	o:set_alpha(1)
end
