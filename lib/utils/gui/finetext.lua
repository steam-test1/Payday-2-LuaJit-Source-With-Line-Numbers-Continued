FineText = FineText or class(GUIObjectWrapper)

-- Lines: 3 to 13
function FineText:init(parent, config)
	config = config or {}
	config.font_size = config.font_size or tweak_data.menu.pd2_medium_font_size
	config.font = config.font or tweak_data.menu.pd2_medium_font
	config.color = config.color or tweak_data.screen_colors.text
	local text_obj = parent:text(config)

	self.super.init(self, text_obj)
	self:shrink_wrap()
end

-- Lines: 15 to 20
function FineText:shrink_wrap()
	local x, y, w, h = self._gui_obj:text_rect()

	self._gui_obj:set_size(w, h)
	self._gui_obj:set_world_position(math.round(x), math.round(y))
end

-- Lines: 22 to 25
function FineText:set_text(...)
	self._gui_obj:set_text(...)
	self:shrink_wrap()
end

-- Lines: 26 to 27
function FineText:text()
	self._gui_obj:text()
end

return
