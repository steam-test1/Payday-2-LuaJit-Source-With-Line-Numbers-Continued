core:module("CoreInputTargetDescription")

TargetDescription = TargetDescription or class()

-- Lines 5-9
function TargetDescription:init(name, type_name)
	self._name = name

	assert(type_name == "bool" or type_name == "vector")

	self._type_name = type_name
end

-- Lines 11-13
function TargetDescription:target_name()
	return self._name
end

-- Lines 15-17
function TargetDescription:target_type_name()
	return self._type_name
end
