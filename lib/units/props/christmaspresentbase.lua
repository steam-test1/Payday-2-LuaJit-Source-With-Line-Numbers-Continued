ChristmasPresentBase = ChristmasPresentBase or class(UnitBase)

-- Lines: 5 to 16
function ChristmasPresentBase:init(unit)
	UnitBase.init(self, unit, false)

	self._unit = unit

	self._unit:set_slot(0)
end

-- Lines: 20 to 31
function ChristmasPresentBase:take_money(unit)
	local params = {
		effect = Idstring("effects/particles/environment/player_snowflakes"),
		position = Vector3(),
		rotation = Rotation()
	}

	World:effect_manager():spawn(params)
	managers.hud._sound_source:post_event("jingle_bells")
	Network:detach_unit(self._unit)
	self._unit:set_slot(0)
end

-- Lines: 36 to 37
function ChristmasPresentBase:update(unit, t, dt)
end

-- Lines: 42 to 43
function ChristmasPresentBase:destroy()
end

return
