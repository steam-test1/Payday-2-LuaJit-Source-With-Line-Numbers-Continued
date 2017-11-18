require("lib/utils/VRLoadingEnvironment")

VRManagerPD2 = VRManagerPD2 or class()
VRManagerPD2.DISABLE_ADAPTIVE_QUALITY = false

-- Lines: 6 to 93
function VRManagerPD2:init()
	print("[VRManagerPD2] init")

	if not PackageManager:loaded("packages/vr_base") then
		PackageManager:load("packages/vr_base")
	end

	VRManager:set_max_adaptive_levels(7)
	VRManager:set_present_post_processor(Idstring("core/shaders/render_to_backbuffer"), Idstring("stretch_copy"))

	local tres = VRManager:target_resolution()
	local rres = VRManager:recommended_target_resolution()
	self._adaptive_scale = {}
	local scale = {
		0.85,
		0.9,
		1,
		1.1,
		1.2,
		1.3,
		1.4
	}

	for _, scaling in ipairs(scale) do
		local x_scale = scaling / 1.4
		local res_x = math.floor(tres.x * x_scale)

		if res_x % 2 > 0.01 then
			res_x = res_x + 1
		end

		x_scale = res_x / tres.x
		local y_scale = scaling / 1.4
		local res_y = math.floor(tres.y * y_scale)

		if res_y % 2 > 0.01 then
			res_y = res_y + 1
		end

		y_scale = res_y / tres.y

		table.insert(self._adaptive_scale, {
			x_scale,
			y_scale
		})
	end

	self._default = {
		belt_height_ratio = 0.6,
		height = 140,
		default_weapon_hand = "right",
		belt_snap = 72,
		autowarp_length = "long",
		auto_reload = true,
		weapon_switch_button = false,
		zipline_screen = true,
		default_tablet_hand = "left"
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
		belt_snap = {
			max = 360,
			min = 0
		}
	}

	if not Global.vr then
		Global.vr = {}
	end

	self._global = Global.vr

	for setting, default in pairs(self._default) do
		if self._global[setting] == nil then
			self._global[setting] = default
		end
	end

	self._vr_loading_environment = VRLoadingEnvironment:new()
	self._force_disable_low_adaptive_quality = false

	MenuRoom:load("units/pd2_dlc_vr/menu/vr_menu_mini", false)
end

-- Lines: 95 to 116
function VRManagerPD2:init_finalize()
	print("[VRManagerPD2] init_finalize")

	if game_state_machine:is_boot_intro_done() then
		self._vr_loading_environment:stop()
	else
		self._vr_loading_environment:start()
	end

	self._adaptive_quality_setting_changed_clbk = callback(self, self, "_on_adaptive_quality_setting_changed")

	managers.user:add_setting_changed_callback("adaptive_quality", self._adaptive_quality_setting_changed_clbk)

	self._use_adaptive_quality = managers.user:get_setting("adaptive_quality")
end

-- Lines: 118 to 148
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

-- Lines: 150 to 153
function VRManagerPD2:force_start_loading()
	print("[VRManagerPD2] Force start loading")
	self._vr_loading_environment:force_start()
end

-- Lines: 155 to 158
function VRManagerPD2:start_loading()
	print("[VRManagerPD2] Start loading")
	self._vr_loading_environment:start()
end

-- Lines: 160 to 163
function VRManagerPD2:start_end_screen()
	print("[VRManagerPD2] Start end screen")
	self._vr_loading_environment:start("end")
end

-- Lines: 165 to 168
function VRManagerPD2:stop_loading()
	print("[VRManagerPD2] Stop loading")
	self._vr_loading_environment:stop()
end

-- Lines: 170 to 173
function VRManagerPD2:destroy()
	managers.user:remove_setting_changed_callback("adaptive_quality", self._adaptive_quality_setting_changed_clbk)
	print("[VRManagerPD2] destroy")
end

