core:module("CoreUnitCamera")
core:import("CoreClass")
core:import("CoreEvent")

UnitCamera = UnitCamera or CoreClass.class()

-- Lines 7-10
function UnitCamera:init(unit)
	self._unit = unit
	self._active_count = 0
end

-- Lines 12-13
function UnitCamera:destroy()
end

-- Lines 15-16
function UnitCamera:create_layers()
end

-- Lines 18-24
function UnitCamera:activate()
	local is_deactivated = self._active_count == 0
	self._active_count = self._active_count + 1

	if is_deactivated then
		self:on_activate(true)
	end
end

-- Lines 26-34
function UnitCamera:deactivate()
	assert(self._active_count > 0)

	self._active_count = self._active_count - 1
	local should_deactivate = self._active_count == 0

	if should_deactivate then
		self:on_activate(false)
	end

	return should_deactivate
end

-- Lines 36-37
function UnitCamera:on_activate(active)
end

-- Lines 39-41
function UnitCamera:is_active()
	return self._active_count > 0
end

-- Lines 48-50
function UnitCamera:apply_camera(camera_manager)
end
