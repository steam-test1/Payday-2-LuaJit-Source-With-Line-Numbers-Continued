NPCSniperRifleBase = NPCSniperRifleBase or class(NPCRaycastWeaponBase)
NPCSniperRifleBase.TRAIL_EFFECT = Idstring("effects/particles/weapons/sniper_trail")
local idstr_trail = Idstring("trail")
local idstr_simulator_length = Idstring("simulator_length")
local idstr_size = Idstring("size")

-- Lines 8-12
function NPCSniperRifleBase:init(unit)
	NPCSniperRifleBase.super.init(self, unit)

	self._trail_length = World:effect_manager():get_initial_simulator_var_vector2(self._trail_effect_table.effect, idstr_trail, idstr_simulator_length, idstr_size)
end

-- Lines 16-24
function NPCSniperRifleBase:_spawn_trail_effect(direction, col_ray)
	self._obj_fire:m_position(self._trail_effect_table.position)
	mvector3.set(self._trail_effect_table.normal, direction)

	local trail = World:effect_manager():spawn(self._trail_effect_table)

	if col_ray then
		mvector3.set_y(self._trail_length, col_ray.distance)
		World:effect_manager():set_simulator_var_vector2(trail, idstr_trail, idstr_simulator_length, idstr_size, self._trail_length)
	end
end
