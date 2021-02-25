HUDBeltInteraction = HUDBeltInteraction or class()

-- Lines 4-8
local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

-- Lines 11-49
local function get_icon(icon_type)
	if icon_type == "primary" or icon_type == "secondary" then
		local prefix = "guis"
		local w_id = icon_type == "secondary" and managers.blackmarket:equipped_secondary().weapon_id or managers.blackmarket:equipped_primary().weapon_id
		local texture = "/textures/pd2/blackmarket/icons/weapons/outline/" .. w_id

		if not DB:has(Idstring("texture"), Idstring(prefix .. texture)) then
			if tweak_data.weapon[w_id] and tweak_data.weapon[w_id].texture_bundle_folder then
				prefix = "guis/dlcs/" .. tweak_data.weapon[w_id].texture_bundle_folder
			end

			if not DB:has(Idstring("texture"), Idstring(prefix .. texture)) then
				return "guis/textures/pd2/blackmarket/icons/weapons/outline/" .. (icon_type == "secondary" and "g26" or "amcar")
			end
		end

		return prefix .. texture
	elseif icon_type == "melee" then
		local w_id = managers.blackmarket:equipped_melee_weapon()
		local prefix = "guis"
		local texture = "/textures/pd2/blackmarket/icons/melee_weapons/outline/" .. w_id

		if not DB:has(Idstring("texture"), Idstring(prefix .. texture)) then
			prefix = "guis/dlcs/" .. tweak_data.blackmarket.melee_weapons[w_id].texture_bundle_folder
		end

		return prefix .. texture
	elseif icon_type == "deployable" or icon_type == "deployable_secondary" then
		local id = managers.player:equipment_in_slot(icon_type == "deployable" and 1 or 2)

		if not id then
			return "guis/textures/pd2/none_icon", "invalid"
		end

		return "guis/textures/pd2/blackmarket/icons/deployables/outline/" .. id
	elseif icon_type == "throwable" then
		return "guis/textures/pd2/blackmarket/icons/grenades/outline/" .. managers.blackmarket:equipped_grenade()
	elseif icon_type == "bag" then
		return "guis/dlcs/vr/textures/pd2/vr_belt_bag_default"
	elseif icon_type == "reload" then
		return "guis/textures/pd2/reload_icon", "inactive"
	end
end

-- Lines 51-58
local function scale_by_aspect(gui_obj, max_size)
	local w = gui_obj:texture_width()
	local h = gui_obj:texture_height()

	if h < w then
		gui_obj:set_size(max_size, max_size / w * h)
	else
		gui_obj:set_size(max_size / h * w, max_size)
	end
end

local PADDING = 40
local GRID_BOX = 100

-- Lines 65-67
function grid_position(x, y)
	return (x - 0.5) * GRID_BOX + PADDING, (y - 0.5) * GRID_BOX + PADDING
end

local Outline = Outline or class()

-- Lines 72-76
function Outline:init(panel)
	self._panel = panel
	self._box_gui = BoxGuiObject:new(panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})

	self._box_gui:set_layer(2)
end

-- Lines 78-81
function Outline:set_selected(selected)
	self._selected = selected

	self:recreate()
end

-- Lines 83-85
function Outline:selected()
	return self._selected
end

-- Lines 87-89
function Outline:set_alpha(alpha)
	self._box_gui:set_color(self._box_gui:color():with_alpha(alpha))
end

-- Lines 91-94
function Outline:recreate()
	local s = self._selected and 2 or 1

	self._box_gui:create_sides(self._panel, {
		sides = {
			s,
			s,
			s,
			s
		}
	})
end

HUDBeltInteraction.size = 160

