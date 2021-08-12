core:import("CoreMissionManager")
core:import("CoreClass")
require("lib/managers/mission/MissionScriptElement")
require("lib/managers/mission/ElementSpawnEnemyGroup")
require("lib/managers/mission/ElementEnemyPrefered")
require("lib/managers/mission/ElementAIGraph")
require("lib/managers/mission/ElementWaypoint")
require("lib/managers/mission/ElementSpawnCivilian")
require("lib/managers/mission/ElementSpawnCivilianGroup")
require("lib/managers/mission/ElementLookAtTrigger")
require("lib/managers/mission/ElementMissionEnd")
require("lib/managers/mission/ElementObjective")
require("lib/managers/mission/ElementConsoleCommand")
require("lib/managers/mission/ElementDialogue")
require("lib/managers/mission/ElementHeat")
require("lib/managers/mission/ElementHint")
require("lib/managers/mission/ElementMoney")
require("lib/managers/mission/ElementFleePoint")
require("lib/managers/mission/ElementAiGlobalEvent")
require("lib/managers/mission/ElementEquipment")
require("lib/managers/mission/ElementAreaMinPoliceForce")
require("lib/managers/mission/ElementPlayerState")
require("lib/managers/mission/ElementKillZone")
require("lib/managers/mission/ElementActionMessage")
require("lib/managers/mission/ElementGameDirection")
require("lib/managers/mission/ElementPressure")
require("lib/managers/mission/ElementDangerZone")
require("lib/managers/mission/ElementScenarioEvent")
require("lib/managers/mission/ElementSpecialObjective")
require("lib/managers/mission/ElementSpecialObjectiveTrigger")
require("lib/managers/mission/ElementSpecialObjectiveGroup")
require("lib/managers/mission/ElementDifficulty")
require("lib/managers/mission/ElementBlurZone")
require("lib/managers/mission/ElementAIRemove")
require("lib/managers/mission/ElementFlashlight")
require("lib/managers/mission/ElementTeammateComment")
require("lib/managers/mission/ElementCharacterOutline")
require("lib/managers/mission/ElementFakeAssaultState")
require("lib/managers/mission/ElementForceEndAssaultState")
require("lib/managers/mission/ElementWhisperState")
require("lib/managers/mission/ElementDifficultyLevelCheck")
require("lib/managers/mission/ElementAwardAchievment")
require("lib/managers/mission/ElementPlayerNumberCheck")
require("lib/managers/mission/ElementPointOfNoReturn")
require("lib/managers/mission/ElementFadeToBlack")
require("lib/managers/mission/ElementAlertTrigger")
require("lib/managers/mission/ElementFeedback")
require("lib/managers/mission/ElementExplosion")
require("lib/managers/mission/ElementFilter")
require("lib/managers/mission/ElementDisableUnit")
require("lib/managers/mission/ElementEnableUnit")
require("lib/managers/mission/ElementSmokeGrenade")
require("lib/managers/mission/ElementDisableShout")
require("lib/managers/mission/ElementSetOutline")
require("lib/managers/mission/ElementExplosionDamage")
require("lib/managers/mission/ElementPlayerStyle")
require("lib/managers/mission/ElementDropinState")
require("lib/managers/mission/ElementBainState")
require("lib/managers/mission/ElementBlackscreenVariant")
require("lib/managers/mission/ElementAccessCamera")
require("lib/managers/mission/ElementAIAttention")
require("lib/managers/mission/ElementMissionFilter")
require("lib/managers/mission/ElementAIArea")
require("lib/managers/mission/ElementSecurityCamera")
require("lib/managers/mission/ElementCarry")
require("lib/managers/mission/ElementLootBag")
require("lib/managers/mission/ElementJobValue")
require("lib/managers/mission/ElementJobStageAlternative")
require("lib/managers/mission/ElementNavObstacle")
require("lib/managers/mission/ElementLootSecuredTrigger")
require("lib/managers/mission/ElementMandatoryBags")
require("lib/managers/mission/ElementAssetTrigger")
require("lib/managers/mission/ElementSpawnDeployable")
require("lib/managers/mission/ElementInventoryDummy")
require("lib/managers/mission/ElementProfileFilter")
require("lib/managers/mission/ElementFleePoint")
require("lib/managers/mission/ElementInstigator")
require("lib/managers/mission/ElementInstigatorRule")
require("lib/managers/mission/ElementPickup")
require("lib/managers/mission/ElementLaserTrigger")
require("lib/managers/mission/ElementSpawnGrenade")
require("lib/managers/mission/ElementSpotter")
require("lib/managers/mission/ElementSpawnGageAssignment")
require("lib/managers/mission/ElementPrePlanning")
require("lib/managers/mission/ElementCinematicCamera")
require("lib/managers/mission/ElementCharacterTeam")
require("lib/managers/mission/ElementTeamRelation")
require("lib/managers/mission/ElementSlowMotion")
require("lib/managers/mission/ElementInteraction")
require("lib/managers/mission/ElementCharacterSequence")
require("lib/managers/mission/ElementExperience")
require("lib/managers/mission/ElementModifyPlayer")
require("lib/managers/mission/ElementStatistics")
require("lib/managers/mission/ElementStatisticsJobs")
require("lib/managers/mission/ElementStatisticsContact")
require("lib/managers/mission/ElementGameEventSet")
require("lib/managers/mission/ElementGameEventIsDone")
require("lib/managers/mission/ElementVariableSet")
require("lib/managers/mission/ElementVariableGet")
require("lib/managers/mission/ElementTeamAICommands")
require("lib/managers/mission/ElementEnableSoundEnvironment")
require("lib/managers/mission/ElementCheckDLC")
require("lib/managers/mission/ElementUnitDamage")
require("lib/managers/mission/ElementStopwatch")
require("lib/managers/mission/ElementClock")
require("lib/managers/mission/ElementPlayerCharacter")
require("lib/managers/mission/ElementRandomInstance")
require("lib/managers/mission/ElementLoadDelayed")
require("lib/managers/mission/ElementUnloadStatic")
require("lib/managers/mission/ElementChangeVanSkin")
require("lib/managers/mission/ElementCustomSafehouse")
require("lib/managers/mission/ElementLootPile")
require("lib/managers/mission/ElementTango")
require("lib/managers/mission/ElementInvulnerable")
require("lib/managers/mission/ElementCharacterDamage")
require("lib/managers/mission/ElementAIForceAttention")
require("lib/managers/mission/ElementAIForceAttentionOperator")
require("lib/managers/mission/ElementSideJob")
require("lib/managers/mission/ElementEventSideJob")
require("lib/managers/mission/ElementPickupCriminalDeployables")
require("lib/managers/mission/ElementTeleportPlayer")
require("lib/managers/mission/ElementHeistTimer")
require("lib/managers/mission/ElementDropInPoint")
require("lib/managers/mission/ElementSpawnTeamAI")
require("lib/managers/mission/ElementArcadeState")
require("lib/managers/mission/ElementPlayerSpawner")
require("lib/managers/mission/ElementAreaTrigger")
require("lib/managers/mission/ElementSpawnEnemyDummy")
require("lib/managers/mission/ElementEnemyDummyTrigger")
require("lib/managers/mission/ElementMotionpathMarker")
require("lib/managers/mission/ElementVehicleTrigger")
require("lib/managers/mission/ElementVehicleOperator")
require("lib/managers/mission/ElementVehicleSpawner")
require("lib/managers/mission/ElementVehicleBoarding")
require("lib/managers/mission/ElementEnvironmentOperator")
require("lib/managers/mission/ElementAreaDespawn")
require("lib/managers/mission/ElementTerminateAssault")

