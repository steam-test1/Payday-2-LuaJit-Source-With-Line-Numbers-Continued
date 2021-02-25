WeaponGadgetBase = WeaponGadgetBase or class(UnitBase)
WeaponGadgetBase.GADGET_TYPE = ""

-- Lines 4-7
function WeaponGadgetBase:init(unit)
	WeaponGadgetBase.super.init(self, unit)

	self._on = false
end

-- Lines 9-10
function WeaponGadgetBase:set_npc()
end

-- Lines 12-25
function WeaponGadgetBase:set_state(on, sound_source, current_state)
	if not self:is_bipod() and not self:is_underbarrel() then
		self:_set_on(on, sound_source)
	end

	self:_check_state(current_state)
end

-- Lines 27-34
function WeaponGadgetBase:_set_on(on, sound_source)
	if self._on ~= on and sound_source and (self._on_event or self._off_event) then
		sound_source:post_event(on and self._on_event or self._off_event)
	end

	self._on = on
end

-- Lines 36-38
function WeaponGadgetBase:is_usable()
	return true
end

-- Lines 40-43
function WeaponGadgetBase:set_on()
	self._on = true

	self:_check_state()
end

-- Lines 45-48
function WeaponGadgetBase:set_off()
	self._on = false

	self:_check_state()
end

-- Lines 50-53
function WeaponGadgetBase:toggle()
	self._on = not self._on

	self:_check_state()
end

-- Lines 55-57
function WeaponGadgetBase:is_on()
	return self._on
end

-- Lines 59-61
function WeaponGadgetBase:toggle_requires_stance_update()
	return false
end

-- Lines 63-64
function WeaponGadgetBase:_check_state(current_state)
end

-- Lines 66-68
function WeaponGadgetBase:is_bipod()
	return false
end

-- Lines 71-73
function WeaponGadgetBase:is_underbarrel()
	return false
end

-- Lines 75-77
function WeaponGadgetBase:overrides_weapon_firing()
	return self:is_underbarrel()
end

-- Lines 82-84
function WeaponGadgetBase:destroy(unit)
	WeaponGadgetBase.super.pre_destroy(self, unit)
end
