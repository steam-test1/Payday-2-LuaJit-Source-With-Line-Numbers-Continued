PlayerEmpty = PlayerEmpty or class(PlayerMovementState)

-- Lines: 3 to 5
function PlayerEmpty:init(unit)
	PlayerMovementState.init(self, unit)
end

-- Lines: 7 to 9
function PlayerEmpty:enter(state_data, enter_data)
	PlayerMovementState.enter(self, state_data)
end

-- Lines: 11 to 13
function PlayerEmpty:exit(state_data)
	PlayerMovementState.exit(self, state_data)
end

-- Lines: 15 to 17
function PlayerEmpty:update(t, dt)
	PlayerMovementState.update(self, t, dt)
end

-- Lines: 19 to 20
function PlayerEmpty:destroy()
end

return
