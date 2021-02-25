core:module("CoreMenuStatePrepareLoadingFrontEnd")
core:import("CoreSessionResponse")
core:import("CoreMenuStatePreFrontEnd")
core:import("CoreMenuStateLoadingFrontEnd")

PrepareLoadingFrontEnd = PrepareLoadingFrontEnd or class()

-- Lines 8-13
function PrepareLoadingFrontEnd:init()
	self._response = CoreSessionResponse.Done:new()
	local menu_handler = self.menu_state._menu_handler

	menu_handler:prepare_loading_front_end(self._response)
end

-- Lines 15-17
function PrepareLoadingFrontEnd:destroy()
	self._response:destroy()
end

-- Lines 19-23
function PrepareLoadingFrontEnd:transition()
	if self._response:is_done() then
		return CoreMenuStateLoadingFrontEnd.LoadingFrontEnd
	end
end
