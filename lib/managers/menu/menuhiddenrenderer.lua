MenuHiddenRenderer = MenuHiddenRenderer or class(MenuRenderer)

-- Lines: 3 to 6
function MenuHiddenRenderer:init(...)
	MenuHiddenRenderer.super.init(self, ...)

	self._disable_blackborder = true
end

-- Lines: 8 to 11
function MenuHiddenRenderer:open(...)
	MenuHiddenRenderer.super.open(self, ...)
	self._main_panel:root():hide()
end

-- Lines: 13 to 16
function MenuHiddenRenderer:show()
	MenuHiddenRenderer.super.show(self)
	self._main_panel:root():hide()
end

-- Lines: 18 to 21
function MenuHiddenRenderer:hide()
	MenuHiddenRenderer.super.hide(self)
	self._main_panel:root():hide()
end

