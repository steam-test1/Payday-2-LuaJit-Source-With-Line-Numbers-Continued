core:module("CoreDependencyNode")
core:import("CoreClass")

GAME = 0
LEVEL = 1
UNIT = 2
OBJECT = 3
MATERIAL_CONFIG = 4
TEXTURE = 6
CUTSCENE = 7
EFFECT = 8
MATERIALS_FILE = 9
MODEL = 10
DependencyNodeBase = DependencyNodeBase or CoreClass.class()

-- Lines: 20 to 35
function DependencyNodeBase:init(type_, db_type, name, get_dn_cb, database)
	assert(type(type_) == "number")
	assert(type(name) == "string")
	assert(type(get_dn_cb) == "function")
	assert(type(database) == "userdata")

	self._type = type_
	self._db_type = db_type
	self._name = name
	self._get_dn = get_dn_cb
	self._database = database
	self._parsed = false
	self._depends_on = {}
end

-- Lines: 37 to 38
function DependencyNodeBase:isdependencynode()
	return true
end

-- Lines: 41 to 42
function DependencyNodeBase:type_()
	return self._type
end

-- Lines: 45 to 46
function DependencyNodeBase:name()
	return self._name
end

-- Lines: 58 to 77
function DependencyNodeBase:match(pattern)
	if pattern == nil then
		return true
	elseif type(pattern) == type(GAME) then
		return pattern == self:type_()
	elseif type(pattern) == "string" then
		return string.match(self:name(), string.format("^%s$", pattern)) ~= nil
	elseif pattern.isdependencynode then
		return pattern == self
	elseif type(pattern) == "table" then
		for _, f in ipairs(pattern) do
			if f == self then
				return true
			end
		end

		return false
	else
		error(string.format("Filter '%s' not supported", pattern))
	end
end

-- Lines: 79 to 90
function DependencyNodeBase:get_dependencies()
	if not self._parsed then
		for _, xmlnode in ipairs(self:_parse()) do
			self:_walkxml(xmlnode)
		end

		self._parsed = true
	end

	local dn_list = {}

	for dn, _ in pairs(self._depends_on) do
		table.insert(dn_list, dn)
	end

	return dn_list
end

-- Lines: 93 to 96
function DependencyNodeBase:reached(pattern)
	local found = {}

	self:_reached(pattern, {}, found)

	return found
end

-- Lines: 99 to 111
function DependencyNodeBase:_reached(pattern, traversed, found)
	if traversed[self] then
		return
	else
		traversed[self] = true

		if self:match(pattern) then
			table.insert(found, self)
		end

		for _, dn in ipairs(self:get_dependencies()) do
			dn:_reached(pattern, traversed, found)
		end
	end
end

-- Lines: 113 to 117
function DependencyNodeBase:_parse()
	local entry = self._database:lookup(self._db_type, self._name)

	assert(entry:valid())

	local xmlnode = self._database:load_node(entry)

	return {xmlnode}
end

-- Lines: 120 to 130
function DependencyNodeBase:_walkxml(xmlnode)
	local deps = _Deps:new()

	self:_walkxml2dependencies(xmlnode, deps)

	for _, dn in deps:get_pairs() do
		self._depends_on[dn] = true
	end

	for child in xmlnode:children() do
		self:_walkxml(child)
	end
end

-- Lines: 132 to 134
function DependencyNodeBase:_walkxml2dependencies(xmlnode, deps)
	error("Not Implemented")
end
_Deps = _Deps or CoreClass.class()

-- Lines: 143 to 145
function _Deps:init()
	self._dnlist = {}
end

-- Lines: 147 to 149
function _Deps:add(dn)
	table.insert(self._dnlist, dn)
end

-- Lines: 151 to 152
function _Deps:get_pairs()
	return ipairs(self._dnlist)
end

return
