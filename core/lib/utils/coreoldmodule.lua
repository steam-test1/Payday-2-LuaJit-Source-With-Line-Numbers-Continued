core:module("CoreOldModule")

-- Lines 11-13
function get_core_or_local(name)
	return rawget(_G, name) or rawget(_G, "Core" .. name)
end

-- Lines 15-18
function core_or_local(name, ...)
	local metatable = get_core_or_local(name)

	return metatable and metatable:new(...)
end
