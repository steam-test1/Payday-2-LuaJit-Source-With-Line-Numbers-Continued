core:import("CoreMissionScriptElement")

ElementPlayerSpawner = ElementPlayerSpawner or class(CoreMissionScriptElement.MissionScriptElement)

-- Lines 5-9
function ElementPlayerSpawner:init(...)
	ElementPlayerSpawner.super.init(self, ...)
	managers.player:preload()
end

-- Lines 12-14
function ElementPlayerSpawner:value(name)
	return self._values[name]
end

-- Lines 16-22
function ElementPlayerSpawner:client_on_executed(...)
	if not self._values.enabled then
		return
	end

	managers.player:set_player_state(self._values.state or managers.player:default_player_state())
end

-- Lines 24-33
function ElementPlayerSpawner:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.player:set_player_state(self._values.state or managers.player:default_player_state())
	managers.groupai:state():on_player_spawn_state_set(self._values.state or managers.player:default_player_state())
	managers.network:register_spawn_point(self._id, {
		position = self._values.position,
		rotation = self._values.rotation
	})
	ElementPlayerSpawner.super.on_executed(self, self._unit or instigator)
end

-- Lines 35-41
function ElementPlayerSpawner:execute_on_all_units(func)
	for _, data in ipairs(managers.criminals:characters()) do
		if alive(data.unit) then
			func(data.unit)
		end
	end
end
