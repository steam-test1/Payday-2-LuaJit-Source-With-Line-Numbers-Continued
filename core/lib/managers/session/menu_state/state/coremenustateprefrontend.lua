core:module("CoreMenuStatePreFrontEnd")
core:import("CoreMenuStateFrontEnd")
core:import("CoreMenuStateStart")
core:import("CoreFiniteStateMachine")

PreFrontEnd = PreFrontEnd or class()

-- Lines: 8 to 10
function PreFrontEnd:init()
	self._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreMenuStateStart.Start, "pre_front_end", self)
end

-- Lines: 12 to 14
function PreFrontEnd:destroy()
	self._state:destroy()
end

-- Lines: 16 to 24
function PreFrontEnd:transition()
	self._state:transition()

	local state = self.menu_state._game_state

	if not state:is_in_pre_front_end() then
		return CoreMenuStateFrontEnd.FrontEnd
	end
end

return
