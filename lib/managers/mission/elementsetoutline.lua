core:import("CoreMissionScriptElement")

ElementSetOutline = ElementSetOutline or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementSetOutline:init(...)
	ElementSetOutline.super.init(self, ...)
end

-- Lines 9-11
function ElementSetOutline:client_on_executed(...)
end

-- Lines 13-42
function ElementSetOutline:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	-- Lines 18-30
	local function f(unit)
		if unit:contour() then
			if self._values.clear_previous then
				unit:contour():remove("highlight", true)
			end

			if self._values.set_outline then
				unit:contour():add("highlight_character", true)
			else
				unit:contour():remove("highlight_character", true)
			end
		end
	end

	if self._values.use_instigator then
		f(instigator)
	else
		for _, id in ipairs(self._values.elements) do
			local element = self:get_mission_element(id)

			element:execute_on_all_units(f)
		end
	end

	ElementSetOutline.super.on_executed(self, instigator)
end
