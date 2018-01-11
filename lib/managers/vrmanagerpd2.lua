require("lib/utils/VRLoadingEnvironment")

VRViewport = VRViewport or class()

-- Lines: 6 to 11
function VRViewport:init(x, y, width, height, name, prio)
	self._vp = Application:create_world_viewport(x, y, width, height)
	self._use_adaptive_quality = true
	self._prio = prio
	self._name = name
end

-- Lines: 13 to 15
function VRViewport:set_camera(camera)
	self._vp:set_camera(camera)
end

-- Lines: 17 to 19
function VRViewport:set_active(active)
	self._active = active
end

-- Lines: 21 to 22
function VRViewport:vp()
	return self._vp
end

-- Lines: 25 to 27
function VRViewport:set_render_params(...)
	self._render_params = {...}
end

-- Lines: 29 to 30
function VRViewport:use_adaptive_quality()
	return self._use_adaptive_quality
end

-- Lines: 33 to 35
function VRViewport:set_enable_adaptive_quality(enable)
	self._use_adaptive_quality = enable
end

-- Lines: 37 to 38
function VRViewport:active()
	return self._active
end

-- Lines: 41 to 42
function VRViewport:destroy()
end

-- Lines: 44 to 46
function VRViewport:render()
	Application:render(unpack(self._render_params))
end
VRManagerPD2 = VRManagerPD2 or class()
VRManagerPD2.DISABLE_ADAPTIVE_QUALITY = false

-- Lines: 51 to 147
function VRManagerPD2:init()
	print("[VRManagerPD2] init")

	if not PackageManager:loaded("packages/vr_base") then
		PackageManager:load("packages/vr_base")
	end

	VRManager:set_max_adaptive_levels(7)

	self._adaptive_scale = {
		0.85,
		0.9,
		1,
		1.1,
		1.2,
		1.3
	}
	self._adaptive_scale_max = 1.4

	VRManager:set_present_post_processor(Idstring("core/shaders/render_to_backbuffer"), Idstring("stretch_copy"), "back_buffer")

	self._is_default_hmd = true
	self._is_oculus = string.find(string.lower(VRManager:hmd_manufacturer()), "oculus") ~= nil
	self._is_default_hmd = self._is_default_hmd and not self._is_oculus
	self._super_sample_scale = VRManager:super_sample_scale()
	self._viewports = {}
	self._default = {
		belt_height_ratio = 0.6,
		height = 140,
		belt_snap = 72,
		autowarp_length = "long",
		auto_reload = true,
		weapon_switch_button = false,
		fadeout_type = "fadeout_smooth",
		collision_instant_teleport = false,
		belt_size = 96,
		default_tablet_hand = "left",
		warp_zone_size = 0,
		enable_dead_zone_warp = true,
		rotate_player_angle = 45,
		weapon_assist_toggle = false,
		default_weapon_hand = "right",
		movement_type = "warp",
		belt_distance = 10,
		zipline_screen = true,
		dead_zone_size = self._is_default_hmd and 50 or 35,
		belt_layout = {
			bag = {
				2,
				4
			},
			melee = {
				4,
				4
			},
			deployable = {
				4,
				6
			},
			weapon = {
				10,
				4
			},
			throwable = {
				10,
				6
			},
			reload = {
				7,
				2
			},
			deployable_secondary = {
				2,
				6
			}
		}
	}
	self._limits = {
		height = {
			max = 250,
			min = 50
		},
		belt_height_ratio = {
			max = 0.9,
			min = 0.1
		},
		belt_distance = {
			max = 30,
			min = -10
		},
		belt_size = {
			max = 126,
			min = 66
		},
		belt_snap = {
			max = 360,
			min = 0
		},
		rotate_player_angle = {
			max = 90,
			min = 45
		},
		warp_zone_size = {
			max = 100,
			min = 0
		},
		dead_zone_size = {
			max = 100,
			min = 0
		}
	}

	if not Global.vr then
		Global.vr = {}
	end

	self._global = Global.vr

	for setting, default in pairs(self._default) do
		if self._global[setting] == nil then
			if type(default) == "table" then
				self._global[setting] = deep_clone(default)
			else
				self._global[setting] = default
			end
		end
	end

	self._vr_loading_environment = VRLoadingEnvironment:new()
	self._force_disable_low_adaptive_quality = false

	MenuRoom:load("units/pd2_dlc_vr/menu/vr_menu_mini", false)
end

