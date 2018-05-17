
-- Lines: 3 to 5
function set_widget_help(widget, help_text)
	widget:set_tool_tip(help_text)
end

-- Lines: 11 to 27
function set_widget_box_help(widget, help_header, help_text, view)

	-- Lines: 8 to 12
	local function on_enter(t, evt)
		t:set_own_font_weight("FONTWEIGHT_BOLD")
		t:refresh()
		evt:skip()
	end

	-- Lines: 14 to 18
	local function on_leave(t, evt)
		t:set_own_font_weight("FONTWEIGHT_NORMAL")
		t:refresh()
		evt:skip()
	end

	-- Lines: 20 to 22
	local function on_left_down(t, evt)
		t[1]:set_box_help(t[2], t[3])
	end

	widget:set_tool_tip("(click to get help text in textbox)\n" .. help_text)
	widget:connect("EVT_ENTER_WINDOW", on_enter, widget)
	widget:connect("EVT_LEAVE_WINDOW", on_leave, widget)
	widget:connect("EVT_LEFT_DOWN", on_left_down, {
		view,
		help_header,
		help_text
	})
end

-- Lines: 29 to 36
function base_path(n)
	local bs = n:reverse():find("\\")

	if bs then
		return n:sub(#n - bs + 2)
	else
		return n
	end
end

-- Lines: 38 to 45
function dir_name(n)
	local bs = n:reverse():find("\\")

	if bs then
		return n:sub(1, #n - bs + 1)
	else
		return n
	end
end

