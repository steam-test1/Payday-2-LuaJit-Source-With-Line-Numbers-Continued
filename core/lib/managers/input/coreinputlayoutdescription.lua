core:module("CoreInputLayoutDescription")

LayoutDescription = LayoutDescription or class()

-- Lines 5-8
function LayoutDescription:init(name)
	self._name = name
	self._device_layout_descriptions = {}
end

-- Lines 10-12
function LayoutDescription:layout_name()
	return self._name
end

-- Lines 14-16
function LayoutDescription:add_device_layout_description(device_layout_description)
	self._device_layout_descriptions[device_layout_description:device_type()] = device_layout_description
end

-- Lines 18-20
function LayoutDescription:device_layout_description(device_type)
	return self._device_layout_descriptions[device_type]
end