-- Lines 100-165
function HUDBeltInteraction:init(ws, id, custom_icon_id)
	self._ws = ws
	self._id = id
	self._custom_icon_id = custom_icon_id
	self._panel = ws:panel():panel({
		name = "belt_" .. id
	})
	local custom_state = nil
	self._texture, custom_state = get_icon(custom_icon_id or id)
	self._icon = self._panel:bitmap({
		blend_mode = "add",
		valign = "scale",
		halign = "scale",
		texture = self._texture
	})
	self._w = self.size
	self._h = self.size
	self._grid_w = 1
	self._grid_h = 1

	self._panel:set_w(self._w)
	self._panel:set_h(self._h)
	scale_by_aspect(self._icon, math.min(self._h, self._w))
	self._icon:set_center(self._panel:w() / 2, self._panel:h() / 2)

	self._bg = self._panel:rect({
		valign = "scale",
		halign = "scale",
		rotation = 360,
		layer = -1,
		color = Color.black
	})
	self._bg_tint = self._panel:bitmap({
		blend_mode = "add",
		texture = "guis/dlcs/vr/textures/pd2/belt_active_fill",
		halign = "scale",
		visible = false,
		rotation = 360,
		valign = "scale",
		w = self._panel:w(),
		h = self._panel:h()
	})
	self._grip_text = self._panel:text({
		y = 10,
		halign = "center",
		visible = false,
		valign = "top",
		font = tweak_data.hud.medium_font_noshadow,
		font_size = tweak_data.hud.medium_default_font_size,
		text = managers.localization:to_upper_text("vr_belt_grip")
	})

	make_fine_text(self._grip_text)
	self._grip_text:set_center_x(self._w / 2)

	self._outline = Outline:new(self._panel)
	self._state = "default"
	self._alpha = 1
	self._alpha_diff = 0

	if custom_state then
		self:set_state(custom_state)
	end

	VRManagerPD2.overlay_helper(ws:panel())
end

-- Lines 167-172
function HUDBeltInteraction:update_icon()
	self._texture = get_icon(self._custom_icon_id or self._id)

	self._icon:set_image(self._texture)
	scale_by_aspect(self._icon, math.min(self._w, self._h))
	self._icon:set_center(self._panel:w() / 2, self._panel:h() / 2)
end

-- Lines 174-177
function HUDBeltInteraction:set_custom_icon_id(id)
	self._custom_icon_id = id

	self:update_icon()
end

-- Lines 179-203
function HUDBeltInteraction:set_amount(amount)
	if not self._amount_text then
		self._amount_text = self._panel:text({
			valign = "bottom",
			halign = "right",
			font = tweak_data.hud.medium_font_noshadow,
			font_size = tweak_data.hud.default_font_size
		})
	end

	if not amount then
		self._show_amount = false

		self._amount_text:set_visible(false)

		return
	end

	self._show_amount = true

	self._amount_text:set_text(tostring(amount))
	make_fine_text(self._amount_text)
	self._amount_text:set_right(self._panel:w() - 6)
	self._amount_text:set_bottom(self._panel:h() - 6)
	self._amount_text:set_color((amount > 0 and Color.white or Color.red):with_alpha(self._alpha + self._alpha_diff))
end

-- Lines 205-217
function HUDBeltInteraction:set_state(state)
	if not table.contains(HUDBelt.states, state) then
		Application:error("[HUDBeltInteraction:set_state] invalid state", state)

		return
	end

	self._panel:set_visible(state ~= "disabled")
	self._outline:set_selected(state == "active")
	self._icon:set_visible(state ~= "inactive")

	if self._amount_text then
		self._amount_text:set_visible(self._show_amount and state ~= "inactive")
	end

	self._bg_tint:set_visible(state == "active")

	self._state = state
end

-- Lines 219-221
function HUDBeltInteraction:state()
	return self._state
end

-- Lines 223-230
function HUDBeltInteraction:set_alpha(alpha)
	self._icon:set_color(self._icon:color():with_alpha(alpha))

	if self._amount_text then
		self._amount_text:set_color(self._amount_text:color():with_alpha(alpha + self._alpha_diff))
	end

	self._bg:set_color(self._bg:color():with_alpha(math.min(alpha + self._alpha_diff - 0.1, 0.6)))
	self._bg_tint:set_color(self._bg_tint:color():with_alpha((alpha + self._alpha_diff) * 2))
	self._outline:set_alpha(alpha * 2)

	self._alpha = alpha
end

local anim_speed = 1

