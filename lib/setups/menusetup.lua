require("lib/setups/Setup")
require("lib/network/base/NetworkManager")
require("lib/managers/MoneyManager")
require("lib/managers/StatisticsManager")
require("lib/managers/MissionManager")
require("lib/managers/CriminalsManager")
require("lib/units/beings/player/PlayerAnimationData")
require("lib/units/menu/MenuMovement")
require("lib/units/MenuScriptUnitData")
require("lib/units/weapons/MenuRaycastWeaponBase")
require("lib/units/weapons/MenuShotgunBase")
require("lib/units/weapons/MenuSawWeaponBase")
require("lib/units/weapons/WeaponGadgetBase")
require("lib/units/weapons/WeaponFlashLight")
require("lib/units/weapons/WeaponLaser")
require("lib/units/weapons/WeaponSecondSight")
require("lib/units/weapons/WeaponSimpleAnim")
require("lib/units/weapons/WeaponLionGadget1")
require("lib/units/weapons/WeaponAmmo")
require("lib/units/weapons/WeaponUnderbarrel")
require("lib/units/weapons/WeaponUnderbarrelLauncher")
require("lib/units/menu/MenuArmourBase")
require("lib/units/ArmorSkinExt")
require("lib/managers/EnvironmentEffectsManager")

IngameUIExt = IngameUIExt or class()

-- Lines: 39 to 40
function IngameUIExt:init(unit)
end

-- Lines: 41 to 42
function IngameUIExt:set_active(unit)
end
AIAttentionObject = AIAttentionObject or class()

-- Lines: 45 to 46
function AIAttentionObject:init(unit)
end

-- Lines: 47 to 48
function AIAttentionObject:set_active()
end
UseInteractionExt = UseInteractionExt or class()

-- Lines: 51 to 52
function UseInteractionExt:init(unit)
end

-- Lines: 53 to 54
function UseInteractionExt:set_active()
end
SecurityCamera = SecurityCamera or class()

-- Lines: 57 to 58
function SecurityCamera:init(unit)
end
SecurityCameraInteractionExt = SecurityCameraInteractionExt or class()

-- Lines: 61 to 62
function SecurityCameraInteractionExt:init(unit)
end

-- Lines: 64 to 65
function SecurityCameraInteractionExt:set_active()
end
ContourExt = ContourExt or class()

-- Lines: 68 to 69
function ContourExt:init(unit)
end

-- Lines: 70 to 71
function ContourExt:set_active()
end
SyncUnitData = SyncUnitData or class()

-- Lines: 74 to 75
function SyncUnitData:init(unit)
end

-- Lines: 76 to 77
function SyncUnitData:set_active()
end
AccessWeaponMenuInteractionExt = AccessWeaponMenuInteractionExt or class()

-- Lines: 80 to 81
function AccessWeaponMenuInteractionExt:init(unit)
end

-- Lines: 83 to 84
function AccessWeaponMenuInteractionExt:set_active()
end
NetworkBaseExtension = NetworkBaseExtension or class()

-- Lines: 87 to 88
function NetworkBaseExtension:init(unit)
end

-- Lines: 89 to 90
function NetworkBaseExtension:set_active()
end
DrivingInteractionExt = DrivingInteractionExt or class()

-- Lines: 93 to 94
function DrivingInteractionExt:init(unit)
end

-- Lines: 95 to 96
function DrivingInteractionExt:set_active()
end
VehicleDamage = VehicleDamage or class()

-- Lines: 99 to 100
function VehicleDamage:init(unit)
end

-- Lines: 101 to 102
function VehicleDamage:set_active()
end
CarryData = CarryData or class()

-- Lines: 105 to 106
function CarryData:init(unit)
end

-- Lines: 107 to 108
function CarryData:set_active()
end
VehicleDrivingExt = VehicleDrivingExt or class()

-- Lines: 111 to 112
function VehicleDrivingExt:init(unit)
end
VehicleCamera = VehicleCamera or class()

-- Lines: 115 to 116
function VehicleCamera:init(unit)
end

require("lib/wip")
core:import("SequenceManager")

