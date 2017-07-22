require("lib/managers/group_ai_states/GroupAIStateBase")
require("lib/managers/group_ai_states/GroupAIStateEmpty")
require("lib/managers/group_ai_states/GroupAIStateBesiege")
require("lib/managers/group_ai_states/GroupAIStateStreet")

GroupAIManager = GroupAIManager or class()

-- Lines: 8 to 10
function GroupAIManager:init()
	self:set_state("empty")
end

-- Lines: 14 to 16
function GroupAIManager:update(t, dt)
	self._state:update(t, dt)
end

-- Lines: 20 to 22
function GroupAIManager:paused_update(t, dt)
	self._state:paused_update(t, dt)
end

-- Lines: 26 to 39
function GroupAIManager:set_state(name)
	if name == "empty" then
		self._state = GroupAIStateEmpty:new()
	elseif name == "street" then
		self._state = GroupAIStateStreet:new()
	elseif name == "besiege" or name == "airport" or name == "zombie_apocalypse" then
		local level_tweak = tweak_data.levels[managers.job:current_level_id()]
		self._state = GroupAIStateBesiege:new(level_tweak and level_tweak.group_ai_state or "besiege")
	else
		Application:error("[GroupAIManager:set_state] inexistent state name", name)

		return
	end

	self._state_name = name
end

-- Lines: 43 to 44
function GroupAIManager:state()
	return self._state
end

-- Lines: 49 to 50
function GroupAIManager:state_name()
	return self._state_name
end

-- Lines: 55 to 56
function GroupAIManager:state_names()
	return {
		"empty",
		"airport",
		"besiege",
		"street",
		"zombie_apocalypse"
	}
end

-- Lines: 61 to 63
function GroupAIManager:on_simulation_started()
	self._state:on_simulation_started()
end

-- Lines: 67 to 69
function GroupAIManager:on_simulation_ended()
	self._state:on_simulation_ended()
end

-- Lines: 73 to 74
function GroupAIManager:visualization_enabled()
	return self._state._draw_enabled
end

return
