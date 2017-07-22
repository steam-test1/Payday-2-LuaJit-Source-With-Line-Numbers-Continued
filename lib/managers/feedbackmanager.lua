FeedBackManager = FeedBackManager or class()

-- Lines: 47 to 56
function FeedBackManager:init()
	self._effect_types = {
		rumble = FeedBackrumble,
		camera_shake = FeedBackCameraShake,
		above_camera_effect = FeedBackAboveCameraEffect
	}

	self:setup_preset_effects()

	self._feedback_map = {}
end

-- Lines: 58 to 98
function FeedBackManager:setup_preset_effects()
	self._feedback = {mission_triggered = {}}
	self._feedback.mission_triggered.camera_shake = {name = "mission_triggered"}
	self._feedback.mission_triggered.rumble = {name = "mission_triggered"}
	self._feedback.mission_triggered.above_camera_effect = {effect = "none"}
end

-- Lines: 100 to 105
function FeedBackManager:get_effect_names()
	local names = {}

	for name, _ in pairs(self._feedback) do
		table.insert(names, name)
	end

	return names
end

-- Lines: 109 to 126
function FeedBackManager:create(feedback, ...)
	local extra_params = {...}
	local f = FeedBack:new(feedback, self._feedback[feedback])

	if not f then
		Application:stack_dump_error("no effect called " .. tostring(feedback))

		return nil
	end

	for i = 1, #extra_params, 2 do
		if extra_params[i] and extra_params[i + 1] and f["set_" .. extra_params[i]] then
			f["set_" .. extra_params[i]](f, extra_params[i + 1])
		else
			Application:stack_dump_error("bad params to create_feedback " .. tostring(extra_params[i]) .. " " .. tostring(extra_params[i + 1]))
		end
	end

	return f
end

-- Lines: 129 to 131
function FeedBackManager:reload(feedback)
	self:setup_preset_effects()
end

-- Lines: 136 to 137
function FeedBackManager:get_effect_table(name)
	return self._feedback[name]
end

-- Lines: 141 to 152
function FeedBackManager:stop_all(name)
	managers.rumble:stop("all")
end
FeedBack = FeedBack or class()

-- Lines: 159 to 165
function FeedBack:init(effect_name, effect_table)
	self._name = effect_name
	self._feedback = {}

	for name, param in pairs(effect_table) do
		self._feedback[name] = managers.feedback._effect_types[name]:new(self._name)
	end
end

-- Lines: 167 to 171
function FeedBack:set_enabled(feedback_type, enabled)
	if self._feedback[feedback_type] then
		self._feedback[feedback_type]:set_enabled(enabled)
	end
end

-- Lines: 173 to 175
function FeedBack:is_enabled(feedback_type)
	local effect = self._feedback[feedback_type]

	return effect and effect:is_enabled()
end

-- Lines: 178 to 186
function FeedBack:set_unit(unit, effect)
	if not effect then
		for _, effect in pairs(self._feedback) do
			effect:set_unit(unit)
		end
	elseif self._feedback[effect] then
		self._feedback[effect]:set_unit(unit)
	end
end

-- Lines: 188 to 196
function FeedBack:set_viewport(vp, effect)
	if effect then
		self._feedback[effect]:set_viewport(vp)
	else
		for _, effect in pairs(self._feedback) do
			effect:set_viewport(vp)
		end
	end
end

-- Lines: 198 to 202
function FeedBack:set_param(effect, param_name, value)
	if self._feedback[effect] then
		self._feedback[effect]:set_param(param_name, value)
	end
end

-- Lines: 204 to 208
function FeedBack:reset_params(effect)
	if self._feedback[effect] then
		self._feedback[effect]:reset_params()
	end
end

-- Lines: 210 to 211
function FeedBack:extra_params(effect)
	return self._extra_params[effect]
end

