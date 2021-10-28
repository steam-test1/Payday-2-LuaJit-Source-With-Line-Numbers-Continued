core:import("CoreEvent")
require("lib/managers/HUDManagerAnimatePD2")
require("lib/managers/hud/HUDTeammate")
require("lib/managers/hud/HUDInteraction")
require("lib/managers/hud/NewHudStatsScreen")
require("lib/managers/hud/HudChallengeNotification")
require("lib/managers/hud/HUDObjectives")
require("lib/managers/hud/HUDPresenter")
require("lib/managers/hud/HUDAssaultCorner")
require("lib/managers/hud/HUDChat")
require("lib/managers/hud/HUDHint")
require("lib/managers/hud/HUDAccessCamera")
require("lib/managers/hud/HUDDriving")
require("lib/managers/hud/HUDHeistTimer")
require("lib/managers/hud/HUDTemp")
require("lib/managers/hud/HUDSuspicion")
require("lib/managers/hud/HUDBlackScreen")
require("lib/managers/hud/HUDMissionBriefing")
require("lib/managers/hud/HUDStageEndScreen")
require("lib/managers/hud/HUDLootScreen")
require("lib/managers/hud/HUDHitConfirm")
require("lib/managers/hud/HUDHitDirection")
require("lib/managers/hud/HUDPlayerDowned")
require("lib/managers/hud/HUDPlayerCustody")
require("lib/managers/hud/HUDWaitingLegend")
require("lib/managers/hud/HUDStageEndCrimeSpreeScreen")
require("lib/managers/hud/HUDStatsScreenSkirmish")
require("lib/managers/hud/HUDLootScreenSkirmish")

HUDManager.disabled = {
	[Idstring("guis/player_hud"):key()] = true,
	[Idstring("guis/experience_hud"):key()] = true
}
HUDManager.PLAYER_PANEL = 4

-- Lines 59-75
function HUDManager:controller_mod_changed()
	if self:alive("guis/mask_off_hud") then
		self:script("guis/mask_off_hud").mask_on_text:set_text(utf8.to_upper(managers.localization:text("hud_instruct_mask_on", {
			BTN_USE_ITEM = managers.localization:btn_macro("use_item")
		})))
	end

	if self._hud_temp then
		self._hud_temp:set_throw_bag_text()
	end

	if self._hud_player_downed then
		self._hud_player_downed:set_arrest_finished_text()
	end

	if alive(managers.interaction:active_unit()) then
		managers.interaction:active_unit():interaction():selected()
	end
end

-- Lines 79-84
function HUDManager:make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

-- Lines 86-91
function HUDManager:text_clone(text)
	return text:parent():text({
		font = tweak_data.hud.medium_font_noshadow,
		font_size = text:font_size(),
		text = text:text(),
		x = text:x(),
		y = text:y(),
		w = text:w(),
		h = text:h(),
		align = text:align(),
		vertical = text:vertical(),
		layer = text:layer(),
		color = text:color(),
		visible = text:visible()
	})
end

-- Lines 95-97
function HUDManager:set_player_location(location_id)
end

-- Lines 99-101
function HUDManager:hide_local_player_gear()
	self:hide_player_gear(HUDManager.PLAYER_PANEL)
end

-- Lines 102-104
function HUDManager:show_local_player_gear()
	self:show_player_gear(HUDManager.PLAYER_PANEL)
end

-- Lines 105-114
function HUDManager:hide_player_gear(panel_id)
	if self._teammate_panels[panel_id] and self._teammate_panels[panel_id]:panel() and self._teammate_panels[panel_id]:panel():child("player") then
		local player_panel = self._teammate_panels[panel_id]:panel():child("player")
		local teammate_panel = self._teammate_panels[panel_id]

		player_panel:child("weapons_panel"):set_visible(false)
		teammate_panel._deployable_equipment_panel:set_visible(false)
		teammate_panel._cable_ties_panel:set_visible(false)
		teammate_panel._grenades_panel:set_visible(false)
	end
end

-- Lines 115-124
function HUDManager:show_player_gear(panel_id)
	if self._teammate_panels[panel_id] and self._teammate_panels[panel_id]:panel() and self._teammate_panels[panel_id]:panel():child("player") then
		local player_panel = self._teammate_panels[panel_id]:panel():child("player")
		local teammate_panel = self._teammate_panels[panel_id]

		player_panel:child("weapons_panel"):set_visible(true)
		teammate_panel._deployable_equipment_panel:set_visible(true)
		teammate_panel._cable_ties_panel:set_visible(true)
		teammate_panel._grenades_panel:set_visible(true)
	end
end

-- Lines 135-154
function HUDManager:add_weapon(data)
	self:_set_weapon(data)

	local teammate_panel = self._teammate_panels[HUDManager.PLAYER_PANEL]:panel()
	self._hud.weapons[data.inventory_index] = {
		inventory_index = data.inventory_index,
		unit = data.unit
	}

	if data.is_equip then
		self:set_weapon_selected_by_inventory_index(data.inventory_index)
	end

	if not data.is_equip and (data.inventory_index == 1 or data.inventory_index == 2) then
		self:_update_second_weapon_ammo_info(HUDManager.PLAYER_PANEL, data.unit)
	end
end

-- Lines 156-166
function HUDManager:_set_weapon(data)
	if data.inventory_index > 2 then
		return
	end
end

-- Lines 169-171
function HUDManager:set_weapon_selected_by_inventory_index(inventory_index)
	self:_set_weapon_selected(inventory_index)
end

-- Lines 174-178
function HUDManager:_set_weapon_selected(id)
	self._hud.selected_weapon = id
	local icon = self._hud.weapons[self._hud.selected_weapon].unit:base():weapon_tweak_data().hud_icon

	self:_set_teammate_weapon_selected(HUDManager.PLAYER_PANEL, id, icon)
end

-- Lines 180-185
function HUDManager:_set_teammate_weapon_selected(i, id, icon)
	self._teammate_panels[i]:set_weapon_selected(id, icon)
end

-- Lines 187-191
function HUDManager:recreate_weapon_firemode(i)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:recreate_weapon_firemode()
	end
end

-- Lines 194-227
function HUDManager:get_waiting_index(peer_id)
	self._waiting_index = self._waiting_index or {}

	if self._waiting_index[peer_id] then
		return self._waiting_index[peer_id]
	end

	-- Lines 200-203
	local function set_index(i)
		self._waiting_index[peer_id] = i

		return i
	end

	-- Lines 205-207
	local function allowed_index(i)
		return i and not table.contains(self._waiting_index, i)
	end

	local peer = managers.network:session():peer(peer_id)
	local data = peer and managers.criminals:character_data_by_name(peer:character())

	if data and allowed_index(data.panel_id) then
		return set_index(data.panel_id)
	end

	for i, data in ipairs(self._hud.teammate_panels_data) do
		if not data.taken and i ~= HUDManager.PLAYER_PANEL and allowed_index(i) then
			return set_index(i)
		end
	end

	for i, panel in ipairs(self._teammate_panels) do
		if panel._ai and allowed_index(i) then
			return set_index(i)
		end
	end

	return nil
end

-- Lines 229-246
function HUDManager:add_waiting(peer_id, override_index)
	if not Network:is_server() then
		return
	end

	local peer = managers.network:session():peer(peer_id)

	if override_index then
		self._waiting_index[peer_id] = override_index
	end

	local index = self:get_waiting_index(peer_id)
	local panel = self._teammate_panels[index]

	if panel and peer then
		panel:set_waiting(true, peer)

		local _ = not self._waiting_legend:is_set() and self._waiting_legend:show_on(panel, peer)
	end
end

-- Lines 248-269
function HUDManager:remove_waiting(peer_id)
	if not Network:is_server() then
		return
	end

	local index = self:get_waiting_index(peer_id)
	self._waiting_index[peer_id] = nil
	local _ = self._teammate_panels[index] and self._teammate_panels[index]:set_waiting(false)

	if self._waiting_legend:peer() and peer_id == self._waiting_legend:peer():id() then
		self._waiting_legend:turn_off()

		for id, index in pairs(self._waiting_index) do
			local panel = self._teammate_panels[index]
			local peer = managers.network:session():peer(id)

			if panel then
				self._waiting_legend:show_on(panel, peer)

				break
			end
		end
	end
end

-- Lines 276-278
function HUDManager:set_teammate_weapon_firemode(i, id, firemode)
	self._teammate_panels[i]:set_weapon_firemode(id, firemode)
end

