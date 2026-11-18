local IDS_BASE = Idstring("base")
local IDS_UNIT_DATA = Idstring("unit_data")

ScriptUnitData = ScriptUnitData or class()

-- Lines 7-9
function ScriptUnitData:init(unit)
	unit:set_extension_update_enabled(IDS_UNIT_DATA, false)
end

-- Lines 11-17
function ScriptUnitData:pre_destroy(unit)
	self._destroying = true

	if self._destroy_listener_holder then
		self._destroy_listener_holder:call(unit)
	end
end

-- Lines 19-27
function ScriptUnitData:destroy(unit)
	if self._destroying then
		return
	end

	if self._destroy_listener_holder then
		self._destroy_listener_holder:call(unit)
	end
end

-- Lines 29-37
function ScriptUnitData:add_destroy_listener(key, clbk)
	if self._destroying then
		Application:error("[MenuScriptUnitData] add_destroy_listener() - attempted to add a destroy listener when unit is being destroyed!", self._unit, key, clbk)

		return
	end

	self._destroy_listener_holder = self._destroy_listener_holder or ListenerHolder:new()

	self._destroy_listener_holder:add(key, clbk)
end

-- Lines 39-49
function ScriptUnitData:remove_destroy_listener(key)
	if not self._destroy_listener_holder then
		return
	end

	self._destroy_listener_holder:remove(key)

	if self._destroy_listener_holder:is_empty() then
		self._destroy_listener_holder = nil
	end
end

UnitBase = UnitBase or class()

-- Lines 55-60
function UnitBase:init(unit, update_enabled)
	self._unit = unit

	if not update_enabled then
		unit:set_extension_update_enabled(IDS_BASE, false)
	end
end

-- Lines 62-68
function UnitBase:pre_destroy(unit)
	self._destroying = true

	if self._destroy_listener_holder then
		self._destroy_listener_holder:call(unit)
	end
end

-- Lines 70-78
function UnitBase:destroy(unit)
	if self._destroying then
		return
	end

	if self._destroy_listener_holder then
		self._destroy_listener_holder:call(unit)
	end
end

-- Lines 80-88
function UnitBase:add_destroy_listener(key, clbk)
	if self._destroying then
		Application:error("[MenuUnitBase] add_destroy_listener() - attempted to add a destroy listener when unit is being destroyed!", self._unit, key, clbk)

		return
	end

	self._destroy_listener_holder = self._destroy_listener_holder or ListenerHolder:new()

	self._destroy_listener_holder:add(key, clbk)
end

-- Lines 90-100
function UnitBase:remove_destroy_listener(key)
	if not self._destroy_listener_holder then
		return
	end

	self._destroy_listener_holder:remove(key)

	if self._destroy_listener_holder:is_empty() then
		self._destroy_listener_holder = nil
	end
end
