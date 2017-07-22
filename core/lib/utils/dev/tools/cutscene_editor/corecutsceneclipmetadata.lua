CoreCutsceneClipMetadata = CoreCutsceneClipMetadata or class()

-- Lines: 3 to 6
function CoreCutsceneClipMetadata:init(footage, camera)
	self._footage = footage
	self._camera = camera
end

-- Lines: 9 to 10
function CoreCutsceneClipMetadata:is_valid()
	return self:camera_index() ~= nil
end

-- Lines: 13 to 14
function CoreCutsceneClipMetadata:footage()
	return self._footage
end

-- Lines: 17 to 18
function CoreCutsceneClipMetadata:camera()
	return self._camera
end

-- Lines: 21 to 23
function CoreCutsceneClipMetadata:set_camera(camera)
	self._camera = camera
end

-- Lines: 25 to 26
function CoreCutsceneClipMetadata:camera_index()
	return self:footage() and table.get_vector_index(self:footage():camera_names(), self:camera()) or nil
end

-- Lines: 29 to 35
function CoreCutsceneClipMetadata:camera_icon_image()
	local icon_index = 0

	if self:footage() and self:camera() then
		icon_index = self:footage():camera_icon_index(self:camera())
	end

	return CoreEWS.image_path(string.format("sequencer\\clip_icon_camera_%02i.bmp", icon_index))
end

-- Lines: 38 to 45
function CoreCutsceneClipMetadata:camera_watermark()
	if self:footage() and self:camera() then
		local name_without_prefix = string.match(self:camera(), "camera_(.+)")
		local as_number = tonumber(name_without_prefix)

		return as_number and tostring(as_number) or string.upper(name_without_prefix or "camera"), 12, "ALIGN_CENTER_HORIZONTAL,ALIGN_CENTER_VERTICAL", Vector3(0, -2)
	end

	return nil
end

-- Lines: 48 to 50
function CoreCutsceneClipMetadata:prime_cast(cast)
	self:footage():prime_cast(cast)
end

return
