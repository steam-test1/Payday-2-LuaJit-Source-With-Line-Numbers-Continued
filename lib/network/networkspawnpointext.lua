NetworkSpawnPointExt = NetworkSpawnPointExt or class()

-- Lines: 3 to 7
function NetworkSpawnPointExt:init(unit)
	if managers.network then
		-- Nothing
	end
end

-- Lines: 10 to 11
function NetworkSpawnPointExt:get_data(unit)
	return {
		position = unit:position(),
		rotation = unit:rotation()
	}
end

-- Lines: 15 to 16
function NetworkSpawnPointExt:destroy(unit)
end

