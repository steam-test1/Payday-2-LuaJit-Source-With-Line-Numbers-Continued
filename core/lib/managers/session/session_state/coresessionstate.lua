core:module("CoreSessionState")
core:import("CorePortableSessionCreator")
core:import("CorePlayerSlots")
core:import("CoreRequester")
core:import("CoreFiniteStateMachine")
core:import("CoreSessionStateInit")
core:import("CoreSessionInfo")
core:import("CoreSessionGenericState")

SessionState = SessionState or class(CoreSessionGenericState.State)

-- Lines 12-25
function SessionState:init(factory, player_slots, game_state)
	self._factory = factory
	self._session_creator = CorePortableSessionCreator.Creator:new(self)
	self._join_session_requester = CoreRequester.Requester:new()
	self._quit_session_requester = CoreRequester.Requester:new()
	self._start_session_requester = CoreRequester.Requester:new()
	self._player_slots = player_slots
	self._game_state = game_state
	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreSessionStateInit.Init, "session_state", self)
	self._session_info = CoreSessionInfo.Info:new()

	self:_set_stable_for_loading()
end

-- Lines 27-29
function SessionState:transition()
	self._state:transition()
end

-- Lines 31-33
function SessionState:player_slots()
	return self._player_slots
end

-- Lines 35-37
function SessionState:join_standard_session()
	self._join_session_requester:request()
end

-- Lines 39-41
function SessionState:start_session()
	self._state:state():start_session()
end

-- Lines 43-45
function SessionState:quit_session()
	self._quit_session_requester:request()
end

-- Lines 47-49
function SessionState:end_session()
	self._state:state():end_session()
end

-- Lines 51-53
function SessionState:session_info()
	return self._session_info
end