-- Lines 234-256
function HUDBeltInteraction:_animate_size_alpha(o, size_ratio, alpha)
	local panel = self._panel

	if not alive(panel) then
		return
	end

	local current_ratio = panel:h() / self._h
	local cx, cy = panel:center()
	local flip = current_ratio < size_ratio and 1 or -1
	local alpha_comp_func = self._alpha_diff < alpha and math.min or math.max
	local new_ratio = current_ratio

	while flip > 0 and new_ratio < size_ratio or flip <= 0 and size_ratio < new_ratio do
		local dt = coroutine.yield()
		new_ratio = new_ratio + dt * anim_speed * flip

		panel:set_size(self._w * new_ratio, self._h * new_ratio)
		panel:set_center(cx, cy)

		self._alpha_diff = alpha_comp_func(self._alpha_diff + dt * anim_speed * flip * 2, alpha)
	end

	panel:set_size(self._w * size_ratio, self._h * size_ratio)
	panel:set_center(cx, cy)

	self._alpha_diff = alpha
end

-- Lines 258-269
function HUDBeltInteraction:set_selected(selected)
	if self._selected == selected then
		return
	end

	self._icon:stop()
	self._icon:animate(callback(self, self, "_animate_size_alpha"), selected and 1.2 or 1, selected and 0.3 or 0)

	self._selected = selected

	self._outline:set_selected(selected or self:state() == "active")
	self._bg_tint:set_visible(selected or self:state() == "active")
	self._grip_text:set_visible(selected)
end

-- Lines 271-280
function HUDBeltInteraction:set_other_selected(selected)
	if self._other_selected == selected then
		return
	end

	self._icon:stop()
	self._icon:animate(callback(self, self, "_animate_size_alpha"), selected and 0.8 or 1, selected and -0.3 or 0)

	self._other_selected = selected
end

-- Lines 282-302
function HUDBeltInteraction:start_timer(time, start_time)
	self:stop_timer()

	local w, h = self._panel:size()
	local size = math.min(w, h)
	local timer_circle = CircleBitmapGuiObject:new(self._panel, {
		image = "guis/textures/pd2/progress_reload",
		current = 1,
		total = 1,
		bg = "guis/textures/pd2/progress_reload_black",
		use_bg = true,
		blend_mode = "normal",
		layer = 2,
		radius = size / 2,
		sides = size / 2,
		color = Color.white
	})

	timer_circle:set_position(w / 2 - size / 2, h / 2 - size / 2)
	timer_circle:set_align("scale")
	self._panel:animate(function (o)
		if not alive(o) or not alive(timer_circle._circle) then
			return
		end

		local current = start_time or 0

		while current < time do
			current = math.min(current + coroutine.yield(), time)
			local p = current / time

			timer_circle:set_current(p)
		end

		timer_circle:remove()
	end)

	self._timer_circle = timer_circle
end

-- Lines 304-311
function HUDBeltInteraction:stop_timer()
	if not self._timer_circle or not alive(self._timer_circle._panel) then
		return
	end

	self._timer_circle._panel:stop()
	self._timer_circle:remove()
end

-- Lines 313-316
function HUDBeltInteraction:set_grid_position(gx, gy)
	local x, y = grid_position(gx, gy)

	self:set_center(x, y)
end

-- Lines 318-356
function HUDBeltInteraction:set_invalid_overlay(visible)
	if visible then
		if self._invalid_overlay then
			return
		end

		self._invalid_overlay = self._panel:panel({
			halign = "scale",
			name = "invalid_overlay",
			valign = "scale",
			layer = 2
		})

		self._invalid_overlay:rect({
			name = "bg",
			valign = "scale",
			halign = "scale",
			color = tweak_data.screen_colors.important_1:with_alpha(0.3)
		})

		local text = self._invalid_overlay:text({
			y = 20,
			name = "text",
			halign = "center",
			valign = "top",
			color = tweak_data.screen_colors.important_1,
			font = tweak_data.hud.medium_font,
			font_size = tweak_data.hud.medium_default_font_size,
			text = managers.localization:to_upper_text("menu_vr_belt_invalid_position")
		})

		make_fine_text(text)
		text:set_center_x(self._invalid_overlay:w() / 2)
	else
		if not self._invalid_overlay then
			return
		end

		self._panel:remove(self._invalid_overlay)

		self._invalid_overlay = nil
	end
end