-- Lines: 149 to 169
function VRManagerPD2:init_finalize()
	print("[VRManagerPD2] init_finalize")

	if game_state_machine:is_boot_intro_done() then
		self._vr_loading_environment:stop()
	else
		self._vr_loading_environment:start()
	end

	self._adaptive_quality_setting_changed_clbk = callback(self, self, "_on_adaptive_quality_setting_changed")

	managers.user:add_setting_changed_callback("adaptive_quality", self._adaptive_quality_setting_changed_clbk)
	self._adaptive_quality_setting_changed_clbk("adaptive_quality", nil, managers.user:get_setting("adaptive_quality"))
end

-- Lines: 171 to 172
function VRManagerPD2:is_default_hmd()
	return self._is_default_hmd
end

-- Lines: 175 to 176
function VRManagerPD2:is_oculus()
	return self._is_oculus
end

-- Lines: 179 to 209
function VRManagerPD2:apply_arcade_settings()
	print("[VRManagerPD2] Apply arcade settings")
	managers.user:set_setting("video_ao", "off")
	managers.user:set_setting("video_aa", "smaa_x1")
	managers.user:set_setting("parallax_mapping", true)
	managers.user:set_setting("chromatic_setting", "none")
	managers.user:set_setting("adaptive_quality", true)

	local dirty = false
	dirty = dirty or RenderSettings.texture_quality_default ~= "high"
	dirty = dirty or RenderSettings.shadow_quality_default ~= "low"
	dirty = dirty or RenderSettings.max_anisotropy ~= 2

	if dirty then
		RenderSettings.texture_quality_default = "high"
		RenderSettings.shadow_quality_default = "low"
		RenderSettings.max_anisotropy = 2

		MenuCallbackHandler:apply_and_save_render_settings()
	end
end

-- Lines: 211 to 214
function VRManagerPD2:force_start_loading()
	print("[VRManagerPD2] Force start loading")
	self._vr_loading_environment:force_start()
end

-- Lines: 216 to 219
function VRManagerPD2:start_loading()
	print("[VRManagerPD2] Start loading")
	self._vr_loading_environment:start()
end

-- Lines: 221 to 224
function VRManagerPD2:start_end_screen()
	print("[VRManagerPD2] Start end screen")
	self._vr_loading_environment:start("end")
end

-- Lines: 226 to 229
function VRManagerPD2:stop_loading()
	print("[VRManagerPD2] Stop loading")
	self._vr_loading_environment:stop()
end

-- Lines: 231 to 234
function VRManagerPD2:destroy()
	managers.user:remove_setting_changed_callback("adaptive_quality", self._adaptive_quality_setting_changed_clbk)
	print("[VRManagerPD2] destroy")
end

-- Lines: 239 to 243
function VRManagerPD2:update(t, dt)
	self:_update_adaptive_quality_level(t)
	self._vr_loading_environment:update(t, dt)
end

-- Lines: 245 to 248
function VRManagerPD2:paused_update(t, dt)
	self:_update_adaptive_quality_level(t)
	self._vr_loading_environment:update(t, dt)
end

-- Lines: 267 to 268
function VRManagerPD2:end_update(t, dt)
end

-- Lines: 270 to 273
function VRManagerPD2:new_vp(x, y, width, height, name, prio)
	local vp = VRViewport:new(x, y, width, height, name, prio)

	table.insert(self._viewports, vp)

	return vp
end

-- Lines: 280 to 286
function VRManagerPD2:render()
	for _, vp in ipairs(self._viewports) do
		if vp:active() then
			vp:render()
		end
	end
end

-- Lines: 288 to 290
function VRManagerPD2:set_hand_state_machine(hsm)
	self._hsm = hsm
end

-- Lines: 292 to 293
function VRManagerPD2:hand_state_machine()
	return self._hsm
end

-- Lines: 296 to 305
function VRManagerPD2:_on_adaptive_quality_setting_changed(setting, old, new)
	local setting = new and true or false
	self._use_adaptive_quality = setting

	if RenderSettings.adaptive_quality ~= setting then
		RenderSettings.adaptive_quality = setting

		VRManager:set_adaptive_quality(new)
		Application:apply_render_settings()
	end
end

-- Lines: 307 to 309
function VRManagerPD2:set_force_disable_low_adaptive_quality(disable)
	self._force_disable_low_adaptive_quality = disable
end

