core:module("CoreMenuStatePreFrontEndOnce")
core:import("CoreMenuStatePreFrontEnd")
core:import("CoreFiniteStateMachine")
core:import("CoreMenuStateLegal")

PreFrontEndOnce = PreFrontEndOnce or class()

-- Lines 8-10
function PreFrontEndOnce:init()
	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreMenuStateLegal.Legal, "pre_front_end_once", self)
end

-- Lines 12-20
function PreFrontEndOnce:transition()
	self._state:transition()

	local state = self.menu_state._game_state

	if not state:is_in_pre_front_end() or self.intro_screens_done then
		return CoreMenuStatePreFrontEnd.PreFrontEnd
	end
end
