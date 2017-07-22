require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")

CoreShakeCameraCutsceneKey = CoreShakeCameraCutsceneKey or class(CoreCutsceneKeyBase)
CoreShakeCameraCutsceneKey.ELEMENT_NAME = "camera_shaker"
CoreShakeCameraCutsceneKey.NAME = "Camera Shake"

CoreShakeCameraCutsceneKey:register_serialized_attribute("name", "")
CoreShakeCameraCutsceneKey:register_serialized_attribute("amplitude", 1, tonumber)
CoreShakeCameraCutsceneKey:register_serialized_attribute("frequency", 1, tonumber)
CoreShakeCameraCutsceneKey:register_serialized_attribute("offset", 0, tonumber)


-- Lines: 11 to 12
function CoreShakeCameraCutsceneKey:__tostring()
	return "Trigger camera shake \"" .. self:name() .. "\"."
end

-- Lines: 15 to 22
function CoreShakeCameraCutsceneKey:play(player, undo, fast_forward)
	if undo then
		self:stop()
	elseif not fast_forward then
		self:stop()

		self._shake_abort_func = player:play_camera_shake(self:name(), self:amplitude(), self:frequency(), self:offset())
	end
end

-- Lines: 24 to 29
function CoreShakeCameraCutsceneKey:stop()
	if self._shake_abort_func then
		self._shake_abort_func()

		self._shake_abort_func = nil
	end
end

return
