core:module("CoreModelDn")
core:import("CoreClass")
core:import("CoreDependencyNode")

MODEL = CoreDependencyNode.MODEL
ModelDependencyNode = ModelDependencyNode or CoreClass.class(CoreDependencyNode.DependencyNodeBase)

-- Lines 12-14
function ModelDependencyNode:init(name, get_dn_cb, database)
	self.super.init(self, MODEL, "model", name, get_dn_cb, database)
end

-- Lines 16-18
function ModelDependencyNode:_parse()
	return {}
end
