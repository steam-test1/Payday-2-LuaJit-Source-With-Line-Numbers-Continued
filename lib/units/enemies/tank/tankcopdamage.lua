TankCopDamage = TankCopDamage or class(CopDamage)
TankCopDamage.impact_body_distance = clone(CopDamage.impact_body_distance)
local impact_body_distance_tmp = {
	RightUpLeg = 20,
	LeftArm = 10,
	RightLeg = 10,
	LeftFoot = 8,
	body_helmet_glass = 0,
	body_helmet_plate = 0,
	RightArm = 10,
	body_helmet = 0,
	LeftUpLeg = 20,
	LeftLeg = 10,
	LeftForeArm = 8,
	Spine = 20,
	RightForeArm = 8,
	RightFoot = 8,
	Hips = 20
}

for body_name, distance in pairs(impact_body_distance_tmp) do
	local name_ids = Idstring(body_name)
	TankCopDamage.impact_body_distance[name_ids:key()] = distance
end

impact_body_distance_tmp = nil
local bodies_tmp = {
	[Idstring("head"):key()] = 1,
	[Idstring("body_helmet_plate"):key()] = 2,
	[Idstring("body_helmet_glass"):key()] = 2,
	[Idstring("body_armor_chest"):key()] = 3,
	[Idstring("body_armor_stomache"):key()] = 3,
	[Idstring("body_armor_back"):key()] = 3,
	[Idstring("body_armor_throat"):key()] = 3,
	[Idstring("body_armor_neck"):key()] = 3
}
TankCopDamage._priority_bodies_ids = bodies_tmp
bodies_tmp = nil

-- Lines 58-61
function TankCopDamage:init(...)
	TankCopDamage.super.init(self, ...)

	self._is_halloween = self._unit:name() == Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
end

-- Lines 63-69
function TankCopDamage:damage_bullet(attack_data, ...)
	if self._is_halloween then
		attack_data.damage = math.min(attack_data.damage, 235)
	end

	return TankCopDamage.super.damage_bullet(self, attack_data, ...)
end

-- Lines 71-78
function TankCopDamage:seq_clbk_vizor_shatter()
	if not self._unit:character_damage():dead() then
		self._unit:sound():say("visor_lost")
		managers.modifiers:run_func("OnTankVisorShatter", self._unit)
	end
end
