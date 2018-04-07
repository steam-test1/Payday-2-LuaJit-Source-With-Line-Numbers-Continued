require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreChangeCameraCutsceneKey = CoreChangeCameraCutsceneKey or class(CoreCutsceneKeyBase)
CoreChangeCameraCutsceneKey.ELEMENT_NAME = "change_camera"
CoreChangeCameraCutsceneKey.NAME = "Camera Change"

CoreChangeCameraCutsceneKey:register_serialized_attribute("camera", nil)

-- Lines: 8 to 9
function CoreChangeCameraCutsceneKey:__tostring()
	return "Change camera to \"" .. self:camera() .. "\"."
end

-- Lines: 12 to 19
function CoreChangeCameraCutsceneKey:load(key_node, loading_class)
	self.super.load(self, key_node, loading_class)

	if self.__camera == nil then
		self.__camera = key_node:parameter("ref_obj_name") or "camera"
	end
end

-- Lines: 21 to 23
function CoreChangeCameraCutsceneKey:evaluate(player, fast_forward)
	player:set_camera(self:camera())
end

-- Lines: 25 to 26
function CoreChangeCameraCutsceneKey:is_valid_camera(camera)
	return self.super.is_valid_unit_name(self, camera) and string.begins(camera, "camera")
end

