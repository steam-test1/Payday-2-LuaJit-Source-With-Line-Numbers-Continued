core:module("CoreEnvironmentEffectsManager")
core:import("CoreTable")

EnvironmentEffectsManager = EnvironmentEffectsManager or class()

-- Lines 13-18
function EnvironmentEffectsManager:init()
	self._effects = {}
	self._current_effects = {}
	self._mission_effects = {}
	self._repeat_mission_effects = {}
end

-- Lines 22-27
function EnvironmentEffectsManager:add_effect(name, effect)
	self._effects[name] = effect

	if effect:default() then
		self:use(name)
	end
end

-- Lines 30-32
function EnvironmentEffectsManager:effect(name)
	return self._effects[name]
end

-- Lines 35-37
function EnvironmentEffectsManager:effects()
	return self._effects
end

-- Lines 40-49
function EnvironmentEffectsManager:effects_names()
	local t = {}

	for name, effect in pairs(self._effects) do
		if not effect:default() then
			table.insert(t, name)
		end
	end

	table.sort(t)

	return t
end

-- Lines 52-62
function EnvironmentEffectsManager:use(effect)
	if self._effects[effect] then
		if not table.contains(self._current_effects, self._effects[effect]) then
			self._effects[effect]:load_effects()
			self._effects[effect]:start()
			table.insert(self._current_effects, self._effects[effect])
		end
	else
		Application:error("No effect named, " .. effect .. " availible to use")
	end
end

-- Lines 65-69
function EnvironmentEffectsManager:load_effects(effect)
	if self._effects[effect] then
		self._effects[effect]:load_effects()
	end
end

-- Lines 72-77
function EnvironmentEffectsManager:stop(effect)
	if self._effects[effect] then
		self._effects[effect]:stop()
		table.delete(self._current_effects, self._effects[effect])
	end
end

-- Lines 80-85
function EnvironmentEffectsManager:stop_all()
	for _, effect in ipairs(self._current_effects) do
		effect:stop()
	end

	self._current_effects = {}
end

-- Lines 88-108
function EnvironmentEffectsManager:update(t, dt)
	for _, effect in ipairs(self._current_effects) do
		effect:update(t, dt)
	end

	for name, params in pairs(self._repeat_mission_effects) do
		params.next_time = params.next_time - dt

		if params.next_time <= 0 then
			params.next_time = params.base_time + math.rand(params.random_time)
			params.effect_id = World:effect_manager():spawn(params)

			if params.max_amount then
				params.max_amount = params.max_amount - 1

				if params.max_amount <= 0 then
					self._repeat_mission_effects[name] = nil
				end
			end
		end
	end
end

-- Lines 110-113
function EnvironmentEffectsManager:gravity_and_wind_dir()
	local wind_importance = 0.5

	return Vector3(0, 0, -982) + Wind:wind_at(Vector3()) * wind_importance
end

-- Lines 116-133
function EnvironmentEffectsManager:spawn_mission_effect(name, params)
	if params.base_time > 0 or params.random_time > 0 then
		if self._repeat_mission_effects[name] then
			self:kill_mission_effect(name)
		end

		params.next_time = 0
		params.effect_id = nil
		self._repeat_mission_effects[name] = params

		return
	end

	params.effect_id = World:effect_manager():spawn(params)
	self._mission_effects[name] = self._mission_effects[name] or {}

	table.insert(self._mission_effects[name], params)
end

-- Lines 136-150
function EnvironmentEffectsManager:kill_all_mission_effects()
	for _, params in pairs(self._repeat_mission_effects) do
		if params.effect_id then
			World:effect_manager():kill(params.effect_id)
		end
	end

	self._repeat_mission_effects = {}

	for _, effects in pairs(self._mission_effects) do
		for _, params in ipairs(effects) do
			World:effect_manager():kill(params.effect_id)
		end
	end

	self._mission_effects = {}
end

-- Lines 153-155
function EnvironmentEffectsManager:kill_mission_effect(name)
	self:_kill_mission_effect(name, "kill")
end

-- Lines 158-160
function EnvironmentEffectsManager:fade_kill_mission_effect(name)
	self:_kill_mission_effect(name, "fade_kill")
end

-- Lines 163-185
function EnvironmentEffectsManager:_kill_mission_effect(name, type)
	local kill = callback(World:effect_manager(), World:effect_manager(), type)
	local params = self._repeat_mission_effects[name]

	if params then
		if params.effect_id then
			kill(params.effect_id)
		end

		self._repeat_mission_effects[name] = nil

		return
	end

	local effects = self._mission_effects[name]

	if not effects then
		return
	end

	for _, params in ipairs(effects) do
		kill(params.effect_id)
	end

	self._mission_effects[name] = nil
end

-- Lines 187-199
function EnvironmentEffectsManager:save(data)
	local state = {
		mission_effects = {}
	}

	for name, effects in pairs(self._mission_effects) do
		state.mission_effects[name] = {}

		for _, params in pairs(effects) do
			if World:effect_manager():alive(params.effect_id) then
				table.insert(state.mission_effects[name], params)
			end
		end
	end

	data.EnvironmentEffectsManager = state
end

-- Lines 201-208
function EnvironmentEffectsManager:load(data)
	local state = data.EnvironmentEffectsManager

	for name, effects in pairs(state.mission_effects) do
		for _, params in ipairs(effects) do
			self:spawn_mission_effect(name, params)
		end
	end
end

EnvironmentEffect = EnvironmentEffect or class()

-- Lines 214-217
function EnvironmentEffect:init(default)
	self._default = default
end

-- Lines 221-223
function EnvironmentEffect:load_effects()
end

-- Lines 225-227
function EnvironmentEffect:update(t, dt)
end

-- Lines 230-232
function EnvironmentEffect:start()
end

-- Lines 235-237
function EnvironmentEffect:stop()
end

-- Lines 239-241
function EnvironmentEffect:default()
	return self._default
end