-- Lines 281-304
function HUDManager:set_ammo_amount(selection_index, max_clip, current_clip, current_left, max)
	if selection_index > 4 then
		print("set_ammo_amount", selection_index, max_clip, current_clip, current_left, max)
		Application:stack_dump()
		debug_pause("WRONG SELECTION INDEX!")
	end

	managers.player:update_synced_ammo_info_to_peers(selection_index, max_clip, current_clip, current_left, max)
	self:set_teammate_ammo_amount(HUDManager.PLAYER_PANEL, selection_index, max_clip, current_clip, current_left, max)

	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)

	if hud.panel:child("ammo_test") then
		local panel = hud.panel:child("ammo_test")
		local ammo_rect = panel:child("ammo_test_rect")

		ammo_rect:set_w(panel:w() * current_clip / max_clip)
		ammo_rect:set_center_x(panel:w() / 2)
		panel:stop()
		panel:animate(callback(self, self, "_animate_ammo_test"))
	end
end

-- Lines 307-314
function HUDManager:set_teammate_ammo_amount(id, selection_index, max_clip, current_clip, current_left, max)
	selection_index = (tonumber(selection_index) - 1) % 2 + 1
	local type = selection_index == 1 and "secondary" or "primary"

	self._teammate_panels[id]:set_ammo_amount_by_type(type, max_clip, current_clip, current_left, max)
end

-- Lines 317-322
function HUDManager:set_weapon_ammo_by_unit(unit)
	local second_weapon_index = self._hud.selected_weapon == 1 and 2 or 1

	if second_weapon_index == unit:base():weapon_tweak_data().use_data.selection_index then
		self:_update_second_weapon_ammo_info(HUDManager.PLAYER_PANEL, unit)
	end
end

-- Lines 325-327
function HUDManager:_update_second_weapon_ammo_info(i, unit)
end

-- Lines 329-331
function HUDManager:damage_taken()
	self._teammate_panels[HUDManager.PLAYER_PANEL]:_damage_taken()
end

-- Lines 334-336
function HUDManager:set_player_health(data)
	self:set_teammate_health(HUDManager.PLAYER_PANEL, data)
end

-- Lines 338-340
function HUDManager:set_teammate_health(i, data)
	self._teammate_panels[i]:set_health(data)
end

-- Lines 342-344
function HUDManager:set_player_custom_radial(data)
	self:set_teammate_custom_radial(HUDManager.PLAYER_PANEL, data)
end

-- Lines 345-347
function HUDManager:set_teammate_custom_radial(i, data)
	self._teammate_panels[i]:set_custom_radial(data)
end

-- Lines 349-351
function HUDManager:set_player_ability_radial(data)
	self:set_teammate_ability_radial(HUDManager.PLAYER_PANEL, data)
end

-- Lines 353-355
function HUDManager:set_teammate_ability_radial(i, data)
	self._teammate_panels[i]:set_ability_radial(data)
end

-- Lines 357-359
function HUDManager:activate_teammate_ability_radial(i, time_left, time_total)
	self._teammate_panels[i]:activate_ability_radial(time_left, time_total)
end

-- Lines 362-364
function HUDManager:set_teammate_delayed_damage(i, delayed_damage)
	self._teammate_panels[i]:set_delayed_damage(delayed_damage)
end

-- Lines 368-374
function HUDManager:set_player_armor(data)
	if data.current == 0 and not data.no_hint then
		managers.hint:show_hint("damage_pad")
	end

	self:set_teammate_armor(HUDManager.PLAYER_PANEL, data)
end

-- Lines 377-379
function HUDManager:set_teammate_armor(i, data)
	self._teammate_panels[i]:set_armor(data)
end

-- Lines 382-384
function HUDManager:set_teammate_name(i, teammate_name)
	self._teammate_panels[i]:set_name(teammate_name)
end

-- Lines 387-389
function HUDManager:set_teammate_callsign(i, id)
	self._teammate_panels[i]:set_callsign(id)
end

-- Lines 392-394
function HUDManager:set_cable_tie(i, data)
	self._teammate_panels[i]:set_cable_tie(data)
end

-- Lines 397-399
function HUDManager:set_cable_ties_amount(i, amount)
	self._teammate_panels[i]:set_cable_ties_amount(amount)
end

-- Lines 402-410
function HUDManager:set_teammate_state(i, state)
	if state == "player" then
		self:set_ai_stopped(i, false)
	end

	self._teammate_panels[i]:set_state(state)
end

-- Lines 413-415
function HUDManager:add_special_equipment(data)
	self:add_teammate_special_equipment(HUDManager.PLAYER_PANEL, data)
end

-- Lines 418-426
function HUDManager:add_teammate_special_equipment(i, data)
	if not i then
		print("[HUDManager:add_teammate_special_equipment] - Didn't get a number")
		Application:stack_dump()

		return
	end

	self._teammate_panels[i]:add_special_equipment(data)
end

-- Lines 429-431
function HUDManager:remove_special_equipment(equipment)
	self:remove_teammate_special_equipment(HUDManager.PLAYER_PANEL, equipment)
end

-- Lines 434-436
function HUDManager:remove_teammate_special_equipment(panel_id, equipment)
	self._teammate_panels[panel_id]:remove_special_equipment(equipment)
end

-- Lines 439-441
function HUDManager:set_special_equipment_amount(equipment_id, amount)
	self:set_teammate_special_equipment_amount(HUDManager.PLAYER_PANEL, equipment_id, amount)
end

-- Lines 444-446
function HUDManager:set_teammate_special_equipment_amount(i, equipment_id, amount)
	self._teammate_panels[i]:set_special_equipment_amount(equipment_id, amount)
end

-- Lines 448-453
function HUDManager:clear_player_special_equipments()
	if not self._teammate_panels then
		return
	end

	self._teammate_panels[HUDManager.PLAYER_PANEL]:clear_special_equipment()
end

-- Lines 456-458
function HUDManager:set_stored_health(stored_health_ratio)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_stored_health(stored_health_ratio)
end

-- Lines 460-462
function HUDManager:set_stored_health_max(stored_health_ratio)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_stored_health_max(stored_health_ratio)
end

-- Lines 471-473
function HUDManager:set_info_meter(i, data)
	self._teammate_panels[i or HUDManager.PLAYER_PANEL]:set_info_meter(data)
end

-- Lines 483-485
function HUDManager:set_absorb_active(i, absorb_amount)
	self._teammate_panels[i or HUDManager.PLAYER_PANEL]:set_absorb_active(absorb_amount)
end

-- Lines 523-525
function HUDManager:add_item(data)
	self:set_deployable_equipment(HUDManager.PLAYER_PANEL, data)
end

-- Lines 527-529
function HUDManager:add_item_from_string(data)
	self:set_deployable_equipment_from_string(HUDManager.PLAYER_PANEL, data)
end

-- Lines 532-534
function HUDManager:set_deployable_equipment(i, data)
	self._teammate_panels[i]:set_deployable_equipment(data)
end

-- Lines 536-538
function HUDManager:set_deployable_equipment_from_string(i, data)
	self._teammate_panels[i]:set_deployable_equipment_from_string(data)
end

-- Lines 541-543
function HUDManager:set_item_amount(index, amount)
	self:set_teammate_deployable_equipment_amount(HUDManager.PLAYER_PANEL, index, {
		amount = amount
	})
end

-- Lines 546-548
function HUDManager:set_item_amount_from_string(index, amount_str, amount)
	self:set_teammate_deployable_equipment_amount_from_string(HUDManager.PLAYER_PANEL, index, {
		amount_str = amount_str,
		amount = amount
	})
end

-- Lines 551-553
function HUDManager:set_teammate_deployable_equipment_amount(i, index, data)
	self._teammate_panels[i]:set_deployable_equipment_amount(index, data)
end

-- Lines 555-557
function HUDManager:set_teammate_deployable_equipment_amount_from_string(i, index, data)
	self._teammate_panels[i]:set_deployable_equipment_amount_from_string(index, data)
end

-- Lines 559-561
function HUDManager:set_player_grenade_cooldown(data)
	self:set_teammate_grenade_cooldown(HUDManager.PLAYER_PANEL, data)
end

-- Lines 563-565
function HUDManager:set_teammate_grenade_cooldown(i, data)
	self._teammate_panels[i]:set_grenade_cooldown(data)
end

-- Lines 567-569
function HUDManager:set_ability_icon(i, icon)
	self._teammate_panels[i]:set_ability_icon(icon)
end

-- Lines 572-575
function HUDManager:set_teammate_grenades(i, data)
	self._teammate_panels[i]:set_grenades(data)
	self:set_ability_icon(i, data.icon)
end

-- Lines 578-581
function HUDManager:set_teammate_grenades_amount(i, data)
	self._teammate_panels[i]:set_grenades_amount(data)
end

-- Lines 583-585
function HUDManager:animate_grenade_flash(i)
	self._teammate_panels[i]:animate_grenade_flash()
end

-- Lines 587-589
function HUDManager:set_player_condition(icon_data, text)
	self:set_teammate_condition(HUDManager.PLAYER_PANEL, icon_data, text)
end

-- Lines 592-600
function HUDManager:set_teammate_condition(i, icon_data, text)
	if not i then
		print("Didn't get a number")
		Application:stack_dump()

		return
	end

	self._teammate_panels[i]:set_condition(icon_data, text)
end

