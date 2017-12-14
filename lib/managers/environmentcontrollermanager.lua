EnvironmentControllerManager = EnvironmentControllerManager or class(CoreEnvironmentControllerManager)

-- Lines: 3 to 11
function EnvironmentControllerManager:init()
	EnvironmentControllerManager.super.init(self)
end

-- Lines: 19 to 21
function EnvironmentControllerManager:set_dof_setting(setting)
	EnvironmentControllerManager.super.set_dof_setting(self, setting)
end

CoreClass.override_class(CoreEnvironmentControllerManager, EnvironmentControllerManager)

