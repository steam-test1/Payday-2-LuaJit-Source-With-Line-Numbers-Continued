core:module("CoreHelperUnitManager")
core:import("CoreClass")

HelperUnitManager = HelperUnitManager or CoreClass.class()

-- Lines 7-9
function HelperUnitManager:init()
	self:_setup()
end

-- Lines 11-13
function HelperUnitManager:clear()
	self:_setup()
end

-- Lines 15-17
function HelperUnitManager:_setup()
	self._types = {}
end

-- Lines 19-22
function HelperUnitManager:add_unit(unit, type)
	self._types[type] = self._types[type] or {}

	table.insert(self._types[type], unit)
end

-- Lines 24-26
function HelperUnitManager:get_units_by_type(type)
	return self._types[type] or {}
end
