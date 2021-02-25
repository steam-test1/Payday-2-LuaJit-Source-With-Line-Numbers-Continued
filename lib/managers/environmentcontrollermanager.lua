EnvironmentControllerManager = EnvironmentControllerManager or class(CoreEnvironmentControllerManager)

-- Lines 3-11
function EnvironmentControllerManager:init()
	EnvironmentControllerManager.super.init(self)

	if _G.IS_VR then
		self:set_dof_setting("none")
	end
end

-- Lines 13-21
function EnvironmentControllerManager:set_dof_setting(setting)
	if _G.IS_VR then
		setting = "none"
	end

	EnvironmentControllerManager.super.set_dof_setting(self, setting)
end

CoreClass.override_class(CoreEnvironmentControllerManager, EnvironmentControllerManager)
