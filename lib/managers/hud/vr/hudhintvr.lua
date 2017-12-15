HUDHintVR = HUDHint
HUDHintVR.old_init = HUDHint.init

-- Lines: 6 to 12
function HUDHintVR:init(hud)
	hud.old_panel = hud.panel
	hud.panel = managers.hud:prompt_panel()

	self:old_init(hud)

	hud.panel = hud.old_panel
	hud.old_panel = nil
end

