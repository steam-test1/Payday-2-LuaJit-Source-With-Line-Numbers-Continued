StatisticsGenerator = StatisticsGenerator or class()

-- Lines: 3 to 19
function StatisticsGenerator.generate()
	local level_list, job_list, mask_list, weapon_list, melee_list, grenade_list, enemy_list, armor_list, character_list, deployable_list = tweak_data.statistics:statistics_table()
	local xml_path = StatisticsGenerator._root_path() .. "aux_assets\\config\\win32\\statistics.xml"
	local xml = SystemFS:open(xml_path, "w")

	StatisticsGenerator._generate_group("mask", mask_list, xml)
	StatisticsGenerator._generate_group("weapon", weapon_list, xml)
	StatisticsGenerator._generate_group("melee", melee_list, xml)
	StatisticsGenerator._generate_group("grenade", grenade_list, xml)
	StatisticsGenerator._generate_group("armor", armor_list, xml)
	StatisticsGenerator._generate_group("character", character_list, xml)
	StatisticsGenerator._generate_group("deployable", deployable_list, xml)
	SystemFS:close(xml)
end

-- Lines: 23 to 32
function StatisticsGenerator._generate_group(group, list, xml)
	xml:puts("<" .. group .. "s>")

	for index, item in pairs(list) do
		xml:puts("\t<" .. group .. " id=\"" .. index .. "\" name=\"" .. item .. "\" />")
	end

	xml:puts("</" .. group .. "s>")
	xml:puts("")
end

-- Lines: 34 to 40
function StatisticsGenerator._root_path()
	local path = Application:base_path() .. (CoreApp.arg_value("-assetslocation") or "..\\..\\")
	path = Application:nice_path(path, true)
	local f = nil


	-- Lines: 38 to 39
	function f(s)
		local str, i = string.gsub(s, "\\[%w_%.%s]+\\%.%.", "")

		return i > 0 and f(str) or str
	end

	return f(path)
end

