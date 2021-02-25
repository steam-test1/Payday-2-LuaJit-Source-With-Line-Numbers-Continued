NetworkSpawnPointExt = NetworkSpawnPointExt or class()

-- Lines 3-7
function NetworkSpawnPointExt:init(unit)
	if managers.network then
		-- Nothing
	end
end

-- Lines 10-12
function NetworkSpawnPointExt:get_data(unit)
	return {
		position = unit:position(),
		rotation = unit:rotation()
	}
end

-- Lines 14-16
function NetworkSpawnPointExt:destroy(unit)
end
