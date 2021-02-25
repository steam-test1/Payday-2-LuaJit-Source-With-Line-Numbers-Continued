core:module("CoreInputManager")
core:import("CoreInputContextFeeder")
core:import("CoreInputSettingsReader")

InputManager = InputManager or class()

-- Lines 7-12
function InputManager:init()
	local settings_reader = CoreInputSettingsReader.SettingsReader:new()
	self._layer_descriptions = settings_reader:layer_descriptions()
	self._feeders = {}
	self._input_provider_to_feeder = {}
end

-- Lines 14-15
function InputManager:destroy()
end

-- Lines 17-21
function InputManager:update(t, dt)
	for _, feeder in pairs(self._feeders) do
		feeder:update()
	end
end

-- Lines 23-36
function InputManager:input_provider_id_that_presses_start()
	local layer_description_ids = {}
	local count = Input:num_real_controllers()

	for i = 1, count do
		local controller = Input:controller(i)

		if controller:connected() and controller:pressed(Idstring("start")) then
			table.insert(layer_description_ids, controller)
		end
	end

	return layer_description_ids
end

-- Lines 38-57
function InputManager:debug_primary_input_provider_id()
	local count = Input:num_real_controllers()
	local best_controller = nil

	for i = 1, count do
		local controller = Input:controller(i)

		if controller:connected() then
			if controller:type() == "xbox360" then
				best_controller = controller

				break
			elseif best_controller == nil then
				best_controller = controller
			end
		end
	end

	assert(best_controller, "You need at least one compatible controller plugged in")

	return best_controller
end

-- Lines 60-69
function InputManager:_create_input_provider_for_controller(engine_controller)
	local feeder = CoreInputContextFeeder.Feeder:new(engine_controller, self._layer_descriptions)
	local input_provider = feeder:input_provider()
	self._input_provider_to_feeder[input_provider] = feeder
	self._feeders[feeder] = feeder

	return input_provider
end

-- Lines 71-74
function InputManager:_destroy_input_provider(input_provider)
	local feeder = self._input_provider_to_feeder[input_provider]
	self._feeders[feeder] = nil
end