MissionManager = MissionManager or class(CoreMissionManager.MissionManager)

-- Lines 164-279
function MissionManager:init(...)
	MissionManager.super.init(self, ...)
	self:add_area_instigator_categories("player")
	self:add_area_instigator_categories("enemies")
	self:add_area_instigator_categories("civilians")
	self:add_area_instigator_categories("escorts")
	self:add_area_instigator_categories("persons")
	self:add_area_instigator_categories("local_criminals")
	self:add_area_instigator_categories("player_criminals")
	self:add_area_instigator_categories("criminals")
	self:add_area_instigator_categories("ai_teammates")
	self:add_area_instigator_categories("loot")
	self:add_area_instigator_categories("unique_loot")
	self:add_area_instigator_categories("vehicle")
	self:add_area_instigator_categories("npc_vehicle")
	self:add_area_instigator_categories("vehicle_with_players")
	self:add_area_instigator_categories("player_not_in_vehicle")
	self:add_area_instigator_categories("hostages")
	self:add_area_instigator_categories("equipment")
	self:add_area_instigator_categories("intimidated_enemies")
	self:add_area_instigator_categories("player1")
	self:add_area_instigator_categories("player2")
	self:add_area_instigator_categories("player3")
	self:add_area_instigator_categories("player4")
	self:add_area_instigator_categories("vr_player")
	self:set_default_area_instigator("player")
	self:set_global_event_list({
		"bankmanager_key",
		"keycard",
		"start_assault",
		"end_assault",
		"end_assault_late",
		"police_called",
		"police_weapons_hot",
		"civilian_killed",
		"loot_lost",
		"loot_exploded",
		"pku_gold",
		"pku_money",
		"pku_jewelry",
		"pku_painting",
		"pku_meth",
		"pku_cocaine",
		"pku_weapons",
		"pku_toolbag",
		"pku_atm",
		"pku_folder",
		"pku_poster",
		"pku_artifact_statue",
		"pku_server",
		"pku_samurai",
		"bar_code",
		"equipment_evidence_lost",
		"pku_sandwich",
		"equipment_sandwich",
		"hotel_room_key",
		"pku_evidence_bag",
		"ecm_jammer_on",
		"ecm_jammer_off",
		"pku_warhead",
		"enemy_killed",
		"pku_rambo",
		"player_damaged",
		"key",
		"pku_winch_bag_01",
		"pku_winch_bag_02",
		"pku_winch_bag_03",
		"player_deploy_bodybagsbag",
		"player_refill_bodybagsbag",
		"player_deploy_doctorbag",
		"player_refill_doctorbag",
		"player_deploy_ecmjammer",
		"player_pickup_bodybag",
		"player_answer_pager",
		"blue_loot_bags",
		"player_release_ai",
		"player_revive_ai",
		"player_in_custody",
		"ai_in_custody",
		"turret_destroyed",
		"pku_toothbrush",
		"tripmine_exploded",
		"cloaker_loot",
		"pku_usb_drive",
		"pku_diamond_necklace",
		"pku_wine",
		"pku_expensive_wine",
		"pku_tin_boy_toy",
		"pku_high_heels",
		"pku_vr_headset",
		"pku_red_diamond",
		"pku_diamond_dah",
		"pku_blue_diamond",
		"pku_jewelry_instant",
		"pku_black_tablet",
		"pku_german_folder",
		"pku_old_wine",
		"uno_access_granted",
		"uno_access_denied",
		"pku_faberge_egg",
		"pku_faberge_egg",
		"pku_treasure",
		"pku_police_uniform",
		"player_criminal_death",
		"keychain",
		"blue_loot_bag_dropped",
		"pku_adrenaline_syringe"
	})

	self._mission_filter = {}

	if not Global.mission_manager then
		Global.mission_manager = {
			stage_job_values = {},
			job_values = {},
			saved_job_values = {},
			has_played_tutorial = false,
			safehouse_ask_amount = 0
		}
	end
