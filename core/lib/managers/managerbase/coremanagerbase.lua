core:module("CoreManagerBase")

PRIO_FUTURECORE1 = 1
PRIO_FUTURECORE2 = 2
PRIO_FUTURECORE3 = 3
PRIO_FUTURECORE4 = 4
PRIO_FUTURECORE5 = 5
PRIO_FREEFLIGHT = 10
PRIO_CUTSCENE = 20
PRIO_WORLDCAMERA = 30
PRIO_GAMEPLAY = 40
PRIO_DEFAULT = PRIO_GAMEPLAY
ManagerBase = ManagerBase or class()

-- Lines: 20 to 27
function ManagerBase:init(name)
	self.__name = name
	self.__aos = {}
	self.__ao2prio = {}
	self.__really_active = {}
	self.__active_requested = {}
	self.__changed = false
end

-- Lines: 30 to 36
function ManagerBase:_add_accessobj(accessobj, prio)
	assert(accessobj:active_requested() == false)
	assert(accessobj:really_active() == false)
	assert(prio > 0)

	self.__ao2prio[accessobj] = prio

	table.insert(self.__aos, accessobj)
end

-- Lines: 39 to 45
function ManagerBase:_del_accessobj(accessobj)
	self.__ao2prio[accessobj] = nil

	table.delete(self.__aos, accessobj)
	table.delete(self.__really_active, accessobj)
	table.delete(self.__active_requested, accessobj)
	accessobj:_really_deactivate()
end

-- Lines: 47 to 48
function ManagerBase:_all_ao()
	return self.__aos
end

-- Lines: 51 to 52
function ManagerBase:_all_really_active()
	return self.__really_active
end

-- Lines: 55 to 56
function ManagerBase:_all_active_requested()
	return self.__active_requested
end

-- Lines: 59 to 60
function ManagerBase:_ao_by_name(name)
	return table.find_value(self.__aos, function (ao)
		return ao:name() == name
	end)
end

-- Lines: 63 to 64
function ManagerBase:_all_ao_by_prio(prio)
	return table.find_all_values(self.__aos, function (ao)
		return self.__ao2prio[ao] == prio
	end)
end

-- Lines: 67 to 68
function ManagerBase:_all_really_active_by_prio(prio)
	return table.find_all_values(self.__really_active, function (ao)
		return self.__ao2prio[ao] == prio
	end)
end

-- Lines: 71 to 72
function ManagerBase:_all_active_requested_by_prio(prio)
	return table.find_all_values(self.__active_requested, function (ao)
		return self.__ao2prio[ao] == prio
	end)
end

-- Lines: 76 to 106
function ManagerBase:_prioritize_and_activate()
	self.__active_requested = table.find_all_values(self.__aos, function (ao)
		return ao:active_requested()
	end)
	local req_prio = math.huge

	for _, ao in ipairs(self.__active_requested) do
		req_prio = math.min(req_prio, self.__ao2prio[ao])
	end

	for ao, prio in pairs(self.__ao2prio) do
		if (prio >= req_prio or ao:really_active()) and (prio ~= req_prio or not ao:active_requested() and ao:really_active()) and ao:really_active() then
			ao:_really_deactivate()
		end
	end

	for ao, prio in pairs(self.__ao2prio) do
		if prio == req_prio and ao:active_requested() and not ao:really_active() then
			ao:_really_activate()
		end
	end

	self.__really_active = table.find_all_values(self.__aos, function (ao)
		return ao:really_active()
	end)
	self.__changed = true
end

-- Lines: 108 to 124
function ManagerBase:end_update(t, dt)
	if self.__changed then
		local p2aos = {}

		for ao, p in pairs(self.__ao2prio) do
			p2aos[p] = p2aos[p] or {}

			table.insert(p2aos[p], ao)
		end

		cat_print("spam", "[ManagerBase] During this frame activation states changed for manager " .. string.upper(self.__name) .. ":")
		cat_print("spam", "[ManagerBase]   <name>           <prio> <active> <really_active>")

		for _, p in ipairs(table.map_keys(p2aos)) do
			for _, ao in ipairs(p2aos[p]) do
				cat_print("spam", string.format("[ManagerBase]    %-15s %5d   %-6s   %s", tostring(ao:name()), p, ao:active_requested() and "YES" or "no", ao:really_active() and "YES" or "no"))
			end
		end

		self.__changed = false
	end
end

