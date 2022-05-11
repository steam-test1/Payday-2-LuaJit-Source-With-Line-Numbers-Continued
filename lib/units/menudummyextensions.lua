IngameUIExt = IngameUIExt or class()

-- Lines 4-6
function IngameUIExt:init(unit)
	unit:set_extension_update_enabled(Idstring("ingame_ui"), false)
end

-- Lines 7-8
function IngameUIExt:set_active(unit)
end

AIAttentionObject = AIAttentionObject or class()

-- Lines 11-13
function AIAttentionObject:init(unit)
	unit:set_extension_update_enabled(Idstring("attention"), false)
end

-- Lines 14-15
function AIAttentionObject:set_active()
end

UseInteractionExt = UseInteractionExt or class()

-- Lines 18-20
function UseInteractionExt:init(unit)
	unit:set_extension_update_enabled(Idstring("interaction"), false)
end

-- Lines 21-22
function UseInteractionExt:set_active()
end

SecurityCamera = SecurityCamera or class()

-- Lines 25-27
function SecurityCamera:init(unit)
	unit:set_extension_update_enabled(Idstring("base"), false)
end

SecurityCameraInteractionExt = SecurityCameraInteractionExt or class()

-- Lines 30-32
function SecurityCameraInteractionExt:init(unit)
	unit:set_extension_update_enabled(Idstring("interaction"), false)
end

-- Lines 34-35
function SecurityCameraInteractionExt:set_active()
end

ContourExt = ContourExt or class()

-- Lines 38-40
function ContourExt:init(unit)
	unit:set_extension_update_enabled(Idstring("contour"), false)
end

-- Lines 41-42
function ContourExt:set_active()
end

-- Lines 43-44
function ContourExt:update_materials()
end

SyncUnitData = SyncUnitData or class()

-- Lines 47-49
function SyncUnitData:init(unit)
	unit:set_extension_update_enabled(Idstring("sync_unit_data"), false)
end

-- Lines 50-51
function SyncUnitData:set_active()
end

AccessWeaponMenuInteractionExt = AccessWeaponMenuInteractionExt or class()

-- Lines 54-56
function AccessWeaponMenuInteractionExt:init(unit)
	unit:set_extension_update_enabled(Idstring("interaction"), false)
end

-- Lines 58-59
function AccessWeaponMenuInteractionExt:set_active()
end

NetworkBaseExtension = NetworkBaseExtension or class()

-- Lines 62-64
function NetworkBaseExtension:init(unit)
	unit:set_extension_update_enabled(Idstring("network"), false)
end

-- Lines 65-66
function NetworkBaseExtension:set_active()
end

DrivingInteractionExt = DrivingInteractionExt or class()

-- Lines 69-71
function DrivingInteractionExt:init(unit)
	unit:set_extension_update_enabled(Idstring("interaction"), false)
end

-- Lines 72-73
function DrivingInteractionExt:set_active()
end

VehicleDamage = VehicleDamage or class()

-- Lines 76-78
function VehicleDamage:init(unit)
	unit:set_extension_update_enabled(Idstring("damage"), false)
end

-- Lines 79-80
function VehicleDamage:set_active()
end

CarryData = CarryData or class()

-- Lines 83-85
function CarryData:init(unit)
	unit:set_extension_update_enabled(Idstring("carry_data"), false)
end

-- Lines 86-87
function CarryData:set_active()
end

VehicleDrivingExt = VehicleDrivingExt or class()

-- Lines 90-92
function VehicleDrivingExt:init(unit)
	unit:set_extension_update_enabled(Idstring("vehicle_driving"), false)
end

VehicleCamera = VehicleCamera or class()

-- Lines 95-97
function VehicleCamera:init(unit)
	unit:set_extension_update_enabled(Idstring("camera"), false)
end