MenuSetup = MenuSetup or class(Setup)
MenuSetup.IS_START_MENU = true

-- Lines: 126 to 181
function MenuSetup:load_packages()
	Setup.load_packages(self)

	if not PackageManager:loaded("packages/start_menu") then
		PackageManager:load("packages/start_menu")
	end

	if not PackageManager:loaded("packages/load_level") then
		PackageManager:load("packages/load_level")
	end

	if not PackageManager:loaded("packages/load_default") then
		PackageManager:load("packages/load_default")
	end

	if not PackageManager:loaded("packages/vr_base") then
		PackageManager:load("packages/vr_base")
	end

	if not PackageManager:loaded("packages/vr_menu") then
		PackageManager:load("packages/vr_menu")
	end

	local prefix = "packages/dlcs/"
	local sufix = "/start_menu"
	local package = ""

	for dlc_package, bundled in pairs(tweak_data.BUNDLED_DLC_PACKAGES) do
		package = prefix .. tostring(dlc_package) .. sufix

		Application:debug("[MenuSetup:load_packages] DLC package: " .. package, "Is package OK to load?: " .. tostring(bundled))

		if bundled and (bundled == true or bundled == 1) and PackageManager:package_exists(package) and not PackageManager:loaded(package) then
			PackageManager:load(package)
		end
	end

	local platform = SystemInfo:platform()

	if platform == Idstring("XB1") or platform == Idstring("PS4") then
		if not PackageManager:loaded("packages/game_base_init") then
			PackageManager:load("packages/game_base_init")

			if Application:installer():get_progress() >= 1 then
				PackageManager:load("packages/game_base")
			end

			Global._game_base_package_loaded = true
		end
	elseif not PackageManager:loaded("packages/game_base_init") then

		-- Lines: 173 to 175
		local function _load_wip_func()
			Global._game_base_package_loaded = true
		end


		-- Lines: 176 to 178
		local function load_base_func()
			PackageManager:load("packages/game_base", _load_wip_func)
		end

		PackageManager:load("packages/game_base_init", load_base_func)
	end
end

-- Lines: 183 to 205
function MenuSetup:gather_packages_to_unload()
	Setup.unload_packages(self)

	self._started_unloading_packages = true
	self._packages_to_unload = self._packages_to_unload or {}

	if not Global.load_start_menu then
		if PackageManager:loaded("packages/start_menu") then
			-- Nothing
		end

		local prefix = "packages/dlcs/"
		local sufix = "/start_menu"
		local package = ""

		for dlc_package, bundled in pairs(tweak_data.BUNDLED_DLC_PACKAGES) do
			package = prefix .. tostring(dlc_package) .. sufix

			if bundled and (bundled == true or bundled == 1) and PackageManager:package_exists(package) and PackageManager:loaded(package) then
				table.insert(self._packages_to_unload, package)
			end
		end
	end
end

-- Lines: 207 to 219
function MenuSetup:unload_packages()
	Setup.unload_packages(self)

	if PackageManager:loaded("packages/start_menu") then
		PackageManager:unload("packages/start_menu")
	end

	if PackageManager:loaded("packages/vr_menu") then
		PackageManager:unload("packages/vr_menu")
	end
end

