BaseModifier = BaseModifier or class()
BaseModifier._type = "BaseModifier"
BaseModifier.name_id = "none"
BaseModifier.desc_id = "none"
BaseModifier.default_value = nil
BaseModifier.total_localization = nil

-- Lines 9-12
function BaseModifier:init(data)
	self._data = data
end

-- Lines 14-16
function BaseModifier:destroy()
end

-- Lines 18-27
function BaseModifier:value(id)
	id = id or self.default_value

	return self._data[id]
end
