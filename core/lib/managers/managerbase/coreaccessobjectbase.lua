core:module("CoreAccessObjectBase")

AccessObjectBase = AccessObjectBase or class()

-- Lines: 10 to 15
function AccessObjectBase:init(manager, name)
	self.__manager = manager
	self.__name = name
	self.__active_requested = false
	self.__really_activated = false
end

-- Lines: 17 to 18
function AccessObjectBase:name()
	return self.__name
end

-- Lines: 21 to 22
function AccessObjectBase:active()
	return self.__active_requested
end

-- Lines: 25 to 26
function AccessObjectBase:active_requested()
	return self.__active_requested
end

-- Lines: 31 to 32
function AccessObjectBase:really_active()
	return self.__really_activated
end

-- Lines: 35 to 40
function AccessObjectBase:set_active(active)
	if self.__active_requested ~= active then
		self.__active_requested = active

		self.__manager:_prioritize_and_activate()
	end
end

-- Lines: 47 to 49
function AccessObjectBase:_really_activate()
	self.__really_activated = true
end

-- Lines: 52 to 54
function AccessObjectBase:_really_deactivate()
	self.__really_activated = false
end

return
