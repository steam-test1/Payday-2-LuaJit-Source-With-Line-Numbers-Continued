CoreDeprecatedHubElement = CoreDeprecatedHubElement or class(HubElement)
DeprecatedHubElement = DeprecatedHubElement or class(CoreDeprecatedHubElement)

-- Lines: 5 to 7
function DeprecatedHubElement:init(...)
	CoreDeprecatedHubElement.init(self, ...)
end

-- Lines: 9 to 11
function CoreDeprecatedHubElement:init(unit)
	HubElement.init(self, unit)
end

-- Lines: 13 to 27
function CoreDeprecatedHubElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local deprecated_sizer = EWS:BoxSizer("VERTICAL")

	deprecated_sizer:add(EWS:StaticText(panel, "This hub element is deprecated", 0, ""), 1, 0, "ALIGN_CENTER")
	deprecated_sizer:add(EWS:StaticText(panel, "Please remove", 0, ""), 1, 0, "ALIGN_CENTER")
	deprecated_sizer:add(EWS:StaticText(panel, "", 0, ""), 1, 0, "ALIGN_CENTER")
	deprecated_sizer:add(EWS:StaticText(panel, "Have a nice day!", 0, ""), 1, 0, "ALIGN_CENTER")
	panel_sizer:add(deprecated_sizer, 0, 0, "EXPAND")
end