-- Lines 602-607
function HUDManager:set_teammate_carry_info(i, carry_id, value)
	if i == HUDManager.PLAYER_PANEL then
		return
	end

	self._teammate_panels[i]:set_carry_info(carry_id, value)
end

-- Lines 609-614
function HUDManager:remove_teammate_carry_info(i)
	if i == HUDManager.PLAYER_PANEL then
		return
	end

	self._teammate_panels[i]:remove_carry_info()
end

-- Lines 618-622
function HUDManager:start_teammate_timer(i, time)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:start_timer(time)
	end
end

-- Lines 624-630
function HUDManager:is_teammate_timer_running(i)
	if self._teammate_panels[i] then
		return self._teammate_panels[i]:is_timer_running()
	else
		return false
	end
end

-- Lines 632-636
function HUDManager:pause_teammate_timer(i, pause)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:set_pause_timer(pause)
	end
end

-- Lines 638-642
function HUDManager:stop_teammate_timer(i)
	if self._teammate_panels[i] then
		self._teammate_panels[i]:stop_timer()
	end
end

-- Lines 646-681
function HUDManager:_setup_player_info_hud_pd2()
	print("_setup_player_info_hud_pd2")

	if not self:alive(PlayerBase.PLAYER_INFO_HUD_PD2) then
		return
	end

	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)

	self:_create_teammates_panel(hud)
	self:_create_present_panel(hud)
	self:_create_interaction(hud)
	self:_create_progress_timer(hud)
	self:_create_objectives(hud)
	self:_create_hint(hud)
	self:_create_heist_timer(hud)
	self:_create_temp_hud(hud)
	self:_create_suspicion(hud)
	self:_create_hit_confirm(hud)
	self:_create_hit_direction(hud)
	self:_create_downed_hud()
	self:_create_custody_hud()
	self:_create_hud_chat()
	self:_create_assault_corner()
	self:_create_waiting_legend(hud)
end

-- Lines 683-694
function HUDManager:_create_ammo_test()
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)

	if hud.panel:child("ammo_test") then
		hud.panel:remove(hud.panel:child("ammo_test"))
	end

	local panel = hud.panel:panel({
		name = "ammo_test",
		h = 4,
		y = 200,
		w = 100,
		x = 550
	})

	panel:set_center_y(hud.panel:h() / 2 - 40)
	panel:set_center_x(hud.panel:w() / 2)
	panel:rect({
		name = "ammo_test_bg_rect",
		color = Color.black:with_alpha(0.5)
	})
	panel:rect({
		name = "ammo_test_rect",
		layer = 1,
		color = Color.white
	})
end

-- Lines 696-711
function HUDManager:_create_hud_chat()
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)

	if self._hud_chat_ingame then
		self._hud_chat_ingame:remove()
	end

	self._hud_chat_ingame = HUDChat:new(self._saferect, hud)
	self._hud_chat = self._hud_chat_ingame

	if not _G.IS_VR then
		self:_create_hud_chat_access()
	end
end

-- Lines 713-719
function HUDManager:_create_hud_chat_access()
	local hud = managers.hud:script(IngameAccessCamera.GUI_SAFERECT)

	if self._hud_chat_access then
		self._hud_chat_access:remove()
	end

	self._hud_chat_access = HUDChat:new(self._saferect, hud)
end

-- Lines 722-729
function HUDManager:_create_assault_corner()
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)

	full_hud.panel:clear()

	self._hud_assault_corner = HUDAssaultCorner:new(hud, full_hud, tweak_data.levels[Global.game_settings.level_id].hud or {})
end

-- Lines 731-743
function HUDManager:mark_cheater(peer_id)
	local name_label = self:_name_label_by_peer_id(peer_id)

	if name_label then
		name_label.panel:child("cheater"):set_visible(true)
	end

	for i, data in ipairs(self._hud.teammate_panels_data) do
		if self._teammate_panels[i]:peer_id() == peer_id then
			self._teammate_panels[i]:set_cheater(true)

			break
		end
	end
end

-- Lines 746-827
function HUDManager:add_teammate_panel(character_name, player_name, ai, peer_id)
	-- Lines 747-810
	local function add_panel(i)
		self._teammate_panels[i]:add_panel()
		self._teammate_panels[i]:set_peer_id(peer_id)
		self._teammate_panels[i]:set_ai(ai)
		self:set_teammate_callsign(i, ai and tweak_data.max_players + 1 or peer_id)
		self:set_teammate_name(i, player_name)
		self:set_teammate_state(i, ai and "ai" or "player")

		local synced_cocaine_stacks = managers.player:get_synced_cocaine_stacks(peer_id)

		if synced_cocaine_stacks and synced_cocaine_stacks.in_use then
			self:set_info_meter(i, {
				icon = "guis/dlcs/coco/textures/pd2/hud_absorb_stack_icon_01",
				max = 1,
				current = managers.player:get_peer_cocaine_damage_absorption_ratio(peer_id),
				total = managers.player:get_peer_cocaine_damage_absorption_max_ratio(peer_id)
			})
		end

		if peer_id then
			local peer_equipment = managers.player:get_synced_equipment_possession(peer_id) or {}

			for equipment, amount in pairs(peer_equipment) do
				self:add_teammate_special_equipment(i, {
					id = equipment,
					icon = tweak_data.equipments.specials[equipment].icon,
					amount = amount
				})
			end

			local peer_deployable_equipment = managers.player:get_synced_deployable_equipment(peer_id)

			if peer_deployable_equipment then
				local icon = tweak_data.equipments[peer_deployable_equipment.deployable].icon

				self:set_deployable_equipment(i, {
					icon = icon,
					amount = peer_deployable_equipment.amount
				})
			end

			local peer_cable_ties = managers.player:get_synced_cable_ties(peer_id)

			if peer_cable_ties then
				local icon = tweak_data.equipments.specials.cable_tie.icon

				self:set_cable_tie(i, {
					icon = icon,
					amount = peer_cable_ties.amount
				})
			end

			local peer_grenades = managers.player:get_synced_grenades(peer_id)

			if peer_grenades then
				local grenades_tweak = tweak_data.blackmarket.projectiles[peer_grenades.grenade]
				local icon = grenades_tweak.icon

				self:set_teammate_grenades(i, {
					icon = icon,
					amount = Application:digest_value(peer_grenades.amount, false)
				})
			end
		end

		local unit = managers.criminals:character_unit_by_name(character_name)

		if alive(unit) then
			local weapon = unit:inventory():equipped_unit()

			if alive(weapon) then
				local icon = weapon:base():weapon_tweak_data().hud_icon
				local equipped_selection = unit:inventory():equipped_selection()

				self:_set_teammate_weapon_selected(i, equipped_selection, icon)
			end
		end

		local peer_ammo_info = managers.player:get_synced_ammo_info(peer_id)

		if peer_ammo_info then
			for selection_index, ammo_info in pairs(peer_ammo_info) do
				self:set_teammate_ammo_amount(i, selection_index, unpack(ammo_info))
			end
		end

		local peer_carry_data = managers.player:get_synced_carry(peer_id)

		if peer_carry_data then
			self:set_teammate_carry_info(i, peer_carry_data.carry_id, managers.loot:get_real_value(peer_carry_data.carry_id, peer_carry_data.multiplier))
		end

		self._hud.teammate_panels_data[i].taken = true

		return i
	end

	local index = self._waiting_index[peer_id]

	if index and not self._hud.teammate_panels_data[index].taken then
		add_panel(index)
	end

	if self._waiting_index and peer_id then
		self._waiting_index[peer_id] = nil
	end

	for i, data in ipairs(self._hud.teammate_panels_data) do
		if not data.taken then
			return add_panel(i)
		end
	end
end

-- Lines 830-865
function HUDManager:remove_teammate_panel(id)
	self._teammate_panels[id]:remove_panel()

	local panel_data = self._hud.teammate_panels_data[id]
	panel_data.taken = false
	local is_ai = self._teammate_panels[HUDManager.PLAYER_PANEL]._ai

	if self._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id and self._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id ~= managers.network:session():local_peer():id() or is_ai then
		print(" MOVE!!!", self._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id, is_ai)

		local peer_id = self._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id

		self:remove_teammate_panel(HUDManager.PLAYER_PANEL)

		if is_ai then
			local character_name = managers.criminals:character_name_by_panel_id(HUDManager.PLAYER_PANEL)
			local name = managers.localization:text("menu_" .. character_name)
			local panel_id = self:add_teammate_panel(character_name, name, true, nil)
			managers.criminals:character_data_by_name(character_name).panel_id = panel_id
		else
			local character_name = managers.criminals:character_name_by_peer_id(peer_id)
			local panel_id = self:add_teammate_panel(character_name, managers.network:session():peer(peer_id):name(), false, peer_id)
			managers.criminals:character_data_by_name(character_name).panel_id = panel_id
		end
	end

	managers.hud._teammate_panels[HUDManager.PLAYER_PANEL]:add_panel()
	managers.hud._teammate_panels[HUDManager.PLAYER_PANEL]:set_state("player")
