RaidMenuGui = RaidMenuGui or class(PromotionalMenuGui)
RaidMenuGui.RaidAppId = "414740"
RaidMenuGui.RaidBetaAppId = "704580"

-- Lines 7-15
function RaidMenuGui:init(ws, fullscreen_ws, node, promo_menu_id)
	RaidMenuGui.super.init(self, ws, fullscreen_ws, node)

	self._promo_menu = tweak_data.promos.menus[promo_menu_id]
	self._theme = tweak_data.promos.themes.raid

	self:setup(self._promo_menu, self._theme)
end

-- Lines 19-37
function RaidMenuGui:launch_raid()
	local dialog_data = {
		title = managers.localization:text("dialog_play_raid_beta"),
		text = managers.localization:text("dialog_play_raid_beta_text")
	}
	local yes_button = {
		text = managers.localization:text("dialog_yes"),
		callback_func = callback(self, self, "_launch_raid_dialog_yes")
	}
	local no_button = {
		text = managers.localization:text("dialog_no"),
		callback_func = callback(self, self, "_launch_raid_dialog_no"),
		cancel_button = true
	}
	dialog_data.button_list = {
		yes_button,
		no_button
	}

	managers.system_menu:show(dialog_data)
end

-- Lines 39-53
function RaidMenuGui:_launch_raid_dialog_yes()
	managers.savefile:save_progress("local_hdd")
	setup:quit()
	os.execute("cmd /c start steam://run/" .. tostring(RaidMenuGui.RaidBetaAppId))
end

-- Lines 55-56
function RaidMenuGui:_launch_raid_dialog_no()
end

-- Lines 60-63
function RaidMenuGui:open_raid_weapons_menu()
	managers.menu:open_node("raid_beta_weapons", {})
	managers.menu:post_event("menu_enter")
end

-- Lines 65-68
function RaidMenuGui:open_raid_masks_menu()
	managers.menu:open_node("raid_beta_masks", {})
	managers.menu:post_event("menu_enter")
end

-- Lines 70-72
function RaidMenuGui:open_raid_trailer()
	Steam:overlay_activate("url", "https://www.youtube.com/embed/XARRgLUzSiA")
end

-- Lines 74-76
function RaidMenuGui:open_dev_diary_trailer()
	Steam:overlay_activate("url", "https://www.youtube.com/embed/cm98FnsSKvY")
end

-- Lines 78-80
function RaidMenuGui:open_gameplay_trailer()
	Steam:overlay_activate("url", "https://www.youtube.com/embed/Kl2qT-UJVJ4")
end

-- Lines 82-84
function RaidMenuGui:open_raid_gang()
	Steam:overlay_activate("url", "http://www.raidworldwar2.com/#characters")
end

-- Lines 86-88
function RaidMenuGui:open_raid_feedback()
	Steam:overlay_activate("url", "https://steamcommunity.com/games/" .. RaidMenuGui.RaidAppId .. "/")
end

-- Lines 90-93
function RaidMenuGui:open_raid_special_edition_menu()
	managers.menu:open_node("raid_beta_special", {})
	managers.menu:post_event("menu_enter")
end

-- Lines 95-97
function RaidMenuGui:open_raid_special_edition()
	Steam:overlay_activate("url", "https://store.steampowered.com/app/" .. RaidMenuGui.RaidAppId .. "/")
end

-- Lines 99-101
function RaidMenuGui:open_raid_twitch()
	Steam:overlay_activate("url", "https://www.twitch.tv/liongamelion")
end

-- Lines 103-106
function RaidMenuGui:open_raid_preorder_menu()
	managers.menu:open_node("raid_beta_preorder", {})
	managers.menu:post_event("menu_enter")
end

-- Lines 108-110
function RaidMenuGui:open_raid_preorder()
	Steam:overlay_activate("url", "https://store.steampowered.com/app/" .. RaidMenuGui.RaidAppId .. "/")
end

-- Lines 114-116
function RaidMenuGui:preview_breech()
	managers.blackmarket:view_weapon_platform("breech", callback(self, self, "_open_preview_node", {
		id = "breech",
		category = "secondaries"
	}))
end

-- Lines 118-120
function RaidMenuGui:preview_ching()
	managers.blackmarket:view_weapon_platform("ching", callback(self, self, "_open_preview_node", {
		id = "ching",
		category = "primaries"
	}))
end

-- Lines 122-124
function RaidMenuGui:preview_erma()
	managers.blackmarket:view_weapon_platform("erma", callback(self, self, "_open_preview_node", {
		id = "erma",
		category = "secondaries"
	}))
end

-- Lines 126-129
function RaidMenuGui:preview_push()
	managers.menu:open_node("raid_weapon_preview_node", {
		{
			category = "melee",
			item_id = "push"
		}
	})
	managers.blackmarket:preview_melee_weapon("push")
end

-- Lines 131-134
function RaidMenuGui:preview_grip()
	managers.menu:open_node("raid_weapon_preview_node", {
		{
			category = "melee",
			item_id = "grip"
		}
	})
	managers.blackmarket:preview_melee_weapon("grip")
end

-- Lines 136-138
function RaidMenuGui:_open_preview_node(data)
	managers.menu:open_node("raid_weapon_preview_node", {
		{
			item_id = data.id,
			category = data.category
		}
	})
end

-- Lines 142-144
function RaidMenuGui:preview_jfr_01()
	self:_preview_mask("jfr_01")
end

-- Lines 146-148
function RaidMenuGui:preview_jfr_02()
	self:_preview_mask("jfr_02")
end

-- Lines 150-152
function RaidMenuGui:preview_jfr_03()
	self:_preview_mask("jfr_03")
end

-- Lines 154-156
function RaidMenuGui:preview_jfr_04()
	self:_preview_mask("jfr_04")
end

-- Lines 158-161
function RaidMenuGui:_preview_mask(mask_id)
	managers.blackmarket:view_mask_with_mask_id(mask_id)
	managers.menu:open_node("raid_weapon_preview_node", {
		{
			category = "mask",
			item_id = mask_id
		}
	})
end
