DLCFlaggedUnit = DLCFlaggedUnit or class()

-- Lines 4-36
function DLCFlaggedUnit:init(unit, update_enabled)
	self._unit = unit

	unit:set_extension_update_enabled(Idstring("flagged_unit"), false)
end