-- Lines: 312 to 374
function VRManagerPD2:_update_adaptive_quality_level(t)
	if self._update_super_sample_scale_t and self._update_super_sample_scale_t < t then
		self._update_super_sample_scale_t = nil
	end

	local scale = VRManager:super_sample_scale()

	if math.abs(scale - self._super_sample_scale) > 0.01 and not self._update_super_sample_scale_t then
		self._update_super_sample_scale_t = t + 0.5
		self._super_sample_scale = scale

		Application:apply_render_settings()
	end

	local quality_level = VRManager:adaptive_level() + 1

	if self._force_disable_low_adaptive_quality then
		quality_level = math.max(quality_level, 3)
	end

	local x_scale = 1
	local y_scale = 1

	if self._use_adaptive_quality and quality_level < 7 then
		local tres = VRManager:target_resolution()
		local scaling = self._adaptive_scale[quality_level]
		x_scale = scaling / self._adaptive_scale_max
		local res_x = math.floor(tres.x * x_scale)

		if res_x % 4 > 0.01 then
			res_x = res_x + 4 - res_x % 4
		end

		x_scale = res_x / tres.x + 0.05 / tres.x
		y_scale = scaling / self._adaptive_scale_max
		local res_y = math.floor(tres.y * y_scale)

		if res_y % 2 > 0.01 then
			res_y = res_y + 1
		end

		y_scale = res_y / tres.y + 0.05 / tres.y
	end

	VRManager:set_output_scaling(x_scale, y_scale)
	managers.overlay_effect:viewport():set_dimensions(0, 0, x_scale, y_scale)

	for _, svp in ipairs(managers.viewport:all_really_active_viewports()) do
		if svp:use_adaptive_quality() then
			svp:vp():set_dimensions(0, 0, x_scale, y_scale)
		end
	end

	for _, svp in ipairs(self._viewports) do
		if svp:use_adaptive_quality() then
			svp:vp():set_dimensions(0, 0, x_scale, y_scale)
		end
	end
end

-- Lines: 376 to 377
function VRManagerPD2:block_exec()
	return self._vr_loading_environment:block_exec()
end

-- Lines: 384 to 399
function VRManagerPD2:save(data)
	data.vr = {}

	for setting in pairs(self._default) do
		data.vr[setting] = self._global[setting]
	end

	data.vr.has_set_height = self._global.has_set_height
	data.vr.has_shown_savefile_dialog = self._global.has_shown_savefile_dialog
end

-- Lines: 406 to 425
function VRManagerPD2:load(data)
	if not data.vr then
		return
	end

	for setting in pairs(self._default) do
		if data.vr[setting] ~= nil then
			self._global[setting] = data.vr[setting]
		end

		self._global.has_set_height = data.vr.has_set_height
		self._global.has_shown_savefile_dialog = data.vr.has_shown_savefile_dialog
	end
end

-- Lines: 429 to 433
function VRManagerPD2:add_setting_changed_callback(setting, callback)
	self._setting_callback_handler_map = self._setting_callback_handler_map or {}
	self._setting_callback_handler_map[setting] = self._setting_callback_handler_map[setting] or CoreEvent.CallbackEventHandler:new()

	self._setting_callback_handler_map[setting]:add(callback)
end

-- Lines: 435 to 441
function VRManagerPD2:remove_setting_changed_callback(setting, callback)
	self._setting_callback_handler_map = self._setting_callback_handler_map or {}
	self._setting_callback_handler_map[setting] = self._setting_callback_handler_map[setting]

	if self._setting_callback_handler_map[setting] then
		self._setting_callback_handler_map[setting]:remove(callback)
	end
end

-- Lines: 445 to 450
function VRManagerPD2:setting_limits(setting)
	local limits = self._limits[setting]

	if limits then
		return limits.min, limits.max
	end
end

-- Lines: 454 to 455
function VRManagerPD2:has_set_height()
	return self._global.has_set_height
end

-- Lines: 458 to 481
function VRManagerPD2:set_setting(setting, value)
	if type(value) == "number" then
		local limits = self._limits[setting]

		if limits then
			value = math.clamp(value, limits.min, limits.max)
		end
	end

	if setting == "height" then
		self._global.has_set_height = true
	end

	local old_value = self._global[setting]
	self._global[setting] = value

	managers.savefile:setting_changed()
	managers.savefile:save_setting()

	local callback_handler = self._setting_callback_handler_map and self._setting_callback_handler_map[setting]

	if callback_handler then
		callback_handler:dispatch(setting, old_value, value)
	end
end

-- Lines: 483 to 485
function VRManagerPD2:reset_setting(setting)
	self:set_setting(setting, self._default[setting])
end

-- Lines: 487 to 488
function VRManagerPD2:get_setting(setting)
	return self._global[setting]
end

-- Lines: 491 to 492
function VRManagerPD2:walking_mode()
	return self:get_setting("movement_type") == "warp_walk"
end

-- Lines: 503 to 508
function VRManagerPD2:show_savefile_dialog()
	if not self._global.has_shown_savefile_dialog then
		managers.menu:show_vr_beta_savefile_dialog()

		self._global.has_shown_savefile_dialog = true
	end
end

