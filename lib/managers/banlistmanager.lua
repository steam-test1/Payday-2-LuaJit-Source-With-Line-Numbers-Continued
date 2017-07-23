BanListManager = BanListManager or class()

-- Lines: 3 to 10
function BanListManager:init()
	if not Global.ban_list then
		Global.ban_list = {}
	end

	self._global = self._global or Global.ban_list
	self._global.banned = self._global.banned or {}
end

-- Lines: 12 to 14
function BanListManager:ban(identifier, name)
	table.insert(self._global.banned, {
		name = name,
		identifier = identifier
	})
end

-- Lines: 16 to 28
function BanListManager:unban(identifier)
	local user_index = nil

	for index, user in ipairs(self._global.banned) do
		if user.identifier == identifier then
			user_index = index

			break
		end
	end

	if user_index then
		table.remove(self._global.banned, user_index)
	end
end

-- Lines: 30 to 36
function BanListManager:banned(identifier)
	for _, user in ipairs(self._global.banned) do
		if user.identifier == identifier then
			return true
		end
	end

	return false
end

-- Lines: 39 to 40
function BanListManager:ban_list()
	return self._global.banned
end

-- Lines: 43 to 45
function BanListManager:save(data)
	data.ban_list = self._global
end

-- Lines: 47 to 52
function BanListManager:load(data)
	if data.ban_list then
		Global.ban_list = data.ban_list
		self._global = Global.ban_list
	end
end

