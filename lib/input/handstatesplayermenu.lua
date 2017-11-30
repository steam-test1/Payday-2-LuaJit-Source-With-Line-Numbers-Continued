require("lib/input/HandState")

HandStatesPlayerMenu = HandStatesPlayerMenu or {}
local M = HandStatesPlayerMenu
M.DefaultHandState = M.DefaultHandState or class(HandState)

-- Lines: 11 to 21
M.DefaultHandState.init = function (self)
	M.DefaultHandState.super.init(self)

	self._connections = {
		toggle_menu = {inputs = {"menu_"}},
		cancel = {inputs = {"grip_"}}
	}
end
M.EmptyHandState = M.EmptyHandState or class(HandState)

-- Lines: 28 to 44
M.EmptyHandState.init = function (self)
	M.EmptyHandState.super.init(self)

	self._connections = {
		toggle_menu = {inputs = {"menu_"}},
		cancel = {inputs = {"grip_"}},
		warp = {inputs = {
			"trackpad_button_",
			"d_up_"
		}},
		warp_target = {inputs = {"trackpad_button_"}}
	}
end
M.LaserHandState = M.LaserHandState or class(HandState)

-- Lines: 51 to 72
M.LaserHandState.init = function (self)
	M.LaserHandState.super.init(self)

	self._connections = {
		toggle_menu = {inputs = {"menu_"}},
		laser_primary = {inputs = {"trigger_"}},
		laser_secondary = {inputs = {"trackpad_button_"}},
		cancel = {inputs = {"grip_"}},
		touchpad_primary = {inputs = {"dpad_"}}
	}
end
M.CustomizationLaserHandState = M.CustomizationLaserHandState or class(HandState)

-- Lines: 79 to 100
M.CustomizationLaserHandState.init = function (self)
	M.CustomizationLaserHandState.super.init(self)

	self._connections = {
		toggle_menu = {inputs = {"menu_"}},
		laser_primary = {inputs = {"trigger_"}},
		laser_secondary = {inputs = {"trackpad_button_"}},
		interact = {inputs = {"grip_"}},
		touchpad_primary = {inputs = {"dpad_"}}
	}
end

