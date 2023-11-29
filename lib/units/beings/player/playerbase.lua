PlayerBase = PlayerBase or class(UnitBase)
PlayerBase.PLAYER_HUD = Idstring("guis/player_hud")
PlayerBase.PLAYER_INFO_HUD_FULLSCREEN = Idstring("guis/player_info_hud_fullscreen")
PlayerBase.PLAYER_INFO_HUD = Idstring("guis/player_info_hud")
PlayerBase.PLAYER_DOWNED_HUD = Idstring("guis/player_downed_hud")
PlayerBase.PLAYER_CUSTODY_HUD = Idstring("guis/spectator_mode")
PlayerBase.PLAYER_INFO_HUD_PD2 = Idstring("guis/player_info_hud_pd2")
PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2 = Idstring("guis/player_info_hud_fullscreen_pd2")
PlayerBase.USE_GRENADES = true

-- Lines 12-37
function PlayerBase:init(unit)
	UnitBase.init(self, unit, false)

	self._unit = unit

	self:_setup_suspicion_and_detection_data()
	self:_setup_hud()

	self._id = managers.player:player_id(self._unit)
	self._rumble_pos_callback = callback(self, self, "get_rumble_position")

	self:_setup_controller()
	self._unit:set_extension_update_enabled(Idstring("base"), false)

	self._stats_screen_visible = false

	managers.game_play_central:restart_portal_effects()

	if Network:is_client() then
		self:sync_unit_upgrades()
	end

	managers.job:set_memory("mad_3", true)
end

-- Lines 41-52
function PlayerBase:post_init()
	self._unit:movement():post_init()
	self:_equip_default_weapon()

	if self._unit:movement():nav_tracker() then
		managers.groupai:state():register_criminal(self._unit)
	else
		self._unregistered = true
	end

	self._unit:character_damage():post_init()
	self:update_concealment()
end

-- Lines 56-61
function PlayerBase:update_concealment()
	local con_mul, index = managers.blackmarket:get_concealment_of_peer(managers.network:session():local_peer())

	self:set_suspicion_multiplier("equipment", 1 / con_mul)
	self:set_detection_multiplier("equipment", 1 / con_mul)
	self:setup_hud_offset()
end

-- Lines 65-78
function PlayerBase:update(unit, t, dt)
	if self._wanted_controller_enabled_t then
		if self._wanted_controller_enabled_t <= 0 then
			if self._wanted_controller_enabled then
				self._controller:set_enabled(true)

				self._wanted_controller_enabled = nil
				self._wanted_controller_enabled_t = nil
			end

			self._unit:set_extension_update_enabled(Idstring("base"), false)
		else
			self._wanted_controller_enabled_t = self._wanted_controller_enabled_t - 1
		end
	end
end

-- Lines 82-93
function PlayerBase:_setup_suspicion_and_detection_data()
	self._suspicion_settings = deep_clone(tweak_data.player.suspicion)
	self._suspicion_settings.multipliers = {}
	self._suspicion_settings.init_buildup_mul = self._suspicion_settings.buildup_mul
	self._suspicion_settings.init_range_mul = self._suspicion_settings.range_mul

	self:setup_hud_offset()

	self._detection_settings = {
		multipliers = {},
		init_delay_mul = 1,
		init_range_mul = 1
	}
end

