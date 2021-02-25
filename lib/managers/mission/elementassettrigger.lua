core:import("CoreMissionScriptElement")

ElementAssetTrigger = ElementAssetTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementAssetTrigger:init(...)
	ElementAssetTrigger.super.init(self, ...)
end

-- Lines 9-11
function ElementAssetTrigger:client_on_executed(...)
end

-- Lines 13-16
function ElementAssetTrigger:on_script_activated()
	managers.assets:add_trigger(self._id, "asset", self._values.id, callback(self, self, "on_executed"))
end

-- Lines 18-25
function ElementAssetTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementAssetTrigger.super.on_executed(self, instigator)
end
