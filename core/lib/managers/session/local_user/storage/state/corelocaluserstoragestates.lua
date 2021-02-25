core:module("CoreLocalUserStorageStates")

Init = Init or class()

-- Lines 6-10
function Init:transition()
	if self.storage._load:is_requested() then
		return Loading
	end
end

DetectSignOut = DetectSignOut or class()

-- Lines 14-15
function DetectSignOut:init()
end

Loading = Loading or class(DetectSignOut)

-- Lines 20-23
function Loading:init()
	DetectSignOut.init(self)
	self.storage:_start_load_task()
end

-- Lines 25-27
function Loading:destroy()
	self.storage:_close_load_task()
end

-- Lines 29-42
function Loading:transition()
	local status = self.storage:_load_status()

	if not status then
		return
	end

	if status == SaveData.OK then
		return Ready
	elseif status == SaveData.FILE_NOT_FOUND then
		return NoSaveGameFound
	else
		return LoadError
	end
end

Ready = Ready or class()

-- Lines 48-50
function Ready:init()
	self.storage:_set_stable_for_loading()
end

-- Lines 52-54
function Ready:destroy()
	self.storage:_not_stable_for_loading()
end

-- Lines 56-57
function Ready:transition()
end

NoSaveGameFound = NoSaveGameFound or class()

-- Lines 63-65
function NoSaveGameFound:init()
	self.storage:_set_stable_for_loading()
end

-- Lines 67-69
function NoSaveGameFound:transition()
	self.storage:_not_stable_for_loading()
end

LoadError = LoadError or class()

-- Lines 75-76
function LoadError:transition()
end
