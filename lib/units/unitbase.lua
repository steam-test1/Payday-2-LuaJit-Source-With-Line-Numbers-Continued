UnitBase = UnitBase or class()

-- Lines 3-20
function UnitBase:init(unit, update_enabled)
	self._unit = unit

	if not update_enabled then
		unit:set_extension_update_enabled(Idstring("base"), false)
	end
end

-- Lines 24-33
function UnitBase:add_destroy_listener(key, clbk)
	if self._destroying then
		Application:error("[UnitBase:add_destroy_listener] Attempted to add a destroy listener when unit is being destroyed!", self._unit, key)

		return
	end

	self._destroy_listener_holder = self._destroy_listener_holder or ListenerHolder:new()

	self._destroy_listener_holder:add(key, clbk)
end

-- Lines 37-50
function UnitBase:remove_destroy_listener(key)
	if not self._destroy_listener_holder then
		return
	end

	self._destroy_listener_holder:remove(key)

	if self._destroy_listener_holder:is_empty() then
		self._destroy_listener_holder = nil
	end
end

-- Lines 54-56
function UnitBase:save(data)
	return
end

-- Lines 58-68
function UnitBase:load(data)
	managers.worlddefinition:use_me(self._unit)
end

-- Lines 72-84
function UnitBase:pre_destroy(unit)
	self._destroying = true

	if self._destroy_listener_holder then
		self._destroy_listener_holder:call(unit)
	end
end

-- Lines 88-102
function UnitBase:destroy(unit)
	if self._destroying then
		return
	end

	if self._destroy_listener_holder then
		self._destroy_listener_holder:call(unit)
	end
end

-- Lines 106-108
function UnitBase:set_slot(unit, slot)
	unit:set_slot(slot)
end
