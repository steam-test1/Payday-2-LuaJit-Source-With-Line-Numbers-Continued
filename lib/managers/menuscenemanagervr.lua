MenuSceneManagerVR = MenuSceneManager or Application:error("MenuSceneManagerVR requires MenuSceneManager!")
local __init = MenuSceneManager.init
local __update = MenuSceneManager.update
local __destroy = MenuSceneManager.destroy
local ids_unit = Idstring("unit")

-- Lines 12-16
function MenuSceneManagerVR:init()
	__init(self)
	print("[MenuSceneManagerVR] Init")
	self:_use_environment("standard")
end

-- Lines 18-20
function MenuSceneManagerVR:destroy()
	__destroy(self)
end

-- Lines 22-23
function MenuSceneManagerVR:_set_dimensions()
end

-- Lines 25-26
function MenuSceneManagerVR:_set_camera_position()
end

-- Lines 28-29
function MenuSceneManagerVR:_set_target_position()
end

-- Lines 31-32
function MenuSceneManagerVR:mouse_pressed()
end

-- Lines 34-36
function MenuSceneManagerVR:character_screen_position()
	return Vector3(0, 0, 0)
end

-- Lines 38-48
function MenuSceneManagerVR:setup_camera()
	self._camera_values = {
		camera_pos_current = Vector3(0, 0, 0),
		camera_pos_target = Vector3(0, 0, 0),
		target_pos_current = Vector3(0, 0, 0),
		target_pos_target = Vector3(0, 0, 0),
		fov_current = 0,
		fov_target = 0
	}
	self._camera_object = managers.menu:player():camera()

	self:_use_environment("standard")
end

-- Lines 50-53
function MenuSceneManagerVR:update(t, dt)
	self:_update_vr(t, dt)
	__update(self, t, dt)
end

-- Lines 55-57
function MenuSceneManagerVR:_update_vr(t, dt)
end

-- Lines 59-72
function MenuSceneManagerVR:_setup_bg()
	self._bg_unit = managers.menu:menu_unit()

	self:set_character(managers.blackmarket:get_preferred_character())

	if alive(self._character_unit) then
		self._character_unit:set_position(Vector3(0, 0, -500))
	end

	self:_setup_lobby_characters()
	self:_setup_henchmen_characters()
end

-- Lines 74-91
function MenuSceneManagerVR:_set_up_environments()
	self._environments = {
		standard = {}
	}
	self._environments.standard.environment = "environments/pd2_menu_vr/pd2_menu_vr"
	self._environments.standard.color_grading = "color_off"
	self._environments.standard.angle = 0
	self._environments.safe = {
		environment = "environments/pd2_menu_vr/pd2_menu_vr",
		color_grading = "color_off",
		angle = 0
	}
	self._environments.crafting = {
		environment = "environments/pd2_menu_vr/pd2_menu_vr",
		color_grading = "color_off",
		angle = 0
	}
end

-- Lines 94-177
function MenuSceneManagerVR:_set_up_templates()
	local ref = self._bg_unit:get_object(Idstring("a_camera_reference"))
	local c_ref = self._bg_unit:get_object(Idstring("a_reference"))
	local target_pos = Vector3(0, 0, ref:position().z)
	local offset = Vector3(ref:position().x, ref:position().y, 0)
	self._scene_templates = {
		standard = {}
	}
	self._scene_templates.standard.use_character_grab = false
	self._scene_templates.standard.character_visible = true
	self._scene_templates.standard.camera_pos = ref:position()
	self._scene_templates.standard.target_pos = target_pos
	self._scene_templates.standard.character_pos = c_ref:position()
	self._scene_templates.standard.disable_item_updates = true
	self._scene_templates.title = {
		use_character_grab = false,
		character_visible = false,
		camera_pos = ref:position(),
		target_pos = target_pos,
		character_pos = Vector3(0, 0, -500),
		disable_item_updates = true
	}
	local cloned_templates = {
		"blackmarket",
		"blackmarket_mask",
		"blackmarket_item",
		"character_customization",
		"play_online",
		"options",
		"lobby",
		"lobby1",
		"lobby2",
		"lobby3",
		"lobby4",
		"inventory",
		"blackmarket_crafting",
		"blackmarket_weapon_color",
		"safe",
		"blackmarket_customize",
		"blackmarket_character",
		"blackmarket_customize_armour",
		"blackmarket_armor",
		"blackmarket_screenshot",
		"crime_spree_lobby",
		"crew_management",
		"blackmarket_item",
		"movie_theater"
	}

	for _, template in ipairs(cloned_templates) do
		self._scene_templates[template] = deep_clone(self._scene_templates.standard)
	end

	self._scene_templates.lobby.character_visible = false
	self._scene_templates.crew_management.henchmen_characters_visible = true
	self._scene_templates.lobby_vr = deep_clone(self._scene_templates.lobby)
	self._scene_templates.lobby_vr.lobby_characters_visible = true
	self._scene_templates.safe.character_visible = false
	self._scene_templates.calibrate = deep_clone(self._scene_templates.standard)
	self._scene_templates.calibrate.character_pos = Vector3(-350, 0, 0)
	self._scene_templates.calibrate.character_rot = Rotation(-90, 0, 0)
	self._scene_templates.allow_item = false
	local item_templates = {
		"blackmarket_item",
		"blackmarket_mask",
		"blackmarket_crafting",
		"blackmarket_weapon_color"
	}

	for _, template in ipairs(item_templates) do
		self._scene_templates[template].allow_item = true
	end
