DummyCivilianBase = DummyCivilianBase or class()

-- Lines: 3 to 7
function DummyCivilianBase:init(unit)
	self._unit = unit

	unit:set_driving("animation")
	unit:set_animation_lod(1, 500000, 500, 500000)
end

-- Lines: 11 to 13
function DummyCivilianBase:play_state(state_name, at_time)
	local result = self._unit:play_state(Idstring(state_name), at_time)

	return result ~= Idstring("") and result
end

-- Lines: 19 to 21
function DummyCivilianBase:anim_clbk_spear_spawn(unit)
	self:_spawn_spear()
end

-- Lines: 25 to 27
function DummyCivilianBase:anim_clbk_spear_unspawn(unit)
	self:_unspawn_spear()
end

-- Lines: 31 to 36
function DummyCivilianBase:_spawn_spear()
	if not alive(self._spear) then
		self._spear = World:spawn_unit(Idstring("units/test/beast/weapon/native_spear"), Vector3(), Rotation())

		self._unit:link(Idstring("a_weapon_right_front"), self._spear, self._spear:orientation_object():name())
	end
end

-- Lines: 40 to 45
function DummyCivilianBase:_unspawn_spear()
	if alive(self._spear) then
		self._spear:set_slot(0)

		self._spear = nil
	end
end

-- Lines: 49 to 51
function DummyCivilianBase:destroy(unit)
	self:_unspawn_spear()
end

