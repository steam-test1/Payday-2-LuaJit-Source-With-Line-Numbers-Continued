ChristmasPresentBase = ChristmasPresentBase or class(UnitBase)

-- Lines 5-16
function ChristmasPresentBase:init(unit)
	ChristmasPresentBase.super.init(self, unit, false)

	self._unit = unit

	self._unit:set_slot(0)
end

-- Lines 20-31
function ChristmasPresentBase:take_money(unit)
	local params = {
		effect = Idstring("effects/particles/environment/player_snowflakes"),
		position = Vector3(),
		rotation = Rotation()
	}

	World:effect_manager():spawn(params)
	managers.hud._sound_source:post_event("jingle_bells")
	detach_unit_from_network(self._unit)
	self._unit:set_slot(0)
end

-- Lines 37-39
function ChristmasPresentBase:destroy(...)
	ChristmasPresentBase.super.destroy(...)
end
