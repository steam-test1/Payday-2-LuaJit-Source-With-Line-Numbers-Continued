core:module("CoreApp")

-- Lines: 13 to 19
function arg_supplied(key)
	for _, arg in ipairs(Application:argv()) do
		if arg == key then
			return true
		end
	end

	return false
end

-- Lines: 22 to 31
function arg_value(key)
	local found = nil

	for _, arg in ipairs(Application:argv()) do
		if found then
			return arg
		elseif arg == key then
			found = true
		end
	end
end

-- Lines: 61 to 62
function min_exe_version(version, system_name)
end

