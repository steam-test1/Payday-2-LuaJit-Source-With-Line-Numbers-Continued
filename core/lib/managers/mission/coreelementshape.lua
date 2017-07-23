local tmp_vec1 = Vector3()

core:module("CoreElementShape")
core:import("CoreShapeManager")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

ElementShape = ElementShape or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines: 11 to 21
function ElementShape:init(...)
	ElementShape.super.init(self, ...)

	self._shapes = {}

	if not self._values.shape_type or self._values.shape_type == "box" then
		self:_add_shape(CoreShapeManager.ShapeBoxMiddle:new({
			position = self._values.position,
			rotation = self._values.rotation,
			width = self._values.width,
			depth = self._values.depth,
			height = self._values.height
		}))
	elseif self._values.shape_type == "cylinder" then
		self:_add_shape(CoreShapeManager.ShapeCylinderMiddle:new({
			position = self._values.position,
			rotation = self._values.rotation,
			height = self._values.height,
			radius = self._values.radius
		}))
	end
end

-- Lines: 23 to 25
function ElementShape:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)
end

-- Lines: 27 to 29
function ElementShape:_add_shape(shape)
	table.insert(self._shapes, shape)
end

-- Lines: 31 to 32
function ElementShape:get_shapes()
	return self._shapes
end

-- Lines: 35 to 41
function ElementShape:is_inside(pos)
	for _, shape in ipairs(self._shapes) do
		if shape:is_inside(pos) then
			return true
		end
	end

	return false
end

-- Lines: 44 to 50
function ElementShape:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementShape.super.on_executed(self, instigator)
end

-- Lines: 52 to 54
function ElementShape:save(data)
	data.enabled = self._values.enabled
end

-- Lines: 56 to 58
function ElementShape:load(data)
	self:set_enabled(data.enabled)
end