-- Lines: 214 to 250
function FeedBack:play(...)
	local extra_params = {...}
	self._extra_params = {}

	for i = 1, #extra_params, 3 do
		if extra_params[i] and extra_params[i + 1] and extra_params[i + 2] and self._feedback[extra_params[i]] then
			self._extra_params[extra_params[i]] = self._extra_params[extra_params[i]] or {}
			self._extra_params[extra_params[i]][extra_params[i + 1]] = extra_params[i + 2]
		end
	end

	for name in pairs(managers.feedback:get_effect_table(self._name)) do
		local effect = self._feedback[name]

		if effect:is_enabled() then
			if effect then
				effect:play(self._extra_params[name])
			else
				self._feedback[name] = managers.feedback._effect_types[name]:new(self._name)
			end
		end
	end

	for i = 1, #extra_params, 3 do
		if extra_params[i] and extra_params[i + 1] and extra_params[i + 2] and self._feedback[extra_params[i]] and self._feedback[extra_params[i]]:is_enabled() then
			self._feedback[extra_params[i]]:set_param(extra_params[i + 1], extra_params[i + 2])
		else
			local msg = ""

			if not self._feedback[extra_params[i]] then
				msg = "no effect called " .. tostring(extra_params[i])
			end
		end
	end
end

-- Lines: 252 to 269
function FeedBack:stop(effect, ...)
	local extra_params = {...}

	for i = 1, #extra_params, 2 do
		if extra_params[i] and extra_params[i + 1] and f["set_" .. extra_params[i]] then
			f["set_" .. extra_params[i]](f, extra_params[i + 1])
		else
			Application:stack_dump_error("bad params to create_feedback " .. tostring(extra_params[i]) .. " " .. tostring(extra_params[i + 1]))
		end
	end

	if not effect then
		for name, effect in pairs(self._feedback) do
			effect:stop()
		end
	else
		self._feedback[effect]:stop()
	end
end

-- Lines: 271 to 282
function FeedBack:is_playing(effect)
	if not effect then
		for name, effect in pairs(self._feedback) do
			if effect:is_playing() then
				return true
			end
		end

		return false
	else
		return self._feedback[effect]:is_playing()
	end
end
FeedBackEffect = FeedBackEffect or class()

-- Lines: 287 to 291
function FeedBackEffect:init(name)
	self._params = {}
	self._name = name
	self._enabled = true
end

-- Lines: 293 to 301
function FeedBackEffect:set_enabled(enabled)
	if not self._enabled ~= not enabled then
		if self._enabled then
			self:stop()
		end

		self._enabled = enabled
	end
end

-- Lines: 304 to 305
function FeedBackEffect:is_enabled()
	return self._enabled
end

-- Lines: 308 to 309
function FeedBackEffect:set_unit(unit)
end

-- Lines: 311 to 312
function FeedBackEffect:set_viewport(vp)
end

-- Lines: 314 to 316
function FeedBackEffect:set_static_param(name, value)
	self._params[name] = value
end

-- Lines: 318 to 320
function FeedBackEffect:set_param(name, value)
	self._params[name] = value
end

-- Lines: 322 to 324
function FeedBackEffect:reset_params()
	self._params = {}
end

-- Lines: 326 to 329
function FeedBackEffect:play()
	local params = managers.feedback:get_effect_table(self._name)[self._type]

	mixin(params, params, self._params)

	return params
end

-- Lines: 332 to 333
function FeedBackEffect:stop()
end

-- Lines: 335 to 336
function FeedBackEffect:is_playing()
	return false
end
FeedBackrumble = FeedBackrumble or class(FeedBackEffect)

-- Lines: 341 to 344
function FeedBackrumble:init(name)
	FeedBackEffect.init(self, name)

	self._type = "rumble"
end

-- Lines: 346 to 348
function FeedBackrumble:set_unit(unit)
	self._unit = unit
end

-- Lines: 350 to 354
function FeedBackrumble:set_param(name, value)
	if name == "multiplier_data" and self._id then
		managers.rumble:set_multiplier(self._id, value)
	end
end

-- Lines: 357 to 366
function FeedBackrumble:play(extra_params)
	local params = FeedBackEffect.play(self)

	if self._unit then
		self._id = managers.rumble:play(params.name, nil, params.multiplier_data, extra_params)
	elseif not self._unit then
		Application:stack_dump_error("no unit set to rumble in feedbackRumble use either set_unit or send unit at create")
	end
end