-- Lines 358-385
function HUDBeltInteraction:add_help_text(id, text_id, location)
	self._help_texts = self._help_texts or {}

	if self._help_texts[id] then
		return
	end

	local text = self._panel:text({
		halign = "center",
		rotation = 360,
		valign = "center",
		name = id,
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.medium_default_font_size,
		text = managers.localization:to_upper_text(text_id)
	})

	make_fine_text(text)
	text:set_center_x(self._panel:w() / 2)

	if location == "above" then
		text:set_bottom(-10)
	elseif location == "below" then
		text:set_y(self._panel:h() + 10)
	else
		text:set_bottom(self._panel:h() - 10)
	end

	self._help_texts[id] = text
end

-- Lines 387-392
function HUDBeltInteraction:remove_help_text(id)
	if self._help_texts and self._help_texts[id] then
		self._panel:remove(self._help_texts[id])

		self._help_texts[id] = nil
	end
end

-- Lines 394-404
function HUDBeltInteraction:clear_help_texts()
	if not self._help_texts then
		return
	end

	for _, text in pairs(self._help_texts) do
		self._panel:remove(text)
	end

	self._help_texts = nil
end

-- Lines 406-416
function HUDBeltInteraction:set_edit_mode(enabled)
	local align = nil

	if enabled then
		align = "center"
	else
		align = "scale"
	end

	self._icon:set_halign(align)
	self._icon:set_valign(align)
end

-- Lines 418-436
function HUDBeltInteraction:set_grid_size(w, h)
	if self._grid_w == w and self._grid_h == h then
		return
	end

	self._grid_w = w
	self._grid_h = h
	self._w = self.size * w + PADDING * (w - 1)
	self._h = self.size * h + PADDING * (h - 1)

	self:set_edit_mode(true)

	local x, y = self._panel:center()

	self._panel:set_size(self._w, self._h)
	self._panel:set_center(x, y)
	self._outline:recreate()
	self:set_edit_mode(false)
	self:update_icon()
end

-- Lines 438-440
function HUDBeltInteraction:grid_size()
	return self._grid_w, self._grid_h
end

-- Lines 442-444
function HUDBeltInteraction:get_size()
	return self._w, self._h
end

-- Lines 446-446
function HUDBeltInteraction:set_x(x)
	self._panel:set_x(x)
end

-- Lines 447-447
function HUDBeltInteraction:set_y(y)
	self._panel:set_y(y)
end

-- Lines 448-448
function HUDBeltInteraction:set_right(right)
	self._panel:set_right(right)
end

-- Lines 449-449
function HUDBeltInteraction:set_bottom(bottom)
	self._panel:set_bottom(bottom)
end

-- Lines 450-450
function HUDBeltInteraction:set_center(x, y)
	self._panel:set_center(x, y)
end

-- Lines 451-451
function HUDBeltInteraction:x()
	return self._panel:x()
end

-- Lines 452-452
function HUDBeltInteraction:y()
	return self._panel:y()
end

-- Lines 453-453
function HUDBeltInteraction:right()
	return self._panel:right()
end

-- Lines 454-454
function HUDBeltInteraction:bottom()
	return self._panel:bottom()
end

-- Lines 455-455
function HUDBeltInteraction:center()
	return self._panel:center()
end

-- Lines 456-456
function HUDBeltInteraction:lefttop()
	return self._panel:lefttop()
end

-- Lines 457-457
function HUDBeltInteraction:leftbottom()
	return self._panel:leftbottom()
end

-- Lines 458-458
function HUDBeltInteraction:righttop()
	return self._panel:righttop()
end

-- Lines 459-459
function HUDBeltInteraction:rightbottom()
	return self._panel:rightbottom()
end

-- Lines 460-460
function HUDBeltInteraction:position()
	return self._panel:position()
end

-- Lines 461-461
function HUDBeltInteraction:inside(x, y)
	return self._panel:inside(x, y)
end

-- Lines 462-462
function HUDBeltInteraction:ws()
	return self._ws
end

HUDBeltInteractionReload = HUDBeltInteractionReload or class(HUDBeltInteraction)

-- Lines 468-484
function HUDBeltInteractionReload:init(ws, id)
	HUDBeltInteractionReload.super.init(self, ws, id)

	self._ammo_text = self._panel:text({
		text = "0/0",
		visible = false,
		halign = "center",
		valign = "bottom",
		font = tweak_data.hud.medium_font,
		font_size = tweak_data.hud.default_font_size
	})

	make_fine_text(self._ammo_text)
	self._ammo_text:set_center_x(self._w / 2)
	self._ammo_text:set_bottom(self._h)
