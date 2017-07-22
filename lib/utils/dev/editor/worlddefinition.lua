core:import("CoreWorldDefinition")

WorldDefinition = WorldDefinition or class(CoreWorldDefinition.WorldDefinition)

-- Lines: 5 to 7
function WorldDefinition:init(...)
	WorldDefinition.super.init(self, ...)
end

-- Lines: 10 to 11
function WorldDefinition:_project_assign_unit_data(unit, data)
end

-- Lines: 13 to 19
function WorldDefinition:get_cover_data()
	local path = self:world_dir() .. "cover_data"

	if not DB:has("cover_data", path) then
		return false
	end

	return self:_serialize_to_script("cover_data", path)
end

CoreClass.override_class(CoreWorldDefinition.WorldDefinition, WorldDefinition)

return
