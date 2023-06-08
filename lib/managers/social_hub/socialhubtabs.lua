require("lib/managers/menu/SearchBoxGuiObject")

SocialHubTab = SocialHubTab or class()

-- Lines 5-6
function SocialHubTab:init(parent_panel)
end

-- Lines 8-58
function SocialHubTab:on_user_item_pressed(action, user_id)
	print("SocialHubTab:on_user_item_pressed", inspect(action or "NO"), inspect(user_id or "NO"))

	if not action or not user_id or user_id == managers.network.matchmake:userid() then
		return
	end

	if action == "friend" then
		managers.menu:show_socialhub_action_dialog({
			action = "add",
			user_id = user_id,
			callback = function ()
				managers.socialhub:add_user_friend(user_id)
				MenuCallbackHandler:save_progress()
				managers.menu_component:social_hub_gui_reset_tab_by_name("friend")
				managers.menu_component:social_hub_gui_reset_tab_by_name("invite")
			end
		})
	elseif action == "unfriend" then
		managers.menu:show_socialhub_action_dialog({
			action = "remove",
			user_id = user_id,
			callback = function ()
				managers.socialhub:remove_user_friend(user_id)
				MenuCallbackHandler:save_progress()
				managers.menu_component:social_hub_gui_reset_tab_by_name("friend")
				managers.menu_component:social_hub_gui_reset_tab_by_name("invite")
			end
		})
	elseif action == "block" then
		managers.menu:show_socialhub_action_dialog({
			action = "block",
			user_id = user_id,
			callback = function ()
				managers.socialhub:add_user_blocked(user_id)
				MenuCallbackHandler:save_progress()
				managers.menu_component:social_hub_gui_reset_tab_by_name("friend")
				managers.menu_component:social_hub_gui_reset_tab_by_name("invite")
				managers.menu_component:social_hub_gui_reset_tab_by_name("blocked")
			end
		})
	elseif action == "unblock" then
		managers.menu:show_socialhub_action_dialog({
			action = "unblock",
			user_id = user_id,
			callback = function ()
				managers.socialhub:remove_user_blocked(user_id)
				MenuCallbackHandler:save_progress()
				managers.menu_component:social_hub_gui_reset_tab_by_name("friend")
				managers.menu_component:social_hub_gui_reset_tab_by_name("invite")
				managers.menu_component:social_hub_gui_reset_tab_by_name("blocked")
			end
		})
	elseif action == "invite" then
		managers.menu:show_socialhub_action_dialog({
			action = "invite",
			user_id = user_id,
			callback = function ()
				managers.socialhub:invite_user_to_lobby(user_id)
				MenuCallbackHandler:save_progress()
				managers.menu_component:social_hub_gui_reset_tab_by_name("friend")
				managers.menu_component:social_hub_gui_reset_tab_by_name("invite")
			end
		})
	end
end

-- Lines 60-72
function SocialHubTab:on_user_lobby_pressed(first, second, third)
	print("SocialHubTab:on_user_lobby_pressed", inspect(first or "NO"), inspect(second or "NO"), inspect(third or "NO"))

	if not first or not second or managers.network.matchmake.lobby_handler and second == managers.network.matchmake.lobby_handler:id() then
		return
	end

	if first == "join" then
		EpicSocialHub:join_lobby(second)
		managers.socialhub:remove_pending_lobby(second)
	elseif first == "decline" then
		managers.socialhub:remove_pending_lobby(second)
	end
end

SocialHubFriendTab = SocialHubFriendTab or class(SocialHubTab)

-- Lines 76-82
function SocialHubFriendTab:init(parent_panel)
	SocialHubFriendTab.super.init(parent_panel)

	self.scroll = ScrollItemList:new(parent_panel, {
		input_focus = true,
		scrollbar_padding = 10,
		padding = 0
	}, {
		layer = 100
	})

	self.scroll:add_lines_and_static_down_indicator(15)
	self:setup_panel(parent_panel)
end