end

local __set_lobby_character_out_fit = MenuSceneManager.set_lobby_character_out_fit

-- Lines 180-188
function MenuSceneManagerVR:set_lobby_character_out_fit(i, outfit_string, rank)
	__set_lobby_character_out_fit(self, i, outfit_string, rank)

	local unit = self._lobby_characters[i]
	local is_me = i == managers.network:session():local_peer():id()
	local pos = Vector3(500 - (is_me and 100 or 0), 50 - i * 75, 0)

	unit:set_position(pos)
	unit:set_rotation(Rotation:look_at(Vector3(0, 100, 0) - pos, math.UP))
end

local __set_item_unit = MenuSceneManager._set_item_unit

-- Lines 191-213
function MenuSceneManagerVR:_set_item_unit(unit, oobb_object, max_mod, type, second_unit, custom_data)
	__set_item_unit(self, unit, oobb_object, max_mod, type, second_unit, custom_data)

	local player = managers.menu:player()
	local hand_unit = player:hand(3 - (player:primary_hand_index() or 1)):unit()

	hand_unit:link(Idstring("g_glove"), unit, unit:orientation_object():name())

	if custom_data and custom_data.id then
		local offset = tweak_data.vr:get_offset_by_id(custom_data.id)

		if offset.position then
			unit:set_local_position(offset.position)
		end

		if offset.rotation then
			if offset.hand_flip and player:primary_hand_index() == 1 then
				unit:set_local_rotation(offset.rotation * Rotation(180))
			else
				unit:set_local_rotation(offset.rotation)
			end
		end
	end

	hand_unit:set_visible(false)
end

local __remove_item = MenuSceneManager.remove_item

-- Lines 216-222
function MenuSceneManagerVR:remove_item()
	__remove_item(self)

	local player = managers.menu:player()
	local hand_unit = player:hand(3 - (player:primary_hand_index() or 1)):unit()

	hand_unit:set_visible(true)
end

local __set_scene_template = MenuSceneManager.set_scene_template

-- Lines 225-233
function MenuSceneManagerVR:set_scene_template(template, data, custom_name, skip_transition)
	__set_scene_template(self, template, data, custom_name, skip_transition)

	local template_data = data or self._scene_templates[template]

	if not template_data.allow_item then
		self:remove_item()
	end
end

-- Lines 235-236
function MenuSceneManagerVR:spawn_workbench_room()
end

-- Lines 238-243
function MenuSceneManagerVR:get_henchmen_positioning(index)
	local pos = Vector3(-180 + 50 * index, 340 + 30 * index, 0)
	local rot = Rotation(180)

	return pos, rot
end

-- Lines 246-264
function MenuSceneManagerVR:create_character_text_panel(peer_id)
	self._character_text_ws = self._character_text_ws or {}
	local character = self._lobby_characters[peer_id]

	if not alive(character) then
		return
	end

	local ws = self._character_text_ws[peer_id]
	local w = 300
	local h = 100

	if not ws then
		ws = managers.gui_data:get_scene_gui():create_world_workspace(w, h, Vector3(), Vector3(1, 0, 0), Vector3(0, 0, 1))
		self._character_text_ws[peer_id] = ws
	end

	local rot = character:rotation()

	ws:set_world(w, h, character:position() + rot:x() * 60 + rot:y() * 45 + rot:z() * 150, -rot:x() * 120, -rot:z() * 40)

	local panel = ws:panel()

	return panel, panel:center()
end

-- Lines 266-274
function MenuSceneManagerVR:clear_character_text_panels()
	if not self._character_text_ws then
		return
	end

	for _, ws in pairs(self._character_text_ws) do
		ws:panel():clear()
	end
end

-- Lines 276-284
function MenuSceneManagerVR:_create_economy_safe_scene()
	local pos = self._scene_templates.safe.character_pos + Vector3(50, 100, 0)
	local rot = Rotation(30)
	self._economy_safe = World:spawn_unit(self._safe_scene_data.safe_data.safe_name, pos, rot)
	self._economy_drill = World:spawn_unit(self._safe_scene_data.drill_data.drill_name, self._economy_safe:get_object(Idstring("spawn_drill")):position(), rot)

	self:_start_safe_drill_sequence()
end

-- Lines 286-288
function MenuSceneManagerVR:character_unit()
	return self._character_unit
end

local __load_safe_result_content = MenuSceneManager.load_safe_result_content

-- Lines 291-297
function MenuSceneManagerVR:load_safe_result_content(...)
	__load_safe_result_content(self, ...)

	if alive(self._economy_character) then
		self._economy_character:set_position(Vector3(-40, 320, 0))
	end
end
