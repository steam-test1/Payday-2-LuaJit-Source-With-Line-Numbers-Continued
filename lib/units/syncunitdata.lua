SyncUnitData = SyncUnitData or class()

-- Lines 3-7
function SyncUnitData:init(unit)
	self._unit = unit

	unit:set_extension_update_enabled(Idstring("sync_unit_data"), false)
end

-- Lines 9-31
function SyncUnitData:save(data)
	local state = {
		lights = {}
	}

	for _, light in ipairs(self._unit:get_objects_by_type(Idstring("light"))) do
		local l = {
			name = light:name(),
			enabled = light:enable(),
			far_range = light:far_range(),
			near_range = light:near_range(),
			color = light:color(),
			spot_angle_start = light:spot_angle_start(),
			spot_angle_end = light:spot_angle_end(),
			multiplier_nr = light:multiplier(),
			specular_multiplier_nr = light:specular_multiplier(),
			falloff_exponent = light:falloff_exponent()
		}

		table.insert(state.lights, l)
	end

	state.projection_light = self._unit:unit_data().projection_light
	state.projection_textures = self._unit:unit_data().projection_textures
	data.SyncUnitData = state
end

-- Lines 33-38
function SyncUnitData:load(data)
	local state = data.SyncUnitData
	self._unit:unit_data().unit_id = self._unit:editor_id()

	managers.worlddefinition:setup_lights(self._unit, state)
	managers.worlddefinition:setup_projection_light(self._unit, state)
end
