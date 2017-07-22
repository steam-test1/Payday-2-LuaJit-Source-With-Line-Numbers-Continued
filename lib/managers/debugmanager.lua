core:module("DebugManager")
core:import("CoreDebugManager")
core:import("CoreClass")

DebugManager = DebugManager or class(CoreDebugManager.DebugManager)

-- Lines: 8 to 10
function DebugManager:qa_debug(username)
	self:set_qa_debug_enabled(username, true)
end

-- Lines: 12 to 13
function DebugManager:get_qa_debug_enabled()
	return self._qa_debug_enabled
end

-- Lines: 16 to 26
function DebugManager:set_qa_debug_enabled(username, enabled)
	enabled = not not enabled
	local cat_print_list = {"qa"}

	for _, cat in ipairs(cat_print_list) do
		Global.category_print[cat] = enabled
	end

	self._qa_debug_enabled = enabled
end

CoreClass.override_class(CoreDebugManager.DebugManager, DebugManager)

return
