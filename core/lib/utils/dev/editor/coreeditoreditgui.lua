core:import("CoreEngineAccess")
core:import("CoreEditorUtils")

EditGui = EditGui or class()

-- Lines: 6 to 19
function EditGui:init(parent, toolbar, btn, name)
	self._panel = EWS:Panel(parent, "", "TAB_TRAVERSAL")
	self._main_sizer = EWS:StaticBoxSizer(self._panel, "HORIZONTAL", name)

	self._panel:set_sizer(self._main_sizer)

	self._toolbar = toolbar
	self._btn = btn
	self._ctrls = {unit = nil}

	self:set_visible(false)
end

-- Lines: 21 to 28
function EditGui:has(unit)
	if alive(unit) then
		-- Nothing
	else
		self:disable()

		return false
	end
end

-- Lines: 30 to 35
function EditGui:disable()
	self._ctrls.unit = nil

	self._toolbar:set_tool_enabled(self._btn, false)
	self._toolbar:set_tool_state(self._btn, false)
	self:set_visible(false)
end

-- Lines: 37 to 41
function EditGui:set_visible(vis)
	self._visible = vis

	self._panel:set_visible(vis)
	self._panel:layout()
end

-- Lines: 43 to 44
function EditGui:visible()
	return self._visible
end

-- Lines: 47 to 48
function EditGui:get_panel()
	return self._panel
end

return
