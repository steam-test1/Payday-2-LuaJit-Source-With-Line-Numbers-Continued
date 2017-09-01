require("lib/managers/workshop/UGCItem")

WorkshopManager = WorkshopManager or class()
WorkshopManager.PATH = "workshop/"
WorkshopManager.FULL_PATH = Application:base_path() .. WorkshopManager.PATH
WorkshopManager.STAGING_NAME = "temporary_staging"
local UGC = Steam:ugc_handler()

-- Lines: 18 to 29
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

-- Lines: 32 to 33
function WorkshopManager:items()
	return self._items
end

-- Lines: 38 to 56
function WorkshopManager:create_item(type)
	local path = self:_new_item_path()

	if SystemFS:make_dir(path) then
		local item = UGCItem:new(path)

		if type == "weapon_skin" then
			item:add_tag("Weapons")
		end

		if type == "armor_skin" then
			item:add_tag("Armors")
		end

		item:save()
		table.insert_sorted(self._items, item, UGCItem.SortByTimestamp)

		return item
	end

	return nil
end

-- Lines: 60 to 66
function WorkshopManager:delete_item(item)
	local path = item:path()

	if SystemFS:exists(path) then
		SystemFS:delete_file(Application:nice_path(path, false))
		table.delete(self._items, item)
	end
end

-- Lines: 68 to 69
function WorkshopManager:is_initialized()
	return self._initialized
end

-- Lines: 72 to 74
function WorkshopManager:set_enabled(enabled)
	self._enabled = enabled
end

-- Lines: 76 to 77
function WorkshopManager:enabled()
	return self._enabled
end

-- Lines: 80 to 100
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

-- Lines: 106 to 116
function WorkshopManager:_setup()
	if not SystemFS:exists(WorkshopManager.FULL_PATH) and not SystemFS:make_dir(WorkshopManager.FULL_PATH) then
		return
	end

	self:_init_items()

	self._initialized = true
end

-- Lines: 119 to 138
function WorkshopManager:_new_item_path()
	local date = Application:date()
	date = date:gsub(":", "")
	date = date:gsub(" ", "-")
	local date_path = WorkshopManager.FULL_PATH .. date
	local next_path = date_path
	local counter = 2

	while SystemFS:exists(next_path) do
		next_path = date_path .. "_" .. counter
		counter = counter + 1
	end

	return next_path .. "/"
end

-- Lines: 142 to 163
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

