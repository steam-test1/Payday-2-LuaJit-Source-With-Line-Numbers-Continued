LoadingIconGuiObject = LoadingIconGuiObject or class()

-- Lines 2-5
function LoadingIconGuiObject:init(panel, visible)
	self._icon = panel:bitmap({
		name = "loading_icon",
		texture = "guis/textures/icon_loading",
		visible = visible or false
	})

	self._icon:set_center(panel:w() / 2, panel:h() / 2)
end

-- Lines 6-17
function LoadingIconGuiObject:show()
	self._icon:stop()
	self._icon:animate(function(o)
		local dt

		while true do
			dt = coroutine.yield()

			o:rotate(dt * 180)
		end
	end)
	self._icon:show()
end

-- Lines 18-21
function LoadingIconGuiObject:hide()
	self._icon:stop()
	self._icon:hide()
end
