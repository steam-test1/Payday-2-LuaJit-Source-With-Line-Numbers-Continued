core:module("CoreSessionDebug")

SessionDebug = SessionDebug or class()

-- Lines: 5 to 8
function SessionDebug:init(session_state)
	self._session_state = session_state

	self:_parse_standard_arguments()
end

-- Lines: 10 to 26
function SessionDebug:_parse_standard_arguments()
	local level = nil
	local args = Application:argv()

	for i, arg in ipairs(args) do
		if arg == "-level" then
			level = true
		elseif level then
			level_name = arg
			local session_info = self._session_state:session_info()

			session_info:set_level_name(level_name)
			self._session_state:player_slots():primary_slot():request_debug_local_user_binding()
			self._session_state:join_standard_session()

			break
		end
	end
end

return
