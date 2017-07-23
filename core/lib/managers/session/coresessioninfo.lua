core:module("CoreSessionInfo")

Info = Info or class()

-- Lines: 5 to 6
function Info:init()
end

-- Lines: 8 to 9
function Info:is_ranked()
	return self._is_ranked
end

-- Lines: 12 to 13
function Info:can_join_in_progress()
	return self._can_join_in_progress
end

-- Lines: 16 to 18
function Info:set_can_join_in_progress(possible)
	self._can_join_in_progress = possible
end

-- Lines: 20 to 22
function Info:set_level_name(name)
	self._level_name = name
end

-- Lines: 24 to 25
function Info:level_name()
	return self._level_name
end

-- Lines: 28 to 30
function Info:set_stage_name(stage_name)
	self._stage_name = stage_name
end

-- Lines: 32 to 33
function Info:stage_name()
	return self._stage_name
end

-- Lines: 36 to 38
function Info:set_run_mission_script(with_mission)
	self._run_mission_script = with_mission
end

-- Lines: 40 to 41
function Info:should_run_mission_script()
	return self._run_mission_script
end

-- Lines: 44 to 46
function Info:set_should_load_level(load_level)
	self._should_load_level = load_level
end

-- Lines: 48 to 49
function Info:should_load_level()
	return self._should_load_level
end