-- Lines 84-159
function SocialHubFriendTab:setup_panel(parent_panel)
	self.open_friend_categories = {}
	local friends = managers.socialhub:get_platform_friends()
	local platform_name = SystemInfo:distribution() == Idstring("STEAM") and managers.localization:text("socialhub_friends_platform_title_steam") or SystemInfo:distribution() == Idstring("EPIC") and managers.localization:text("socialhub_friends_platform_title_epic") or managers.localization:text("socialhub_friends_platform_title")
	local category_header = SocialHubUserCategoryHeader:new(self.scroll:canvas(), {
		text = platform_name .. " [" .. managers.socialhub:get_number_of_platform_friends() .. "]",
		press_callback = callback(self, self, "on_user_filter_pressed", 2)
	})
	category_header.sort_category_prio = 2
	category_header.sort_type_prio = 1

	self.scroll:add_item(category_header)

	for index, item in ipairs(friends) do
		local friend_item = SocialHubUserItem:new(self.scroll:canvas(), {
			right_display = "status",
			id = item,
			buttons = managers.socialhub:get_actions_for_user(self, "on_user_item_pressed", item)
		})
		friend_item.sort_category_prio = 2
		friend_item.sort_type_prio = 2

		self.scroll:add_item(friend_item)
	end

	local offline_separator_item = SocialHubUserSeparator:new(self.scroll:canvas())
	offline_separator_item.sort_category_prio = 2
	offline_separator_item.sort_type_prio = 2

	self.scroll:add_item(offline_separator_item)
	table.insert(self.open_friend_categories, true)

	local cross_friends = managers.socialhub:get_cross_friends()
	local category_header = SocialHubUserCategoryHeader:new(self.scroll:canvas(), {
		text = managers.localization:text("socialhub_friends_cross_title") .. " [" .. managers.socialhub:get_number_of_cross_friends() .. "]",
		press_callback = callback(self, self, "on_user_filter_pressed", 1)
	})
	category_header.sort_category_prio = 1
	category_header.sort_type_prio = 1

	self.scroll:add_item(category_header)

	for index, item in ipairs(cross_friends) do
		if managers.socialhub:user_exists(item) then
			local friend_item = SocialHubUserItem:new(self.scroll:canvas(), {
				right_display = "status",
				id = item,
				buttons = managers.socialhub:get_actions_for_user(self, "on_user_item_pressed", item)
			})
			friend_item.sort_category_prio = 1
			friend_item.sort_type_prio = 2

			self.scroll:add_item(friend_item)
		end
	end

	local offline_separator_item = SocialHubUserSeparator:new(self.scroll:canvas())
	offline_separator_item.sort_category_prio = 1
	offline_separator_item.sort_type_prio = 2

	self.scroll:add_item(offline_separator_item)
	table.insert(self.open_friend_categories, true)
	self.scroll:sort_items(function (lhs, rhs)
		if lhs.sort_category_prio < rhs.sort_category_prio then
			return true
		elseif rhs.sort_category_prio < lhs.sort_category_prio then
			return false
		end

		if lhs.sort_type_prio < rhs.sort_type_prio then
			return true
		elseif rhs.sort_type_prio < lhs.sort_type_prio then
			return false
		end

		if lhs.get_status_prio and lhs.get_status_prio then
			if lhs:get_status_prio() < rhs:get_status_prio() then
				return true
			elseif rhs:get_status_prio() < lhs:get_status_prio() then
				return false
			end
		end
	end)
	self.scroll:select_index(1)
end

-- Lines 161-167
function SocialHubFriendTab:reset_tab()
	for index, item in ipairs(self.scroll:all_items()) do
		item:remove_self()
	end

	self.scroll:clear()
	self:setup_panel()
end

-- Lines 169-178
function SocialHubFriendTab:on_user_filter_pressed(filter_category)
	self.open_friend_categories[filter_category] = not self.open_friend_categories[filter_category]

	self.scroll:filter_items(function (item)
		if item.sort_type_prio > 1 then
			return self.open_friend_categories[item.sort_category_prio]
		end

		return true
	end, nil, true)
end

-- Lines 180-188
function SocialHubFriendTab:get_online_friends_amount(friend_list)
	local amount = 0

	for index, item in ipairs(friend_list) do
		if item.state == "online" then
			amount = amount + 1
		end
	end

	return amount
