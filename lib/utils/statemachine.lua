local InitState = InitState or class()
StateMachine = StateMachine or class()

-- Lines: 5 to 8
function InitState:init(state_machine)
	self._name = "init"
	self._sm = state_machine
end

-- Lines: 10 to 11
function InitState:destroy()
end

-- Lines: 13 to 14
function InitState:name()
	return self._name
end

-- Lines: 17 to 18
function InitState:sm()
	return self._sm
end

-- Lines: 21 to 22
function InitState:at_enter(previous_state)
end

-- Lines: 24 to 25
function InitState:at_exit(next_state)
end

-- Lines: 27 to 30
function InitState:default_transition(next_state)
	self:at_exit(next_state)
	next_state:at_enter(self)
end
StateMachineTransitionQueue = StateMachineTransitionQueue or class()

-- Lines: 35 to 37
function StateMachineTransitionQueue:init()
	self._queued_transitions = nil
end

-- Lines: 39 to 42
function StateMachineTransitionQueue:queue_transition(state, params, state_machine)
	self._queued_transitions = self._queued_transitions or {}

	table.insert(self._queued_transitions, {
		state,
		params,
		state_machine
	})
end

-- Lines: 44 to 64
function StateMachineTransitionQueue:do_state_change()
	if not self._queued_transitions or #self._queued_transitions == 0 then
		return
	end

	local i = 1

	repeat
		local transition = self._queued_transitions[i]
		local new_state = transition[1]
		local params = transition[2]
		local state_machine = transition[3]
		local old_state = state_machine._current_state
		local trans_func = state_machine._transitions[old_state][new_state]

		cat_print("state_machine", "[StateMachine] Executing state change '" .. tostring(old_state:name()) .. "' --> '" .. tostring(new_state:name()) .. "'")

		state_machine._current_state = new_state

		trans_func(old_state, new_state, params)

		i = i + 1
	until i == #self._queued_transitions + 1

	self._queued_transitions = nil
end

-- Lines: 66 to 75
function StateMachineTransitionQueue:last_queued_state(state_machine)
	local state = nil

	if self._queued_transitions then
		for _, transition in ipairs(self._queued_transitions) do
			if transition[3] == state_machine then
				state = transition[1]
			end
		end
	end

	return state
end

-- Lines: 78 to 87
function StateMachineTransitionQueue:last_queued_state_name(state_machine)
	local state_name = nil

	if self._queued_transitions then
		for _, transition in ipairs(self._queued_transitions) do
			if transition[3] == state_machine then
				state_name = transition[1]:name()
			end
		end
	end

	return state_name
end

-- Lines: 90 to 104
function StateMachine:init(start_state, shared_queue)
	self._states = {}
	self._transitions = {}
	local init = InitState:new(self)
	self._states[init:name()] = init
	self._transitions[init] = self._transitions[init] or {}
	self._transitions[init][start_state] = init.default_transition
	self._current_state = init
	self._transition_queue = shared_queue or StateMachineTransitionQueue:new()

	self._transition_queue:queue_transition(start_state, nil, self)
	self._transition_queue:do_state_change()
end

-- Lines: 106 to 113
function StateMachine:destroy()
	for _, state in pairs(self._states) do
		state:destroy()
	end

	self._states = {}
	self._transitions = {}
end

-- Lines: 115 to 120
function StateMachine:add_transition(from, to, trans_func)
	self._states[from:name()] = from
	self._states[to:name()] = to
	self._transitions[from] = self._transitions[from] or {}
	self._transitions[from][to] = trans_func
end

-- Lines: 122 to 123
function StateMachine:current_state()
	return self._current_state
end

-- Lines: 126 to 129
function StateMachine:can_change_state(state)
	local state_from = self._transition_queue:last_queued_state(self) or self._current_state
	local valid_transitions = self._transitions[state_from]

	return valid_transitions and valid_transitions[state] ~= nil
end

-- Lines: 132 to 148
function StateMachine:change_state(state, params)
	local transition_debug_string = string.format("'%s' --> '%s'", tostring(self:last_queued_state_name()), tostring(state:name()))

	cat_print("state_machine", "[StateMachine] Requested state change " .. transition_debug_string)

	if not self:can_change_state(state) then
		-- Nothing
	else
		self._transition_queue:queue_transition(state, params, self)
	end
end

-- Lines: 150 to 151
function StateMachine:current_state_name()
	return self._current_state:name()
end

-- Lines: 154 to 156
function StateMachine:can_change_state_by_name(state_name)
	local state = assert(self._states[state_name], "[StateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	return self:can_change_state(state)
end

-- Lines: 159 to 162
function StateMachine:change_state_by_name(state_name, params)
	local state = assert(self._states[state_name], "[StateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	self:change_state(state, params)
end

-- Lines: 164 to 168
function StateMachine:update(t, dt)
	if self._current_state.update then
		self._current_state:update(t, dt)
	end
end

-- Lines: 170 to 174
function StateMachine:paused_update(t, dt)
	if self._current_state.paused_update then
		self._current_state:paused_update(t, dt)
	end
end

-- Lines: 176 to 178
function StateMachine:end_update(t, dt)
	self._transition_queue:do_state_change()
end

-- Lines: 180 to 181
function StateMachine:last_queued_state_name()
	return self._transition_queue:last_queued_state_name(self) or self:current_state_name()
end

