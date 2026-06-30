PunchingBagDamage = PunchingBagDamage or class()

-- Lines 4-6
function PunchingBagDamage:init(unit)
	unit:set_extension_update_enabled(Idstring("damage"), false)
end

-- Lines 8-9
function PunchingBagDamage:damage_melee(unit)
	return
end

-- Lines 11-12
function PunchingBagDamage:damage_bullet(unit)
	return
end

-- Lines 14-15
function PunchingBagDamage:damage_fire(unit)
	return
end

-- Lines 17-18
function PunchingBagDamage:damage_dot(unit)
	return
end

-- Lines 20-21
function PunchingBagDamage:damage_explosion(unit)
	return
end

-- Lines 23-24
function PunchingBagDamage:damage_tase(unit)
	return
end

-- Lines 26-27
function PunchingBagDamage:damage_mission(unit)
	return
end

-- Lines 30-32
function PunchingBagDamage:dead()
	return false
end