end

-- Lines 867-878
function HUDManager:get_teammate_panel_by_peer(peer)
	if not peer then
		return self._teammate_panels[HUDManager.PLAYER_PANEL]
	end

	for i, teammate_panel in ipairs(self._teammate_panels) do
		local is_player_panel = i == HUDManager.PLAYER_PANEL

		if teammate_panel:peer_id() == peer:id() and not is_player_panel then
			return teammate_panel
		end
	end
end

-- Lines 966-968
function HUDManager:teampanels_height()
	return 120
end

-- Lines 970-1011
function HUDManager:_create_teammates_panel(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud.teammate_panels_data = self._hud.teammate_panels_data or {}
	self._teammate_panels = {}

	if hud.panel:child("teammates_panel") then
		hud.panel:remove(hud.panel:child("teammates_panel"))
	end

	local h = self:teampanels_height()
	local teammates_panel = hud.panel:panel({
		halign = "grow",
		name = "teammates_panel",
		valign = "bottom",
		h = h,
		y = hud.panel:h() - h
	})
	local teammate_w = 204
	local player_gap = 240
	local small_gap = (teammates_panel:w() - player_gap - teammate_w * 4) / 3

	for i = 1, 4 do
		local is_player = i == HUDManager.PLAYER_PANEL
		self._hud.teammate_panels_data[i] = {
			taken = false and is_player,
			special_equipments = {}
		}
		local pw = teammate_w + (is_player and 0 or 64)
		local teammate = HUDTeammate:new(i, teammates_panel, is_player, pw)

		if not _G.IS_VR then
			local x = math.floor((pw + small_gap) * (i - 1) + (i == HUDManager.PLAYER_PANEL and player_gap or 0))

			teammate._panel:set_x(math.floor(x))
		end

		table.insert(self._teammate_panels, teammate)
	end
end

-- Lines 1014-1018
function HUDManager:_create_waiting_legend(hud)
	if Network:is_server() then
		self._waiting_legend = HUDWaitingLegend:new(hud)
	end
end

-- Lines 1023-1026
function HUDManager:_create_present_panel(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_presenter = HUDPresenter:new(hud)
end

-- Lines 1029-1033
function HUDManager:present(params)
	if self._hud_presenter then
		self._hud_presenter:present(params)
	end
end

-- Lines 1036-1037
function HUDManager:present_done()
end

-- Lines 1041-1044
function HUDManager:_create_interaction(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_interaction = HUDInteraction:new(hud)
end

-- Lines 1047-1049
function HUDManager:show_interact(data)
	self._hud_interaction:show_interact(data)
end

-- Lines 1052-1057
function HUDManager:remove_interact()
	if not self._hud_interaction then
		return
	end

	self._hud_interaction:remove_interact()
end

-- Lines 1060-1062
function HUDManager:show_interaction_bar(current, total)
	self._hud_interaction:show_interaction_bar(current, total)
end

-- Lines 1065-1067
function HUDManager:set_interaction_bar_width(current, total)
	self._hud_interaction:set_interaction_bar_width(current, total)
end

-- Lines 1070-1072
function HUDManager:hide_interaction_bar(complete)
	self._hud_interaction:hide_interaction_bar(complete)
end

-- Lines 1076-1079
function HUDManager:_create_progress_timer(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._progress_timer = HUDInteraction:new(hud, "progress_timer")
end

-- Lines 1081-1083
function HUDManager:show_progress_timer(data)
	self._progress_timer:show_interact(data)
end

-- Lines 1085-1087
function HUDManager:remove_progress_timer()
	self._progress_timer:remove_interact()
end

-- Lines 1089-1091
function HUDManager:show_progress_timer_bar(current, total)
	self._progress_timer:show_interaction_bar(current, total)
end

-- Lines 1093-1095
function HUDManager:set_progress_timer_bar_width(current, total)
	self._progress_timer:set_interaction_bar_width(current, total)
end

-- Lines 1097-1099
function HUDManager:set_progress_timer_bar_valid(valid, text_id)
	self._progress_timer:set_bar_valid(valid, text_id)
end

-- Lines 1101-1103
function HUDManager:hide_progress_timer_bar(complete)
	self._progress_timer:hide_interaction_bar(complete)
end

-- Lines 1108-1110
function HUDManager:set_control_info(data)
	self._hud_assault_corner:set_control_info(data)
end

-- Lines 1115-1127
function HUDManager:sync_start_assault(assault_number)
	managers.music:post_event(tweak_data.levels:get_music_event("assault"))

	if not managers.groupai:state():get_hunt_mode() then
		managers.dialog:queue_narrator_dialog("b02c", {})
	end

	self._hud_assault_corner:sync_start_assault(assault_number)
end

-- Lines 1130-1145
function HUDManager:sync_end_assault(result)
	managers.music:post_event(tweak_data.levels:get_music_event("control"))

	local result_diag = {
		"b12",
		"b11",
		"b10"
	}

	if result then
		managers.dialog:queue_narrator_dialog(result_diag[result + 1], {})
	end

	self._hud_assault_corner:sync_end_assault(result)
end

-- Lines 1147-1151
function HUDManager:sync_assault_number(assault_number)
	self._hud_assault_corner:sync_start_assault(assault_number)
end

-- Lines 1153-1155
function HUDManager:show_casing(mode)
	self._hud_assault_corner:show_casing(mode)
end

-- Lines 1157-1159
function HUDManager:hide_casing()
	self._hud_assault_corner:hide_casing()
end

-- Lines 1161-1163
function HUDManager:sync_set_assault_mode(mode)
	self._hud_assault_corner:sync_set_assault_mode(mode)
end

-- Lines 1165-1167
function HUDManager:set_buff_enabled(buff_name, enabled)
	self._hud_assault_corner:set_buff_enabled(buff_name, enabled)
end

-- Lines 1171-1173
function HUDManager:_additional_layout()
	self:_setup_stats_screen()
end

-- Lines 1175-1189
function HUDManager:_setup_stats_screen()
	if not self:alive(self.STATS_SCREEN_FULLSCREEN) then
		return
	end

	local stats_screen_class = HUDStatsScreen

	if managers.skirmish:is_skirmish() then
		stats_screen_class = HUDStatsScreenSkirmish
	end

	self._hud_statsscreen = stats_screen_class:new()
end

-- Lines 1192-1206
function HUDManager:show_stats_screen()
	local safe = self.STATS_SCREEN_SAFERECT
	local full = self.STATS_SCREEN_FULLSCREEN

	if not self:exists(safe) then
		self:load_hud(full, false, true, false, {})
		self:load_hud(safe, false, true, true, {})
	end

	self._hud_statsscreen:show()

	self._showing_stats_screen = true

	self:add_updator("_hud_statsscreen", callback(self._hud_statsscreen, self._hud_statsscreen, "update"))
end

-- Lines 1209-1214
function HUDManager:update_stat_screen()
	if not self._hud_statsscreen then
		return
	end

	self._hud_statsscreen:update()
end

-- Lines 1218-1226
function HUDManager:hide_stats_screen()
	self._showing_stats_screen = false

	if self._hud_statsscreen then
		self._hud_statsscreen:hide()
	end

	self:remove_updator("_hud_statsscreen")
end

-- Lines 1228-1230
function HUDManager:showing_stats_screen()
	return self._showing_stats_screen
end

-- Lines 1232-1236
function HUDManager:loot_value_updated()
	if self._hud_statsscreen then
		self._hud_statsscreen:loot_value_updated()
	end
end

-- Lines 1238-1242
function HUDManager:on_ext_inventory_changed()
	if self._hud_statsscreen then
		self._hud_statsscreen:on_ext_inventory_changed()
	end
end

-- Lines 1247-1249
function HUDManager:feed_point_of_no_return_timer(time, is_inside)
	self._hud_assault_corner:feed_point_of_no_return_timer(time, is_inside)
end

-- Lines 1252-1254
function HUDManager:show_point_of_no_return_timer(tweak_id)
	self._hud_assault_corner:show_point_of_no_return_timer(tweak_id)
end

-- Lines 1257-1259
function HUDManager:hide_point_of_no_return_timer()
	self._hud_assault_corner:hide_point_of_no_return_timer()
end

-- Lines 1262-1270
function HUDManager:flash_point_of_no_return_timer(beep)
	if beep then
		self._sound_source:post_event("last_10_seconds_beep")
	end

	self._hud_assault_corner:flash_point_of_no_return_timer(beep)
end

-- Lines 1274-1277
function HUDManager:_create_objectives(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_objectives = HUDObjectives:new(hud)
end

-- Lines 1281-1284
function HUDManager:activate_objective(data)
	self._hud_objectives:activate_objective(data)
end

-- Lines 1287-1290
function HUDManager:complete_sub_objective(data)
end

-- Lines 1293-1296
function HUDManager:update_amount_objective(data)
	print("HUDManager:update_amount_objective", inspect(data))
	self._hud_objectives:update_amount_objective(data)
end

-- Lines 1299-1301
function HUDManager:remind_objective(id)
	self._hud_objectives:remind_objective(id)
end

-- Lines 1304-1307
function HUDManager:complete_objective(data)
	self._hud_objectives:complete_objective(data)
end

-- Lines 1311-1314
function HUDManager:_create_hint(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_hint = HUDHint:new(hud)
end

-- Lines 1317-1323
function HUDManager:show_hint(params)
	self._hud_hint:show(params)

	if params.event then
		self._sound_source:post_event(params.event)
	end
end

-- Lines 1325-1327
function HUDManager:stop_hint()
	self._hud_hint:stop()
end

-- Lines 1331-1334
function HUDManager:_create_heist_timer(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_heist_timer = HUDHeistTimer:new(hud, tweak_data.levels[Global.game_settings.level_id].hud or {})
end

-- Lines 1336-1338
function HUDManager:feed_heist_time(time)
	self._hud_heist_timer:set_time(time)
end

-- Lines 1340-1342
function HUDManager:modify_heist_time(time)
	self._hud_heist_timer:modify_time(time)
end

-- Lines 1382-1385
function HUDManager:_create_temp_hud(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_temp = HUDTemp:new(hud)
end

-- Lines 1387-1389
function HUDManager:temp_show_carry_bag(carry_id, value)
	self._hud_temp:show_carry_bag(carry_id, value)
end

-- Lines 1391-1393
function HUDManager:temp_hide_carry_bag()
	self._hud_temp:hide_carry_bag()
end

-- Lines 1395-1397
function HUDManager:set_stamina_value(value)
	self._hud_temp:set_stamina_value(value)
end

-- Lines 1399-1401
function HUDManager:set_max_stamina(value)
	self._hud_temp:set_max_stamina(value)
end

-- Lines 1405-1408
function HUDManager:_create_suspicion(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_suspicion = HUDSuspicion:new(hud, self._sound_source)
end

-- Lines 1411-1422
function HUDManager:set_suspicion(status)
	if type(status) == "boolean" then
		if status then
			self._hud_suspicion:feed_value(1)
			self._hud_suspicion:discovered()
		else
			self._hud_suspicion:back_to_stealth()
		end
	else
		self._hud_suspicion:feed_value(status)
	end
end

-- Lines 1426-1429
function HUDManager:_create_hit_confirm(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_hit_confirm = HUDHitConfirm:new(hud)
end

-- Lines 1431-1436
function HUDManager:on_hit_confirmed(damage_scale)
	if not managers.user:get_setting("hit_indicator") then
		return
	end

	self._hud_hit_confirm:on_hit_confirmed(damage_scale)
end

-- Lines 1438-1443
function HUDManager:on_headshot_confirmed(damage_scale)
	if not managers.user:get_setting("hit_indicator") then
		return
	end

	self._hud_hit_confirm:on_headshot_confirmed(damage_scale)
end

-- Lines 1445-1450
function HUDManager:on_crit_confirmed(damage_scale)
	if not managers.user:get_setting("hit_indicator") then
		return
	end

	self._hud_hit_confirm:on_crit_confirmed(damage_scale)
end

-- Lines 1454-1457
function HUDManager:_create_hit_direction(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._hud_hit_direction = HUDHitDirection:new(hud)
end

-- Lines 1459-1461
function HUDManager:on_hit_direction(dir, unit_type_hit, fixed_angle)
	self._hud_hit_direction:on_hit_direction(dir, unit_type_hit, fixed_angle)
end

-- Lines 1465-1468
function HUDManager:_create_downed_hud(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
	self._hud_player_downed = HUDPlayerDowned:new(hud)
end

-- Lines 1470-1472
function HUDManager:on_downed()
	self._hud_player_downed:on_downed()
end

-- Lines 1474-1476
function HUDManager:on_arrested()
	self._hud_player_downed:on_arrested()
end

-- Lines 1480-1483
function HUDManager:_create_custody_hud(hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_CUSTODY_HUD)
	self._hud_player_custody = HUDPlayerCustody:new(hud)
end

-- Lines 1485-1487
function HUDManager:set_custody_respawn_time(time)
	self._hud_player_custody:set_respawn_time(time)
end

-- Lines 1489-1491
function HUDManager:set_custody_timer_visibility(visible)
	self._hud_player_custody:set_timer_visibility(visible)
end

-- Lines 1493-1495
function HUDManager:set_custody_civilians_killed(amount)
	self._hud_player_custody:set_civilians_killed(amount)
end

-- Lines 1497-1499
function HUDManager:set_custody_trade_delay(time)
	self._hud_player_custody:set_trade_delay(time)
end

-- Lines 1501-1503
function HUDManager:set_custody_trade_delay_visible(visible)
	self._hud_player_custody:set_trade_delay_visible(visible)
end

-- Lines 1505-1507
function HUDManager:set_custody_negotiating_visible(visible)
	self._hud_player_custody:set_negotiating_visible(visible)
end

-- Lines 1509-1511
function HUDManager:set_custody_can_be_trade_visible(visible)
	self._hud_player_custody:set_can_be_trade_visible(visible)
end

-- Lines 1515-1564
function HUDManager:align_teammate_name_label(panel, interact)
	local double_radius = interact:radius() * 2
	local text = panel:child("text")
	local action = panel:child("action")
	local bag = panel:child("bag")
	local bag_number = panel:child("bag_number")
	local cheater = panel:child("cheater")
	local _, _, tw, th = text:text_rect()
	local _, _, aw, ah = action:text_rect()
	local _, _, cw, ch = cheater:text_rect()

	panel:set_size(math.max(tw, cw) + 4 + double_radius, math.max(th + ah + ch, double_radius))
	text:set_size(panel:w(), th)
	action:set_size(panel:w(), ah)
	cheater:set_size(tw, ch)
	text:set_x(double_radius + 4)
	action:set_x(double_radius + 4)
	cheater:set_x(double_radius + 4)
	text:set_top(cheater:bottom())
	action:set_top(text:bottom())
	bag:set_top(text:top() + 4)
	interact:set_position(0, text:top())

	local infamy = panel:child("infamy")

	if infamy then
		panel:set_w(panel:w() + infamy:w())
		text:set_size(panel:size())
		infamy:set_x(double_radius + 4)
		infamy:set_top(text:top() + 4)
		text:set_x(double_radius + 4 + infamy:w())
	end

	if bag_number then
		bag_number:set_bottom(text:bottom() - 1)
		panel:set_w(panel:w() + bag_number:w() + bag:w() + 8)
		bag:set_right(panel:w() - bag_number:w())
		bag_number:set_right(panel:w() + 2)
	else
		panel:set_w(panel:w() + bag:w() + 4)
		bag:set_right(panel:w())
	end
end

-- Lines 1569-1635
function HUDManager:_add_name_label(data)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	local last_id = self._hud.name_labels[#self._hud.name_labels] and self._hud.name_labels[#self._hud.name_labels].id or 0
	local id = last_id + 1
	local character_name = data.name
	local rank = 0
	local peer_id = nil
	local is_husk_player = data.unit:base().is_husk_player

	if is_husk_player then
		peer_id = data.unit:network():peer():id()
		local level = data.unit:network():peer():level()
		rank = data.unit:network():peer():rank()

		if level then
			local color_range_offset = utf8.len(data.name) + 2
			local experience, color_ranges = managers.experience:gui_string(level, rank, color_range_offset)
			data.name_color_ranges = color_ranges
			data.name = data.name .. " (" .. experience .. ")"
		end
	end

	local panel = hud.panel:panel({
		name = "name_label" .. id
	})
	local radius = 24
	local interact = CircleBitmapGuiObject:new(panel, {
		blend_mode = "add",
		use_bg = true,
		layer = 0,
		radius = radius,
		color = Color.white
	})

	interact:set_visible(false)

	local tabs_texture = "guis/textures/pd2/hud_tabs"
	local bag_rect = {
		2,
		34,
		20,
		17
	}
	local color_id = managers.criminals:character_color_id_by_unit(data.unit)
	local crim_color = tweak_data.chat_colors[color_id] or tweak_data.chat_colors[#tweak_data.chat_colors]
	local text = panel:text({
		name = "text",
		vertical = "top",
		h = 18,
		w = 256,
		align = "left",
		layer = -1,
		text = data.name,
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.name_label_font_size,
		color = crim_color
	})
	local bag = panel:bitmap({
		name = "bag",
		layer = 0,
		visible = false,
		y = 1,
		x = 1,
		texture = tabs_texture,
		texture_rect = bag_rect,
		color = (crim_color * 1.1):with_alpha(1)
	})

	panel:text({
		w = 256,
		name = "cheater",
		h = 18,
		align = "center",
		visible = false,
		layer = -1,
		text = utf8.to_upper(managers.localization:text("menu_hud_cheater")),
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.name_label_font_size,
		color = tweak_data.screen_colors.pro_color
	})
	panel:text({
		vertical = "bottom",
		name = "action",
		h = 18,
		w = 256,
		align = "left",
		visible = false,
		rotation = 360,
		layer = -1,
		text = utf8.to_upper("Fixing"),
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.name_label_font_size,
		color = (crim_color * 1.1):with_alpha(1)
	})

	if rank > 0 then
		local texture, texture_rect = managers.experience:rank_icon_data(rank)

		panel:bitmap({
			name = "infamy",
			h = 16,
			layer = 0,
			w = 16,
			texture = texture,
			texture_rect = texture_rect,
			color = crim_color
		})
	end

	for _, color_range in ipairs(data.name_color_ranges or {}) do
		text:set_range_color(color_range.start, color_range.stop, color_range.color)
	end

	self:align_teammate_name_label(panel, interact)
	table.insert(self._hud.name_labels, {
		movement = data.unit:movement(),
		panel = panel,
		text = text,
		id = id,
		peer_id = peer_id,
		character_name = character_name,
		interact = interact,
		bag = bag
	})

	return id
end

-- Lines 1637-1677
function HUDManager:add_vehicle_name_label(data)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	local last_id = self._hud.name_labels[#self._hud.name_labels] and self._hud.name_labels[#self._hud.name_labels].id or 0
	local id = last_id + 1
	local vehicle_name = data.name
	local panel = hud.panel:panel({
		name = "name_label" .. id
	})
	local radius = 24
	local interact = CircleBitmapGuiObject:new(panel, {
		blend_mode = "add",
		use_bg = true,
		layer = 0,
		radius = radius,
		color = Color.white
	})

	interact:set_visible(false)

	local tabs_texture = "guis/textures/pd2/hud_tabs"
	local bag_rect = {
		2,
		34,
		20,
		17
	}
	local crim_color = tweak_data.chat_colors[1]
	local text = panel:text({
		name = "text",
		vertical = "top",
		h = 18,
		w = 256,
		align = "left",
		layer = -1,
		text = utf8.to_upper(data.name),
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.name_label_font_size,
		color = crim_color
	})
	local bag = panel:bitmap({
		name = "bag",
		layer = 0,
		visible = false,
		y = 1,
		x = 1,
		texture = tabs_texture,
		texture_rect = bag_rect,
		color = (crim_color * 1.1):with_alpha(1)
	})
	local bag_number = panel:text({
		name = "bag_number",
		vertical = "top",
		h = 18,
		w = 32,
		align = "left",
		visible = false,
		layer = -1,
		text = utf8.to_upper(""),
		font = tweak_data.hud.small_font,
		font_size = tweak_data.hud.small_name_label_font_size,
		color = crim_color
	})

	panel:text({
		w = 256,
		name = "cheater",
		h = 18,
		align = "center",
		visible = false,
		layer = -1,
		text = utf8.to_upper(managers.localization:text("menu_hud_cheater")),
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.name_label_font_size,
		color = tweak_data.screen_colors.pro_color
	})
	panel:text({
		vertical = "bottom",
		name = "action",
		h = 18,
		w = 256,
		align = "left",
		visible = false,
		rotation = 360,
		layer = -1,
		text = utf8.to_upper("Fixing"),
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.name_label_font_size,
		color = (crim_color * 1.1):with_alpha(1)
	})
	self:align_teammate_name_label(panel, interact)
	table.insert(self._hud.name_labels, {
		vehicle = data.unit,
		panel = panel,
		text = text,
		id = id,
		character_name = vehicle_name,
		interact = interact,
		bag = bag,
		bag_number = bag_number
	})

	return id
end

-- Lines 1680-1694
function HUDManager:_remove_name_label(id)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)

	if not hud then
		return
	end

	for i, data in ipairs(self._hud.name_labels) do
		if data.id == id then
			hud.panel:remove(data.panel)
			table.remove(self._hud.name_labels, i)

			break
		end
	end
end

-- Lines 1696-1707
function HUDManager:_name_label_by_peer_id(peer_id)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)

	if not hud then
		return
	end

	for i, data in ipairs(self._hud.name_labels) do
		if data.peer_id == peer_id then
			return data
		end
	end
end

-- Lines 1709-1720
function HUDManager:_get_name_label(id)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)

	if not hud then
		return
	end

	for i, data in ipairs(self._hud.name_labels) do
		if data.id == id then
			return data
		end
	end
end

-- Lines 1721-1726
function HUDManager:set_name_label_carry_info(peer_id, carry_id, value)
	local name_label = self:_name_label_by_peer_id(peer_id)

	if name_label then
		name_label.panel:child("bag"):set_visible(true)
	end
end

-- Lines 1728-1735
function HUDManager:set_vehicle_label_carry_info(label_id, value, number)
	local name_label = self:_get_name_label(label_id)

	if name_label then
		name_label.panel:child("bag"):set_visible(value)
		name_label.panel:child("bag_number"):set_visible(value)
		name_label.panel:child("bag_number"):set_text("X" .. number)
	end
end

-- Lines 1738-1743
function HUDManager:remove_name_label_carry_info(peer_id)
	local name_label = self:_name_label_by_peer_id(peer_id)

	if name_label then
		name_label.panel:child("bag"):set_visible(false)
	end
end

-- Lines 1745-1787
function HUDManager:teammate_progress(peer_id, type_index, enabled, tweak_data_id, timer, success)
	local name_label = self:_name_label_by_peer_id(peer_id)

	if name_label then
		name_label.interact:set_visible(enabled)
		name_label.panel:child("action"):set_visible(enabled)

		local action_text = ""

		if type_index == 1 then
			action_text = managers.localization:text(tweak_data.interaction[tweak_data_id].action_text_id or "hud_action_generic")
		elseif type_index == 2 then
			if enabled then
				local equipment_name = managers.localization:text(tweak_data.equipments[tweak_data_id].text_id)
				local deploying_text = tweak_data.equipments[tweak_data_id].deploying_text_id and managers.localization:text(tweak_data.equipments[tweak_data_id].deploying_text_id) or false
				action_text = deploying_text or managers.localization:text("hud_deploying_equipment", {
					EQUIPMENT = equipment_name
				})
			end
		elseif type_index == 3 then
			action_text = managers.localization:text("hud_starting_heist")
		end

		name_label.panel:child("action"):set_text(utf8.to_upper(action_text))
		name_label.panel:stop()

		if enabled then
			name_label.panel:animate(callback(self, self, "_animate_label_interact"), name_label.interact, timer)
		elseif success then
			local panel = name_label.panel
			local bitmap = panel:bitmap({
				blend_mode = "add",
				texture = "guis/textures/pd2/hud_progress_active",
				layer = 2,
				align = "center",
				rotation = 360,
				valign = "center"
			})

			bitmap:set_size(name_label.interact:size())
			bitmap:set_position(name_label.interact:position())

			local radius = name_label.interact:radius()
			local circle = CircleBitmapGuiObject:new(panel, {
				blend_mode = "normal",
				rotation = 360,
				layer = 3,
				radius = radius,
				color = Color.white:with_alpha(1)
			})

			circle:set_position(name_label.interact:position())
			bitmap:animate(callback(HUDInteraction, HUDInteraction, "_animate_interaction_complete"), circle)
		end
	end

	local character_data = managers.criminals:character_data_by_peer_id(peer_id)

	if character_data then
		self._teammate_panels[character_data.panel_id]:teammate_progress(enabled, tweak_data_id, timer, success)
	end
end

-- Lines 1789-1797
function HUDManager:_animate_label_interact(panel, interact, timer)
	local t = 0

	while timer >= t do
		local dt = coroutine.yield()
		t = t + dt

		interact:set_current(t / timer)
	end

	interact:set_current(1)
end

-- Lines 1799-1801
function HUDManager:toggle_chatinput()
	self:set_chat_focus(true)
end

-- Lines 1803-1805
function HUDManager:chat_focus()
	return self._chat_focus
end

-- Lines 1807-1811
function HUDManager:set_chat_skip_first(skip_first)
	if self._hud_chat then
		self._hud_chat:set_skip_first(skip_first)
	end
end

-- Lines 1814-1831
function HUDManager:set_chat_focus(focus)
	if not self:alive(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) then
		return
	end

	if self._chat_focus == focus then
		return
	end

	setup:add_end_frame_callback(function ()
		self._chat_focus = focus
	end)
	self._chatinput_changed_callback_handler:dispatch(focus)

	if focus then
		self._hud_chat:_on_focus()
	else
		self._hud_chat:_loose_focus()
	end
end

-- Lines 1835-1840
function HUDManager:setup_access_camera_hud()
	local hud = managers.hud:script(IngameAccessCamera.GUI_SAFERECT)
	local full_hud = managers.hud:script(IngameAccessCamera.GUI_FULLSCREEN)
	self._hud_access_camera = HUDAccessCamera:new(hud, full_hud)
end

-- Lines 1842-1844
function HUDManager:set_access_camera_name(name)
	self._hud_access_camera:set_camera_name(name)
end

-- Lines 1846-1848
function HUDManager:set_access_camera_destroyed(destroyed, no_feed)
	self._hud_access_camera:set_destroyed(destroyed, no_feed)
end

-- Lines 1850-1857
function HUDManager:start_access_camera()
	self._hud_access_camera:start()

	if self._hud_chat then
		self._hud_chat:clear()
	end

	self._hud_chat = self._hud_chat_access or self._hud_chat
end

-- Lines 1859-1866
function HUDManager:stop_access_camera()
	self._hud_access_camera:stop()

	if self._hud_chat then
		self._hud_chat:clear()
	end

	self._hud_chat = self._hud_chat_ingame or self._hud_chat
end

-- Lines 1868-1870
function HUDManager:access_camera_track(i, cam, pos)
	self._hud_access_camera:draw_marker(i, self._workspace:world_to_screen(cam, pos))
end

-- Lines 1872-1874
function HUDManager:access_camera_track_max_amount(amount)
	self._hud_access_camera:max_markers(amount)
end

-- Lines 1878-1883
function HUDManager:setup_driving_hud()
	print("HUDManager:setup_driving_hud()")

	local hud = managers.hud:script(IngameDriving.DRIVING_GUI_SAFERECT)
	local full_hud = managers.hud:script(IngameDriving.DRIVING_GUI_FULLSCREEN)
	self._hud_driving = HUDDriving:new(hud, full_hud)
end

-- Lines 1885-1887
function HUDManager:start_driving()
	self._hud_driving:start()
end

-- Lines 1889-1891
function HUDManager:stop_driving()
	self._hud_driving:stop()
end

-- Lines 1893-1895
function HUDManager:set_driving_vehicle_state(speed, rpm, gear)
	self._hud_driving:set_vehicle_state(speed, rpm, gear)
end

-- Lines 1898-1902
function HUDManager:setup_blackscreen_hud()
	local hud = managers.hud:script(IngameWaitingForPlayersState.LEVEL_INTRO_GUI)
	self._hud_blackscreen = HUDBlackScreen:new(hud)
end

-- Lines 1904-1906
function HUDManager:set_blackscreen_mid_text(...)
	self._hud_blackscreen:set_mid_text(...)
end

-- Lines 1908-1910
function HUDManager:blackscreen_fade_in_mid_text()
	self._hud_blackscreen:fade_in_mid_text()
end

-- Lines 1912-1914
function HUDManager:blackscreen_fade_out_mid_text()
	self._hud_blackscreen:fade_out_mid_text()
end

-- Lines 1916-1918
function HUDManager:set_blackscreen_job_data()
	self._hud_blackscreen:set_job_data()
end

-- Lines 1920-1922
function HUDManager:set_blackscreen_skip_circle(current, total)
	self._hud_blackscreen:set_skip_circle(current, total)
end

-- Lines 1924-1926
function HUDManager:blackscreen_skip_circle_done()
	self._hud_blackscreen:skip_circle_done()
end

-- Lines 1930-1933
function HUDManager:setup_mission_briefing_hud()
	local hud = managers.hud:script(IngameWaitingForPlayersState.GUI_FULLSCREEN)
	self._hud_mission_briefing = HUDMissionBriefing:new(hud, self:workspace("fullscreen_workspace", "menu"))
end

-- Lines 1935-1939
function HUDManager:hide_mission_briefing_hud()
	if self._hud_mission_briefing then
		self._hud_mission_briefing:hide()
	end
end

-- Lines 1941-1945
function HUDManager:layout_mission_briefing_hud()
	if self._hud_mission_briefing then
		self._hud_mission_briefing:update_layout()
	end
end

-- Lines 1947-1949
function HUDManager:get_mission_briefing_hud()
	return self._hud_mission_briefing
end

-- Lines 1951-1953
function HUDManager:set_player_slot(nr, params)
	self._hud_mission_briefing:set_player_slot(nr, params)
end

-- Lines 1955-1957
function HUDManager:set_slot_joining(peer, peer_id)
	self._hud_mission_briefing:set_slot_joining(peer, peer_id)
end

-- Lines 1959-1961
function HUDManager:set_slot_ready(peer, peer_id)
	self._hud_mission_briefing:set_slot_ready(peer, peer_id)
end

-- Lines 1963-1965
function HUDManager:set_slot_not_ready(peer, peer_id)
	self._hud_mission_briefing:set_slot_not_ready(peer, peer_id)
end

-- Lines 1967-1969
function HUDManager:set_dropin_progress(peer_id, progress_percentage, mode)
	self._hud_mission_briefing:set_dropin_progress(peer_id, progress_percentage, mode)
end

-- Lines 1971-1973
function HUDManager:set_player_slots_kit(slot)
	self._hud_mission_briefing:set_player_slots_kit(slot)
end

-- Lines 1975-1977
function HUDManager:set_kit_selection(peer_id, category, id, slot)
	self._hud_mission_briefing:set_kit_selection(peer_id, category, id, slot)
end

-- Lines 1979-1981
function HUDManager:set_slot_outfit(slot, criminal_name, outfit)
	self._hud_mission_briefing:set_slot_outfit(slot, criminal_name, outfit)
end

-- Lines 1983-1985
function HUDManager:set_slot_voice(peer, peer_id, active)
	self._hud_mission_briefing:set_slot_voice(peer, peer_id, active)
end

-- Lines 1987-1989
function HUDManager:remove_player_slot_by_peer_id(peer, reason)
	self._hud_mission_briefing:remove_player_slot_by_peer_id(peer, reason)
end

-- Lines 1991-1993
function HUDManager:is_inside_mission_briefing_slot(peer_id, child, x, y)
	return self._hud_mission_briefing:inside_slot(peer_id, child, x, y)
end

-- Lines 1997-2010
function HUDManager:setup_endscreen_hud()
	local ws = self:workspace("fullscreen_workspace", "menu")
	local hud = managers.hud:script(MissionEndState.GUI_ENDSCREEN)

	if game_state_machine:gamemode().id == GamemodeCrimeSpree.id then
		self._hud_stage_endscreen = HUDStageEndCrimeSpreeScreen:new(hud, ws)
	else
		self._hud_stage_endscreen = HUDStageEndScreen:new(hud, ws)
	end
end

-- Lines 2012-2016
function HUDManager:hide_endscreen_hud()
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:hide()
	end
end

-- Lines 2018-2022
function HUDManager:show_endscreen_hud()
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:show()
	end
end

-- Lines 2024-2028
function HUDManager:layout_endscreen_hud()
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:update_layout()
	end
end

-- Lines 2031-2035
function HUDManager:set_continue_button_text_endscreen_hud(text)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:set_continue_button_text(text)
	end
end

-- Lines 2037-2041
function HUDManager:set_success_endscreen_hud(success, server_left)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:set_success(success, server_left)
	end
end

-- Lines 2043-2047
function HUDManager:set_statistics_endscreen_hud(criminals_completed, success)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:set_statistics(criminals_completed, success)
	end
end

-- Lines 2048-2052
function HUDManager:set_special_packages_endscreen_hud(params)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:set_special_packages(params)
	end
end

-- Lines 2054-2058
function HUDManager:set_speed_up_endscreen_hud(multiplier)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:set_speed_up(multiplier)
	end
end

-- Lines 2060-2072
function HUDManager:set_group_statistics_endscreen_hud(best_kills, best_kills_score, best_special_kills, best_special_kills_score, best_accuracy, best_accuracy_score, most_downs, most_downs_score, total_kills, total_specials_kills, total_head_shots, group_accuracy, group_downs)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:set_group_statistics(best_kills, best_kills_score, best_special_kills, best_special_kills_score, best_accuracy, best_accuracy_score, most_downs, most_downs_score, total_kills, total_specials_kills, total_head_shots, group_accuracy, group_downs)
	end
end

-- Lines 2074-2078
function HUDManager:send_xp_data_endscreen_hud(data, done_clbk)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:send_xp_data(data, done_clbk)
	end
end

-- Lines 2080-2084
function HUDManager:update_endscreen_hud(t, dt)
	if self._hud_stage_endscreen then
		self._hud_stage_endscreen:update(t, dt)
	end
end

-- Lines 2090-2096
function HUDManager:setup_lootscreen_hud()
	local hud = managers.hud:script(IngameLobbyMenuState.GUI_LOOTSCREEN)
	self._hud_lootscreen = HUDLootScreen:new(hud, self:workspace("fullscreen_workspace", "menu"), self._saved_lootdrop, self._saved_selected, self._saved_card_chosen, self._saved_setup)
	self._saved_lootdrop = nil
	self._saved_selected = nil
	self._saved_card_chosen = nil
end

-- Lines 2098-2102
function HUDManager:hide_lootscreen_hud()
	if self._hud_lootscreen then
		self._hud_lootscreen:hide()
	end
end

-- Lines 2104-2108
function HUDManager:show_lootscreen_hud()
	if self._hud_lootscreen then
		self._hud_lootscreen:show()
	end
end

-- Lines 2110-2117
function HUDManager:make_cards_hud(peer, max_pc, left_card, right_card)
	if self._hud_lootscreen then
		self._hud_lootscreen:make_cards(peer, max_pc, left_card, right_card)
	else
		self._saved_setup = self._saved_setup or {}

		table.insert(self._saved_setup, {
			peer = peer,
			max_pc = max_pc,
			left_card = left_card,
			right_card = right_card
		})
	end
end

-- Lines 2119-2126
function HUDManager:make_lootdrop_hud(lootdrop_data)
	if self._hud_lootscreen then
		self._hud_lootscreen:make_lootdrop(lootdrop_data)
	else
		self._saved_lootdrop = self._saved_lootdrop or {}

		table.insert(self._saved_lootdrop, lootdrop_data)
	end
end

-- Lines 2128-2135
function HUDManager:set_selected_lootcard(peer_id, selected)
	if self._hud_lootscreen then
		self._hud_lootscreen:set_selected(peer_id, selected)
	else
		self._saved_selected = self._saved_selected or {}
		self._saved_selected[peer_id] = selected
	end
end

-- Lines 2137-2144
function HUDManager:confirm_choose_lootcard(peer_id, card_id)
	if self._hud_lootscreen then
		self._hud_lootscreen:begin_choose_card(peer_id, card_id)
	else
		self._saved_card_chosen = self._saved_card_chosen or {}
		self._saved_card_chosen[peer_id] = card_id
	end
end

-- Lines 2146-2148
function HUDManager:get_lootscreen_hud()
	return self._hud_lootscreen
end

-- Lines 2151-2155
function HUDManager:layout_lootscreen_hud()
	if self._hud_lootscreen then
		self._hud_lootscreen:update_layout()
	end
end

-- Lines 2160-2164
function HUDManager:layout_lootscreen_skirmish_hud()
	if self._hud_lootscreen then
		self._hud_lootscreen:update_layout()
	end
end

-- Lines 2166-2170
function HUDManager:setup_lootscreen_skirmish_hud()
	local hud = managers.hud:script(IngameLobbyMenuState.GUI_LOOTSCREEN)
	self._hud_lootscreen = HUDLootScreenSkirmish:new(hud, self:workspace("fullscreen_workspace", "menu"), self._saved_lootdrop, self._saved_setup)
	self._saved_lootdrop = nil
end

-- Lines 2172-2176
function HUDManager:hide_lootscreen_skirmish_hud()
	if self._hud_lootscreen then
		self._hud_lootscreen:hide()
	end
end

-- Lines 2178-2182
function HUDManager:show_lootscreen_skirmish_hud()
	if self._hud_lootscreen then
		self._hud_lootscreen:show()
	end
end

-- Lines 2184-2191
function HUDManager:make_skirmish_cards_hud(peer, amount_cards)
	if self._hud_lootscreen then
		self._hud_lootscreen:make_cards(peer, amount_cards)
	else
		self._saved_setup = self._saved_setup or {}

		table.insert(self._saved_setup, {
			peer = peer,
			amount_cards = amount_cards
		})
	end
end

-- Lines 2196-2204
function HUDManager:_create_test_circle()
	if self._test_circle then
		self._test_circle:remove()

		self._test_circle = nil
	end

	self._test_circle = CircleGuiObject:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel, {
		sides = 64,
		radius = 10,
		current = 10,
		total = 10
	})

	self._test_circle._circle:animate(callback(self, self, "_animate_test_circle"))
end

-- Lines 2208-2210
function HUDManager:set_blackscreen_loading_text_status(status)
	self._hud_blackscreen:set_loading_text_status(status)
end

-- Lines 2214-2216
function HUDManager:set_custody_respawn_type(is_ai_trade)
	self._hud_player_custody:set_respawn_type(is_ai_trade)
end

-- Lines 2222-2269
function HUDManager:set_ai_stopped(ai_id, stopped)
	local teammate_panel = self._teammate_panels[ai_id]

	if not teammate_panel or stopped and not teammate_panel._ai then
		return
	end

	local panel = teammate_panel._panel

	if not panel then
		return
	end

	local label = nil

	for _, lbl in ipairs(self._hud.name_labels) do
		if lbl.id == ai_id then
			label = lbl

			break
		end
	end

	if stopped then
		local name_text = panel:child("name")
		local stop_icon = panel:bitmap({
			name = "stopped",
			texture = tweak_data.hud_icons.ai_stopped.texture,
			texture_rect = tweak_data.hud_icons.ai_stopped.texture_rect
		})

		stop_icon:set_w(name_text:h() / 2)
		stop_icon:set_h(name_text:h())
		stop_icon:set_left(name_text:right() + 5)
		stop_icon:set_y(name_text:y())

		if label then
			local label_stop_icon = label.panel:bitmap({
				name = "stopped",
				texture = tweak_data.hud_icons.ai_stopped.texture,
				texture_rect = tweak_data.hud_icons.ai_stopped.texture_rect
			})

			if _G.IS_VR then
				label_stop_icon:configure({
					depth_mode = "disabled",
					render_template = Idstring("OverlayVertexColorTextured")
				})
			end

			label_stop_icon:set_right(label.text:left())
			label_stop_icon:set_center_y(label.text:center_y())
		end
	else
		if panel:child("stopped") then
			panel:remove(panel:child("stopped"))
		end

		if label and label.panel:child("stopped") then
			label.panel:remove(label.panel:child("stopped"))
		end
	end
end

-- Lines 2276-2284
function HUDManager:achievement_popup(id)
	if managers.network.account:signin_state() ~= "signed in" then
		return
	end

	local d = tweak_data.achievement.visual[id]
	local title = managers.localization:to_upper_text("hud_achieved_popup")
	local text = d and managers.localization:to_upper_text(d.name_id) or id
	local icon = d and d.icon_id or "placeholder_circle"

	HudChallengeNotification.queue(title, text, icon)
end

-- Lines 2287-2290
function HUDManager:challenge_popup(d)
	HudChallengeNotification.queue(managers.localization:to_upper_text("hud_challenge_popup"), managers.localization:to_upper_text(d.name_id))
end

-- Lines 2292-2295
function HUDManager:custom_ingame_popup(title_id, text_id, icon_id)
	HudChallengeNotification.queue(managers.localization:to_upper_text(title_id), managers.localization:to_upper_text(text_id), icon_id)
end

-- Lines 2297-2299
function HUDManager:custom_ingame_popup_text(title, text, icon_id)
	HudChallengeNotification.queue(title, text, icon_id)
end

-- Lines 2302-2323
function HUDManager:safe_house_challenge_popup(id, c_type)
	local d = nil
	local title_id = "hud_trophy_popup"

	if c_type == "daily" then
		title_id = "hud_challenge_popup"
		d = managers.custom_safehouse:get_daily(id)
	else
		d = managers.custom_safehouse:get_trophy(id)
	end

	if not d then
		Application:error("Failed to get data about side job with id '" .. id .. "' and type '" .. (c_type or "nil") .. "'!")

		return
	end

	if not d.hidden_in_list then
		HudChallengeNotification.queue(managers.localization:to_upper_text(title_id), managers.localization:to_upper_text(d.name_id))
	end
end

-- Lines 2326-2331
function HUDManager:achievement_milestone_popup(id)
	local milestone = managers.achievment:get_milestone(id)
	local title = managers.localization:to_upper_text("hud_achievement_milestone_popup")
	local description = managers.localization:to_upper_text("menu_milestone_item_title", {
		AT = milestone.at
	})

	HudChallengeNotification.queue(title, description, "milestone_trophy", milestone.rewards)
end

-- Lines 2336-2344
function HUDManager:register_ingame_workspace(name, obj)
	self._ingame_workspaces = self._ingame_workspaces or {}

	managers.gui_data:add_workspace_object(name, obj)

	self._ingame_workspaces[name] = managers.gui_data:create_fullscreen_workspace(name, World:gui())

	if self["on_workspace_created_" .. name] then
		self["on_workspace_created_" .. name](self, self._ingame_workspaces[name])
	end
end

-- Lines 2346-2348
function HUDManager:ingame_workspace(name)
	return self._ingame_workspaces and self._ingame_workspaces[name]
end

-- Lines 2680-2697
function HUDManager:hide_panels(...)
	-- Lines 2681-2686
	local function fade_out(o)
		for t, p, dt in seconds(1) do
			o:set_alpha(1 - p)
		end

		o:set_visible(false)
	end

	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	local panels = {
		...
	}

	for _, panel_name in ipairs(panels) do
		local panel = hud.panel:child(panel_name)

		if panel then
			panel:animate(fade_out)
		end
	end
end
