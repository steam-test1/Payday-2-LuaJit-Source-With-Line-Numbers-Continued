local InitState = InitState or class()
StateMachine = StateMachine or class()

-- Lines 5-8
function InitState:init(state_machine)
	self._name = "init"
	self._sm = state_machine
end

-- Lines 10-11
function InitState:destroy()
end

-- Lines 13-15
function InitState:name()
	return self._name
end

-- Lines 17-19
function InitState:sm()
	return self._sm
end

-- Lines 21-22
function InitState:at_enter(previous_state)
end

-- Lines 24-25
function InitState:at_exit(next_state)
end

-- Lines 27-30
function InitState:default_transition(next_state)
	self:at_exit(next_state)
	next_state:at_enter(self)
end

StateMachineTransitionQueue = StateMachineTransitionQueue or class()

-- Lines 35-37
function StateMachineTransitionQueue:init()
	self._queued_transitions = nil
end

-- Lines 39-42
function StateMachineTransitionQueue:queue_transition(state, params, state_machine)
	self._queued_transitions = self._queued_transitions or {}

	table.insert(self._queued_transitions, {
		state,
		params,
		state_machine
	})
end

-- Lines 44-72
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
		local trans_func, condition = unpack(state_machine._transitions[old_state][new_state])

		if not condition or condition(old_state, new_state) then
			cat_print("state_machine", "[StateMachine] Executing state change '" .. tostring(old_state:name()) .. "' --> '" .. tostring(new_state:name()) .. "'")

			state_machine._current_state = new_state

			trans_func(old_state, new_state, params)
		else
			cat_print("state_machine", "[StateMachine] Condition failed, blocking state change '" .. tostring(old_state:name()) .. "' --> '" .. tostring(new_state:name()) .. "'")

			self._queued_transitions = nil

			return
		end

		i = i + 1
	until i == #self._queued_transitions + 1

	self._queued_transitions = nil
end

-- Lines 74-84
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

-- Lines 86-96
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

-- Lines 98-112
function StateMachine:init(start_state, shared_queue)
	self._states = {}
	self._transitions = {}
	local init = InitState:new(self)
	self._states[init:name()] = init
	self._transitions[init] = self._transitions[init] or {}
	self._transitions[init][start_state] = {
		init.default_transition
	}
	self._current_state = init
	self._transition_queue = shared_queue or StateMachineTransitionQueue:new()

	self._transition_queue:queue_transition(start_state, nil, self)
	self._transition_queue:do_state_change()
end

-- Lines 114-121
function StateMachine:destroy()
	for _, state in pairs(self._states) do
		state:destroy()
	end

	self._states = {}
	self._transitions = {}
end

-- Lines 123-128
function StateMachine:add_transition(from, to, trans_func, condition)
	self._states[from:name()] = from
	self._states[to:name()] = to
	self._transitions[from] = self._transitions[from] or {}
	self._transitions[from][to] = {
		trans_func,
		condition
	}
end

-- Lines 130-132
function StateMachine:current_state()
	return self._current_state
end

-- Lines 134-138
function StateMachine:can_change_state(state)
	local state_from = self._transition_queue:last_queued_state(self) or self._current_state
	local valid_transitions = self._transitions[state_from]

	return valid_transitions and valid_transitions[state] ~= nil
end

-- Lines 140-156
function StateMachine:change_state(state, params)
	local transition_debug_string = string.format("'%s' --> '%s'", tostring(self:last_queued_state_name()), tostring(state:name()))

	cat_print("state_machine", "[StateMachine] Requested state change " .. transition_debug_string)

	if self:can_change_state(state) then
		self._transition_queue:queue_transition(state, params, self)
	end
end

-- Lines 158-160
function StateMachine:current_state_name()
	return self._current_state:name()
end

-- Lines 162-165
function StateMachine:can_change_state_by_name(state_name)
	local state = assert(self._states[state_name], "[StateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	return self:can_change_state(state)
end

-- Lines 167-170
function StateMachine:change_state_by_name(state_name, params)
	local state = assert(self._states[state_name], "[StateMachine] Name '" .. tostring(state_name) .. "' does not correspond to a valid state.")

	self:change_state(state, params)
end

-- Lines 172-176
function StateMachine:update(t, dt)
	if self._current_state.update then
		self._current_state:update(t, dt)
	end
end

-- Lines 178-182
function StateMachine:paused_update(t, dt)
	if self._current_state.paused_update then
		self._current_state:paused_update(t, dt)
	end
end

-- Lines 184-186
function StateMachine:end_update(t, dt)
	self._transition_queue:do_state_change()
end

-- Lines 188-190
function StateMachine:last_queued_state_name()
	return self._transition_queue:last_queued_state_name(self) or self:current_state_name()
end
