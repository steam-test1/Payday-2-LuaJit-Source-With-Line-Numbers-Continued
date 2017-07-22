require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreChangeCameraAttributeCutsceneKey = CoreChangeCameraAttributeCutsceneKey or class(CoreCutsceneKeyBase)
CoreChangeCameraAttributeCutsceneKey.ELEMENT_NAME = "camera_attribute"
CoreChangeCameraAttributeCutsceneKey.NAME = "Camera Attribute"

CoreChangeCameraAttributeCutsceneKey:register_serialized_attribute("near_range", nil, tonumber)
CoreChangeCameraAttributeCutsceneKey:register_serialized_attribute("far_range", nil, tonumber)
CoreChangeCameraAttributeCutsceneKey:attribute_affects("near_range", "far_range")
CoreChangeCameraAttributeCutsceneKey:attribute_affects("far_range", "near_range")


-- Lines: 11 to 12
function CoreChangeCameraAttributeCutsceneKey:__tostring()
	return "Change camera attributes."
end

-- Lines: 15 to 21
function CoreChangeCameraAttributeCutsceneKey:populate_from_editor(cutscene_editor)
	self.super.populate_from_editor(self, cutscene_editor)

	local camera_attributes = cutscene_editor:camera_attributes()

	self:set_near_range(camera_attributes.near_range)
	self:set_far_range(camera_attributes.far_range)
end

-- Lines: 23 to 24
function CoreChangeCameraAttributeCutsceneKey:is_valid()
	return true
end

-- Lines: 33 to 39
function CoreChangeCameraAttributeCutsceneKey:evaluate(player, fast_forward)

	-- Lines: 28 to 34
	local function set_attribute_if_valid(attribute_name)
		local value = self:attribute_value(attribute_name)

		if value and self["is_valid_" .. attribute_name](self, value) then
			player:set_camera_attribute(attribute_name, value)
		end
	end

	for attribute_name, _ in pairs(self.__serialized_attributes) do
		set_attribute_if_valid(attribute_name)
	end
end

-- Lines: 41 to 42
function CoreChangeCameraAttributeCutsceneKey:is_valid_near_range(value)
	return value == nil or value > 0 and value < (self:far_range() or math.huge)
end

-- Lines: 45 to 46
function CoreChangeCameraAttributeCutsceneKey:is_valid_far_range(value)
	return value == nil or (self:near_range() or 0) < value
end

return
