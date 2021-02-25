core:module("CoreControllerWrapperDebug")
core:import("CoreControllerWrapper")

ControllerWrapperDebug = ControllerWrapperDebug or class(CoreControllerWrapper.ControllerWrapper)
ControllerWrapperDebug.TYPE = "debug"

-- Lines 8-19
function ControllerWrapperDebug:init(controller_wrapper_list, manager, id, name, default_controller_wrapper, setup)
	self._controller_wrapper_list = controller_wrapper_list
	self._default_controller_wrapper = default_controller_wrapper

	ControllerWrapperDebug.super.init(self, manager, id, name, {}, default_controller_wrapper and default_controller_wrapper:get_default_controller_id(), setup, true, true)

	for _, controller_wrapper in ipairs(controller_wrapper_list) do
		for controller_id, controller in pairs(controller_wrapper:get_controller_map()) do
			self._controller_map[controller_id] = controller
		end
	end
end

-- Lines 21-27
function ControllerWrapperDebug:destroy()
	ControllerWrapperDebug.super.destroy(self)

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:destroy()
	end
end

-- Lines 29-35
function ControllerWrapperDebug:update(t, dt)
	ControllerWrapperDebug.super.update(self, t, dt)

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:update(t, dt)
	end
end

-- Lines 37-43
function ControllerWrapperDebug:paused_update(t, dt)
	ControllerWrapperDebug.super.paused_update(self, t, dt)

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:paused_update(t, dt)
	end
end

-- Lines 45-53
function ControllerWrapperDebug:connected(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connected(...) then
			return true
		end
	end

	return false
end

-- Lines 55-61
function ControllerWrapperDebug:rebind_connections(setup, setup_map)
	ControllerWrapperDebug.super.rebind_connections(self)

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:rebind_connections(setup_map and setup_map[controller_wrapper:get_type()], setup_map)
	end
end

-- Lines 63-64
function ControllerWrapperDebug:setup(...)
end

-- Lines 66-74
function ControllerWrapperDebug:get_any_input(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:get_any_input(...) then
			return true
		end
	end

	return false
end

-- Lines 76-84
function ControllerWrapperDebug:get_any_input_pressed(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:get_any_input_pressed(...) then
			return true
		end
	end

	return false
end

-- Lines 86-94
function ControllerWrapperDebug:get_input_pressed(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) and controller_wrapper:get_input_pressed(...) then
			return true
		end
	end

	return false
end

-- Lines 96-104
function ControllerWrapperDebug:get_input_bool(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) and controller_wrapper:get_input_bool(...) then
			return true
		end
	end

	return false
end

-- Lines 106-116
function ControllerWrapperDebug:get_input_float(...)
	local input_float = 0

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) then
			input_float = math.max(input_float, controller_wrapper:get_input_float(...))
		end
	end

	return input_float
end

-- Lines 118-131
function ControllerWrapperDebug:get_input_axis(...)
	local input_axis = Vector3(0, 0, 0)

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) then
			local next_input_axis = controller_wrapper:get_input_axis(...)

			if input_axis:length() < next_input_axis:length() then
				input_axis = next_input_axis
			end
		end
	end

	return input_axis
end

-- Lines 133-145
function ControllerWrapperDebug:get_connection_map(...)
	local map = {}

	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		local sub_map = controller_wrapper:get_connection_map(...)

		for k, v in pairs(sub_map) do
			map[k] = v
		end
	end

	return map
end

-- Lines 147-155
function ControllerWrapperDebug:connection_exist(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) then
			return true
		end
	end

	return false
end

-- Lines 157-161
function ControllerWrapperDebug:set_enabled(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:set_enabled(...)
	end
end

-- Lines 163-169
function ControllerWrapperDebug:enable(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:enable(...)
	end

	self._enabled = true
end

-- Lines 171-177
function ControllerWrapperDebug:disable(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:disable(...)
	end

	self._enabled = false
end

-- Lines 179-185
function ControllerWrapperDebug:add_trigger(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) then
			controller_wrapper:add_trigger(...)
		end
	end
end

-- Lines 187-193
function ControllerWrapperDebug:add_release_trigger(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) then
			controller_wrapper:add_release_trigger(...)
		end
	end
end

-- Lines 195-201
function ControllerWrapperDebug:remove_trigger(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:connection_exist(...) then
			controller_wrapper:remove_trigger(...)
		end
	end
end

-- Lines 203-207
function ControllerWrapperDebug:clear_triggers(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:clear_triggers(...)
	end
end

-- Lines 209-213
function ControllerWrapperDebug:reset_cache(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:reset_cache(...)
	end
end

-- Lines 215-219
function ControllerWrapperDebug:restore_triggers(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:restore_triggers(...)
	end
end

-- Lines 221-225
function ControllerWrapperDebug:clear_connections(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:clear_connections(...)
	end
end

-- Lines 227-229
function ControllerWrapperDebug:get_setup(...)
	return self._default_controller_wrapper and self._default_controller_wrapper:get_setup(...)
end

-- Lines 231-233
function ControllerWrapperDebug:get_connection_settings(...)
	return self._default_controller_wrapper and self._default_controller_wrapper:get_connection_settings(...)
end

-- Lines 235-243
function ControllerWrapperDebug:get_connection_enabled(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		if controller_wrapper:get_connection_enabled(...) then
			return true
		end
	end

	return false
end

-- Lines 245-249
function ControllerWrapperDebug:set_connection_enabled(...)
	for _, controller_wrapper in ipairs(self._controller_wrapper_list) do
		controller_wrapper:set_connection_enabled(...)
	end
end