end

-- Lines 190-192
function SocialHubFriendTab:mouse_moved(button, x, y)
	return self.scroll:mouse_moved(button, x, y)
end

-- Lines 194-196
function SocialHubFriendTab:mouse_pressed(button, x, y)
	self.scroll:mouse_pressed(button, x, y)
end

-- Lines 198-200
function SocialHubFriendTab:mouse_released(o, button, x, y)
	return self.scroll:mouse_released(o, button, x, y)
end

-- Lines 202-204
function SocialHubFriendTab:mouse_wheel_up(x, y)
	return self.scroll:mouse_wheel_up(x, y)
end

-- Lines 206-208
function SocialHubFriendTab:mouse_wheel_down(x, y)
	return self.scroll:mouse_wheel_down(x, y)
end

-- Lines 210-212
function SocialHubFriendTab:move_up()
	self.scroll:move_up()
end

-- Lines 214-216
function SocialHubFriendTab:move_down()
	self.scroll:move_down()
end

-- Lines 218-223
function SocialHubFriendTab:move_left()
	local item = self.scroll:selected_item()

	if item and item.move_left then
		item:move_left()
	end
end

-- Lines 225-230
function SocialHubFriendTab:move_right()
	local item = self.scroll:selected_item()

	if item and item.move_right then
		item:move_right()
	end
end

-- Lines 232-237
function SocialHubFriendTab:confirm_pressed()
	local item = self.scroll:selected_item()

	if item and item.confirm_pressed then
		item:confirm_pressed()
	end
end

SocialHubInviteTab = SocialHubInviteTab or class(SocialHubTab)

-- Lines 242-264
function SocialHubInviteTab:init(parent_panel, ws)
	SocialHubInviteTab.super.init(parent_panel)

	self._searchbox = SearchBoxGuiObject:new(parent_panel, ws, nil, {
		w = 292
	})

	self._searchbox:register_disconnect_callback(callback(self, self, "searchbox_disconnect_callback"))
	self._searchbox.panel:set_center_x(parent_panel:center_x())

	self._paste_icon = parent_panel:bitmap({
		texture = "guis/dlcs/shub/textures/paste_icon",
		layer = 10,
		x = self._searchbox.panel:right() + 2,
		w = self._searchbox.panel:h(),
		h = self._searchbox.panel:h()
	})

	if not managers.menu:is_pc_controller() then
		self._paste_button_prompt = parent_panel:text({
			name = "paste_button_prompt",
			layer = 1,
			font = tweak_data.menu.pd2_medium_font,
			font_size = tweak_data.menu.pd2_medium_font_size,
			text = utf8.to_upper(managers.localization:btn_macro("menu_respec_tree") .. " " .. managers.localization:text("menu_socialhub_controller_paste"))
		})

		ExtendedPanel.make_fine_text(self._paste_button_prompt)
		self._paste_button_prompt:set_x(self._searchbox.panel:x() - self._paste_button_prompt:w() - 2)
		self._paste_button_prompt:set_center_y(self._searchbox.panel:center_y())
	end

	self._scroll_panel = parent_panel:panel({
		y = self._searchbox.panel:bottom() + 5
	})
	self.scroll = ScrollItemList:new(self._scroll_panel, {
		input_focus = true,
		scrollbar_padding = 10,
		padding = 0
	}, {
		layer = 100
	})

	self:setup_panel(parent_panel)
end

-- Lines 266-285
function SocialHubInviteTab:setup_panel(parent_panel)
	local header_text = SocialHubTextHeader:new(self._scroll_panel, {
		text = managers.localization:text("socialhub_invites_header_invite")
	})

	self.scroll:add_item(header_text)

	local header_text = SocialHubTextHeader:new(self._scroll_panel, {
		text = managers.localization:text("socialhub_invites_header_search")
	})

	self.scroll:add_item(header_text)

	for index, item in pairs(managers.socialhub:get_pending_lobbies()) do
		item.buttons = {
			{
				text = managers.localization:text("socialhub_lobby_action_decline"),
				press_callback = callback(self, self, "on_user_lobby_pressed", "decline")
			},
			{
				text = managers.localization:text("socialhub_lobby_action_join"),
				press_callback = callback(self, self, "on_user_lobby_pressed", "join")
			}
		}
		local lobby_item = SocialHubLobbyItem:new(self.scroll:canvas(), item)

		self.scroll:add_item(lobby_item, nil, 1)
	end

	self.scroll:place_items_in_order(nil, true, true)
	self.scroll:select_index(1)
