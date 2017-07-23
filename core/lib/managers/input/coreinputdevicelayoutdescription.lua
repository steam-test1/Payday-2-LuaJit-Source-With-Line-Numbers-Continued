core:module("CoreInputDeviceLayoutDescription")

DeviceLayoutDescription = DeviceLayoutDescription or class()

-- Lines: 5 to 9
function DeviceLayoutDescription:init(device_type)
	assert(device_type == "xbox_controller" or device_type == "ps3_controller" or device_type == "win32_mouse")

	self._device_type = device_type
	self._binds = {}
end

-- Lines: 11 to 12
function DeviceLayoutDescription:device_type()
	return self._device_type
end

-- Lines: 15 to 17
function DeviceLayoutDescription:add_bind_button(hardware_button_name, input_target_description)
	self._binds[hardware_button_name] = {
		type_name = "button",
		input_target_description = input_target_description
	}
end

-- Lines: 19 to 21
function DeviceLayoutDescription:add_bind_axis(hardware_axis_name, input_target_description)
	self._binds[hardware_axis_name] = {
		type_name = "axis",
		input_target_description = input_target_description
	}
end

-- Lines: 23 to 24
function DeviceLayoutDescription:binds()
	return self._binds
end

