HUDObjectivesVR = HUDObjectives
HUDObjectivesVR.old_init = HUDObjectives.init

-- Lines: 6 to 13
function HUDObjectivesVR:init(hud)
	hud.old_panel = hud.panel
	hud.panel = managers.hud:tablet_page()

	self:old_init(hud)
	self._hud_panel:child("objectives_panel"):set_y(45)

	hud.panel = hud.old_panel
	hud.old_panel = nil
end

