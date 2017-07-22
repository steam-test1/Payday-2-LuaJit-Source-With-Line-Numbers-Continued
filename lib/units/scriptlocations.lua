ScriptLocations = ScriptLocations or class()

-- Lines: 4 to 5
function ScriptLocations:init(unit)
end

-- Lines: 7 to 14
function ScriptLocations:setup(callback)
	if callback then
		self._unit:set_extension_update_enabled("roaming_data", true)
	else
		self._unit:set_extension_update_enabled("roaming_data", false)
	end

	self._updator = callback
end

return
