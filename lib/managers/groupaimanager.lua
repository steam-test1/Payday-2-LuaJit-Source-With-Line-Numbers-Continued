require("lib/managers/group_ai_states/GroupAIStateBase")
require("lib/managers/group_ai_states/GroupAIStateEmpty")
require("lib/managers/group_ai_states/GroupAIStateBesiege")
require("lib/managers/group_ai_states/GroupAIStateStreet")

GroupAIManager = GroupAIManager or class()

-- Lines: 8 to 12
function GroupAIManager:init()
	self:set_state("empty")

	self._event_listener_holder = EventListenerHolder:new()
end

-- Lines: 15 to 16
function GroupAIManager:add_event_listener(...)
	self._event_listener_holder:add(...)
end

-- Lines: 16 to 17
function GroupAIManager:remove_event_listener(...)
	self._event_listener_holder:remove(...)
end

-- Lines: 17 to 18
function GroupAIManager:dispatch_event(...)
	self._event_listener_holder:call(...)
end

-- Lines: 22 to 24
function GroupAIManager:update(t, dt)
	self._state:update(t, dt)
end

-- Lines: 28 to 30
function GroupAIManager:paused_update(t, dt)
	self._state:paused_update(t, dt)
end

-- Lines: 34 to 47
function GroupAIManager:set_state(name)
	if name == "empty" then
		self._state = GroupAIStateEmpty:new()
	elseif name == "street" then
		self._state = GroupAIStateStreet:new()
	elseif name == "besiege" or name == "airport" or name == "zombie_apocalypse" then
		local level_tweak = managers.job:current_level_data()
		self._state = GroupAIStateBesiege:new(level_tweak and level_tweak.group_ai_state or "besiege")
	else
		Application:error("[GroupAIManager:set_state] inexistent state name", name)

		return
	end

	self._state_name = name
end

-- Lines: 51 to 52
function GroupAIManager:state()
	return self._state
end

-- Lines: 57 to 58
function GroupAIManager:state_name()
	return self._state_name
end

-- Lines: 63 to 64
function GroupAIManager:state_names()
	return {
		"empty",
		"airport",
		"besiege",
		"street",
		"zombie_apocalypse"
	}
end

-- Lines: 70 to 72
function GroupAIManager:on_simulation_started()
	self:set_state(self:state_name())
end

-- Lines: 76 to 78
function GroupAIManager:on_simulation_ended()
	self._state:on_simulation_ended()
end

-- Lines: 82 to 83
function GroupAIManager:visualization_enabled()
	return self._state._draw_enabled
end

