StatisticsGenerator = StatisticsGenerator or class()

-- Lines 3-41
function StatisticsGenerator.generate(dataXML)
	dataXML = dataXML or false
	local level_list, job_list, mask_list, weapon_list, melee_list, grenade_list, enemy_list, armor_list, character_list, deployable_list, suit_list, weapon_color_list, glove_list = tweak_data.statistics:statistics_table()
	local join_stinger_list = {}

	for index = 0, tweak_data.infamy.join_stingers do
		table.insert(join_stinger_list, index)
	end

	local xml_path = StatisticsGenerator._root_path() .. "aux_assets\\config\\win32\\statistics.xml"
	local xml = SystemFS:open(xml_path, "w")

	if dataXML ~= false then
		xml:puts("<data>")
	end

	StatisticsGenerator._generate_group("mask", mask_list, xml)
	StatisticsGenerator._generate_group("weapon", weapon_list, xml)
	StatisticsGenerator._generate_group("melee", melee_list, xml)
	StatisticsGenerator._generate_group("grenade", grenade_list, xml)
	StatisticsGenerator._generate_group("armor", armor_list, xml)
	StatisticsGenerator._generate_group("character", character_list, xml)
	StatisticsGenerator._generate_group("deployable", deployable_list, xml)
	StatisticsGenerator._generate_group("suit", suit_list, xml)
	StatisticsGenerator._generate_group("glove", glove_list, xml)
	StatisticsGenerator._generate_group("weapon_color", weapon_color_list, xml)
	StatisticsGenerator._generate_group("join_stinger", join_stinger_list, xml)

	if dataXML ~= false then
		xml:puts("</data>")
	end

	SystemFS:close(xml)
end

-- Lines 45-54
function StatisticsGenerator._generate_group(group, list, xml)
	xml:puts("<" .. group .. "s>")

	for index, item in pairs(list) do
		xml:puts("\t<" .. group .. " id=\"" .. index .. "\" name=\"" .. item .. "\" />")
	end

	xml:puts("</" .. group .. "s>")
	xml:puts("")
end

-- Lines 56-63
function StatisticsGenerator._root_path()
	local path = Application:base_path() .. (CoreApp.arg_value("-assetslocation") or "..\\..\\")
	path = Application:nice_path(path, true)
	local f = nil

	-- Lines 61-61
	function f(s)
		local str, i = string.gsub(s, "\\[%w_%.%s]+\\%.%.", "")

		return i > 0 and f(str) or str
	end

	return f(path)
end
