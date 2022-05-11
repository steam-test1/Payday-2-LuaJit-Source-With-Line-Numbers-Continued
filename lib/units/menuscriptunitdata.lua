ScriptUnitData = ScriptUnitData or class()

-- Lines 3-5
function ScriptUnitData:init(unit)
	unit:set_extension_update_enabled(Idstring("unit_data"), false)
end

UnitBase = UnitBase or class()

-- Lines 8-13
function UnitBase:init(unit, update_enabled)
	self._unit = unit

	if not update_enabled then
		unit:set_extension_update_enabled(Idstring("base"), false)
	end
end

-- Lines 15-16
function UnitBase:destroy(unit)
end

-- Lines 19-21
function UnitBase:pre_destroy(unit)
	self._destroying = true
end