end

-- Lines 486-492
function HUDBeltInteractionReload:set_alpha(alpha)
	if self._waiting_for_trigger then
		alpha = 0.6
	end

	HUDBeltInteractionReload.super.set_alpha(self, alpha)
	self._ammo_text:set_color(self._ammo_text:color():with_alpha(alpha + self._alpha_diff + 0.2))
end

-- Lines 494-516
function HUDBeltInteractionReload:_reload_animate(o, time, clip_start, clip_full)
	local ammo_text = self._ammo_text

	ammo_text:set_text(tostring(clip_start) .. "/" .. tostring(clip_full))
	make_fine_text(ammo_text)
	ammo_text:show()

	local inc = clip_full - clip_start

	over(time, function (p)
		ammo_text:set_text(tostring(math.floor(clip_start + inc * p)) .. "/" .. tostring(clip_full))
		make_fine_text(ammo_text)
		ammo_text:set_center_x(self._panel:w() / 2)
	end)
	ammo_text:set_text(tostring(clip_full) .. "/" .. tostring(clip_full))

	self._waiting_for_trigger = true
	local bg_val = 0

	while self._waiting_for_trigger do
		local dt = coroutine.yield()
		bg_val = bg_val + dt * 360
		local val = math.abs(math.sin(bg_val))

		self._bg:set_color(Color(val, val, val))
	end

	self._bg:set_color(Color.black)
end

-- Lines 518-521
function HUDBeltInteractionReload:start_reload(time, clip_start, clip_full)
	self:start_timer(time)
	self._panel:animate(callback(self, self, "_reload_animate"), time, clip_start, clip_full)
end

-- Lines 523-527
function HUDBeltInteractionReload:trigger_reload()
	self._waiting_for_trigger = nil

	self._ammo_text:hide()
	self:stop_timer()
end

HUDBelt = HUDBelt or class()
HUDBelt.LEFT = 1
HUDBelt.RIGHT = 2
HUDBelt.interactions = {
	"deployable",
	"bag",
	"throwable",
	"weapon",
	"melee",
	"reload"
}
HUDBelt.states = {
	"default",
	"active",
	"inactive",
	"invalid",
	"disabled"
}
HUDBelt.GRID_WIDTH = 13
HUDBelt.GRID_HEIGHT = 8

-- Lines 554-614
function HUDBelt:init(ws)
	self._ws = ws
	self._panel = ws:panel()
	self._interactions = {}
	local bag = HUDBeltInteraction:new(ws, "bag")

	bag:set_state("inactive")

	self._interactions.bag = bag
	local melee = HUDBeltInteraction:new(ws, "melee")
	self._interactions.melee = melee
	local deployable = HUDBeltInteraction:new(ws, "deployable")
	self._interactions.deployable = deployable
	local deployable_secondary = HUDBeltInteraction:new(ws, "deployable_secondary")
	self._interactions.deployable_secondary = deployable_secondary

	if not managers.player:equipment_in_slot(2) then
		self:set_state("deployable_secondary", "disabled")
	end

	local weapon = HUDBeltInteraction:new(ws, "weapon", "primary")
	self._interactions.weapon = weapon
	local throwable = HUDBeltInteraction:new(ws, "throwable")
	self._interactions.throwable = throwable
	local reload = HUDBeltInteractionReload:new(ws, "reload")
	self._interactions.reload = reload

	if managers.vr:get_setting("auto_reload") then
		self:set_state("reload", "disabled")
	end

	self._reload_setting_clbk = callback(self, self, "_reload_setting_changed")

	managers.vr:add_setting_changed_callback("auto_reload", self._reload_setting_clbk)

	self._primary_hand_clbk = callback(self, self, "_primary_hand_changed")

	managers.vr:add_setting_changed_callback("default_weapon_hand", self._primary_hand_clbk)

	self._grid_layout_clbk = callback(self, self, "_grid_layout_changed")

	managers.vr:add_setting_changed_callback("belt_layout", self._grid_layout_clbk)

	self._grid_box_sizes_clbk = callback(self, self, "_grid_box_sizes_changed")

	managers.vr:add_setting_changed_callback("belt_box_sizes", self._grid_box_sizes_clbk)

	if not self:verify_belt_ids(managers.vr:get_setting("belt_layout")) or not self:verify_belt_ids(managers.vr:get_setting("belt_box_sizes")) then
		managers.vr:reset_setting("belt_layout")
		managers.vr:reset_setting("belt_box_sizes")
	end

	self:layout_grid(managers.vr:get_setting("belt_layout"))
	self:set_box_sizes(managers.vr:get_setting("belt_box_sizes"))
