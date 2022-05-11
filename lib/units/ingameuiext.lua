IngameUIExt = IngameUIExt or class()

-- Lines 3-13
function IngameUIExt:init(unit)
	self._unit = unit

	unit:set_extension_update_enabled(Idstring("ingame_ui"), false)

	if self.objects then
		for name, object in pairs(self.objects) do
			managers.hud:register_ingame_workspace(name, self._unit:get_object(Idstring(object)))
		end
	end
end
