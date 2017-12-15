require("lib/input/HandState")

local common = require("lib/input/HandStatesCommon")
EmptyHandState = EmptyHandState or class(HandState)

-- Lines: 11 to 53
function EmptyHandState:init()
	EmptyHandState.super.init(self)

	self._connections = {
		toggle_menu = {
			inputs = {"menu_"},
			condition = common.toggle_menu_condition
		},
		warp = {inputs = common.warp_inputs},
		warp_target = {inputs = common.warp_target_inputs},
		run = {inputs = common.run_input},
		touchpad_move = {inputs = {"dpad_"}},
		interact_right = {
			hand = 1,
			inputs = {"grip_"}
		},
		interact_left = {
			hand = 2,
			inputs = {"grip_"}
		},
		automove = {inputs = {"trigger_"}}
	}
end
PointHandState = PointHandState or class(HandState)

-- Lines: 68 to 90
function PointHandState:init()
	PointHandState.super.init(self)

	self._connections = {
		warp = {inputs = common.warp_inputs},
		warp_target = {inputs = common.warp_target_inputs},
		run = {inputs = common.run_input},
		touchpad_move = {inputs = {"dpad_"}},
		automove = {inputs = {"trigger_"}}
	}
end
WeaponHandState = WeaponHandState or class(HandState)

-- Lines: 97 to 141
function WeaponHandState:init()
	WeaponHandState.super.init(self)

	self._connections = {
		toggle_menu = {
			exclusive = true,
			inputs = {"menu_"}
		},
		primary_attack = {inputs = {"trigger_"}},
		reload = {inputs = {"grip_"}},
		switch_hands = {inputs = {"d_up_"}},
		weapon_firemode = {inputs = {"d_left_"}},
		weapon_gadget = {inputs = {"d_right_"}},
		touchpad_primary = {inputs = {"dpad_"}}
	}
end
AkimboHandState = AkimboHandState or class(HandState)

-- Lines: 148 to 156
function AkimboHandState:init()
	AkimboHandState.super.init(self, 1)

	self._connections = {akimbo_fire = {inputs = {"trigger_"}}}
end
MaskHandState = MaskHandState or class(HandState)

-- Lines: 163 to 176
function MaskHandState:init()
	MaskHandState.super.init(self)

	self._connections = {
		toggle_menu = {
			exclusive = true,
			inputs = {"menu_"}
		},
		use_item = {inputs = {"trigger_"}}
	}
end
ItemHandState = ItemHandState or class(HandState)

-- Lines: 183 to 194
function ItemHandState:init()
	ItemHandState.super.init(self, 1)

	self._connections = {
		use_item_vr = {inputs = {"trigger_"}},
		unequip = {inputs = {"grip_"}}
	}
end
AbilityHandState = AbilityHandState or class(HandState)

-- Lines: 201 to 209
function AbilityHandState:init()
	AbilityHandState.super.init(self, 2)

	self._connections = {throw_grenade = {inputs = {"grip_"}}}
end
EquipmentHandState = EquipmentHandState or class(HandState)

-- Lines: 216 to 227
function EquipmentHandState:init()
	EquipmentHandState.super.init(self, 1)

	self._connections = {
		use_item = {inputs = {"trigger_"}},
		unequip = {inputs = {"grip_"}}
	}
end
TabletHandState = TabletHandState or class(HandState)

-- Lines: 234 to 242
function TabletHandState:init()
	TabletHandState.super.init(self)

	self._connections = {toggle_menu = {
		inputs = {"menu_"},
		condition = common.toggle_menu_condition
	}}
end
BeltHandState = BeltHandState or class(HandState)

-- Lines: 249 to 270
function BeltHandState:init()
	BeltHandState.super.init(self, 1)

	self._connections = {
		toggle_menu = {
			inputs = {"menu_"},
			condition = common.toggle_menu_condition
		},
		belt_right = {
			hand = 1,
			inputs = {"grip_"}
		},
		belt_left = {
			hand = 2,
			inputs = {"grip_"}
		},
		disabled = {inputs = {"trigger_"}}
	}
end
RepeaterHandState = RepeaterHandState or class(HandState)

-- Lines: 277 to 279
function RepeaterHandState:init()
	RepeaterHandState.super.init(self, 2)
end
DrivingHandState = DrivingHandState or class(HandState)

-- Lines: 286 to 303
function DrivingHandState:init()
	DrivingHandState.super.init(self)

	self._connections = {
		hand_brake = {
			hand = 2,
			inputs = {"trackpad_button_"}
		},
		interact_right = {
			hand = 1,
			inputs = {"grip_"}
		},
		interact_left = {
			hand = 2,
			inputs = {"grip_"}
		}
	}
end