end

-- Lines 616-623
function HUDBelt:verify_belt_ids(layout)
	for id, _ in pairs(layout) do
		if not self._interactions[id] then
			return false
		end
	end

	return true
end

-- Lines 625-630
function HUDBelt:destroy()
	managers.vr:remove_setting_changed_callback("auto_reload", self._reload_setting_clbk)
	managers.vr:remove_setting_changed_callback("default_weapon_hand", self._primary_hand_clbk)
	managers.vr:remove_setting_changed_callback("belt_layout", self._grid_layout_clbk)
	managers.vr:remove_setting_changed_callback("belt_box_sizes", self._grid_box_sizes_clbk)
end

-- Lines 632-670
function HUDBelt:set_grid_display(display)
	if display == not not self._grid_display_panel then
		return
	end

	if display then
		self._grid_display_panel = self._panel:panel()

		for gx = 1, HUDBelt.GRID_WIDTH do
			for gy = 1, HUDBelt.GRID_HEIGHT do
				local x, y = grid_position(gx, gy)

				self._grid_display_panel:rect({
					h = 10,
					w = 10,
					name = "dot_" .. tostring(gx) .. "_" .. tostring(gy),
					x = x - 5,
					y = y - 5,
					color = Color.white:with_alpha(0.5)
				})
			end
		end

		for id, interaction in pairs(self._interactions) do
			if interaction:state() == "disabled" then
				self._temp_enabled = self._temp_enabled or {}

				table.insert(self._temp_enabled, id)
				interaction:set_state("default")
			end
		end
	else
		if self._temp_enabled then
			for _, id in ipairs(self._temp_enabled) do
				self:set_state(id, "disabled")
			end

			self._temp_enabled = nil
		end

		self._panel:remove(self._grid_display_panel)

		self._grid_display_panel = nil
	end
end

-- Lines 672-674
function HUDBelt:_reload_setting_changed(setting, old_value, new_value)
	self:set_state("reload", new_value and "disabled" or "inactive")
end

-- Lines 676-678
function HUDBelt:_primary_hand_changed(setting, old_value, new_value)
end

-- Lines 680-682
function HUDBelt:_grid_layout_changed(setting, old_value, new_value)
	self:layout_grid(new_value)
end

-- Lines 684-686
function HUDBelt:_grid_box_sizes_changed(setting, old_value, new_value)
	self:set_box_sizes(new_value)
end

-- Lines 689-693
function HUDBelt:layout_grid(layout)
	for id, positions in pairs(layout) do
		self:set_grid_position(id, unpack(positions))
	end
end

-- Lines 695-699
function HUDBelt:set_box_sizes(sizes)
	for id, size in pairs(sizes) do
		self:set_grid_size(id, unpack(size))
	end
end

-- Lines 701-709
function HUDBelt:set_grid_position(id, x, y)
	local interaction = self._interactions[id]

	if not interaction then
		debug_pause("[HUDBelt:set_grid_position] invalid ID", id)
	end

	interaction:set_grid_position(x, y)
	interaction:set_invalid_overlay(false)
end

-- Lines 711-719
function HUDBelt:get_interaction_point(id)
	local interaction = self._interactions[id]

	if not interaction then
		debug_pause("[HUDBelt:get_interaction_point] invalid ID", id)
	end

	local x, y = interaction:center()

	return interaction:ws():local_to_world(Vector3(x, y, 0))
end

