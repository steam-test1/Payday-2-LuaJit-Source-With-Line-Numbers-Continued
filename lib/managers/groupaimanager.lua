require("lib/managers/group_ai_states/GroupAIStateBase")
require("lib/managers/group_ai_states/GroupAIStateEmpty")
require("lib/managers/group_ai_states/GroupAIStateBesiege")
require("lib/managers/group_ai_states/GroupAIStateStreet")

GroupAIManager = GroupAIManager or class()
GroupAIManager.STATE_CLASS_LOOKUP = {
	empty = function()
		return GroupAIStateEmpty
	end,
	street = function()
		return GroupAIStateStreet
	end,
	besiege = function()
		local level_tweak = managers.job and managers.job:current_level_data() or nil

		return GroupAIStateBesiege, level_tweak and level_tweak.group_ai_state or "besiege"
	end
}
GroupAIManager.STATE_CLASS_LOOKUP.airport = GroupAIManager.STATE_CLASS_LOOKUP.besiege
GroupAIManager.STATE_CLASS_LOOKUP.zombie_apocalypse = GroupAIManager.STATE_CLASS_LOOKUP.besiege

-- Lines 23-27
function GroupAIManager:init()
	self:set_state("empty")

	self._event_listener_holder = EventListenerHolder:new()
end

-- Lines 31-31
function GroupAIManager:add_event_listener(...)
	self._event_listener_holder:add(...)
end

-- Lines 32-32
function GroupAIManager:remove_event_listener(...)
	self._event_listener_holder:remove(...)
end

-- Lines 33-33
function GroupAIManager:dispatch_event(...)
	self._event_listener_holder:call(...)
end

-- Lines 37-39
function GroupAIManager:update(t, dt)
	self._state:update(t, dt)
end

-- Lines 43-45
function GroupAIManager:paused_update(t, dt)
	self._state:paused_update(t, dt)
end

-- Lines 49-73
function GroupAIManager:set_state(name)
	local new_state_getter = GroupAIManager.STATE_CLASS_LOOKUP[name]

	if not new_state_getter then
		Application:error("[GroupAIManager:set_state] Inexistent state name.", name)

		return
	end

	local new_state_class, state_type = new_state_getter()

	if not new_state_class then
		Application:error("[GroupAIManager:set_state] Inexistent state class..?", name)

		return
	end

	if self._state ~= nil then
		self._state:destroy()
	end

	self._state_name = name
	self._state = new_state_class:new(state_type)
end

-- Lines 77-79
function GroupAIManager:state()
	return self._state
end

-- Lines 83-85
function GroupAIManager:state_name()
	return self._state_name
end

-- Lines 89-91
function GroupAIManager:state_names()
	return table.map_keys(GroupAIManager.STATE_CLASS_LOOKUP)
end

-- Lines 95-98
function GroupAIManager:on_simulation_started()
	self:set_state(self:state_name())
end

-- Lines 102-104
function GroupAIManager:on_simulation_ended()
	self._state:on_simulation_ended()
end

-- Lines 108-110
function GroupAIManager:visualization_enabled()
	return self._state._draw_enabled
end
