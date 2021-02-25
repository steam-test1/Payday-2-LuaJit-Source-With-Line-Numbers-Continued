UnitBase = UnitBase or class()

-- Lines 3-9
function UnitBase:init(unit, update_enabled)
	self._unit = unit

	if not update_enabled then
		unit:set_extension_update_enabled(Idstring("base"), false)
	end

	self._destroy_listener_holder = ListenerHolder:new()
end

-- Lines 13-17
function UnitBase:add_destroy_listener(key, clbk)
	if not self._destroying then
		self._destroy_listener_holder:add(key, clbk)
	end
end

-- Lines 21-23
function UnitBase:remove_destroy_listener(key)
	self._destroy_listener_holder:remove(key)
end

-- Lines 27-29
function UnitBase:save(data)
end

-- Lines 31-33
function UnitBase:load(data)
	managers.worlddefinition:use_me(self._unit)
end

-- Lines 37-40
function UnitBase:pre_destroy(unit)
	self._destroying = true

	self._destroy_listener_holder:call(unit)
end

-- Lines 44-49
function UnitBase:destroy(unit)
	if self._destroying then
		return
	end

	self._destroy_listener_holder:call(unit)
end

-- Lines 53-55
function UnitBase:set_slot(unit, slot)
	unit:set_slot(slot)
end
