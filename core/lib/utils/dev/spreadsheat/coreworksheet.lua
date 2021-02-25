core:module("CoreWorksheet")
core:import("CoreClass")

local EMPTY_WORKSHEET_XML1 = " <Worksheet ss:Name=\"%s\">\n  <Table> "
local EMPTY_WORKSHEET_XML2 = "\n  </Table>\n </Worksheet> "
Worksheet = Worksheet or CoreClass.class()

-- Lines 18-21
function Worksheet:init(name)
	self._name = name
	self._rows = {}
end

-- Lines 23-25
function Worksheet:add_row(row)
	table.insert(self._rows, row)
end

-- Lines 27-34
function Worksheet:to_xml(f)
	f:write(string.format(EMPTY_WORKSHEET_XML1, self._name))

	for _, r in ipairs(self._rows) do
		f:write("\n")
		r:to_xml(f)
	end

	f:write(EMPTY_WORKSHEET_XML2)
end
