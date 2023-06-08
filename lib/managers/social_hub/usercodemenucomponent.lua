local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.pd2_tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size
UserCodeMenuComponent = UserCodeMenuComponent or class(LobbyCodeMenuComponent)

-- Lines 16-24
function UserCodeMenuComponent:init(ws, fullscreen_ws, node)
	self._ws = ws
	self._panel = self._ws:panel():panel({
		w = 500,
		layer = 100,
		h = 100,
		y = 80
	})
	self._id_code = managers.network.matchmake:userid()

	self:create_hub_panel()
	self:set_header(managers.localization:to_upper_text("menu_user_code"))
	self:set_code_hidden(not managers.user:get_setting("toggle_socialhub_hide_code"))
end

-- Lines 26-29
function UserCodeMenuComponent:copy_code()
	self._copied_alpha_timer = 2

	Application:set_clipboard(managers.network.matchmake:userid())
end

-- Lines 32-44
function UserCodeMenuComponent:mouse_moved(o, x, y)
	if self._button_panel and self._button_panel:inside(x, y) then
		return true, "link"
	end

	if self._lower_panel then
		if self._lower_panel:inside(x, y) then
			self._hide_code_text:set_color(tweak_data.screen_colors.button_stage_2)

			return true, "link"
		else
			self._hide_code_text:set_color(tweak_data.screen_colors.button_stage_3)
		end
	end
end
