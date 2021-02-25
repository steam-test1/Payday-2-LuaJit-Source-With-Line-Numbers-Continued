core:module("CoreTransformCameraNode")
core:import("CoreClass")
core:import("CoreMath")

local mvector3_add = mvector3.add
local mvector3_sub = mvector3.subtract
local mvector3_set = mvector3.set
local mvector3_rotate_with = mvector3.rotate_with
local mrotation_set_zero = mrotation.set_zero
local mrotation_mul = mrotation.multiply
TransformCameraNode = TransformCameraNode or CoreClass.class()

-- Lines 15-40
function TransformCameraNode:init(settings)
	self._child = nil
	self._parent_camera = nil
	self._local_position = settings.position
	self._local_rotation = settings.rotation
	self._local_fov = settings.fov
	self._local_dof_near_min = settings.dof_near_min
	self._local_dof_near_max = settings.dof_near_max
	self._local_dof_far_min = settings.dof_far_min
	self._local_dof_far_max = settings.dof_far_max
	self._local_dof_amount = settings.dof_amount
	self._position = Vector3(0, 0, 0)
	self._rotation = Rotation()
	self._name = settings.name
	self._settings = settings
end

-- Lines 42-92
function TransformCameraNode.compile_settings(xml_node, settings)
	if xml_node:has_parameter("name") then
		settings.name = xml_node:parameter("name")
	end

	if xml_node:has_parameter("position") then
		settings.position = CoreMath.string_to_vector(xml_node:parameter("position"))
	else
		settings.position = Vector3(0, 0, 0)
	end

	if xml_node:has_parameter("rotation") then
		settings.rotation = CoreMath.string_to_rotation(xml_node:parameter("rotation"))
	else
		settings.rotation = Rotation()
	end

	if xml_node:has_parameter("fov") then
		settings.fov = tonumber(xml_node:parameter("fov"))
	else
		settings.fov = 0
	end

	if xml_node:has_parameter("dof_near_min") then
		settings.dof_near_min = tonumber(xml_node:parameter("dof_near_min"))
	else
		settings.dof_near_min = 0
	end

	if xml_node:has_parameter("dof_near_max") then
		settings.dof_near_max = tonumber(xml_node:parameter("dof_near_max"))
	else
		settings.dof_near_max = 0
	end

	if xml_node:has_parameter("dof_far_min") then
		settings.dof_far_min = tonumber(xml_node:parameter("dof_far_min"))
	else
		settings.dof_far_min = 0
	end

	if xml_node:has_parameter("dof_far_max") then
		settings.dof_far_max = tonumber(xml_node:parameter("dof_far_max"))
	else
		settings.dof_far_max = 0
	end

	if xml_node:has_parameter("dof_amount") then
		settings.dof_amount = tonumber(xml_node:parameter("dof_amount"))
	else
		settings.dof_amount = 0
	end
end

-- Lines 94-97
function TransformCameraNode:destroy()
	self._child = nil
	self._parent_camera = nil
end

-- Lines 99-101
function TransformCameraNode:name()
	return self._name
end

-- Lines 103-106
function TransformCameraNode:set_parent(camera)
	camera._child = self
	self._parent_camera = camera
end

-- Lines 108-110
function TransformCameraNode:child()
	return self._child
end

-- Lines 113-115
function TransformCameraNode:set_local_position(position)
	self._local_position = position
end

-- Lines 117-119
function TransformCameraNode:set_local_rotation(rotation)
	self._local_rotation = rotation
end

-- Lines 121-132
function TransformCameraNode:set_local_position_from_world_position(position)
	local parent_camera = self._parent_camera

	if parent_camera then
		local parent_position = parent_camera:position()
		local parent_rotation = parent_camera:rotation()

		mvector3_set(self._local_position, position)
		mvector3_sub(self._local_position, parent_camera:position())
		mvector3_rotate_with(self._local_position, parent_camera:rotation():inverse())
	else
		mvector3_set(self._local_position, position)
	end
end

-- Lines 134-142
function TransformCameraNode:set_local_rotation_from_world_rotation(rotation)
	local parent_camera = self._parent_camera

	if parent_camera then
		local parent_rotation = parent_camera:rotation()
		self._local_rotation = parent_rotation:inverse() * rotation
	else
		self._local_rotation = rotation
	end
end

-- Lines 144-146
function TransformCameraNode:position()
	return self._position
end

-- Lines 148-150
function TransformCameraNode:rotation()
	return self._rotation
end

-- Lines 152-154
function TransformCameraNode:local_position()
	return self._local_position
end

-- Lines 156-158
function TransformCameraNode:local_rotation()
	return self._local_rotation
end

-- Lines 161-172
function TransformCameraNode:update(t, dt, in_data, out_data)
	if self._pivot_position then
		out_data:set_pivot_position(self._pivot_position)
	end

	if self._pivot_rotation then
		out_data:set_pivot_rotation(self._pivot_rotation)
	end

	out_data:set_position(self._local_position)
	out_data:set_rotation(self._local_rotation)
	out_data:set_fov(self._local_fov)
	out_data:set_dof(self._local_dof_amount, self._local_dof_near_min, self._local_dof_near_max, self._local_dof_far_min, self._local_dof_far_max)
end

-- Lines 174-188
function TransformCameraNode:debug_render(t, dt)
	local x_pen = Draw:pen(Color(0.05, 1, 0, 0))
	local y_pen = Draw:pen(Color(0.05, 0, 1, 0))
	local z_pen = Draw:pen(Color(0.05, 0, 0, 1))
	local position = self._position
	local rotation = self._rotation

	x_pen:line(position, position + rotation:x() * 2)
	y_pen:line(position, position + rotation:y() * 2)
	z_pen:line(position, position + rotation:z() * 2)

	local brush = Draw:brush(Color(0.3, 1, 1, 1))

	brush:sphere(position, 1)
end

-- Lines 190-192
function TransformCameraNode:parent_camera()
	return self._parent_camera
end
