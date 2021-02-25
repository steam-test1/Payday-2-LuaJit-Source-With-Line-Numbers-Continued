core:module("CoreSessionInfo")

Info = Info or class()

-- Lines 5-6
function Info:init()
end

-- Lines 8-10
function Info:is_ranked()
	return self._is_ranked
end

-- Lines 12-14
function Info:can_join_in_progress()
	return self._can_join_in_progress
end

-- Lines 16-18
function Info:set_can_join_in_progress(possible)
	self._can_join_in_progress = possible
end

-- Lines 20-22
function Info:set_level_name(name)
	self._level_name = name
end

-- Lines 24-26
function Info:level_name()
	return self._level_name
end

-- Lines 28-30
function Info:set_stage_name(stage_name)
	self._stage_name = stage_name
end

-- Lines 32-34
function Info:stage_name()
	return self._stage_name
end

-- Lines 36-38
function Info:set_run_mission_script(with_mission)
	self._run_mission_script = with_mission
end

-- Lines 40-42
function Info:should_run_mission_script()
	return self._run_mission_script
end

-- Lines 44-46
function Info:set_should_load_level(load_level)
	self._should_load_level = load_level
end

-- Lines 48-50
function Info:should_load_level()
	return self._should_load_level
end