end

-- Lines 287-299
function SocialHubInviteTab:reset_tab()
	for index, item in ipairs(self.scroll:all_items()) do
		item:remove_self()
	end

	if self.search_item then
		self.search_item:remove_self()

		self.search_item = nil
	end

	self.scroll:clear()
	self:setup_panel()
end

-- Lines 301-307
function SocialHubInviteTab:searchbox_disconnect_callback(first, second, third)
	if string.len(first) == 32 then
		EpicMM:query_users({
			first
		}, callback(self, self, "on_search_users_fetched"))
		EpicSocialHub:get_lobby_info(first, callback(self, self, "on_search_lobby_fetched"))
	end
end

-- Lines 309-328
function SocialHubInviteTab:on_search_users_fetched(first, second, third)
	if not first or not second or second and table.size(second) <= 0 or not self:invite_tab_valid() then
		return
	end

	print("SocialHubInviteTab:on_search_users_fetched", first, inspect(second), table.size(second))

	if self.search_item then
		self.scroll:remove_item(#self.scroll:items() - 1)
		self.search_item:remove_self()

		self.search_item = nil
	end

	for index, item in pairs(second) do
		managers.socialhub:add_cached_user(index, item)

		self.search_item = SocialHubUserItem:new(self.scroll:canvas(), {
			right_display = "status",
			id = index,
			buttons = managers.socialhub:get_actions_for_user(self, "on_user_item_pressed", index)
		})

		self.scroll:add_item(self.search_item, nil, #self.scroll:items())
		self.scroll:place_items_in_order(nil, true, true)
	end
end

-- Lines 330-351
function SocialHubInviteTab:on_search_lobby_fetched(lobby_id, host_user_id, lobby_parameters)
	if not lobby_id or not host_user_id or not self:invite_tab_valid() then
		return
	end

	print("SocialHubInviteTab:on_search_lobby_fetched", inspect(lobby_id), inspect(host_user_id), inspect(lobby_parameters))

	if self.search_item then
		self.scroll:remove_item(#self.scroll:items() - 1)
		self.search_item:remove_self()

		self.search_item = nil
	end

	lobby_parameters.buttons = {
		{
			text = managers.localization:text("socialhub_lobby_action_decline"),
			press_callback = callback(self, self, "on_user_lobby_pressed", "decline")
		},
		{
			text = managers.localization:text("socialhub_lobby_action_join"),
			press_callback = callback(self, self, "on_user_lobby_pressed", "join")
		}
	}
	lobby_parameters.LOBBYID = lobby_id
	self.search_item = SocialHubLobbyItem:new(self.scroll:canvas(), lobby_parameters)

	self.scroll:add_item(self.search_item, nil, #self.scroll:items())
	self.scroll:place_items_in_order(nil, true, true)
end

-- Lines 353-362
function SocialHubInviteTab:on_user_lobby_pressed(first, second, third)
	SocialHubInviteTab.super.on_user_lobby_pressed(self, first, second, third)

	if not first or not second or managers.network.matchmake.lobby_handler and second == managers.network.matchmake.lobby_handler:id() then
		return
	end

	if first == "decline" then
		self:reset_tab()
	end
end

-- Lines 364-384
function SocialHubInviteTab:mouse_moved(button, x, y)
	if not alive(self.scroll) or not alive(self._searchbox.panel) then
		return
	end

	local used, pointer = self.scroll:mouse_moved(button, x, y)

	if used then
		return used, pointer
	end

	if self._searchbox then
		used, pointer = self._searchbox:mouse_moved(button, x, y)

		if used then
			return used, pointer
		end
	end

	if alive(self._paste_icon) and self._paste_icon:inside(x, y) then
		return true, "link"
	end
end

-- Lines 386-401
function SocialHubInviteTab:mouse_pressed(button, x, y)
	if not alive(self.scroll) or not alive(self._searchbox.panel) then
		return
	end

	self.scroll:mouse_pressed(button, x, y)

	if self._searchbox and self._searchbox:mouse_pressed(button, x, y) then
		return
	end

	if alive(self._paste_icon) and self._paste_icon:inside(x, y) then
		self._searchbox:clear_text()
		self._searchbox:enter_text(nil, Application:get_clipboard())
		self:searchbox_disconnect_callback(Application:get_clipboard())
	end
end

-- Lines 403-405
function SocialHubInviteTab:move_up()
	self.scroll:move_up()
end

-- Lines 407-409
function SocialHubInviteTab:move_down()
	self.scroll:move_down()
end

-- Lines 411-416
function SocialHubInviteTab:move_left()
	local item = self.scroll:selected_item()

	if item and item.move_left then
		item:move_left()
	end
end

-- Lines 418-423
function SocialHubInviteTab:move_right()
	local item = self.scroll:selected_item()

	if item and item.move_right then
		item:move_right()
	end
end

-- Lines 425-435
function SocialHubInviteTab:confirm_pressed()
	if self._searchbox:input_focus() then
		self._searchbox:disconnect_search_input()

		return
	end

	local item = self.scroll:selected_item()

	if item and item.confirm_pressed then
		item:confirm_pressed()
	end
end

-- Lines 437-443
function SocialHubInviteTab:special_btn_pressed(button)
	if button == Idstring("menu_respec_tree") then
		self._searchbox:clear_text()
		self._searchbox:enter_text(nil, Application:get_clipboard())
		self:searchbox_disconnect_callback(Application:get_clipboard())
	end
end

-- Lines 445-447
function SocialHubInviteTab:invite_tab_valid()
	return alive(self._scroll_panel)
end

SocialHubBlockedTab = SocialHubBlockedTab or class(SocialHubTab)

-- Lines 486-491
function SocialHubBlockedTab:init(parent_panel)
	SocialHubBlockedTab.super.init(parent_panel)

	self.scroll = ScrollItemList:new(parent_panel, {
		input_focus = true,
		scrollbar_padding = 10,
		padding = 0
	}, {
		layer = 100
	})

	self:setup_panel()
end

-- Lines 493-502
function SocialHubBlockedTab:setup_panel()
	for index, item in ipairs(managers.socialhub:get_blocked_users()) do
		if managers.socialhub:user_exists(item) then
			local user = SocialHubUserItem:new(self.scroll:canvas(), {
				right_display_icon = "guis/dlcs/shub/textures/blocked_player_icon",
				right_display = "icon",
				id = item,
				buttons = managers.socialhub:get_actions_for_user(self, "on_user_item_pressed", item)
			})

			self.scroll:add_item(user)
		end
	end

	self.scroll:select_index(1)
end

-- Lines 504-511
function SocialHubBlockedTab:reset_tab()
	for index, item in ipairs(self.scroll:all_items()) do
		item:remove_self()
	end

	self.scroll:clear()
	self:setup_panel()
end

-- Lines 513-515
function SocialHubBlockedTab:mouse_moved(button, x, y)
	return self.scroll:mouse_moved(button, x, y)
end

-- Lines 517-519
function SocialHubBlockedTab:mouse_pressed(button, x, y)
	self.scroll:mouse_pressed(button, x, y)
end

-- Lines 521-523
function SocialHubBlockedTab:move_up()
	self.scroll:move_up()
end

-- Lines 525-527
function SocialHubBlockedTab:move_down()
	self.scroll:move_down()
end

-- Lines 529-534
function SocialHubBlockedTab:move_left()
	local item = self.scroll:selected_item()

	if item and item.move_left then
		item:move_left()
	end
end

-- Lines 536-541
function SocialHubBlockedTab:move_right()
	local item = self.scroll:selected_item()

	if item and item.move_right then
		item:move_right()
	end
end

-- Lines 543-548
function SocialHubBlockedTab:confirm_pressed()
	local item = self.scroll:selected_item()

	if item and item.confirm_pressed then
		item:confirm_pressed()
	end
end
