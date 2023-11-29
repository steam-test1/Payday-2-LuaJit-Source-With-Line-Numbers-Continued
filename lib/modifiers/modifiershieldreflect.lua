ModifierShieldReflect = ModifierShieldReflect or class(BaseModifier)
ModifierShieldReflect._type = "ModifierShieldReflect"
ModifierShieldReflect.name_id = "none"
ModifierShieldReflect.desc_id = "menu_cs_modifier_shield_reflect"

-- Lines 7-11
function ModifierShieldReflect:init(...)
	ModifierShieldReflect.super.init(self, ...)

	self._shield_slotmask = managers.slot:get_mask("enemy_shield_check")
end

-- Lines 13-21
function ModifierShieldReflect:modify_value(id, value, hit_unit, unit)
	if id == "FragGrenade:ShouldReflect" then
		local is_shield = hit_unit:in_slot(self._shield_slotmask)

		if is_shield then
			return true
		end
	end

	return value
end
