core:module("CoreMenuStateInEditor")
core:import("CoreMenuStateInGame")

InEditor = InEditor or class(CoreMenuStateInGame.InGame)

-- Lines: 6 to 8
function InEditor:init()
	self.menu_state:_set_stable_for_loading()
end

-- Lines: 10 to 12
function InEditor:destroy()
	self.menu_state:_not_stable_for_loading()
end

return
