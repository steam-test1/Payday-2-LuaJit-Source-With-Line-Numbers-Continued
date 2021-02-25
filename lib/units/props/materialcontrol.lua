MaterialControl = MaterialControl or class()

-- Lines 3-5
function MaterialControl:init(unit)
	self._unit = unit
end

-- Lines 8-20
function MaterialControl:save(save_data)
	local data = {}
	local materials = self._unit:get_objects_by_type(Idstring("material"))

	for idx, material in ipairs(materials) do
		local material_data = {
			time = material:time(),
			playing = material:is_playing(),
			playing_speed = material:playing_speed()
		}
		data[idx] = material_data
	end

	save_data.material_control = data
end

-- Lines 23-41
function MaterialControl:load(load_data)
	local data = load_data.material_control

	if not data then
		return
	end

	local materials = self._unit:get_objects_by_type(Idstring("material"))

	for idx, material in ipairs(materials) do
		local material_data = data[idx]

		if material_data then
			if material_data.is_playing then
				material:play(material_data.playing_speed)
				material:set_time(material_data.time)
			else
				material:stop()
				material:set_time(material_data.time)
			end
		end
	end
end

-- Lines 44-54
function MaterialControl:play(material_name, speed)
	local materials = self._unit:get_objects_by_type(Idstring("material"))
	local material_id = Idstring(material_name)

	for i, material in ipairs(materials) do
		if material:name() == material_id then
			Application:trace("***********  PLAYING: ", material_name, ",   speed:  ", speed)
			material:play(speed)
		end
	end
end

-- Lines 57-67
function MaterialControl:stop(material_name)
	local materials = self._unit:get_objects_by_type(Idstring("material"))
	local material_id = Idstring(material_name)

	for _, material in ipairs(materials) do
		if material:name() == material_id then
			Application:trace("***********  STOPPING: ", material_name)
			material:stop()
		end
	end
end

-- Lines 70-80
function MaterialControl:pause(material_name)
	local materials = self._unit:get_objects_by_type(Idstring("material"))
	local material_id = Idstring(material_name)

	for _, material in ipairs(materials) do
		if material:name() == material_id then
			Application:trace("***********  PAUSING: ", material_name)
			material:pause()
		end
	end
end

-- Lines 83-93
function MaterialControl:set_time(material_name, time)
	local materials = self._unit:get_objects_by_type(Idstring("material"))
	local material_id = Idstring(material_name)

	for _, material in ipairs(materials) do
		if material:name() == material_id then
			Application:trace("***********  SETTIMT TIME: ", material_name, "  ", time)
			material:set_time(time)
		end
	end
end
