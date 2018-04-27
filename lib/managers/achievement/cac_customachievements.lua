
-- Lines: 2 to 30
local function init_cac_2()
	local state_changed_key = {}
	local enemy_killed_key = {}
	local kill_count = 0
	local target_count = 20

	
	-- Lines: 8 to 13
	local function on_enemy_killed(...)
		kill_count = kill_count + 1

		if kill_count == target_count then
			managers.achievment:award("cac_2")
		end
	end

	
	-- Lines: 15 to 23
	local function on_player_state_changed(state_name)
		kill_count = 0

		if state_name == "bipod" then
			managers.player:register_message(Message.OnEnemyKilled, enemy_killed_key, on_enemy_killed)
		else
			managers.player:unregister_message(Message.OnEnemyKilled, enemy_killed_key)
		end
	end

	managers.player:register_message("player_state_changed", state_changed_key, on_player_state_changed)

	local progress_tweak = tweak_data.achievement.visual.cac_2.progress
	
	-- Lines: 27 to 28
	function progress_tweak.get()
		return kill_count
	end
	progress_tweak.max = target_count
end

-- Lines: 34 to 45
local function init_cac_3()
	local listener_key = {}

	
	-- Lines: 37 to 42
	local function on_flash_grenade_destroyed(attacker_unit)
		local local_player = managers.player:player_unit()

		if local_player and attacker_unit == local_player then
			managers.achievment:award_progress("cac_3_stats")
		end
	end

	managers.player:register_message("flash_grenade_destroyed", listener_key, on_flash_grenade_destroyed)
end

-- Lines: 49 to 57
local function init_cac_7()
	local listener_key = {}

	
	-- Lines: 52 to 54
	local function on_casino_fee_paid(amount)
		managers.achievment:award_progress("cac_7_stats", amount)
	end

	managers.money:add_event_listener(listener_key, "casino_fee_paid", on_casino_fee_paid)
end

-- Lines: 61 to 89
local function init_cac_11_34()
	local listener_key = {}

	
	-- Lines: 64 to 86
	local function on_cop_converted(converted_unit, converting_unit)
		if not alive(converting_unit) then
			return
		end

		managers.achievment:award_progress("cac_34_stats")

		if converting_unit ~= managers.player:player_unit() then
			return
		end

		local cashier_units = {
			Idstring("units/pd2_dlc_rvd/characters/ene_female_civ_undercover/ene_female_civ_undercover"),
			Idstring("units/pd2_dlc_rvd/characters/ene_female_civ_undercover/ene_female_civ_undercover_husk")
		}
		local is_rvd = managers.job:current_job_id() == "rvd"
		local is_cashier = table.contains(cashier_units, converted_unit:name())

		if is_rvd and is_cashier then
			managers.achievment:award("cac_11")
		end
	end

	managers.player:register_message("cop_converted", listener_key, on_cop_converted)
end

-- Lines: 93 to 110
local function init_cac_15()
	local trip_mine_count = 0
	local target_count = 40
	local listener_key = {}

	
	-- Lines: 98 to 107
	local function on_trip_mine_placed()
		if not Global.statistics_manager.playing_from_start then
			return
		end

		trip_mine_count = trip_mine_count + 1

		if trip_mine_count == target_count then
			managers.achievment:award("cac_15")
		end
	end

	managers.player:register_message("trip_mine_placed", listener_key, on_trip_mine_placed)
end

-- Lines: 114 to 138
local function init_cac_20()
	local masks = {
		"sds_01",
		"sds_02",
		"sds_03",
		"sds_04",
		"sds_05",
		"sds_06",
		"sds_07"
	}

	
	-- Lines: 117 to 127
	local function attempt_award()
		for _, mask_id in ipairs(masks) do
			local has_in_inventory = managers.blackmarket:has_item("halloween", "masks", mask_id)
			local has_crafted = managers.blackmarket:get_crafted_item_amount("masks", mask_id) > 0

			if not has_in_inventory and not has_crafted then
				return
			end
		end

		managers.achievment:award("cac_20")
	end

	local listener_key = {}

	
	-- Lines: 130 to 134
	local function on_item_added_to_inventory(id)
		if table.contains(masks, id) then
			attempt_award()
		end
	end

	managers.blackmarket:add_event_listener(listener_key, "added_to_inventory", on_item_added_to_inventory)
	managers.savefile:add_load_sequence_done_callback_handler(attempt_award)
end

-- Lines: 142 to 179
local function init_cac_28()
	if not managers.criminals then
		return
	end

	local listener_key = {}

	
	-- Lines: 148 to 176
	local function on_criminal_added(name, unit, peer_id, ai)
		local session = managers.network:session()
		local peer = session:peer(peer_id)

		if not peer or peer == session:local_peer() then
			return
		end

		local user_sa_viewer = Steam:usa_viewer(peer:user_id())

		user_sa_viewer:refresh(function (success)
			if not success then
				return
			end

			if user_sa_viewer:has_achievement("cac_28") then
				managers.achievment:award("cac_28")
			end
		end)
	end

	managers.criminals:add_listener(listener_key, "on_criminal_added", on_criminal_added)
end

-- Lines: 183 to 191
function AchievmentManager:init_cac_custom_achievements()
	init_cac_2()
	init_cac_3()
	init_cac_7()
	init_cac_11_34()
	init_cac_15()
	init_cac_20()
	init_cac_28()
end

