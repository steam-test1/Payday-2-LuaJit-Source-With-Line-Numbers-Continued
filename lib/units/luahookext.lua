require("lib/managers/AchievmentManager")

LuaHookExt = LuaHookExt or class()

-- Lines 5-7
function LuaHookExt:award(trophy_stat)
	managers.custom_safehouse:award(trophy_stat)
end