-- Lines: 178 to 182
function VRManagerPD2:update(t, dt)
	self:_update_adaptive_quality_level()
	self._vr_loading_environment:update(t, dt)
end

-- Lines: 184 to 187
function VRManagerPD2:paused_update(t, dt)
	self:_update_adaptive_quality_level()
	self._vr_loading_environment:update(t, dt)
end

-- Lines: 206 to 207
function VRManagerPD2:end_update(t, dt)
end

-- Lines: 213 to 214
function VRManagerPD2:render()
end

-- Lines: 216 to 218
function VRManagerPD2:set_hand_state_machine(hsm)
	self._hsm = hsm
end

-- Lines: 220 to 221
function VRManagerPD2:hand_state_machine()
	return self._hsm
end

-- Lines: 224 to 226
function VRManagerPD2:_on_adaptive_quality_setting_changed(setting, old, new)
	self._use_adaptive_quality = new
end

-- Lines: 228 to 230
function VRManagerPD2:set_force_disable_low_adaptive_quality(disable)
	self._force_disable_low_adaptive_quality = disable
end

-- Lines: 233 to 259
function VRManagerPD2:_update_adaptive_quality_level()
	local quality_level = self._use_adaptive_quality and VRManager:adaptive_level() + 1 or 3

	if self._force_disable_low_adaptive_quality then
		quality_level = math.max(quality_level, 3)
	end

	local scaling = self._adaptive_scale[quality_level]
	local x_scale = scaling[1]
	local y_scale = scaling[2]

	VRManager:set_output_scaling(x_scale, y_scale)
	managers.overlay_effect:viewport():set_dimensions(0, 0, x_scale, y_scale)

	for _, svp in ipairs(managers.viewport:all_really_active_viewports()) do
		if svp:use_adaptive_quality() then
			svp:vp():set_dimensions(0, 0, x_scale, y_scale)
		end
	end
end

-- Lines: 261 to 262
function VRManagerPD2:block_exec()
	return self._vr_loading_environment:block_exec()
end

-- Lines: 269 to 284
function VRManagerPD2:save(data)
	data.vr = {}

	for setting in pairs(self._default) do
		data.vr[setting] = self._global[setting]
	end

	data.vr.has_set_height = self._global.has_set_height
	data.vr.has_shown_savefile_dialog = self._global.has_shown_savefile_dialog
end

-- Lines: 291 to 310
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

-- Lines: 314 to 318
function VRManagerPD2:add_setting_changed_callback(setting, callback)
	self._setting_callback_handler_map = self._setting_callback_handler_map or {}
	self._setting_callback_handler_map[setting] = self._setting_callback_handler_map[setting] or CoreEvent.CallbackEventHandler:new()

	self._setting_callback_handler_map[setting]:add(callback)
end

-- Lines: 320 to 326
function VRManagerPD2:remove_setting_changed_callback(setting, callback)
	self._setting_callback_handler_map = self._setting_callback_handler_map or {}
	self._setting_callback_handler_map[setting] = self._setting_callback_handler_map[setting]

	if self._setting_callback_handler_map[setting] then
		self._setting_callback_handler_map[setting]:remove(callback)
	end
end

-- Lines: 330 to 335
function VRManagerPD2:setting_limits(setting)
	local limits = self._limits[setting]

	if limits then
		return limits.min, limits.max
	end
end

-- Lines: 339 to 340
function VRManagerPD2:has_set_height()
	return self._global.has_set_height
end

-- Lines: 343 to 366
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

-- Lines: 368 to 370
function VRManagerPD2:reset_setting(setting)
	self:set_setting(setting, self._default[setting])
end

-- Lines: 372 to 373
function VRManagerPD2:get_setting(setting)
	return self._global[setting]
end

-- Lines: 384 to 389
function VRManagerPD2:show_savefile_dialog()
	if not self._global.has_shown_savefile_dialog then
		managers.menu:show_vr_beta_savefile_dialog()

		self._global.has_shown_savefile_dialog = true
	end
end

