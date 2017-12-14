core:import("CoreOverlayEffectManager")

OverlayEffectManager = OverlayEffectManager or class(CoreOverlayEffectManager.OverlayEffectManager)

-- Lines: 10 to 24
function OverlayEffectManager:init()
	OverlayEffectManager.super.init(self)

	for name, setting in pairs(tweak_data.overlay_effects) do
		self:add_preset(name, setting)
	end
end

CoreClass.override_class(CoreOverlayEffectManager.OverlayEffectManager, OverlayEffectManager)

