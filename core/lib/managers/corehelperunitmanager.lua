core:module("CoreHelperUnitManager")
core:import("CoreClass")

HelperUnitManager = HelperUnitManager or CoreClass.class()

-- Lines: 7 to 9
function HelperUnitManager:init()
	self:_setup()
end

-- Lines: 11 to 13
function HelperUnitManager:clear()
	self:_setup()
end

-- Lines: 15 to 17
function HelperUnitManager:_setup()
	self._types = {}
end

-- Lines: 19 to 22
function HelperUnitManager:add_unit(unit, type)
	self._types[type] = self._types[type] or {}

	table.insert(self._types[type], unit)
end

-- Lines: 24 to 25
function HelperUnitManager:get_units_by_type(type)
	return self._types[type] or {}
end