-- Lines: 221 to 343
function MenuSetup:init_game()
	local gsm = Setup.init_game(self)

	if not Application:editor() then
		local event_id, checkpoint_index, level, level_class_name, mission, world_setting, difficulty, intro_skipped = nil

		if not Global.exe_arguments_parsed then
			local arg_list = Application:argv()

			for i = 1, #arg_list, 1 do
				local arg = arg_list[i]

				if arg == "-event_id" then
					event_id = arg_list[i + 1]
					i = i + 1
				elseif arg == "-checkpoint_index" then
					checkpoint_index = tonumber(arg_list[i + 1])
					i = i + 1
				elseif arg == "-level" then
					level = arg_list[i + 1]
					Global.exe_argument_level = level
					i = i + 1
				elseif arg == "-difficulty" then
					difficulty = arg_list[i + 1]
					Global.exe_argument_difficulty = difficulty
					i = i + 1
				elseif arg == "-class" then
					level_class_name = arg_list[i + 1]
					i = i + 1
				elseif arg == "-mission" then
					mission = arg_list[i + 1]
					i = i + 1
				elseif arg == "-world_setting" then
					world_setting = arg_list[i + 1]
					i = i + 1
				elseif arg == "-skip_intro" then
					if not _G.IS_VR then
						game_state_machine:set_boot_intro_done(true)

						intro_skipped = true
					end
				elseif arg == "+connect_lobby" then
					Global.boot_invite = arg_list[i + 1]
				elseif arg == "-auto_enter_level" then
					Global.exe_argument_auto_enter_level = true
					i = i + 1
				end
			end

			if Global.exe_argument_level and not Global.exe_argument_difficulty then
				Global.exe_argument_difficulty = "normal"
			end

			Global.exe_arguments_parsed = true
		end

		if game_state_machine:is_boot_intro_done() then
			if game_state_machine:is_boot_from_sign_out() or intro_skipped then
				game_state_machine:change_state_by_name("menu_titlescreen")
			else
				game_state_machine:change_state_by_name("menu_main")
			end
		else
			game_state_machine:change_state_by_name("bootup")
		end
	end

	return gsm
end

-- Lines: 346 to 358
function MenuSetup:init_managers(managers)
	Setup.init_managers(self, managers)
	managers.sequence:preload()
	PackageManager:set_resource_loaded_clbk(Idstring("unit"), callback(managers.sequence, managers.sequence, "clbk_pkg_manager_unit_loaded"))

	managers.menu_scene = MenuSceneManager:new()
	managers.money = MoneyManager:new()
	managers.statistics = StatisticsManager:new()
	managers.network = NetworkManager:new()
end

-- Lines: 360 to 390
function MenuSetup:init_finalize()
	Setup.init_finalize(self)

	if managers.network:session() then
		managers.network:init_finalize()
	end

	if SystemInfo:platform() == Idstring("PS3") then
		if not Global.hdd_space_checked then
			managers.savefile:check_space_required()

			self.update = self.update_wait_for_savegame_info
		else
			managers.achievment:chk_install_trophies()
		end
	end

	if SystemInfo:platform() == Idstring("PS4") then
		managers.achievment:chk_install_trophies()
	end

	if managers.music then
		managers.music:init_finalize()
	end

	if managers.challenge then
		managers.challenge:init_finalize()
	end

	managers.dyn_resource:post_init()
	TestAPIHelper.on_event("exit_to_menu")
end

-- Lines: 395 to 411
function MenuSetup:update_wait_for_savegame_info(t, dt)
	managers.savefile:update(t, dt)
	print("Checking fetch_savegame_hdd_space_required")

	if managers.savefile:fetch_savegame_hdd_space_required() then
		Application:check_sufficient_hdd_space_to_launch(managers.savefile:fetch_savegame_hdd_space_required(), managers.dlc:has_full_game())

		if SystemInfo:platform() == Idstring("PS3") or SystemInfo:platform() == Idstring("PS4") then
			Trophies:set_translation_text(managers.localization:text("err_load"), managers.localization:text("err_ins"), managers.localization:text("err_disk"))
			managers.achievment:chk_install_trophies()
		end

		Global.hdd_space_checked = true
		self.update = nil
	end
end

-- Lines: 413 to 418
function MenuSetup:update(t, dt)
	Setup.update(self, t, dt)
	managers.crimenet:update(t, dt)
	managers.network:update(t, dt)
end

-- Lines: 420 to 424
function MenuSetup:paused_update(t, dt)
	Setup.paused_update(self, t, dt)
	managers.network:update(t, dt)
end

-- Lines: 426 to 454
function MenuSetup:end_update(t, dt)
	Setup.end_update(self, t, dt)
	managers.network:end_update()
end

-- Lines: 456 to 460
function MenuSetup:paused_end_update(t, dt)
	Setup.paused_end_update(self, t, dt)
	managers.network:end_update()
end

-- Lines: 462 to 465
function MenuSetup:destroy()
	MenuSetup.super.destroy(self)
	managers.menu_scene:destroy()
end

