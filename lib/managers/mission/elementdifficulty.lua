core:import("CoreMissionScriptElement")

ElementDifficulty = ElementDifficulty or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-7
function ElementDifficulty:init(...)
	ElementDifficulty.super.init(self, ...)
end

-- Lines 9-11
function ElementDifficulty:client_on_executed(...)
end

-- Lines 13-22
function ElementDifficulty:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_difficulty(self._values.difficulty)
	ElementDifficulty.super.on_executed(self, instigator)
end
