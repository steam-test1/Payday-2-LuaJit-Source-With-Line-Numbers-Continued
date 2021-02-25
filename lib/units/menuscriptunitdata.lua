ScriptUnitData = ScriptUnitData or class()
UnitBase = UnitBase or class()

-- Lines 4-9
function UnitBase:init(unit, update_enabled)
	self._unit = unit

	if not update_enabled then
		unit:set_extension_update_enabled(Idstring("base"), false)
	end
end

-- Lines 11-12
function UnitBase:destroy(unit)
end

-- Lines 15-17
function UnitBase:pre_destroy(unit)
	self._destroying = true
end
