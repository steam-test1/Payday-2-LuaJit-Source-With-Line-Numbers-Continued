RaidMenuGui = RaidMenuGui or class(PromotionalMenuGui)
RaidMenuGui.RaidAppId = "414740"
RaidMenuGui.RaidBetaAppId = "704580"

-- Lines: 8 to 15
function RaidMenuGui:init(ws, fullscreen_ws, node, promo_menu_id)
	RaidMenuGui.super.init(self, ws, fullscreen_ws, node)

	self._promo_menu = tweak_data.promos.menus[promo_menu_id]
	self._theme = tweak_data.promos.themes.raid

	self:setup(self._promo_menu, self._theme)
end

-- Lines: 20 to 37
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

-- Lines: 41 to 53
function RaidMenuGui:_launch_raid_dialog_yes()
	managers.savefile:save_progress("local_hdd")
	setup:quit()
	os.execute("cmd /c start steam://run/" .. tostring(RaidMenuGui.RaidBetaAppId))
end

-- Lines: 55 to 56
function RaidMenuGui:_launch_raid_dialog_no()
end

-- Lines: 60 to 63
function RaidMenuGui:open_raid_weapons_menu()
	managers.menu:open_node("raid_beta_weapons", {})
	managers.menu:post_event("menu_enter")
end

-- Lines: 65 to 68
function RaidMenuGui:open_raid_masks_menu()
	managers.menu:open_node("raid_beta_masks", {})
	managers.menu:post_event("menu_enter")
end

-- Lines: 70 to 72
function RaidMenuGui:open_raid_trailer()
	Steam:overlay_activate("url", "https://www.youtube.com/embed/XARRgLUzSiA")
end

-- Lines: 74 to 76
function RaidMenuGui:open_dev_diary_trailer()
	Steam:overlay_activate("url", "https://www.youtube.com/embed/cm98FnsSKvY")
end

-- Lines: 78 to 80
function RaidMenuGui:open_gameplay_trailer()
	Steam:overlay_activate("url", "https://www.youtube.com/embed/Kl2qT-UJVJ4")
end

-- Lines: 82 to 84
function RaidMenuGui:open_raid_gang()
	Steam:overlay_activate("url", "http://www.raidworldwar2.com/#characters")
end

-- Lines: 86 to 88
function RaidMenuGui:open_raid_feedback()
	Steam:overlay_activate("url", "https://steamcommunity.com/games/" .. RaidMenuGui.RaidAppId .. "/")
end

-- Lines: 90 to 93
function RaidMenuGui:open_raid_special_edition_menu()
	managers.menu:open_node("raid_beta_special", {})
	managers.menu:post_event("menu_enter")
end

-- Lines: 95 to 97
function RaidMenuGui:open_raid_special_edition()
	Steam:overlay_activate("url", "https://store.steampowered.com/app/" .. RaidMenuGui.RaidAppId .. "/")
end

-- Lines: 99 to 101
function RaidMenuGui:open_raid_twitch()
	Steam:overlay_activate("url", "https://www.twitch.tv/liongamelion")
end

-- Lines: 103 to 105
function RaidMenuGui:open_raid_preorder()
	Steam:overlay_activate("url", "https://store.steampowered.com/app/" .. RaidMenuGui.RaidAppId .. "/")
end

-- Lines: 109 to 111
function RaidMenuGui:preview_breech()
	managers.blackmarket:view_weapon_platform("breech", callback(self, self, "_open_preview_node", {
		id = "breech",
		category = "secondaries"
	}))
end

-- Lines: 113 to 115
function RaidMenuGui:preview_ching()
	managers.blackmarket:view_weapon_platform("ching", callback(self, self, "_open_preview_node", {
		id = "ching",
		category = "primaries"
	}))
end

-- Lines: 117 to 119
function RaidMenuGui:preview_erma()
	managers.blackmarket:view_weapon_platform("erma", callback(self, self, "_open_preview_node", {
		id = "erma",
		category = "secondaries"
	}))
end

-- Lines: 121 to 124
function RaidMenuGui:preview_push()
	managers.menu:open_node("raid_weapon_preview_node", {{
		category = "melee",
		item_id = "push"
	}})
	managers.blackmarket:preview_melee_weapon("push")
end

-- Lines: 126 to 129
function RaidMenuGui:preview_grip()
	managers.menu:open_node("raid_weapon_preview_node", {{
		category = "melee",
		item_id = "grip"
	}})
	managers.blackmarket:preview_melee_weapon("grip")
end

-- Lines: 131 to 133
function RaidMenuGui:_open_preview_node(data)
	managers.menu:open_node("raid_weapon_preview_node", {{
		item_id = data.id,
		category = data.category
	}})
end

-- Lines: 137 to 139
function RaidMenuGui:preview_jfr_01()
	self:_preview_mask("jfr_01")
end

-- Lines: 141 to 143
function RaidMenuGui:preview_jfr_02()
	self:_preview_mask("jfr_02")
end

-- Lines: 145 to 147
function RaidMenuGui:preview_jfr_03()
	self:_preview_mask("jfr_03")
end

-- Lines: 149 to 151
function RaidMenuGui:preview_jfr_04()
	self:_preview_mask("jfr_04")
end

-- Lines: 153 to 156
function RaidMenuGui:_preview_mask(mask_id)
	managers.blackmarket:view_mask_with_mask_id(mask_id)
	managers.menu:open_node("raid_weapon_preview_node", {{
		category = "mask",
		item_id = mask_id
	}})
end

