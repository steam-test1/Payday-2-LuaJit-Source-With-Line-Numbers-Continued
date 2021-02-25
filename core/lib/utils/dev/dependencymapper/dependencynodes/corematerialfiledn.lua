core:module("CoreMaterialfileDn")
core:import("CoreClass")
core:import("CoreDependencyNode")

MATERIALS_FILE = CoreDependencyNode.MATERIALS_FILE
TEXTURE = CoreDependencyNode.TEXTURE
local _FILE = "./data/settings/materials.xml"
MaterialsfileDependencyNode = MaterialsfileDependencyNode or CoreClass.class(CoreDependencyNode.DependencyNodeBase)

-- Lines 15-17
function MaterialsfileDependencyNode:init(name, get_dn_cb, database)
	self.super.init(self, MATERIALS_FILE, nil, name, get_dn_cb, database)
end

-- Lines 19-24
function MaterialsfileDependencyNode:_parse()
	local f = File:open(_FILE, "r")
	local xmlnode = Node.from_xml(f:read())

	f:close()

	return {
		xmlnode
	}
end

-- Lines 26-38
function MaterialsfileDependencyNode:_walkxml2dependencies(xmlnode, deps)
	local node_name = xmlnode:name()

	if node_name ~= "material" then
		local texture_name = xmlnode:parameter("file")

		if texture_name ~= nil then
			local dn = self._get_dn({
				name = texture_name,
				type_ = TEXTURE
			})

			deps:add(dn)

			if dn == nil then
				Application:error("When parsing material: " .. self._name .. ", can not locate texture: " .. texture_name)
			end
		end
	end
end