end

-- Lines 281-284
function MissionManager:set_saved_job_value(key, value)
	Global.mission_manager.saved_job_values[key] = value

	self:on_set_saved_job_value(key, value)
end

-- Lines 286-288
function MissionManager:get_saved_job_value(key)
	return Global.mission_manager.saved_job_values[key]
end

-- Lines 290-306
function MissionManager:on_set_saved_job_value(key, value)
	local christmas_presents_values = {
		present_bex = false,
		present_pex = false,
		present_mex = false,
		present_fex = false
	}

	for name, state in pairs(christmas_presents_values) do
		if Global.mission_manager.saved_job_values[name] ~= nil then
			christmas_presents_values[name] = true
		end
	end

	if christmas_presents_values.present_mex and christmas_presents_values.present_bex and christmas_presents_values.present_pex and christmas_presents_values.present_fex then
		managers.achievment:award("xm20_1")
	end
end

-- Lines 312-319
function MissionManager:on_reset_profile()
	for key, value in pairs(Global.mission_manager.saved_job_values) do
		Global.mission_manager.saved_job_values[key] = nil
	end

	Global.mission_manager.has_played_tutorial = false
	Global.mission_manager.safehouse_ask_amount = 0
end

-- Lines 321-324
function MissionManager:set_job_value(key, value)
	Global.mission_manager.stage_job_values[key] = value
end

-- Lines 326-328
function MissionManager:get_job_value(key)
	return Global.mission_manager.job_values[key] or Global.mission_manager.stage_job_values[key]
end

-- Lines 330-332
function MissionManager:on_job_deactivated()
	self:clear_job_values()
end

-- Lines 334-337
function MissionManager:clear_job_values()
	Global.mission_manager.job_values = {}
	Global.mission_manager.stage_job_values = {}
