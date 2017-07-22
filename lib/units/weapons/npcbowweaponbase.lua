NPCBowWeaponBase = NPCBowWeaponBase or class(NewNPCRaycastWeaponBase)

-- Lines: 3 to 5
function NPCBowWeaponBase:init(...)
	NPCBowWeaponBase.super.init(self, ...)
end

-- Lines: 10 to 18
function NPCBowWeaponBase:fire_blank(direction, impact)
	self:_sound_singleshot()

	if self:weapon_tweak_data().has_fire_animation then
		self:tweak_data_anim_play("fire")
	end
end
NPCCrossBowWeaponBase = NPCCrossBowWeaponBase or class(NPCBowWeaponBase)

return
