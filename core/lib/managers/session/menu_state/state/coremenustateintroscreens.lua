core:module("CoreMenuStateIntroScreens")
core:import("CoreSessionResponse")

IntroScreens = IntroScreens or class()

-- Lines 6-9
function IntroScreens:init()
	self._response = CoreSessionResponse.DoneOrFinished:new()

	self.pre_front_end_once.menu_state._menu_handler:show_next_intro_screen(self._response)
end

-- Lines 11-13
function IntroScreens:destroy()
	self._response:destroy()
end

-- Lines 15-21
function IntroScreens:transition()
	if self._response:is_finished() then
		self.pre_front_end_once.intro_screens_done = true
	elseif self._response:is_done() or Input:any_input() then
		return IntroScreens
	end
end
