core:module("CoreEffectDn")
core:import("CoreClass")
core:import("CoreDependencyNode")

TEXTURE = CoreDependencyNode.TEXTURE
EFFECT = CoreDependencyNode.EFFECT
EffectDependencyNode = EffectDependencyNode or CoreClass.class(CoreDependencyNode.DependencyNodeBase)

-- Lines: 13 to 15
function EffectDependencyNode:init(name, get_dn_cb, database)
	self.super.init(self, EFFECT, "effect", name, get_dn_cb, database)
end

-- Lines: 17 to 26
function EffectDependencyNode:_walkxml2dependencies(xmlnode, deps)
	local texture_name = xmlnode:parameter("texture")

	if texture_name ~= nil then
		local dn = self._get_dn({
			name = texture_name,
			type_ = TEXTURE
		})

		deps:add(dn)

		if dn == nil then
			Application:error("When parsing effect: " .. self._name .. ", can not locate texture: " .. texture_name)
		end
	end
end

