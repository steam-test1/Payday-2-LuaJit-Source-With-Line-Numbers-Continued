require("lib/managers/workshop/UGCItem")

WorkshopManager = WorkshopManager or class()
WorkshopManager.PATH = "workshop/"
WorkshopManager.FULL_PATH = Application:base_path() .. WorkshopManager.PATH
WorkshopManager.STAGING_NAME = "temporary_staging"
local UGC = Steam:ugc_handler()

-- Lines: 15 to 26
function WorkshopManager:init()
	if self._initialized then
		return
	end

	self._initialized = false

	self:_setup()

	if managers.user then
		self:set_enabled(managers.user:get_setting("workshop"))
	end
end

-- Lines: 29 to 30
function WorkshopManager:items()
	return self._items
end

-- Lines: 35 to 48
function WorkshopManager:create_item(type)
	local path = self:_new_item_path()

	if SystemFS:make_dir(path) then
		local item = UGCItem:new(path)

		if type == "weapon_skin" then
			item:add_tag("Weapons")
		end

		item:save()
		table.insert_sorted(self._items, item, UGCItem.SortByTimestamp)

		return item
	end

	return nil
end

-- Lines: 52 to 58
function WorkshopManager:delete_item(item)
	local path = item:path()

	if SystemFS:exists(path) then
		SystemFS:delete_file(Application:nice_path(path, false))
		table.delete(self._items, item)
	end
end

-- Lines: 60 to 61
function WorkshopManager:is_initialized()
	return self._initialized
end

-- Lines: 64 to 66
function WorkshopManager:set_enabled(enabled)
	self._enabled = enabled
end

-- Lines: 68 to 69
function WorkshopManager:enabled()
	return self._enabled
end

-- Lines: 72 to 92
function WorkshopManager:create_staging_directory()
	local path = Application:create_temporary_folder()

	if not path or path == "" then
		local basepath = WorkshopManager.FULL_PATH .. WorkshopManager.STAGING_NAME
		path = basepath
		local count = 1

		while SystemFS:exists(path) do
			path = basepath .. count
			count = count + 1
		end

		if not SystemFS:make_dir(path) then
			return nil
		end
	end

	return path .. "/"
end

-- Lines: 98 to 108
function WorkshopManager:_setup()
	if not SystemFS:exists(WorkshopManager.FULL_PATH) and not SystemFS:make_dir(WorkshopManager.FULL_PATH) then
		return
	end

	self:_init_items()

	self._initialized = true
end

-- Lines: 111 to 124
function WorkshopManager:_new_item_path()
	local date = Application:date()
	date = date:gsub(":", "")
	date = date:gsub(" ", "-")
	local next_path = WorkshopManager.FULL_PATH .. date
	local counter = 2

	while SystemFS:exists(next_path) do
		next_path = WorkshopManager.FULL_PATH .. date .. "_" .. counter
		counter = counter + 1
	end

	return next_path .. "/"
end

-- Lines: 127 to 137
function WorkshopManager:_init_items()
	self._items = {}
	local directories = SystemFS:list(WorkshopManager.FULL_PATH, true)

	for _, dir in ipairs(directories) do
		local item_path = WorkshopManager.FULL_PATH .. dir .. "/"
		local item = UGCItem:new(item_path)

		if item:load() then
			table.insert_sorted(self._items, item, UGCItem.SortByTimestamp)
		end
	end
end

return
