CoreCommandRegistry = CoreCommandRegistry or class()
CoreCommandRegistry.Wrapper = CoreCommandRegistry.Wrapper or class()
CoreCommandRegistry.MenuWrapper = CoreCommandRegistry.MenuWrapper or class(CoreCommandRegistry.Wrapper)
CoreCommandRegistry.ToolBarWrapper = CoreCommandRegistry.ToolBarWrapper or class(CoreCommandRegistry.Wrapper)

-- Lines 11-13
function CoreCommandRegistry:init()
	self._commands = {}
end

-- Lines 15-21
function CoreCommandRegistry:add(command_table)
	assert(type(command_table) == "table", "Single table argument with keyword arguments expected.")
	assert(type(command_table.id) == "string", "Command table must contain string member \"id\".")
	assert(type(command_table.label) == "string", "Command table must contain string member \"label\".")
	assert(self._commands[command_table.id] == nil, "Command \"" .. command_table.id .. "\" already added.")

	self._commands[command_table.id] = command_table
end

-- Lines 23-26
function CoreCommandRegistry:id(command_id)
	assert(self._commands[command_id], "Command \"" .. command_id .. "\" not found.")

	return command_id
end

-- Lines 28-30
function CoreCommandRegistry:wrap_menu(menu)
	return CoreCommandRegistry.MenuWrapper:new(menu, self._commands)
end

-- Lines 32-34
function CoreCommandRegistry:wrap_tool_bar(tool_bar)
	return CoreCommandRegistry.ToolBarWrapper:new(tool_bar, self._commands)
end

-- Lines 41-53
function CoreCommandRegistry.Wrapper:init(wrapped_object, commands)
	assert(type(commands) == "table", "Table argument with keyword arguments expected.")

	for command_id, command_table in pairs(commands) do
		assert(type(command_id) == "string", "Command id must be a string.")
		assert(type(command_table.id) == "string", "Command table must contain string member \"id\".")
		assert(command_id == command_table.id, "Command id does not match command table member \"id\".")
		assert(type(command_table.label) == "string", "Command table must contain string member \"label\".")
	end

	self._wrapped_object = wrapped_object
	self._commands = commands
end

-- Lines 55-57
function CoreCommandRegistry.Wrapper:wrapped_object()
	return self._wrapped_object
end

-- Lines 59-73
function CoreCommandRegistry.Wrapper:__index(key)
	local metatable = getmetatable(self)

	while metatable do
		local member = rawget(metatable, key)

		if member ~= nil then
			return member
		end

		metatable = getmetatable(metatable)
	end

	return function (wrapper, ...)
		local instance = wrapper:wrapped_object()

		return instance[key](instance, ...)
	end
end

-- Lines 75-78
function CoreCommandRegistry.Wrapper:command(command_id)
	local command_table = assert(self._commands[command_id], "Command \"" .. command_id .. "\" not found.")

	return command_table
end

-- Lines 85-89
function CoreCommandRegistry.MenuWrapper:make_args(command_id)
	local command = self:command(command_id)
	local label = command.key and command.label .. "\t" .. command.key or command.label

	return command.id, label, command.help or string.gsub(command.label, "&", "")
end

-- Lines 91-93
function CoreCommandRegistry.MenuWrapper:append_command(command_id)
	self:wrapped_object():append_item(self:make_args(command_id))
end

-- Lines 95-97
function CoreCommandRegistry.MenuWrapper:append_check_command(command_id)
	self:wrapped_object():append_check_item(self:make_args(command_id))
end

-- Lines 99-101
function CoreCommandRegistry.MenuWrapper:append_radio_command(command_id)
	self:wrapped_object():append_radio_item(self:make_args(command_id))
end

-- Lines 108-116
function CoreCommandRegistry.ToolBarWrapper:make_args(command_id)
	local command = self:command(command_id)

	assert(type(command.image) == "string", "Command table must contain string member \"image\".")

	local label = string.gsub(command.label, "&", "")

	if command.key then
		label = label .. " (" .. command.key .. ")"
	end

	return command.id, label, CoreEWS.image_path(command.image), command.help or label
end

-- Lines 118-120
function CoreCommandRegistry.ToolBarWrapper:add_command(command_id)
	self:wrapped_object():add_tool(self:make_args(command_id))
end

-- Lines 122-124
function CoreCommandRegistry.ToolBarWrapper:add_check_command(command_id)
	self:wrapped_object():add_check_tool(self:make_args(command_id))
end

-- Lines 126-128
function CoreCommandRegistry.ToolBarWrapper:add_radio_command(command_id)
	self:wrapped_object():add_radio_tool(self:make_args(command_id))
end