-- Lines 95-101
function PlayerBase:setup_hud_offset()
	if not self._suspicion_settings then
		return
	end

	self._suspicion_settings.hud_offset = managers.blackmarket:get_suspicion_offset_of_peer(managers.network:session():local_peer(), tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
end

-- Lines 105-127
function PlayerBase:save(data)
	data.upgrades = {}
	data.temporary_upgrades = {}
	local pm = managers.player
	local net_sesh = managers.network:session()

	for category, upgrades in pairs(pm._global.upgrades) do
		for upgrade, level in pairs(upgrades) do
			if pm:is_upgrade_synced(category, upgrade) then
				if category == "temporary" then
					local index = pm:temporary_upgrade_index(category, upgrade)
					data.temporary_upgrades[category] = data.temporary_upgrades[category] or {}
					data.temporary_upgrades[category][upgrade] = {
						index = index,
						level = level
					}
				else
					data.upgrades[category] = data.upgrades[category] or {}
					data.upgrades[category][upgrade] = level
				end
			end
		end
	end

	data.concealment_modifier = managers.blackmarket:_get_concealment_from_local_player()
end

-- Lines 131-154
function PlayerBase:sync_unit_upgrades()
	local sus_multiplier = 1
	local det_multiplier = 1

	if managers.player:has_category_upgrade("player", "suspicion_multiplier") then
		local mul = managers.player:upgrade_value("player", "suspicion_multiplier", 1)

		self:set_suspicion_multiplier("suspicion_multiplier", mul)
	end

	managers.environment_controller:set_flashbang_multiplier(managers.player:upgrade_value("player", "flashbang_multiplier"))

	local pm = managers.player
	local net_sesh = managers.network:session()

	for category, upgrades in pairs(pm._global.upgrades) do
		for upgrade, level in pairs(upgrades) do
			if pm:is_upgrade_synced(category, upgrade) then
				if category == "temporary" then
					net_sesh:send_to_peers_synched("sync_temporary_upgrade_owned", category, upgrade, level, pm:temporary_upgrade_index(category, upgrade))
				else
					net_sesh:send_to_peers_synched("sync_upgrade", category, upgrade, level)
				end
			end
		end
	end
end

-- Lines 158-160
function PlayerBase:stats_screen_visible()
	return self._stats_screen_visible
end

-- Lines 162-169
function PlayerBase:set_stats_screen_visible(visible)
	self._stats_screen_visible = visible

	if self._stats_screen_visible then
		managers.hud:show_stats_screen()
	else
		managers.hud:hide_stats_screen()
	end
end

-- Lines 174-176
function PlayerBase:set_enabled(enabled)
	self._unit:set_extension_update_enabled(Idstring("movement"), enabled)
end

-- Lines 178-193
function PlayerBase:set_visible(visible)
	self._unit:set_visible(visible)

	if not _G.IS_VR then
		self._unit:camera():camera_unit():set_visible(visible)
	end

	if visible then
		self._unit:inventory():show_equipped_unit()
	else
		self._unit:inventory():hide_equipped_unit()
	end
end

-- Lines 196-226
function PlayerBase:_setup_hud()
	if not managers.hud:exists(self.PLAYER_HUD) then
		managers.hud:load_hud(self.PLAYER_HUD, false, false, true, {})
	end

	if not managers.hud:exists(self.PLAYER_DOWNED_HUD) then
		managers.hud:load_hud(self.PLAYER_DOWNED_HUD, false, false, true, {})
	end
end

-- Lines 230-231
function PlayerBase:_equip_default_weapon()
end

-- Lines 235-239
function PlayerBase:_setup_controller()
	self._controller = managers.controller:create_controller("player_" .. tostring(self._id), nil, false)

	managers.rumble:register_controller(self._controller, self._rumble_pos_callback)
	managers.controller:set_ingame_mode("main")
end

-- Lines 243-245
function PlayerBase:id()
	return self._id
end

-- Lines 249-251
function PlayerBase:nick_name()
	return managers.network:session():local_peer():name()
end

-- Lines 255-268
function PlayerBase:set_controller_enabled(enabled)
	if not self._controller then
		return
	end

	if not enabled then
		self._controller:set_enabled(false)
	end

	self._wanted_controller_enabled = enabled

	if self._wanted_controller_enabled then
		self._wanted_controller_enabled_t = 1

		self._unit:set_extension_update_enabled(Idstring("base"), true)
	end
end

-- Lines 270-272
function PlayerBase:controller()
	return self._controller
end

local on_ladder_footstep_material = Idstring("steel")

-- Lines 277-309
function PlayerBase:anim_data_clbk_footstep(foot)
	local obj = self._unit:orientation_object()
	local proj_dir = math.UP
	local proj_from = obj:position()
	local proj_to = proj_from - proj_dir * 30
	local material_name, pos, norm = nil

	if self._unit:movement():on_ladder() then
		material_name = on_ladder_footstep_material
	else
		material_name, pos, norm = World:pick_decal_material(proj_from, proj_to, managers.slot:get_mask("surface_move"))
	end

	self._unit:sound():play_footstep(foot, material_name)
end

-- Lines 313-315
function PlayerBase:get_rumble_position()
	return self._unit:position() + math.UP * 100
end

-- Lines 319-332
function PlayerBase:replenish()
	for id, weapon in pairs(self._unit:inventory():available_selections()) do
		if alive(weapon.unit) then
			weapon.unit:base():replenish()
			managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
		end
	end

	self._unit:character_damage():replenish()
end

-- Lines 336-338
function PlayerBase:suspicion_settings()
	return self._suspicion_settings
end

-- Lines 342-344
function PlayerBase:detection_settings()
	return self._detection_settings
end

-- Lines 348-362
function PlayerBase:set_suspicion_multiplier(reason, multiplier)
	self._suspicion_settings.multipliers[reason] = multiplier
	local buildup_mul = self._suspicion_settings.init_buildup_mul
	local range_mul = self._suspicion_settings.init_range_mul

	for reason, mul in pairs(self._suspicion_settings.multipliers) do
		buildup_mul = buildup_mul * mul

		if mul > 1 then
			range_mul = range_mul * math.sqrt(mul)
		end
	end

	self._suspicion_settings.buildup_mul = buildup_mul
	self._suspicion_settings.range_mul = range_mul
end

-- Lines 366-377
function PlayerBase:set_detection_multiplier(reason, multiplier)
	self._detection_settings.multipliers[reason] = multiplier
	local delay_mul = self._detection_settings.init_delay_mul
	local range_mul = self._detection_settings.init_range_mul

	for reason, mul in pairs(self._detection_settings.multipliers) do
		delay_mul = delay_mul * 1 / mul
		range_mul = range_mul * math.sqrt(mul)
	end

	self._detection_settings.delay_mul = delay_mul
	self._detection_settings.range_mul = range_mul
end

-- Lines 381-383
function PlayerBase:arrest_settings()
	return tweak_data.player.arrest
end

-- Lines 387-394
function PlayerBase:_unregister()
	if not self._unregistered then
		self._unit:movement():attention_handler():set_attention(nil)
		managers.groupai:state():unregister_criminal(self._unit)

		self._unregistered = true
	end
end

-- Lines 398-424
function PlayerBase:pre_destroy(unit)
	self:_unregister()
	UnitBase.pre_destroy(self, unit)
	managers.player:player_destroyed(self._id)

	if self._controller then
		managers.rumble:unregister_controller(self._controller, self._rumble_pos_callback)
		self._controller:destroy()

		self._controller = nil
	end

	if managers.hud:alive(self.PLAYER_HUD) then
		managers.hud:clear_weapons()
		managers.hud:hide(self.PLAYER_HUD)
	end

	self:set_stats_screen_visible(false)

	if managers.network:session() then
		local peer = managers.network:session():local_peer()

		if peer then
			peer:set_unit(nil)
		end
	end

	unit:movement():pre_destroy(unit)
	unit:inventory():pre_destroy(unit)
	unit:character_damage():pre_destroy()
end

-- Lines 432-434
function PlayerBase:upgrade_value(category, upgrade)
	return managers.player:upgrade_value_nil(category, upgrade)
end

-- Lines 436-438
function PlayerBase:upgrade_level(category, upgrade)
	return managers.player:upgrade_level_nil(category, upgrade)
end

-- Lines 442-444
function PlayerBase:character_name()
	return managers.criminals:character_name_by_unit(self._unit)
end
