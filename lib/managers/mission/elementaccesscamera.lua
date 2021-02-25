core:import("CoreMissionScriptElement")

ElementAccessCamera = ElementAccessCamera or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-10
function ElementAccessCamera:init(...)
	ElementAccessCamera.super.init(self, ...)

	self._camera_unit = nil
	self._triggers = {}
end

-- Lines 12-29
function ElementAccessCamera:on_script_activated()
	if self._values.camera_u_id then
		local id = self._values.camera_u_id
		local unit = nil

		if Global.running_simulation then
			unit = managers.editor:unit_with_id(id)
		else
			unit = managers.worlddefinition:get_unit_on_load(id, callback(self, self, "_load_unit"))
		end

		if unit then
			unit:base():set_access_camera_mission_element(self)

			self._camera_unit = unit
		end
	end

	self._has_fetched_units = true

	self._mission_script:add_save_state_cb(self._id)
end

-- Lines 31-36
function ElementAccessCamera:_load_unit(unit)
	unit:base():set_access_camera_mission_element(self)

	self._camera_unit = unit
end

-- Lines 38-40
function ElementAccessCamera:client_on_executed(...)
end

-- Lines 42-48
function ElementAccessCamera:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementAccessCamera.super.on_executed(self, instigator)
end

-- Lines 50-54
function ElementAccessCamera:access_camera_operation_destroy()
	self._values.destroyed = true

	self:check_triggers("destroyed")
end

-- Lines 56-60
function ElementAccessCamera:add_trigger(id, type, callback)
	self._triggers[type] = self._triggers[type] or {}
	self._triggers[type][id] = {
		callback = callback
	}
end

-- Lines 62-66
function ElementAccessCamera:remove_trigger(id, type)
	if self._triggers[type] then
		self._triggers[type][id] = nil
	end
end

-- Lines 68-74
function ElementAccessCamera:trigger_accessed(instigator)
	if Network:is_client() then
		managers.network:session():send_to_host("to_server_access_camera_trigger", self._id, "accessed", instigator)
	else
		self:check_triggers("accessed", instigator)
	end
end

-- Lines 76-85
function ElementAccessCamera:check_triggers(type, instigator)
	if not self._triggers[type] then
		return
	end

	for id, cb_data in pairs(self._triggers[type]) do
		cb_data.callback(instigator)
	end
end

-- Lines 87-96
function ElementAccessCamera:enabled(...)
	if alive(self._camera_unit) then
		if self._camera_unit:base() and self._camera_unit:base().is_security_camera and self._camera_unit:base().access_enabled then
			return self._camera_unit:base():access_enabled()
		end

		return self._camera_unit:enabled()
	end

	return ElementAccessCamera.super.enabled(self, ...)
end

-- Lines 98-100
function ElementAccessCamera:has_camera_unit()
	return alive(self._camera_unit) and true or false
end

-- Lines 102-107
function ElementAccessCamera:camera_unit()
	if alive(self._camera_unit) then
		return self._camera_unit
	end

	return nil
end

-- Lines 109-114
function ElementAccessCamera:camera_position()
	if alive(self._camera_unit) then
		return self._camera_unit:get_object(Idstring("CameraLens")):position()
	end

	return self:value("position")
end

-- Lines 116-118
function ElementAccessCamera:camera_rotation()
	return self:value("rotation")
end

-- Lines 120-122
function ElementAccessCamera:is_moving()
	return alive(self._camera_unit) and self._camera_unit:base() and self._camera_unit:base().update_position
end

-- Lines 124-137
function ElementAccessCamera:m_camera_rotation(m_rot)
	if not m_rot then
		return self:camera_rotation()
	end

	if alive(self._camera_unit) then
		self._camera_unit:get_object(Idstring("CameraLens")):m_rotation(m_rot)

		return m_rot
	end

	mrotation.set_zero(m_rot)
	mrotation.multiply(m_rot, self:value("rotation"))

	return m_rot
end

-- Lines 139-150
function ElementAccessCamera:m_camera_position(m_vec)
	if not m_vec then
		return self:camera_position()
	end

	if alive(self._camera_unit) then
		self._camera_unit:get_object(Idstring("CameraLens")):m_position(m_vec)

		return m_vec
	end

	mvector3.set(m_vec, self:value("position"))

	return m_vec
end

-- Lines 153-156
function ElementAccessCamera:save(data)
	data.enabled = self._values.enabled
	data.destroyed = self._values.destroyed
end

-- Lines 158-164
function ElementAccessCamera:load(data)
	self:set_enabled(data.enabled)

	self._values.destroyed = data.destroyed

	if not self._has_fetched_units then
		self:on_script_activated()
	end
end

ElementAccessCameraOperator = ElementAccessCameraOperator or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 170-172
function ElementAccessCameraOperator:init(...)
	ElementAccessCameraOperator.super.init(self, ...)
end

-- Lines 174-176
function ElementAccessCameraOperator:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 178-193
function ElementAccessCameraOperator:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element and self._values.operation == "destroy" then
			element:access_camera_operation_destroy()
		end
	end

	ElementAccessCameraOperator.super.on_executed(self, instigator)
end

ElementAccessCameraTrigger = ElementAccessCameraTrigger or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 199-201
function ElementAccessCameraTrigger:init(...)
	ElementAccessCameraTrigger.super.init(self, ...)
end

-- Lines 203-208
function ElementAccessCameraTrigger:on_script_activated()
	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		element:add_trigger(self._id, self._values.trigger_type, callback(self, self, "on_executed"))
	end
end

-- Lines 210-212
function ElementAccessCameraTrigger:client_on_executed(...)
end

-- Lines 214-220
function ElementAccessCameraTrigger:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementAccessCameraTrigger.super.on_executed(self, instigator)
end
