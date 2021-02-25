core:import("CoreMissionScriptElement")

ElementCharacterOutline = ElementCharacterOutline or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementCharacterOutline:init(...)
	ElementCharacterOutline.super.init(self, ...)
end

-- Lines 9-11
function ElementCharacterOutline:client_on_executed(...)
	self:on_executed(...)
end

-- Lines 13-28
function ElementCharacterOutline:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local all_civilians = managers.enemy:all_civilians()

	for u_key, u_data in pairs(all_civilians) do
		local data = u_data.unit:brain()._logic_data

		if data and not data.been_outlined and data.char_tweak.outline_on_discover then
			CivilianLogicIdle._enable_outline(data)
		end
	end

	ElementCharacterOutline.super.on_executed(self, instigator)
end