-- Lines: 368 to 371
function FeedBackrumble:stop()
	managers.rumble:stop(self._id)

	self._id = nil
end

-- Lines: 373 to 390
function FeedBackrumble:is_playing()
	local rumble = nil

	if not self._id then
		return false
	end

	for _, controller in pairs(self._id.controllers) do
		rumble = controller:is_rumble_playing(self._id[1])

		if self._id[2] then
			rumble = rumble or controller:is_rumble_playing(self._id[2])
		end

		if rumble then
			return rumble
		end
	end

	return rumble
end
FeedBackCameraShake = FeedBackCameraShake or class(FeedBackEffect)

-- Lines: 396 to 399
function FeedBackCameraShake:init(name)
	FeedBackEffect.init(self, name)

	self._type = "camera_shake"
end

-- Lines: 401 to 404
function FeedBackEffect:set_viewport(vp)
	self._camera = vp:director():shaker()
	self._playing_camera = self._camera
end

-- Lines: 406 to 408
function FeedBackEffect:set_unit(unit)
	self._unit_camera = unit:camera()
end

-- Lines: 410 to 428
function FeedBackCameraShake:set_param(name, value)
	if name == "multiplier" then
		return
	end

	if name == "name" then
		return
	end

	if name == "amplitude" then
		value = value * self._multiplier
	end

	if self._unit_camera then
		self._unit_camera:shaker():set_parameter(self._id, name, value)
	elseif alive(self._playing_camera) then
		self._playing_camera:set_parameter(self._id, name, value)
	end
end

-- Lines: 430 to 457
function FeedBackCameraShake:play(extra_params)
	local params = managers.feedback:get_effect_table(self._name)[self._type]
	local name = extra_params.name or params.name
	self._multiplier = extra_params.multiplier or 1

	if self._unit_camera then
		self._id = self._unit_camera:play_shaker(name, params.amplitude or 1, params.frequency or 1, params.offset or 0)
	else
		self._playing_camera = alive(self._camera) and self._camera or managers.viewport:get_current_shaker()

		if self._playing_camera then
			self._id = self._playing_camera:play(name)

			if self._playing_camera:is_playing(self._id) then
				local t = {}

				mixin(t, params, self._params)

				t.name = nil

				for param, value in pairs(t) do
					self._playing_camera:set_parameter(self._id, param, value)
				end
			end
		end
	end
end

-- Lines: 459 to 466
function FeedBackCameraShake:stop()
	if self._unit_camera then
		self._unit_camera:stop_shaker(self._id)
	else
		managers.viewport:get_current_shaker():stop(self._id)
	end

	self._id = nil
end

-- Lines: 468 to 476
function FeedBackCameraShake:is_playing()
	if self._unit_camera and self._id then
		return self._unit_camera:shaker():is_playing(self._id)
	elseif self._playing_camera and self._id then
		return self._playing_camera:is_playing(self._id)
	else
		return false
	end
end
FeedBackAboveCameraEffect = FeedBackAboveCameraEffect or class(FeedBackEffect)

-- Lines: 504 to 508
function FeedBackAboveCameraEffect:init(name)
	FeedBackAboveCameraEffect.super.init(self, name)

	self._type = "above_camera_effect"
	self._offset = Vector3(0, 0, 100)
end

-- Lines: 510 to 512
function FeedBackAboveCameraEffect:set_unit(unit)
	self._unit_camera = unit:camera()
end

-- Lines: 514 to 516
function FeedBackAboveCameraEffect:set_param(name, value)
	self._params[name] = value
end

-- Lines: 518 to 531
function FeedBackAboveCameraEffect:play(extra_params)
	local params = FeedBackAboveCameraEffect.super.play(self)
	local name = extra_params and extra_params.effect or params.effect

	if name == "none" then
		return
	end

	local effect_params = {
		effect = Idstring(name),
		position = self._unit_camera:position() + self._offset,
		rotation = self._unit_camera:rotation()
	}
	self._id = World:effect_manager():spawn(effect_params)
end

-- Lines: 533 to 537
function FeedBackAboveCameraEffect:stop()
	if self._id then
		World:effect_manager():kill(self._id)
	end
end

return
