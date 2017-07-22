PunchingBagDamage = PunchingBagDamage or class()

-- Lines: 5 to 6
function PunchingBagDamage:init(unit)
end

-- Lines: 8 to 9
function PunchingBagDamage:damage_melee(unit)
end

-- Lines: 11 to 12
function PunchingBagDamage:damage_bullet(unit)
end

-- Lines: 14 to 15
function PunchingBagDamage:damage_fire(unit)
end

-- Lines: 17 to 18
function PunchingBagDamage:damage_dot(unit)
end

-- Lines: 20 to 21
function PunchingBagDamage:damage_explosion(unit)
end

-- Lines: 23 to 24
function PunchingBagDamage:damage_tase(unit)
end

-- Lines: 26 to 27
function PunchingBagDamage:damage_mission(unit)
end

-- Lines: 30 to 31
function PunchingBagDamage:dead()
	return false
end

return
