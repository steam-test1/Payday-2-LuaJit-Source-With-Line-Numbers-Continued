core:module("CoreAvatar")

Avatar = Avatar or class()

-- Lines: 5 to 7
function Avatar:init(avatar_handler)
	self._avatar_handler = avatar_handler
end

-- Lines: 9 to 14
function Avatar:destroy()
	if self._input_input_provider then
		self:release_input()
	end

	self._avatar_handler:destroy()
end

-- Lines: 16 to 19
function Avatar:set_input(input_input_provider)
	self._avatar_handler:enable_input(input_input_provider)

	self._input_input_provider = input_input_provider
end

-- Lines: 21 to 24
function Avatar:release_input()
	self._avatar_handler:disable_input()

	self._input_input_provider = nil
end

-- Lines: 26 to 27
function Avatar:avatar_handler()
	return self._avatar_handler
end

return