end

-- Lines 339-342
function MissionManager:on_retry_job_stage()
	Global.mission_manager.stage_job_values = {}
end

-- Lines 344-350
function MissionManager:on_stage_success()
	for key, value in pairs(Global.mission_manager.stage_job_values) do
		Global.mission_manager.job_values[key] = value
	end

	Global.mission_manager.stage_job_values = {}
end

-- Lines 352-354
function MissionManager:set_mission_filter(mission_filter)
	self._mission_filter = mission_filter
end

-- Lines 356-358
function MissionManager:check_mission_filter(value)
	return table.contains(self._mission_filter, value)
end

-- Lines 360-362
function MissionManager:default_instigator()
	return managers.player:player_unit()
end

-- Lines 364-369
function MissionManager:activate_script(...)
	MissionManager.super.activate_script(self, ...)
end

-- Lines 371-379
function MissionManager:client_run_mission_element(id, unit, orientation_element_index)
	for name, data in pairs(self._scripts) do
		if data:element(id) then
			data:element(id):set_synced_orientation_element_index(orientation_element_index)
			data:element(id):client_on_executed(unit)

			return
		end
	end
end

-- Lines 382-392
function MissionManager:client_run_mission_element_end_screen(id, unit, orientation_element_index)
	for name, data in pairs(self._scripts) do
		if data:element(id) then
			if data:element(id).client_on_executed_end_screen then
				data:element(id):set_synced_orientation_element_index(orientation_element_index)
				data:element(id):client_on_executed_end_screen(unit)
			end

			return
		end
	end
end

-- Lines 394-402
function MissionManager:server_run_mission_element_trigger(id, unit)
	for name, data in pairs(self._scripts) do
		local element = data:element(id)

		if element then
			element:on_executed(unit)

			return
		end
	end
end

-- Lines 405-420
function MissionManager:to_server_area_event(event_id, id, unit)
	for name, data in pairs(self._scripts) do
		local element = data:element(id)

		if element then
			if event_id == 1 then
				element:sync_enter_area(unit)
			elseif event_id == 2 then
				element:sync_exit_area(unit)
			elseif event_id == 3 then
				element:sync_while_in_area(unit)
			elseif event_id == 4 then
				element:sync_rule_failed(unit)
			end
		end
	end
end

-- Lines 444-451
function MissionManager:to_server_access_camera_trigger(id, trigger, instigator)
	for name, data in pairs(self._scripts) do
		local element = data:element(id)

		if element then
			element:check_triggers(trigger, instigator)
		end
	end
end

-- Lines 453-460
function MissionManager:save_job_values(data)
	local state = {
		saved_job_values = Global.mission_manager.saved_job_values,
		has_played_tutorial = Global.mission_manager.has_played_tutorial,
		safehouse_ask_amount = Global.mission_manager.safehouse_ask_amount
	}
	data.ProductMissionManager = state
end

-- Lines 462-469
function MissionManager:load_job_values(data)
	local state = data.ProductMissionManager

	if state then
		Global.mission_manager.saved_job_values = state.saved_job_values
		Global.mission_manager.has_played_tutorial = state.has_played_tutorial
		Global.mission_manager.safehouse_ask_amount = state.safehouse_ask_amount or 0
	end
end

-- Lines 472-477
function MissionManager:stop_simulation(...)
	MissionManager.super.stop_simulation(self, ...)

	Global.mission_manager.saved_job_values = {}

	self:on_job_deactivated()
	managers.loot:reset()
end

-- Lines 479-487
function MissionManager:get_mission_element_by_name(name)
	for _, data in pairs(self._scripts) do
		for id, element in pairs(data:elements()) do
			if element:editor_name() == name then
				return element
			end
		end
	end
end

CoreClass.override_class(CoreMissionManager.MissionManager, MissionManager)

MissionScript = MissionScript or class(CoreMissionManager.MissionScript)

-- Lines 522-538
function MissionScript:activate(...)
	if Network:is_server() then
		MissionScript.super.activate(self, ...)

		return
	end

	managers.mission:add_persistent_debug_output("")
	managers.mission:add_persistent_debug_output("Activate mission " .. self._name, Color(1, 0, 1, 0))

	for _, element in pairs(self._elements) do
		element:on_script_activated()
	end

	for _, element in pairs(self._elements) do
		if element:value("execute_on_startup") then
			-- Nothing
		end
	end
end

CoreClass.override_class(CoreMissionManager.MissionScript, MissionScript)