-- Lines 721-742
function HUDBelt:get_closest_interaction(pos, limit, allow_invalid)
	local closest_id, closest_dis, interactions = nil

	if allow_invalid then
		interactions = {}

		for id in pairs(self._interactions) do
			table.insert(interactions, id)
		end
	else
		interactions = self:valid_interactions()
	end

	for _, id in ipairs(interactions) do
		local interact_pos = self:get_interaction_point(id)
		local dis = mvector3.distance_sq(pos, interact_pos)

		if (not closest_dis or dis < closest_dis) and (not limit or dis < limit) then
			closest_dis = dis
			closest_id = id
		end
	end

	return closest_id, closest_dis
end

-- Lines 747-762
function HUDBelt:move_interaction(id, pos, snap_to_grid)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:move_interaction] invalid ID", id)

		return
	end

	if snap_to_grid then
		local x = math.round(pos.x / GRID_BOX)
		local y = math.round(pos.y / GRID_BOX)

		interaction:set_grid_position(x, y)
		interaction:set_invalid_overlay(not self:valid_grid_location(id))
	else
		interaction:set_center(pos.x, pos.y)
	end
end

-- Lines 764-781
function HUDBelt:resize_interaction(id, edge_pos)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:resize_interaction] invalid ID", id)

		return
	end

	local cx, cy = interaction:center()
	local w = math.floor((edge_pos.x - cx) / GRID_BOX)
	local h = math.floor((edge_pos.y - cy) / GRID_BOX)

	if w < 1 then
		w = math.abs(w) + 1
	end

	if h < 1 then
		h = math.abs(h) + 1
	end

	if w < 4 and h < 4 then
		interaction:set_grid_size(w, h)
	end

	interaction:set_invalid_overlay(not self:valid_grid_location(id))
end

-- Lines 783-794
function HUDBelt:pos_on_grid(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:pos_on_grid] invalid ID", id)

		return
	end

	local x, y = interaction:center()
	x = math.round(x / GRID_BOX)
	y = math.round(y / GRID_BOX)

	return x, y
end

-- Lines 796-826
function HUDBelt:valid_grid_location(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:valid_grid_location] invalid ID", id)

		return
	end

	for other_id, other_interaction in pairs(self._interactions) do
		if other_id ~= id and (other_interaction:inside(interaction:lefttop()) or other_interaction:inside(interaction:leftbottom()) or other_interaction:inside(interaction:righttop()) or other_interaction:inside(interaction:rightbottom()) or interaction:inside(other_interaction:lefttop()) or interaction:inside(other_interaction:leftbottom()) or interaction:inside(other_interaction:righttop()) or interaction:inside(other_interaction:rightbottom())) then
			return false
		end
	end

	if not self._panel:inside(interaction:lefttop()) or not self._panel:inside(interaction:leftbottom()) or not self._panel:inside(interaction:righttop()) or not self._panel:inside(interaction:rightbottom()) then
		return false
	end

	return true
end

-- Lines 831-836
function HUDBelt:set_visible(visible)
	self._ws[visible and "show" or "hide"](self._ws)
end

-- Lines 838-840
function HUDBelt:visible()
	return self._ws:visible()
end

-- Lines 842-858
function HUDBelt:set_state(id, state)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:set_state] invalid ID", id)

		return
	end

	if not table.contains(self.states, state) then
		Application:error("[HUDBelt:set_state] invalid state", state)

		return
	end

	interaction:set_state(state)

	self._cached_interactions = nil
end

-- Lines 860-868
function HUDBelt:state(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:state] invalid ID", id)

		return
	end

	return interaction:state()
end

-- Lines 870-883
function HUDBelt:valid_interactions()
	if self._cached_interactions then
		return self._cached_interactions
	end

	local interactions = {}

	for k, interaction in pairs(self._interactions) do
		if interaction:state() ~= "inactive" and interaction:state() ~= "invalid" and interaction:state() ~= "disabled" then
			table.insert(interactions, k)
		end
	end

	self._cached_interactions = interactions

	return interactions
end

-- Lines 885-891
function HUDBelt:interactions()
	local interactions = {}

	for id in pairs(self._interactions) do
		table.insert(interactions, id)
	end

	return interactions
end

-- Lines 894-908
function HUDBelt:set_alpha(alpha, id)
	if id then
		local interaction = self._interactions[id]

		if not interaction then
			Application:error("[HUDBelt:set_alpha] invalid ID", id)

			return
		end

		interaction:set_alpha(alpha)
	else
		for _, interaction in pairs(self._interactions) do
			interaction:set_alpha(alpha)
		end
	end
