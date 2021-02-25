core:module("CoreDatabaseManager")
core:import("CoreEngineAccess")
core:import("CoreApp")
core:import("CoreString")

DatabaseManager = DatabaseManager or class()

-- Lines 8-18
function DatabaseManager:list_unit_types()
	if self.__unit_types == nil then
		self.__unit_types = {}

		for _, unit in ipairs(self:list_entries_of_type("unit")) do
			local unit_data = CoreEngineAccess._editor_unit_data(unit:id())

			table.insert(self.__unit_types, unit_data and unit_data:type() or nil)
		end
	end

	return self.__unit_types
end

-- Lines 20-34
function DatabaseManager:list_units_of_type(type)
	if self.__units_by_type == nil then
		self.__units_by_type = {}

		for _, unit in ipairs(self:list_entries_of_type("unit")) do
			local unit_data = CoreEngineAccess._editor_unit_data(unit:id())
			local key = unit_data and unit_data:type() and unit_data:type():key()

			if key then
				self.__units_by_type[key] = self.__units_by_type[key] or {}

				table.insert(self.__units_by_type[key], unit)
			end
		end
	end

	return self.__units_by_type[type:key()] or {}
end

-- Lines 36-38
function DatabaseManager:list_entries_of_type(type, pattern)
	return self:list_entries_in_index(self:_type_index(type), pattern)
end

-- Lines 40-43
function DatabaseManager:list_entries_in_index(index, pattern)
	local entries = self:_entries_in_index(index)

	return pattern and table.find_all_values(entries, function (e)
		return string.find(e, pattern:s()) ~= nil
	end) or entries
end

-- Lines 45-62
function DatabaseManager:recompile(...)
	local files = {}

	for _, v in pairs({
		...
	}) do
		table.insert(files, self:entry_relative_path(v))
	end

	Application:data_compile({
		target_db_name = "all",
		preprocessor_definitions = "preprocessor_definitions",
		verbose = false,
		platform = string.lower(SystemInfo:platform():s()),
		source_root = self:base_path(),
		target_db_root = Application:base_path() .. "assets",
		source_files = files
	})
	DB:reload()
	self:clear_all_cached_indices()
end

-- Lines 64-73
function DatabaseManager:clear_cached_index(index)
	if self.__entries then
		self.__entries[index] = nil
	end

	if index == self:_type_index("unit") then
		self.__unit_types = nil
		self.__units_by_type = nil
	end
end

-- Lines 75-79
function DatabaseManager:clear_all_cached_indices()
	self.__entries = nil
	self.__unit_types = nil
	self.__units_by_type = nil
end

-- Lines 82-89
function DatabaseManager:root_path()
	local path = Application:base_path() .. (CoreApp.arg_value("-assetslocation") or "..\\..\\")
	path = Application:nice_path(path, true)
	local f = nil

	-- Lines 87-87
	function f(s)
		local str, i = string.gsub(s, "\\[%w_%.%s]+\\%.%.", "")

		return i > 0 and f(str) or str
	end

	return f(path)
end

-- Lines 91-93
function DatabaseManager:base_path()
	return self:root_path() .. "assets\\"
end

-- Lines 95-97
function DatabaseManager:is_valid_database_path(path)
	return string.begins(Application:nice_path(path, true):lower(), Application:nice_path(self:base_path(), true):lower())
end

-- Lines 99-101
function DatabaseManager:entry_name(path)
	return string.match(self:entry_path(path), "([^/]*)$")
end

-- Lines 103-106
function DatabaseManager:entry_type(path)
	if not string.find(path, "%.") then
		return nil
	end

	return string.match(path, "([^.]*)$")
end

-- Lines 108-112
function DatabaseManager:entry_path(path)
	path = string.match(string.gsub(path, ".*assets[/\\]", ""), "([^.]*)")
	path = string.gsub(path, "[/\\]+", "/")

	return path
end

-- Lines 114-119
function DatabaseManager:entry_path_with_properties(path)
	path = string.gsub(path, ".*assets[/\\]", "")
	path = string.gsub(path, "%.%w-$", "")
	path = string.gsub(path, "[/\\]+", "/")

	return path
end

-- Lines 121-125
function DatabaseManager:entry_relative_path(path)
	path = string.gsub(path, ".*assets[/\\]", "")
	path = string.gsub(path, "[/\\]+", "/")

	return path
end

-- Lines 127-131
function DatabaseManager:entry_expanded_path(type, entry_path, prop)
	local properties = prop or ""
	local path = string.gsub(self:base_path() .. entry_path .. properties .. "." .. type, "/", "\\")

	return path
end

-- Lines 133-136
function DatabaseManager:entry_expanded_directory(entry_path)
	local path = string.gsub(self:base_path() .. entry_path, "/", "\\")

	return path
end

-- Lines 138-142
function DatabaseManager:load_node_dialog(parent, file_pattern, start_path)
	local path = self:open_file_dialog(parent, file_pattern, start_path)
	local node = path and self:load_node(path)

	return node, path
end

-- Lines 144-152
function DatabaseManager:open_file_dialog(parent, file_pattern, start_path)
	local path = start_path or self:base_path()
	local pattern = file_pattern or "*.*"
	local file_dialog = EWS:FileDialog(parent, "Choose file", path, "", pattern, "OPEN,FILE_MUST_EXIST")

	if file_dialog:show_modal() then
		return file_dialog:get_path(), file_dialog:get_directory()
	end
end

-- Lines 154-177
function DatabaseManager:save_file_dialog(parent, new, file_pattern, start_path, save_outside_project)
	local pattern = file_pattern or "*.*"
	local path = start_path or self:base_path()
	local name = ""
	local new_file = ""

	if start_path then
		name = self:entry_name(start_path)
	end

	if new then
		new_file = "new file "
	end

	local save_dialog = EWS:FileDialog(parent, "Save " .. new_file .. "as..", path, name, file_pattern, "SAVE")

	if save_dialog:show_modal() then
		local new_path = save_dialog:get_path()

		if save_outside_project or self:is_valid_database_path(new_path) then
			return new_path, save_dialog:get_directory()
		else
			EWS:MessageDialog(parent, "Invalid path. Cannot save outside of the project.", "Error", "OK,ICON_ERROR"):show_modal()
		end
	end

	return nil, nil
end

-- Lines 179-187
function DatabaseManager:load_node(path)
	if self:has(path) then
		local file = SystemFS:open(path, "r")
		local content = file:read()

		file:close()

		return Node.from_xml(content)
	end

	return nil
end

-- Lines 189-193
function DatabaseManager:save_node(node, path)
	local file = assert(SystemFS:open(path, "w"))

	file:write(node:to_xml())
	file:close()
end

-- Lines 195-197
function DatabaseManager:delete(path)
	return SystemFS:delete_file(path)
end

-- Lines 199-201
function DatabaseManager:has(path)
	return SystemFS:exists(path)
end

-- Lines 203-213
function DatabaseManager:_entries_in_index(index)
	local result = self.__entries and self.__entries[index]

	if result == nil then
		result = self:_parse_entries_in_index(index)
		self.__entries = self.__entries or {}
		self.__entries[index] = result
	end

	return result
end

-- Lines 215-217
function DatabaseManager:_type_index(type)
	return string.format("indices/types/%s", type:s())
end

-- Lines 219-228
function DatabaseManager:_parse_entries_in_index(index)
	local file = DB:has("index", index) and DB:open("index", index) or nil

	if file == nil then
		return {}
	else
		local contents = file:read()

		file:close()

		return string.split(contents, "[\r\n]")
	end
end
