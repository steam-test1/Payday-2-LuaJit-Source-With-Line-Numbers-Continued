require("lib/setups/GameSetup")
require("lib/network/base/NetworkManager")
require("lib/wip")

NetworkGameSetup = NetworkGameSetup or class(GameSetup)

-- Lines: 9 to 12
function NetworkGameSetup:init_managers(managers)
	GameSetup.init_managers(self, managers)

	managers.network = NetworkManager:new()
end

-- Lines: 14 to 18
function NetworkGameSetup:init_finalize()
	GameSetup.init_finalize(self)
	managers.network:init_finalize()
end

-- Lines: 20 to 24
function NetworkGameSetup:update(t, dt)
	GameSetup.update(self, t, dt)
	managers.network:update(t, dt)
end

-- Lines: 26 to 30
function NetworkGameSetup:paused_update(t, dt)
	GameSetup.paused_update(self, t, dt)
	managers.network:update(t, dt)
end

-- Lines: 32 to 36
function NetworkGameSetup:end_update(t, dt)
	GameSetup.end_update(self, t, dt)
	managers.network:end_update()
end

-- Lines: 38 to 42
function NetworkGameSetup:paused_end_update(t, dt)
	GameSetup.paused_end_update(self, t, dt)
	managers.network:end_update()
end

return NetworkGameSetup