end

-- Lines 910-924
function HUDBelt:set_selected(id, selected)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:set_selected] invalid ID", id)

		return
	end

	for interaction_id, interaction in pairs(self._interactions) do
		if interaction_id == id then
			interaction:set_selected(selected)
		else
			interaction:set_other_selected(selected)
		end
	end
end

-- Lines 926-934
function HUDBelt:update_icon(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:update_icon] invalid ID", id)

		return
	end

	interaction:update_icon()
end

-- Lines 936-940
function HUDBelt:update_icons()
	for _, interaction in pairs(self._interactions) do
		interaction:update_icon()
	end
end

-- Lines 942-950
function HUDBelt:set_amount(id, amount)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:set_amount] invalid ID", id)

		return
	end

	interaction:set_amount(amount)
end

-- Lines 952-960
function HUDBelt:start_timer(id, time, start_time)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:start_timer] invalid ID", id)

		return
	end

	interaction:start_timer(time, start_time)
end

-- Lines 962-970
function HUDBelt:stop_timer(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:stop_timer] invalid ID", id)

		return
	end

	interaction:stop_timer()
end

-- Lines 972-975
function HUDBelt:start_reload(time, clip_start, clip_full)
	self._interactions.reload:start_reload(time, clip_start, clip_full)
	self:set_state("reload", "default")
end

-- Lines 977-980
function HUDBelt:trigger_reload()
	self._interactions.reload:trigger_reload()
	self:set_state("reload", managers.vr:get_setting("auto_reload") and "disabled" or "inactive")
end

-- Lines 982-990
function HUDBelt:set_icon_by_type(id, icon_id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:set_icon_by_type] invalid ID", id)

		return
	end

	interaction:set_custom_icon_id(icon_id)
end

-- Lines 992-1000
function HUDBelt:add_help_text(id, help_id, text_id, location)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:add_help_text] invalid ID", id)

		return
	end

	interaction:add_help_text(help_id, text_id, location)
end

-- Lines 1002-1010
function HUDBelt:remove_help_text(id, help_id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:remove_help_text] invalid ID", id)

		return
	end

	interaction:remove_help_text(help_id)
end

-- Lines 1012-1026
function HUDBelt:clear_help_texts(id)
	if id then
		local interaction = self._interactions[id]

		if not interaction then
			Application:error("[HUDBelt:clear_help_texts] invalid ID", id)

			return
		end

		interaction:clear_help_texts()
	else
		for _, interaction in pairs(self._interactions) do
			interaction:clear_help_texts()
		end
	end
end

-- Lines 1028-1036
function HUDBelt:set_grid_size(id, w, h)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:set_grid_size] invalid ID", id)

		return
	end

	interaction:set_grid_size(w, h)
end

-- Lines 1038-1046
function HUDBelt:grid_size(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:grid_size] invalid ID", id)

		return
	end

	return interaction:grid_size()
end

-- Lines 1048-1064
function HUDBelt:world_pos(id, pos_type)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:world_pos] invalid ID", id)

		return
	end

	pos_type = pos_type or "center"

	if type(interaction[pos_type]) ~= "function" then
		Application:error("[HUDBelt:world_pos] invalid position type", pos_type)

		return
	end

	local x, y = interaction[pos_type](interaction)

	return self._ws:local_to_world(Vector3(x, y))
end

-- Lines 1066-1076
function HUDBelt:world_size(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:world_size] invalid ID", id)

		return
	end

	local pos = self._ws:local_to_world(Vector3(interaction:lefttop()))
	local edge = self._ws:local_to_world(Vector3(interaction:rightbottom()))

	return edge - pos
end

-- Lines 1078-1088
function HUDBelt:world_radius(id)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:world_size] invalid ID", id)

		return
	end

	local center = self._ws:local_to_world(Vector3(interaction:center()))
	local edge = self._ws:local_to_world(Vector3(interaction:rightbottom()))

	return edge - center
end

-- Lines 1090-1101
function HUDBelt:interacting(id, world_pos)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:interacting] invalid ID", id)

		return
	end

	local local_pos = self._ws:world_to_local(world_pos)

	if interaction:inside(local_pos.x, local_pos.y) then
		return true
	end
end
