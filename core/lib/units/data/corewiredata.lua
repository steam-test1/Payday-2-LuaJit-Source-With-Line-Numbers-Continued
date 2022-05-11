CoreWireData = CoreWireData or class()

-- Lines 3-8
function CoreWireData:init(unit)
	self.slack = 0
	self.target_rot = 0

	unit:set_extension_update_enabled(Idstring("wire_data"), false)
end
