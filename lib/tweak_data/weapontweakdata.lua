require("lib/tweak_data/WeaponFactoryTweakData")

WeaponTweakData = WeaponTweakData or class()

-- Lines: 5 to 293
function WeaponTweakData:init(tweak_data)
	self:_create_table_structure()
	self:_init_data_npc_melee()
	self:_init_data_player_weapons(tweak_data)
	self:_init_data_m4_npc()
	self:_init_data_m14_npc()
	self:_init_data_m14_sniper_npc()
	self:_init_data_c45_npc()
	self:_init_data_x_c45_npc()
	self:_init_data_beretta92_npc()
	self:_init_data_raging_bull_npc()
	self:_init_data_r870_npc()
	self:_init_data_mossberg_npc()
	self:_init_data_mp5_npc()
	self:_init_data_mac11_npc()
	self:_init_data_glock_18_npc()
	self:_init_data_ak47_npc()
	self:_init_data_g36_npc()
	self:_init_data_mp9_npc()
	self:_init_data_saiga_npc()
	self:_init_data_sentry_gun_npc()
	self:_init_data_swat_van_turret_module_npc()
	self:_init_data_ceiling_turret_module_npc()
	self:_init_data_s552_npc()
	self:_init_data_scar_npc()
	self:_init_data_hk21_npc()
	self:_init_data_m249_npc()
	self:_init_data_contraband_npc()
	self:_init_data_mini_npc()
	self:_init_data_m4_crew()
	self:_init_data_m14_crew()
	self:_init_data_c45_crew()
	self:_init_data_x_c45_crew()
	self:_init_data_beretta92_crew()
	self:_init_data_raging_bull_crew()
	self:_init_data_r870_crew()
	self:_init_data_mossberg_crew()
	self:_init_data_mp5_crew()
	self:_init_data_glock_18_crew()
	self:_init_data_ak47_crew()
	self:_init_data_g36_crew()
	self:_init_data_g17_crew()
	self:_init_data_mp9_crew()
	self:_init_data_olympic_crew()
	self:_init_data_m16_crew()
	self:_init_data_aug_crew()
	self:_init_data_ak74_crew()
	self:_init_data_ak5_crew()
	self:_init_data_p90_crew()
	self:_init_data_amcar_crew()
	self:_init_data_mac10_crew()
	self:_init_data_akmsu_crew()
	self:_init_data_akm_crew()
	self:_init_data_akm_gold_crew()
	self:_init_data_deagle_crew()
	self:_init_data_serbu_crew()
	self:_init_data_saiga_crew()
	self:_init_data_huntsman_crew()
	self:_init_data_saw_crew()
	self:_init_data_usp_crew()
	self:_init_data_g22c_crew()
	self:_init_data_judge_crew()
	self:_init_data_m45_crew()
	self:_init_data_s552_crew()
	self:_init_data_ppk_crew()
	self:_init_data_mp7_crew()
	self:_init_data_scar_crew()
	self:_init_data_p226_crew()
	self:_init_data_hk21_crew()
	self:_init_data_m249_crew()
	self:_init_data_rpk_crew()
	self:_init_data_m95_crew()
	self:_init_data_msr_crew()
	self:_init_data_r93_crew()
	self:_init_data_fal_crew()
	self:_init_data_ben_crew()
	self:_init_data_striker_crew()
	self:_init_data_ksg_crew()
	self:_init_data_gre_m79_crew()
	self:_init_data_g3_crew()
	self:_init_data_galil_crew()
	self:_init_data_famas_crew()
	self:_init_data_scorpion_crew()
	self:_init_data_tec9_crew()
	self:_init_data_uzi_crew()
	self:_init_data_jowi_crew()
	self:_init_data_x_1911_crew()
	self:_init_data_x_b92fs_crew()
	self:_init_data_x_deagle_crew()
	self:_init_data_g26_crew()
	self:_init_data_spas12_crew()
	self:_init_data_mg42_crew()
	self:_init_data_c96_crew()
	self:_init_data_sterling_crew()
	self:_init_data_mosin_crew()
	self:_init_data_m1928_crew()
	self:_init_data_l85a2_crew()
	self:_init_data_hs2000_crew()
	self:_init_data_vhs_crew()
	self:_init_data_m134_crew()
	self:_init_data_rpg7_crew()
	self:_init_data_cobray_crew()
	self:_init_data_b682_crew()
	self:_init_data_x_g22c_crew()
	self:_init_data_x_g17_crew()
	self:_init_data_x_usp_crew()
	self:_init_data_flamethrower_mk2_crew()
	self:_init_data_m32_crew()
	self:_init_data_aa12_crew()
	self:_init_data_peacemaker_crew()
	self:_init_data_winchester1874_crew()
	self:_init_data_plainsrider_crew()
	self:_init_data_mateba_crew()
	self:_init_data_asval_crew()
	self:_init_data_sub2000_crew()
	self:_init_data_wa2000_crew()
	self:_init_data_polymer_crew()
	self:_init_data_hunter_crew()
	self:_init_data_baka_crew()
	self:_init_data_arblast_crew()
	self:_init_data_frankish_crew()
	self:_init_data_long_crew()
	self:_init_data_par_crew()
	self:_init_data_sparrow_crew()
	self:_init_data_model70_crew()
	self:_init_data_m37_crew()
	self:_init_data_china_crew()
	self:_init_data_sr2_crew()
	self:_init_data_x_sr2_crew()
	self:_init_data_pl14_crew()
	self:_init_data_x_mp5_crew()
	self:_init_data_x_akmsu_crew()
	self:_init_data_tecci_crew()
	self:_init_data_hajk_crew()
	self:_init_data_boot_crew()
	self:_init_data_packrat_crew()
	self:_init_data_schakal_crew()
	self:_init_data_desertfox_crew()
	self:_init_data_x_packrat_crew()
	self:_init_data_rota_crew()
	self:_init_data_arbiter_crew()
	self:_init_data_contraband_crew()
	self:_init_data_ray_crew()
	self:_init_data_tti_crew()
	self:_init_data_siltstone_crew()
	self:_init_data_flint_crew()
	self:_init_data_coal_crew()
	self:_init_data_lemming_crew()
	self:_init_data_chinchilla_crew()
	self:_init_data_x_chinchilla_crew()
	self:_init_data_breech_crew()
	self:_init_data_ching_crew()
	self:_init_data_erma_crew()
	self:_init_data_basset_crew()
	self:_init_data_x_basset_crew()
	self:_precalculate_values()
end

-- Lines: 296 to 297
function WeaponTweakData:_set_easy()
end

-- Lines: 300 to 319
function WeaponTweakData:_set_normal()
	self.swat_van_turret_module.HEALTH_INIT = 3500
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 70
	self.swat_van_turret_module.DAMAGE = 0.2
	self.ak47_ass_npc.DAMAGE = 0.1
	self.mp5_npc.DAMAGE = 0.3
	self.r870_npc.DAMAGE = 0.4
	self.m4_npc.DAMAGE = 0.4
	self.c45_npc.DAMAGE = 0.1
	self.raging_bull_npc.DAMAGE = 0.6
	self.ump_npc.DAMAGE = 0.3
	self.mp9_npc.DAMAGE = 0.1
	self.m14_sniper_npc.DAMAGE = 1
	self.mac11_npc.DAMAGE = 0.3
	self.ceiling_turret_module.HEALTH_INIT = 875
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 2
	self.ceiling_turret_module.DAMAGE = 0.2
end

-- Lines: 322 to 335
function WeaponTweakData:_set_hard()
	self.swat_van_turret_module.HEALTH_INIT = 3500
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 70
	self.swat_van_turret_module.DAMAGE = 0.5
	self.ak47_ass_npc.DAMAGE = 0.4
	self.m4_npc.DAMAGE = 0.4
	self.g36_npc.DAMAGE = 0.6
	self.r870_npc.DAMAGE = 1
	self.ceiling_turret_module.HEALTH_INIT = 875
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 70
	self.ceiling_turret_module.DAMAGE = 0.5
end

-- Lines: 338 to 346
function WeaponTweakData:_set_overkill()
	self.swat_van_turret_module.HEALTH_INIT = 12500
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 300
	self.swat_van_turret_module.DAMAGE = 1.3
	self.ceiling_turret_module.HEALTH_INIT = 6250
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 150
	self.ceiling_turret_module.DAMAGE = 1.3
end

-- Lines: 348 to 359
function WeaponTweakData:_set_overkill_145()
	self.ak47_ass_npc.DAMAGE = 2
	self.swat_van_turret_module.HEALTH_INIT = 25000
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 500
	self.swat_van_turret_module.DAMAGE = 2
	self.ceiling_turret_module.HEALTH_INIT = 12500
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 250
	self.ceiling_turret_module.DAMAGE = 2
end

-- Lines: 361 to 374
function WeaponTweakData:_set_easy_wish()
	self.ak47_ass_npc.DAMAGE = 2.5
	self.swat_van_turret_module.HEALTH_INIT = 40000
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 700
	self.swat_van_turret_module.DAMAGE = 3.5
	self.swat_van_turret_module.CLIP_SIZE = 800
	self.ceiling_turret_module.HEALTH_INIT = 20000
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 350
	self.ceiling_turret_module.DAMAGE = 3.5
	self.ceiling_turret_module.CLIP_SIZE = 800
end

-- Lines: 376 to 389
function WeaponTweakData:_set_overkill_290()
	self.ak47_ass_npc.DAMAGE = 3
	self.swat_van_turret_module.HEALTH_INIT = 40000
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 700
	self.swat_van_turret_module.DAMAGE = 3.5
	self.swat_van_turret_module.CLIP_SIZE = 800
	self.ceiling_turret_module.HEALTH_INIT = 20000
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 350
	self.ceiling_turret_module.DAMAGE = 3.5
	self.ceiling_turret_module.CLIP_SIZE = 800
end

-- Lines: 392 to 409
function WeaponTweakData:_set_sm_wish()
	self.ak47_ass_npc.DAMAGE = 3
	self.m4_npc.DAMAGE = 3
	self.g36_npc.DAMAGE = 5
	self.r870_npc.DAMAGE = 7
	self.swat_van_turret_module.HEALTH_INIT = 40000
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 700
	self.swat_van_turret_module.DAMAGE = 3.5
	self.swat_van_turret_module.CLIP_SIZE = 800
	self.ceiling_turret_module.HEALTH_INIT = 20000
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 350
	self.ceiling_turret_module.DAMAGE = 3.5
	self.ceiling_turret_module.CLIP_SIZE = 800
end

-- Lines: 413 to 450
function WeaponTweakData:_init_data_npc_melee()
	self.npc_melee = {baton = {}}
	self.npc_melee.baton.unit_name = Idstring("units/payday2/characters/ene_acc_baton/ene_acc_baton")
	self.npc_melee.baton.damage = 10
	self.npc_melee.baton.animation_param = "melee_baton"
	self.npc_melee.baton.player_blood_effect = true
	self.npc_melee.knife_1 = {
		unit_name = Idstring("units/payday2/characters/ene_acc_knife_1/ene_acc_knife_1"),
		damage = 15,
		animation_param = "melee_knife",
		player_blood_effect = true
	}
	self.npc_melee.fists = {
		unit_name = nil,
		damage = 8,
		animation_param = "melee_fist",
		player_blood_effect = true
	}
	self.npc_melee.helloween = {
		unit_name = Idstring("units/pd2_halloween/weapons/wpn_mel_titan_hammer/wpn_mel_titan_hammer"),
		damage = 10,
		animation_param = "melee_fireaxe",
		player_blood_effect = true
	}
end

-- Lines: 452 to 456
function WeaponTweakData:_set_npc_weapon_damage_multiplier(mul)
	for name, data in pairs(self.npc_melee) do
		data.damage = data.damage * mul
	end
end

-- Lines: 461 to 480
function WeaponTweakData:_init_data_c45_npc()
	self.c45_npc.sounds.prefix = "c45_npc"
	self.c45_npc.use_data.selection_index = 1
	self.c45_npc.DAMAGE = 1
	self.c45_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.c45_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.c45_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.c45_npc.CLIP_AMMO_MAX = 10
	self.c45_npc.NR_CLIPS_MAX = 9
	self.c45_npc.hold = "pistol"
	self.c45_npc.alert_size = 2500
	self.c45_npc.suppression = 1
	self.colt_1911_primary_npc = deep_clone(self.c45_npc)
	self.colt_1911_primary_npc.use_data.selection_index = 2
end

-- Lines: 485 to 501
function WeaponTweakData:_init_data_x_c45_npc()
	self.x_c45_npc.sounds.prefix = "c45_npc"
	self.x_c45_npc.use_data.selection_index = 2
	self.x_c45_npc.DAMAGE = 1
	self.x_c45_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_c45_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_c45_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_c45_npc.CLIP_AMMO_MAX = 20
	self.x_c45_npc.NR_CLIPS_MAX = 5
	self.x_c45_npc.hold = "akimbo_pistol"
	self.x_c45_npc.alert_size = 2500
	self.x_c45_npc.suppression = 1
end

-- Lines: 506 to 522
function WeaponTweakData:_init_data_beretta92_npc()
	self.beretta92_npc.sounds.prefix = "beretta_npc"
	self.beretta92_npc.use_data.selection_index = 1
	self.beretta92_npc.DAMAGE = 1
	self.beretta92_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.beretta92_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.beretta92_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.beretta92_npc.CLIP_AMMO_MAX = 14
	self.beretta92_npc.NR_CLIPS_MAX = 11
	self.beretta92_npc.hold = "pistol"
	self.beretta92_npc.alert_size = 300
	self.beretta92_npc.suppression = 0.3
end

-- Lines: 525 to 544
function WeaponTweakData:_init_data_glock_18_npc()
	self.glock_18_npc.sounds.prefix = "g18c_npc"
	self.glock_18_npc.use_data.selection_index = 1
	self.glock_18_npc.DAMAGE = 1
	self.glock_18_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.glock_18_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.glock_18_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.glock_18_npc.CLIP_AMMO_MAX = 20
	self.glock_18_npc.NR_CLIPS_MAX = 8
	self.glock_18_npc.hold = "pistol"
	self.glock_18_npc.auto = {fire_rate = 0.092}
	self.glock_18_npc.alert_size = 2500
	self.glock_18_npc.suppression = 0.45
end

-- Lines: 548 to 564
function WeaponTweakData:_init_data_raging_bull_npc()
	self.raging_bull_npc.sounds.prefix = "rbull_npc"
	self.raging_bull_npc.use_data.selection_index = 1
	self.raging_bull_npc.DAMAGE = 4
	self.raging_bull_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.raging_bull_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.raging_bull_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.raging_bull_npc.CLIP_AMMO_MAX = 6
	self.raging_bull_npc.NR_CLIPS_MAX = 8
	self.raging_bull_npc.hold = "pistol"
	self.raging_bull_npc.alert_size = 5000
	self.raging_bull_npc.suppression = 1.8
end

-- Lines: 568 to 593
function WeaponTweakData:_init_data_m4_npc()
	self.m4_npc.sounds.prefix = "m4_npc"
	self.m4_npc.use_data.selection_index = 2
	self.m4_npc.DAMAGE = 1
	self.m4_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.m4_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m4_npc.CLIP_AMMO_MAX = 30
	self.m4_npc.NR_CLIPS_MAX = 5
	self.m4_npc.auto.fire_rate = 0.175
	self.m4_npc.hold = "rifle"
	self.m4_npc.alert_size = 5000
	self.m4_npc.suppression = 1
	self.ak47_ass_npc = deep_clone(self.m4_npc)
end

-- Lines: 596 to 617
function WeaponTweakData:_init_data_ak47_npc()
	self.ak47_npc.sounds.prefix = "akm_npc"
	self.ak47_npc.use_data.selection_index = 2
	self.ak47_npc.DAMAGE = 3
	self.ak47_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.ak47_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ak47_npc.CLIP_AMMO_MAX = 30
	self.ak47_npc.NR_CLIPS_MAX = 5
	self.ak47_npc.auto.fire_rate = 0.2
	self.ak47_npc.hold = "rifle"
	self.ak47_npc.alert_size = 5000
	self.ak47_npc.suppression = 1
end

-- Lines: 622 to 639
function WeaponTweakData:_init_data_m14_npc()
	self.m14_npc.sounds.prefix = "m14_npc"
	self.m14_npc.use_data.selection_index = 2
	self.m14_npc.DAMAGE = 4
	self.m14_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.m14_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m14_npc.CLIP_AMMO_MAX = 10
	self.m14_npc.NR_CLIPS_MAX = 8
	self.m14_npc.auto.fire_rate = 0.2
	self.m14_npc.hold = "rifle"
	self.m14_npc.alert_size = 5000
	self.m14_npc.suppression = 1
end

-- Lines: 643 to 672
function WeaponTweakData:_init_data_m14_sniper_npc()
	self.m14_sniper_npc.sounds.prefix = "sniper_npc"
	self.m14_sniper_npc.use_data.selection_index = 2
	self.m14_sniper_npc.DAMAGE = 2
	self.m14_sniper_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.m14_sniper_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m14_sniper_npc.CLIP_AMMO_MAX = 6
	self.m14_sniper_npc.NR_CLIPS_MAX = 8
	self.m14_sniper_npc.hold = "rifle"
	self.m14_sniper_npc.alert_size = 5000
	self.m14_sniper_npc.suppression = 1
	self.m14_sniper_npc.armor_piercing = true
	self.svd_snp_npc = deep_clone(self.m14_sniper_npc)
	self.svdsil_snp_npc = deep_clone(self.m14_sniper_npc)
	self.svdsil_snp_npc.has_suppressor = "suppressed_a"
	self.heavy_snp_npc = deep_clone(self.m14_sniper_npc)
	self.heavy_snp_npc.sounds.prefix = "zsniper_npc"
end

-- Lines: 678 to 704
function WeaponTweakData:_init_data_r870_npc()
	self.r870_npc.sounds.prefix = "remington_npc"
	self.r870_npc.use_data.selection_index = 2
	self.r870_npc.DAMAGE = 5
	self.r870_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.r870_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.r870_npc.CLIP_AMMO_MAX = 6
	self.r870_npc.NR_CLIPS_MAX = 4
	self.r870_npc.hold = "rifle"
	self.r870_npc.alert_size = 4500
	self.r870_npc.suppression = 1.8
	self.r870_npc.is_shotgun = true
	self.r870_npc.rays = 12
	self.r870_npc.spread = 3
	self.benelli_npc = deep_clone(self.r870_npc)
end

-- Lines: 709 to 728
function WeaponTweakData:_init_data_mossberg_npc()
	self.mossberg_npc.sounds.prefix = "mossberg_npc"
	self.mossberg_npc.use_data.selection_index = 2
	self.mossberg_npc.DAMAGE = 6
	self.mossberg_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.mossberg_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.mossberg_npc.CLIP_AMMO_MAX = 6
	self.mossberg_npc.NR_CLIPS_MAX = 4
	self.mossberg_npc.hold = "rifle"
	self.mossberg_npc.alert_size = 3000
	self.mossberg_npc.suppression = 2
	self.mossberg_npc.is_shotgun = true
	self.mossberg_npc.rays = 12
	self.mossberg_npc.spread = 3
end

-- Lines: 733 to 763
function WeaponTweakData:_init_data_mp5_npc()
	self.mp5_npc.sounds.prefix = "mp5_npc"
	self.mp5_npc.use_data.selection_index = 1
	self.mp5_npc.DAMAGE = 1
	self.mp5_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mp5_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mp5_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mp5_npc.CLIP_AMMO_MAX = 30
	self.mp5_npc.NR_CLIPS_MAX = 5
	self.mp5_npc.auto.fire_rate = 0.12
	self.mp5_npc.hold = "rifle"
	self.mp5_npc.alert_size = 2500
	self.mp5_npc.suppression = 1
	self.mp5_tactical_npc = deep_clone(self.mp5_npc)
	self.mp5_tactical_npc.has_suppressor = "suppressed_a"
	self.ump_npc = deep_clone(self.mp5_npc)
	self.akmsu_smg_npc = deep_clone(self.mp5_npc)
	self.asval_smg_npc = deep_clone(self.mp5_npc)
	self.asval_smg_npc.has_suppressor = "suppressed_a"
end

-- Lines: 768 to 786
function WeaponTweakData:_init_data_mac11_npc()
	self.mac11_npc.sounds.prefix = "mp5_npc"
	self.mac11_npc.use_data.selection_index = 1
	self.mac11_npc.DAMAGE = 1
	self.mac11_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mac11_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mac11_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mac11_npc.CLIP_AMMO_MAX = 40
	self.mac11_npc.NR_CLIPS_MAX = 5
	self.mac11_npc.auto.fire_rate = 0.11
	self.mac11_npc.hold = {
		"uzi",
		"pistol"
	}
	self.mac11_npc.alert_size = 2500
	self.mac11_npc.suppression = 1
end

-- Lines: 790 to 812
function WeaponTweakData:_init_data_g36_npc()
	self.g36_npc.sounds.prefix = "g36_npc"
	self.g36_npc.use_data.selection_index = 2
	self.g36_npc.DAMAGE = 3
	self.g36_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.g36_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.g36_npc.CLIP_AMMO_MAX = 30
	self.g36_npc.NR_CLIPS_MAX = 5
	self.g36_npc.auto.fire_rate = 0.15
	self.g36_npc.hold = "rifle"
	self.g36_npc.alert_size = 5000
	self.g36_npc.suppression = 1
end

-- Lines: 814 to 836
function WeaponTweakData:_init_data_mp9_npc()
	self.mp9_npc.sounds.prefix = "mp9_npc"
	self.mp9_npc.use_data.selection_index = 1
	self.mp9_npc.DAMAGE = 1
	self.mp9_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mp9_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mp9_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mp9_npc.CLIP_AMMO_MAX = 30
	self.mp9_npc.NR_CLIPS_MAX = 5
	self.mp9_npc.auto.fire_rate = 0.125
	self.mp9_npc.hold = "pistol"
	self.mp9_npc.alert_size = 1000
	self.mp9_npc.suppression = 1
	self.sr2_smg_npc = deep_clone(self.mp9_npc)
end

-- Lines: 838 to 859
function WeaponTweakData:_init_data_saiga_npc()
	self.saiga_npc.sounds.prefix = "saiga_npc"
	self.saiga_npc.use_data.selection_index = 2
	self.saiga_npc.DAMAGE = 3
	self.saiga_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.saiga_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.saiga_npc.auto.fire_rate = 0.14
	self.saiga_npc.CLIP_AMMO_MAX = 7
	self.saiga_npc.NR_CLIPS_MAX = 10
	self.saiga_npc.hold = "rifle"
	self.saiga_npc.alert_size = 4500
	self.saiga_npc.suppression = 1.8
	self.saiga_npc.is_shotgun = true
	self.saiga_npc.rays = 12
	self.saiga_npc.spread = 3
end

-- Lines: 869 to 912
function WeaponTweakData:_init_data_sentry_gun_npc()
	self.sentry_gun.categories = {}
	self.sentry_gun.name_id = "debug_sentry_gun"
	self.sentry_gun.DAMAGE = 3
	self.sentry_gun.SUPPRESSION = 1
	self.sentry_gun.SPREAD = 5
	self.sentry_gun.FIRE_RANGE = 5000
	self.sentry_gun.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.sentry_gun.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.sentry_gun.auto.fire_rate = 0.15
	self.sentry_gun.alert_size = 2500
	self.sentry_gun.BAG_DMG_MUL = 0.25
	self.sentry_gun.SHIELD_DMG_MUL = 0
	self.sentry_gun.DEATH_VERIFICATION = {
		0.4,
		0.75
	}
	self.sentry_gun.DETECTION_RANGE = self.sentry_gun.FIRE_RANGE
	self.sentry_gun.KEEP_FIRE_ANGLE = 0.8
	self.sentry_gun.DETECTION_DELAY = {
		{
			600,
			0.1
		},
		{
			self.sentry_gun.DETECTION_RANGE,
			0.5
		}
	}
	self.sentry_gun.MAX_VEL_SPIN = 120
	self.sentry_gun.MIN_VEL_SPIN = self.sentry_gun.MAX_VEL_SPIN * 0.05
	self.sentry_gun.SLOWDOWN_ANGLE_SPIN = 30
	self.sentry_gun.ACC_SPIN = self.sentry_gun.MAX_VEL_SPIN * 5
	self.sentry_gun.MAX_VEL_PITCH = 100
	self.sentry_gun.MIN_VEL_PITCH = self.sentry_gun.MAX_VEL_PITCH * 0.05
	self.sentry_gun.SLOWDOWN_ANGLE_PITCH = 20
	self.sentry_gun.ACC_PITCH = self.sentry_gun.MAX_VEL_PITCH * 5
	self.sentry_gun.recoil = {
		horizontal = {
			2,
			3,
			0,
			3
		},
		vertical = {
			1,
			2,
			0,
			4
		}
	}
	self.sentry_gun.challenges = {
		group = "sentry_gun",
		weapon = "sentry_gun"
	}
	self.sentry_gun.suppression = 0.8
end

-- Lines: 916 to 987
function WeaponTweakData:_init_data_swat_van_turret_module_npc()
	self.swat_van_turret_module.name_id = "debug_sentry_gun"
	self.swat_van_turret_module.DAMAGE = 3
	self.swat_van_turret_module.DAMAGE_MUL_RANGE = {
		{
			800,
			4
		},
		{
			1000,
			1.1
		},
		{
			1500,
			1
		}
	}
	self.swat_van_turret_module.SUPPRESSION = 1
	self.swat_van_turret_module.SPREAD = 0.5
	self.swat_van_turret_module.FIRE_RANGE = 10000
	self.swat_van_turret_module.CLIP_SIZE = 400
	self.swat_van_turret_module.AUTO_RELOAD = true
	self.swat_van_turret_module.AUTO_RELOAD_DURATION = 8
	self.swat_van_turret_module.CAN_GO_IDLE = true
	self.swat_van_turret_module.IDLE_WAIT_TIME = 5
	self.swat_van_turret_module.AUTO_REPAIR = true
	self.swat_van_turret_module.AUTO_REPAIR_MAX_COUNT = 2
	self.swat_van_turret_module.AUTO_REPAIR_DURATION = 30
	self.swat_van_turret_module.ECM_HACKABLE = true
	self.swat_van_turret_module.FLASH_GRENADE = {
		effect_duration = 6,
		range = 300,
		chance = 1,
		check_interval = {
			1,
			1
		},
		quiet_time = {
			10,
			13
		}
	}
	self.swat_van_turret_module.HACKABLE_WITH_ECM = true
	self.swat_van_turret_module.VELOCITY_COMPENSATION = {
		OVERCOMPENSATION = 50,
		SNAPSHOT_INTERVAL = 0.3
	}
	self.swat_van_turret_module.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.swat_van_turret_module.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.swat_van_turret_module.auto.fire_rate = 0.06
	self.swat_van_turret_module.alert_size = 2500
	self.swat_van_turret_module.headshot_dmg_mul = 4
	self.swat_van_turret_module.EXPLOSION_DMG_MUL = 7
	self.swat_van_turret_module.FIRE_DMG_MUL = 0.1
	self.swat_van_turret_module.BAG_DMG_MUL = 100
	self.swat_van_turret_module.SHIELD_DMG_MUL = 1
	self.swat_van_turret_module.HEALTH_INIT = 5000
	self.swat_van_turret_module.SHIELD_HEALTH_INIT = 1000
	self.swat_van_turret_module.SHIELD_DAMAGE_CLAMP = 350
	self.swat_van_turret_module.BODY_DAMAGE_CLAMP = 4200
	self.swat_van_turret_module.DEATH_VERIFICATION = {
		0.4,
		0.75
	}
	self.swat_van_turret_module.DETECTION_RANGE = 8000
	self.swat_van_turret_module.DETECTION_DELAY = {
		{
			900,
			0.3
		},
		{
			3500,
			1.5
		}
	}
	self.swat_van_turret_module.KEEP_FIRE_ANGLE = 0.9
	self.swat_van_turret_module.MAX_VEL_SPIN = 72
	self.swat_van_turret_module.MIN_VEL_SPIN = self.swat_van_turret_module.MAX_VEL_SPIN * 0.05
	self.swat_van_turret_module.SLOWDOWN_ANGLE_SPIN = 30
	self.swat_van_turret_module.ACC_SPIN = self.swat_van_turret_module.MAX_VEL_SPIN * 5
	self.swat_van_turret_module.MAX_VEL_PITCH = 60
	self.swat_van_turret_module.MIN_VEL_PITCH = self.swat_van_turret_module.MAX_VEL_PITCH * 0.05
	self.swat_van_turret_module.SLOWDOWN_ANGLE_PITCH = 20
	self.swat_van_turret_module.ACC_PITCH = self.swat_van_turret_module.MAX_VEL_PITCH * 5
	self.swat_van_turret_module.recoil = {
		horizontal = {
			1,
			1.5,
			1,
			1
		},
		vertical = {
			1,
			1.5,
			1,
			1
		}
	}
	self.swat_van_turret_module.challenges = {
		group = "sentry_gun",
		weapon = "sentry_gun"
	}
	self.swat_van_turret_module.suppression = 0.8
end

-- Lines: 989 to 1065
function WeaponTweakData:_init_data_ceiling_turret_module_npc()
	self.ceiling_turret_module.name_id = "debug_sentry_gun"
	self.ceiling_turret_module.DAMAGE = 3
	self.ceiling_turret_module.DAMAGE_MUL_RANGE = {
		{
			800,
			4
		},
		{
			1000,
			1.1
		},
		{
			1500,
			1
		}
	}
	self.ceiling_turret_module.SUPPRESSION = 1
	self.ceiling_turret_module.SPREAD = 0.5
	self.ceiling_turret_module.FIRE_RANGE = 10000
	self.ceiling_turret_module.CLIP_SIZE = 400
	self.ceiling_turret_module.AUTO_RELOAD = true
	self.ceiling_turret_module.AUTO_RELOAD_DURATION = 8
	self.ceiling_turret_module.CAN_GO_IDLE = true
	self.ceiling_turret_module.IDLE_WAIT_TIME = 5
	self.ceiling_turret_module.AUTO_REPAIR = false
	self.ceiling_turret_module.AUTO_REPAIR_MAX_COUNT = 2
	self.ceiling_turret_module.AUTO_REPAIR_DURATION = 30
	self.ceiling_turret_module.ECM_HACKABLE = true
	self.ceiling_turret_module.FLASH_GRENADE = {
		effect_duration = 6,
		range = 300,
		chance = 1,
		check_interval = {
			1,
			1
		},
		quiet_time = {
			10,
			13
		}
	}
	self.ceiling_turret_module.HACKABLE_WITH_ECM = true
	self.ceiling_turret_module.VELOCITY_COMPENSATION = {
		OVERCOMPENSATION = 50,
		SNAPSHOT_INTERVAL = 0.3
	}
	self.ceiling_turret_module.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.ceiling_turret_module.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.ceiling_turret_module.auto.fire_rate = 0.06
	self.ceiling_turret_module.alert_size = 2500
	self.ceiling_turret_module.headshot_dmg_mul = 4
	self.ceiling_turret_module.EXPLOSION_DMG_MUL = 7
	self.ceiling_turret_module.FIRE_DMG_MUL = 0.1
	self.ceiling_turret_module.BAG_DMG_MUL = 100
	self.ceiling_turret_module.SHIELD_DMG_MUL = 1
	self.ceiling_turret_module.HEALTH_INIT = 1250
	self.ceiling_turret_module.SHIELD_HEALTH_INIT = 2
	self.ceiling_turret_module.SHIELD_DAMAGE_CLAMP = 350
	self.ceiling_turret_module.BODY_DAMAGE_CLAMP = 4200
	self.ceiling_turret_module.DEATH_VERIFICATION = {
		0.4,
		0.75
	}
	self.ceiling_turret_module.DETECTION_RANGE = self.ceiling_turret_module.FIRE_RANGE
	self.ceiling_turret_module.DETECTION_DELAY = {
		{
			900,
			0.3
		},
		{
			3500,
			1.5
		}
	}
	self.ceiling_turret_module.KEEP_FIRE_ANGLE = 0.9
	self.ceiling_turret_module.MAX_VEL_SPIN = 72
	self.ceiling_turret_module.MIN_VEL_SPIN = self.ceiling_turret_module.MAX_VEL_SPIN * 0.05
	self.ceiling_turret_module.SLOWDOWN_ANGLE_SPIN = 30
	self.ceiling_turret_module.ACC_SPIN = self.ceiling_turret_module.MAX_VEL_SPIN * 5
	self.ceiling_turret_module.MAX_VEL_PITCH = 60
	self.ceiling_turret_module.MIN_VEL_PITCH = self.ceiling_turret_module.MAX_VEL_PITCH * 0.05
	self.ceiling_turret_module.SLOWDOWN_ANGLE_PITCH = 20
	self.ceiling_turret_module.ACC_PITCH = self.ceiling_turret_module.MAX_VEL_PITCH * 5
	self.ceiling_turret_module.recoil = {
		horizontal = {
			1,
			1.5,
			1,
			1
		},
		vertical = {
			1,
			1.5,
			1,
			1
		}
	}
	self.ceiling_turret_module.challenges = {
		group = "sentry_gun",
		weapon = "sentry_gun"
	}
	self.ceiling_turret_module.suppression = 0.8
	self.ceiling_turret_module_no_idle = deep_clone(self.ceiling_turret_module)
	self.ceiling_turret_module_no_idle.CAN_GO_IDLE = false
end

-- Lines: 1069 to 1087
function WeaponTweakData:_init_data_s552_npc()
	self.s552_npc.sounds.prefix = "sig552_npc"
	self.s552_npc.use_data.selection_index = 2
	self.s552_npc.DAMAGE = 2
	self.s552_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.s552_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.s552_npc.CLIP_AMMO_MAX = 30
	self.s552_npc.NR_CLIPS_MAX = 5
	self.s552_npc.auto.fire_rate = 0.15
	self.s552_npc.hold = "rifle"
	self.s552_npc.alert_size = 5000
	self.s552_npc.suppression = 1
end

-- Lines: 1093 to 1110
function WeaponTweakData:_init_data_scar_npc()
	self.scar_npc.sounds.prefix = "scar_npc"
	self.scar_npc.use_data.selection_index = 2
	self.scar_npc.DAMAGE = 2
	self.scar_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.scar_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.scar_npc.CLIP_AMMO_MAX = 20
	self.scar_npc.NR_CLIPS_MAX = 5
	self.scar_npc.auto.fire_rate = 0.15
	self.scar_npc.hold = "rifle"
	self.scar_npc.alert_size = 5000
	self.scar_npc.suppression = 1
end

-- Lines: 1115 to 1132
function WeaponTweakData:_init_data_hk21_npc()
	self.hk21_npc.sounds.prefix = "hk23e_npc"
	self.hk21_npc.use_data.selection_index = 2
	self.hk21_npc.DAMAGE = 2
	self.hk21_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.hk21_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.hk21_npc.CLIP_AMMO_MAX = 150
	self.hk21_npc.NR_CLIPS_MAX = 5
	self.hk21_npc.auto.fire_rate = 0.15
	self.hk21_npc.hold = "rifle"
	self.hk21_npc.alert_size = 5000
	self.hk21_npc.suppression = 1
end

-- Lines: 1136 to 1159
function WeaponTweakData:_init_data_m249_npc()
	self.m249_npc.sounds.prefix = "m249_npc"
	self.m249_npc.use_data.selection_index = 2
	self.m249_npc.DAMAGE = 2
	self.m249_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.m249_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.m249_npc.CLIP_AMMO_MAX = 200
	self.m249_npc.NR_CLIPS_MAX = 2
	self.m249_npc.auto.fire_rate = 0.08
	self.m249_npc.hold = "rifle"
	self.m249_npc.alert_size = 5000
	self.m249_npc.suppression = 1
	self.rpk_lmg_npc = deep_clone(self.m249_npc)
end

-- Lines: 1162 to 1181
function WeaponTweakData:_init_data_mini_npc()
	self.mini_npc.sounds.prefix = "minigun_npc"
	self.mini_npc.use_data.selection_index = 2
	self.mini_npc.DAMAGE = 2
	self.mini_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.mini_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.mini_npc.CLIP_AMMO_MAX = 1000
	self.mini_npc.NR_CLIPS_MAX = 2
	self.mini_npc.auto.fire_rate = 0.02
	self.mini_npc.hold = "rifle"
	self.mini_npc.alert_size = 5000
	self.mini_npc.suppression = 1
end

-- Lines: 1186 to 1224
function WeaponTweakData:_init_data_contraband_npc()
	self.contraband_npc.sounds.prefix = "contraband_npc"
	self.contraband_npc.use_data.selection_index = 2
	self.contraband_npc.DAMAGE = 2
	self.contraband_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.contraband_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.contraband_npc.CLIP_AMMO_MAX = 20
	self.contraband_npc.NR_CLIPS_MAX = 5
	self.contraband_npc.auto.fire_rate = 0.15
	self.contraband_npc.hold = "rifle"
	self.contraband_npc.alert_size = 5000
	self.contraband_npc.suppression = 1
	self.contraband_m203_npc.sounds.prefix = "contrabandm203_npc"
	self.contraband_m203_npc.use_data.selection_index = 2
	self.contraband_m203_npc.DAMAGE = 2
	self.contraband_m203_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.contraband_m203_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.contraband_m203_npc.no_trail = true
	self.contraband_m203_npc.CLIP_AMMO_MAX = 1
	self.contraband_m203_npc.NR_CLIPS_MAX = 4
	self.contraband_m203_npc.looped_reload_speed = 0.16666666666666666
	self.contraband_m203_npc.auto.fire_rate = 0.1
	self.contraband_m203_npc.hold = "rifle"
	self.contraband_m203_npc.alert_size = 2800
	self.contraband_m203_npc.suppression = 1
end

-- Lines: 1230 to 1250
function WeaponTweakData:_init_data_c45_crew()
	self.c45_crew.sounds.prefix = "c45_npc"
	self.c45_crew.use_data.selection_index = 1
	self.c45_crew.DAMAGE = 1
	self.c45_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.c45_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.c45_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.c45_crew.CLIP_AMMO_MAX = 10
	self.c45_crew.NR_CLIPS_MAX = 9
	self.c45_crew.pull_magazine_during_reload = "pistol"
	self.c45_crew.hold = "pistol"
	self.c45_crew.alert_size = 2500
	self.c45_crew.suppression = 1
	self.colt_1911_primary_crew = deep_clone(self.c45_crew)
	self.colt_1911_primary_crew.use_data.selection_index = 2
end

-- Lines: 1255 to 1271
function WeaponTweakData:_init_data_x_c45_crew()
	self.x_c45_crew.sounds.prefix = "c45_npc"
	self.x_c45_crew.use_data.selection_index = 2
	self.x_c45_crew.DAMAGE = 1
	self.x_c45_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_c45_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_c45_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_c45_crew.CLIP_AMMO_MAX = 20
	self.x_c45_crew.NR_CLIPS_MAX = 5
	self.x_c45_crew.hold = "akimbo_pistol"
	self.x_c45_crew.alert_size = 2500
	self.x_c45_crew.suppression = 1
end

-- Lines: 1276 to 1296
function WeaponTweakData:_init_data_beretta92_crew()
	self.beretta92_crew.sounds.prefix = "beretta_npc"
	self.beretta92_crew.use_data.selection_index = 1
	self.beretta92_crew.DAMAGE = 1
	self.beretta92_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.beretta92_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.beretta92_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.beretta92_crew.CLIP_AMMO_MAX = 14
	self.beretta92_crew.NR_CLIPS_MAX = 11
	self.beretta92_crew.pull_magazine_during_reload = "pistol"
	self.beretta92_crew.hold = "pistol"
	self.beretta92_crew.alert_size = 300
	self.beretta92_crew.suppression = 0.3
	self.beretta92_primary_crew = deep_clone(self.beretta92_crew)
	self.beretta92_primary_crew.use_data.selection_index = 2
end

-- Lines: 1299 to 1322
function WeaponTweakData:_init_data_glock_18_crew()
	self.glock_18_crew.sounds.prefix = "g18c_npc"
	self.glock_18_crew.use_data.selection_index = 1
	self.glock_18_crew.DAMAGE = 1
	self.glock_18_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.glock_18_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.glock_18_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.glock_18_crew.CLIP_AMMO_MAX = 20
	self.glock_18_crew.NR_CLIPS_MAX = 8
	self.glock_18_crew.pull_magazine_during_reload = "pistol"
	self.glock_18_crew.hold = "pistol"
	self.glock_18_crew.auto = {fire_rate = 0.066}
	self.glock_18_crew.alert_size = 2500
	self.glock_18_crew.suppression = 0.45
	self.glock_18c_primary_crew = deep_clone(self.glock_18_crew)
	self.glock_18c_primary_crew.use_data.selection_index = 2
end

-- Lines: 1326 to 1346
function WeaponTweakData:_init_data_raging_bull_crew()
	self.raging_bull_crew.sounds.prefix = "rbull_npc"
	self.raging_bull_crew.use_data.selection_index = 1
	self.raging_bull_crew.DAMAGE = 4
	self.raging_bull_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.raging_bull_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.raging_bull_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.raging_bull_crew.CLIP_AMMO_MAX = 6
	self.raging_bull_crew.NR_CLIPS_MAX = 8
	self.raging_bull_crew.hold = "pistol"
	self.raging_bull_crew.reload = "revolver"
	self.raging_bull_crew.alert_size = 5000
	self.raging_bull_crew.suppression = 1.8
	self.raging_bull_primary_crew = deep_clone(self.raging_bull_crew)
	self.raging_bull_primary_crew.use_data.selection_index = 2
end

-- Lines: 1350 to 1379
function WeaponTweakData:_init_data_m4_crew()
	self.m4_crew.sounds.prefix = "m4_npc"
	self.m4_crew.use_data.selection_index = 2
	self.m4_crew.DAMAGE = 1.5
	self.m4_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.m4_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m4_crew.CLIP_AMMO_MAX = 30
	self.m4_crew.NR_CLIPS_MAX = 5
	self.m4_crew.pull_magazine_during_reload = "rifle"
	self.m4_crew.auto.fire_rate = 0.1
	self.m4_crew.hold = "rifle"
	self.m4_crew.alert_size = 5000
	self.m4_crew.suppression = 1
	self.m4_secondary_crew = deep_clone(self.m4_crew)
	self.m4_secondary_crew.use_data.selection_index = 1
	self.ak47_ass_crew = deep_clone(self.m4_crew)
end

-- Lines: 1382 to 1403
function WeaponTweakData:_init_data_ak47_crew()
	self.ak47_crew.sounds.prefix = "akm_npc"
	self.ak47_crew.use_data.selection_index = 2
	self.ak47_crew.DAMAGE = 3
	self.ak47_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.ak47_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ak47_crew.CLIP_AMMO_MAX = 30
	self.ak47_crew.NR_CLIPS_MAX = 5
	self.ak47_crew.auto.fire_rate = 0.107
	self.ak47_crew.hold = "rifle"
	self.ak47_crew.alert_size = 5000
	self.ak47_crew.suppression = 1
end

-- Lines: 1408 to 1426
function WeaponTweakData:_init_data_m14_crew()
	self.m14_crew.sounds.prefix = "m14_npc"
	self.m14_crew.use_data.selection_index = 2
	self.m14_crew.DAMAGE = 1.28
	self.m14_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.m14_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m14_crew.CLIP_AMMO_MAX = 10
	self.m14_crew.NR_CLIPS_MAX = 8
	self.m14_crew.pull_magazine_during_reload = "rifle"
	self.m14_crew.auto.fire_rate = 0.085
	self.m14_crew.hold = "rifle"
	self.m14_crew.alert_size = 5000
	self.m14_crew.suppression = 1
end

-- Lines: 1431 to 1450
function WeaponTweakData:_init_data_r870_crew()
	self.r870_crew.sounds.prefix = "remington_npc"
	self.r870_crew.use_data.selection_index = 2
	self.r870_crew.DAMAGE = 8.7
	self.r870_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.r870_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.r870_crew.CLIP_AMMO_MAX = 6
	self.r870_crew.NR_CLIPS_MAX = 4
	self.r870_crew.hold = "rifle"
	self.r870_crew.alert_size = 4500
	self.r870_crew.suppression = 1.8
	self.r870_crew.is_shotgun = true
	self.benelli_crew = deep_clone(self.r870_crew)
end

-- Lines: 1455 to 1472
function WeaponTweakData:_init_data_mossberg_crew()
	self.mossberg_crew.sounds.prefix = "mossberg_npc"
	self.mossberg_crew.use_data.selection_index = 2
	self.mossberg_crew.DAMAGE = 6
	self.mossberg_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.mossberg_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.mossberg_crew.CLIP_AMMO_MAX = 6
	self.mossberg_crew.NR_CLIPS_MAX = 4
	self.mossberg_crew.hold = "rifle"
	self.mossberg_crew.alert_size = 3000
	self.mossberg_crew.suppression = 2
	self.mossberg_crew.is_shotgun = true
end

-- Lines: 1477 to 1497
function WeaponTweakData:_init_data_mp5_crew()
	self.mp5_crew.sounds.prefix = "mp5_npc"
	self.mp5_crew.use_data.selection_index = 1
	self.mp5_crew.DAMAGE = 1
	self.mp5_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mp5_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mp5_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mp5_crew.CLIP_AMMO_MAX = 30
	self.mp5_crew.NR_CLIPS_MAX = 5
	self.mp5_crew.pull_magazine_during_reload = "smg"
	self.mp5_crew.auto.fire_rate = 0.08
	self.mp5_crew.hold = "rifle"
	self.mp5_crew.alert_size = 2500
	self.mp5_crew.suppression = 1
end

-- Lines: 1501 to 1524
function WeaponTweakData:_init_data_g36_crew()
	self.g36_crew.sounds.prefix = "g36_npc"
	self.g36_crew.use_data.selection_index = 2
	self.g36_crew.DAMAGE = 1.28
	self.g36_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.g36_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.g36_crew.CLIP_AMMO_MAX = 30
	self.g36_crew.NR_CLIPS_MAX = 5
	self.g36_crew.pull_magazine_during_reload = "rifle"
	self.g36_crew.auto.fire_rate = 0.085
	self.g36_crew.hold = "rifle"
	self.g36_crew.alert_size = 5000
	self.g36_crew.suppression = 1
end

-- Lines: 1528 to 1545
function WeaponTweakData:_init_data_g17_crew()
	self.g17_crew.sounds.prefix = "g17_npc"
	self.g17_crew.use_data.selection_index = 1
	self.g17_crew.DAMAGE = 1
	self.g17_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.g17_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.g17_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.g17_crew.CLIP_AMMO_MAX = 17
	self.g17_crew.NR_CLIPS_MAX = 5
	self.g17_crew.pull_magazine_during_reload = "pistol"
	self.g17_crew.hold = "pistol"
	self.g17_crew.alert_size = 2500
	self.g17_crew.suppression = 1
end

-- Lines: 1547 to 1566
function WeaponTweakData:_init_data_mp9_crew()
	self.mp9_crew.sounds.prefix = "mp9_npc"
	self.mp9_crew.use_data.selection_index = 1
	self.mp9_crew.DAMAGE = 1
	self.mp9_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mp9_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mp9_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mp9_crew.CLIP_AMMO_MAX = 30
	self.mp9_crew.NR_CLIPS_MAX = 5
	self.mp9_crew.pull_magazine_during_reload = "smg"
	self.mp9_crew.auto.fire_rate = 0.063
	self.mp9_crew.hold = {
		"uzi",
		"bullpup",
		"rifle"
	}
	self.mp9_crew.alert_size = 1000
	self.mp9_crew.suppression = 1
end

-- Lines: 1568 to 1590
function WeaponTweakData:_init_data_olympic_crew()
	self.olympic_crew.sounds.prefix = "m4_olympic_npc"
	self.olympic_crew.use_data.selection_index = 1
	self.olympic_crew.DAMAGE = 1.5
	self.olympic_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.olympic_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.olympic_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.olympic_crew.CLIP_AMMO_MAX = 25
	self.olympic_crew.NR_CLIPS_MAX = 5
	self.olympic_crew.pull_magazine_during_reload = "rifle"
	self.olympic_crew.auto.fire_rate = 0.088
	self.olympic_crew.hold = "rifle"
	self.olympic_crew.alert_size = 1000
	self.olympic_crew.suppression = 1
	self.olympic_primary_crew = deep_clone(self.olympic_crew)
	self.olympic_primary_crew.use_data.selection_index = 2
end

-- Lines: 1592 to 1610
function WeaponTweakData:_init_data_m16_crew()
	self.m16_crew.sounds.prefix = "m16_npc"
	self.m16_crew.use_data.selection_index = 2
	self.m16_crew.DAMAGE = 1.05
	self.m16_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.m16_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m16_crew.CLIP_AMMO_MAX = 30
	self.m16_crew.NR_CLIPS_MAX = 8
	self.m16_crew.pull_magazine_during_reload = "rifle"
	self.m16_crew.auto.fire_rate = 0.07
	self.m16_crew.hold = "rifle"
	self.m16_crew.alert_size = 5000
	self.m16_crew.suppression = 1
end

-- Lines: 1612 to 1633
function WeaponTweakData:_init_data_aug_crew()
	self.aug_crew.sounds.prefix = "aug_npc"
	self.aug_crew.use_data.selection_index = 2
	self.aug_crew.DAMAGE = 1.2
	self.aug_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.aug_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.aug_crew.CLIP_AMMO_MAX = 30
	self.aug_crew.NR_CLIPS_MAX = 5
	self.aug_crew.pull_magazine_during_reload = "rifle"
	self.aug_crew.auto.fire_rate = 0.08
	self.aug_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.aug_crew.alert_size = 5000
	self.aug_crew.suppression = 1
	self.aug_secondary_crew = deep_clone(self.aug_crew)
	self.aug_secondary_crew.use_data.selection_index = 1
end

-- Lines: 1636 to 1657
function WeaponTweakData:_init_data_ak74_crew()
	self.ak74_crew.sounds.prefix = "ak74_npc"
	self.ak74_crew.use_data.selection_index = 2
	self.ak74_crew.DAMAGE = 1.38
	self.ak74_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.ak74_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ak74_crew.CLIP_AMMO_MAX = 30
	self.ak74_crew.NR_CLIPS_MAX = 5
	self.ak74_crew.pull_magazine_during_reload = "rifle"
	self.ak74_crew.auto.fire_rate = 0.092
	self.ak74_crew.hold = "rifle"
	self.ak74_crew.alert_size = 5000
	self.ak74_crew.suppression = 1
	self.ak74_secondary_crew = deep_clone(self.ak74_crew)
	self.ak74_secondary_crew.use_data.selection_index = 1
end

-- Lines: 1659 to 1677
function WeaponTweakData:_init_data_ak5_crew()
	self.ak5_crew.sounds.prefix = "ak5_npc"
	self.ak5_crew.use_data.selection_index = 2
	self.ak5_crew.DAMAGE = 1.28
	self.ak5_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.ak5_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ak5_crew.CLIP_AMMO_MAX = 30
	self.ak5_crew.NR_CLIPS_MAX = 5
	self.ak5_crew.pull_magazine_during_reload = "rifle"
	self.ak5_crew.auto.fire_rate = 0.085
	self.ak5_crew.hold = "rifle"
	self.ak5_crew.alert_size = 5000
	self.ak5_crew.suppression = 1
end

-- Lines: 1680 to 1700
function WeaponTweakData:_init_data_p90_crew()
	self.p90_crew.sounds.prefix = "p90_npc"
	self.p90_crew.use_data.selection_index = 1
	self.p90_crew.DAMAGE = 1
	self.p90_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.p90_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.p90_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.p90_crew.CLIP_AMMO_MAX = 50
	self.p90_crew.NR_CLIPS_MAX = 4
	self.p90_crew.reload = "looped"
	self.p90_crew.looped_reload_speed = 0.14285714285714285
	self.p90_crew.auto.fire_rate = 0.066
	self.p90_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.p90_crew.alert_size = 1000
	self.p90_crew.suppression = 1
end

-- Lines: 1703 to 1721
function WeaponTweakData:_init_data_amcar_crew()
	self.amcar_crew.sounds.prefix = "amcar_npc"
	self.amcar_crew.use_data.selection_index = 2
	self.amcar_crew.DAMAGE = 1.65
	self.amcar_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.amcar_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.amcar_crew.CLIP_AMMO_MAX = 20
	self.amcar_crew.NR_CLIPS_MAX = 5
	self.amcar_crew.pull_magazine_during_reload = "rifle"
	self.amcar_crew.auto.fire_rate = 0.11
	self.amcar_crew.hold = "rifle"
	self.amcar_crew.alert_size = 5000
	self.amcar_crew.suppression = 1
end

-- Lines: 1723 to 1742
function WeaponTweakData:_init_data_mac10_crew()
	self.mac10_crew.sounds.prefix = "mac10_npc"
	self.mac10_crew.use_data.selection_index = 1
	self.mac10_crew.DAMAGE = 0.75
	self.mac10_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mac10_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mac10_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mac10_crew.CLIP_AMMO_MAX = 32
	self.mac10_crew.NR_CLIPS_MAX = 5
	self.mac10_crew.pull_magazine_during_reload = "smg"
	self.mac10_crew.auto.fire_rate = 0.06
	self.mac10_crew.hold = "pistol"
	self.mac10_crew.alert_size = 1000
	self.mac10_crew.suppression = 1
end

-- Lines: 1744 to 1766
function WeaponTweakData:_init_data_akmsu_crew()
	self.akmsu_crew.sounds.prefix = "akmsu_npc"
	self.akmsu_crew.use_data.selection_index = 1
	self.akmsu_crew.DAMAGE = 3
	self.akmsu_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.akmsu_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.akmsu_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.akmsu_crew.CLIP_AMMO_MAX = 30
	self.akmsu_crew.NR_CLIPS_MAX = 5
	self.akmsu_crew.pull_magazine_during_reload = "rifle"
	self.akmsu_crew.auto.fire_rate = 0.073
	self.akmsu_crew.hold = "rifle"
	self.akmsu_crew.alert_size = 1000
	self.akmsu_crew.suppression = 1
	self.akmsu_primary_crew = deep_clone(self.akmsu_crew)
	self.akmsu_primary_crew.use_data.selection_index = 2
end

-- Lines: 1768 to 1786
function WeaponTweakData:_init_data_akm_crew()
	self.akm_crew.sounds.prefix = "akm_npc"
	self.akm_crew.use_data.selection_index = 2
	self.akm_crew.DAMAGE = 1.61
	self.akm_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.akm_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.akm_crew.CLIP_AMMO_MAX = 30
	self.akm_crew.NR_CLIPS_MAX = 5
	self.akm_crew.pull_magazine_during_reload = "rifle"
	self.akm_crew.auto.fire_rate = 0.107
	self.akm_crew.hold = "rifle"
	self.akm_crew.alert_size = 5000
	self.akm_crew.suppression = 1
end

-- Lines: 1788 to 1806
function WeaponTweakData:_init_data_akm_gold_crew()
	self.akm_gold_crew.sounds.prefix = "akm_npc"
	self.akm_gold_crew.use_data.selection_index = 2
	self.akm_gold_crew.DAMAGE = 1.61
	self.akm_gold_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.akm_gold_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.akm_gold_crew.CLIP_AMMO_MAX = 30
	self.akm_gold_crew.NR_CLIPS_MAX = 5
	self.akm_gold_crew.pull_magazine_during_reload = "rifle"
	self.akm_gold_crew.auto.fire_rate = 0.107
	self.akm_gold_crew.hold = "rifle"
	self.akm_gold_crew.alert_size = 5000
	self.akm_gold_crew.suppression = 1
end

-- Lines: 1808 to 1828
function WeaponTweakData:_init_data_deagle_crew()
	self.deagle_crew.sounds.prefix = "deagle_npc"
	self.deagle_crew.use_data.selection_index = 1
	self.deagle_crew.DAMAGE = 4
	self.deagle_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.deagle_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.deagle_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.deagle_crew.CLIP_AMMO_MAX = 10
	self.deagle_crew.NR_CLIPS_MAX = 5
	self.deagle_crew.pull_magazine_during_reload = "pistol"
	self.deagle_crew.hold = "pistol"
	self.deagle_crew.alert_size = 2500
	self.deagle_crew.suppression = 1
	self.deagle_primary_crew = deep_clone(self.deagle_crew)
	self.deagle_primary_crew.use_data.selection_index = 2
end

-- Lines: 1830 to 1847
function WeaponTweakData:_init_data_serbu_crew()
	self.serbu_crew.sounds.prefix = "serbu_npc"
	self.serbu_crew.use_data.selection_index = 1
	self.serbu_crew.DAMAGE = 5
	self.serbu_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.serbu_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.serbu_crew.CLIP_AMMO_MAX = 6
	self.serbu_crew.NR_CLIPS_MAX = 4
	self.serbu_crew.hold = "rifle"
	self.serbu_crew.alert_size = 4500
	self.serbu_crew.suppression = 1.8
	self.serbu_crew.is_shotgun = true
end

-- Lines: 1849 to 1869
function WeaponTweakData:_init_data_saiga_crew()
	self.saiga_crew.sounds.prefix = "saiga_npc"
	self.saiga_crew.use_data.selection_index = 2
	self.saiga_crew.DAMAGE = 2.7
	self.saiga_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.saiga_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.saiga_crew.auto.fire_rate = 0.18
	self.saiga_crew.CLIP_AMMO_MAX = 7
	self.saiga_crew.NR_CLIPS_MAX = 10
	self.saiga_crew.pull_magazine_during_reload = "rifle"
	self.saiga_crew.hold = "rifle"
	self.saiga_crew.alert_size = 4500
	self.saiga_crew.suppression = 1.8
	self.saiga_crew.is_shotgun = true
end

-- Lines: 1871 to 1889
function WeaponTweakData:_init_data_huntsman_crew()
	self.huntsman_crew.sounds.prefix = "huntsman_npc"
	self.huntsman_crew.use_data.selection_index = 2
	self.huntsman_crew.DAMAGE = 17.4
	self.huntsman_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.huntsman_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.huntsman_crew.CLIP_AMMO_MAX = 2
	self.huntsman_crew.NR_CLIPS_MAX = 4
	self.huntsman_crew.looped_reload_speed = 0.2
	self.huntsman_crew.hold = "rifle"
	self.huntsman_crew.alert_size = 4500
	self.huntsman_crew.suppression = 1.8
	self.huntsman_crew.is_shotgun = true
end

-- Lines: 1891 to 1911
function WeaponTweakData:_init_data_saw_crew()
	self.saw_crew.sounds.prefix = "saw_npc"
	self.saw_crew.sounds.fire = "Play_npc_saw_handheld_start"
	self.saw_crew.sounds.stop_fire = "Play_npc_saw_handheld_end"
	self.saw_crew.use_data.selection_index = 2
	self.saw_crew.DAMAGE = 1
	self.saw_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.saw_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.saw_crew.CLIP_AMMO_MAX = 2
	self.saw_crew.NR_CLIPS_MAX = 4
	self.saw_crew.hold = "bullpup"
	self.saw_crew.alert_size = 4500
	self.saw_crew.suppression = 1.8
	self.saw_secondary_crew = deep_clone(self.saw_crew)
	self.saw_secondary_crew.use_data.selection_index = 1
end

-- Lines: 1913 to 1934
function WeaponTweakData:_init_data_usp_crew()
	self.usp_crew.sounds.prefix = "usp45_npc"
	self.usp_crew.use_data.selection_index = 1
	self.usp_crew.DAMAGE = 1.25
	self.usp_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.usp_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.usp_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.usp_crew.CLIP_AMMO_MAX = 13
	self.usp_crew.NR_CLIPS_MAX = 6
	self.usp_crew.pull_magazine_during_reload = "pistol"
	self.usp_crew.auto.fire_rate = 0.1
	self.usp_crew.hold = "pistol"
	self.usp_crew.alert_size = 1800
	self.usp_crew.suppression = 2
end

-- Lines: 1936 to 1957
function WeaponTweakData:_init_data_g22c_crew()
	self.g22c_crew.sounds.prefix = "g22_npc"
	self.g22c_crew.use_data.selection_index = 1
	self.g22c_crew.DAMAGE = 1.25
	self.g22c_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.g22c_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.g22c_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.g22c_crew.CLIP_AMMO_MAX = 16
	self.g22c_crew.NR_CLIPS_MAX = 6
	self.g22c_crew.pull_magazine_during_reload = "pistol"
	self.g22c_crew.auto.fire_rate = 0.1
	self.g22c_crew.hold = "pistol"
	self.g22c_crew.alert_size = 1800
	self.g22c_crew.suppression = 2
end

-- Lines: 1960 to 1977
function WeaponTweakData:_init_data_judge_crew()
	self.judge_crew.sounds.prefix = "judge_npc"
	self.judge_crew.use_data.selection_index = 1
	self.judge_crew.DAMAGE = 4
	self.judge_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.judge_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.judge_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.judge_crew.CLIP_AMMO_MAX = 5
	self.judge_crew.NR_CLIPS_MAX = 5
	self.judge_crew.hold = "pistol"
	self.judge_crew.reload = "revolver"
	self.judge_crew.alert_size = 5000
	self.judge_crew.suppression = 1.8
end

-- Lines: 1981 to 2001
function WeaponTweakData:_init_data_m45_crew()
	self.m45_crew.sounds.prefix = "m45_npc"
	self.m45_crew.use_data.selection_index = 1
	self.m45_crew.DAMAGE = 2
	self.m45_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.m45_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.m45_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.m45_crew.CLIP_AMMO_MAX = 40
	self.m45_crew.NR_CLIPS_MAX = 5
	self.m45_crew.auto.fire_rate = 0.1
	self.m45_crew.hold = "rifle"
	self.m45_crew.alert_size = 2800
	self.m45_crew.suppression = 1
end

-- Lines: 2004 to 2025
function WeaponTweakData:_init_data_s552_crew()
	self.s552_crew.sounds.prefix = "sig552_npc"
	self.s552_crew.use_data.selection_index = 2
	self.s552_crew.DAMAGE = 1.26
	self.s552_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.s552_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.s552_crew.CLIP_AMMO_MAX = 30
	self.s552_crew.NR_CLIPS_MAX = 5
	self.s552_crew.pull_magazine_during_reload = "rifle"
	self.s552_crew.auto.fire_rate = 0.084
	self.s552_crew.hold = "rifle"
	self.s552_crew.alert_size = 5000
	self.s552_crew.suppression = 1
	self.s552_secondary_crew = deep_clone(self.s552_crew)
	self.s552_secondary_crew.use_data.selection_index = 1
end

-- Lines: 2028 to 2046
function WeaponTweakData:_init_data_ppk_crew()
	self.ppk_crew.sounds.prefix = "w_ppk_npc"
	self.ppk_crew.use_data.selection_index = 1
	self.ppk_crew.DAMAGE = 1
	self.ppk_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.ppk_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.ppk_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.ppk_crew.CLIP_AMMO_MAX = 14
	self.ppk_crew.NR_CLIPS_MAX = 5
	self.ppk_crew.pull_magazine_during_reload = "pistol"
	self.ppk_crew.hold = "pistol"
	self.ppk_crew.alert_size = 2500
	self.ppk_crew.suppression = 1
end

-- Lines: 2051 to 2071
function WeaponTweakData:_init_data_mp7_crew()
	self.mp7_crew.sounds.prefix = "mp7_npc"
	self.mp7_crew.use_data.selection_index = 1
	self.mp7_crew.DAMAGE = 2
	self.mp7_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mp7_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mp7_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mp7_crew.CLIP_AMMO_MAX = 20
	self.mp7_crew.NR_CLIPS_MAX = 5
	self.mp7_crew.pull_magazine_during_reload = "smg"
	self.mp7_crew.auto.fire_rate = 0.063
	self.mp7_crew.hold = {
		"uzi",
		"bullpup",
		"rifle"
	}
	self.mp7_crew.alert_size = 2800
	self.mp7_crew.suppression = 1
end

-- Lines: 2074 to 2093
function WeaponTweakData:_init_data_scar_crew()
	self.scar_crew.sounds.prefix = "scar_npc"
	self.scar_crew.use_data.selection_index = 2
	self.scar_crew.DAMAGE = 1.47
	self.scar_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.scar_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.scar_crew.CLIP_AMMO_MAX = 20
	self.scar_crew.NR_CLIPS_MAX = 5
	self.scar_crew.pull_magazine_during_reload = "rifle"
	self.scar_crew.auto.fire_rate = 0.098
	self.scar_crew.hold = "rifle"
	self.scar_crew.alert_size = 5000
	self.scar_crew.suppression = 1
end

-- Lines: 2096 to 2114
function WeaponTweakData:_init_data_p226_crew()
	self.p226_crew.sounds.prefix = "p226r_npc"
	self.p226_crew.use_data.selection_index = 1
	self.p226_crew.DAMAGE = 1
	self.p226_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.p226_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.p226_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.p226_crew.CLIP_AMMO_MAX = 12
	self.p226_crew.NR_CLIPS_MAX = 5
	self.p226_crew.pull_magazine_during_reload = "pistol"
	self.p226_crew.hold = "pistol"
	self.p226_crew.alert_size = 2500
	self.p226_crew.suppression = 1
end

-- Lines: 2121 to 2139
function WeaponTweakData:_init_data_hk21_crew()
	self.hk21_crew.sounds.prefix = "hk23e_npc"
	self.hk21_crew.use_data.selection_index = 2
	self.hk21_crew.DAMAGE = 1.25
	self.hk21_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.hk21_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.hk21_crew.CLIP_AMMO_MAX = 150
	self.hk21_crew.NR_CLIPS_MAX = 5
	self.hk21_crew.auto.fire_rate = 0.083
	self.hk21_crew.hold = "rifle"
	self.hk21_crew.alert_size = 5000
	self.hk21_crew.suppression = 1
end

-- Lines: 2143 to 2161
function WeaponTweakData:_init_data_m249_crew()
	self.m249_crew.sounds.prefix = "m249_npc"
	self.m249_crew.use_data.selection_index = 2
	self.m249_crew.DAMAGE = 0.99
	self.m249_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.m249_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.m249_crew.CLIP_AMMO_MAX = 200
	self.m249_crew.NR_CLIPS_MAX = 2
	self.m249_crew.auto.fire_rate = 0.066
	self.m249_crew.hold = "rifle"
	self.m249_crew.alert_size = 5000
	self.m249_crew.suppression = 1
end

-- Lines: 2164 to 2182
function WeaponTweakData:_init_data_rpk_crew()
	self.rpk_crew.sounds.prefix = "rpk_npc"
	self.rpk_crew.use_data.selection_index = 2
	self.rpk_crew.DAMAGE = 1.2
	self.rpk_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.rpk_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.rpk_crew.CLIP_AMMO_MAX = 100
	self.rpk_crew.NR_CLIPS_MAX = 5
	self.rpk_crew.auto.fire_rate = 0.08
	self.rpk_crew.hold = "rifle"
	self.rpk_crew.alert_size = 5000
	self.rpk_crew.suppression = 1
end

-- Lines: 2191 to 2210
function WeaponTweakData:_init_data_m95_crew()
	self.m95_crew.sounds.prefix = "barrett_npc"
	self.m95_crew.use_data.selection_index = 2
	self.m95_crew.DAMAGE = 22.5
	self.m95_crew.muzzleflash = "effects/payday2/particles/weapons/50cal_auto"
	self.m95_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper_m95"
	self.m95_crew.CLIP_AMMO_MAX = 5
	self.m95_crew.NR_CLIPS_MAX = 5
	self.m95_crew.pull_magazine_during_reload = "rifle"
	self.m95_crew.hold = "rifle"
	self.m95_crew.reload = "bullpup"
	self.m95_crew.auto.fire_rate = 1.5
	self.m95_crew.alert_size = 5000
	self.m95_crew.suppression = 1
end

-- Lines: 2214 to 2232
function WeaponTweakData:_init_data_msr_crew()
	self.msr_crew.sounds.prefix = "msr_npc"
	self.msr_crew.use_data.selection_index = 2
	self.msr_crew.DAMAGE = 15
	self.msr_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.msr_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.msr_crew.CLIP_AMMO_MAX = 10
	self.msr_crew.NR_CLIPS_MAX = 5
	self.msr_crew.pull_magazine_during_reload = "rifle"
	self.msr_crew.auto.fire_rate = 1
	self.msr_crew.hold = "rifle"
	self.msr_crew.alert_size = 5000
	self.msr_crew.suppression = 1
end

-- Lines: 2235 to 2253
function WeaponTweakData:_init_data_r93_crew()
	self.r93_crew.sounds.prefix = "blazer_npc"
	self.r93_crew.use_data.selection_index = 2
	self.r93_crew.DAMAGE = 18
	self.r93_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.r93_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.r93_crew.CLIP_AMMO_MAX = 6
	self.r93_crew.NR_CLIPS_MAX = 5
	self.r93_crew.pull_magazine_during_reload = "rifle"
	self.r93_crew.auto.fire_rate = 1.2
	self.r93_crew.hold = "rifle"
	self.r93_crew.alert_size = 5000
	self.r93_crew.suppression = 1
end

-- Lines: 2264 to 2283
function WeaponTweakData:_init_data_fal_crew()
	self.fal_crew.sounds.prefix = "fn_fal_npc"
	self.fal_crew.use_data.selection_index = 2
	self.fal_crew.DAMAGE = 1.29
	self.fal_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.fal_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.fal_crew.CLIP_AMMO_MAX = 20
	self.fal_crew.NR_CLIPS_MAX = 5
	self.fal_crew.pull_magazine_during_reload = "rifle"
	self.fal_crew.auto.fire_rate = 0.08
	self.fal_crew.hold = "rifle"
	self.fal_crew.alert_size = 5000
	self.fal_crew.suppression = 1
end

-- Lines: 2289 to 2310
function WeaponTweakData:_init_data_ben_crew()
	self.ben_crew.sounds.prefix = "benelli_m4_npc"
	self.ben_crew.use_data.selection_index = 2
	self.ben_crew.DAMAGE = 2.1
	self.ben_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.ben_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.ben_crew.auto.fire_rate = 0.14
	self.ben_crew.CLIP_AMMO_MAX = 8
	self.ben_crew.NR_CLIPS_MAX = 4
	self.ben_crew.hold = "rifle"
	self.ben_crew.reload = "looped"
	self.ben_crew.looped_reload_speed = 0.8
	self.ben_crew.alert_size = 4500
	self.ben_crew.suppression = 1.8
	self.ben_crew.is_shotgun = true
end

-- Lines: 2312 to 2333
function WeaponTweakData:_init_data_striker_crew()
	self.striker_crew.sounds.prefix = "striker_npc"
	self.striker_crew.use_data.selection_index = 1
	self.striker_crew.DAMAGE = 5
	self.striker_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.striker_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.striker_crew.auto.fire_rate = 0.14
	self.striker_crew.CLIP_AMMO_MAX = 12
	self.striker_crew.NR_CLIPS_MAX = 4
	self.striker_crew.looped_reload_speed = 0.6666666666666666
	self.striker_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.striker_crew.alert_size = 4500
	self.striker_crew.suppression = 1.8
	self.striker_crew.is_shotgun = true
end

-- Lines: 2335 to 2354
function WeaponTweakData:_init_data_ksg_crew()
	self.ksg_crew.sounds.prefix = "keltec_npc"
	self.ksg_crew.use_data.selection_index = 2
	self.ksg_crew.DAMAGE = 8.7
	self.ksg_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.ksg_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.ksg_crew.auto.fire_rate = 0.575
	self.ksg_crew.CLIP_AMMO_MAX = 14
	self.ksg_crew.NR_CLIPS_MAX = 4
	self.ksg_crew.hold = "rifle"
	self.ksg_crew.alert_size = 4500
	self.ksg_crew.suppression = 1.8
	self.ksg_crew.is_shotgun = true
end

-- Lines: 2359 to 2380
function WeaponTweakData:_init_data_gre_m79_crew()
	self.gre_m79_crew.sounds.prefix = "gl40_npc"
	self.gre_m79_crew.use_data.selection_index = 2
	self.gre_m79_crew.DAMAGE = 2
	self.gre_m79_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.gre_m79_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.gre_m79_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.gre_m79_crew.no_trail = true
	self.gre_m79_crew.CLIP_AMMO_MAX = 1
	self.gre_m79_crew.NR_CLIPS_MAX = 4
	self.gre_m79_crew.looped_reload_speed = 0.16666666666666666
	self.gre_m79_crew.auto.fire_rate = 0.1
	self.gre_m79_crew.hold = "rifle"
	self.gre_m79_crew.alert_size = 2800
	self.gre_m79_crew.suppression = 1
end

-- Lines: 2384 to 2403
function WeaponTweakData:_init_data_g3_crew()
	self.g3_crew.sounds.prefix = "g3_npc"
	self.g3_crew.use_data.selection_index = 2
	self.g3_crew.DAMAGE = 1.43
	self.g3_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.g3_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.g3_crew.CLIP_AMMO_MAX = 20
	self.g3_crew.NR_CLIPS_MAX = 5
	self.g3_crew.pull_magazine_during_reload = "rifle"
	self.g3_crew.auto.fire_rate = 0.092
	self.g3_crew.hold = "rifle"
	self.g3_crew.alert_size = 5000
	self.g3_crew.suppression = 1
end

-- Lines: 2406 to 2425
function WeaponTweakData:_init_data_galil_crew()
	self.galil_crew.sounds.prefix = "galil_npc"
	self.galil_crew.use_data.selection_index = 2
	self.galil_crew.DAMAGE = 1.07
	self.galil_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.galil_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.galil_crew.CLIP_AMMO_MAX = 30
	self.galil_crew.NR_CLIPS_MAX = 5
	self.galil_crew.pull_magazine_during_reload = "rifle"
	self.galil_crew.auto.fire_rate = 0.071
	self.galil_crew.hold = "rifle"
	self.galil_crew.alert_size = 5000
	self.galil_crew.suppression = 1
end

-- Lines: 2428 to 2447
function WeaponTweakData:_init_data_famas_crew()
	self.famas_crew.sounds.prefix = "famas_npc"
	self.famas_crew.use_data.selection_index = 2
	self.famas_crew.DAMAGE = 0.9
	self.famas_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.famas_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.famas_crew.CLIP_AMMO_MAX = 30
	self.famas_crew.NR_CLIPS_MAX = 5
	self.famas_crew.pull_magazine_during_reload = "rifle"
	self.famas_crew.auto.fire_rate = 0.06
	self.famas_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.famas_crew.alert_size = 5000
	self.famas_crew.suppression = 1
end

-- Lines: 2451 to 2471
function WeaponTweakData:_init_data_scorpion_crew()
	self.scorpion_crew.sounds.prefix = "skorpion_npc"
	self.scorpion_crew.use_data.selection_index = 1
	self.scorpion_crew.DAMAGE = 2
	self.scorpion_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.scorpion_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.scorpion_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.scorpion_crew.CLIP_AMMO_MAX = 20
	self.scorpion_crew.NR_CLIPS_MAX = 5
	self.scorpion_crew.pull_magazine_during_reload = "smg"
	self.scorpion_crew.auto.fire_rate = 0.06
	self.scorpion_crew.hold = "pistol"
	self.scorpion_crew.alert_size = 2800
	self.scorpion_crew.suppression = 1
end

-- Lines: 2473 to 2493
function WeaponTweakData:_init_data_tec9_crew()
	self.tec9_crew.sounds.prefix = "tec9_npc"
	self.tec9_crew.use_data.selection_index = 1
	self.tec9_crew.DAMAGE = 2
	self.tec9_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.tec9_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.tec9_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.tec9_crew.CLIP_AMMO_MAX = 20
	self.tec9_crew.NR_CLIPS_MAX = 5
	self.tec9_crew.pull_magazine_during_reload = "smg"
	self.tec9_crew.auto.fire_rate = 0.067
	self.tec9_crew.hold = "pistol"
	self.tec9_crew.alert_size = 2800
	self.tec9_crew.suppression = 1
end

-- Lines: 2495 to 2515
function WeaponTweakData:_init_data_uzi_crew()
	self.uzi_crew.sounds.prefix = "uzi_npc"
	self.uzi_crew.use_data.selection_index = 1
	self.uzi_crew.DAMAGE = 2
	self.uzi_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.uzi_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.uzi_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.uzi_crew.CLIP_AMMO_MAX = 40
	self.uzi_crew.NR_CLIPS_MAX = 5
	self.uzi_crew.pull_magazine_during_reload = "smg"
	self.uzi_crew.auto.fire_rate = 0.086
	self.uzi_crew.hold = {
		"uzi",
		"bullpup",
		"rifle"
	}
	self.uzi_crew.alert_size = 2800
	self.uzi_crew.suppression = 1
end

-- Lines: 2517 to 2533
function WeaponTweakData:_init_data_jowi_crew()
	self.jowi_crew.sounds.prefix = "g17_npc"
	self.jowi_crew.use_data.selection_index = 2
	self.jowi_crew.DAMAGE = 1
	self.jowi_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.jowi_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.jowi_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.jowi_crew.CLIP_AMMO_MAX = 20
	self.jowi_crew.NR_CLIPS_MAX = 5
	self.jowi_crew.hold = "akimbo_pistol"
	self.jowi_crew.alert_size = 2500
	self.jowi_crew.suppression = 1
end

-- Lines: 2536 to 2552
function WeaponTweakData:_init_data_x_1911_crew()
	self.x_1911_crew.sounds.prefix = "c45_npc"
	self.x_1911_crew.use_data.selection_index = 2
	self.x_1911_crew.DAMAGE = 1
	self.x_1911_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_1911_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_1911_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_1911_crew.CLIP_AMMO_MAX = 20
	self.x_1911_crew.NR_CLIPS_MAX = 5
	self.x_1911_crew.hold = "akimbo_pistol"
	self.x_1911_crew.alert_size = 2500
	self.x_1911_crew.suppression = 1
end

-- Lines: 2555 to 2571
function WeaponTweakData:_init_data_x_b92fs_crew()
	self.x_b92fs_crew.sounds.prefix = "beretta_npc"
	self.x_b92fs_crew.use_data.selection_index = 2
	self.x_b92fs_crew.DAMAGE = 1
	self.x_b92fs_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_b92fs_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_b92fs_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_b92fs_crew.CLIP_AMMO_MAX = 28
	self.x_b92fs_crew.NR_CLIPS_MAX = 5
	self.x_b92fs_crew.hold = "akimbo_pistol"
	self.x_b92fs_crew.alert_size = 2500
	self.x_b92fs_crew.suppression = 1
end

-- Lines: 2574 to 2590
function WeaponTweakData:_init_data_x_deagle_crew()
	self.x_deagle_crew.sounds.prefix = "deagle_npc"
	self.x_deagle_crew.use_data.selection_index = 2
	self.x_deagle_crew.DAMAGE = 1
	self.x_deagle_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.x_deagle_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_deagle_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_deagle_crew.CLIP_AMMO_MAX = 20
	self.x_deagle_crew.NR_CLIPS_MAX = 5
	self.x_deagle_crew.hold = "akimbo_pistol"
	self.x_deagle_crew.alert_size = 2500
	self.x_deagle_crew.suppression = 1
end

-- Lines: 2592 to 2609
function WeaponTweakData:_init_data_g26_crew()
	self.g26_crew.sounds.prefix = "g17_npc"
	self.g26_crew.use_data.selection_index = 1
	self.g26_crew.DAMAGE = 1
	self.g26_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.g26_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.g26_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.g26_crew.CLIP_AMMO_MAX = 10
	self.g26_crew.NR_CLIPS_MAX = 5
	self.g26_crew.pull_magazine_during_reload = "pistol"
	self.g26_crew.hold = "pistol"
	self.g26_crew.alert_size = 2500
	self.g26_crew.suppression = 1
end

-- Lines: 2612 to 2631
function WeaponTweakData:_init_data_spas12_crew()
	self.spas12_crew.sounds.prefix = "spas_npc"
	self.spas12_crew.use_data.selection_index = 2
	self.spas12_crew.DAMAGE = 3
	self.spas12_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.spas12_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.spas12_crew.auto.fire_rate = 0.2
	self.spas12_crew.CLIP_AMMO_MAX = 6
	self.spas12_crew.NR_CLIPS_MAX = 4
	self.spas12_crew.hold = "rifle"
	self.spas12_crew.alert_size = 4500
	self.spas12_crew.suppression = 1.8
	self.spas12_crew.is_shotgun = true
end

-- Lines: 2633 to 2654
function WeaponTweakData:_init_data_mg42_crew()
	self.mg42_crew.sounds.prefix = "mg42_npc"
	self.mg42_crew.use_data.selection_index = 2
	self.mg42_crew.DAMAGE = 0.75
	self.mg42_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.mg42_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.mg42_crew.CLIP_AMMO_MAX = 150
	self.mg42_crew.NR_CLIPS_MAX = 3
	self.mg42_crew.auto.fire_rate = 0.05
	self.mg42_crew.hold = "rifle"
	self.mg42_crew.alert_size = 5000
	self.mg42_crew.suppression = 1
	self.mg42_secondary_crew = deep_clone(self.mg42_crew)
	self.mg42_secondary_crew.use_data.selection_index = 1
	self.mg42_secondary_crew.armor_piercing = true
end

-- Lines: 2656 to 2672
function WeaponTweakData:_init_data_c96_crew()
	self.c96_crew.sounds.prefix = "c96_npc"
	self.c96_crew.use_data.selection_index = 1
	self.c96_crew.DAMAGE = 1
	self.c96_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.c96_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.c96_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.c96_crew.CLIP_AMMO_MAX = 10
	self.c96_crew.NR_CLIPS_MAX = 5
	self.c96_crew.hold = "pistol"
	self.c96_crew.alert_size = 2500
	self.c96_crew.suppression = 1
end

-- Lines: 2674 to 2693
function WeaponTweakData:_init_data_sterling_crew()
	self.sterling_crew.sounds.prefix = "sterling_npc"
	self.sterling_crew.use_data.selection_index = 1
	self.sterling_crew.DAMAGE = 2
	self.sterling_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.sterling_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.sterling_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sterling_crew.CLIP_AMMO_MAX = 20
	self.sterling_crew.NR_CLIPS_MAX = 5
	self.sterling_crew.auto.fire_rate = 0.11
	self.sterling_crew.hold = "pistol"
	self.sterling_crew.alert_size = 2800
	self.sterling_crew.suppression = 1
end

-- Lines: 2695 to 2715
function WeaponTweakData:_init_data_mosin_crew()
	self.mosin_crew.sounds.prefix = "nagant_npc"
	self.mosin_crew.use_data.selection_index = 2
	self.mosin_crew.DAMAGE = 15
	self.mosin_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.mosin_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.mosin_crew.CLIP_AMMO_MAX = 5
	self.mosin_crew.NR_CLIPS_MAX = 8
	self.mosin_crew.auto.fire_rate = 1
	self.mosin_crew.hold = "rifle"
	self.mosin_crew.alert_size = 5000
	self.mosin_crew.suppression = 1
	self.mosin_secondary_crew = deep_clone(self.mosin_crew)
	self.mosin_secondary_crew.use_data.selection_index = 1
end

-- Lines: 2718 to 2737
function WeaponTweakData:_init_data_m1928_crew()
	self.m1928_crew.sounds.prefix = "m1928_npc"
	self.m1928_crew.use_data.selection_index = 2
	self.m1928_crew.DAMAGE = 2
	self.m1928_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.m1928_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.m1928_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.m1928_crew.CLIP_AMMO_MAX = 50
	self.m1928_crew.NR_CLIPS_MAX = 3
	self.m1928_crew.pull_magazine_during_reload = "large_metal"
	self.m1928_crew.auto.fire_rate = 0.083
	self.m1928_crew.hold = "rifle"
	self.m1928_crew.alert_size = 5000
	self.m1928_crew.suppression = 1
end

-- Lines: 2740 to 2760
function WeaponTweakData:_init_data_l85a2_crew()
	self.l85a2_crew.sounds.prefix = "l85_npc"
	self.l85a2_crew.use_data.selection_index = 2
	self.l85a2_crew.DAMAGE = 2
	self.l85a2_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.l85a2_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.l85a2_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.l85a2_crew.CLIP_AMMO_MAX = 30
	self.l85a2_crew.NR_CLIPS_MAX = 5
	self.l85a2_crew.pull_magazine_during_reload = "rifle"
	self.l85a2_crew.auto.fire_rate = 0.083
	self.l85a2_crew.hold = "rifle"
	self.l85a2_crew.reload = "bullpup"
	self.l85a2_crew.alert_size = 5000
	self.l85a2_crew.suppression = 1
end

-- Lines: 2763 to 2782
function WeaponTweakData:_init_data_vhs_crew()
	self.vhs_crew.sounds.prefix = "vhs_npc"
	self.vhs_crew.use_data.selection_index = 2
	self.vhs_crew.DAMAGE = 1.05
	self.vhs_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.vhs_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.vhs_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.vhs_crew.CLIP_AMMO_MAX = 30
	self.vhs_crew.NR_CLIPS_MAX = 5
	self.vhs_crew.pull_magazine_during_reload = "rifle"
	self.vhs_crew.auto.fire_rate = 0.07
	self.vhs_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.vhs_crew.alert_size = 5000
	self.vhs_crew.suppression = 1
end

-- Lines: 2784 to 2805
function WeaponTweakData:_init_data_m134_crew()
	self.m134_crew.sounds.prefix = "minigun_npc"
	self.m134_crew.use_data.selection_index = 2
	self.m134_crew.DAMAGE = 2
	self.m134_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.m134_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.m134_crew.CLIP_AMMO_MAX = 750
	self.m134_crew.NR_CLIPS_MAX = 1
	self.m134_crew.auto.fire_rate = 0.05
	self.m134_crew.hold = "rifle"
	self.m134_crew.alert_size = 5000
	self.m134_crew.suppression = 1
	self.m134_crew.has_fire_animation = true
	self.m134_crew.animations = {thq_align_anim = "thq"}
end

-- Lines: 2807 to 2827
function WeaponTweakData:_init_data_rpg7_crew()
	self.rpg7_crew.sounds.prefix = "rpg_npc"
	self.rpg7_crew.use_data.selection_index = 2
	self.rpg7_crew.DAMAGE = 2
	self.rpg7_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.rpg7_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.rpg7_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.rpg7_crew.no_trail = true
	self.rpg7_crew.CLIP_AMMO_MAX = 1
	self.rpg7_crew.NR_CLIPS_MAX = 4
	self.rpg7_crew.auto.fire_rate = 0.1
	self.rpg7_crew.hold = "rifle"
	self.rpg7_crew.alert_size = 2800
	self.rpg7_crew.suppression = 1
end

-- Lines: 2830 to 2847
function WeaponTweakData:_init_data_hs2000_crew()
	self.hs2000_crew.sounds.prefix = "p226r_npc"
	self.hs2000_crew.use_data.selection_index = 1
	self.hs2000_crew.DAMAGE = 1
	self.hs2000_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.hs2000_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.hs2000_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.hs2000_crew.CLIP_AMMO_MAX = 19
	self.hs2000_crew.NR_CLIPS_MAX = 5
	self.hs2000_crew.pull_magazine_during_reload = "pistol"
	self.hs2000_crew.hold = "pistol"
	self.hs2000_crew.alert_size = 2500
	self.hs2000_crew.suppression = 1
end

-- Lines: 2850 to 2869
function WeaponTweakData:_init_data_cobray_crew()
	self.cobray_crew.sounds.prefix = "cobray_npc"
	self.cobray_crew.use_data.selection_index = 1
	self.cobray_crew.DAMAGE = 2
	self.cobray_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.cobray_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.cobray_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.cobray_crew.CLIP_AMMO_MAX = 32
	self.cobray_crew.NR_CLIPS_MAX = 5
	self.cobray_crew.pull_magazine_during_reload = "smg"
	self.cobray_crew.auto.fire_rate = 0.05
	self.cobray_crew.hold = {
		"uzi",
		"bullpup",
		"rifle"
	}
	self.cobray_crew.alert_size = 5000
	self.cobray_crew.suppression = 1
end

-- Lines: 2871 to 2889
function WeaponTweakData:_init_data_b682_crew()
	self.b682_crew.sounds.prefix = "b682_npc"
	self.b682_crew.use_data.selection_index = 2
	self.b682_crew.DAMAGE = 17.4
	self.b682_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.b682_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.b682_crew.CLIP_AMMO_MAX = 2
	self.b682_crew.NR_CLIPS_MAX = 4
	self.b682_crew.looped_reload_speed = 0.2
	self.b682_crew.hold = "rifle"
	self.b682_crew.alert_size = 4500
	self.b682_crew.suppression = 1.8
	self.b682_crew.is_shotgun = true
end

-- Lines: 2890 to 2906
function WeaponTweakData:_init_data_x_g22c_crew()
	self.x_g22c_crew.sounds.prefix = "g22_npc"
	self.x_g22c_crew.use_data.selection_index = 2
	self.x_g22c_crew.DAMAGE = 1.25
	self.x_g22c_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_g22c_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_g22c_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_g22c_crew.CLIP_AMMO_MAX = 32
	self.x_g22c_crew.NR_CLIPS_MAX = 5
	self.x_g22c_crew.hold = "akimbo_pistol"
	self.x_g22c_crew.alert_size = 1800
	self.x_g22c_crew.suppression = 2
end

-- Lines: 2907 to 2923
function WeaponTweakData:_init_data_x_g17_crew()
	self.x_g17_crew.sounds.prefix = "g22_npc"
	self.x_g17_crew.use_data.selection_index = 2
	self.x_g17_crew.DAMAGE = 1.25
	self.x_g17_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_g17_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_g17_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_g17_crew.CLIP_AMMO_MAX = 34
	self.x_g17_crew.NR_CLIPS_MAX = 5
	self.x_g17_crew.hold = "akimbo_pistol"
	self.x_g17_crew.alert_size = 1800
	self.x_g17_crew.suppression = 2
end

-- Lines: 2924 to 2940
function WeaponTweakData:_init_data_x_usp_crew()
	self.x_usp_crew.sounds.prefix = "g22_npc"
	self.x_usp_crew.use_data.selection_index = 2
	self.x_usp_crew.DAMAGE = 1.25
	self.x_usp_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_usp_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_usp_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_usp_crew.CLIP_AMMO_MAX = 26
	self.x_usp_crew.NR_CLIPS_MAX = 5
	self.x_usp_crew.hold = "akimbo_pistol"
	self.x_usp_crew.alert_size = 1800
	self.x_usp_crew.suppression = 2
end

-- Lines: 2943 to 2965
function WeaponTweakData:_init_data_flamethrower_mk2_crew()
	self.flamethrower_mk2_crew.sounds.prefix = "flamethrower_npc"
	self.flamethrower_mk2_crew.sounds.fire = "flamethrower_npc_fire"
	self.flamethrower_mk2_crew.sounds.stop_fire = "flamethrower_npc_fire_stop"
	self.flamethrower_mk2_crew.use_data.selection_index = 2
	self.flamethrower_mk2_crew.DAMAGE = 1
	self.flamethrower_mk2_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.flamethrower_mk2_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.flamethrower_mk2_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.flamethrower_mk2_crew.CLIP_AMMO_MAX = 300
	self.flamethrower_mk2_crew.NR_CLIPS_MAX = 4
	self.flamethrower_mk2_crew.pull_magazine_during_reload = "large_metal"
	self.flamethrower_mk2_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.flamethrower_mk2_crew.auto.fire_rate = 0.05
	self.flamethrower_mk2_crew.hud_icon = "rifle"
	self.flamethrower_mk2_crew.alert_size = 2500
	self.flamethrower_mk2_crew.suppression = 0.45
end

-- Lines: 2967 to 2988
function WeaponTweakData:_init_data_m32_crew()
	self.m32_crew.sounds.prefix = "mgl_npc"
	self.m32_crew.use_data.selection_index = 2
	self.m32_crew.DAMAGE = 2
	self.m32_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.m32_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.m32_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.m32_crew.no_trail = true
	self.m32_crew.CLIP_AMMO_MAX = 6
	self.m32_crew.NR_CLIPS_MAX = 4
	self.m32_crew.looped_reload_speed = 0.2
	self.m32_crew.auto.fire_rate = 0.1
	self.m32_crew.hold = "rifle"
	self.m32_crew.alert_size = 2800
	self.m32_crew.suppression = 1
end

-- Lines: 2990 to 3010
function WeaponTweakData:_init_data_aa12_crew()
	self.aa12_crew.sounds.prefix = "aa12_npc"
	self.aa12_crew.use_data.selection_index = 2
	self.aa12_crew.DAMAGE = 3
	self.aa12_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.aa12_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.aa12_crew.auto.fire_rate = 0.2
	self.aa12_crew.CLIP_AMMO_MAX = 8
	self.aa12_crew.NR_CLIPS_MAX = 4
	self.aa12_crew.pull_magazine_during_reload = "large_plastic"
	self.aa12_crew.hold = "rifle"
	self.aa12_crew.alert_size = 4500
	self.aa12_crew.suppression = 1.8
	self.aa12_crew.is_shotgun = true
end

-- Lines: 3013 to 3031
function WeaponTweakData:_init_data_peacemaker_crew()
	self.peacemaker_crew.sounds.prefix = "pmkr45_npc"
	self.peacemaker_crew.use_data.selection_index = 1
	self.peacemaker_crew.DAMAGE = 4
	self.peacemaker_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.peacemaker_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.peacemaker_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.peacemaker_crew.CLIP_AMMO_MAX = 6
	self.peacemaker_crew.NR_CLIPS_MAX = 8
	self.peacemaker_crew.reload = "looped"
	self.peacemaker_crew.looped_reload_speed = 0.5
	self.peacemaker_crew.hold = "pistol"
	self.peacemaker_crew.alert_size = 5000
	self.peacemaker_crew.suppression = 1.8
end

-- Lines: 3033 to 3054
function WeaponTweakData:_init_data_winchester1874_crew()
	self.winchester1874_crew.sounds.prefix = "m1873_npc"
	self.winchester1874_crew.use_data.selection_index = 2
	self.winchester1874_crew.DAMAGE = 10.5
	self.winchester1874_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.winchester1874_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.winchester1874_crew.CLIP_AMMO_MAX = 15
	self.winchester1874_crew.NR_CLIPS_MAX = 8
	self.winchester1874_crew.looped_reload_speed = 0.7407407407407407
	self.winchester1874_crew.auto.fire_rate = 0.7
	self.winchester1874_crew.hold = "rifle"
	self.winchester1874_crew.alert_size = 5000
	self.winchester1874_crew.suppression = 1
	self.winchester1874_secondary_crew = deep_clone(self.winchester1874_crew)
	self.winchester1874_secondary_crew.use_data.selection_index = 1
end

-- Lines: 3056 to 3079
function WeaponTweakData:_init_data_plainsrider_crew()
	self.plainsrider_crew.sounds.prefix = "bow_npc"
	self.plainsrider_crew.use_data.selection_index = 2
	self.plainsrider_crew.use_data.align_place = "left_hand"
	self.plainsrider_crew.DAMAGE = 2
	self.plainsrider_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.plainsrider_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.plainsrider_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.plainsrider_crew.no_trail = true
	self.plainsrider_crew.CLIP_AMMO_MAX = 1
	self.plainsrider_crew.NR_CLIPS_MAX = 4
	self.plainsrider_crew.auto.fire_rate = 0.1
	self.plainsrider_crew.hold = "bow"
	self.plainsrider_crew.has_fire_animation = true
	self.plainsrider_crew.alert_size = 2800
	self.plainsrider_crew.suppression = 1
end

-- Lines: 3082 to 3099
function WeaponTweakData:_init_data_mateba_crew()
	self.mateba_crew.sounds.prefix = "mateba_npc"
	self.mateba_crew.use_data.selection_index = 1
	self.mateba_crew.DAMAGE = 4
	self.mateba_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.mateba_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.mateba_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.mateba_crew.CLIP_AMMO_MAX = 6
	self.mateba_crew.NR_CLIPS_MAX = 8
	self.mateba_crew.hold = "pistol"
	self.mateba_crew.reload = "revolver"
	self.mateba_crew.alert_size = 5000
	self.mateba_crew.suppression = 1.8
end

-- Lines: 3101 to 3119
function WeaponTweakData:_init_data_asval_crew()
	self.asval_crew.sounds.prefix = "val_npc"
	self.asval_crew.use_data.selection_index = 2
	self.asval_crew.DAMAGE = 1.01
	self.asval_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.asval_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.asval_crew.CLIP_AMMO_MAX = 20
	self.asval_crew.NR_CLIPS_MAX = 5
	self.asval_crew.pull_magazine_during_reload = "rifle"
	self.asval_crew.auto.fire_rate = 0.067
	self.asval_crew.hold = "rifle"
	self.asval_crew.alert_size = 5000
	self.asval_crew.suppression = 1
end

-- Lines: 3121 to 3140
function WeaponTweakData:_init_data_sub2000_crew()
	self.sub2000_crew.sounds.prefix = "sub2k_npc"
	self.sub2000_crew.use_data.selection_index = 2
	self.sub2000_crew.DAMAGE = 1.28
	self.sub2000_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.sub2000_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.sub2000_crew.CLIP_AMMO_MAX = 33
	self.sub2000_crew.NR_CLIPS_MAX = 8
	self.sub2000_crew.pull_magazine_during_reload = "smg"
	self.sub2000_crew.auto.fire_rate = 0.085
	self.sub2000_crew.hold = "rifle"
	self.sub2000_crew.reload = "uzi"
	self.sub2000_crew.alert_size = 5000
	self.sub2000_crew.suppression = 1
end

-- Lines: 3144 to 3163
function WeaponTweakData:_init_data_wa2000_crew()
	self.wa2000_crew.sounds.prefix = "lakner_npc"
	self.wa2000_crew.use_data.selection_index = 2
	self.wa2000_crew.DAMAGE = 7.5
	self.wa2000_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.wa2000_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.wa2000_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.wa2000_crew.CLIP_AMMO_MAX = 10
	self.wa2000_crew.NR_CLIPS_MAX = 5
	self.wa2000_crew.pull_magazine_during_reload = "rifle"
	self.wa2000_crew.auto.fire_rate = 0.5
	self.wa2000_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.wa2000_crew.alert_size = 5000
	self.wa2000_crew.suppression = 1
end

-- Lines: 3167 to 3187
function WeaponTweakData:_init_data_polymer_crew()
	self.polymer_crew.sounds.prefix = "polymer_npc"
	self.polymer_crew.use_data.selection_index = 1
	self.polymer_crew.DAMAGE = 2
	self.polymer_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.polymer_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.polymer_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.polymer_crew.CLIP_AMMO_MAX = 30
	self.polymer_crew.NR_CLIPS_MAX = 5
	self.polymer_crew.reload = "rifle"
	self.polymer_crew.pull_magazine_during_reload = "smg"
	self.polymer_crew.auto.fire_rate = 0.05
	self.polymer_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.polymer_crew.alert_size = 5000
	self.polymer_crew.suppression = 1
end

-- Lines: 3190 to 3210
function WeaponTweakData:_init_data_hunter_crew()
	self.hunter_crew.sounds.prefix = "hunter_npc"
	self.hunter_crew.use_data.selection_index = 1
	self.hunter_crew.DAMAGE = 2
	self.hunter_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.hunter_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.hunter_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.hunter_crew.CLIP_AMMO_MAX = 1
	self.hunter_crew.NR_CLIPS_MAX = 5
	self.hunter_crew.looped_reload_speed = 0.5
	self.hunter_crew.reload = "looped"
	self.hunter_crew.auto.fire_rate = 20
	self.hunter_crew.hold = "pistol"
	self.hunter_crew.alert_size = 5000
	self.hunter_crew.suppression = 1
end

-- Lines: 3213 to 3232
function WeaponTweakData:_init_data_baka_crew()
	self.baka_crew.sounds.prefix = "baka_npc"
	self.baka_crew.use_data.selection_index = 1
	self.baka_crew.DAMAGE = 2
	self.baka_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.baka_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.baka_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.baka_crew.CLIP_AMMO_MAX = 32
	self.baka_crew.NR_CLIPS_MAX = 5
	self.baka_crew.pull_magazine_during_reload = "smg"
	self.baka_crew.auto.fire_rate = 0.05
	self.baka_crew.hold = "pistol"
	self.baka_crew.alert_size = 5000
	self.baka_crew.suppression = 1
end

-- Lines: 3236 to 3256
function WeaponTweakData:_init_data_arblast_crew()
	self.arblast_crew.sounds.prefix = "arblast_npc"
	self.arblast_crew.use_data.selection_index = 2
	self.arblast_crew.DAMAGE = 2
	self.arblast_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.arblast_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.arblast_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.arblast_crew.CLIP_AMMO_MAX = 1
	self.arblast_crew.NR_CLIPS_MAX = 5
	self.arblast_crew.reload = "looped"
	self.arblast_crew.looped_reload_speed = 0.2
	self.arblast_crew.auto.fire_rate = 20
	self.arblast_crew.hold = "rifle"
	self.arblast_crew.alert_size = 5000
	self.arblast_crew.suppression = 1
end

-- Lines: 3259 to 3279
function WeaponTweakData:_init_data_frankish_crew()
	self.frankish_crew.sounds.prefix = "frankish_npc"
	self.frankish_crew.use_data.selection_index = 2
	self.frankish_crew.DAMAGE = 2
	self.frankish_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.frankish_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.frankish_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.frankish_crew.CLIP_AMMO_MAX = 1
	self.frankish_crew.NR_CLIPS_MAX = 5
	self.frankish_crew.reload = "looped"
	self.frankish_crew.looped_reload_speed = 0.5
	self.frankish_crew.auto.fire_rate = 20
	self.frankish_crew.hold = "rifle"
	self.frankish_crew.alert_size = 5000
	self.frankish_crew.suppression = 1
end

-- Lines: 3282 to 3305
function WeaponTweakData:_init_data_long_crew()
	self.long_crew.sounds.prefix = "bow_npc"
	self.long_crew.use_data.selection_index = 2
	self.long_crew.use_data.align_place = "left_hand"
	self.long_crew.DAMAGE = 2
	self.long_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.long_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.long_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.long_crew.no_trail = true
	self.long_crew.CLIP_AMMO_MAX = 1
	self.long_crew.NR_CLIPS_MAX = 4
	self.long_crew.auto.fire_rate = 0.1
	self.long_crew.hold = "bow"
	self.long_crew.has_fire_animation = true
	self.long_crew.alert_size = 2800
	self.long_crew.suppression = 1
end

-- Lines: 3309 to 3330
function WeaponTweakData:_init_data_par_crew()
	self.par_crew.sounds.prefix = "svinet_npc"
	self.par_crew.use_data.selection_index = 2
	self.par_crew.DAMAGE = 0.99
	self.par_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.par_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.par_crew.CLIP_AMMO_MAX = 200
	self.par_crew.NR_CLIPS_MAX = 2
	self.par_crew.auto.fire_rate = 0.066
	self.par_crew.hold = "rifle"
	self.par_crew.alert_size = 5000
	self.par_crew.suppression = 1
	self.par_secondary_crew = deep_clone(self.par_crew)
	self.par_secondary_crew.use_data.selection_index = 1
	self.par_secondary_crew.armor_piercing = true
end

-- Lines: 3334 to 3351
function WeaponTweakData:_init_data_sparrow_crew()
	self.sparrow_crew.sounds.prefix = "sparrow_npc"
	self.sparrow_crew.use_data.selection_index = 1
	self.sparrow_crew.DAMAGE = 1
	self.sparrow_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.sparrow_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.sparrow_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sparrow_crew.CLIP_AMMO_MAX = 12
	self.sparrow_crew.NR_CLIPS_MAX = 5
	self.sparrow_crew.pull_magazine_during_reload = "pistol"
	self.sparrow_crew.hold = "pistol"
	self.sparrow_crew.alert_size = 2500
	self.sparrow_crew.suppression = 1
end

-- Lines: 3352 to 3372
function WeaponTweakData:_init_data_model70_crew()
	self.model70_crew.sounds.prefix = "model70_npc"
	self.model70_crew.use_data.selection_index = 2
	self.model70_crew.DAMAGE = 15
	self.model70_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.model70_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.model70_crew.CLIP_AMMO_MAX = 5
	self.model70_crew.NR_CLIPS_MAX = 8
	self.model70_crew.auto.fire_rate = 1
	self.model70_crew.hold = "rifle"
	self.model70_crew.alert_size = 5000
	self.model70_crew.suppression = 1
	self.model70_secondary_crew = deep_clone(self.model70_crew)
	self.model70_secondary_crew.use_data.selection_index = 1
end

-- Lines: 3398 to 3418
function WeaponTweakData:_init_data_m37_crew()
	self.m37_crew.sounds.prefix = "m37_npc"
	self.m37_crew.use_data.selection_index = 1
	self.m37_crew.DAMAGE = 5
	self.m37_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.m37_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.m37_crew.auto.fire_rate = 0.14
	self.m37_crew.CLIP_AMMO_MAX = 7
	self.m37_crew.NR_CLIPS_MAX = 6
	self.m37_crew.looped_reload_speed = 0.7
	self.m37_crew.hold = "rifle"
	self.m37_crew.alert_size = 4500
	self.m37_crew.suppression = 1.8
	self.m37_crew.is_shotgun = true
end

-- Lines: 3422 to 3442
function WeaponTweakData:_init_data_china_crew()
	self.china_crew.sounds.prefix = "china_npc"
	self.china_crew.use_data.selection_index = 1
	self.china_crew.DAMAGE = 2
	self.china_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.china_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.china_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.china_crew.no_trail = true
	self.china_crew.CLIP_AMMO_MAX = 3
	self.china_crew.NR_CLIPS_MAX = 2
	self.china_crew.looped_reload_speed = 0.3333333333333333
	self.china_crew.auto.fire_rate = 0.1
	self.china_crew.hold = "rifle"
	self.china_crew.alert_size = 2800
	self.china_crew.suppression = 1
end

-- Lines: 3447 to 3466
function WeaponTweakData:_init_data_sr2_crew()
	self.sr2_crew.sounds.prefix = "sr2_npc"
	self.sr2_crew.use_data.selection_index = 1
	self.sr2_crew.DAMAGE = 2
	self.sr2_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.sr2_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.sr2_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sr2_crew.CLIP_AMMO_MAX = 32
	self.sr2_crew.NR_CLIPS_MAX = 5
	self.sr2_crew.pull_magazine_during_reload = "smg"
	self.sr2_crew.auto.fire_rate = 0.08
	self.sr2_crew.hold = {
		"uzi",
		"bullpup",
		"rifle"
	}
	self.sr2_crew.alert_size = 5000
	self.sr2_crew.suppression = 1
end

-- Lines: 3467 to 3483
function WeaponTweakData:_init_data_x_sr2_crew()
	self.x_sr2_crew.sounds.prefix = "sr2_x_npc"
	self.x_sr2_crew.use_data.selection_index = 2
	self.x_sr2_crew.DAMAGE = 1.25
	self.x_sr2_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_sr2_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_sr2_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_sr2_crew.CLIP_AMMO_MAX = 64
	self.x_sr2_crew.NR_CLIPS_MAX = 5
	self.x_sr2_crew.hold = "akimbo_pistol"
	self.x_sr2_crew.alert_size = 1800
	self.x_sr2_crew.suppression = 2
end

-- Lines: 3487 to 3504
function WeaponTweakData:_init_data_pl14_crew()
	self.pl14_crew.sounds.prefix = "pl14_npc"
	self.pl14_crew.use_data.selection_index = 1
	self.pl14_crew.DAMAGE = 1
	self.pl14_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.pl14_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.pl14_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.pl14_crew.CLIP_AMMO_MAX = 12
	self.pl14_crew.NR_CLIPS_MAX = 5
	self.pl14_crew.pull_magazine_during_reload = "pistol"
	self.pl14_crew.hold = "pistol"
	self.pl14_crew.alert_size = 2500
	self.pl14_crew.suppression = 1
end

-- Lines: 3508 to 3524
function WeaponTweakData:_init_data_x_mp5_crew()
	self.x_mp5_crew.sounds.prefix = "mp5_x_npc"
	self.x_mp5_crew.use_data.selection_index = 2
	self.x_mp5_crew.DAMAGE = 1.25
	self.x_mp5_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_mp5_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_mp5_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_mp5_crew.CLIP_AMMO_MAX = 60
	self.x_mp5_crew.NR_CLIPS_MAX = 5
	self.x_mp5_crew.hold = "akimbo_pistol"
	self.x_mp5_crew.alert_size = 1800
	self.x_mp5_crew.suppression = 2
end

-- Lines: 3526 to 3542
function WeaponTweakData:_init_data_x_akmsu_crew()
	self.x_akmsu_crew.sounds.prefix = "akmsu_x_npc"
	self.x_akmsu_crew.use_data.selection_index = 2
	self.x_akmsu_crew.DAMAGE = 1.25
	self.x_akmsu_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.x_akmsu_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_akmsu_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.x_akmsu_crew.CLIP_AMMO_MAX = 60
	self.x_akmsu_crew.NR_CLIPS_MAX = 5
	self.x_akmsu_crew.hold = "akimbo_pistol"
	self.x_akmsu_crew.alert_size = 1800
	self.x_akmsu_crew.suppression = 2
end

-- Lines: 3546 to 3559
function WeaponTweakData:_init_data_tecci_crew()
	self.tecci_crew.sounds.prefix = "tecci_npc"
	self.tecci_crew.use_data.selection_index = 2
	self.tecci_crew.DAMAGE = 1.35
	self.tecci_crew.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	self.tecci_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.tecci_crew.CLIP_AMMO_MAX = 100
	self.tecci_crew.NR_CLIPS_MAX = 5
	self.tecci_crew.pull_magazine_during_reload = "large_plastic"
	self.tecci_crew.auto.fire_rate = 0.09
	self.tecci_crew.hold = "rifle"
	self.tecci_crew.alert_size = 5000
	self.tecci_crew.suppression = 1
end

-- Lines: 3563 to 3583
function WeaponTweakData:_init_data_hajk_crew()
	self.hajk_crew.sounds.prefix = "hajk_npc"
	self.hajk_crew.use_data.selection_index = 1
	self.hajk_crew.DAMAGE = 1.5
	self.hajk_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.hajk_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.hajk_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.hajk_crew.CLIP_AMMO_MAX = 30
	self.hajk_crew.NR_CLIPS_MAX = 5
	self.hajk_crew.pull_magazine_during_reload = "rifle"
	self.hajk_crew.auto.fire_rate = 0.08
	self.hajk_crew.hold = "rifle"
	self.hajk_crew.alert_size = 1000
	self.hajk_crew.suppression = 1
end

-- Lines: 3587 to 3607
function WeaponTweakData:_init_data_boot_crew()
	self.boot_crew.sounds.prefix = "boot_npc"
	self.boot_crew.use_data.selection_index = 2
	self.boot_crew.DAMAGE = 11.25
	self.boot_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.boot_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.boot_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.boot_crew.CLIP_AMMO_MAX = 7
	self.boot_crew.NR_CLIPS_MAX = 5
	self.boot_crew.auto.fire_rate = 0.75
	self.boot_crew.hold = "rifle"
	self.boot_crew.alert_size = 1000
	self.boot_crew.suppression = 1
	self.boot_crew.suppression = 1
end

-- Lines: 3612 to 3629
function WeaponTweakData:_init_data_packrat_crew()
	self.packrat_crew.sounds.prefix = "packrat_npc"
	self.packrat_crew.use_data.selection_index = 1
	self.packrat_crew.DAMAGE = 1
	self.packrat_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.packrat_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.packrat_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.packrat_crew.CLIP_AMMO_MAX = 15
	self.packrat_crew.NR_CLIPS_MAX = 5
	self.packrat_crew.pull_magazine_during_reload = "pistol"
	self.packrat_crew.hold = "pistol"
	self.packrat_crew.alert_size = 2500
	self.packrat_crew.suppression = 1
end

-- Lines: 3632 to 3652
function WeaponTweakData:_init_data_schakal_crew()
	self.schakal_crew.sounds.prefix = "schakal_npc"
	self.schakal_crew.use_data.selection_index = 1
	self.schakal_crew.DAMAGE = 2
	self.schakal_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.schakal_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.schakal_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.schakal_crew.CLIP_AMMO_MAX = 30
	self.schakal_crew.NR_CLIPS_MAX = 5
	self.schakal_crew.pull_magazine_during_reload = "pistol"
	self.schakal_crew.auto.fire_rate = 0.092
	self.schakal_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.schakal_crew.hold = "rifle"
	self.schakal_crew.alert_size = 5000
	self.schakal_crew.suppression = 1
end

-- Lines: 3654 to 3676
function WeaponTweakData:_init_data_desertfox_crew()
	self.desertfox_crew.sounds.prefix = "desertfox_npc"
	self.desertfox_crew.use_data.selection_index = 2
	self.desertfox_crew.DAMAGE = 15
	self.desertfox_crew.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.desertfox_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.desertfox_crew.CLIP_AMMO_MAX = 5
	self.desertfox_crew.NR_CLIPS_MAX = 8
	self.desertfox_crew.pull_magazine_during_reload = "rifle"
	self.desertfox_crew.auto.fire_rate = 20
	self.desertfox_crew.hold = "rifle"
	self.desertfox_crew.reload = "bullpup"
	self.desertfox_crew.alert_size = 5000
	self.desertfox_crew.suppression = 1
	self.desertfox_secondary_crew = deep_clone(self.desertfox_crew)
	self.desertfox_secondary_crew.use_data.selection_index = 1
end

-- Lines: 3678 to 3694
function WeaponTweakData:_init_data_x_packrat_crew()
	self.x_packrat_crew.sounds.prefix = "packrat_npc"
	self.x_packrat_crew.use_data.selection_index = 2
	self.x_packrat_crew.DAMAGE = 1
	self.x_packrat_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_packrat_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_packrat_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_packrat_crew.CLIP_AMMO_MAX = 30
	self.x_packrat_crew.NR_CLIPS_MAX = 5
	self.x_packrat_crew.hold = "akimbo_pistol"
	self.x_packrat_crew.alert_size = 2500
	self.x_packrat_crew.suppression = 1
end

-- Lines: 3698 to 3717
function WeaponTweakData:_init_data_rota_crew()
	self.rota_crew.sounds.prefix = "rota_npc"
	self.rota_crew.use_data.selection_index = 1
	self.rota_crew.DAMAGE = 5
	self.rota_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.rota_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.rota_crew.auto.fire_rate = 0.14
	self.rota_crew.CLIP_AMMO_MAX = 6
	self.rota_crew.NR_CLIPS_MAX = 6
	self.rota_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.rota_crew.alert_size = 4500
	self.rota_crew.suppression = 1.8
	self.rota_crew.is_shotgun = true
end

-- Lines: 3721 to 3743
function WeaponTweakData:_init_data_arbiter_crew()
	self.arbiter_crew.sounds.prefix = "mgl_npc"
	self.arbiter_crew.use_data.selection_index = 1
	self.arbiter_crew.DAMAGE = 2
	self.arbiter_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.arbiter_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.arbiter_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.arbiter_crew.no_trail = true
	self.arbiter_crew.CLIP_AMMO_MAX = 5
	self.arbiter_crew.NR_CLIPS_MAX = 4
	self.arbiter_crew.pull_magazine_during_reload = "rifle"
	self.arbiter_crew.auto.fire_rate = 0.1
	self.arbiter_crew.hold = "rifle"
	self.arbiter_crew.reload = "bullpup"
	self.arbiter_crew.alert_size = 2800
	self.arbiter_crew.suppression = 1
end

-- Lines: 3748 to 3787
function WeaponTweakData:_init_data_contraband_crew()
	self.contraband_crew.sounds.prefix = "contraband_npc"
	self.contraband_crew.use_data.selection_index = 2
	self.contraband_crew.DAMAGE = 1.47
	self.contraband_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.contraband_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.contraband_crew.CLIP_AMMO_MAX = 20
	self.contraband_crew.NR_CLIPS_MAX = 5
	self.contraband_crew.pull_magazine_during_reload = "rifle"
	self.contraband_crew.auto.fire_rate = 0.098
	self.contraband_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.contraband_crew.reload = "rifle"
	self.contraband_crew.alert_size = 5000
	self.contraband_crew.suppression = 1
	self.contraband_m203_crew.sounds.prefix = "contrabandm203_npc"
	self.contraband_m203_crew.use_data.selection_index = 2
	self.contraband_m203_crew.DAMAGE = 2
	self.contraband_m203_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.contraband_m203_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.contraband_m203_crew.no_trail = true
	self.contraband_m203_crew.CLIP_AMMO_MAX = 1
	self.contraband_m203_crew.NR_CLIPS_MAX = 4
	self.contraband_m203_crew.auto.fire_rate = 0.1
	self.contraband_m203_crew.hold = {
		"bullpup",
		"rifle"
	}
	self.contraband_m203_crew.alert_size = 2800
	self.contraband_m203_crew.suppression = 1
end

-- Lines: 3791 to 3814
function WeaponTweakData:_init_data_ray_crew()
	self.ray_crew.sounds.prefix = "ray_npc"
	self.ray_crew.use_data.selection_index = 1
	self.ray_crew.DAMAGE = 2
	self.ray_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.ray_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.ray_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.ray_crew.no_trail = true
	self.ray_crew.CLIP_AMMO_MAX = 4
	self.ray_crew.NR_CLIPS_MAX = 1
	self.ray_crew.auto.fire_rate = 0.1
	self.ray_crew.hold = "rifle"
	self.ray_crew.animations = {thq_align_anim = "thq"}
	self.ray_crew.alert_size = 2800
	self.ray_crew.suppression = 1
end

-- Lines: 3819 to 3838
function WeaponTweakData:_init_data_tti_crew()
	self.tti_crew.sounds.prefix = "tti_npc"
	self.tti_crew.use_data.selection_index = 2
	self.tti_crew.DAMAGE = 6
	self.tti_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.tti_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.tti_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.tti_crew.CLIP_AMMO_MAX = 20
	self.tti_crew.NR_CLIPS_MAX = 5
	self.tti_crew.pull_magazine_during_reload = "rifle"
	self.tti_crew.auto.fire_rate = 0.4
	self.tti_crew.hold = "rifle"
	self.tti_crew.alert_size = 5000
	self.tti_crew.suppression = 1
end

-- Lines: 3844 to 3862
function WeaponTweakData:_init_data_siltstone_crew()
	self.siltstone_crew.sounds.prefix = "siltstone_npc"
	self.siltstone_crew.use_data.selection_index = 2
	self.siltstone_crew.DAMAGE = 2
	self.siltstone_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.siltstone_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.siltstone_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.siltstone_crew.CLIP_AMMO_MAX = 10
	self.siltstone_crew.NR_CLIPS_MAX = 4
	self.siltstone_crew.auto.fire_rate = 0.5
	self.siltstone_crew.hold = "rifle"
	self.siltstone_crew.alert_size = 5000
	self.siltstone_crew.suppression = 1
end

-- Lines: 3865 to 3883
function WeaponTweakData:_init_data_flint_crew()
	self.flint_crew.sounds.prefix = "flint_npc"
	self.flint_crew.use_data.selection_index = 2
	self.flint_crew.DAMAGE = 2
	self.flint_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.flint_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.flint_crew.CLIP_AMMO_MAX = 35
	self.flint_crew.NR_CLIPS_MAX = 5
	self.flint_crew.pull_magazine_during_reload = "rifle"
	self.flint_crew.auto.fire_rate = 0.092
	self.flint_crew.hold = "rifle"
	self.flint_crew.alert_size = 5000
	self.flint_crew.suppression = 1
end

-- Lines: 3885 to 3904
function WeaponTweakData:_init_data_coal_crew()
	self.coal_crew.sounds.prefix = "coal_npc"
	self.coal_crew.use_data.selection_index = 1
	self.coal_crew.DAMAGE = 2
	self.coal_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.coal_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.coal_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.coal_crew.CLIP_AMMO_MAX = 64
	self.coal_crew.NR_CLIPS_MAX = 5
	self.coal_crew.pull_magazine_during_reload = "rifle"
	self.coal_crew.auto.fire_rate = 0.092
	self.coal_crew.hold = "rifle"
	self.coal_crew.alert_size = 5000
	self.coal_crew.suppression = 1
end

-- Lines: 3911 to 3928
function WeaponTweakData:_init_data_lemming_crew()
	self.lemming_crew.sounds.prefix = "lemming_npc"
	self.lemming_crew.use_data.selection_index = 1
	self.lemming_crew.DAMAGE = 1
	self.lemming_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.lemming_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.lemming_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.lemming_crew.CLIP_AMMO_MAX = 10
	self.lemming_crew.NR_CLIPS_MAX = 5
	self.lemming_crew.pull_magazine_during_reload = "pistol"
	self.lemming_crew.hold = "pistol"
	self.lemming_crew.alert_size = 2500
	self.lemming_crew.suppression = 1
end

-- Lines: 3934 to 3950
function WeaponTweakData:_init_data_chinchilla_crew()
	self.chinchilla_crew.sounds.prefix = "chinchilla_npc"
	self.chinchilla_crew.use_data.selection_index = 1
	self.chinchilla_crew.DAMAGE = 1
	self.chinchilla_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.chinchilla_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.chinchilla_crew.CLIP_AMMO_MAX = 6
	self.chinchilla_crew.NR_CLIPS_MAX = 5
	self.chinchilla_crew.hold = "pistol"
	self.chinchilla_crew.reload = "revolver"
	self.chinchilla_crew.alert_size = 2500
	self.chinchilla_crew.suppression = 1
end

-- Lines: 3952 to 3968
function WeaponTweakData:_init_data_x_chinchilla_crew()
	self.x_chinchilla_crew.sounds.prefix = "chinchilla_npc"
	self.x_chinchilla_crew.use_data.selection_index = 2
	self.x_chinchilla_crew.DAMAGE = 1
	self.x_chinchilla_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.x_chinchilla_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_chinchilla_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.x_chinchilla_crew.CLIP_AMMO_MAX = 12
	self.x_chinchilla_crew.NR_CLIPS_MAX = 5
	self.x_chinchilla_crew.hold = "akimbo_pistol"
	self.x_chinchilla_crew.alert_size = 2500
	self.x_chinchilla_crew.suppression = 1
end

-- Lines: 4012 to 4029
function WeaponTweakData:_init_data_breech_crew()
	self.breech_crew.sounds.prefix = "breech_npc"
	self.breech_crew.use_data.selection_index = 1
	self.breech_crew.DAMAGE = 1
	self.breech_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.breech_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.breech_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.breech_crew.CLIP_AMMO_MAX = 15
	self.breech_crew.NR_CLIPS_MAX = 5
	self.breech_crew.pull_magazine_during_reload = "pistol"
	self.breech_crew.hold = "pistol"
	self.breech_crew.alert_size = 2500
	self.breech_crew.suppression = 1
end

-- Lines: 4032 to 4053
function WeaponTweakData:_init_data_ching_crew()
	self.ching_crew.sounds.prefix = "ching_npc"
	self.ching_crew.use_data.selection_index = 2
	self.ching_crew.DAMAGE = 1.28
	self.ching_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.ching_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ching_crew.CLIP_AMMO_MAX = 10
	self.ching_crew.NR_CLIPS_MAX = 8
	self.ching_crew.pull_magazine_during_reload = "rifle"
	self.ching_crew.reload = "looped"
	self.ching_crew.looped_reload_speed = 1
	self.ching_crew.auto.fire_rate = 0.085
	self.ching_crew.hold = "rifle"
	self.ching_crew.alert_size = 5000
	self.ching_crew.suppression = 1
end

-- Lines: 4055 to 4076
function WeaponTweakData:_init_data_erma_crew()
	self.erma_crew.sounds.prefix = "erma_npc"
	self.erma_crew.use_data.selection_index = 1
	self.erma_crew.DAMAGE = 2
	self.erma_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
	self.erma_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.erma_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.erma_crew.CLIP_AMMO_MAX = 40
	self.erma_crew.NR_CLIPS_MAX = 5
	self.erma_crew.reload = "rifle"
	self.erma_crew.pull_magazine_during_reload = "smg"
	self.erma_crew.auto.fire_rate = 0.1
	self.erma_crew.hold = "rifle"
	self.erma_crew.alert_size = 2800
	self.erma_crew.suppression = 1
end

-- Lines: 4141 to 4161
function WeaponTweakData:_init_data_basset_crew()
	self.basset_crew.sounds.prefix = "basset_npc"
	self.basset_crew.use_data.selection_index = 1
	self.basset_crew.DAMAGE = 3
	self.basset_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.basset_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.basset_crew.auto.fire_rate = 0.2
	self.basset_crew.CLIP_AMMO_MAX = 8
	self.basset_crew.NR_CLIPS_MAX = 4
	self.basset_crew.pull_magazine_during_reload = "large_plastic"
	self.basset_crew.hold = "bullpup"
	self.basset_crew.alert_size = 4500
	self.basset_crew.suppression = 1.8
	self.basset_crew.is_shotgun = true
end

-- Lines: 4163 to 4180
function WeaponTweakData:_init_data_x_basset_crew()
	self.x_basset_crew.sounds.prefix = "basset_x_npc"
	self.x_basset_crew.use_data.selection_index = 2
	self.x_basset_crew.DAMAGE = 1.25
	self.x_basset_crew.muzzleflash = "effects/payday2/particles/weapons/762_auto"
	self.x_basset_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	self.x_basset_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.x_basset_crew.rays = 12
	self.x_basset_crew.CLIP_AMMO_MAX = 60
	self.x_basset_crew.NR_CLIPS_MAX = 5
	self.x_basset_crew.hold = "akimbo_pistol"
	self.x_basset_crew.alert_size = 1800
	self.x_basset_crew.suppression = 2
end

-- Lines: 4183 to 4368
function WeaponTweakData:_init_data_player_weapons(tweak_data)
	local autohit_rifle_default, autohit_pistol_default, autohit_shotgun_default, autohit_lmg_default, autohit_snp_default, autohit_smg_default, autohit_minigun_default, aim_assist_rifle_default, aim_assist_pistol_default, aim_assist_shotgun_default, aim_assist_lmg_default, aim_assist_snp_default, aim_assist_smg_default, aim_assist_minigun_default = nil

	if SystemInfo:platform() == Idstring("WIN32") then
		autohit_rifle_default = {
			INIT_RATIO = 0.15,
			MAX_RATIO = 0.85,
			far_angle = 1,
			far_dis = 4000,
			MIN_RATIO = 0.75,
			near_angle = 3
		}
		autohit_pistol_default = {
			INIT_RATIO = 0.15,
			MAX_RATIO = 0.95,
			far_angle = 0.5,
			far_dis = 4000,
			MIN_RATIO = 0.82,
			near_angle = 3
		}
		autohit_shotgun_default = {
			INIT_RATIO = 0.15,
			MAX_RATIO = 0.7,
			far_angle = 1.5,
			far_dis = 5000,
			MIN_RATIO = 0.6,
			near_angle = 3
		}
		autohit_lmg_default = {
			INIT_RATIO = 0.05,
			MAX_RATIO = 0.4,
			far_angle = 0.2,
			far_dis = 2000,
			MIN_RATIO = 0.2,
			near_angle = 2
		}
		autohit_snp_default = {
			INIT_RATIO = 0.05,
			MAX_RATIO = 0.4,
			far_angle = 0.2,
			far_dis = 5000,
			MIN_RATIO = 0.2,
			near_angle = 2
		}
		autohit_smg_default = {
			INIT_RATIO = 0.05,
			MAX_RATIO = 0.4,
			far_angle = 0.5,
			far_dis = 2500,
			MIN_RATIO = 0.2,
			near_angle = 4
		}
		autohit_minigun_default = {
			INIT_RATIO = 1,
			MAX_RATIO = 1,
			far_angle = 0.0005,
			far_dis = 10000,
			MIN_RATIO = 0,
			near_angle = 0.0005
		}
	else
		autohit_rifle_default = {
			INIT_RATIO = 0.6,
			MAX_RATIO = 0.6,
			far_angle = 3,
			far_dis = 5000,
			MIN_RATIO = 0.25,
			near_angle = 3
		}
		autohit_pistol_default = {
			INIT_RATIO = 0.6,
			MAX_RATIO = 0.6,
			far_angle = 3,
			far_dis = 2500,
			MIN_RATIO = 0.25,
			near_angle = 3
		}
		autohit_shotgun_default = {
			INIT_RATIO = 0.3,
			MAX_RATIO = 0.3,
			far_angle = 5,
			far_dis = 5000,
			MIN_RATIO = 0.15,
			near_angle = 3
		}
		autohit_lmg_default = {
			INIT_RATIO = 0.6,
			MAX_RATIO = 0.6,
			far_angle = 3,
			far_dis = 5000,
			MIN_RATIO = 0.25,
			near_angle = 3
		}
		autohit_snp_default = {
			INIT_RATIO = 0.6,
			MAX_RATIO = 0.6,
			far_angle = 3,
			far_dis = 5000,
			MIN_RATIO = 0.25,
			near_angle = 3
		}
		autohit_smg_default = {
			INIT_RATIO = 0.6,
			MAX_RATIO = 0.6,
			far_angle = 3,
			far_dis = 5000,
			MIN_RATIO = 0.25,
			near_angle = 3
		}
		autohit_minigun_default = {
			INIT_RATIO = 1,
			MAX_RATIO = 1,
			far_angle = 0.0005,
			far_dis = 10000,
			MIN_RATIO = 0,
			near_angle = 0.0005
		}
	end

	aim_assist_rifle_default = deep_clone(autohit_rifle_default)
	aim_assist_pistol_default = deep_clone(autohit_pistol_default)
	aim_assist_shotgun_default = deep_clone(autohit_shotgun_default)
	aim_assist_lmg_default = deep_clone(autohit_lmg_default)
	aim_assist_snp_default = deep_clone(autohit_snp_default)
	aim_assist_smg_default = deep_clone(autohit_smg_default)
	aim_assist_minigun_default = deep_clone(autohit_minigun_default)
	aim_assist_rifle_default.near_angle = 40
	aim_assist_pistol_default.near_angle = 20
	aim_assist_shotgun_default.near_angle = 40
	aim_assist_lmg_default.near_angle = 10
	aim_assist_snp_default.near_angle = 20
	aim_assist_smg_default.near_angle = 30
	self.crosshair = {
		MIN_OFFSET = 10,
		MAX_OFFSET = 150,
		MIN_KICK_OFFSET = 0,
		MAX_KICK_OFFSET = 100,
		DEFAULT_OFFSET = 0.16,
		DEFAULT_KICK_OFFSET = 0.6
	}
	local damage_melee_default = 1.5
	local damage_melee_effect_multiplier_default = 1.75
	self.trip_mines = {
		delay = 0.3,
		damage = 100,
		player_damage = 6,
		damage_size = 300,
		alert_radius = 5000
	}

	self:_init_stats()

	self.factory = WeaponFactoryTweakData:new()

	tweak_data._init_wip_weapon_factory(self.factory, tweak_data)
	self:_init_new_weapons(autohit_rifle_default, autohit_pistol_default, autohit_shotgun_default, autohit_lmg_default, autohit_snp_default, autohit_smg_default, autohit_minigun_default, damage_melee_default, damage_melee_effect_multiplier_default, aim_assist_rifle_default, aim_assist_pistol_default, aim_assist_shotgun_default, aim_assist_lmg_default, aim_assist_snp_default, aim_assist_smg_default, aim_assist_minigun_default)

	local free_dlcs = tweak_data:free_dlc_list()

	for _, data in pairs(self) do
		if free_dlcs[data.global_value] then
			data.global_value = nil
		end
	end

	for _, data in pairs(self.factory.parts) do
		if free_dlcs[data.dlc] then
			data.dlc = nil
		end
	end
end

-- Lines: 4370 to 4452
function WeaponTweakData:_init_stats()
	self.stats = {
		alert_size = {
			30000,
			20000,
			15000,
			10000,
			7500,
			6000,
			4500,
			4000,
			3500,
			1800,
			1500,
			1200,
			1000,
			850,
			700,
			500,
			350,
			200,
			100,
			0
		},
		suppression = {
			4.5,
			3.9,
			3.6,
			3.3,
			3,
			2.8,
			2.6,
			2.4,
			2.2,
			1.6,
			1.5,
			1.4,
			1.3,
			1.2,
			1.1,
			1,
			0.8,
			0.6,
			0.4,
			0.2
		},
		damage = {
			0.1,
			0.2,
			0.3,
			0.4,
			0.5,
			0.6,
			0.7,
			0.8,
			0.9,
			1,
			1.1,
			1.2,
			1.3,
			1.4,
			1.5,
			1.6,
			1.7,
			1.8,
			1.9,
			2,
			2.1,
			2.2,
			2.3,
			2.4,
			2.5,
			2.6,
			2.7,
			2.8,
			2.9,
			3,
			3.1,
			3.2,
			3.3,
			3.4,
			3.5,
			3.6,
			3.7,
			3.8,
			3.9,
			4,
			4.1,
			4.2,
			4.3,
			4.4,
			4.5,
			4.6,
			4.7,
			4.8,
			4.9,
			5,
			5.1,
			5.2,
			5.3,
			5.4,
			5.5,
			5.6,
			5.7,
			5.8,
			5.9,
			6,
			6.1,
			6.2,
			6.3,
			6.4,
			6.5,
			6.6,
			6.7,
			6.8,
			6.9,
			7,
			7.1,
			7.2,
			7.3,
			7.4,
			7.5,
			7.6,
			7.7,
			7.8,
			7.9,
			8,
			8.1,
			8.2,
			8.3,
			8.4,
			8.5,
			8.6,
			8.7,
			8.8,
			8.9,
			9,
			9.1,
			9.2,
			9.3,
			9.4,
			9.5,
			9.6,
			9.7,
			9.8,
			9.9,
			10,
			10.1,
			10.2,
			10.3,
			10.4,
			10.5,
			10.6,
			10.7,
			10.8,
			10.9,
			11,
			11.1,
			11.2,
			11.3,
			11.4,
			11.5,
			11.6,
			11.7,
			11.8,
			11.9,
			12,
			12.1,
			12.2,
			12.3,
			12.4,
			12.5,
			12.6,
			12.7,
			12.8,
			12.9,
			13,
			13.1,
			13.2,
			13.3,
			13.4,
			13.5,
			13.6,
			13.7,
			13.8,
			13.9,
			14,
			14.1,
			14.2,
			14.3,
			14.4,
			14.5,
			14.6,
			14.7,
			14.8,
			14.9,
			15,
			15.1,
			15.2,
			15.3,
			15.4,
			15.5,
			15.6,
			15.7,
			15.8,
			15.9,
			16,
			16.1,
			16.2,
			16.3,
			16.4,
			16.5,
			16.6,
			16.7,
			16.8,
			16.9,
			17,
			17.1,
			17.2,
			17.3,
			17.4,
			17.5,
			17.6,
			17.7,
			17.8,
			17.9,
			18,
			18.1,
			18.2,
			18.3,
			18.4,
			18.5,
			18.6,
			18.7,
			18.8,
			18.9,
			19,
			19.1,
			19.2,
			19.3,
			19.4,
			19.5,
			19.6,
			19.7,
			19.8,
			19.9,
			20,
			20.1,
			20.2,
			20.3,
			20.4,
			20.5,
			20.6,
			20.7,
			20.8,
			20.9,
			21
		},
		zoom = {
			63,
			60,
			55,
			50,
			45,
			40,
			35,
			30,
			25,
			20
		},
		spread = {
			2,
			1.92,
			1.84,
			1.76,
			1.68,
			1.6,
			1.52,
			1.44,
			1.36,
			1.28,
			1.2,
			1.12,
			1.04,
			0.96,
			0.88,
			0.8,
			0.72,
			0.64,
			0.56,
			0.48,
			0.4,
			0.32,
			0.24,
			0.16,
			0.08,
			0
		},
		spread_moving = {
			2.5,
			2.42,
			2.34,
			2.26,
			2.18,
			2.1,
			2.02,
			1.94,
			1.86,
			1.78,
			1.7,
			1.62,
			1.54,
			1.46,
			1.38,
			1.3,
			1.22,
			1.14,
			1.06,
			0.98,
			0.9,
			0.82,
			0.74,
			0.66,
			0.58,
			0.5
		},
		recoil = {
			3,
			2.9,
			2.8,
			2.7,
			2.6,
			2.5,
			2.4,
			2.3,
			2.2,
			2.1,
			2,
			1.9,
			1.8,
			1.7,
			1.6,
			1.5,
			1.4,
			1.3,
			1.2,
			1.1,
			1,
			0.9,
			0.8,
			0.7,
			0.6,
			0.5
		},
		value = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10
		},
		concealment = {
			0.3,
			0.4,
			0.5,
			0.6,
			0.65,
			0.7,
			0.75,
			0.8,
			0.825,
			0.85,
			1,
			1.05,
			1.1,
			1.15,
			1.2,
			1.225,
			1.25,
			1.275,
			1.3,
			1.325,
			1.35,
			1.375,
			1.4,
			1.425,
			1.45,
			1.475,
			1.5,
			1.525,
			1.55,
			1.6
		},
		extra_ammo = {}
	}

	for i = -10, 100, 2 do
		table.insert(self.stats.extra_ammo, i)
	end

	self.stats.total_ammo_mod = {}

	for i = -100, 100, 5 do
		table.insert(self.stats.total_ammo_mod, i / 100)
	end

	self.stats.reload = {}

	for i = 5, 20, 0.5 do
		if i <= 10 or i == math.floor(i) then
			table.insert(self.stats.reload, i / 10)
		end
	end
end

-- Lines: 4454 to 4477
function WeaponTweakData:_pickup_chance(max_ammo, selection_index)
	local low, high = nil

	if selection_index == 2 then
		low = 0.03
		high = 0.055
	elseif selection_index == 3 then
		low = 0.03
		high = 0.055
	elseif selection_index == 4 then
		low = 0.05
		high = 0.075
	elseif selection_index == 5 then
		low = 0.05
		high = 0.075
	elseif selection_index == 6 then
		low = 0.005
		high = 0.015
	else
		low = 0.01
		high = 0.035
	end

	return {
		max_ammo * low,
		max_ammo * high
	}
end

-- Lines: 4480 to 20147
function WeaponTweakData:_init_new_weapons(autohit_rifle_default, autohit_pistol_default, autohit_shotgun_default, autohit_lmg_default, autohit_snp_default, autohit_smg_default, autohit_minigun_default, damage_melee_default, damage_melee_effect_multiplier_default, aim_assist_rifle_default, aim_assist_pistol_default, aim_assist_shotgun_default, aim_assist_lmg_default, aim_assist_snp_default, aim_assist_smg_default, aim_assist_minigun_default)
	local total_damage_primary = 300
	local total_damage_secondary = 150
	local default_bipod_spread = 1.6
	self.new_m4 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.new_m4.sounds.fire = "m4_fire_single"
	self.new_m4.sounds.fire_single = "m4_fire_single"
	self.new_m4.sounds.fire_auto = "m4_fire"
	self.new_m4.sounds.stop_fire = "m4_stop"
	self.new_m4.sounds.dryfire = "primary_dryfire"
	self.new_m4.sounds.enter_steelsight = "m4_tighten"
	self.new_m4.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.new_m4.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.new_m4.timers = {
		reload_not_empty = 2.665,
		reload_empty = 3.43,
		unequip = 0.6,
		equip = 0.6
	}
	self.new_m4.name_id = "bm_w_m4"
	self.new_m4.desc_id = "bm_w_m4_desc"
	self.new_m4.description_id = "des_m4"
	self.new_m4.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.new_m4.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.new_m4.use_data = {selection_index = 2}
	self.new_m4.DAMAGE = 1
	self.new_m4.CLIP_AMMO_MAX = 30
	self.new_m4.NR_CLIPS_MAX = 5
	self.new_m4.AMMO_MAX = self.new_m4.CLIP_AMMO_MAX * self.new_m4.NR_CLIPS_MAX
	self.new_m4.AMMO_PICKUP = self:_pickup_chance(self.new_m4.AMMO_MAX, 3)
	self.new_m4.FIRE_MODE = "auto"
	self.new_m4.fire_mode_data = {fire_rate = 0.1}
	self.new_m4.CAN_TOGGLE_FIREMODE = true
	self.new_m4.auto = {fire_rate = 0.1}
	self.new_m4.spread = {standing = 3}
	self.new_m4.spread.crouching = self.new_m4.spread.standing * 0.4
	self.new_m4.spread.steelsight = self.new_m4.spread.standing * 0.4
	self.new_m4.spread.moving_standing = self.new_m4.spread.standing
	self.new_m4.spread.moving_crouching = self.new_m4.spread.standing
	self.new_m4.spread.moving_steelsight = self.new_m4.spread.steelsight
	self.new_m4.kick = {standing = {
		0.6,
		0.8,
		-1,
		1
	}}
	self.new_m4.kick.crouching = self.new_m4.kick.standing
	self.new_m4.kick.steelsight = self.new_m4.kick.standing
	self.new_m4.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.new_m4.crosshair.standing.offset = 0.16
	self.new_m4.crosshair.standing.moving_offset = 0.7
	self.new_m4.crosshair.standing.kick_offset = 0.5
	self.new_m4.crosshair.crouching.offset = 0.07
	self.new_m4.crosshair.crouching.moving_offset = 0.7
	self.new_m4.crosshair.crouching.kick_offset = 0.3
	self.new_m4.crosshair.steelsight.hidden = true
	self.new_m4.crosshair.steelsight.offset = 0
	self.new_m4.crosshair.steelsight.moving_offset = 0
	self.new_m4.crosshair.steelsight.kick_offset = 0.1
	self.new_m4.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.new_m4.autohit = autohit_rifle_default
	self.new_m4.aim_assist = aim_assist_rifle_default
	self.new_m4.weapon_hold = "m4"
	self.new_m4.animations = {
		reload = "reload",
		reload_not_empty = "reload_not_empty",
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.new_m4.transition_duration = 0.02
	self.new_m4.panic_suppression_chance = 0.2
	self.new_m4.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 7,
		spread = 12,
		spread_moving = 10,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 20
	}
	self.glock_17 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.glock_17.sounds.fire = "g17_fire"
	self.glock_17.sounds.dryfire = "secondary_dryfire"
	self.glock_17.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.glock_17.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.glock_17.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.glock_17.FIRE_MODE = "single"
	self.glock_17.fire_mode_data = {fire_rate = 0.125}
	self.glock_17.single = {fire_rate = 0.125}
	self.glock_17.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.glock_17.name_id = "bm_w_glock_17"
	self.glock_17.desc_id = "bm_w_glock_17_desc"
	self.glock_17.description_id = "des_glock_17"
	self.glock_17.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.glock_17.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.glock_17.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.glock_17.use_data = {selection_index = 1}
	self.glock_17.DAMAGE = 1
	self.glock_17.CLIP_AMMO_MAX = 17
	self.glock_17.NR_CLIPS_MAX = 9
	self.glock_17.AMMO_MAX = self.glock_17.CLIP_AMMO_MAX * self.glock_17.NR_CLIPS_MAX
	self.glock_17.AMMO_PICKUP = self:_pickup_chance(self.glock_17.AMMO_MAX, 1)
	self.glock_17.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.glock_17.kick = {standing = {
		1.2,
		1.8,
		-0.5,
		0.5
	}}
	self.glock_17.kick.crouching = self.glock_17.kick.standing
	self.glock_17.kick.steelsight = self.glock_17.kick.standing
	self.glock_17.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.glock_17.crosshair.standing.offset = 0.175
	self.glock_17.crosshair.standing.moving_offset = 0.6
	self.glock_17.crosshair.standing.kick_offset = 0.4
	self.glock_17.crosshair.crouching.offset = 0.1
	self.glock_17.crosshair.crouching.moving_offset = 0.6
	self.glock_17.crosshair.crouching.kick_offset = 0.3
	self.glock_17.crosshair.steelsight.hidden = true
	self.glock_17.crosshair.steelsight.offset = 0
	self.glock_17.crosshair.steelsight.moving_offset = 0
	self.glock_17.crosshair.steelsight.kick_offset = 0.1
	self.glock_17.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.glock_17.autohit = autohit_pistol_default
	self.glock_17.aim_assist = aim_assist_pistol_default
	self.glock_17.weapon_hold = "glock"
	self.glock_17.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.glock_17.transition_duration = 0
	self.glock_17.panic_suppression_chance = 0.2
	self.glock_17.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 35,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 30
	}
	self.mp9 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.mp9.sounds.fire = "mp9_fire_single"
	self.mp9.sounds.fire_single = "mp9_fire_single"
	self.mp9.sounds.fire_auto = "mp9_fire"
	self.mp9.sounds.stop_fire = "mp9_stop"
	self.mp9.sounds.dryfire = "secondary_dryfire"
	self.mp9.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.mp9.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.mp9.timers = {
		reload_not_empty = 1.51,
		reload_empty = 2.48,
		unequip = 0.5,
		equip = 0.4
	}
	self.mp9.name_id = "bm_w_mp9"
	self.mp9.desc_id = "bm_w_mp9_desc"
	self.mp9.description_id = "des_mp9"
	self.mp9.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.mp9.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.mp9.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mp9.use_data = {selection_index = 1}
	self.mp9.DAMAGE = 1
	self.mp9.CLIP_AMMO_MAX = 30
	self.mp9.NR_CLIPS_MAX = 7
	self.mp9.AMMO_MAX = self.mp9.CLIP_AMMO_MAX * self.mp9.NR_CLIPS_MAX
	self.mp9.AMMO_PICKUP = self:_pickup_chance(self.mp9.AMMO_MAX, 2)
	self.mp9.FIRE_MODE = "auto"
	self.mp9.fire_mode_data = {fire_rate = 0.063}
	self.mp9.CAN_TOGGLE_FIREMODE = true
	self.mp9.auto = {fire_rate = 0.063}
	self.mp9.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.mp9.kick = {standing = {
		-1.2,
		1.2,
		-1,
		1
	}}
	self.mp9.kick.crouching = self.mp9.kick.standing
	self.mp9.kick.steelsight = self.mp9.kick.standing
	self.mp9.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.mp9.crosshair.standing.offset = 0.4
	self.mp9.crosshair.standing.moving_offset = 0.7
	self.mp9.crosshair.standing.kick_offset = 0.6
	self.mp9.crosshair.crouching.offset = 0.3
	self.mp9.crosshair.crouching.moving_offset = 0.6
	self.mp9.crosshair.crouching.kick_offset = 0.4
	self.mp9.crosshair.steelsight.hidden = true
	self.mp9.crosshair.steelsight.offset = 0
	self.mp9.crosshair.steelsight.moving_offset = 0
	self.mp9.crosshair.steelsight.kick_offset = 0.4
	self.mp9.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.mp9.autohit = autohit_smg_default
	self.mp9.aim_assist = aim_assist_smg_default
	self.mp9.animations = {
		equip_id = "equip_mac11_rifle",
		recoil_steelsight = true
	}
	self.mp9.panic_suppression_chance = 0.2
	self.mp9.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 20,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 26
	}
	self.r870 = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.r870.sounds.fire = "remington_fire"
	self.r870.sounds.dryfire = "shotgun_dryfire"
	self.r870.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.r870.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.r870.timers = {
		unequip = 0.85,
		equip = 0.85
	}
	self.r870.name_id = "bm_w_r870"
	self.r870.desc_id = "bm_w_r870_desc"
	self.r870.description_id = "des_r870"
	self.r870.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.r870.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.r870.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.r870.DAMAGE = 6
	self.r870.damage_near = 2000
	self.r870.damage_far = 3000
	self.r870.rays = 12
	self.r870.CLIP_AMMO_MAX = 6
	self.r870.NR_CLIPS_MAX = 7
	self.r870.AMMO_MAX = self.r870.CLIP_AMMO_MAX * self.r870.NR_CLIPS_MAX
	self.r870.AMMO_PICKUP = self:_pickup_chance(self.r870.AMMO_MAX, 1)
	self.r870.FIRE_MODE = "single"
	self.r870.fire_mode_data = {fire_rate = 0.575}
	self.r870.single = {fire_rate = 0.575}
	self.r870.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.r870.kick = {standing = {
		1.9,
		2,
		-0.2,
		0.2
	}}
	self.r870.kick.crouching = self.r870.kick.standing
	self.r870.kick.steelsight = {
		1.5,
		1.7,
		-0.2,
		0.2
	}
	self.r870.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.r870.crosshair.standing.offset = 0.7
	self.r870.crosshair.standing.moving_offset = 0.7
	self.r870.crosshair.standing.kick_offset = 0.8
	self.r870.crosshair.crouching.offset = 0.65
	self.r870.crosshair.crouching.moving_offset = 0.65
	self.r870.crosshair.crouching.kick_offset = 0.75
	self.r870.crosshair.steelsight.hidden = true
	self.r870.crosshair.steelsight.offset = 0
	self.r870.crosshair.steelsight.moving_offset = 0
	self.r870.crosshair.steelsight.kick_offset = 0
	self.r870.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.r870.autohit = autohit_shotgun_default
	self.r870.aim_assist = aim_assist_shotgun_default
	self.r870.weapon_hold = "r870_shotgun"
	self.r870.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.r870.panic_suppression_chance = 0.2
	self.r870.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 90,
		alert_size = 7,
		spread = 11,
		spread_moving = 12,
		recoil = 9,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 11
	}
	self.glock_18c = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.glock_18c.sounds.fire = "g18c_fire_single"
	self.glock_18c.sounds.fire_single = "g18c_fire_single"
	self.glock_18c.sounds.fire_auto = "g18c_fire"
	self.glock_18c.sounds.stop_fire = "g18c_stop"
	self.glock_18c.sounds.dryfire = "secondary_dryfire"
	self.glock_18c.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.glock_18c.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.glock_18c.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.glock_18c.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.glock_18c.name_id = "bm_w_glock_18c"
	self.glock_18c.desc_id = "bm_w_glock_18c_desc"
	self.glock_18c.description_id = "des_glock"
	self.glock_18c.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.glock_18c.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.glock_18c.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.glock_18c.use_data = {selection_index = 1}
	self.glock_18c.DAMAGE = 1
	self.glock_18c.CLIP_AMMO_MAX = 20
	self.glock_18c.NR_CLIPS_MAX = 8
	self.glock_18c.AMMO_MAX = self.glock_18c.CLIP_AMMO_MAX * self.glock_18c.NR_CLIPS_MAX
	self.glock_18c.AMMO_PICKUP = self:_pickup_chance(self.glock_18c.AMMO_MAX, 1)
	self.glock_18c.FIRE_MODE = "auto"
	self.glock_18c.fire_mode_data = {fire_rate = 0.066}
	self.glock_18c.CAN_TOGGLE_FIREMODE = true
	self.glock_18c.auto = {fire_rate = 0.066}
	self.glock_18c.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.glock_18c.kick = {standing = self.glock_17.kick.standing}
	self.glock_18c.kick.crouching = self.glock_18c.kick.standing
	self.glock_18c.kick.steelsight = self.glock_18c.kick.standing
	self.glock_18c.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.glock_18c.crosshair.standing.offset = 0.3
	self.glock_18c.crosshair.standing.moving_offset = 0.5
	self.glock_18c.crosshair.standing.kick_offset = 0.6
	self.glock_18c.crosshair.crouching.offset = 0.2
	self.glock_18c.crosshair.crouching.moving_offset = 0.5
	self.glock_18c.crosshair.crouching.kick_offset = 0.3
	self.glock_18c.crosshair.steelsight.hidden = true
	self.glock_18c.crosshair.steelsight.offset = 0.2
	self.glock_18c.crosshair.steelsight.moving_offset = 0.2
	self.glock_18c.crosshair.steelsight.kick_offset = 0.3
	self.glock_18c.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.glock_18c.autohit = autohit_pistol_default
	self.glock_18c.aim_assist = aim_assist_pistol_default
	self.glock_18c.weapon_hold = "glock"
	self.glock_18c.animations = {
		fire = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.glock_18c.challenges = {
		group = "handgun",
		weapon = "glock"
	}
	self.glock_18c.transition_duration = 0
	self.glock_18c.panic_suppression_chance = 0.2
	self.glock_18c.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 35,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 29
	}
	self.amcar = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.amcar.sounds.fire = "amcar_fire_single"
	self.amcar.sounds.fire_single = "amcar_fire_single"
	self.amcar.sounds.fire_auto = "amcar_fire"
	self.amcar.sounds.stop_fire = "amcar_stop"
	self.amcar.sounds.dryfire = "primary_dryfire"
	self.amcar.sounds.enter_steelsight = "m4_tighten"
	self.amcar.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.amcar.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.amcar.timers = {
		reload_not_empty = 2.25,
		reload_empty = 3,
		unequip = 0.6,
		equip = 0.55
	}
	self.amcar.name_id = "bm_w_amcar"
	self.amcar.desc_id = "bm_w_amcar_desc"
	self.amcar.description_id = "des_m4"
	self.amcar.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.amcar.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.amcar.use_data = {selection_index = 2}
	self.amcar.DAMAGE = 1
	self.amcar.CLIP_AMMO_MAX = 20
	self.amcar.NR_CLIPS_MAX = 11
	self.amcar.AMMO_MAX = self.amcar.CLIP_AMMO_MAX * self.amcar.NR_CLIPS_MAX
	self.amcar.AMMO_PICKUP = self:_pickup_chance(self.amcar.AMMO_MAX, 2)
	self.amcar.FIRE_MODE = "auto"
	self.amcar.fire_mode_data = {fire_rate = 0.11}
	self.amcar.CAN_TOGGLE_FIREMODE = true
	self.amcar.auto = {fire_rate = 0.11}
	self.amcar.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.amcar.kick = {standing = self.new_m4.kick.standing}
	self.amcar.kick.crouching = self.amcar.kick.standing
	self.amcar.kick.steelsight = self.amcar.kick.standing
	self.amcar.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.amcar.crosshair.standing.offset = 0.16
	self.amcar.crosshair.standing.moving_offset = 0.8
	self.amcar.crosshair.standing.kick_offset = 0.6
	self.amcar.crosshair.crouching.offset = 0.08
	self.amcar.crosshair.crouching.moving_offset = 0.7
	self.amcar.crosshair.crouching.kick_offset = 0.4
	self.amcar.crosshair.steelsight.hidden = true
	self.amcar.crosshair.steelsight.offset = 0
	self.amcar.crosshair.steelsight.moving_offset = 0
	self.amcar.crosshair.steelsight.kick_offset = 0.1
	self.amcar.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.amcar.autohit = autohit_rifle_default
	self.amcar.aim_assist = aim_assist_rifle_default
	self.amcar.weapon_hold = "m4"
	self.amcar.animations = {
		reload = "reload",
		reload_not_empty = "reload_not_empty",
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.amcar.panic_suppression_chance = 0.2
	self.amcar.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 10,
		spread_moving = 8,
		recoil = 20,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 21
	}
	self.m16 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m16.sounds.fire = "m16_fire_single"
	self.m16.sounds.fire_single = "m16_fire_single"
	self.m16.sounds.fire_auto = "m16_fire"
	self.m16.sounds.stop_fire = "m16_stop"
	self.m16.sounds.dryfire = "primary_dryfire"
	self.m16.sounds.enter_steelsight = "m4_tighten"
	self.m16.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.m16.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.m16.timers = {
		reload_not_empty = 2.75,
		reload_empty = 3.73,
		unequip = 0.6,
		equip = 0.6
	}
	self.m16.name_id = "bm_w_m16"
	self.m16.desc_id = "bm_w_m16_desc"
	self.m16.description_id = "des_m4"
	self.m16.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.m16.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.m16.use_data = {selection_index = 2}
	self.m16.DAMAGE = 1
	self.m16.CLIP_AMMO_MAX = 30
	self.m16.NR_CLIPS_MAX = 3
	self.m16.AMMO_MAX = self.m16.CLIP_AMMO_MAX * self.m16.NR_CLIPS_MAX
	self.m16.AMMO_PICKUP = self:_pickup_chance(self.m16.AMMO_MAX, 1)
	self.m16.FIRE_MODE = "auto"
	self.m16.fire_mode_data = {fire_rate = 0.07}
	self.m16.CAN_TOGGLE_FIREMODE = true
	self.m16.auto = {fire_rate = 0.07}
	self.m16.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.m16.kick = {standing = self.new_m4.kick.standing}
	self.m16.kick.crouching = self.m16.kick.standing
	self.m16.kick.steelsight = self.m16.kick.standing
	self.m16.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m16.crosshair.standing.offset = 0.16
	self.m16.crosshair.standing.moving_offset = 0.8
	self.m16.crosshair.standing.kick_offset = 0.6
	self.m16.crosshair.crouching.offset = 0.08
	self.m16.crosshair.crouching.moving_offset = 0.7
	self.m16.crosshair.crouching.kick_offset = 0.4
	self.m16.crosshair.steelsight.hidden = true
	self.m16.crosshair.steelsight.offset = 0
	self.m16.crosshair.steelsight.moving_offset = 0
	self.m16.crosshair.steelsight.kick_offset = 0.1
	self.m16.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.m16.autohit = autohit_rifle_default
	self.m16.aim_assist = aim_assist_rifle_default
	self.m16.weapon_hold = "m4"
	self.m16.animations = {
		reload = "reload",
		reload_not_empty = "reload_not_empty",
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.m16.panic_suppression_chance = 0.2
	self.m16.stats = {
		zoom = 4,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 15,
		spread_moving = 13,
		recoil = 9,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 17
	}
	self.olympic = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.olympic.sounds.fire = "m4_olympic_fire_single"
	self.olympic.sounds.fire_single = "m4_olympic_fire_single"
	self.olympic.sounds.fire_auto = "m4_olympic_fire"
	self.olympic.sounds.stop_fire = "m4_olympic_stop"
	self.olympic.sounds.dryfire = "primary_dryfire"
	self.olympic.sounds.enter_steelsight = "m4_tighten"
	self.olympic.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.olympic.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.olympic.timers = {
		reload_not_empty = 2.16,
		reload_empty = 3.23,
		unequip = 0.6,
		equip = 0.5
	}
	self.olympic.name_id = "bm_w_olympic"
	self.olympic.desc_id = "bm_w_olympic_desc"
	self.olympic.description_id = "des_m4"
	self.olympic.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.olympic.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.olympic.use_data = {selection_index = 1}
	self.olympic.DAMAGE = 1
	self.olympic.CLIP_AMMO_MAX = 25
	self.olympic.NR_CLIPS_MAX = 6
	self.olympic.AMMO_MAX = self.olympic.CLIP_AMMO_MAX * self.olympic.NR_CLIPS_MAX
	self.olympic.AMMO_PICKUP = self:_pickup_chance(self.olympic.AMMO_MAX, 3)
	self.olympic.FIRE_MODE = "auto"
	self.olympic.fire_mode_data = {fire_rate = 0.088}
	self.olympic.CAN_TOGGLE_FIREMODE = true
	self.olympic.auto = {fire_rate = 0.088}
	self.olympic.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.olympic.kick = {standing = self.new_m4.kick.standing}
	self.olympic.kick.crouching = self.olympic.kick.standing
	self.olympic.kick.steelsight = self.olympic.kick.standing
	self.olympic.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.olympic.crosshair.standing.offset = 0.16
	self.olympic.crosshair.standing.moving_offset = 0.8
	self.olympic.crosshair.standing.kick_offset = 0.6
	self.olympic.crosshair.crouching.offset = 0.08
	self.olympic.crosshair.crouching.moving_offset = 0.7
	self.olympic.crosshair.crouching.kick_offset = 0.4
	self.olympic.crosshair.steelsight.hidden = true
	self.olympic.crosshair.steelsight.offset = 0
	self.olympic.crosshair.steelsight.moving_offset = 0
	self.olympic.crosshair.steelsight.kick_offset = 0.1
	self.olympic.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.olympic.autohit = autohit_smg_default
	self.olympic.aim_assist = aim_assist_smg_default
	self.olympic.weapon_hold = "m4"
	self.olympic.animations = {
		reload = "reload",
		reload_not_empty = "reload_not_empty",
		equip_id = "equip_mp5",
		recoil_steelsight = true
	}
	self.olympic.panic_suppression_chance = 0.2
	self.olympic.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 7,
		spread = 12,
		spread_moving = 11,
		recoil = 17,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 24
	}
	self.ak74 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.ak74.sounds.fire = "ak74_fire_single"
	self.ak74.sounds.fire_single = "ak74_fire_single"
	self.ak74.sounds.fire_auto = "ak74_fire"
	self.ak74.sounds.stop_fire = "ak74_stop"
	self.ak74.sounds.dryfire = "primary_dryfire"
	self.ak74.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.ak74.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.ak74.timers = {
		reload_not_empty = 2.8,
		reload_empty = 3.87,
		unequip = 0.5,
		equip = 0.5
	}
	self.ak74.name_id = "bm_w_ak74"
	self.ak74.desc_id = "bm_w_ak74_desc"
	self.ak74.description_id = "des_ak47"
	self.ak74.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.ak74.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ak74.use_data = {selection_index = 2}
	self.ak74.DAMAGE = 1
	self.ak74.CLIP_AMMO_MAX = 30
	self.ak74.NR_CLIPS_MAX = 5
	self.ak74.AMMO_MAX = self.ak74.CLIP_AMMO_MAX * self.ak74.NR_CLIPS_MAX
	self.ak74.AMMO_PICKUP = self:_pickup_chance(self.ak74.AMMO_MAX, 3)
	self.ak74.FIRE_MODE = "auto"
	self.ak74.fire_mode_data = {fire_rate = 0.092}
	self.ak74.CAN_TOGGLE_FIREMODE = true
	self.ak74.auto = {fire_rate = 0.092}
	self.ak74.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.ak74.kick = {standing = self.new_m4.kick.standing}
	self.ak74.kick.crouching = self.ak74.kick.standing
	self.ak74.kick.steelsight = self.ak74.kick.standing
	self.ak74.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.ak74.crosshair.standing.offset = 0.16
	self.ak74.crosshair.standing.moving_offset = 0.8
	self.ak74.crosshair.standing.kick_offset = 0.6
	self.ak74.crosshair.crouching.offset = 0.08
	self.ak74.crosshair.crouching.moving_offset = 0.7
	self.ak74.crosshair.crouching.kick_offset = 0.4
	self.ak74.crosshair.steelsight.hidden = true
	self.ak74.crosshair.steelsight.offset = 0
	self.ak74.crosshair.steelsight.moving_offset = 0
	self.ak74.crosshair.steelsight.kick_offset = 0.1
	self.ak74.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.ak74.autohit = autohit_rifle_default
	self.ak74.aim_assist = aim_assist_rifle_default
	self.ak74.weapon_hold = "ak47"
	self.ak74.animations = {
		equip_id = "equip_ak47",
		recoil_steelsight = true
	}
	self.ak74.challenges = {
		group = "rifle",
		weapon = "ak47"
	}
	self.ak74.panic_suppression_chance = 0.2
	self.ak74.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 13,
		spread_moving = 11,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 16
	}
	self.akm = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.akm.sounds.fire = "akm_fire_single"
	self.akm.sounds.fire_single = "akm_fire_single"
	self.akm.sounds.fire_auto = "akm_fire"
	self.akm.sounds.stop_fire = "akm_stop"
	self.akm.sounds.dryfire = "primary_dryfire"
	self.akm.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.akm.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.akm.timers = {
		reload_not_empty = 2.8,
		reload_empty = 3.87,
		unequip = 0.5,
		equip = 0.5
	}
	self.akm.name_id = "bm_w_akm"
	self.akm.desc_id = "bm_w_akm_desc"
	self.akm.description_id = "des_ak47"
	self.akm.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.akm.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.akm.use_data = {selection_index = 2}
	self.akm.DAMAGE = 1.25
	self.akm.CLIP_AMMO_MAX = 30
	self.akm.NR_CLIPS_MAX = 3
	self.akm.AMMO_MAX = self.akm.CLIP_AMMO_MAX * self.akm.NR_CLIPS_MAX
	self.akm.AMMO_PICKUP = self:_pickup_chance(self.akm.AMMO_MAX, 1)
	self.akm.FIRE_MODE = "auto"
	self.akm.fire_mode_data = {fire_rate = 0.107}
	self.akm.CAN_TOGGLE_FIREMODE = true
	self.akm.auto = {fire_rate = 0.107}
	self.akm.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.akm.kick = {standing = self.new_m4.kick.standing}
	self.akm.kick.crouching = self.akm.kick.standing
	self.akm.kick.steelsight = self.akm.kick.standing
	self.akm.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.akm.crosshair.standing.offset = 0.16
	self.akm.crosshair.standing.moving_offset = 0.8
	self.akm.crosshair.standing.kick_offset = 0.6
	self.akm.crosshair.crouching.offset = 0.08
	self.akm.crosshair.crouching.moving_offset = 0.7
	self.akm.crosshair.crouching.kick_offset = 0.4
	self.akm.crosshair.steelsight.hidden = true
	self.akm.crosshair.steelsight.offset = 0
	self.akm.crosshair.steelsight.moving_offset = 0
	self.akm.crosshair.steelsight.kick_offset = 0.1
	self.akm.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.akm.autohit = autohit_rifle_default
	self.akm.aim_assist = aim_assist_rifle_default
	self.akm.weapon_hold = "ak47"
	self.akm.animations = {
		equip_id = "equip_ak47",
		recoil_steelsight = true
	}
	self.akm.challenges = {
		group = "rifle",
		weapon = "ak47"
	}
	self.akm.panic_suppression_chance = 0.2
	self.akm.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 16,
		spread_moving = 14,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 13
	}
	self.akm_gold = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.akm_gold.sounds.fire = "akm_fire_single"
	self.akm_gold.sounds.fire_single = "akm_fire_single"
	self.akm_gold.sounds.fire_auto = "akm_fire"
	self.akm_gold.sounds.stop_fire = "akm_stop"
	self.akm_gold.sounds.dryfire = "primary_dryfire"
	self.akm_gold.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.akm_gold.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.akm_gold.timers = {
		reload_not_empty = 2.8,
		reload_empty = 3.87,
		unequip = 0.5,
		equip = 0.5
	}
	self.akm_gold.name_id = "bm_w_akm_gold"
	self.akm_gold.desc_id = "bm_w_akm_gold_desc"
	self.akm_gold.description_id = "des_ak47"
	self.akm_gold.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.akm_gold.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.akm_gold.use_data = {selection_index = 2}
	self.akm_gold.DAMAGE = 1.25
	self.akm_gold.CLIP_AMMO_MAX = 30
	self.akm_gold.NR_CLIPS_MAX = 3
	self.akm_gold.AMMO_MAX = self.akm_gold.CLIP_AMMO_MAX * self.akm_gold.NR_CLIPS_MAX
	self.akm_gold.AMMO_PICKUP = self:_pickup_chance(self.akm_gold.AMMO_MAX, 1)
	self.akm_gold.FIRE_MODE = "auto"
	self.akm_gold.fire_mode_data = {fire_rate = 0.107}
	self.akm_gold.CAN_TOGGLE_FIREMODE = true
	self.akm_gold.auto = {fire_rate = 0.107}
	self.akm_gold.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.akm_gold.kick = {standing = self.new_m4.kick.standing}
	self.akm_gold.kick.crouching = self.akm_gold.kick.standing
	self.akm_gold.kick.steelsight = self.akm_gold.kick.standing
	self.akm_gold.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.akm_gold.crosshair.standing.offset = 0.16
	self.akm_gold.crosshair.standing.moving_offset = 0.8
	self.akm_gold.crosshair.standing.kick_offset = 0.6
	self.akm_gold.crosshair.crouching.offset = 0.08
	self.akm_gold.crosshair.crouching.moving_offset = 0.7
	self.akm_gold.crosshair.crouching.kick_offset = 0.4
	self.akm_gold.crosshair.steelsight.hidden = true
	self.akm_gold.crosshair.steelsight.offset = 0
	self.akm_gold.crosshair.steelsight.moving_offset = 0
	self.akm_gold.crosshair.steelsight.kick_offset = 0.1
	self.akm_gold.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.akm_gold.autohit = autohit_rifle_default
	self.akm_gold.aim_assist = aim_assist_rifle_default
	self.akm_gold.weapon_hold = "ak47"
	self.akm_gold.animations = {
		equip_id = "equip_ak47",
		recoil_steelsight = true
	}
	self.akm_gold.global_value = "pd2_clan"
	self.akm_gold.challenges = {
		group = "rifle",
		weapon = "ak47"
	}
	self.akm_gold.panic_suppression_chance = 0.2
	self.akm_gold.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 16,
		spread_moving = 14,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 11
	}
	self.akmsu = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.akmsu.sounds.fire = "akmsu_fire_single"
	self.akmsu.sounds.fire_single = "akmsu_fire_single"
	self.akmsu.sounds.fire_auto = "akmsu_fire"
	self.akmsu.sounds.stop_fire = "akmsu_stop"
	self.akmsu.sounds.dryfire = "primary_dryfire"
	self.akmsu.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.akmsu.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.akmsu.timers = {
		reload_not_empty = 2.15,
		reload_empty = 3.9,
		unequip = 0.55,
		equip = 0.6
	}
	self.akmsu.name_id = "bm_w_akmsu"
	self.akmsu.desc_id = "bm_w_akmsu_desc"
	self.akmsu.description_id = "des_ak47"
	self.akmsu.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.akmsu.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.akmsu.use_data = {selection_index = 1}
	self.akmsu.DAMAGE = 1
	self.akmsu.CLIP_AMMO_MAX = 30
	self.akmsu.NR_CLIPS_MAX = 3
	self.akmsu.AMMO_MAX = self.akmsu.CLIP_AMMO_MAX * self.akmsu.NR_CLIPS_MAX
	self.akmsu.AMMO_PICKUP = self:_pickup_chance(self.akmsu.AMMO_MAX, 1)
	self.akmsu.FIRE_MODE = "auto"
	self.akmsu.fire_mode_data = {fire_rate = 0.073}
	self.akmsu.CAN_TOGGLE_FIREMODE = true
	self.akmsu.auto = {fire_rate = 0.073}
	self.akmsu.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.akmsu.kick = {standing = self.new_m4.kick.standing}
	self.akmsu.kick.crouching = self.akmsu.kick.standing
	self.akmsu.kick.steelsight = self.akmsu.kick.standing
	self.akmsu.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.akmsu.crosshair.standing.offset = 0.16
	self.akmsu.crosshair.standing.moving_offset = 0.8
	self.akmsu.crosshair.standing.kick_offset = 0.6
	self.akmsu.crosshair.crouching.offset = 0.08
	self.akmsu.crosshair.crouching.moving_offset = 0.7
	self.akmsu.crosshair.crouching.kick_offset = 0.4
	self.akmsu.crosshair.steelsight.hidden = true
	self.akmsu.crosshair.steelsight.offset = 0
	self.akmsu.crosshair.steelsight.moving_offset = 0
	self.akmsu.crosshair.steelsight.kick_offset = 0.1
	self.akmsu.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.akmsu.autohit = autohit_smg_default
	self.akmsu.aim_assist = aim_assist_smg_default
	self.akmsu.weapon_hold = "ak47"
	self.akmsu.animations = {
		equip_id = "equip_ak47",
		recoil_steelsight = true
	}
	self.akmsu.challenges = {
		group = "rifle",
		weapon = "ak47"
	}
	self.akmsu.panic_suppression_chance = 0.2
	self.akmsu.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 16,
		spread_moving = 16,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 21
	}
	self.saiga = {
		categories = {"shotgun"},
		has_magazine = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.saiga.sounds.fire = "saiga_play"
	self.saiga.sounds.dryfire = "shotgun_dryfire"
	self.saiga.sounds.stop_fire = "saiga_stop"
	self.saiga.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.saiga.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.saiga.timers = {
		reload_not_empty = 2.65,
		reload_empty = 3.95,
		unequip = 0.6,
		equip = 0.6
	}
	self.saiga.name_id = "bm_w_saiga"
	self.saiga.desc_id = "bm_w_saiga_desc"
	self.saiga.description_id = "des_saiga"
	self.saiga.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.saiga.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.saiga.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.saiga.DAMAGE = 6
	self.saiga.damage_near = 2000
	self.saiga.damage_far = 3000
	self.saiga.rays = 12
	self.saiga.CLIP_AMMO_MAX = 7
	self.saiga.NR_CLIPS_MAX = 10
	self.saiga.AMMO_MAX = self.saiga.CLIP_AMMO_MAX * self.saiga.NR_CLIPS_MAX
	self.saiga.AMMO_PICKUP = self:_pickup_chance(self.saiga.AMMO_MAX, 4)
	self.saiga.FIRE_MODE = "auto"
	self.saiga.fire_mode_data = {fire_rate = 0.18}
	self.saiga.CAN_TOGGLE_FIREMODE = true
	self.saiga.auto = {fire_rate = 0.18}
	self.saiga.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.saiga.kick = {standing = self.r870.kick.standing}
	self.saiga.kick.crouching = self.saiga.kick.standing
	self.saiga.kick.steelsight = self.r870.kick.steelsight
	self.saiga.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.saiga.crosshair.standing.offset = 0.7
	self.saiga.crosshair.standing.moving_offset = 0.7
	self.saiga.crosshair.standing.kick_offset = 0.8
	self.saiga.crosshair.crouching.offset = 0.65
	self.saiga.crosshair.crouching.moving_offset = 0.65
	self.saiga.crosshair.crouching.kick_offset = 0.75
	self.saiga.crosshair.steelsight.hidden = true
	self.saiga.crosshair.steelsight.offset = 0
	self.saiga.crosshair.steelsight.moving_offset = 0
	self.saiga.crosshair.steelsight.kick_offset = 0
	self.saiga.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 1.25
	}
	self.saiga.autohit = autohit_shotgun_default
	self.saiga.aim_assist = aim_assist_shotgun_default
	self.saiga.weapon_hold = "saiga"
	self.saiga.animations = {
		equip_id = "equip_saiga",
		recoil_steelsight = true
	}
	self.saiga.panic_suppression_chance = 0.2
	self.saiga.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 42,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 13
	}
	self.ak5 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.ak5.sounds.fire = "ak5_fire_single"
	self.ak5.sounds.fire_single = "ak5_fire_single"
	self.ak5.sounds.fire_auto = "ak5_fire"
	self.ak5.sounds.stop_fire = "ak5_stop"
	self.ak5.sounds.dryfire = "primary_dryfire"
	self.ak5.sounds.enter_steelsight = "m4_tighten"
	self.ak5.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.ak5.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.ak5.timers = {
		reload_not_empty = 2.05,
		reload_empty = 3.08,
		unequip = 0.6,
		equip = 0.45
	}
	self.ak5.name_id = "bm_w_ak5"
	self.ak5.desc_id = "bm_w_ak5_desc"
	self.ak5.description_id = "des_m4"
	self.ak5.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.ak5.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ak5.use_data = {selection_index = 2}
	self.ak5.DAMAGE = 1
	self.ak5.CLIP_AMMO_MAX = 30
	self.ak5.NR_CLIPS_MAX = 5
	self.ak5.AMMO_MAX = self.ak5.CLIP_AMMO_MAX * self.ak5.NR_CLIPS_MAX
	self.ak5.AMMO_PICKUP = self:_pickup_chance(self.ak5.AMMO_MAX, 3)
	self.ak5.FIRE_MODE = "auto"
	self.ak5.fire_mode_data = {fire_rate = 0.085}
	self.ak5.CAN_TOGGLE_FIREMODE = true
	self.ak5.auto = {fire_rate = 0.085}
	self.ak5.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.ak5.kick = {standing = self.new_m4.kick.standing}
	self.ak5.kick.crouching = self.ak5.kick.standing
	self.ak5.kick.steelsight = self.ak5.kick.standing
	self.ak5.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.ak5.crosshair.standing.offset = 0.16
	self.ak5.crosshair.standing.moving_offset = 0.8
	self.ak5.crosshair.standing.kick_offset = 0.6
	self.ak5.crosshair.crouching.offset = 0.08
	self.ak5.crosshair.crouching.moving_offset = 0.7
	self.ak5.crosshair.crouching.kick_offset = 0.4
	self.ak5.crosshair.steelsight.hidden = true
	self.ak5.crosshair.steelsight.offset = 0
	self.ak5.crosshair.steelsight.moving_offset = 0
	self.ak5.crosshair.steelsight.kick_offset = 0.1
	self.ak5.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.ak5.autohit = autohit_rifle_default
	self.ak5.aim_assist = aim_assist_rifle_default
	self.ak5.weapon_hold = "m4"
	self.ak5.animations = {
		reload_not_empty = "reload_not_empty",
		reload = "reload",
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.ak5.panic_suppression_chance = 0.2
	self.ak5.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 7,
		spread = 16,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 18
	}
	self.aug = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.aug.sounds.fire = "aug_fire_single"
	self.aug.sounds.fire_single = "aug_fire_single"
	self.aug.sounds.fire_auto = "aug_fire"
	self.aug.sounds.stop_fire = "aug_stop"
	self.aug.sounds.dryfire = "secondary_dryfire"
	self.aug.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.aug.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.aug.timers = {
		reload_not_empty = 2.5,
		reload_empty = 3.3,
		unequip = 0.5,
		equip = 0.5
	}
	self.aug.name_id = "bm_w_aug"
	self.aug.desc_id = "bm_w_aug_desc"
	self.aug.description_id = "des_aug"
	self.aug.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.aug.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.aug.use_data = {selection_index = 2}
	self.aug.DAMAGE = 1
	self.aug.CLIP_AMMO_MAX = 30
	self.aug.NR_CLIPS_MAX = 5
	self.aug.AMMO_MAX = self.aug.CLIP_AMMO_MAX * self.aug.NR_CLIPS_MAX
	self.aug.AMMO_PICKUP = self:_pickup_chance(self.aug.AMMO_MAX, 3)
	self.aug.FIRE_MODE = "auto"
	self.aug.fire_mode_data = {fire_rate = 0.08}
	self.aug.CAN_TOGGLE_FIREMODE = true
	self.aug.auto = {fire_rate = 0.08}
	self.aug.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.aug.kick = {standing = self.new_m4.kick.standing}
	self.aug.kick.crouching = self.aug.kick.standing
	self.aug.kick.steelsight = self.aug.kick.standing
	self.aug.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.aug.crosshair.standing.offset = 0.5
	self.aug.crosshair.standing.moving_offset = 0.6
	self.aug.crosshair.standing.kick_offset = 0.6
	self.aug.crosshair.crouching.offset = 0.4
	self.aug.crosshair.crouching.moving_offset = 0.5
	self.aug.crosshair.crouching.kick_offset = 0.4
	self.aug.crosshair.steelsight.hidden = true
	self.aug.crosshair.steelsight.offset = 0
	self.aug.crosshair.steelsight.moving_offset = 0
	self.aug.crosshair.steelsight.kick_offset = 0
	self.aug.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.aug.autohit = autohit_pistol_default
	self.aug.aim_assist = aim_assist_pistol_default
	self.aug.animations = {
		equip_id = "equip_mp5_rifle",
		recoil_steelsight = true
	}
	self.aug.panic_suppression_chance = 0.2
	self.aug.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 7,
		spread = 17,
		spread_moving = 15,
		recoil = 11,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 20
	}
	self.g36 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.g36.sounds.fire = "g36_fire_single"
	self.g36.sounds.fire_single = "g36_fire_single"
	self.g36.sounds.fire_auto = "g36_fire"
	self.g36.sounds.stop_fire = "g36_stop"
	self.g36.sounds.dryfire = "primary_dryfire"
	self.g36.sounds.enter_steelsight = "m4_tighten"
	self.g36.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.g36.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.g36.timers = {
		reload_not_empty = 2.85,
		reload_empty = 3.85,
		unequip = 0.6,
		equip = 0.6
	}
	self.g36.name_id = "bm_w_g36"
	self.g36.desc_id = "bm_w_g36_desc"
	self.g36.description_id = "des_m4"
	self.g36.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.g36.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.g36.use_data = {selection_index = 2}
	self.g36.DAMAGE = 1
	self.g36.CLIP_AMMO_MAX = 30
	self.g36.NR_CLIPS_MAX = 8
	self.g36.AMMO_MAX = self.g36.CLIP_AMMO_MAX * self.g36.NR_CLIPS_MAX
	self.g36.AMMO_PICKUP = self:_pickup_chance(self.g36.AMMO_MAX, 2)
	self.g36.FIRE_MODE = "auto"
	self.g36.fire_mode_data = {fire_rate = 0.085}
	self.g36.CAN_TOGGLE_FIREMODE = true
	self.g36.auto = {fire_rate = 0.085}
	self.g36.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.g36.kick = {standing = self.new_m4.kick.standing}
	self.g36.kick.crouching = self.g36.kick.standing
	self.g36.kick.steelsight = self.g36.kick.standing
	self.g36.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.g36.crosshair.standing.offset = 0.16
	self.g36.crosshair.standing.moving_offset = 0.8
	self.g36.crosshair.standing.kick_offset = 0.6
	self.g36.crosshair.crouching.offset = 0.08
	self.g36.crosshair.crouching.moving_offset = 0.7
	self.g36.crosshair.crouching.kick_offset = 0.4
	self.g36.crosshair.steelsight.hidden = true
	self.g36.crosshair.steelsight.offset = 0
	self.g36.crosshair.steelsight.moving_offset = 0
	self.g36.crosshair.steelsight.kick_offset = 0.1
	self.g36.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.g36.autohit = autohit_rifle_default
	self.g36.aim_assist = aim_assist_rifle_default
	self.g36.animations = {
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.g36.panic_suppression_chance = 0.2
	self.g36.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 11,
		spread_moving = 9,
		recoil = 17,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 11,
		concealment = 19
	}
	self.p90 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.p90.sounds.fire = "p90_fire_single"
	self.p90.sounds.fire_single = "p90_fire_single"
	self.p90.sounds.fire_auto = "p90_fire"
	self.p90.sounds.stop_fire = "p90_stop"
	self.p90.sounds.dryfire = "secondary_dryfire"
	self.p90.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.p90.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.p90.timers = {
		reload_not_empty = 2.55,
		reload_empty = 3.4,
		unequip = 0.68,
		equip = 0.65
	}
	self.p90.name_id = "bm_w_p90"
	self.p90.desc_id = "bm_w_p90_desc"
	self.p90.description_id = "des_p90"
	self.p90.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.p90.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.p90.use_data = {selection_index = 1}
	self.p90.DAMAGE = 1
	self.p90.CLIP_AMMO_MAX = 50
	self.p90.NR_CLIPS_MAX = 3
	self.p90.AMMO_MAX = self.p90.CLIP_AMMO_MAX * self.p90.NR_CLIPS_MAX
	self.p90.AMMO_PICKUP = self:_pickup_chance(self.p90.AMMO_MAX, 3)
	self.p90.FIRE_MODE = "auto"
	self.p90.fire_mode_data = {fire_rate = 0.066}
	self.p90.CAN_TOGGLE_FIREMODE = true
	self.p90.auto = {fire_rate = 0.066}
	self.p90.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.p90.kick = {standing = self.new_m4.kick.standing}
	self.p90.kick.crouching = self.p90.kick.standing
	self.p90.kick.steelsight = self.p90.kick.standing
	self.p90.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.p90.crosshair.standing.offset = 0.4
	self.p90.crosshair.standing.moving_offset = 0.7
	self.p90.crosshair.standing.kick_offset = 0.6
	self.p90.crosshair.crouching.offset = 0.3
	self.p90.crosshair.crouching.moving_offset = 0.6
	self.p90.crosshair.crouching.kick_offset = 0.4
	self.p90.crosshair.steelsight.hidden = true
	self.p90.crosshair.steelsight.offset = 0
	self.p90.crosshair.steelsight.moving_offset = 0
	self.p90.crosshair.steelsight.kick_offset = 0.4
	self.p90.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.p90.autohit = autohit_smg_default
	self.p90.aim_assist = aim_assist_smg_default
	self.p90.animations = {
		equip_id = "equip_mac11_rifle",
		recoil_steelsight = true
	}
	self.p90.panic_suppression_chance = 0.2
	self.p90.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 25
	}
	self.new_m14 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.new_m14.sounds.fire = "m14_fire"
	self.new_m14.sounds.fire_single = "m14_fire"
	self.new_m14.sounds.fire_auto = "m14_fire_loop"
	self.new_m14.sounds.stop_fire = "m14_stop"
	self.new_m14.sounds.dryfire = "primary_dryfire"
	self.new_m14.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.new_m14.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.new_m14.timers = {
		reload_not_empty = 2.65,
		reload_empty = 3.15,
		unequip = 0.6,
		equip = 0.55
	}
	self.new_m14.name_id = "bm_w_m14"
	self.new_m14.desc_id = "bm_w_m14_desc"
	self.new_m14.description_id = "des_m14"
	self.new_m14.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.new_m14.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.new_m14.use_data = {selection_index = 2}
	self.new_m14.DAMAGE = 2
	self.new_m14.CLIP_AMMO_MAX = 10
	self.new_m14.NR_CLIPS_MAX = 7
	self.new_m14.AMMO_MAX = self.new_m14.CLIP_AMMO_MAX * self.new_m14.NR_CLIPS_MAX
	self.new_m14.AMMO_PICKUP = self:_pickup_chance(self.new_m14.AMMO_MAX, 1)
	self.new_m14.FIRE_MODE = "single"
	self.new_m14.fire_mode_data = {fire_rate = 0.085}
	self.new_m14.CAN_TOGGLE_FIREMODE = true
	self.new_m14.single = {fire_rate = 0.085}
	self.new_m14.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.new_m14.kick = {standing = self.new_m4.kick.standing}
	self.new_m14.kick.crouching = self.new_m14.kick.standing
	self.new_m14.kick.steelsight = self.new_m14.kick.standing
	self.new_m14.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.new_m14.crosshair.standing.offset = 0.16
	self.new_m14.crosshair.standing.moving_offset = 0.8
	self.new_m14.crosshair.standing.kick_offset = 0.6
	self.new_m14.crosshair.crouching.offset = 0.08
	self.new_m14.crosshair.crouching.moving_offset = 0.7
	self.new_m14.crosshair.crouching.kick_offset = 0.4
	self.new_m14.crosshair.steelsight.hidden = true
	self.new_m14.crosshair.steelsight.offset = 0
	self.new_m14.crosshair.steelsight.moving_offset = 0
	self.new_m14.crosshair.steelsight.kick_offset = 0.1
	self.new_m14.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.new_m14.autohit = autohit_rifle_default
	self.new_m14.aim_assist = aim_assist_rifle_default
	self.new_m14.animations = {
		fire = "recoil",
		equip_id = "equip_m14_rifle",
		recoil_steelsight = true
	}
	self.new_m14.panic_suppression_chance = 0.2
	self.new_m14.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 7,
		spread = 22,
		spread_moving = 20,
		recoil = 10,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 8
	}
	self.deagle = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.deagle.sounds.fire = "deagle_fire"
	self.deagle.sounds.dryfire = "secondary_dryfire"
	self.deagle.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.deagle.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.deagle.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.deagle.FIRE_MODE = "single"
	self.deagle.fire_mode_data = {fire_rate = 0.25}
	self.deagle.single = {fire_rate = 0.25}
	self.deagle.timers = {
		reload_not_empty = 1.85,
		reload_empty = 3.1,
		unequip = 0.5,
		equip = 0.35
	}
	self.deagle.name_id = "bm_w_deagle"
	self.deagle.desc_id = "bm_w_deagle_desc"
	self.deagle.description_id = "des_deagle"
	self.deagle.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.deagle.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.deagle.use_data = {selection_index = 1}
	self.deagle.DAMAGE = 2
	self.deagle.CLIP_AMMO_MAX = 10
	self.deagle.NR_CLIPS_MAX = 5
	self.deagle.AMMO_MAX = self.deagle.CLIP_AMMO_MAX * self.deagle.NR_CLIPS_MAX
	self.deagle.AMMO_PICKUP = self:_pickup_chance(self.deagle.AMMO_MAX, 1)
	self.deagle.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.deagle.kick = {standing = self.glock_17.kick.standing}
	self.deagle.kick.crouching = self.deagle.kick.standing
	self.deagle.kick.steelsight = self.deagle.kick.standing
	self.deagle.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.deagle.crosshair.standing.offset = 0.2
	self.deagle.crosshair.standing.moving_offset = 0.6
	self.deagle.crosshair.standing.kick_offset = 0.4
	self.deagle.crosshair.crouching.offset = 0.1
	self.deagle.crosshair.crouching.moving_offset = 0.6
	self.deagle.crosshair.crouching.kick_offset = 0.3
	self.deagle.crosshair.steelsight.hidden = true
	self.deagle.crosshair.steelsight.offset = 0
	self.deagle.crosshair.steelsight.moving_offset = 0
	self.deagle.crosshair.steelsight.kick_offset = 0.1
	self.deagle.shake = {
		fire_multiplier = -1,
		fire_steelsight_multiplier = -1
	}
	self.deagle.autohit = autohit_pistol_default
	self.deagle.aim_assist = aim_assist_pistol_default
	self.deagle.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.deagle.panic_suppression_chance = 0.2
	self.deagle.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 120,
		alert_size = 7,
		spread = 20,
		spread_moving = 20,
		recoil = 8,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 28
	}
	self.new_mp5 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.new_mp5.sounds.fire = "mp5_fire_single"
	self.new_mp5.sounds.fire_single = "mp5_fire_single"
	self.new_mp5.sounds.fire_auto = "mp5_fire"
	self.new_mp5.sounds.stop_fire = "mp5_stop"
	self.new_mp5.sounds.dryfire = "secondary_dryfire"
	self.new_mp5.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.new_mp5.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.new_mp5.timers = {
		reload_not_empty = 2.4,
		reload_empty = 3.6,
		unequip = 0.6,
		equip = 0.6
	}
	self.new_mp5.name_id = "bm_w_mp5"
	self.new_mp5.desc_id = "bm_w_mp5_desc"
	self.new_mp5.description_id = "des_mp5"
	self.new_mp5.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.new_mp5.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.new_mp5.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.new_mp5.use_data = {selection_index = 1}
	self.new_mp5.DAMAGE = 1
	self.new_mp5.CLIP_AMMO_MAX = 30
	self.new_mp5.NR_CLIPS_MAX = 7
	self.new_mp5.AMMO_MAX = self.new_mp5.CLIP_AMMO_MAX * self.new_mp5.NR_CLIPS_MAX
	self.new_mp5.AMMO_PICKUP = self:_pickup_chance(self.new_mp5.AMMO_MAX, 2)
	self.new_mp5.FIRE_MODE = "auto"
	self.new_mp5.fire_mode_data = {fire_rate = 0.08}
	self.new_mp5.CAN_TOGGLE_FIREMODE = true
	self.new_mp5.auto = {fire_rate = 0.08}
	self.new_mp5.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.new_mp5.kick = {standing = self.new_m4.kick.standing}
	self.new_mp5.kick.crouching = self.new_mp5.kick.standing
	self.new_mp5.kick.steelsight = self.new_mp5.kick.standing
	self.new_mp5.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.new_mp5.crosshair.standing.offset = 0.5
	self.new_mp5.crosshair.standing.moving_offset = 0.6
	self.new_mp5.crosshair.standing.kick_offset = 0.7
	self.new_mp5.crosshair.crouching.offset = 0.4
	self.new_mp5.crosshair.crouching.moving_offset = 0.5
	self.new_mp5.crosshair.crouching.kick_offset = 0.6
	self.new_mp5.crosshair.steelsight.hidden = true
	self.new_mp5.crosshair.steelsight.offset = 0
	self.new_mp5.crosshair.steelsight.moving_offset = 0
	self.new_mp5.crosshair.steelsight.kick_offset = 0
	self.new_mp5.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 0.5
	}
	self.new_mp5.autohit = autohit_smg_default
	self.new_mp5.aim_assist = aim_assist_smg_default
	self.new_mp5.weapon_hold = "mp5"
	self.new_mp5.animations = {
		equip_id = "equip_mp5_rifle",
		recoil_steelsight = true
	}
	self.new_mp5.panic_suppression_chance = 0.2
	self.new_mp5.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 20,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 17,
		concealment = 23
	}
	self.colt_1911 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.colt_1911.sounds.fire = "c45_fire"
	self.colt_1911.sounds.dryfire = "secondary_dryfire"
	self.colt_1911.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.colt_1911.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.colt_1911.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.colt_1911.FIRE_MODE = "single"
	self.colt_1911.fire_mode_data = {fire_rate = 0.166}
	self.colt_1911.single = {fire_rate = 0.166}
	self.colt_1911.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.colt_1911.name_id = "bm_w_colt_1911"
	self.colt_1911.desc_id = "bm_w_colt_1911_desc"
	self.colt_1911.description_id = "des_colt_1911"
	self.colt_1911.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.colt_1911.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.colt_1911.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.colt_1911.use_data = {selection_index = 1}
	self.colt_1911.DAMAGE = 1
	self.colt_1911.CLIP_AMMO_MAX = 10
	self.colt_1911.NR_CLIPS_MAX = 9
	self.colt_1911.AMMO_MAX = self.colt_1911.CLIP_AMMO_MAX * self.colt_1911.NR_CLIPS_MAX
	self.colt_1911.AMMO_PICKUP = self:_pickup_chance(self.colt_1911.AMMO_MAX, 1)
	self.colt_1911.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.colt_1911.kick = {standing = self.glock_17.kick.standing}
	self.colt_1911.kick.crouching = self.colt_1911.kick.standing
	self.colt_1911.kick.steelsight = self.colt_1911.kick.standing
	self.colt_1911.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.colt_1911.crosshair.standing.offset = 0.2
	self.colt_1911.crosshair.standing.moving_offset = 0.6
	self.colt_1911.crosshair.standing.kick_offset = 0.4
	self.colt_1911.crosshair.crouching.offset = 0.1
	self.colt_1911.crosshair.crouching.moving_offset = 0.6
	self.colt_1911.crosshair.crouching.kick_offset = 0.3
	self.colt_1911.crosshair.steelsight.hidden = true
	self.colt_1911.crosshair.steelsight.offset = 0
	self.colt_1911.crosshair.steelsight.moving_offset = 0
	self.colt_1911.crosshair.steelsight.kick_offset = 0.1
	self.colt_1911.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.colt_1911.autohit = autohit_pistol_default
	self.colt_1911.aim_assist = aim_assist_pistol_default
	self.colt_1911.animations = {
		fire = "recoil",
		reload = "reload",
		reload_not_empty = "reload_not_empty",
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.colt_1911.panic_suppression_chance = 0.2
	self.colt_1911.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 29
	}
	self.mac10 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.mac10.sounds.fire = "mac10_fire_single"
	self.mac10.sounds.fire_single = "mac10_fire_single"
	self.mac10.sounds.fire_auto = "mac10_fire"
	self.mac10.sounds.stop_fire = "mac10_stop"
	self.mac10.sounds.dryfire = "secondary_dryfire"
	self.mac10.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.mac10.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.mac10.timers = {
		reload_not_empty = 2,
		reload_empty = 2.7,
		unequip = 0.5,
		equip = 0.5
	}
	self.mac10.name_id = "bm_w_mac10"
	self.mac10.desc_id = "bm_w_mac10_desc"
	self.mac10.description_id = "des_mac10"
	self.mac10.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.mac10.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.mac10.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.mac10.use_data = {selection_index = 1}
	self.mac10.DAMAGE = 1
	self.mac10.CLIP_AMMO_MAX = 40
	self.mac10.NR_CLIPS_MAX = 4
	self.mac10.AMMO_MAX = self.mac10.CLIP_AMMO_MAX * self.mac10.NR_CLIPS_MAX
	self.mac10.AMMO_PICKUP = self:_pickup_chance(self.mac10.AMMO_MAX, 3)
	self.mac10.FIRE_MODE = "auto"
	self.mac10.fire_mode_data = {fire_rate = 0.06}
	self.mac10.CAN_TOGGLE_FIREMODE = true
	self.mac10.auto = {fire_rate = 0.06}
	self.mac10.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.mac10.kick = {standing = self.mp9.kick.standing}
	self.mac10.kick.crouching = self.mac10.kick.standing
	self.mac10.kick.steelsight = self.mac10.kick.standing
	self.mac10.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.mac10.crosshair.standing.offset = 0.4
	self.mac10.crosshair.standing.moving_offset = 0.7
	self.mac10.crosshair.standing.kick_offset = 0.6
	self.mac10.crosshair.crouching.offset = 0.3
	self.mac10.crosshair.crouching.moving_offset = 0.6
	self.mac10.crosshair.crouching.kick_offset = 0.4
	self.mac10.crosshair.steelsight.hidden = true
	self.mac10.crosshair.steelsight.offset = 0
	self.mac10.crosshair.steelsight.moving_offset = 0
	self.mac10.crosshair.steelsight.kick_offset = 0.4
	self.mac10.shake = {
		fire_multiplier = 0.65,
		fire_steelsight_multiplier = -1
	}
	self.mac10.autohit = autohit_smg_default
	self.mac10.aim_assist = aim_assist_smg_default
	self.mac10.weapon_hold = "mac11"
	self.mac10.animations = {
		equip_id = "equip_mac11_rifle",
		recoil_steelsight = true
	}
	self.mac10.panic_suppression_chance = 0.2
	self.mac10.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 13,
		spread_moving = 13,
		recoil = 17,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 27
	}
	self.serbu = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.serbu.sounds.fire = "serbu_fire"
	self.serbu.sounds.dryfire = "shotgun_dryfire"
	self.serbu.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.serbu.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.serbu.timers = {
		unequip = 0.7,
		equip = 0.6
	}
	self.serbu.name_id = "bm_w_serbu"
	self.serbu.desc_id = "bm_w_serbu_desc"
	self.serbu.description_id = "des_r870"
	self.serbu.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.serbu.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.serbu.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.serbu.DAMAGE = 6
	self.serbu.damage_near = 2000
	self.serbu.damage_far = 3000
	self.serbu.rays = 12
	self.serbu.CLIP_AMMO_MAX = 6
	self.serbu.NR_CLIPS_MAX = 7
	self.serbu.AMMO_MAX = self.serbu.CLIP_AMMO_MAX * self.serbu.NR_CLIPS_MAX
	self.serbu.AMMO_PICKUP = self:_pickup_chance(self.serbu.AMMO_MAX, 1)
	self.serbu.FIRE_MODE = "single"
	self.serbu.fire_mode_data = {fire_rate = 0.375}
	self.serbu.single = {fire_rate = 0.375}
	self.serbu.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.serbu.kick = {standing = self.r870.kick.standing}
	self.serbu.kick.crouching = self.serbu.kick.standing
	self.serbu.kick.steelsight = self.serbu.kick.standing
	self.serbu.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.serbu.crosshair.standing.offset = 0.7
	self.serbu.crosshair.standing.moving_offset = 0.7
	self.serbu.crosshair.standing.kick_offset = 0.8
	self.serbu.crosshair.crouching.offset = 0.65
	self.serbu.crosshair.crouching.moving_offset = 0.65
	self.serbu.crosshair.crouching.kick_offset = 0.75
	self.serbu.crosshair.steelsight.hidden = true
	self.serbu.crosshair.steelsight.offset = 0
	self.serbu.crosshair.steelsight.moving_offset = 0
	self.serbu.crosshair.steelsight.kick_offset = 0
	self.serbu.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.serbu.autohit = autohit_shotgun_default
	self.serbu.aim_assist = aim_assist_shotgun_default
	self.serbu.weapon_hold = "r870_shotgun"
	self.serbu.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.serbu.panic_suppression_chance = 0.2
	self.serbu.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 90,
		alert_size = 7,
		spread = 13,
		spread_moving = 10,
		recoil = 10,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 23
	}
	self.huntsman = {
		categories = {"shotgun"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.huntsman.sounds.fire = "huntsman_fire"
	self.huntsman.sounds.dryfire = "shotgun_dryfire"
	self.huntsman.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.huntsman.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.huntsman.timers = {reload_not_empty = 2.5}
	self.huntsman.timers.reload_empty = self.huntsman.timers.reload_not_empty
	self.huntsman.timers.unequip = 0.6
	self.huntsman.timers.equip = 0.6
	self.huntsman.name_id = "bm_w_huntsman"
	self.huntsman.desc_id = "bm_w_huntsman_desc"
	self.huntsman.description_id = "des_huntsman"
	self.huntsman.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.huntsman.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.huntsman.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.huntsman.DAMAGE = 6
	self.huntsman.damage_near = 2000
	self.huntsman.damage_far = 3000
	self.huntsman.rays = 12
	self.huntsman.CLIP_AMMO_MAX = 2
	self.huntsman.NR_CLIPS_MAX = 16
	self.huntsman.AMMO_MAX = self.huntsman.CLIP_AMMO_MAX * self.huntsman.NR_CLIPS_MAX
	self.huntsman.AMMO_PICKUP = self:_pickup_chance(self.huntsman.AMMO_MAX, 1)
	self.huntsman.FIRE_MODE = "single"
	self.huntsman.fire_mode_data = {fire_rate = 0.12}
	self.huntsman.single = {fire_rate = 0.12}
	self.huntsman.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.huntsman.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.huntsman.kick.crouching = self.huntsman.kick.standing
	self.huntsman.kick.steelsight = self.huntsman.kick.standing
	self.huntsman.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.huntsman.crosshair.standing.offset = 0.16
	self.huntsman.crosshair.standing.moving_offset = 0.8
	self.huntsman.crosshair.standing.kick_offset = 0.6
	self.huntsman.crosshair.standing.hidden = true
	self.huntsman.crosshair.crouching.offset = 0.08
	self.huntsman.crosshair.crouching.moving_offset = 0.7
	self.huntsman.crosshair.crouching.kick_offset = 0.4
	self.huntsman.crosshair.crouching.hidden = true
	self.huntsman.crosshair.steelsight.hidden = true
	self.huntsman.crosshair.steelsight.offset = 0
	self.huntsman.crosshair.steelsight.moving_offset = 0
	self.huntsman.crosshair.steelsight.kick_offset = 0.1
	self.huntsman.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.huntsman.autohit = autohit_shotgun_default
	self.huntsman.aim_assist = aim_assist_shotgun_default
	self.huntsman.animations = {
		equip_id = "equip_huntsman",
		recoil_steelsight = true
	}
	self.huntsman.panic_suppression_chance = 0.2
	self.huntsman.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 155,
		alert_size = 7,
		spread = 16,
		spread_moving = 16,
		recoil = 10,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 7
	}
	self.huntsman.stats_modifiers = {damage = 1}
	self.b92fs = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.b92fs.sounds.fire = "beretta_fire"
	self.b92fs.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.b92fs.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.b92fs.sounds.dryfire = "secondary_dryfire"
	self.b92fs.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.b92fs.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.b92fs.name_id = "bm_w_b92fs"
	self.b92fs.desc_id = "bm_w_b92fs_desc"
	self.b92fs.description_id = "des_b92fs"
	self.b92fs.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.b92fs.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.b92fs.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.b92fs.use_data = {selection_index = 1}
	self.b92fs.DAMAGE = 1
	self.b92fs.CLIP_AMMO_MAX = 14
	self.b92fs.NR_CLIPS_MAX = 11
	self.b92fs.AMMO_MAX = self.b92fs.CLIP_AMMO_MAX * self.b92fs.NR_CLIPS_MAX
	self.b92fs.AMMO_PICKUP = self:_pickup_chance(self.b92fs.AMMO_MAX, 1)
	self.b92fs.FIRE_MODE = "single"
	self.b92fs.fire_mode_data = {fire_rate = 0.125}
	self.b92fs.single = {fire_rate = 0.125}
	self.b92fs.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.b92fs.kick = {standing = self.glock_17.kick.standing}
	self.b92fs.kick.crouching = self.b92fs.kick.standing
	self.b92fs.kick.steelsight = self.b92fs.kick.standing
	self.b92fs.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.b92fs.crosshair.standing.offset = 0.2
	self.b92fs.crosshair.standing.moving_offset = 0.6
	self.b92fs.crosshair.standing.kick_offset = 0.4
	self.b92fs.crosshair.crouching.offset = 0.1
	self.b92fs.crosshair.crouching.moving_offset = 0.6
	self.b92fs.crosshair.crouching.kick_offset = 0.3
	self.b92fs.crosshair.steelsight.hidden = true
	self.b92fs.crosshair.steelsight.offset = 0
	self.b92fs.crosshair.steelsight.moving_offset = 0
	self.b92fs.crosshair.steelsight.kick_offset = 0.1
	self.b92fs.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.b92fs.autohit = autohit_pistol_default
	self.b92fs.aim_assist = aim_assist_pistol_default
	self.b92fs.weapon_hold = "glock"
	self.b92fs.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.b92fs.panic_suppression_chance = 0.2
	self.b92fs.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 7,
		spread = 15,
		spread_moving = 15,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 17,
		concealment = 30
	}
	self.new_raging_bull = {
		categories = {
			"pistol",
			"revolver"
		},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.new_raging_bull.sounds.fire = "rbull_fire"
	self.new_raging_bull.sounds.dryfire = "secondary_dryfire"
	self.new_raging_bull.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.new_raging_bull.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.new_raging_bull.timers = {
		reload_not_empty = 2.25,
		reload_empty = 2.25,
		unequip = 0.5,
		equip = 0.45
	}
	self.new_raging_bull.FIRE_MODE = "single"
	self.new_raging_bull.fire_mode_data = {fire_rate = 0.166}
	self.new_raging_bull.single = {fire_rate = 0.166}
	self.new_raging_bull.name_id = "bm_w_raging_bull"
	self.new_raging_bull.desc_id = "bm_w_raging_bull_desc"
	self.new_raging_bull.description_id = "des_new_raging_bull"
	self.new_raging_bull.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.new_raging_bull.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.new_raging_bull.use_data = {selection_index = 1}
	self.new_raging_bull.DAMAGE = 2
	self.new_raging_bull.CLIP_AMMO_MAX = 6
	self.new_raging_bull.NR_CLIPS_MAX = 9
	self.new_raging_bull.AMMO_MAX = self.new_raging_bull.CLIP_AMMO_MAX * self.new_raging_bull.NR_CLIPS_MAX
	self.new_raging_bull.AMMO_PICKUP = self:_pickup_chance(self.new_raging_bull.AMMO_MAX, 1)
	self.new_raging_bull.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.new_raging_bull.kick = {standing = self.glock_17.kick.standing}
	self.new_raging_bull.kick.crouching = self.new_raging_bull.kick.standing
	self.new_raging_bull.kick.steelsight = self.new_raging_bull.kick.standing
	self.new_raging_bull.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.new_raging_bull.crosshair.standing.offset = 0.2
	self.new_raging_bull.crosshair.standing.moving_offset = 0.6
	self.new_raging_bull.crosshair.standing.kick_offset = 0.4
	self.new_raging_bull.crosshair.crouching.offset = 0.1
	self.new_raging_bull.crosshair.crouching.moving_offset = 0.6
	self.new_raging_bull.crosshair.crouching.kick_offset = 0.3
	self.new_raging_bull.crosshair.steelsight.hidden = true
	self.new_raging_bull.crosshair.steelsight.offset = 0
	self.new_raging_bull.crosshair.steelsight.moving_offset = 0
	self.new_raging_bull.crosshair.steelsight.kick_offset = 0.1
	self.new_raging_bull.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.new_raging_bull.autohit = autohit_pistol_default
	self.new_raging_bull.aim_assist = aim_assist_pistol_default
	self.new_raging_bull.weapon_hold = "raging_bull"
	self.new_raging_bull.animations = {
		equip_id = "equip_raging_bull",
		recoil_steelsight = true
	}
	self.new_raging_bull.panic_suppression_chance = 0.2
	self.new_raging_bull.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 175,
		alert_size = 7,
		spread = 20,
		spread_moving = 5,
		recoil = 2,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 26
	}
	self.saw = {
		categories = {"saw"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.saw.sounds.fire = "Play_saw_handheld_start"
	self.saw.sounds.stop_fire = "Play_saw_handheld_end"
	self.saw.sounds.dryfire = "secondary_dryfire"
	self.saw.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.saw.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.saw.timers = {
		reload_not_empty = 3.75,
		reload_empty = 3.75,
		unequip = 0.8,
		equip = 0.8
	}
	self.saw.name_id = "bm_w_saw"
	self.saw.desc_id = "bm_w_saw_desc"
	self.saw.description_id = "des_mp5"
	self.saw.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.saw.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.saw.use_data = {selection_index = 2}
	self.saw.DAMAGE = 0.2
	self.saw.CLIP_AMMO_MAX = 150
	self.saw.NR_CLIPS_MAX = 2
	self.saw.AMMO_MAX = self.saw.CLIP_AMMO_MAX * self.saw.NR_CLIPS_MAX
	self.saw.AMMO_PICKUP = {
		0,
		0
	}
	self.saw.FIRE_MODE = "auto"
	self.saw.fire_mode_data = {fire_rate = 0.15}
	self.saw.auto = {fire_rate = 0.15}
	self.saw.spread = {
		standing = 1,
		crouching = 0.71,
		steelsight = 0.48,
		moving_standing = 1.28,
		moving_crouching = 1.52,
		moving_steelsight = 0.48
	}
	self.saw.kick = {
		standing = {
			1,
			-1,
			-1,
			1
		},
		crouching = {
			1,
			-1,
			-1,
			1
		},
		steelsight = {
			0.725,
			-0.725,
			-0.725,
			0.725
		}
	}
	self.saw.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.saw.crosshair.standing.offset = 0.5
	self.saw.crosshair.standing.moving_offset = 0.6
	self.saw.crosshair.standing.kick_offset = 0.7
	self.saw.crosshair.crouching.offset = 0.4
	self.saw.crosshair.crouching.moving_offset = 0.5
	self.saw.crosshair.crouching.kick_offset = 0.6
	self.saw.crosshair.steelsight.hidden = true
	self.saw.crosshair.steelsight.offset = 0
	self.saw.crosshair.steelsight.moving_offset = 0
	self.saw.crosshair.steelsight.kick_offset = 0
	self.saw.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.saw.autohit = autohit_pistol_default
	self.saw.aim_assist = aim_assist_pistol_default
	self.saw.weapon_hold = "saw"
	self.saw.animations = {
		equip_id = "equip_saw",
		recoil_steelsight = true
	}
	self.saw.panic_suppression_chance = 0.2
	self.saw.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 23,
		alert_size = 9,
		spread = 3,
		spread_moving = 7,
		value = 1,
		recoil = 7,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 16
	}
	self.saw.hit_alert_size_increase = 4
	self.saw_secondary = deep_clone(self.saw)
	self.saw_secondary.parent_weapon_id = "saw"
	self.saw_secondary.use_data.selection_index = 1
	self.saw_secondary.animations.reload_name_id = "saw"
	self.saw_secondary.use_stance = "saw"
	self.saw_secondary.texture_name = "saw"
	self.saw_secondary.weapon_hold = "saw"
	self.usp = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.usp.sounds.fire = "usp45_fire"
	self.usp.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.usp.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.usp.sounds.dryfire = "secondary_dryfire"
	self.usp.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.usp.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.2,
		unequip = 0.5,
		equip = 0.35
	}
	self.usp.name_id = "bm_w_usp"
	self.usp.desc_id = "bm_w_usp_desc"
	self.usp.description_id = "des_usp"
	self.usp.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.usp.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.usp.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.usp.use_data = {selection_index = 1}
	self.usp.DAMAGE = 1
	self.usp.FIRE_MODE = "single"
	self.usp.fire_mode_data = {fire_rate = 0.166}
	self.usp.single = {fire_rate = 0.166}
	self.usp.CLIP_AMMO_MAX = 13
	self.usp.NR_CLIPS_MAX = 7
	self.usp.AMMO_MAX = self.usp.CLIP_AMMO_MAX * self.usp.NR_CLIPS_MAX
	self.usp.AMMO_PICKUP = self:_pickup_chance(self.usp.AMMO_MAX, 1)
	self.usp.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.usp.kick = {
		standing = {
			1.2,
			1.8,
			-0.5,
			0.5
		},
		crouching = self.glock_17.kick.standing,
		steelsight = self.glock_17.kick.standing
	}
	self.usp.global_value = "pd2_clan"
	self.usp.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.usp.crosshair.standing.offset = 0.2
	self.usp.crosshair.standing.moving_offset = 0.6
	self.usp.crosshair.standing.kick_offset = 0.4
	self.usp.crosshair.crouching.offset = 0.1
	self.usp.crosshair.crouching.moving_offset = 0.6
	self.usp.crosshair.crouching.kick_offset = 0.3
	self.usp.crosshair.steelsight.hidden = true
	self.usp.crosshair.steelsight.offset = 0
	self.usp.crosshair.steelsight.moving_offset = 0
	self.usp.crosshair.steelsight.kick_offset = 0.1
	self.usp.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.usp.autohit = autohit_pistol_default
	self.usp.aim_assist = aim_assist_pistol_default
	self.usp.weapon_hold = "colt_1911"
	self.usp.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.usp.panic_suppression_chance = 0.2
	self.usp.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 29
	}
	self.g22c = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.g22c.sounds.fire = "g22_fire"
	self.g22c.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.g22c.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.g22c.sounds.dryfire = "secondary_dryfire"
	self.g22c.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.g22c.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.2,
		unequip = 0.5,
		equip = 0.35
	}
	self.g22c.name_id = "bm_w_g22c"
	self.g22c.desc_id = "bm_w_g22c_desc"
	self.g22c.description_id = "des_g22c"
	self.g22c.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.g22c.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.g22c.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.g22c.use_data = {selection_index = 1}
	self.g22c.DAMAGE = 1
	self.g22c.FIRE_MODE = "single"
	self.g22c.fire_mode_data = {fire_rate = 0.166}
	self.g22c.single = {fire_rate = 0.166}
	self.g22c.CLIP_AMMO_MAX = 16
	self.g22c.NR_CLIPS_MAX = 6
	self.g22c.AMMO_MAX = self.g22c.CLIP_AMMO_MAX * self.g22c.NR_CLIPS_MAX
	self.g22c.AMMO_PICKUP = self:_pickup_chance(self.g22c.AMMO_MAX, 1)
	self.g22c.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.g22c.kick = {
		standing = {
			1.2,
			1.8,
			-0.5,
			0.5
		},
		crouching = self.glock_17.kick.standing,
		steelsight = self.glock_17.kick.standing
	}
	self.g22c.global_value = "pd2_clan"
	self.g22c.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.g22c.crosshair.standing.offset = 0.2
	self.g22c.crosshair.standing.moving_offset = 0.6
	self.g22c.crosshair.standing.kick_offset = 0.4
	self.g22c.crosshair.crouching.offset = 0.1
	self.g22c.crosshair.crouching.moving_offset = 0.6
	self.g22c.crosshair.crouching.kick_offset = 0.3
	self.g22c.crosshair.steelsight.hidden = true
	self.g22c.crosshair.steelsight.offset = 0
	self.g22c.crosshair.steelsight.moving_offset = 0
	self.g22c.crosshair.steelsight.kick_offset = 0.1
	self.g22c.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.g22c.autohit = autohit_pistol_default
	self.g22c.aim_assist = aim_assist_pistol_default
	self.g22c.weapon_hold = "glock"
	self.g22c.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.g22c.panic_suppression_chance = 0.2
	self.g22c.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.judge = {
		categories = {"shotgun"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.judge.sounds.fire = "judge_fire"
	self.judge.sounds.dryfire = "secondary_dryfire"
	self.judge.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.judge.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.judge.timers = {
		reload_not_empty = 2.25,
		reload_empty = 2.25,
		unequip = 0.5,
		equip = 0.45
	}
	self.judge.FIRE_MODE = "single"
	self.judge.fire_mode_data = {fire_rate = 0.12}
	self.judge.single = {fire_rate = 0.21}
	self.judge.name_id = "bm_w_judge"
	self.judge.desc_id = "bm_w_judge_desc"
	self.judge.description_id = "des_judge"
	self.judge.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.judge.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.judge.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.judge.DAMAGE = 6
	self.judge.damage_near = 2000
	self.judge.damage_far = 3000
	self.judge.rays = 12
	self.judge.CLIP_AMMO_MAX = 5
	self.judge.NR_CLIPS_MAX = 5
	self.judge.AMMO_MAX = self.judge.CLIP_AMMO_MAX * self.judge.NR_CLIPS_MAX
	self.judge.AMMO_PICKUP = self:_pickup_chance(self.judge.AMMO_MAX, 1)
	self.judge.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.judge.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.judge.kick.crouching = self.judge.kick.standing
	self.judge.kick.steelsight = self.judge.kick.standing
	self.judge.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.judge.crosshair.standing.offset = 0.2
	self.judge.crosshair.standing.moving_offset = 0.8
	self.judge.crosshair.standing.kick_offset = 0.6
	self.judge.crosshair.crouching.offset = 0.1
	self.judge.crosshair.crouching.moving_offset = 0.7
	self.judge.crosshair.crouching.kick_offset = 0.4
	self.judge.crosshair.steelsight.hidden = true
	self.judge.crosshair.steelsight.offset = 0
	self.judge.crosshair.steelsight.moving_offset = 0
	self.judge.crosshair.steelsight.kick_offset = 0.1
	self.judge.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.judge.autohit = autohit_shotgun_default
	self.judge.aim_assist = aim_assist_shotgun_default
	self.judge.weapon_hold = "raging_bull"
	self.judge.animations = {
		equip_id = "equip_raging_bull",
		recoil_steelsight = true
	}
	self.judge.global_value = "pd2_clan"
	self.judge.texture_bundle_folder = "pd2_million"
	self.judge.panic_suppression_chance = 0.2
	self.judge.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 155,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 8,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 29
	}
	self.m45 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m45.sounds.fire = "m45_fire_single"
	self.m45.sounds.fire_single = "m45_fire_single"
	self.m45.sounds.fire_auto = "m45_fire"
	self.m45.sounds.stop_fire = "m45_stop"
	self.m45.sounds.dryfire = "secondary_dryfire"
	self.m45.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.m45.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.m45.timers = {
		reload_not_empty = 2.85,
		reload_empty = 3.9,
		unequip = 0.5,
		equip = 0.6
	}
	self.m45.name_id = "bm_w_m45"
	self.m45.desc_id = "bm_w_m45_desc"
	self.m45.description_id = "des_m45"
	self.m45.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.m45.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.m45.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.m45.use_data = {selection_index = 1}
	self.m45.DAMAGE = 1
	self.m45.CLIP_AMMO_MAX = 40
	self.m45.NR_CLIPS_MAX = 2
	self.m45.AMMO_MAX = self.m45.CLIP_AMMO_MAX * self.m45.NR_CLIPS_MAX
	self.m45.AMMO_PICKUP = self:_pickup_chance(self.m45.AMMO_MAX, 1)
	self.m45.FIRE_MODE = "auto"
	self.m45.fire_mode_data = {fire_rate = 0.1}
	self.m45.auto = {fire_rate = 0.1}
	self.m45.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.m45.kick = {standing = self.mp9.kick.standing}
	self.m45.kick.crouching = self.m45.kick.standing
	self.m45.kick.steelsight = self.m45.kick.standing
	self.m45.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m45.crosshair.standing.offset = 0.4
	self.m45.crosshair.standing.moving_offset = 0.7
	self.m45.crosshair.standing.kick_offset = 0.6
	self.m45.crosshair.crouching.offset = 0.3
	self.m45.crosshair.crouching.moving_offset = 0.6
	self.m45.crosshair.crouching.kick_offset = 0.4
	self.m45.crosshair.steelsight.hidden = true
	self.m45.crosshair.steelsight.offset = 0
	self.m45.crosshair.steelsight.moving_offset = 0
	self.m45.crosshair.steelsight.kick_offset = 0.4
	self.m45.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.m45.autohit = autohit_smg_default
	self.m45.aim_assist = aim_assist_smg_default
	self.m45.weapon_hold = "m45"
	self.m45.animations = {
		equip_id = "equip_m45",
		recoil_steelsight = true
	}
	self.m45.global_value = "armored_transport"
	self.m45.texture_bundle_folder = "dlc1"
	self.m45.panic_suppression_chance = 0.2
	self.m45.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 12,
		value = 5,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 24
	}
	self.s552 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.s552.sounds.fire = "sig552_fire_single"
	self.s552.sounds.fire_single = "sig552_fire_single"
	self.s552.sounds.fire_auto = "sig552_fire"
	self.s552.sounds.stop_fire = "sig552_stop"
	self.s552.sounds.dryfire = "primary_dryfire"
	self.s552.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.s552.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.s552.timers = {
		reload_not_empty = 1.65,
		reload_empty = 2.4,
		unequip = 0.55,
		equip = 0.7
	}
	self.s552.name_id = "bm_w_s552"
	self.s552.desc_id = "bm_w_s552_desc"
	self.s552.description_id = "des_s552"
	self.s552.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.s552.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.s552.use_data = {selection_index = 2}
	self.s552.DAMAGE = 1
	self.s552.CLIP_AMMO_MAX = 30
	self.s552.NR_CLIPS_MAX = 8
	self.s552.AMMO_MAX = self.s552.CLIP_AMMO_MAX * self.s552.NR_CLIPS_MAX
	self.s552.AMMO_PICKUP = self:_pickup_chance(self.s552.AMMO_MAX, 2)
	self.s552.FIRE_MODE = "auto"
	self.s552.fire_mode_data = {fire_rate = 0.084}
	self.s552.CAN_TOGGLE_FIREMODE = true
	self.s552.auto = {fire_rate = 0.084}
	self.s552.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.s552.kick = {standing = self.new_m4.kick.standing}
	self.s552.kick.crouching = self.s552.kick.standing
	self.s552.kick.steelsight = self.s552.kick.standing
	self.s552.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.s552.crosshair.standing.offset = 0.16
	self.s552.crosshair.standing.moving_offset = 0.9
	self.s552.crosshair.standing.kick_offset = 0.7
	self.s552.crosshair.crouching.offset = 0.1
	self.s552.crosshair.crouching.moving_offset = 0.8
	self.s552.crosshair.crouching.kick_offset = 0.5
	self.s552.crosshair.steelsight.hidden = true
	self.s552.crosshair.steelsight.offset = 0
	self.s552.crosshair.steelsight.moving_offset = 0
	self.s552.crosshair.steelsight.kick_offset = 0.15
	self.s552.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.s552.autohit = autohit_rifle_default
	self.s552.aim_assist = aim_assist_rifle_default
	self.s552.weapon_hold = "ak47"
	self.s552.animations = {
		equip_id = "equip_ak47",
		recoil_steelsight = true
	}
	self.s552.global_value = "armored_transport"
	self.s552.texture_bundle_folder = "dlc1"
	self.s552.panic_suppression_chance = 0.2
	self.s552.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 35,
		alert_size = 7,
		spread = 10,
		spread_moving = 8,
		recoil = 15,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 22
	}
	self.ppk = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.ppk.sounds.fire = "w_ppk_fire"
	self.ppk.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.ppk.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.ppk.sounds.dryfire = "secondary_dryfire"
	self.ppk.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.ppk.timers = {
		reload_not_empty = 1.55,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.ppk.name_id = "bm_w_ppk"
	self.ppk.desc_id = "bm_w_ppk_desc"
	self.ppk.description_id = "des_ppk"
	self.ppk.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.ppk.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.ppk.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.ppk.use_data = {selection_index = 1}
	self.ppk.DAMAGE = 1
	self.ppk.CLIP_AMMO_MAX = 14
	self.ppk.NR_CLIPS_MAX = 11
	self.ppk.AMMO_MAX = self.ppk.CLIP_AMMO_MAX * self.ppk.NR_CLIPS_MAX
	self.ppk.AMMO_PICKUP = self:_pickup_chance(self.ppk.AMMO_MAX, 1)
	self.ppk.FIRE_MODE = "single"
	self.ppk.fire_mode_data = {fire_rate = 0.125}
	self.ppk.single = {fire_rate = 0.125}
	self.ppk.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.ppk.kick = {standing = self.glock_17.kick.standing}
	self.ppk.kick.crouching = self.ppk.kick.standing
	self.ppk.kick.steelsight = self.ppk.kick.standing
	self.ppk.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.ppk.crosshair.standing.offset = 0.2
	self.ppk.crosshair.standing.moving_offset = 0.6
	self.ppk.crosshair.standing.kick_offset = 0.4
	self.ppk.crosshair.crouching.offset = 0.1
	self.ppk.crosshair.crouching.moving_offset = 0.6
	self.ppk.crosshair.crouching.kick_offset = 0.3
	self.ppk.crosshair.steelsight.hidden = true
	self.ppk.crosshair.steelsight.offset = 0
	self.ppk.crosshair.steelsight.moving_offset = 0
	self.ppk.crosshair.steelsight.kick_offset = 0.1
	self.ppk.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.ppk.autohit = autohit_pistol_default
	self.ppk.aim_assist = aim_assist_pistol_default
	self.ppk.weapon_hold = "glock"
	self.ppk.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.ppk.global_value = "armored_transport"
	self.ppk.texture_bundle_folder = "dlc1"
	self.ppk.panic_suppression_chance = 0.2
	self.ppk.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 7,
		spread = 12,
		spread_moving = 12,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 18,
		concealment = 30
	}
	self.mp7 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.mp7.sounds.fire = "mp7_fire_single"
	self.mp7.sounds.fire_single = "mp7_fire_single"
	self.mp7.sounds.fire_auto = "mp7_fire"
	self.mp7.sounds.stop_fire = "mp7_stop"
	self.mp7.sounds.dryfire = "secondary_dryfire"
	self.mp7.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.mp7.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.mp7.timers = {
		reload_not_empty = 1.96,
		reload_empty = 2.45,
		unequip = 0.6,
		equip = 0.5
	}
	self.mp7.name_id = "bm_w_mp7"
	self.mp7.desc_id = "bm_w_mp7_desc"
	self.mp7.description_id = "des_mp7"
	self.mp7.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.mp7.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.mp7.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.mp7.use_data = {selection_index = 1}
	self.mp7.DAMAGE = 1
	self.mp7.CLIP_AMMO_MAX = 20
	self.mp7.NR_CLIPS_MAX = 8
	self.mp7.AMMO_MAX = self.mp7.CLIP_AMMO_MAX * self.mp7.NR_CLIPS_MAX
	self.mp7.AMMO_PICKUP = self:_pickup_chance(self.mp7.AMMO_MAX, 3)
	self.mp7.FIRE_MODE = "auto"
	self.mp7.fire_mode_data = {fire_rate = 0.063}
	self.mp7.CAN_TOGGLE_FIREMODE = true
	self.mp7.auto = {fire_rate = 0.063}
	self.mp7.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.mp7.kick = {standing = self.new_m4.kick.standing}
	self.mp7.kick.crouching = self.mp7.kick.standing
	self.mp7.kick.steelsight = self.mp7.kick.standing
	self.mp7.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.mp7.crosshair.standing.offset = 0.5
	self.mp7.crosshair.standing.moving_offset = 0.8
	self.mp7.crosshair.standing.kick_offset = 0.7
	self.mp7.crosshair.crouching.offset = 0.3
	self.mp7.crosshair.crouching.moving_offset = 0.6
	self.mp7.crosshair.crouching.kick_offset = 0.5
	self.mp7.crosshair.steelsight.hidden = true
	self.mp7.crosshair.steelsight.offset = 0
	self.mp7.crosshair.steelsight.moving_offset = 0
	self.mp7.crosshair.steelsight.kick_offset = 0.3
	self.mp7.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.mp7.autohit = autohit_smg_default
	self.mp7.aim_assist = aim_assist_smg_default
	self.mp7.weapon_hold = "mp9"
	self.mp7.animations = {
		equip_id = "equip_mp9",
		recoil_steelsight = true
	}
	self.mp7.global_value = "gage_pack"
	self.mp7.texture_bundle_folder = "gage_pack"
	self.mp7.panic_suppression_chance = 0.2
	self.mp7.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 17,
		spread_moving = 17,
		recoil = 18,
		value = 7,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 23
	}
	self.scar = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.scar.sounds.fire = "scar_fire_single"
	self.scar.sounds.fire_single = "scar_fire_single"
	self.scar.sounds.fire_auto = "scar_fire"
	self.scar.sounds.stop_fire = "scar_stop"
	self.scar.sounds.dryfire = "primary_dryfire"
	self.scar.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.scar.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.scar.timers = {
		reload_not_empty = 2.2,
		reload_empty = 3.15,
		unequip = 0.6,
		equip = 0.5
	}
	self.scar.name_id = "bm_w_scar"
	self.scar.desc_id = "bm_w_scar_desc"
	self.scar.description_id = "des_scar"
	self.scar.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.scar.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.scar.use_data = {selection_index = 2}
	self.scar.DAMAGE = 1
	self.scar.CLIP_AMMO_MAX = 20
	self.scar.NR_CLIPS_MAX = 5
	self.scar.AMMO_MAX = self.scar.CLIP_AMMO_MAX * self.scar.NR_CLIPS_MAX
	self.scar.AMMO_PICKUP = self:_pickup_chance(self.scar.AMMO_MAX, 1)
	self.scar.FIRE_MODE = "auto"
	self.scar.fire_mode_data = {fire_rate = 0.098}
	self.scar.CAN_TOGGLE_FIREMODE = true
	self.scar.auto = {fire_rate = 0.098}
	self.scar.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.scar.kick = {standing = self.new_m4.kick.standing}
	self.scar.kick.crouching = self.scar.kick.standing
	self.scar.kick.steelsight = self.scar.kick.standing
	self.scar.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.scar.crosshair.standing.offset = 0.14
	self.scar.crosshair.standing.moving_offset = 0.8
	self.scar.crosshair.standing.kick_offset = 0.6
	self.scar.crosshair.crouching.offset = 0.1
	self.scar.crosshair.crouching.moving_offset = 0.6
	self.scar.crosshair.crouching.kick_offset = 0.4
	self.scar.crosshair.steelsight.hidden = true
	self.scar.crosshair.steelsight.offset = 0
	self.scar.crosshair.steelsight.moving_offset = 0
	self.scar.crosshair.steelsight.kick_offset = 0.14
	self.scar.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.scar.autohit = autohit_rifle_default
	self.scar.aim_assist = aim_assist_rifle_default
	self.scar.weapon_hold = "m4"
	self.scar.animations = {
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.scar.global_value = "gage_pack"
	self.scar.texture_bundle_folder = "gage_pack"
	self.scar.panic_suppression_chance = 0.2
	self.scar.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 81,
		alert_size = 7,
		spread = 19,
		spread_moving = 15,
		recoil = 12,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 8
	}
	self.p226 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.p226.sounds.fire = "p226r_fire"
	self.p226.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.p226.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.p226.sounds.dryfire = "secondary_dryfire"
	self.p226.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.p226.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.p226.name_id = "bm_w_p226"
	self.p226.desc_id = "bm_w_p226_desc"
	self.p226.description_id = "des_p226"
	self.p226.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.p226.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.p226.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.p226.use_data = {selection_index = 1}
	self.p226.DAMAGE = 1
	self.p226.CLIP_AMMO_MAX = 12
	self.p226.NR_CLIPS_MAX = 7
	self.p226.AMMO_MAX = self.p226.CLIP_AMMO_MAX * self.p226.NR_CLIPS_MAX
	self.p226.AMMO_PICKUP = self:_pickup_chance(self.p226.AMMO_MAX, 1)
	self.p226.FIRE_MODE = "single"
	self.p226.fire_mode_data = {fire_rate = 0.166}
	self.p226.single = {fire_rate = 0.166}
	self.p226.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.p226.kick = {standing = self.glock_17.kick.standing}
	self.p226.kick.crouching = self.p226.kick.standing
	self.p226.kick.steelsight = self.p226.kick.standing
	self.p226.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.p226.crosshair.standing.offset = 0.1
	self.p226.crosshair.standing.moving_offset = 0.4
	self.p226.crosshair.standing.kick_offset = 0.3
	self.p226.crosshair.crouching.offset = 0.1
	self.p226.crosshair.crouching.moving_offset = 0.5
	self.p226.crosshair.crouching.kick_offset = 0.2
	self.p226.crosshair.steelsight.hidden = true
	self.p226.crosshair.steelsight.offset = 0
	self.p226.crosshair.steelsight.moving_offset = 0
	self.p226.crosshair.steelsight.kick_offset = 0.1
	self.p226.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.p226.autohit = autohit_pistol_default
	self.p226.aim_assist = aim_assist_pistol_default
	self.p226.weapon_hold = "colt_1911"
	self.p226.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.p226.global_value = "gage_pack"
	self.p226.texture_bundle_folder = "gage_pack"
	self.p226.panic_suppression_chance = 0.2
	self.p226.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.hk21 = {
		categories = {"lmg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.hk21.sounds.fire = "hk23e_fire"
	self.hk21.sounds.fire_single = "hk23e_fire_single"
	self.hk21.sounds.fire_auto = "hk23e_fire"
	self.hk21.sounds.stop_fire = "hk23e_stop"
	self.hk21.sounds.dryfire = "primary_dryfire"
	self.hk21.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.hk21.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.hk21.timers = {
		reload_not_empty = 4.65,
		reload_empty = 6.7,
		unequip = 0.9,
		equip = 0.9,
		deploy_bipod = 1
	}
	self.hk21.bipod_camera_spin_limit = 40
	self.hk21.bipod_camera_pitch_limit = 15
	self.hk21.bipod_weapon_translation = Vector3(-8.5, 10, 0)
	self.hk21.bipod_deploy_multiplier = 1
	self.hk21.name_id = "bm_w_hk21"
	self.hk21.desc_id = "bm_w_hk21_desc"
	self.hk21.description_id = "des_hk21"
	self.hk21.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.hk21.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.hk21.use_data = {selection_index = 2}
	self.hk21.DAMAGE = 1
	self.hk21.CLIP_AMMO_MAX = 150
	self.hk21.NR_CLIPS_MAX = 2
	self.hk21.AMMO_MAX = self.hk21.CLIP_AMMO_MAX * self.hk21.NR_CLIPS_MAX
	self.hk21.AMMO_PICKUP = self:_pickup_chance(self.hk21.AMMO_MAX, 1)
	self.hk21.FIRE_MODE = "auto"
	self.hk21.fire_mode_data = {fire_rate = 0.083}
	self.hk21.CAN_TOGGLE_FIREMODE = false
	self.hk21.auto = {fire_rate = 0.083}
	self.hk21.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight,
		bipod = default_bipod_spread
	}
	self.hk21.kick = {standing = {
		-0.2,
		0.8,
		-0.8,
		1
	}}
	self.hk21.kick.crouching = self.hk21.kick.standing
	self.hk21.kick.steelsight = self.hk21.kick.standing
	self.hk21.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.hk21.crosshair.standing.offset = 0.14
	self.hk21.crosshair.standing.moving_offset = 0.8
	self.hk21.crosshair.standing.kick_offset = 0.6
	self.hk21.crosshair.crouching.offset = 0.1
	self.hk21.crosshair.crouching.moving_offset = 0.6
	self.hk21.crosshair.crouching.kick_offset = 0.4
	self.hk21.crosshair.steelsight.hidden = true
	self.hk21.crosshair.steelsight.offset = 0
	self.hk21.crosshair.steelsight.moving_offset = 0
	self.hk21.crosshair.steelsight.kick_offset = 0.14
	self.hk21.shake = {
		fire_multiplier = 0.8,
		fire_steelsight_multiplier = -0.8
	}
	self.hk21.autohit = autohit_lmg_default
	self.hk21.aim_assist = aim_assist_lmg_default
	self.hk21.weapon_hold = "hk21"
	self.hk21.animations = {
		equip_id = "equip_hk21",
		recoil_steelsight = true,
		bipod_enter = "bipod_enter",
		bipod_exit = "bipod_exit",
		bipod_recoil = "bipod_recoil",
		bipod_recoil_enter = "bipod_recoil",
		bipod_recoil_loop = "bipod_recoil_loop",
		bipod_recoil_exit = "bipod_recoil_exit"
	}
	self.hk21.global_value = "gage_pack_lmg"
	self.hk21.texture_bundle_folder = "gage_pack_lmg"
	self.hk21.panic_suppression_chance = 0.2
	self.hk21.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 8,
		spread = 10,
		spread_moving = 10,
		recoil = 10,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 2
	}
	self.m249 = {
		categories = {"lmg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m249.sounds.fire = "m249_fire_single"
	self.m249.sounds.fire_single = "m249_fire_single"
	self.m249.sounds.fire_auto = "m249_fire"
	self.m249.sounds.stop_fire = "m249_stop"
	self.m249.sounds.dryfire = "primary_dryfire"
	self.m249.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.m249.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.m249.timers = {
		reload_not_empty = 5.62,
		reload_empty = 5.62,
		unequip = 0.9,
		equip = 0.9,
		deploy_bipod = 1
	}
	self.m249.bipod_camera_spin_limit = 40
	self.m249.bipod_camera_pitch_limit = 15
	self.m249.bipod_weapon_translation = Vector3(-8.5, 20, -5)
	self.m249.bipod_deploy_multiplier = 1
	self.m249.name_id = "bm_w_m249"
	self.m249.desc_id = "bm_w_m249_desc"
	self.m249.description_id = "des_m249"
	self.m249.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.m249.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.m249.use_data = {selection_index = 2}
	self.m249.DAMAGE = 1
	self.m249.CLIP_AMMO_MAX = 200
	self.m249.NR_CLIPS_MAX = 2
	self.m249.AMMO_MAX = self.m249.CLIP_AMMO_MAX * self.m249.NR_CLIPS_MAX
	self.m249.AMMO_PICKUP = self:_pickup_chance(self.m249.AMMO_MAX, 1)
	self.m249.FIRE_MODE = "auto"
	self.m249.fire_mode_data = {fire_rate = 0.066}
	self.m249.CAN_TOGGLE_FIREMODE = false
	self.m249.auto = {fire_rate = 0.076}
	self.m249.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight,
		bipod = default_bipod_spread
	}
	self.m249.kick = {standing = {
		-0.2,
		0.8,
		-1,
		1.4
	}}
	self.m249.kick.crouching = self.m249.kick.standing
	self.m249.kick.steelsight = self.m249.kick.standing
	self.m249.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m249.crosshair.standing.offset = 0.16
	self.m249.crosshair.standing.moving_offset = 1
	self.m249.crosshair.standing.kick_offset = 0.8
	self.m249.crosshair.crouching.offset = 0.1
	self.m249.crosshair.crouching.moving_offset = 0.6
	self.m249.crosshair.crouching.kick_offset = 0.4
	self.m249.crosshair.steelsight.hidden = true
	self.m249.crosshair.steelsight.offset = 0
	self.m249.crosshair.steelsight.moving_offset = 0
	self.m249.crosshair.steelsight.kick_offset = 0.14
	self.m249.shake = {
		fire_multiplier = 0.5,
		fire_steelsight_multiplier = -0.5
	}
	self.m249.autohit = autohit_lmg_default
	self.m249.aim_assist = aim_assist_lmg_default
	self.m249.weapon_hold = "m249"
	self.m249.animations = {
		equip_id = "equip_m249",
		recoil_steelsight = true,
		bipod_enter = "bipod_enter",
		bipod_exit = "bipod_exit",
		bipod_recoil = "bipod_recoil",
		bipod_recoil_enter = "bipod_recoil",
		bipod_recoil_loop = "bipod_recoil_loop",
		bipod_recoil_exit = "bipod_recoil_exit"
	}
	self.m249.global_value = "gage_pack_lmg"
	self.m249.texture_bundle_folder = "gage_pack_lmg"
	self.m249.panic_suppression_chance = 0.2
	self.m249.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 8,
		spread = 8,
		spread_moving = 8,
		recoil = 10,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 2
	}
	self.rpk = {
		categories = {"lmg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.rpk.sounds.fire = "rpk_fire_single"
	self.rpk.sounds.fire_single = "rpk_fire_single"
	self.rpk.sounds.fire_auto = "rpk_fire"
	self.rpk.sounds.stop_fire = "rpk_stop"
	self.rpk.sounds.dryfire = "primary_dryfire"
	self.rpk.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.rpk.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.rpk.timers = {
		reload_not_empty = 3.4,
		reload_empty = 4.56,
		unequip = 0.9,
		equip = 0.9,
		deploy_bipod = 1
	}
	self.rpk.bipod_camera_spin_limit = 40
	self.rpk.bipod_camera_pitch_limit = 15
	self.rpk.bipod_weapon_translation = Vector3(-8.5, 12, 0)
	self.rpk.bipod_deploy_multiplier = 1
	self.rpk.name_id = "bm_w_rpk"
	self.rpk.desc_id = "bm_w_rpk_desc"
	self.rpk.description_id = "des_rpk"
	self.rpk.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.rpk.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.rpk.use_data = {selection_index = 2}
	self.rpk.DAMAGE = 1
	self.rpk.CLIP_AMMO_MAX = 100
	self.rpk.NR_CLIPS_MAX = 3
	self.rpk.AMMO_MAX = self.rpk.CLIP_AMMO_MAX * self.rpk.NR_CLIPS_MAX
	self.rpk.AMMO_PICKUP = self:_pickup_chance(self.rpk.AMMO_MAX, 1)
	self.rpk.FIRE_MODE = "auto"
	self.rpk.fire_mode_data = {fire_rate = 0.08}
	self.rpk.CAN_TOGGLE_FIREMODE = false
	self.rpk.auto = {fire_rate = 0.08}
	self.rpk.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight,
		bipod = default_bipod_spread
	}
	self.rpk.kick = {standing = {
		-0.2,
		0.8,
		-1,
		1.4
	}}
	self.rpk.kick.crouching = self.rpk.kick.standing
	self.rpk.kick.steelsight = self.rpk.kick.standing
	self.rpk.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.rpk.crosshair.standing.offset = 0.17
	self.rpk.crosshair.standing.moving_offset = 0.9
	self.rpk.crosshair.standing.kick_offset = 0.7
	self.rpk.crosshair.crouching.offset = 0.9
	self.rpk.crosshair.crouching.moving_offset = 0.8
	self.rpk.crosshair.crouching.kick_offset = 0.5
	self.rpk.crosshair.steelsight.hidden = true
	self.rpk.crosshair.steelsight.offset = 0
	self.rpk.crosshair.steelsight.moving_offset = 0
	self.rpk.crosshair.steelsight.kick_offset = 0.11
	self.rpk.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.rpk.autohit = autohit_lmg_default
	self.rpk.aim_assist = aim_assist_lmg_default
	self.rpk.weapon_hold = "rpk"
	self.rpk.animations = {
		equip_id = "equip_rpk",
		recoil_steelsight = true,
		bipod_enter = "bipod_enter",
		bipod_exit = "bipod_exit",
		bipod_recoil = "bipod_recoil",
		bipod_recoil_enter = "bipod_recoil",
		bipod_recoil_loop = "bipod_recoil_loop",
		bipod_recoil_exit = "bipod_recoil_exit"
	}
	self.rpk.global_value = "gage_pack_lmg"
	self.rpk.texture_bundle_folder = "gage_pack_lmg"
	self.rpk.panic_suppression_chance = 0.2
	self.rpk.stats = {
		zoom = 2,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 8,
		spread_moving = 6,
		recoil = 10,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 5
	}
	self.m95 = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m95.sounds.fire = "barrett_fire"
	self.m95.sounds.dryfire = "primary_dryfire"
	self.m95.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.m95.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.m95.timers = {
		reload_not_empty = 3.96,
		reload_empty = 5.23,
		unequip = 0.9,
		equip = 0.9
	}
	self.m95.name_id = "bm_w_m95"
	self.m95.desc_id = "bm_w_m95_desc"
	self.m95.description_id = "des_m95"
	self.m95.muzzleflash = "effects/payday2/particles/weapons/50cal_auto_fps"
	self.m95.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper_m95"
	self.m95.use_data = {selection_index = 2}
	self.m95.DAMAGE = 1
	self.m95.CLIP_AMMO_MAX = 5
	self.m95.NR_CLIPS_MAX = 3
	self.m95.AMMO_MAX = self.m95.CLIP_AMMO_MAX * self.m95.NR_CLIPS_MAX
	self.m95.AMMO_PICKUP = {
		0.05,
		0.65
	}
	self.m95.FIRE_MODE = "single"
	self.m95.fire_mode_data = {fire_rate = 1.5}
	self.m95.CAN_TOGGLE_FIREMODE = false
	self.m95.single = {fire_rate = 20}
	self.m95.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.m95.kick = {standing = {
		3,
		3.8,
		-0.5,
		0.5
	}}
	self.m95.kick.crouching = self.m95.kick.standing
	self.m95.kick.steelsight = self.m95.kick.standing
	self.m95.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m95.crosshair.standing.offset = 1.14
	self.m95.crosshair.standing.moving_offset = 1.8
	self.m95.crosshair.standing.kick_offset = 1.6
	self.m95.crosshair.crouching.offset = 1.1
	self.m95.crosshair.crouching.moving_offset = 1.6
	self.m95.crosshair.crouching.kick_offset = 1.4
	self.m95.crosshair.steelsight.hidden = true
	self.m95.crosshair.steelsight.offset = 1
	self.m95.crosshair.steelsight.moving_offset = 1
	self.m95.crosshair.steelsight.kick_offset = 1.14
	self.m95.shake = {
		fire_multiplier = 3.8,
		fire_steelsight_multiplier = -3.8
	}
	self.m95.autohit = autohit_snp_default
	self.m95.aim_assist = aim_assist_snp_default
	self.m95.animations = {
		equip_id = "equip_m95",
		recoil_steelsight = true
	}
	self.m95.global_value = "gage_pack_snp"
	self.m95.texture_bundle_folder = "gage_pack_snp"
	self.m95.can_shoot_through_enemy = true
	self.m95.can_shoot_through_shield = true
	self.m95.can_shoot_through_wall = true
	self.m95.panic_suppression_chance = 0.2
	self.m95.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 145,
		alert_size = 9,
		spread = 24,
		spread_moving = 24,
		recoil = 2,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 1
	}
	self.m95.armor_piercing_chance = 1
	self.m95.stats_modifiers = {damage = 20}
	self.msr = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.msr.sounds.fire = "msr_fire"
	self.msr.sounds.dryfire = "primary_dryfire"
	self.msr.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.msr.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.msr.timers = {
		reload_not_empty = 2.6,
		reload_empty = 3.7,
		unequip = 0.6,
		equip = 0.7
	}
	self.msr.name_id = "bm_w_msr"
	self.msr.desc_id = "bm_w_msr_desc"
	self.msr.description_id = "des_msr"
	self.msr.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.msr.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.msr.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.msr.DAMAGE = 1
	self.msr.CLIP_AMMO_MAX = 10
	self.msr.NR_CLIPS_MAX = 4
	self.msr.AMMO_MAX = self.msr.CLIP_AMMO_MAX * self.msr.NR_CLIPS_MAX
	self.msr.AMMO_PICKUP = self:_pickup_chance(self.msr.AMMO_MAX, 5)
	self.msr.FIRE_MODE = "single"
	self.msr.fire_mode_data = {fire_rate = 1}
	self.msr.CAN_TOGGLE_FIREMODE = false
	self.msr.single = {fire_rate = 20}
	self.msr.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.msr.kick = {standing = {
		3,
		4.8,
		-0.3,
		0.3
	}}
	self.msr.kick.crouching = self.msr.kick.standing
	self.msr.kick.steelsight = self.msr.kick.standing
	self.msr.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.msr.crosshair.standing.offset = 1.14
	self.msr.crosshair.standing.moving_offset = 1.8
	self.msr.crosshair.standing.kick_offset = 1.6
	self.msr.crosshair.crouching.offset = 1.1
	self.msr.crosshair.crouching.moving_offset = 1.6
	self.msr.crosshair.crouching.kick_offset = 1.4
	self.msr.crosshair.steelsight.hidden = true
	self.msr.crosshair.steelsight.offset = 1
	self.msr.crosshair.steelsight.moving_offset = 1
	self.msr.crosshair.steelsight.kick_offset = 1.14
	self.msr.shake = {
		fire_multiplier = 3.5,
		fire_steelsight_multiplier = -3.5
	}
	self.msr.autohit = autohit_snp_default
	self.msr.aim_assist = aim_assist_snp_default
	self.msr.weapon_hold = "msr"
	self.msr.animations = {
		equip_id = "equip_msr",
		recoil_steelsight = true
	}
	self.msr.global_value = "gage_pack_snp"
	self.msr.texture_bundle_folder = "gage_pack_snp"
	self.msr.can_shoot_through_enemy = true
	self.msr.can_shoot_through_shield = true
	self.msr.can_shoot_through_wall = true
	self.msr.panic_suppression_chance = 0.2
	self.msr.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 7,
		spread = 23,
		spread_moving = 22,
		recoil = 8,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 6,
		concealment = 5
	}
	self.msr.armor_piercing_chance = 1
	self.msr.stats_modifiers = {damage = 1}
	self.r93 = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.r93.sounds.fire = "blazer_fire"
	self.r93.sounds.dryfire = "primary_dryfire"
	self.r93.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.r93.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.r93.timers = {
		reload_not_empty = 2.82,
		reload_empty = 3.82,
		unequip = 0.7,
		equip = 0.65
	}
	self.r93.name_id = "bm_w_r93"
	self.r93.desc_id = "bm_w_r93_desc"
	self.r93.description_id = "des_r93"
	self.r93.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.r93.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.r93.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.r93.DAMAGE = 1
	self.r93.CLIP_AMMO_MAX = 6
	self.r93.NR_CLIPS_MAX = 5
	self.r93.AMMO_MAX = self.r93.CLIP_AMMO_MAX * self.r93.NR_CLIPS_MAX
	self.r93.AMMO_PICKUP = {
		0.7,
		1
	}
	self.r93.FIRE_MODE = "single"
	self.r93.fire_mode_data = {fire_rate = 1.2}
	self.r93.CAN_TOGGLE_FIREMODE = false
	self.r93.single = {fire_rate = 20}
	self.r93.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.r93.kick = {standing = {
		3,
		3.8,
		-0.1,
		0.1
	}}
	self.r93.kick.crouching = self.r93.kick.standing
	self.r93.kick.steelsight = self.r93.kick.standing
	self.r93.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.r93.crosshair.standing.offset = 1.14
	self.r93.crosshair.standing.moving_offset = 1.8
	self.r93.crosshair.standing.kick_offset = 1.6
	self.r93.crosshair.crouching.offset = 1.1
	self.r93.crosshair.crouching.moving_offset = 1.6
	self.r93.crosshair.crouching.kick_offset = 1.4
	self.r93.crosshair.steelsight.hidden = true
	self.r93.crosshair.steelsight.offset = 1
	self.r93.crosshair.steelsight.moving_offset = 1
	self.r93.crosshair.steelsight.kick_offset = 1.14
	self.r93.shake = {
		fire_multiplier = 2.8,
		fire_steelsight_multiplier = -2.8
	}
	self.r93.autohit = autohit_snp_default
	self.r93.aim_assist = aim_assist_snp_default
	self.r93.weapon_hold = "r93"
	self.r93.animations = {
		equip_id = "equip_r93",
		recoil_steelsight = true
	}
	self.r93.global_value = "gage_pack_snp"
	self.r93.texture_bundle_folder = "gage_pack_snp"
	self.r93.can_shoot_through_enemy = true
	self.r93.can_shoot_through_shield = true
	self.r93.can_shoot_through_wall = true
	self.r93.panic_suppression_chance = 0.2
	self.r93.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 150,
		alert_size = 8,
		spread = 24,
		spread_moving = 24,
		recoil = 4,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 5
	}
	self.r93.armor_piercing_chance = 1
	self.r93.stats_modifiers = {damage = 2}
	self.fal = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.fal.sounds.fire = "fn_fal_fire_1p"
	self.fal.sounds.fire_single = "fn_fal_fire_1p_single"
	self.fal.sounds.fire_auto = "fn_fal_fire_1p"
	self.fal.sounds.stop_fire = "fn_fal_stop"
	self.fal.sounds.dryfire = "primary_dryfire"
	self.fal.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.fal.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.fal.timers = {
		reload_not_empty = 2.2,
		reload_empty = 3.28,
		unequip = 0.6,
		equip = 0.6
	}
	self.fal.name_id = "bm_w_fal"
	self.fal.desc_id = "bm_w_fal_desc"
	self.fal.description_id = "des_fal"
	self.fal.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.fal.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.fal.use_data = {selection_index = 2}
	self.fal.DAMAGE = 1
	self.fal.CLIP_AMMO_MAX = 20
	self.fal.NR_CLIPS_MAX = 5
	self.fal.AMMO_MAX = self.fal.CLIP_AMMO_MAX * self.fal.NR_CLIPS_MAX
	self.fal.AMMO_PICKUP = self:_pickup_chance(self.fal.AMMO_MAX, 1)
	self.fal.FIRE_MODE = "auto"
	self.fal.fire_mode_data = {fire_rate = 0.086}
	self.fal.CAN_TOGGLE_FIREMODE = true
	self.fal.auto = {fire_rate = 0.086}
	self.fal.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.fal.kick = {standing = self.new_m4.kick.standing}
	self.fal.kick.crouching = self.fal.kick.standing
	self.fal.kick.steelsight = self.fal.kick.standing
	self.fal.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.fal.crosshair.standing.offset = 0.14
	self.fal.crosshair.standing.moving_offset = 0.8
	self.fal.crosshair.standing.kick_offset = 0.6
	self.fal.crosshair.crouching.offset = 0.1
	self.fal.crosshair.crouching.moving_offset = 0.6
	self.fal.crosshair.crouching.kick_offset = 0.4
	self.fal.crosshair.steelsight.hidden = true
	self.fal.crosshair.steelsight.offset = 0
	self.fal.crosshair.steelsight.moving_offset = 0
	self.fal.crosshair.steelsight.kick_offset = 0.14
	self.fal.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.fal.autohit = autohit_rifle_default
	self.fal.aim_assist = aim_assist_rifle_default
	self.fal.animations = {
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.fal.global_value = "big_bank"
	self.fal.texture_bundle_folder = "big_bank"
	self.fal.panic_suppression_chance = 0.2
	self.fal.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 18,
		spread_moving = 16,
		recoil = 12,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 10
	}
	self.benelli = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.benelli.sounds.fire = "benelli_m4_fire"
	self.benelli.sounds.dryfire = "shotgun_dryfire"
	self.benelli.sounds.stop_fire = "shotgun_dryfire"
	self.benelli.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.benelli.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.benelli.timers = {
		unequip = 0.85,
		equip = 0.85
	}
	self.benelli.name_id = "bm_w_benelli"
	self.benelli.desc_id = "bm_w_benelli_desc"
	self.benelli.description_id = "des_benelli"
	self.benelli.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.benelli.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.benelli.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.benelli.DAMAGE = 6
	self.benelli.damage_near = 2000
	self.benelli.damage_far = 3000
	self.benelli.rays = 12
	self.benelli.CLIP_AMMO_MAX = 8
	self.benelli.NR_CLIPS_MAX = 8
	self.benelli.AMMO_MAX = self.benelli.CLIP_AMMO_MAX * self.benelli.NR_CLIPS_MAX
	self.benelli.AMMO_PICKUP = self:_pickup_chance(self.benelli.AMMO_MAX, 4)
	self.benelli.FIRE_MODE = "single"
	self.benelli.fire_mode_data = {fire_rate = 0.14}
	self.benelli.CAN_TOGGLE_FIREMODE = false
	self.benelli.single = {fire_rate = 0.14}
	self.benelli.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.benelli.kick = {standing = self.r870.kick.standing}
	self.benelli.kick.crouching = self.benelli.kick.standing
	self.benelli.kick.steelsight = self.r870.kick.steelsight
	self.benelli.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.benelli.crosshair.standing.offset = 0.7
	self.benelli.crosshair.standing.moving_offset = 0.7
	self.benelli.crosshair.standing.kick_offset = 0.8
	self.benelli.crosshair.crouching.offset = 0.65
	self.benelli.crosshair.crouching.moving_offset = 0.65
	self.benelli.crosshair.crouching.kick_offset = 0.75
	self.benelli.crosshair.steelsight.hidden = true
	self.benelli.crosshair.steelsight.offset = 0.65
	self.benelli.crosshair.steelsight.moving_offset = 0.65
	self.benelli.crosshair.steelsight.kick_offset = 0.25
	self.benelli.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 1.25
	}
	self.benelli.autohit = autohit_shotgun_default
	self.benelli.aim_assist = aim_assist_shotgun_default
	self.benelli.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.benelli.texture_bundle_folder = "gage_pack_shotgun"
	self.benelli.global_value = "gage_pack_shotgun"
	self.benelli.panic_suppression_chance = 0.2
	self.benelli.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 55,
		alert_size = 7,
		spread = 8,
		spread_moving = 7,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 6,
		concealment = 12
	}
	self.striker = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.striker.sounds.fire = "striker_fire"
	self.striker.sounds.dryfire = "shotgun_dryfire"
	self.striker.sounds.stop_fire = "shotgun_dryfire"
	self.striker.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.striker.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.striker.timers = {
		shotgun_reload_enter = 0.5333333333333333,
		shotgun_reload_exit_empty = 0.4,
		shotgun_reload_exit_not_empty = 0.4,
		shotgun_reload_shell = 0.6,
		shotgun_reload_first_shell_offset = 0.13333333333333333,
		unequip = 0.6,
		equip = 0.85
	}
	self.striker.name_id = "bm_w_striker"
	self.striker.desc_id = "bm_w_striker_desc"
	self.striker.description_id = "des_striker"
	self.striker.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.striker.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.striker.use_data = {
		selection_index = 1,
		align_place = "left_hand"
	}
	self.striker.DAMAGE = 6
	self.striker.damage_near = 2000
	self.striker.damage_far = 3000
	self.striker.rays = 12
	self.striker.CLIP_AMMO_MAX = 12
	self.striker.NR_CLIPS_MAX = 6
	self.striker.AMMO_MAX = self.striker.CLIP_AMMO_MAX * self.striker.NR_CLIPS_MAX
	self.striker.AMMO_PICKUP = self:_pickup_chance(self.striker.AMMO_MAX, 4)
	self.striker.FIRE_MODE = "single"
	self.striker.fire_mode_data = {fire_rate = 0.14}
	self.striker.CAN_TOGGLE_FIREMODE = false
	self.striker.single = {fire_rate = 0.14}
	self.striker.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.striker.kick = {standing = self.r870.kick.standing}
	self.striker.kick.crouching = self.striker.kick.standing
	self.striker.kick.steelsight = self.r870.kick.steelsight
	self.striker.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.striker.crosshair.standing.offset = 0.7
	self.striker.crosshair.standing.moving_offset = 0.7
	self.striker.crosshair.standing.kick_offset = 0.8
	self.striker.crosshair.crouching.offset = 0.65
	self.striker.crosshair.crouching.moving_offset = 0.65
	self.striker.crosshair.crouching.kick_offset = 0.75
	self.striker.crosshair.steelsight.hidden = true
	self.striker.crosshair.steelsight.offset = 0
	self.striker.crosshair.steelsight.moving_offset = 0
	self.striker.crosshair.steelsight.kick_offset = 0
	self.striker.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 1.25
	}
	self.striker.autohit = autohit_shotgun_default
	self.striker.aim_assist = aim_assist_shotgun_default
	self.striker.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true,
		reload_shell_data = {align = "right"}
	}
	self.striker.texture_bundle_folder = "gage_pack_shotgun"
	self.striker.global_value = "gage_pack_shotgun"
	self.striker.panic_suppression_chance = 0.2
	self.striker.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 42,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 21
	}
	self.ksg = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.ksg.sounds.fire = "keltec_fire"
	self.ksg.sounds.dryfire = "shotgun_dryfire"
	self.ksg.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.ksg.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.ksg.timers = {
		unequip = 0.6,
		equip = 0.55
	}
	self.ksg.name_id = "bm_w_ksg"
	self.ksg.desc_id = "bm_w_ksg_desc"
	self.ksg.description_id = "des_ksg"
	self.ksg.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.ksg.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.ksg.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.ksg.DAMAGE = 6
	self.ksg.damage_near = 2000
	self.ksg.damage_far = 3000
	self.ksg.rays = 12
	self.ksg.CLIP_AMMO_MAX = 14
	self.ksg.NR_CLIPS_MAX = 3
	self.ksg.AMMO_MAX = self.ksg.CLIP_AMMO_MAX * self.ksg.NR_CLIPS_MAX
	self.ksg.AMMO_PICKUP = self:_pickup_chance(self.ksg.AMMO_MAX, 1)
	self.ksg.FIRE_MODE = "single"
	self.ksg.fire_mode_data = {fire_rate = 0.575}
	self.ksg.single = {fire_rate = 0.575}
	self.ksg.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.ksg.kick = {standing = {
		1.9,
		2,
		-0.2,
		0.2
	}}
	self.ksg.kick.crouching = self.ksg.kick.standing
	self.ksg.kick.steelsight = {
		1.5,
		1.7,
		-0.2,
		0.2
	}
	self.ksg.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.ksg.crosshair.standing.offset = 0.7
	self.ksg.crosshair.standing.moving_offset = 0.7
	self.ksg.crosshair.standing.kick_offset = 0.8
	self.ksg.crosshair.crouching.offset = 0.65
	self.ksg.crosshair.crouching.moving_offset = 0.65
	self.ksg.crosshair.crouching.kick_offset = 0.75
	self.ksg.crosshair.steelsight.hidden = true
	self.ksg.crosshair.steelsight.offset = 0
	self.ksg.crosshair.steelsight.moving_offset = 0
	self.ksg.crosshair.steelsight.kick_offset = 0
	self.ksg.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.ksg.autohit = autohit_shotgun_default
	self.ksg.aim_assist = aim_assist_shotgun_default
	self.ksg.weapon_hold = "ksg"
	self.ksg.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.ksg.texture_bundle_folder = "gage_pack_shotgun"
	self.ksg.global_value = "gage_pack_shotgun"
	self.ksg.panic_suppression_chance = 0.2
	self.ksg.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 90,
		alert_size = 7,
		spread = 12,
		spread_moving = 12,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 22
	}
	self.gre_m79 = {
		categories = {"grenade_launcher"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.gre_m79.sounds.fire = "gl40_fire"
	self.gre_m79.sounds.dryfire = "shotgun_dryfire"
	self.gre_m79.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.gre_m79.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.gre_m79.timers = {reload_not_empty = 3.1}
	self.gre_m79.timers.reload_empty = self.gre_m79.timers.reload_not_empty
	self.gre_m79.timers.unequip = 0.6
	self.gre_m79.timers.equip = 0.6
	self.gre_m79.name_id = "bm_w_gre_m79"
	self.gre_m79.desc_id = "bm_w_gre_m79_desc"
	self.gre_m79.description_id = "des_gre_m79"
	self.gre_m79.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.gre_m79.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.gre_m79.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.gre_m79.DAMAGE = 6
	self.gre_m79.damage_near = 2000
	self.gre_m79.damage_far = 3000
	self.gre_m79.rays = 6
	self.gre_m79.CLIP_AMMO_MAX = 1
	self.gre_m79.NR_CLIPS_MAX = math.round((total_damage_primary / 50) / self.gre_m79.CLIP_AMMO_MAX)
	self.gre_m79.AMMO_MAX = self.gre_m79.CLIP_AMMO_MAX * self.gre_m79.NR_CLIPS_MAX
	self.gre_m79.AMMO_PICKUP = {
		0.05,
		0.65
	}
	self.gre_m79.FIRE_MODE = "single"
	self.gre_m79.fire_mode_data = {fire_rate = 2}
	self.gre_m79.single = {fire_rate = 2}
	self.gre_m79.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.gre_m79.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.gre_m79.kick.crouching = self.gre_m79.kick.standing
	self.gre_m79.kick.steelsight = self.gre_m79.kick.standing
	self.gre_m79.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.gre_m79.crosshair.standing.offset = 0.16
	self.gre_m79.crosshair.standing.moving_offset = 0.8
	self.gre_m79.crosshair.standing.kick_offset = 0.6
	self.gre_m79.crosshair.standing.hidden = true
	self.gre_m79.crosshair.crouching.offset = 0.08
	self.gre_m79.crosshair.crouching.moving_offset = 0.7
	self.gre_m79.crosshair.crouching.kick_offset = 0.4
	self.gre_m79.crosshair.crouching.hidden = true
	self.gre_m79.crosshair.steelsight.hidden = true
	self.gre_m79.crosshair.steelsight.offset = 0
	self.gre_m79.crosshair.steelsight.moving_offset = 0
	self.gre_m79.crosshair.steelsight.kick_offset = 0.1
	self.gre_m79.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.gre_m79.autohit = autohit_shotgun_default
	self.gre_m79.aim_assist = aim_assist_shotgun_default
	self.gre_m79.animations = {
		equip_id = "equip_gre_m79",
		recoil_steelsight = true
	}
	self.gre_m79.global_value = "gage_pack_assault"
	self.gre_m79.texture_bundle_folder = "gage_pack_assault"
	self.gre_m79.panic_suppression_chance = 0.2
	self.gre_m79.ignore_damage_upgrades = true
	self.gre_m79.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 130,
		alert_size = 7,
		spread = 25,
		spread_moving = 6,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 18
	}
	self.gre_m79.stats_modifiers = {damage = 10}
	self.g3 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.g3.sounds.fire = "g3_fire_single"
	self.g3.sounds.fire_single = "g3_fire_single"
	self.g3.sounds.fire_auto = "g3_fire"
	self.g3.sounds.stop_fire = "g3_stop"
	self.g3.sounds.dryfire = "primary_dryfire"
	self.g3.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.g3.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.g3.timers = {
		reload_not_empty = 2.6,
		reload_empty = 3.8,
		unequip = 0.6,
		equip = 0.65
	}
	self.g3.name_id = "bm_w_g3"
	self.g3.desc_id = "bm_w_g3_desc"
	self.g3.description_id = "des_g3"
	self.g3.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.g3.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.g3.use_data = {selection_index = 2}
	self.g3.DAMAGE = 1
	self.g3.CLIP_AMMO_MAX = 20
	self.g3.NR_CLIPS_MAX = 5
	self.g3.AMMO_MAX = self.g3.CLIP_AMMO_MAX * self.g3.NR_CLIPS_MAX
	self.g3.AMMO_PICKUP = self:_pickup_chance(self.g3.AMMO_MAX, 1)
	self.g3.FIRE_MODE = "auto"
	self.g3.fire_mode_data = {fire_rate = 0.092}
	self.g3.CAN_TOGGLE_FIREMODE = true
	self.g3.auto = {fire_rate = 0.092}
	self.g3.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.g3.kick = {standing = self.new_m4.kick.standing}
	self.g3.kick.crouching = self.g3.kick.standing
	self.g3.kick.steelsight = self.g3.kick.standing
	self.g3.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.g3.crosshair.standing.offset = 0.14
	self.g3.crosshair.standing.moving_offset = 0.8
	self.g3.crosshair.standing.kick_offset = 0.6
	self.g3.crosshair.crouching.offset = 0.1
	self.g3.crosshair.crouching.moving_offset = 0.6
	self.g3.crosshair.crouching.kick_offset = 0.4
	self.g3.crosshair.steelsight.hidden = true
	self.g3.crosshair.steelsight.offset = 0
	self.g3.crosshair.steelsight.moving_offset = 0
	self.g3.crosshair.steelsight.kick_offset = 0.14
	self.g3.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.g3.autohit = autohit_rifle_default
	self.g3.aim_assist = aim_assist_rifle_default
	self.g3.animations = {
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.g3.global_value = "gage_pack_assault"
	self.g3.texture_bundle_folder = "gage_pack_assault"
	self.g3.panic_suppression_chance = 0.2
	self.g3.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 18,
		spread_moving = 16,
		recoil = 13,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 6,
		concealment = 12
	}
	self.galil = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.galil.sounds.fire = "galil_fire"
	self.galil.sounds.fire_single = "galil_fire_single"
	self.galil.sounds.fire_auto = "galil_fire"
	self.galil.sounds.stop_fire = "galil_stop"
	self.galil.sounds.dryfire = "primary_dryfire"
	self.galil.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.galil.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.galil.timers = {
		reload_not_empty = 3,
		reload_empty = 4.2,
		unequip = 0.6,
		equip = 0.6
	}
	self.galil.name_id = "bm_w_galil"
	self.galil.desc_id = "bm_w_galil_desc"
	self.galil.description_id = "des_galil"
	self.galil.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.galil.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.galil.use_data = {selection_index = 2}
	self.galil.DAMAGE = 1
	self.galil.CLIP_AMMO_MAX = 30
	self.galil.NR_CLIPS_MAX = 5
	self.galil.AMMO_MAX = self.galil.CLIP_AMMO_MAX * self.galil.NR_CLIPS_MAX
	self.galil.AMMO_PICKUP = self:_pickup_chance(self.galil.AMMO_MAX, 3)
	self.galil.FIRE_MODE = "auto"
	self.galil.fire_mode_data = {fire_rate = 0.071}
	self.galil.CAN_TOGGLE_FIREMODE = true
	self.galil.auto = {fire_rate = 0.071}
	self.galil.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.galil.kick = {standing = self.new_m4.kick.standing}
	self.galil.kick.crouching = self.galil.kick.standing
	self.galil.kick.steelsight = self.galil.kick.standing
	self.galil.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.galil.crosshair.standing.offset = 0.14
	self.galil.crosshair.standing.moving_offset = 0.8
	self.galil.crosshair.standing.kick_offset = 0.6
	self.galil.crosshair.crouching.offset = 0.1
	self.galil.crosshair.crouching.moving_offset = 0.6
	self.galil.crosshair.crouching.kick_offset = 0.4
	self.galil.crosshair.steelsight.hidden = true
	self.galil.crosshair.steelsight.offset = 0
	self.galil.crosshair.steelsight.moving_offset = 0
	self.galil.crosshair.steelsight.kick_offset = 0.14
	self.galil.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.galil.autohit = autohit_rifle_default
	self.galil.aim_assist = aim_assist_rifle_default
	self.galil.weapon_hold = "ak47"
	self.galil.animations = {}
	self.galil.animations = {
		equip_id = "equip_ak47",
		recoil_steelsight = true
	}
	self.galil.global_value = "gage_pack_assault"
	self.galil.texture_bundle_folder = "gage_pack_assault"
	self.galil.panic_suppression_chance = 0.2
	self.galil.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 42,
		alert_size = 7,
		spread = 13,
		spread_moving = 10,
		recoil = 18,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 15
	}
	self.famas = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.famas.sounds.fire = "famas_fire_single"
	self.famas.sounds.fire_single = "famas_fire_single"
	self.famas.sounds.fire_auto = "famas_fire"
	self.famas.sounds.stop_fire = "famas_stop"
	self.famas.sounds.dryfire = "primary_dryfire"
	self.famas.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.famas.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.famas.timers = {
		reload_not_empty = 2.72,
		reload_empty = 3.78,
		unequip = 0.55,
		equip = 0.6
	}
	self.famas.name_id = "bm_w_famas"
	self.famas.desc_id = "bm_w_famas_desc"
	self.famas.description_id = "des_famas"
	self.famas.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.famas.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.famas.use_data = {selection_index = 2}
	self.famas.DAMAGE = 1
	self.famas.CLIP_AMMO_MAX = 30
	self.famas.NR_CLIPS_MAX = 8
	self.famas.AMMO_MAX = self.famas.CLIP_AMMO_MAX * self.famas.NR_CLIPS_MAX
	self.famas.AMMO_PICKUP = self:_pickup_chance(self.famas.AMMO_MAX, 2)
	self.famas.FIRE_MODE = "auto"
	self.famas.fire_mode_data = {fire_rate = 0.06}
	self.famas.CAN_TOGGLE_FIREMODE = true
	self.famas.auto = {fire_rate = 0.06}
	self.famas.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.famas.kick = {standing = self.new_m4.kick.standing}
	self.famas.kick.crouching = self.famas.kick.standing
	self.famas.kick.steelsight = self.famas.kick.standing
	self.famas.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.famas.crosshair.standing.offset = 0.14
	self.famas.crosshair.standing.moving_offset = 0.8
	self.famas.crosshair.standing.kick_offset = 0.6
	self.famas.crosshair.crouching.offset = 0.1
	self.famas.crosshair.crouching.moving_offset = 0.6
	self.famas.crosshair.crouching.kick_offset = 0.4
	self.famas.crosshair.steelsight.hidden = true
	self.famas.crosshair.steelsight.offset = 0
	self.famas.crosshair.steelsight.moving_offset = 0
	self.famas.crosshair.steelsight.kick_offset = 0.14
	self.famas.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.famas.autohit = autohit_rifle_default
	self.famas.aim_assist = aim_assist_rifle_default
	self.famas.animations = {
		equip_id = "equip_m4",
		recoil_steelsight = true
	}
	self.famas.global_value = "gage_pack_assault"
	self.famas.texture_bundle_folder = "gage_pack_assault"
	self.famas.panic_suppression_chance = 0.2
	self.famas.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 35,
		alert_size = 7,
		spread = 10,
		spread_moving = 8,
		recoil = 18,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 24
	}
	self.scorpion = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.scorpion.sounds.fire = "skorpion_fire_single"
	self.scorpion.sounds.fire_single = "skorpion_fire_single"
	self.scorpion.sounds.fire_auto = "skorpion_fire"
	self.scorpion.sounds.stop_fire = "skorpion_stop"
	self.scorpion.sounds.dryfire = "secondary_dryfire"
	self.scorpion.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.scorpion.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.scorpion.timers = {
		reload_not_empty = 2,
		reload_empty = 2.75,
		unequip = 0.7,
		equip = 0.5
	}
	self.scorpion.name_id = "bm_w_scorpion"
	self.scorpion.desc_id = "bm_w_scorpion_desc"
	self.scorpion.description_id = "des_scorpion"
	self.scorpion.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.scorpion.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.scorpion.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.scorpion.use_data = {selection_index = 1}
	self.scorpion.DAMAGE = 1
	self.scorpion.CLIP_AMMO_MAX = 20
	self.scorpion.NR_CLIPS_MAX = 11
	self.scorpion.AMMO_MAX = self.scorpion.CLIP_AMMO_MAX * self.scorpion.NR_CLIPS_MAX
	self.scorpion.AMMO_PICKUP = self:_pickup_chance(self.scorpion.AMMO_MAX, 2)
	self.scorpion.FIRE_MODE = "auto"
	self.scorpion.fire_mode_data = {fire_rate = 0.06}
	self.scorpion.CAN_TOGGLE_FIREMODE = true
	self.scorpion.auto = {fire_rate = 0.06}
	self.scorpion.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.scorpion.kick = {standing = self.new_m4.kick.standing}
	self.scorpion.kick.crouching = self.scorpion.kick.standing
	self.scorpion.kick.steelsight = self.scorpion.kick.standing
	self.scorpion.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.scorpion.crosshair.standing.offset = 0.5
	self.scorpion.crosshair.standing.moving_offset = 0.8
	self.scorpion.crosshair.standing.kick_offset = 0.7
	self.scorpion.crosshair.crouching.offset = 0.3
	self.scorpion.crosshair.crouching.moving_offset = 0.6
	self.scorpion.crosshair.crouching.kick_offset = 0.5
	self.scorpion.crosshair.steelsight.hidden = true
	self.scorpion.crosshair.steelsight.offset = 0
	self.scorpion.crosshair.steelsight.moving_offset = 0
	self.scorpion.crosshair.steelsight.kick_offset = 0.3
	self.scorpion.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.scorpion.autohit = autohit_smg_default
	self.scorpion.aim_assist = aim_assist_smg_default
	self.scorpion.weapon_hold = "scorpion"
	self.scorpion.animations = {
		equip_id = "equip_scorpion",
		recoil_steelsight = true
	}
	self.scorpion.global_value = "hl_miami"
	self.scorpion.texture_bundle_folder = "hl_miami"
	self.scorpion.panic_suppression_chance = 0.2
	self.scorpion.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 18,
		value = 7,
		extra_ammo = 6,
		reload = 11,
		suppression = 17,
		concealment = 28
	}
	self.tec9 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.tec9.sounds.fire = "tec9_fire_single"
	self.tec9.sounds.fire_single = "tec9_fire_single"
	self.tec9.sounds.fire_auto = "tec9_fire"
	self.tec9.sounds.stop_fire = "tec9_stop"
	self.tec9.sounds.dryfire = "secondary_dryfire"
	self.tec9.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.tec9.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.tec9.timers = {
		reload_not_empty = 2.315,
		reload_empty = 3.28,
		unequip = 0.6,
		equip = 0.5
	}
	self.tec9.name_id = "bm_w_tec9"
	self.tec9.desc_id = "bm_w_tec9_desc"
	self.tec9.description_id = "des_tec9"
	self.tec9.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.tec9.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.tec9.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.tec9.use_data = {selection_index = 1}
	self.tec9.DAMAGE = 1
	self.tec9.CLIP_AMMO_MAX = 20
	self.tec9.NR_CLIPS_MAX = 11
	self.tec9.AMMO_MAX = self.tec9.CLIP_AMMO_MAX * self.tec9.NR_CLIPS_MAX
	self.tec9.AMMO_PICKUP = self:_pickup_chance(self.tec9.AMMO_MAX, 2)
	self.tec9.FIRE_MODE = "auto"
	self.tec9.fire_mode_data = {fire_rate = 0.067}
	self.tec9.CAN_TOGGLE_FIREMODE = true
	self.tec9.auto = {fire_rate = 0.067}
	self.tec9.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.tec9.kick = {standing = self.new_m4.kick.standing}
	self.tec9.kick.crouching = self.tec9.kick.standing
	self.tec9.kick.steelsight = self.tec9.kick.standing
	self.tec9.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.tec9.crosshair.standing.offset = 0.5
	self.tec9.crosshair.standing.moving_offset = 0.8
	self.tec9.crosshair.standing.kick_offset = 0.7
	self.tec9.crosshair.crouching.offset = 0.3
	self.tec9.crosshair.crouching.moving_offset = 0.6
	self.tec9.crosshair.crouching.kick_offset = 0.5
	self.tec9.crosshair.steelsight.hidden = true
	self.tec9.crosshair.steelsight.offset = 0
	self.tec9.crosshair.steelsight.moving_offset = 0
	self.tec9.crosshair.steelsight.kick_offset = 0.3
	self.tec9.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.tec9.autohit = autohit_smg_default
	self.tec9.aim_assist = aim_assist_smg_default
	self.tec9.weapon_hold = "tec9"
	self.tec9.animations = {
		equip_id = "equip_tec9",
		recoil_steelsight = true
	}
	self.tec9.global_value = "hl_miami"
	self.tec9.texture_bundle_folder = "hl_miami"
	self.tec9.panic_suppression_chance = 0.2
	self.tec9.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 20,
		value = 7,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 27
	}
	self.uzi = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.uzi.sounds.fire = "uzi_fire_single"
	self.uzi.sounds.fire_single = "uzi_fire_single"
	self.uzi.sounds.fire_auto = "uzi_fire"
	self.uzi.sounds.stop_fire = "uzi_stop"
	self.uzi.sounds.dryfire = "secondary_dryfire"
	self.uzi.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.uzi.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.uzi.timers = {
		reload_not_empty = 2.45,
		reload_empty = 3.52,
		unequip = 0.55,
		equip = 0.6
	}
	self.uzi.name_id = "bm_w_uzi"
	self.uzi.desc_id = "bm_w_uzi_desc"
	self.uzi.description_id = "des_uzi"
	self.uzi.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.uzi.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.uzi.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.uzi.use_data = {selection_index = 1}
	self.uzi.DAMAGE = 1
	self.uzi.CLIP_AMMO_MAX = 40
	self.uzi.NR_CLIPS_MAX = 5
	self.uzi.AMMO_MAX = self.uzi.CLIP_AMMO_MAX * self.uzi.NR_CLIPS_MAX
	self.uzi.AMMO_PICKUP = self:_pickup_chance(self.uzi.AMMO_MAX, 3)
	self.uzi.FIRE_MODE = "auto"
	self.uzi.fire_mode_data = {fire_rate = 0.086}
	self.uzi.CAN_TOGGLE_FIREMODE = true
	self.uzi.auto = {fire_rate = 0.086}
	self.uzi.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.uzi.kick = {standing = self.new_m4.kick.standing}
	self.uzi.kick.crouching = self.uzi.kick.standing
	self.uzi.kick.steelsight = self.uzi.kick.standing
	self.uzi.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.uzi.crosshair.standing.offset = 0.5
	self.uzi.crosshair.standing.moving_offset = 0.8
	self.uzi.crosshair.standing.kick_offset = 0.7
	self.uzi.crosshair.crouching.offset = 0.3
	self.uzi.crosshair.crouching.moving_offset = 0.6
	self.uzi.crosshair.crouching.kick_offset = 0.5
	self.uzi.crosshair.steelsight.hidden = true
	self.uzi.crosshair.steelsight.offset = 0
	self.uzi.crosshair.steelsight.moving_offset = 0
	self.uzi.crosshair.steelsight.kick_offset = 0.3
	self.uzi.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.uzi.autohit = autohit_smg_default
	self.uzi.aim_assist = aim_assist_smg_default
	self.uzi.weapon_hold = "mp9"
	self.uzi.animations = {
		equip_id = "equip_mp9",
		recoil_steelsight = true
	}
	self.uzi.global_value = "hl_miami"
	self.uzi.texture_bundle_folder = "hl_miami"
	self.uzi.panic_suppression_chance = 0.2
	self.uzi.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 18,
		value = 7,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 24
	}
	self.jowi = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.jowi.sounds.fire = "g17_fire"
	self.jowi.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.jowi.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.jowi.sounds.dryfire = "secondary_dryfire"
	self.jowi.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.jowi.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.jowi.name_id = "bm_w_jowi"
	self.jowi.desc_id = "bm_w_jowi_desc"
	self.jowi.description_id = "des_jowi"
	self.jowi.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.jowi.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.jowi.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.jowi.use_data = {selection_index = 2}
	self.jowi.DAMAGE = 1
	self.jowi.CLIP_AMMO_MAX = 20
	self.jowi.NR_CLIPS_MAX = 8
	self.jowi.AMMO_MAX = self.jowi.CLIP_AMMO_MAX * self.jowi.NR_CLIPS_MAX
	self.jowi.AMMO_PICKUP = self:_pickup_chance(self.jowi.AMMO_MAX, 1)
	self.jowi.FIRE_MODE = "single"
	self.jowi.fire_mode_data = {fire_rate = 0.09}
	self.jowi.single = {fire_rate = 0.09}
	self.jowi.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.jowi.kick = {standing = {
		1.4,
		1.2,
		-0.5,
		0.5
	}}
	self.jowi.kick.crouching = self.jowi.kick.standing
	self.jowi.kick.steelsight = self.jowi.kick.standing
	self.jowi.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.jowi.crosshair.standing.offset = 0.2
	self.jowi.crosshair.standing.moving_offset = 0.6
	self.jowi.crosshair.standing.kick_offset = 0.4
	self.jowi.crosshair.crouching.offset = 0.1
	self.jowi.crosshair.crouching.moving_offset = 0.6
	self.jowi.crosshair.crouching.kick_offset = 0.3
	self.jowi.crosshair.steelsight.hidden = true
	self.jowi.crosshair.steelsight.offset = 0
	self.jowi.crosshair.steelsight.moving_offset = 0
	self.jowi.crosshair.steelsight.kick_offset = 0.1
	self.jowi.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.jowi.autohit = autohit_pistol_default
	self.jowi.aim_assist = aim_assist_pistol_default
	self.jowi.weapon_hold = "jowi_pistol"
	self.jowi.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.jowi.panic_suppression_chance = 0.2
	self.jowi.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 30
	}
	self.x_1911 = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_1911.sounds.fire = "c45_fire"
	self.x_1911.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_1911.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_1911.sounds.dryfire = "secondary_dryfire"
	self.x_1911.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_1911.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_1911.name_id = "bm_w_x_1911"
	self.x_1911.desc_id = "bm_w_x_1911_desc"
	self.x_1911.description_id = "des_x_1911"
	self.x_1911.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_1911.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_1911.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_1911.use_data = {selection_index = 2}
	self.x_1911.DAMAGE = 1
	self.x_1911.CLIP_AMMO_MAX = 20
	self.x_1911.NR_CLIPS_MAX = 5
	self.x_1911.AMMO_MAX = self.x_1911.CLIP_AMMO_MAX * self.x_1911.NR_CLIPS_MAX
	self.x_1911.AMMO_PICKUP = self:_pickup_chance(self.x_1911.AMMO_MAX, 1)
	self.x_1911.FIRE_MODE = "single"
	self.x_1911.fire_mode_data = {fire_rate = 0.166}
	self.x_1911.single = {fire_rate = 0.166}
	self.x_1911.spread = {
		standing = self.colt_1911.spread.standing,
		crouching = self.colt_1911.spread.crouching,
		steelsight = self.colt_1911.spread.steelsight,
		moving_standing = self.colt_1911.spread.moving_standing,
		moving_crouching = self.colt_1911.spread.moving_crouching,
		moving_steelsight = self.colt_1911.spread.moving_steelsight
	}
	self.x_1911.kick = {standing = {
		1.6,
		1.3,
		-0.3,
		0.3
	}}
	self.x_1911.kick.crouching = self.x_1911.kick.standing
	self.x_1911.kick.steelsight = self.x_1911.kick.standing
	self.x_1911.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_1911.crosshair.standing.offset = 0.2
	self.x_1911.crosshair.standing.moving_offset = 0.6
	self.x_1911.crosshair.standing.kick_offset = 0.4
	self.x_1911.crosshair.crouching.offset = 0.1
	self.x_1911.crosshair.crouching.moving_offset = 0.6
	self.x_1911.crosshair.crouching.kick_offset = 0.3
	self.x_1911.crosshair.steelsight.hidden = true
	self.x_1911.crosshair.steelsight.offset = 0
	self.x_1911.crosshair.steelsight.moving_offset = 0
	self.x_1911.crosshair.steelsight.kick_offset = 0.1
	self.x_1911.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_1911.autohit = autohit_pistol_default
	self.x_1911.aim_assist = aim_assist_pistol_default
	self.x_1911.weapon_hold = "jowi_pistol"
	self.x_1911.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.x_1911.panic_suppression_chance = 0.2
	self.x_1911.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 27
	}
	self.x_b92fs = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_b92fs.sounds.fire = "beretta_fire"
	self.x_b92fs.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_b92fs.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_b92fs.sounds.dryfire = "secondary_dryfire"
	self.x_b92fs.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_b92fs.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_b92fs.name_id = "bm_w_x_b92fs"
	self.x_b92fs.desc_id = "bm_w_x_b92fs_desc"
	self.x_b92fs.description_id = "des_x_b92fs"
	self.x_b92fs.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_b92fs.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_b92fs.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_b92fs.use_data = {selection_index = 2}
	self.x_b92fs.DAMAGE = 1
	self.x_b92fs.CLIP_AMMO_MAX = 28
	self.x_b92fs.NR_CLIPS_MAX = 6
	self.x_b92fs.AMMO_MAX = self.x_b92fs.CLIP_AMMO_MAX * self.x_b92fs.NR_CLIPS_MAX
	self.x_b92fs.AMMO_PICKUP = self:_pickup_chance(self.x_b92fs.AMMO_MAX, 1)
	self.x_b92fs.FIRE_MODE = "single"
	self.x_b92fs.fire_mode_data = {fire_rate = 0.09}
	self.x_b92fs.single = {fire_rate = 0.09}
	self.x_b92fs.spread = {
		standing = self.b92fs.spread.standing,
		crouching = self.b92fs.spread.crouching,
		steelsight = self.b92fs.spread.steelsight,
		moving_standing = self.b92fs.spread.moving_standing,
		moving_crouching = self.b92fs.spread.moving_crouching,
		moving_steelsight = self.b92fs.spread.moving_steelsight
	}
	self.x_b92fs.kick = {
		1.5,
		1.2,
		-0.3,
		0.3,
		standing = self.glock_17.kick.standing
	}
	self.x_b92fs.kick.crouching = self.x_b92fs.kick.standing
	self.x_b92fs.kick.steelsight = self.x_b92fs.kick.standing
	self.x_b92fs.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_b92fs.crosshair.standing.offset = 0.2
	self.x_b92fs.crosshair.standing.moving_offset = 0.6
	self.x_b92fs.crosshair.standing.kick_offset = 0.4
	self.x_b92fs.crosshair.crouching.offset = 0.1
	self.x_b92fs.crosshair.crouching.moving_offset = 0.6
	self.x_b92fs.crosshair.crouching.kick_offset = 0.3
	self.x_b92fs.crosshair.steelsight.hidden = true
	self.x_b92fs.crosshair.steelsight.offset = 0
	self.x_b92fs.crosshair.steelsight.moving_offset = 0
	self.x_b92fs.crosshair.steelsight.kick_offset = 0.1
	self.x_b92fs.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_b92fs.autohit = autohit_pistol_default
	self.x_b92fs.aim_assist = aim_assist_pistol_default
	self.x_b92fs.weapon_hold = "jowi_pistol"
	self.x_b92fs.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.x_b92fs.panic_suppression_chance = 0.2
	self.x_b92fs.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 17,
		concealment = 28
	}
	self.x_deagle = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_deagle.sounds.fire = "deagle_fire"
	self.x_deagle.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_deagle.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_deagle.sounds.dryfire = "secondary_dryfire"
	self.x_deagle.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_deagle.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_deagle.name_id = "bm_w_x_deagle"
	self.x_deagle.desc_id = "bm_w_x_deagle_desc"
	self.x_deagle.description_id = "des_x_deagle"
	self.x_deagle.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.x_deagle.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_deagle.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_deagle.use_data = {selection_index = 2}
	self.x_deagle.DAMAGE = 1
	self.x_deagle.CLIP_AMMO_MAX = 20
	self.x_deagle.NR_CLIPS_MAX = 3
	self.x_deagle.AMMO_MAX = self.x_deagle.CLIP_AMMO_MAX * self.x_deagle.NR_CLIPS_MAX
	self.x_deagle.AMMO_PICKUP = self:_pickup_chance(self.x_deagle.AMMO_MAX, 1)
	self.x_deagle.FIRE_MODE = "single"
	self.x_deagle.fire_mode_data = {fire_rate = 0.25}
	self.x_deagle.single = {fire_rate = 0.25}
	self.x_deagle.spread = {
		standing = self.deagle.spread.standing,
		crouching = self.deagle.spread.crouching,
		steelsight = self.deagle.spread.steelsight,
		moving_standing = self.deagle.spread.moving_standing,
		moving_crouching = self.deagle.spread.moving_crouching,
		moving_steelsight = self.deagle.spread.moving_steelsight
	}
	self.x_deagle.kick = {standing = {
		1,
		0.9,
		-0.3,
		0.3
	}}
	self.x_deagle.kick.crouching = self.x_deagle.kick.standing
	self.x_deagle.kick.steelsight = self.x_deagle.kick.standing
	self.x_deagle.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_deagle.crosshair.standing.offset = 0.2
	self.x_deagle.crosshair.standing.moving_offset = 0.6
	self.x_deagle.crosshair.standing.kick_offset = 0.4
	self.x_deagle.crosshair.crouching.offset = 0.1
	self.x_deagle.crosshair.crouching.moving_offset = 0.6
	self.x_deagle.crosshair.crouching.kick_offset = 0.2
	self.x_deagle.crosshair.steelsight.hidden = true
	self.x_deagle.crosshair.steelsight.offset = 0.1
	self.x_deagle.crosshair.steelsight.moving_offset = 0.1
	self.x_deagle.crosshair.steelsight.kick_offset = 0.2
	self.x_deagle.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = -2
	}
	self.x_deagle.autohit = autohit_pistol_default
	self.x_deagle.aim_assist = aim_assist_pistol_default
	self.x_deagle.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.x_deagle.panic_suppression_chance = 0.2
	self.x_deagle.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 120,
		alert_size = 7,
		spread = 20,
		spread_moving = 4,
		recoil = 8,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 26
	}
	self.g26 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.g26.sounds.fire = "g17_fire"
	self.g26.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.g26.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.g26.sounds.dryfire = "secondary_dryfire"
	self.g26.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.g26.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.g26.name_id = "bm_wp_pis_g26"
	self.g26.desc_id = "bm_wp_pis_g26_desc"
	self.g26.description_id = "des_g26"
	self.g26.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.g26.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.g26.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.g26.use_data = {selection_index = 1}
	self.g26.DAMAGE = 1
	self.g26.CLIP_AMMO_MAX = 10
	self.g26.NR_CLIPS_MAX = 15
	self.g26.AMMO_MAX = self.g26.CLIP_AMMO_MAX * self.g26.NR_CLIPS_MAX
	self.g26.AMMO_PICKUP = self:_pickup_chance(self.g26.AMMO_MAX, 1)
	self.g26.FIRE_MODE = "single"
	self.g26.fire_mode_data = {fire_rate = 0.125}
	self.g26.single = {fire_rate = 0.125}
	self.g26.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.g26.kick = {standing = self.glock_17.kick.standing}
	self.g26.kick.crouching = self.g26.kick.standing
	self.g26.kick.steelsight = self.g26.kick.standing
	self.g26.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.g26.crosshair.standing.offset = 0.2
	self.g26.crosshair.standing.moving_offset = 0.6
	self.g26.crosshair.standing.kick_offset = 0.4
	self.g26.crosshair.crouching.offset = 0.1
	self.g26.crosshair.crouching.moving_offset = 0.6
	self.g26.crosshair.crouching.kick_offset = 0.3
	self.g26.crosshair.steelsight.hidden = true
	self.g26.crosshair.steelsight.offset = 0
	self.g26.crosshair.steelsight.moving_offset = 0
	self.g26.crosshair.steelsight.kick_offset = 0.1
	self.g26.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.g26.autohit = autohit_pistol_default
	self.g26.aim_assist = aim_assist_pistol_default
	self.g26.weapon_hold = "glock"
	self.g26.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.g26.global_value = "pd2_clan"
	self.g26.panic_suppression_chance = 0.2
	self.g26.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 18,
		concealment = 30
	}
	self.spas12 = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.spas12.sounds.fire = "spas_fire"
	self.spas12.sounds.dryfire = "shotgun_dryfire"
	self.spas12.sounds.stop_fire = "shotgun_dryfire"
	self.spas12.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.spas12.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.spas12.timers = {
		unequip = 0.85,
		equip = 0.85
	}
	self.spas12.name_id = "bm_w_spas12"
	self.spas12.desc_id = "bm_w_spas12_desc"
	self.spas12.description_id = "des_spas12"
	self.spas12.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.spas12.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.spas12.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.spas12.DAMAGE = 6
	self.spas12.damage_near = 2000
	self.spas12.damage_far = 3000
	self.spas12.rays = 12
	self.spas12.CLIP_AMMO_MAX = 6
	self.spas12.NR_CLIPS_MAX = 11
	self.spas12.AMMO_MAX = self.spas12.CLIP_AMMO_MAX * self.spas12.NR_CLIPS_MAX
	self.spas12.AMMO_PICKUP = self:_pickup_chance(self.spas12.AMMO_MAX, 4)
	self.spas12.FIRE_MODE = "single"
	self.spas12.fire_mode_data = {fire_rate = 0.2}
	self.spas12.CAN_TOGGLE_FIREMODE = false
	self.spas12.single = {fire_rate = 0.2}
	self.spas12.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.spas12.kick = {standing = {
		1.8,
		1.5,
		-0.5,
		0.8
	}}
	self.spas12.kick.crouching = self.spas12.kick.standing
	self.spas12.kick.steelsight = self.spas12.kick.standing
	self.spas12.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.spas12.crosshair.standing.offset = 0.6
	self.spas12.crosshair.standing.moving_offset = 0.8
	self.spas12.crosshair.standing.kick_offset = 0.8
	self.spas12.crosshair.crouching.offset = 0.75
	self.spas12.crosshair.crouching.moving_offset = 0.85
	self.spas12.crosshair.crouching.kick_offset = 0.95
	self.spas12.crosshair.steelsight.hidden = true
	self.spas12.crosshair.steelsight.offset = 0.85
	self.spas12.crosshair.steelsight.moving_offset = 0.95
	self.spas12.crosshair.steelsight.kick_offset = 0.95
	self.spas12.shake = {
		fire_multiplier = 2.4,
		fire_steelsight_multiplier = 1.45
	}
	self.spas12.autohit = autohit_shotgun_default
	self.spas12.aim_assist = aim_assist_shotgun_default
	self.spas12.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.spas12.global_value = "pd2_clan"
	self.spas12.panic_suppression_chance = 0.2
	self.spas12.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 55,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 14
	}
	self.mg42 = {
		categories = {"lmg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.mg42.sounds.fire = "mg42_fire_single"
	self.mg42.sounds.fire_single = "mg42_fire_single"
	self.mg42.sounds.fire_auto = "mg42_fire"
	self.mg42.sounds.stop_fire = "mg42_stop"
	self.mg42.sounds.dryfire = "primary_dryfire"
	self.mg42.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.mg42.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.mg42.timers = {
		reload_not_empty = 6.5,
		reload_empty = 6.5,
		unequip = 0.9,
		equip = 0.9,
		deploy_bipod = 1
	}
	self.mg42.bipod_camera_spin_limit = 40
	self.mg42.bipod_camera_pitch_limit = 15
	self.mg42.bipod_weapon_translation = Vector3(-8.5, 20, -7.5)
	self.mg42.bipod_deploy_multiplier = 1
	self.mg42.name_id = "bm_w_mg42"
	self.mg42.desc_id = "bm_w_mg42_desc"
	self.mg42.description_id = "des_mg42"
	self.mg42.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.mg42.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.mg42.use_data = {selection_index = 2}
	self.mg42.DAMAGE = 1
	self.mg42.CLIP_AMMO_MAX = 150
	self.mg42.NR_CLIPS_MAX = 3
	self.mg42.AMMO_MAX = self.mg42.CLIP_AMMO_MAX * self.mg42.NR_CLIPS_MAX
	self.mg42.AMMO_PICKUP = self:_pickup_chance(self.mg42.AMMO_MAX, 1)
	self.mg42.FIRE_MODE = "auto"
	self.mg42.fire_mode_data = {fire_rate = 0.05}
	self.mg42.CAN_TOGGLE_FIREMODE = false
	self.mg42.auto = {fire_rate = 0.05}
	self.mg42.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight,
		bipod = default_bipod_spread
	}
	self.mg42.kick = {standing = {
		-0.2,
		0.8,
		-1,
		1.4
	}}
	self.mg42.kick.crouching = self.mg42.kick.standing
	self.mg42.kick.steelsight = self.mg42.kick.standing
	self.mg42.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.mg42.crosshair.standing.offset = 0.16
	self.mg42.crosshair.standing.moving_offset = 1
	self.mg42.crosshair.standing.kick_offset = 0.8
	self.mg42.crosshair.crouching.offset = 0.1
	self.mg42.crosshair.crouching.moving_offset = 0.6
	self.mg42.crosshair.crouching.kick_offset = 0.4
	self.mg42.crosshair.steelsight.hidden = true
	self.mg42.crosshair.steelsight.offset = 0
	self.mg42.crosshair.steelsight.moving_offset = 0
	self.mg42.crosshair.steelsight.kick_offset = 0.14
	self.mg42.shake = {
		fire_multiplier = 0.5,
		fire_steelsight_multiplier = -0.5
	}
	self.mg42.autohit = autohit_lmg_default
	self.mg42.aim_assist = aim_assist_lmg_default
	self.mg42.weapon_hold = "mg42"
	self.mg42.animations = {
		equip_id = "equip_mg42",
		recoil_steelsight = true,
		bipod_enter = "bipod_enter",
		bipod_exit = "bipod_exit",
		bipod_recoil = "bipod_recoil",
		bipod_recoil_enter = "bipod_recoil",
		bipod_recoil_loop = "bipod_recoil_loop",
		bipod_recoil_exit = "bipod_recoil_exit"
	}
	self.mg42.global_value = "gage_pack_historical"
	self.mg42.texture_bundle_folder = "gage_pack_historical"
	self.mg42.panic_suppression_chance = 0.2
	self.mg42.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 8,
		spread = 8,
		spread_moving = 8,
		recoil = 10,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 2
	}
	self.c96 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.c96.sounds.fire = "c96_fire"
	self.c96.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.c96.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.c96.sounds.dryfire = "secondary_dryfire"
	self.c96.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.c96.timers = {
		reload_not_empty = 4,
		reload_empty = 4.17,
		unequip = 0.5,
		equip = 0.35
	}
	self.c96.name_id = "bm_w_c96"
	self.c96.desc_id = "bm_w_c96_desc"
	self.c96.description_id = "des_c96"
	self.c96.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.c96.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.c96.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.c96.use_data = {selection_index = 1}
	self.c96.DAMAGE = 1
	self.c96.CLIP_AMMO_MAX = 10
	self.c96.NR_CLIPS_MAX = 9
	self.c96.AMMO_MAX = self.c96.CLIP_AMMO_MAX * self.c96.NR_CLIPS_MAX
	self.c96.AMMO_PICKUP = self:_pickup_chance(self.c96.AMMO_MAX, 1)
	self.c96.FIRE_MODE = "single"
	self.c96.fire_mode_data = {fire_rate = 0.166}
	self.c96.single = {fire_rate = 0.166}
	self.c96.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.c96.kick = {standing = self.glock_17.kick.standing}
	self.c96.kick.crouching = self.c96.kick.standing
	self.c96.kick.steelsight = self.c96.kick.standing
	self.c96.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.c96.crosshair.standing.offset = 0.2
	self.c96.crosshair.standing.moving_offset = 0.6
	self.c96.crosshair.standing.kick_offset = 0.4
	self.c96.crosshair.crouching.offset = 0.1
	self.c96.crosshair.crouching.moving_offset = 0.6
	self.c96.crosshair.crouching.kick_offset = 0.3
	self.c96.crosshair.steelsight.hidden = true
	self.c96.crosshair.steelsight.offset = 0
	self.c96.crosshair.steelsight.moving_offset = 0
	self.c96.crosshair.steelsight.kick_offset = 0.1
	self.c96.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.c96.autohit = autohit_pistol_default
	self.c96.aim_assist = aim_assist_pistol_default
	self.c96.weapon_hold = "glock"
	self.c96.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.c96.global_value = "gage_pack_historical"
	self.c96.texture_bundle_folder = "gage_pack_historical"
	self.c96.panic_suppression_chance = 0.2
	self.c96.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 21,
		spread_moving = 12,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 28
	}
	self.sterling = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.sterling.sounds.fire = "sterling_fire_single"
	self.sterling.sounds.fire_single = "sterling_fire_single"
	self.sterling.sounds.fire_auto = "sterling_fire"
	self.sterling.sounds.stop_fire = "sterling_stop"
	self.sterling.sounds.dryfire = "secondary_dryfire"
	self.sterling.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.sterling.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.sterling.timers = {
		reload_not_empty = 2.3,
		reload_empty = 3.3,
		unequip = 0.55,
		equip = 0.65
	}
	self.sterling.name_id = "bm_w_sterling"
	self.sterling.desc_id = "bm_w_sterling_desc"
	self.sterling.description_id = "des_sterling"
	self.sterling.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.sterling.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.sterling.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sterling.use_data = {selection_index = 1}
	self.sterling.DAMAGE = 1
	self.sterling.CLIP_AMMO_MAX = 20
	self.sterling.NR_CLIPS_MAX = 11
	self.sterling.AMMO_MAX = self.sterling.CLIP_AMMO_MAX * self.sterling.NR_CLIPS_MAX
	self.sterling.AMMO_PICKUP = self:_pickup_chance(self.sterling.AMMO_MAX, 2)
	self.sterling.FIRE_MODE = "auto"
	self.sterling.fire_mode_data = {fire_rate = 0.11}
	self.sterling.CAN_TOGGLE_FIREMODE = true
	self.sterling.auto = {fire_rate = 0.11}
	self.sterling.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.sterling.kick = {standing = self.new_m4.kick.standing}
	self.sterling.kick.crouching = self.sterling.kick.standing
	self.sterling.kick.steelsight = self.sterling.kick.standing
	self.sterling.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.sterling.crosshair.standing.offset = 0.5
	self.sterling.crosshair.standing.moving_offset = 0.8
	self.sterling.crosshair.standing.kick_offset = 0.7
	self.sterling.crosshair.crouching.offset = 0.3
	self.sterling.crosshair.crouching.moving_offset = 0.6
	self.sterling.crosshair.crouching.kick_offset = 0.5
	self.sterling.crosshair.steelsight.hidden = true
	self.sterling.crosshair.steelsight.offset = 0
	self.sterling.crosshair.steelsight.moving_offset = 0
	self.sterling.crosshair.steelsight.kick_offset = 0.3
	self.sterling.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.sterling.autohit = autohit_smg_default
	self.sterling.aim_assist = aim_assist_smg_default
	self.sterling.weapon_hold = "sterling"
	self.sterling.animations = {
		equip_id = "equip_sterling",
		recoil_steelsight = true
	}
	self.sterling.global_value = "gage_pack_historical"
	self.sterling.texture_bundle_folder = "gage_pack_historical"
	self.sterling.panic_suppression_chance = 0.2
	self.sterling.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 20,
		value = 7,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 20
	}
	self.mosin = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.mosin.sounds.fire = "nagant_fire"
	self.mosin.sounds.dryfire = "primary_dryfire"
	self.mosin.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.mosin.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.mosin.timers = {
		reload_not_empty = 3.85,
		reload_empty = 3.85,
		unequip = 0.6,
		equip = 0.5
	}
	self.mosin.name_id = "bm_w_mosin"
	self.mosin.desc_id = "bm_w_mosin_desc"
	self.mosin.description_id = "des_mosin"
	self.mosin.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.mosin.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.mosin.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.mosin.DAMAGE = 1
	self.mosin.CLIP_AMMO_MAX = 5
	self.mosin.NR_CLIPS_MAX = 5
	self.mosin.AMMO_MAX = self.mosin.CLIP_AMMO_MAX * self.mosin.NR_CLIPS_MAX
	self.mosin.AMMO_PICKUP = {
		0.7,
		1
	}
	self.mosin.FIRE_MODE = "single"
	self.mosin.fire_mode_data = {fire_rate = 1}
	self.mosin.CAN_TOGGLE_FIREMODE = false
	self.mosin.single = {fire_rate = 20}
	self.mosin.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.mosin.kick = {standing = {
		3,
		4.8,
		-0.3,
		0.3
	}}
	self.mosin.kick.crouching = self.mosin.kick.standing
	self.mosin.kick.steelsight = self.mosin.kick.standing
	self.mosin.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.mosin.crosshair.standing.offset = 1.14
	self.mosin.crosshair.standing.moving_offset = 1.8
	self.mosin.crosshair.standing.kick_offset = 1.6
	self.mosin.crosshair.crouching.offset = 1.1
	self.mosin.crosshair.crouching.moving_offset = 1.6
	self.mosin.crosshair.crouching.kick_offset = 1.4
	self.mosin.crosshair.steelsight.hidden = true
	self.mosin.crosshair.steelsight.offset = 1
	self.mosin.crosshair.steelsight.moving_offset = 1
	self.mosin.crosshair.steelsight.kick_offset = 1.14
	self.mosin.shake = {
		fire_multiplier = 3.5,
		fire_steelsight_multiplier = -3.5
	}
	self.mosin.autohit = autohit_snp_default
	self.mosin.aim_assist = aim_assist_snp_default
	self.mosin.weapon_hold = "mosin"
	self.mosin.animations = {
		equip_id = "equip_mosin",
		recoil_steelsight = true
	}
	self.mosin.global_value = "gage_pack_historical"
	self.mosin.texture_bundle_folder = "gage_pack_historical"
	self.mosin.can_shoot_through_enemy = true
	self.mosin.can_shoot_through_shield = true
	self.mosin.can_shoot_through_wall = true
	self.mosin.panic_suppression_chance = 0.2
	self.mosin.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 150,
		alert_size = 7,
		spread = 24,
		spread_moving = 24,
		recoil = 4,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 6
	}
	self.mosin.armor_piercing_chance = 1
	self.mosin.stats_modifiers = {damage = 2}
	self.m1928 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m1928.sounds.fire = "m1928_fire_single"
	self.m1928.sounds.fire_single = "m1928_fire_single"
	self.m1928.sounds.fire_auto = "m1928_fire"
	self.m1928.sounds.stop_fire = "m1928_stop"
	self.m1928.sounds.dryfire = "primary_dryfire"
	self.m1928.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.m1928.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.m1928.timers = {
		reload_not_empty = 3.5,
		reload_empty = 4.5,
		unequip = 0.6,
		equip = 0.75
	}
	self.m1928.name_id = "bm_w_m1928"
	self.m1928.desc_id = "bm_w_m1928_desc"
	self.m1928.description_id = "des_m1928"
	self.m1928.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.m1928.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.m1928.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.m1928.use_data = {selection_index = 1}
	self.m1928.DAMAGE = 1
	self.m1928.CLIP_AMMO_MAX = 50
	self.m1928.NR_CLIPS_MAX = 3
	self.m1928.AMMO_MAX = self.m1928.CLIP_AMMO_MAX * self.m1928.NR_CLIPS_MAX
	self.m1928.AMMO_PICKUP = self:_pickup_chance(self.m1928.AMMO_MAX, 3)
	self.m1928.FIRE_MODE = "auto"
	self.m1928.fire_mode_data = {fire_rate = 0.083}
	self.m1928.CAN_TOGGLE_FIREMODE = true
	self.m1928.auto = {fire_rate = 0.083}
	self.m1928.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.m1928.kick = {standing = {
		0.3,
		1.5,
		-1.2,
		1.2
	}}
	self.m1928.kick.crouching = self.m1928.kick.standing
	self.m1928.kick.steelsight = self.m1928.kick.standing
	self.m1928.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m1928.crosshair.standing.offset = 0.16
	self.m1928.crosshair.standing.moving_offset = 1
	self.m1928.crosshair.standing.kick_offset = 0.8
	self.m1928.crosshair.crouching.offset = 0.1
	self.m1928.crosshair.crouching.moving_offset = 0.6
	self.m1928.crosshair.crouching.kick_offset = 0.4
	self.m1928.crosshair.steelsight.hidden = true
	self.m1928.crosshair.steelsight.offset = 0
	self.m1928.crosshair.steelsight.moving_offset = 0
	self.m1928.crosshair.steelsight.kick_offset = 0.14
	self.m1928.shake = {
		fire_multiplier = 0.4,
		fire_steelsight_multiplier = -0.4
	}
	self.m1928.autohit = autohit_smg_default
	self.m1928.aim_assist = aim_assist_smg_default
	self.m1928.weapon_hold = "tommy"
	self.m1928.animations = {
		equip_id = "equip_m1928",
		recoil_steelsight = true
	}
	self.m1928.global_value = "pd2_clan"
	self.m1928.texture_bundle_folder = "pines"
	self.m1928.panic_suppression_chance = 0.2
	self.m1928.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 8,
		spread = 13,
		spread_moving = 13,
		recoil = 18,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 18
	}
	self.l85a2 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.l85a2.sounds.fire = "l85_fire_single"
	self.l85a2.sounds.fire_single = "l85_fire_single"
	self.l85a2.sounds.fire_auto = "l85_fire"
	self.l85a2.sounds.stop_fire = "l85_stop"
	self.l85a2.sounds.dryfire = "primary_dryfire"
	self.l85a2.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.l85a2.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.l85a2.timers = {
		reload_not_empty = 3.5,
		reload_empty = 4.5,
		unequip = 0.45,
		equip = 0.75
	}
	self.l85a2.name_id = "bm_w_l85a2"
	self.l85a2.desc_id = "bm_w_l85a2_desc"
	self.l85a2.description_id = "des_l85a2"
	self.l85a2.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.l85a2.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.l85a2.use_data = {selection_index = 2}
	self.l85a2.DAMAGE = 1
	self.l85a2.CLIP_AMMO_MAX = 30
	self.l85a2.NR_CLIPS_MAX = 5
	self.l85a2.AMMO_MAX = self.l85a2.CLIP_AMMO_MAX * self.l85a2.NR_CLIPS_MAX
	self.l85a2.AMMO_PICKUP = self:_pickup_chance(self.l85a2.AMMO_MAX, 3)
	self.l85a2.FIRE_MODE = "auto"
	self.l85a2.fire_mode_data = {fire_rate = 0.083}
	self.l85a2.CAN_TOGGLE_FIREMODE = true
	self.l85a2.auto = {fire_rate = 0.083}
	self.l85a2.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.l85a2.kick = {standing = {
		0.8,
		1.1,
		-1.2,
		1.2
	}}
	self.l85a2.kick.crouching = self.l85a2.kick.standing
	self.l85a2.kick.steelsight = self.l85a2.kick.standing
	self.l85a2.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.l85a2.crosshair.standing.offset = 0.16
	self.l85a2.crosshair.standing.moving_offset = 1
	self.l85a2.crosshair.standing.kick_offset = 0.8
	self.l85a2.crosshair.crouching.offset = 0.1
	self.l85a2.crosshair.crouching.moving_offset = 0.6
	self.l85a2.crosshair.crouching.kick_offset = 0.4
	self.l85a2.crosshair.steelsight.hidden = true
	self.l85a2.crosshair.steelsight.offset = 0
	self.l85a2.crosshair.steelsight.moving_offset = 0
	self.l85a2.crosshair.steelsight.kick_offset = 0.14
	self.l85a2.shake = {
		fire_multiplier = 0.4,
		fire_steelsight_multiplier = -0.4
	}
	self.l85a2.autohit = autohit_rifle_default
	self.l85a2.aim_assist = aim_assist_rifle_default
	self.l85a2.weapon_hold = "l85a2"
	self.l85a2.animations = {
		equip_id = "equip_l85a2",
		recoil_steelsight = true
	}
	self.l85a2.global_value = "character_pack_clover"
	self.l85a2.texture_bundle_folder = "character_pack_clover"
	self.l85a2.panic_suppression_chance = 0.2
	self.l85a2.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 8,
		spread = 17,
		spread_moving = 15,
		recoil = 16,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 16
	}
	self.vhs = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.vhs.sounds.fire = "vhs_fire_single"
	self.vhs.sounds.fire_single = "vhs_fire_single"
	self.vhs.sounds.fire_auto = "vhs_fire"
	self.vhs.sounds.stop_fire = "vhs_stop"
	self.vhs.sounds.dryfire = "primary_dryfire"
	self.vhs.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.vhs.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.vhs.timers = {
		reload_not_empty = 3.2,
		reload_empty = 4.75,
		unequip = 0.6,
		equip = 0.6
	}
	self.vhs.name_id = "bm_w_vhs"
	self.vhs.desc_id = "bm_w_vhs_desc"
	self.vhs.description_id = "des_vhs"
	self.vhs.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.vhs.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.vhs.use_data = {selection_index = 2}
	self.vhs.DAMAGE = 1
	self.vhs.CLIP_AMMO_MAX = 30
	self.vhs.NR_CLIPS_MAX = 5
	self.vhs.AMMO_MAX = self.vhs.CLIP_AMMO_MAX * self.vhs.NR_CLIPS_MAX
	self.vhs.AMMO_PICKUP = self:_pickup_chance(self.vhs.AMMO_MAX, 3)
	self.vhs.FIRE_MODE = "auto"
	self.vhs.fire_mode_data = {fire_rate = 0.07}
	self.vhs.CAN_TOGGLE_FIREMODE = true
	self.vhs.auto = {fire_rate = 0.07}
	self.vhs.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.vhs.kick = {standing = {
		0.6,
		0.8,
		-1,
		1
	}}
	self.vhs.kick.crouching = self.vhs.kick.standing
	self.vhs.kick.steelsight = self.vhs.kick.standing
	self.vhs.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.vhs.crosshair.standing.offset = 0.16
	self.vhs.crosshair.standing.moving_offset = 1
	self.vhs.crosshair.standing.kick_offset = 0.8
	self.vhs.crosshair.crouching.offset = 0.1
	self.vhs.crosshair.crouching.moving_offset = 0.6
	self.vhs.crosshair.crouching.kick_offset = 0.4
	self.vhs.crosshair.steelsight.hidden = true
	self.vhs.crosshair.steelsight.offset = 0
	self.vhs.crosshair.steelsight.moving_offset = 0
	self.vhs.crosshair.steelsight.kick_offset = 0.14
	self.vhs.shake = {
		fire_multiplier = 0.3,
		fire_steelsight_multiplier = -0.3
	}
	self.vhs.autohit = autohit_rifle_default
	self.vhs.aim_assist = aim_assist_rifle_default
	self.vhs.weapon_hold = "vhs"
	self.vhs.animations = {
		equip_id = "equip_vhs",
		recoil_steelsight = true
	}
	self.vhs.global_value = "character_pack_dragan"
	self.vhs.texture_bundle_folder = "character_pack_dragan"
	self.vhs.panic_suppression_chance = 0.2
	self.vhs.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 8,
		spread = 16,
		spread_moving = 15,
		recoil = 16,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 17
	}
	self.hs2000 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.hs2000.sounds.fire = "p226r_fire"
	self.hs2000.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.hs2000.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.hs2000.sounds.dryfire = "secondary_dryfire"
	self.hs2000.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.hs2000.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.5
	}
	self.hs2000.name_id = "bm_w_hs2000"
	self.hs2000.desc_id = "bm_w_hs2000_desc"
	self.hs2000.description_id = "des_hs2000"
	self.hs2000.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.hs2000.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.hs2000.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.hs2000.use_data = {selection_index = 1}
	self.hs2000.DAMAGE = 1
	self.hs2000.CLIP_AMMO_MAX = 19
	self.hs2000.NR_CLIPS_MAX = 5
	self.hs2000.AMMO_MAX = self.hs2000.CLIP_AMMO_MAX * self.hs2000.NR_CLIPS_MAX
	self.hs2000.AMMO_PICKUP = self:_pickup_chance(self.hs2000.AMMO_MAX, 1)
	self.hs2000.FIRE_MODE = "single"
	self.hs2000.fire_mode_data = {fire_rate = 0.166}
	self.hs2000.single = {fire_rate = 0.166}
	self.hs2000.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.hs2000.kick = {standing = self.glock_17.kick.standing}
	self.hs2000.kick.crouching = self.hs2000.kick.standing
	self.hs2000.kick.steelsight = self.hs2000.kick.standing
	self.hs2000.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.hs2000.crosshair.standing.offset = 0.1
	self.hs2000.crosshair.standing.moving_offset = 0.4
	self.hs2000.crosshair.standing.kick_offset = 0.3
	self.hs2000.crosshair.crouching.offset = 0.1
	self.hs2000.crosshair.crouching.moving_offset = 0.5
	self.hs2000.crosshair.crouching.kick_offset = 0.2
	self.hs2000.crosshair.steelsight.hidden = true
	self.hs2000.crosshair.steelsight.offset = 0
	self.hs2000.crosshair.steelsight.moving_offset = 0
	self.hs2000.crosshair.steelsight.kick_offset = 0.1
	self.hs2000.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.hs2000.autohit = autohit_pistol_default
	self.hs2000.aim_assist = aim_assist_pistol_default
	self.hs2000.weapon_hold = "glock"
	self.hs2000.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.hs2000.global_value = "the_bomb"
	self.hs2000.texture_bundle_folder = "the_bomb"
	self.hs2000.panic_suppression_chance = 0.2
	self.hs2000.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.m134 = {
		categories = {"minigun"},
		has_description = false,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m134.sounds.fire = "minigun_fire_single"
	self.m134.sounds.fire_single = "minigun_fire_single"
	self.m134.sounds.fire_auto = "minigun_fire"
	self.m134.sounds.stop_fire = "minigun_stop"
	self.m134.sounds.dryfire = "primary_dryfire"
	self.m134.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.m134.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.m134.timers = {
		reload_not_empty = 7.8,
		reload_empty = 7.8,
		unequip = 0.9,
		equip = 0.9
	}
	self.m134.name_id = "bm_w_m134"
	self.m134.desc_id = "bm_w_m134_desc"
	self.m134.description_id = "des_m134"
	self.m134.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.m134.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.m134.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.m134.DAMAGE = 1
	self.m134.CLIP_AMMO_MAX = 750
	self.m134.NR_CLIPS_MAX = 1
	self.m134.AMMO_MAX = self.m134.CLIP_AMMO_MAX * self.m134.NR_CLIPS_MAX
	self.m134.AMMO_PICKUP = self:_pickup_chance(90, 1)
	self.m134.FIRE_MODE = "auto"
	self.m134.fire_mode_data = {fire_rate = 0.02}
	self.m134.CAN_TOGGLE_FIREMODE = false
	self.m134.auto = {fire_rate = 0.05}
	self.m134.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.m134.kick = {standing = {
		-0.1,
		0.2,
		-0.3,
		0.4
	}}
	self.m134.kick.crouching = self.m134.kick.standing
	self.m134.kick.steelsight = self.m134.kick.standing
	self.m134.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m134.crosshair.standing.offset = 0.16
	self.m134.crosshair.standing.moving_offset = 1
	self.m134.crosshair.standing.kick_offset = 0.8
	self.m134.crosshair.crouching.offset = 0.1
	self.m134.crosshair.crouching.moving_offset = 0.6
	self.m134.crosshair.crouching.kick_offset = 0.4
	self.m134.crosshair.steelsight.hidden = true
	self.m134.crosshair.steelsight.offset = 0
	self.m134.crosshair.steelsight.moving_offset = 0
	self.m134.crosshair.steelsight.kick_offset = 0.14
	self.m134.shake = {
		fire_multiplier = 0.5,
		fire_steelsight_multiplier = -0.5
	}
	self.m134.autohit = autohit_minigun_default
	self.m134.aim_assist = aim_assist_lmg_default
	self.m134.weapon_hold = "m134"
	self.m134.animations = {
		equip_id = "equip_m134",
		recoil_steelsight = true,
		thq_align_anim = "thq"
	}
	self.m134.global_value = "overkill_pack"
	self.m134.texture_bundle_folder = "dlc_pack_overkill"
	self.m134.panic_suppression_chance = 0.2
	self.m134.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 8,
		spread = 5,
		spread_moving = 9,
		recoil = 2,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 5
	}
	self.rpg7 = {
		categories = {"grenade_launcher"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		has_description = true,
		projectile_type_index = 3,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.rpg7.sounds.fire = "rpg_fire"
	self.rpg7.sounds.dryfire = "shotgun_dryfire"
	self.rpg7.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.rpg7.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.rpg7.timers = {reload_not_empty = 4.7}
	self.rpg7.timers.reload_empty = self.rpg7.timers.reload_not_empty
	self.rpg7.timers.unequip = 0.85
	self.rpg7.timers.equip = 0.85
	self.rpg7.name_id = "bm_w_rpg7"
	self.rpg7.desc_id = "bm_w_rpg7_desc"
	self.rpg7.description_id = "des_rpg7"
	self.rpg7.muzzleflash = "effects/payday2/particles/weapons/50cal_auto_fps"
	self.rpg7.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.rpg7.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.rpg7.DAMAGE = 6
	self.rpg7.damage_near = 1000
	self.rpg7.damage_far = 2000
	self.rpg7.rays = 6
	self.rpg7.CLIP_AMMO_MAX = 1
	self.rpg7.NR_CLIPS_MAX = 4
	self.rpg7.AMMO_MAX = self.rpg7.CLIP_AMMO_MAX * self.rpg7.NR_CLIPS_MAX
	self.rpg7.AMMO_PICKUP = self:_pickup_chance(0, 1)
	self.rpg7.FIRE_MODE = "single"
	self.rpg7.fire_mode_data = {fire_rate = 2}
	self.rpg7.single = {fire_rate = 2}
	self.rpg7.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.rpg7.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.rpg7.kick.crouching = self.rpg7.kick.standing
	self.rpg7.kick.steelsight = self.rpg7.kick.standing
	self.rpg7.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.rpg7.crosshair.standing.offset = 0.16
	self.rpg7.crosshair.standing.moving_offset = 0.8
	self.rpg7.crosshair.standing.kick_offset = 0.6
	self.rpg7.crosshair.standing.hidden = true
	self.rpg7.crosshair.crouching.offset = 0.08
	self.rpg7.crosshair.crouching.moving_offset = 0.7
	self.rpg7.crosshair.crouching.kick_offset = 0.4
	self.rpg7.crosshair.crouching.hidden = true
	self.rpg7.crosshair.steelsight.hidden = true
	self.rpg7.crosshair.steelsight.offset = 0
	self.rpg7.crosshair.steelsight.moving_offset = 0
	self.rpg7.crosshair.steelsight.kick_offset = 0.1
	self.rpg7.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.rpg7.autohit = autohit_shotgun_default
	self.rpg7.aim_assist = aim_assist_shotgun_default
	self.rpg7.animations = {
		equip_id = "equip_rpg7",
		recoil_steelsight = true
	}
	self.rpg7.global_value = "overkill_pack"
	self.rpg7.texture_bundle_folder = "dlc_pack_overkill"
	self.rpg7.panic_suppression_chance = 0.2
	self.rpg7.ignore_damage_upgrades = true
	self.rpg7.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 100,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 5
	}
	self.rpg7.stats_modifiers = {damage = 100}
	self.cobray = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.cobray.sounds.fire = "cobray_fire_single"
	self.cobray.sounds.fire_single = "cobray_fire_single"
	self.cobray.sounds.fire_auto = "cobray_fire"
	self.cobray.sounds.stop_fire = "cobray_stop"
	self.cobray.sounds.dryfire = "secondary_dryfire"
	self.cobray.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.cobray.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.cobray.timers = {
		reload_not_empty = 2.05,
		reload_empty = 4.35,
		unequip = 0.55,
		equip = 0.5
	}
	self.cobray.name_id = "bm_w_cobray"
	self.cobray.desc_id = "bm_w_cobray_desc"
	self.cobray.description_id = "des_cobray"
	self.cobray.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.cobray.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.cobray.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.cobray.use_data = {selection_index = 1}
	self.cobray.DAMAGE = 1
	self.cobray.CLIP_AMMO_MAX = 32
	self.cobray.NR_CLIPS_MAX = 5
	self.cobray.AMMO_MAX = self.cobray.CLIP_AMMO_MAX * self.cobray.NR_CLIPS_MAX
	self.cobray.AMMO_PICKUP = self:_pickup_chance(self.cobray.AMMO_MAX, 3)
	self.cobray.FIRE_MODE = "auto"
	self.cobray.fire_mode_data = {fire_rate = 0.05}
	self.cobray.CAN_TOGGLE_FIREMODE = true
	self.cobray.auto = {fire_rate = 0.05}
	self.cobray.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.cobray.kick = {standing = {
		-0.6,
		1.2,
		-1,
		1
	}}
	self.cobray.kick.crouching = self.cobray.kick.standing
	self.cobray.kick.steelsight = self.cobray.kick.standing
	self.cobray.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.cobray.crosshair.standing.offset = 0.4
	self.cobray.crosshair.standing.moving_offset = 0.7
	self.cobray.crosshair.standing.kick_offset = 0.6
	self.cobray.crosshair.crouching.offset = 0.3
	self.cobray.crosshair.crouching.moving_offset = 0.6
	self.cobray.crosshair.crouching.kick_offset = 0.4
	self.cobray.crosshair.steelsight.hidden = true
	self.cobray.crosshair.steelsight.offset = 0
	self.cobray.crosshair.steelsight.moving_offset = 0
	self.cobray.crosshair.steelsight.kick_offset = 0.4
	self.cobray.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.cobray.autohit = autohit_smg_default
	self.cobray.aim_assist = aim_assist_smg_default
	self.cobray.weapon_hold = "cobray"
	self.cobray.animations = {
		equip_id = "equip_cobray",
		recoil_steelsight = true
	}
	self.cobray.global_value = "hlm2_deluxe"
	self.cobray.texture_bundle_folder = "hlm2"
	self.cobray.panic_suppression_chance = 0.2
	self.cobray.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 18,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 25
	}
	self.b682 = {
		categories = {"shotgun"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.b682.sounds.fire = "b682_fire"
	self.b682.sounds.dryfire = "shotgun_dryfire"
	self.b682.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.b682.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.b682.timers = {
		reload_not_empty = 2.5,
		reload_empty = 2.7,
		unequip = 0.55,
		equip = 0.55
	}
	self.b682.name_id = "bm_w_b682"
	self.b682.desc_id = "bm_w_b682_desc"
	self.b682.description_id = "des_b682"
	self.b682.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.b682.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.b682.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.b682.DAMAGE = 6
	self.b682.damage_near = 2000
	self.b682.damage_far = 3000
	self.b682.rays = 12
	self.b682.CLIP_AMMO_MAX = 2
	self.b682.NR_CLIPS_MAX = 14
	self.b682.AMMO_MAX = self.b682.CLIP_AMMO_MAX * self.b682.NR_CLIPS_MAX
	self.b682.AMMO_PICKUP = self:_pickup_chance(self.b682.AMMO_MAX, 1)
	self.b682.FIRE_MODE = "single"
	self.b682.fire_mode_data = {fire_rate = 0.12}
	self.b682.single = {fire_rate = 0.12}
	self.b682.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.b682.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.b682.kick.crouching = self.b682.kick.standing
	self.b682.kick.steelsight = self.b682.kick.standing
	self.b682.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.b682.crosshair.standing.offset = 0.16
	self.b682.crosshair.standing.moving_offset = 0.8
	self.b682.crosshair.standing.kick_offset = 0.6
	self.b682.crosshair.standing.hidden = true
	self.b682.crosshair.crouching.offset = 0.08
	self.b682.crosshair.crouching.moving_offset = 0.7
	self.b682.crosshair.crouching.kick_offset = 0.4
	self.b682.crosshair.crouching.hidden = true
	self.b682.crosshair.steelsight.hidden = true
	self.b682.crosshair.steelsight.offset = 0
	self.b682.crosshair.steelsight.moving_offset = 0
	self.b682.crosshair.steelsight.kick_offset = 0.1
	self.b682.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.b682.autohit = autohit_shotgun_default
	self.b682.aim_assist = aim_assist_shotgun_default
	self.b682.animations = {
		equip_id = "equip_b682",
		recoil_steelsight = true
	}
	self.b682.panic_suppression_chance = 0.2
	self.b682.global_value = "pd2_clan"
	self.b682.texture_bundle_folder = "character_pack_bonnie"
	self.b682.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 155,
		alert_size = 7,
		spread = 16,
		spread_moving = 16,
		recoil = 8,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 5
	}
	self.b682.stats_modifiers = {damage = 1}
	self.x_g22c = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_g22c.sounds.fire = "g22_fire"
	self.x_g22c.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_g22c.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_g22c.sounds.dryfire = "secondary_dryfire"
	self.x_g22c.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_g22c.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_g22c.name_id = "bm_w_x_g22c"
	self.x_g22c.desc_id = "bm_w_x_g22c_desc"
	self.x_g22c.description_id = "des_x_g22c"
	self.x_g22c.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_g22c.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_g22c.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_g22c.use_data = {selection_index = 2}
	self.x_g22c.DAMAGE = 1
	self.x_g22c.CLIP_AMMO_MAX = 32
	self.x_g22c.NR_CLIPS_MAX = 3
	self.x_g22c.AMMO_MAX = self.x_g22c.CLIP_AMMO_MAX * self.x_g22c.NR_CLIPS_MAX
	self.x_g22c.AMMO_PICKUP = self:_pickup_chance(self.x_g22c.AMMO_MAX, 1)
	self.x_g22c.FIRE_MODE = "single"
	self.x_g22c.fire_mode_data = {fire_rate = 0.166}
	self.x_g22c.single = {fire_rate = 0.166}
	self.x_g22c.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_g22c.kick = {standing = {
		1.6,
		1.3,
		-0.3,
		0.3
	}}
	self.x_g22c.kick.crouching = self.x_g22c.kick.standing
	self.x_g22c.kick.steelsight = self.x_g22c.kick.standing
	self.x_g22c.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_g22c.crosshair.standing.offset = 0.2
	self.x_g22c.crosshair.standing.moving_offset = 0.6
	self.x_g22c.crosshair.standing.kick_offset = 0.4
	self.x_g22c.crosshair.crouching.offset = 0.1
	self.x_g22c.crosshair.crouching.moving_offset = 0.6
	self.x_g22c.crosshair.crouching.kick_offset = 0.3
	self.x_g22c.crosshair.steelsight.hidden = true
	self.x_g22c.crosshair.steelsight.offset = 0
	self.x_g22c.crosshair.steelsight.moving_offset = 0
	self.x_g22c.crosshair.steelsight.kick_offset = 0.1
	self.x_g22c.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_g22c.autohit = autohit_pistol_default
	self.x_g22c.aim_assist = aim_assist_pistol_default
	self.x_g22c.weapon_hold = "jowi_pistol"
	self.x_g22c.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.x_g22c.panic_suppression_chance = 0.2
	self.x_g22c.texture_bundle_folder = "butcher_pack_mods"
	self.x_g22c.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.x_g17 = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_g17.sounds.fire = "g17_fire"
	self.x_g17.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_g17.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_g17.sounds.dryfire = "secondary_dryfire"
	self.x_g17.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_g17.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_g17.name_id = "bm_w_x_g17"
	self.x_g17.desc_id = "bm_w_x_g17_desc"
	self.x_g17.description_id = "des_x_g17"
	self.x_g17.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_g17.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_g17.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_g17.use_data = {selection_index = 2}
	self.x_g17.DAMAGE = 1
	self.x_g17.CLIP_AMMO_MAX = 34
	self.x_g17.NR_CLIPS_MAX = 5
	self.x_g17.AMMO_MAX = self.x_g17.CLIP_AMMO_MAX * self.x_g17.NR_CLIPS_MAX
	self.x_g17.AMMO_PICKUP = self:_pickup_chance(self.x_g17.AMMO_MAX, 1)
	self.x_g17.FIRE_MODE = "single"
	self.x_g17.fire_mode_data = {fire_rate = 0.125}
	self.x_g17.single = {fire_rate = 0.125}
	self.x_g17.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_g17.kick = {standing = {
		1.6,
		1.3,
		-0.3,
		0.3
	}}
	self.x_g17.kick.crouching = self.x_g17.kick.standing
	self.x_g17.kick.steelsight = self.x_g17.kick.standing
	self.x_g17.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_g17.crosshair.standing.offset = 0.2
	self.x_g17.crosshair.standing.moving_offset = 0.6
	self.x_g17.crosshair.standing.kick_offset = 0.4
	self.x_g17.crosshair.crouching.offset = 0.1
	self.x_g17.crosshair.crouching.moving_offset = 0.6
	self.x_g17.crosshair.crouching.kick_offset = 0.3
	self.x_g17.crosshair.steelsight.hidden = true
	self.x_g17.crosshair.steelsight.offset = 0
	self.x_g17.crosshair.steelsight.moving_offset = 0
	self.x_g17.crosshair.steelsight.kick_offset = 0.1
	self.x_g17.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_g17.autohit = autohit_pistol_default
	self.x_g17.aim_assist = aim_assist_pistol_default
	self.x_g17.weapon_hold = "jowi_pistol"
	self.x_g17.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		magazine_empty = "last_recoil",
		recoil_steelsight = true
	}
	self.x_g17.panic_suppression_chance = 0.2
	self.x_g17.texture_bundle_folder = "butcher_pack_mods"
	self.x_g17.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 30
	}
	self.x_usp = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_usp.sounds.fire = "usp45_fire"
	self.x_usp.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_usp.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_usp.sounds.dryfire = "secondary_dryfire"
	self.x_usp.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_usp.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_usp.name_id = "bm_w_x_usp"
	self.x_usp.desc_id = "bm_w_x_usp_desc"
	self.x_usp.description_id = "des_x_usp"
	self.x_usp.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_usp.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_usp.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_usp.use_data = {selection_index = 2}
	self.x_usp.DAMAGE = 1
	self.x_usp.CLIP_AMMO_MAX = 26
	self.x_usp.NR_CLIPS_MAX = 4
	self.x_usp.AMMO_MAX = self.x_usp.CLIP_AMMO_MAX * self.x_usp.NR_CLIPS_MAX
	self.x_usp.AMMO_PICKUP = self:_pickup_chance(self.x_usp.AMMO_MAX, 1)
	self.x_usp.FIRE_MODE = "single"
	self.x_usp.fire_mode_data = {fire_rate = 0.166}
	self.x_usp.single = {fire_rate = 0.166}
	self.x_usp.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_usp.kick = {standing = {
		1.6,
		1.3,
		-0.3,
		0.3
	}}
	self.x_usp.kick.crouching = self.x_usp.kick.standing
	self.x_usp.kick.steelsight = self.x_usp.kick.standing
	self.x_usp.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_usp.crosshair.standing.offset = 0.2
	self.x_usp.crosshair.standing.moving_offset = 0.6
	self.x_usp.crosshair.standing.kick_offset = 0.4
	self.x_usp.crosshair.crouching.offset = 0.1
	self.x_usp.crosshair.crouching.moving_offset = 0.6
	self.x_usp.crosshair.crouching.kick_offset = 0.3
	self.x_usp.crosshair.steelsight.hidden = true
	self.x_usp.crosshair.steelsight.offset = 0
	self.x_usp.crosshair.steelsight.moving_offset = 0
	self.x_usp.crosshair.steelsight.kick_offset = 0.1
	self.x_usp.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_usp.autohit = autohit_pistol_default
	self.x_usp.aim_assist = aim_assist_pistol_default
	self.x_usp.weapon_hold = "jowi_pistol"
	self.x_usp.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		magazine_empty = "last_recoil",
		recoil_steelsight = true
	}
	self.x_usp.panic_suppression_chance = 0.2
	self.x_usp.texture_bundle_folder = "butcher_pack_mods"
	self.x_usp.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 65,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 16,
		concealment = 29
	}
	self.flamethrower_mk2 = {
		categories = {"flamethrower"},
		has_description = false,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.flamethrower_mk2.sounds.fire = "flamethrower_fire"
	self.flamethrower_mk2.sounds.stop_fire = "flamethrower_stop"
	self.flamethrower_mk2.sounds.dryfire = "flamethrower_dryfire"
	self.flamethrower_mk2.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.flamethrower_mk2.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.flamethrower_mk2.timers = {reload_not_empty = 8.5}
	self.flamethrower_mk2.timers.reload_empty = self.flamethrower_mk2.timers.reload_not_empty
	self.flamethrower_mk2.timers.unequip = 0.85
	self.flamethrower_mk2.timers.equip = 0.85
	self.flamethrower_mk2.name_id = "bm_w_flamethrower_mk2"
	self.flamethrower_mk2.desc_id = "bm_w_flamethrower_mk2_desc"
	self.flamethrower_mk2.description_id = "des_flamethrower_mk2"
	self.flamethrower_mk2.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.flamethrower_mk2.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.flamethrower_mk2.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.flamethrower_mk2.DAMAGE = 1
	self.flamethrower_mk2.rays = 12
	self.flamethrower_mk2.CLIP_AMMO_MAX = 300
	self.flamethrower_mk2.NR_CLIPS_MAX = 2
	self.flamethrower_mk2.AMMO_MAX = self.flamethrower_mk2.CLIP_AMMO_MAX * self.flamethrower_mk2.NR_CLIPS_MAX
	self.flamethrower_mk2.AMMO_PICKUP = self:_pickup_chance(90, 1)
	self.flamethrower_mk2.FIRE_MODE = "auto"
	self.flamethrower_mk2.fire_mode_data = {fire_rate = 0.03}
	self.flamethrower_mk2.auto = {fire_rate = 0.05}
	self.flamethrower_mk2.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.flamethrower_mk2.kick = {standing = {
		0,
		0,
		0,
		0
	}}
	self.flamethrower_mk2.kick.crouching = self.flamethrower_mk2.kick.standing
	self.flamethrower_mk2.kick.steelsight = self.flamethrower_mk2.kick.standing
	self.flamethrower_mk2.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.flamethrower_mk2.crosshair.standing.offset = 0.16
	self.flamethrower_mk2.crosshair.standing.moving_offset = 0.8
	self.flamethrower_mk2.crosshair.standing.kick_offset = 0.6
	self.flamethrower_mk2.crosshair.standing.hidden = true
	self.flamethrower_mk2.crosshair.crouching.offset = 0.08
	self.flamethrower_mk2.crosshair.crouching.moving_offset = 0.7
	self.flamethrower_mk2.crosshair.crouching.kick_offset = 0.4
	self.flamethrower_mk2.crosshair.crouching.hidden = true
	self.flamethrower_mk2.crosshair.steelsight.hidden = true
	self.flamethrower_mk2.crosshair.steelsight.offset = 0
	self.flamethrower_mk2.crosshair.steelsight.moving_offset = 0
	self.flamethrower_mk2.crosshair.steelsight.kick_offset = 0.1
	self.flamethrower_mk2.shake = {
		fire_multiplier = 0,
		fire_steelsight_multiplier = 0
	}
	self.flamethrower_mk2.autohit = autohit_shotgun_default
	self.flamethrower_mk2.aim_assist = aim_assist_shotgun_default
	self.flamethrower_mk2.animations = {
		equip_id = "equip_flamethrower",
		recoil_steelsight = false
	}
	self.flamethrower_mk2.flame_max_range = 1000
	self.flamethrower_mk2.single_flame_effect_duration = 1
	self.flamethrower_mk2.panic_suppression_chance = 0.2
	self.flamethrower_mk2.global_value = "bbq"
	self.flamethrower_mk2.texture_bundle_folder = "bbq"
	self.flamethrower_mk2.fire_dot_data = {
		dot_trigger_chance = 35,
		dot_damage = 10,
		dot_length = 6.1,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}
	self.flamethrower_mk2.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 14,
		alert_size = 1,
		spread = 1,
		spread_moving = 6,
		recoil = 0,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 7
	}
	self.m32 = {
		categories = {"grenade_launcher"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		projectile_type_index = 6,
		projectile_type_indices = {launcher_incendiary = 26},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m32.sounds.fire = "mgl_fire"
	self.m32.sounds.dryfire = "shotgun_dryfire"
	self.m32.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.m32.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.m32.timers = {
		shotgun_reload_enter = 1.96,
		shotgun_reload_exit_empty = 1.33,
		shotgun_reload_exit_not_empty = 1.33,
		shotgun_reload_shell = 2,
		shotgun_reload_first_shell_offset = 0,
		unequip = 0.85,
		equip = 0.85
	}
	self.m32.name_id = "bm_w_m32"
	self.m32.desc_id = "bm_w_m32_desc"
	self.m32.description_id = "des_m32"
	self.m32.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.m32.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.m32.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.m32.DAMAGE = 6
	self.m32.damage_near = 2000
	self.m32.damage_far = 3000
	self.m32.rays = 6
	self.m32.CLIP_AMMO_MAX = 6
	self.m32.NR_CLIPS_MAX = 2
	self.m32.AMMO_MAX = self.m32.CLIP_AMMO_MAX * self.m32.NR_CLIPS_MAX
	self.m32.AMMO_PICKUP = {
		0.05,
		0.65
	}
	self.m32.FIRE_MODE = "single"
	self.m32.fire_mode_data = {fire_rate = 1}
	self.m32.single = {fire_rate = 1.1}
	self.m32.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.m32.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.m32.kick.crouching = self.m32.kick.standing
	self.m32.kick.steelsight = self.m32.kick.standing
	self.m32.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m32.crosshair.standing.offset = 0.16
	self.m32.crosshair.standing.moving_offset = 0.8
	self.m32.crosshair.standing.kick_offset = 0.6
	self.m32.crosshair.standing.hidden = true
	self.m32.crosshair.crouching.offset = 0.08
	self.m32.crosshair.crouching.moving_offset = 0.7
	self.m32.crosshair.crouching.kick_offset = 0.4
	self.m32.crosshair.crouching.hidden = true
	self.m32.crosshair.steelsight.hidden = true
	self.m32.crosshair.steelsight.offset = 0
	self.m32.crosshair.steelsight.moving_offset = 0
	self.m32.crosshair.steelsight.kick_offset = 0.1
	self.m32.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.m32.autohit = autohit_shotgun_default
	self.m32.aim_assist = aim_assist_shotgun_default
	self.m32.animations = {
		equip_id = "equip_m32",
		recoil_steelsight = true
	}
	self.m32.global_value = "bbq"
	self.m32.texture_bundle_folder = "bbq"
	self.m32.panic_suppression_chance = 0.2
	self.m32.ignore_damage_upgrades = true
	self.m32.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 130,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 10
	}
	self.m32.stats_modifiers = {damage = 10}
	self.aa12 = {
		categories = {"shotgun"},
		has_magazine = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.aa12.sounds.fire = "aa12_fire"
	self.aa12.sounds.fire_single = "aa12_fire_single"
	self.aa12.sounds.fire_auto = "aa12_fire"
	self.aa12.sounds.dryfire = "shotgun_dryfire"
	self.aa12.sounds.stop_fire = "aa12_stop"
	self.aa12.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.aa12.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.aa12.timers = {
		reload_not_empty = 3,
		reload_empty = 4.1,
		unequip = 0.55,
		equip = 0.55
	}
	self.aa12.name_id = "bm_w_aa12"
	self.aa12.desc_id = "bm_w_aa12_desc"
	self.aa12.description_id = "des_aa12"
	self.aa12.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.aa12.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.aa12.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.aa12.DAMAGE = 6
	self.aa12.damage_near = 2000
	self.aa12.damage_far = 3000
	self.aa12.rays = 12
	self.aa12.CLIP_AMMO_MAX = 8
	self.aa12.NR_CLIPS_MAX = 9
	self.aa12.AMMO_MAX = self.aa12.CLIP_AMMO_MAX * self.aa12.NR_CLIPS_MAX
	self.aa12.AMMO_PICKUP = self:_pickup_chance(self.aa12.AMMO_MAX, 4)
	self.aa12.FIRE_MODE = "auto"
	self.aa12.fire_mode_data = {fire_rate = 0.2}
	self.aa12.CAN_TOGGLE_FIREMODE = true
	self.aa12.auto = {fire_rate = 0.2}
	self.aa12.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.aa12.kick = {standing = self.r870.kick.standing}
	self.aa12.kick.crouching = self.aa12.kick.standing
	self.aa12.kick.steelsight = self.r870.kick.steelsight
	self.aa12.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.aa12.crosshair.standing.offset = 0.7
	self.aa12.crosshair.standing.moving_offset = 0.7
	self.aa12.crosshair.standing.kick_offset = 0.8
	self.aa12.crosshair.crouching.offset = 0.65
	self.aa12.crosshair.crouching.moving_offset = 0.65
	self.aa12.crosshair.crouching.kick_offset = 0.75
	self.aa12.crosshair.steelsight.hidden = true
	self.aa12.crosshair.steelsight.offset = 0
	self.aa12.crosshair.steelsight.moving_offset = 0
	self.aa12.crosshair.steelsight.kick_offset = 0
	self.aa12.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 1.25
	}
	self.aa12.autohit = autohit_shotgun_default
	self.aa12.aim_assist = aim_assist_shotgun_default
	self.aa12.weapon_hold = "aa12"
	self.aa12.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.aa12.global_value = "bbq"
	self.aa12.texture_bundle_folder = "bbq"
	self.aa12.panic_suppression_chance = 0.2
	self.aa12.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 42,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 9
	}
	self.peacemaker = {
		categories = {
			"pistol",
			"revolver"
		},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		use_shotgun_reload = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.peacemaker.sounds.fire = "pmkr45_fire"
	self.peacemaker.sounds.dryfire = "pmkr45_dryfire"
	self.peacemaker.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.peacemaker.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.peacemaker.timers = {
		shotgun_reload_enter = 1.4333333333333333,
		shotgun_reload_exit_empty = 0.3333333333333333,
		shotgun_reload_exit_not_empty = 0.3333333333333333,
		shotgun_reload_shell = 1,
		shotgun_reload_first_shell_offset = 0,
		unequip = 0.65,
		equip = 0.65
	}
	self.peacemaker.FIRE_MODE = "single"
	self.peacemaker.fire_mode_data = {fire_rate = 0.25}
	self.peacemaker.CAN_TOGGLE_FIREMODE = false
	self.peacemaker.single = {fire_rate = 0.166}
	self.peacemaker.auto = {fire_rate = 0.166}
	self.peacemaker.name_id = "bm_w_peacemaker"
	self.peacemaker.desc_id = "bm_w_peacemaker_desc"
	self.peacemaker.description_id = "des_peacemaker"
	self.peacemaker.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.peacemaker.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.peacemaker.use_data = {selection_index = 1}
	self.peacemaker.DAMAGE = 6
	self.peacemaker.CLIP_AMMO_MAX = 6
	self.peacemaker.NR_CLIPS_MAX = 9
	self.peacemaker.AMMO_MAX = self.peacemaker.CLIP_AMMO_MAX * self.peacemaker.NR_CLIPS_MAX
	self.peacemaker.AMMO_PICKUP = self:_pickup_chance(self.peacemaker.AMMO_MAX, 1)
	self.peacemaker.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.peacemaker.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.peacemaker.kick.crouching = self.peacemaker.kick.standing
	self.peacemaker.kick.steelsight = self.peacemaker.kick.standing
	self.peacemaker.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.peacemaker.crosshair.standing.offset = 0.2
	self.peacemaker.crosshair.standing.moving_offset = 0.8
	self.peacemaker.crosshair.standing.kick_offset = 0.6
	self.peacemaker.crosshair.crouching.offset = 0.1
	self.peacemaker.crosshair.crouching.moving_offset = 0.7
	self.peacemaker.crosshair.crouching.kick_offset = 0.4
	self.peacemaker.crosshair.steelsight.hidden = true
	self.peacemaker.crosshair.steelsight.offset = 0
	self.peacemaker.crosshair.steelsight.moving_offset = 0
	self.peacemaker.crosshair.steelsight.kick_offset = 0.1
	self.peacemaker.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.peacemaker.autohit = autohit_pistol_default
	self.peacemaker.aim_assist = aim_assist_pistol_default
	self.peacemaker.animations = {
		equip_id = "equip_peacemaker",
		recoil_steelsight = true
	}
	self.peacemaker.global_value = "west"
	self.peacemaker.texture_bundle_folder = "west"
	self.peacemaker.panic_suppression_chance = 0.2
	self.peacemaker.stats = {
		zoom = 5,
		total_ammo_mod = 21,
		damage = 180,
		alert_size = 7,
		spread = 22,
		spread_moving = 22,
		recoil = 4,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 26
	}
	self.peacemaker.stats_modifiers = {damage = 1}
	self.winchester1874 = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		use_shotgun_reload = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.winchester1874.sounds.fire = "m1873_fire"
	self.winchester1874.sounds.dryfire = "primary_dryfire"
	self.winchester1874.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.winchester1874.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.winchester1874.timers = {
		shotgun_reload_enter = 0.43333333333333335,
		shotgun_reload_exit_empty = 0.7666666666666667,
		shotgun_reload_exit_not_empty = 0.4,
		shotgun_reload_shell = 0.5666666666666667,
		shotgun_reload_first_shell_offset = 0.2,
		unequip = 0.9,
		equip = 0.9
	}
	self.winchester1874.name_id = "bm_w_winchester1874"
	self.winchester1874.desc_id = "bm_w_winchester1874_desc"
	self.winchester1874.description_id = "des_winchester1874"
	self.winchester1874.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.winchester1874.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper_9mm"
	self.winchester1874.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.winchester1874.DAMAGE = 1
	self.winchester1874.CLIP_AMMO_MAX = 15
	self.winchester1874.NR_CLIPS_MAX = 3
	self.winchester1874.AMMO_MAX = self.winchester1874.CLIP_AMMO_MAX * self.winchester1874.NR_CLIPS_MAX
	self.winchester1874.AMMO_PICKUP = self:_pickup_chance(self.winchester1874.AMMO_MAX, 5)
	self.winchester1874.FIRE_MODE = "single"
	self.winchester1874.fire_mode_data = {fire_rate = 0.7}
	self.winchester1874.CAN_TOGGLE_FIREMODE = false
	self.winchester1874.single = {fire_rate = 0.7}
	self.winchester1874.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.winchester1874.kick = {standing = {
		3,
		4.8,
		-0.3,
		0.3
	}}
	self.winchester1874.kick.crouching = self.winchester1874.kick.standing
	self.winchester1874.kick.steelsight = self.winchester1874.kick.standing
	self.winchester1874.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.winchester1874.crosshair.standing.offset = 1.14
	self.winchester1874.crosshair.standing.moving_offset = 1.8
	self.winchester1874.crosshair.standing.kick_offset = 1.6
	self.winchester1874.crosshair.crouching.offset = 1.1
	self.winchester1874.crosshair.crouching.moving_offset = 1.6
	self.winchester1874.crosshair.crouching.kick_offset = 1.4
	self.winchester1874.crosshair.steelsight.hidden = true
	self.winchester1874.crosshair.steelsight.offset = 1
	self.winchester1874.crosshair.steelsight.moving_offset = 1
	self.winchester1874.crosshair.steelsight.kick_offset = 1.14
	self.winchester1874.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = -2
	}
	self.winchester1874.autohit = autohit_snp_default
	self.winchester1874.aim_assist = aim_assist_snp_default
	self.winchester1874.animations = {
		equip_id = "equip_winchester1874",
		recoil_steelsight = true
	}
	self.winchester1874.global_value = "west"
	self.winchester1874.texture_bundle_folder = "west"
	self.winchester1874.can_shoot_through_enemy = true
	self.winchester1874.can_shoot_through_shield = true
	self.winchester1874.can_shoot_through_wall = true
	self.winchester1874.panic_suppression_chance = 0.2
	self.winchester1874.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 7,
		spread = 24,
		spread_moving = 24,
		recoil = 6,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 12
	}
	self.winchester1874.armor_piercing_chance = 1
	self.winchester1874.stats_modifiers = {damage = 1}
	self.plainsrider = {
		categories = {"bow"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		projectile_type_index = 7,
		not_allowed_in_bleedout = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.plainsrider.sounds.charge_release = "bow_release"
	self.plainsrider.sounds.charge_release_fail = "bow_release_fail"
	self.plainsrider.sounds.charge = "bow_charge"
	self.plainsrider.sounds.charge_cancel = "bow_charge_cancel"
	self.plainsrider.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.plainsrider.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.plainsrider.timers = {reload_not_empty = 1}
	self.plainsrider.timers.reload_empty = self.plainsrider.timers.reload_not_empty
	self.plainsrider.timers.unequip = 0.55
	self.plainsrider.timers.equip = 0.55
	self.plainsrider.bow_reload_speed_multiplier = 3
	self.plainsrider.charge_data = {max_t = 1}
	self.plainsrider.name_id = "bm_w_plainsrider"
	self.plainsrider.desc_id = "bm_w_plainsrider_desc"
	self.plainsrider.description_id = "des_plainsrider"
	self.plainsrider.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.plainsrider.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.plainsrider.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.plainsrider.DAMAGE = 6
	self.plainsrider.CLIP_AMMO_MAX = 1
	self.plainsrider.NR_CLIPS_MAX = 50
	self.plainsrider.AMMO_MAX = self.plainsrider.CLIP_AMMO_MAX * self.plainsrider.NR_CLIPS_MAX
	self.plainsrider.AMMO_PICKUP = self:_pickup_chance(0, self.plainsrider.use_data.selection_index)
	self.plainsrider.FIRE_MODE = "single"
	self.plainsrider.fire_mode_data = {fire_rate = 0.2}
	self.plainsrider.single = {fire_rate = 0.2}
	self.plainsrider.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.plainsrider.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.plainsrider.kick.crouching = self.plainsrider.kick.standing
	self.plainsrider.kick.steelsight = self.plainsrider.kick.standing
	self.plainsrider.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.plainsrider.crosshair.standing.offset = 0.16
	self.plainsrider.crosshair.standing.moving_offset = 0.7
	self.plainsrider.crosshair.crouching.offset = 0.07
	self.plainsrider.crosshair.crouching.moving_offset = 0.7
	self.plainsrider.crosshair.crouching.kick_offset = 0.3
	self.plainsrider.crosshair.steelsight.hidden = true
	self.plainsrider.crosshair.steelsight.offset = 0
	self.plainsrider.crosshair.steelsight.moving_offset = 0
	self.plainsrider.crosshair.steelsight.kick_offset = 0.1
	self.plainsrider.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.plainsrider.autohit = autohit_shotgun_default
	self.plainsrider.aim_assist = aim_assist_shotgun_default
	self.plainsrider.animations = {
		equip_id = "equip_plainsrider",
		recoil_steelsight = false
	}
	self.plainsrider.global_value = "west"
	self.plainsrider.texture_bundle_folder = "west"
	self.plainsrider.panic_suppression_chance = 0.2
	self.plainsrider.ignore_damage_upgrades = true
	self.plainsrider.stats = {
		zoom = 5,
		total_ammo_mod = 21,
		damage = 100,
		alert_size = 7,
		spread = 25,
		spread_moving = 12,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 30
	}
	self.plainsrider.stats_modifiers = {damage = 10}
	self.mateba = {
		categories = {
			"pistol",
			"revolver"
		},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.mateba.sounds.fire = "mateba_fire"
	self.mateba.sounds.dryfire = "secondary_dryfire"
	self.mateba.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.mateba.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.mateba.timers = {
		reload_not_empty = 3.6,
		reload_empty = 3.6,
		unequip = 0.5,
		equip = 0.45
	}
	self.mateba.FIRE_MODE = "single"
	self.mateba.fire_mode_data = {fire_rate = 0.166}
	self.mateba.single = {fire_rate = 0.166}
	self.mateba.name_id = "bm_w_mateba"
	self.mateba.desc_id = "bm_w_mateba_desc"
	self.mateba.description_id = "des_mateba"
	self.mateba.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.mateba.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.mateba.use_data = {selection_index = 1}
	self.mateba.DAMAGE = 2
	self.mateba.CLIP_AMMO_MAX = 6
	self.mateba.NR_CLIPS_MAX = 9
	self.mateba.AMMO_MAX = self.mateba.CLIP_AMMO_MAX * self.mateba.NR_CLIPS_MAX
	self.mateba.AMMO_PICKUP = self:_pickup_chance(self.mateba.AMMO_MAX, 1)
	self.mateba.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.mateba.kick = {standing = self.glock_17.kick.standing}
	self.mateba.kick.crouching = self.mateba.kick.standing
	self.mateba.kick.steelsight = self.mateba.kick.standing
	self.mateba.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.mateba.crosshair.standing.offset = 0.2
	self.mateba.crosshair.standing.moving_offset = 0.6
	self.mateba.crosshair.standing.kick_offset = 0.4
	self.mateba.crosshair.crouching.offset = 0.1
	self.mateba.crosshair.crouching.moving_offset = 0.6
	self.mateba.crosshair.crouching.kick_offset = 0.3
	self.mateba.crosshair.steelsight.hidden = true
	self.mateba.crosshair.steelsight.offset = 0
	self.mateba.crosshair.steelsight.moving_offset = 0
	self.mateba.crosshair.steelsight.kick_offset = 0.1
	self.mateba.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.mateba.autohit = autohit_pistol_default
	self.mateba.aim_assist = aim_assist_pistol_default
	self.mateba.weapon_hold = "mateba"
	self.mateba.animations = {
		equip_id = "equip_raging_bull",
		recoil_steelsight = true
	}
	self.mateba.global_value = "arena"
	self.mateba.texture_bundle_folder = "dlc_arena"
	self.mateba.panic_suppression_chance = 0.2
	self.mateba.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 180,
		alert_size = 7,
		spread = 22,
		spread_moving = 22,
		recoil = 4,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 20
	}
	self.asval = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.asval.sounds.fire = "val_fire"
	self.asval.sounds.fire_single = "val_fire_single"
	self.asval.sounds.fire_auto = "val_fire"
	self.asval.sounds.stop_fire = "val_stop"
	self.asval.sounds.dryfire = "primary_dryfire"
	self.asval.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.asval.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.asval.timers = {
		reload_not_empty = 2.6,
		reload_empty = 3.7,
		unequip = 0.5,
		equip = 0.5
	}
	self.asval.name_id = "bm_w_asval"
	self.asval.desc_id = "bm_w_asval_desc"
	self.asval.description_id = "des_asval"
	self.asval.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.asval.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.asval.use_data = {selection_index = 2}
	self.asval.DAMAGE = 1
	self.asval.CLIP_AMMO_MAX = 20
	self.asval.NR_CLIPS_MAX = 11
	self.asval.AMMO_MAX = self.asval.CLIP_AMMO_MAX * self.asval.NR_CLIPS_MAX
	self.asval.AMMO_PICKUP = self:_pickup_chance(self.asval.AMMO_MAX, 2)
	self.asval.FIRE_MODE = "auto"
	self.asval.fire_mode_data = {fire_rate = 0.067}
	self.asval.CAN_TOGGLE_FIREMODE = true
	self.asval.auto = {fire_rate = 0.067}
	self.asval.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.asval.kick = {standing = self.new_m4.kick.standing}
	self.asval.kick.crouching = self.asval.kick.standing
	self.asval.kick.steelsight = self.asval.kick.standing
	self.asval.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.asval.crosshair.standing.offset = 0.16
	self.asval.crosshair.standing.moving_offset = 0.8
	self.asval.crosshair.standing.kick_offset = 0.6
	self.asval.crosshair.crouching.offset = 0.08
	self.asval.crosshair.crouching.moving_offset = 0.7
	self.asval.crosshair.crouching.kick_offset = 0.4
	self.asval.crosshair.steelsight.hidden = true
	self.asval.crosshair.steelsight.offset = 0
	self.asval.crosshair.steelsight.moving_offset = 0
	self.asval.crosshair.steelsight.kick_offset = 0.1
	self.asval.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.asval.autohit = autohit_rifle_default
	self.asval.aim_assist = aim_assist_rifle_default
	self.asval.weapon_hold = "asval"
	self.asval.animations = {
		equip_id = "asval_equip",
		recoil_steelsight = true
	}
	self.asval.challenges = {
		group = "rifle",
		weapon = "ak47"
	}
	self.asval.global_value = "character_pack_sokol"
	self.asval.texture_bundle_folder = "character_pack_sokol"
	self.asval.panic_suppression_chance = 0.2
	self.asval.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 12,
		spread = 15,
		spread_moving = 8,
		recoil = 17,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 24,
		concealment = 26
	}
	self.sub2000 = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.sub2000.sounds.fire = "sub2k_fire"
	self.sub2000.sounds.fire_single = "sub2k_fire"
	self.sub2000.sounds.dryfire = "primary_dryfire"
	self.sub2000.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.sub2000.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.sub2000.timers = {
		reload_not_empty = 2.3,
		reload_empty = 3.3,
		unequip = 0.9,
		equip = 0.9
	}
	self.sub2000.name_id = "bm_w_sub2000"
	self.sub2000.desc_id = "bm_w_sub2000_desc"
	self.sub2000.description_id = "des_sub2000"
	self.sub2000.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.sub2000.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sub2000.use_data = {selection_index = 2}
	self.sub2000.DAMAGE = 2
	self.sub2000.CLIP_AMMO_MAX = 33
	self.sub2000.NR_CLIPS_MAX = 2
	self.sub2000.AMMO_MAX = self.sub2000.CLIP_AMMO_MAX * self.sub2000.NR_CLIPS_MAX
	self.sub2000.AMMO_PICKUP = self:_pickup_chance(self.sub2000.AMMO_MAX, 1)
	self.sub2000.FIRE_MODE = "single"
	self.sub2000.fire_mode_data = {fire_rate = 0.085}
	self.sub2000.CAN_TOGGLE_FIREMODE = false
	self.sub2000.single = {fire_rate = 0.085}
	self.sub2000.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.sub2000.kick = {standing = self.new_m4.kick.standing}
	self.sub2000.kick.crouching = self.sub2000.kick.standing
	self.sub2000.kick.steelsight = self.sub2000.kick.standing
	self.sub2000.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.sub2000.crosshair.standing.offset = 0.16
	self.sub2000.crosshair.standing.moving_offset = 0.8
	self.sub2000.crosshair.standing.kick_offset = 0.6
	self.sub2000.crosshair.crouching.offset = 0.08
	self.sub2000.crosshair.crouching.moving_offset = 0.7
	self.sub2000.crosshair.crouching.kick_offset = 0.4
	self.sub2000.crosshair.steelsight.hidden = true
	self.sub2000.crosshair.steelsight.offset = 0
	self.sub2000.crosshair.steelsight.moving_offset = 0
	self.sub2000.crosshair.steelsight.kick_offset = 0.1
	self.sub2000.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.sub2000.autohit = autohit_rifle_default
	self.sub2000.aim_assist = aim_assist_rifle_default
	self.sub2000.panic_suppression_chance = 0.2
	self.sub2000.weapon_hold = "sub2000"
	self.sub2000.animations = {
		equip_id = "sub2000_equip",
		recoil_steelsight = true
	}
	self.sub2000.global_value = "kenaz"
	self.sub2000.texture_bundle_folder = "kenaz"
	self.sub2000.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 7,
		spread = 19,
		spread_moving = 16,
		recoil = 9,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 27
	}
	self.wa2000 = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.wa2000.sounds.fire = "lakner_fire"
	self.wa2000.sounds.dryfire = "primary_dryfire"
	self.wa2000.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.wa2000.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.wa2000.timers = {
		reload_not_empty = 4.64,
		reload_empty = 6.2,
		unequip = 0.9,
		equip = 0.9
	}
	self.wa2000.name_id = "bm_w_wa2000"
	self.wa2000.desc_id = "bm_w_wa2000_desc"
	self.wa2000.description_id = "des_wa2000"
	self.wa2000.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.wa2000.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.wa2000.use_data = {selection_index = 2}
	self.wa2000.DAMAGE = 1
	self.wa2000.CLIP_AMMO_MAX = 10
	self.wa2000.NR_CLIPS_MAX = 4
	self.wa2000.AMMO_MAX = self.wa2000.CLIP_AMMO_MAX * self.wa2000.NR_CLIPS_MAX
	self.wa2000.AMMO_PICKUP = self:_pickup_chance(self.wa2000.AMMO_MAX, 5)
	self.wa2000.FIRE_MODE = "single"
	self.wa2000.fire_mode_data = {fire_rate = 0.5}
	self.wa2000.CAN_TOGGLE_FIREMODE = false
	self.wa2000.single = {fire_rate = 0.4}
	self.wa2000.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.wa2000.kick = {standing = {
		3,
		4.8,
		-0.3,
		0.3
	}}
	self.wa2000.kick.crouching = self.wa2000.kick.standing
	self.wa2000.kick.steelsight = self.wa2000.kick.standing
	self.wa2000.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.wa2000.crosshair.standing.offset = 1.14
	self.wa2000.crosshair.standing.moving_offset = 1.8
	self.wa2000.crosshair.standing.kick_offset = 1.6
	self.wa2000.crosshair.crouching.offset = 1.1
	self.wa2000.crosshair.crouching.moving_offset = 1.6
	self.wa2000.crosshair.crouching.kick_offset = 1.4
	self.wa2000.crosshair.steelsight.hidden = true
	self.wa2000.crosshair.steelsight.offset = 1
	self.wa2000.crosshair.steelsight.moving_offset = 1
	self.wa2000.crosshair.steelsight.kick_offset = 1.14
	self.wa2000.shake = {
		fire_multiplier = 1.5,
		fire_steelsight_multiplier = -1.5
	}
	self.wa2000.autohit = autohit_snp_default
	self.wa2000.aim_assist = aim_assist_snp_default
	self.wa2000.weapon_hold = "wa2000"
	self.wa2000.animations = {
		equip_id = "equip_wa2000",
		recoil_steelsight = true
	}
	self.wa2000.panic_suppression_chance = 0.2
	self.wa2000.global_value = "turtles"
	self.wa2000.texture_bundle_folder = "turtles"
	self.wa2000.can_shoot_through_enemy = true
	self.wa2000.can_shoot_through_shield = true
	self.wa2000.can_shoot_through_wall = true
	self.wa2000.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 8,
		spread = 24,
		spread_moving = 24,
		recoil = 6,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 16
	}
	self.wa2000.armor_piercing_chance = 1
	self.wa2000.stats_modifiers = {damage = 1}
	self.polymer = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.polymer.sounds.fire = "polymer_fire_single"
	self.polymer.sounds.fire_single = "polymer_fire_single"
	self.polymer.sounds.fire_auto = "polymer_fire"
	self.polymer.sounds.stop_fire = "polymer_stop"
	self.polymer.sounds.dryfire = "secondary_dryfire"
	self.polymer.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.polymer.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.polymer.timers = {
		reload_not_empty = 2,
		reload_empty = 2.5,
		unequip = 0.6,
		equip = 0.5
	}
	self.polymer.name_id = "bm_w_polymer"
	self.polymer.desc_id = "bm_w_polymer_desc"
	self.polymer.description_id = "des_polymer"
	self.polymer.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.polymer.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.polymer.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.polymer.use_data = {selection_index = 1}
	self.polymer.DAMAGE = 1
	self.polymer.CLIP_AMMO_MAX = 30
	self.polymer.NR_CLIPS_MAX = 5
	self.polymer.AMMO_MAX = self.polymer.CLIP_AMMO_MAX * self.polymer.NR_CLIPS_MAX
	self.polymer.AMMO_PICKUP = self:_pickup_chance(self.polymer.AMMO_MAX, 3)
	self.polymer.FIRE_MODE = "auto"
	self.polymer.fire_mode_data = {fire_rate = 0.05}
	self.polymer.CAN_TOGGLE_FIREMODE = true
	self.polymer.auto = {fire_rate = 0.05}
	self.polymer.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.polymer.kick = {standing = {
		-0.2,
		0.4,
		-1,
		1
	}}
	self.polymer.kick.crouching = self.polymer.kick.standing
	self.polymer.kick.steelsight = self.polymer.kick.standing
	self.polymer.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.polymer.crosshair.standing.offset = 0.4
	self.polymer.crosshair.standing.moving_offset = 0.7
	self.polymer.crosshair.standing.kick_offset = 0.6
	self.polymer.crosshair.crouching.offset = 0.3
	self.polymer.crosshair.crouching.moving_offset = 0.6
	self.polymer.crosshair.crouching.kick_offset = 0.4
	self.polymer.crosshair.steelsight.hidden = true
	self.polymer.crosshair.steelsight.offset = 0
	self.polymer.crosshair.steelsight.moving_offset = 0
	self.polymer.crosshair.steelsight.kick_offset = 0.4
	self.polymer.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.polymer.autohit = autohit_smg_default
	self.polymer.aim_assist = aim_assist_smg_default
	self.polymer.weapon_hold = "polymer"
	self.polymer.animations = {
		equip_id = "equip_polymer",
		recoil_steelsight = true
	}
	self.polymer.global_value = "turtles"
	self.polymer.texture_bundle_folder = "turtles"
	self.polymer.panic_suppression_chance = 0.2
	self.polymer.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 42,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 20,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 20
	}
	self.hunter = {
		categories = {"crossbow"},
		projectile_type_index = 11,
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.hunter.sounds.fire = "hunter_fire"
	self.hunter.sounds.fire_single = "hunter_fire"
	self.hunter.sounds.fire_auto = "hunter_fire"
	self.hunter.sounds.dryfire = "secondary_dryfire"
	self.hunter.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.hunter.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.hunter.timers = {
		reload_not_empty = 1.8,
		reload_empty = 1.2,
		unequip = 0.55,
		equip = 0.5
	}
	self.hunter.name_id = "bm_w_hunter"
	self.hunter.desc_id = "bm_w_hunter_desc"
	self.hunter.description_id = "des_hunter"
	self.hunter.muzzleflash = "effects/payday2/particles/weapons/shells/shell_empty"
	self.hunter.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.hunter.use_data = {selection_index = 1}
	self.hunter.DAMAGE = 1
	self.hunter.CLIP_AMMO_MAX = 1
	self.hunter.NR_CLIPS_MAX = 25
	self.hunter.AMMO_MAX = self.hunter.CLIP_AMMO_MAX * self.hunter.NR_CLIPS_MAX
	self.hunter.AMMO_PICKUP = self:_pickup_chance(0, 1)
	self.hunter.FIRE_MODE = "single"
	self.hunter.fire_mode_data = {fire_rate = 1.2}
	self.hunter.CAN_TOGGLE_FIREMODE = false
	self.hunter.single = {fire_rate = 0.05}
	self.hunter.spread = {
		standing = self.new_m4.spread.standing * 0.7,
		crouching = self.new_m4.spread.standing * 0.7,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.standing * 0.7,
		moving_crouching = self.new_m4.spread.standing * 0.7,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.hunter.kick = {standing = {
		-0.2,
		0.4,
		-1,
		1
	}}
	self.hunter.kick.crouching = self.hunter.kick.standing
	self.hunter.kick.steelsight = self.hunter.kick.standing
	self.hunter.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.hunter.crosshair.standing.offset = 0.4
	self.hunter.crosshair.standing.moving_offset = 0.7
	self.hunter.crosshair.standing.kick_offset = 0.6
	self.hunter.crosshair.crouching.offset = 0.3
	self.hunter.crosshair.crouching.moving_offset = 0.6
	self.hunter.crosshair.crouching.kick_offset = 0.4
	self.hunter.crosshair.steelsight.hidden = true
	self.hunter.crosshair.steelsight.offset = 0
	self.hunter.crosshair.steelsight.moving_offset = 0
	self.hunter.crosshair.steelsight.kick_offset = 0.4
	self.hunter.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.hunter.autohit = autohit_smg_default
	self.hunter.aim_assist = aim_assist_smg_default
	self.hunter.weapon_hold = "hunter"
	self.hunter.animations = {
		equip_id = "equip_hunter",
		recoil_steelsight = true
	}
	self.hunter.global_value = "turtles"
	self.hunter.texture_bundle_folder = "turtles"
	self.hunter.panic_suppression_chance = 0.2
	self.hunter.ignore_damage_upgrades = true
	self.hunter.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 35,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 26
	}
	self.hunter.stats_modifiers = {damage = 10}
	self.baka = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.baka.sounds.fire = "baka_fire_single"
	self.baka.sounds.fire_single = "baka_fire_single"
	self.baka.sounds.fire_auto = "baka_fire"
	self.baka.sounds.stop_fire = "baka_stop"
	self.baka.sounds.dryfire = "secondary_dryfire"
	self.baka.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.baka.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.baka.timers = {
		reload_not_empty = 1.85,
		reload_empty = 2.6,
		unequip = 0.7,
		equip = 0.5
	}
	self.baka.name_id = "bm_w_baka"
	self.baka.desc_id = "bm_w_baka_desc"
	self.baka.description_id = "des_baka"
	self.baka.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.baka.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.baka.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.baka.use_data = {selection_index = 1}
	self.baka.DAMAGE = 1
	self.baka.CLIP_AMMO_MAX = 32
	self.baka.NR_CLIPS_MAX = 7
	self.baka.AMMO_MAX = self.baka.CLIP_AMMO_MAX * self.baka.NR_CLIPS_MAX
	self.baka.AMMO_PICKUP = self:_pickup_chance(self.baka.AMMO_MAX, 2)
	self.baka.FIRE_MODE = "auto"
	self.baka.fire_mode_data = {fire_rate = 0.05}
	self.baka.CAN_TOGGLE_FIREMODE = true
	self.baka.auto = {fire_rate = 0.05}
	self.baka.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.baka.kick = {standing = {
		-0.1,
		0.6,
		-1.2,
		1.2
	}}
	self.baka.kick.crouching = self.baka.kick.standing
	self.baka.kick.steelsight = self.baka.kick.standing
	self.baka.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.baka.crosshair.standing.offset = 0.5
	self.baka.crosshair.standing.moving_offset = 0.8
	self.baka.crosshair.standing.kick_offset = 0.7
	self.baka.crosshair.crouching.offset = 0.4
	self.baka.crosshair.crouching.moving_offset = 0.7
	self.baka.crosshair.crouching.kick_offset = 0.5
	self.baka.crosshair.steelsight.hidden = true
	self.baka.crosshair.steelsight.offset = 0
	self.baka.crosshair.steelsight.moving_offset = 0
	self.baka.crosshair.steelsight.kick_offset = 0.5
	self.baka.shake = {
		fire_multiplier = 1.1,
		fire_steelsight_multiplier = -1.1
	}
	self.baka.autohit = autohit_smg_default
	self.baka.aim_assist = aim_assist_smg_default
	self.baka.weapon_hold = "baka"
	self.baka.animations = {
		equip_id = "equip_baka",
		recoil_steelsight = true
	}
	self.baka.global_value = "dragon"
	self.baka.texture_bundle_folder = "dragon"
	self.baka.panic_suppression_chance = 0.2
	self.baka.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 4,
		recoil = 20,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 29
	}
	self.arblast = {
		categories = {"crossbow"},
		projectile_type_index = 17,
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.arblast.sounds.fire = "arblast_fire"
	self.arblast.sounds.fire_single = "arblast_fire"
	self.arblast.sounds.fire_auto = "arblast_fire"
	self.arblast.sounds.dryfire = "secondary_dryfire"
	self.arblast.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.arblast.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.arblast.timers = {
		reload_not_empty = 2.5,
		reload_empty = 2.5,
		unequip = 0.7,
		equip = 0.5
	}
	self.arblast.name_id = "bm_w_arblast"
	self.arblast.desc_id = "bm_w_arblast_desc"
	self.arblast.description_id = "des_arblast"
	self.arblast.muzzleflash = "effects/payday2/particles/weapons/shells/shell_empty"
	self.arblast.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.arblast.use_data = {selection_index = 2}
	self.arblast.DAMAGE = 1
	self.arblast.CLIP_AMMO_MAX = 1
	self.arblast.NR_CLIPS_MAX = 35
	self.arblast.AMMO_MAX = self.arblast.CLIP_AMMO_MAX * self.arblast.NR_CLIPS_MAX
	self.arblast.AMMO_PICKUP = self:_pickup_chance(0, 1)
	self.arblast.FIRE_MODE = "single"
	self.arblast.fire_mode_data = {fire_rate = 2.9}
	self.arblast.CAN_TOGGLE_FIREMODE = false
	self.arblast.single = {fire_rate = 0.05}
	self.arblast.spread = {
		standing = self.new_m4.spread.standing * 0.7,
		crouching = self.new_m4.spread.standing * 0.7,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.standing * 0.7,
		moving_crouching = self.new_m4.spread.standing * 0.7,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.arblast.kick = {standing = {
		-0.2,
		0.4,
		-1,
		1
	}}
	self.arblast.kick.crouching = self.arblast.kick.standing
	self.arblast.kick.steelsight = self.arblast.kick.standing
	self.arblast.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.arblast.crosshair.standing.offset = 0.4
	self.arblast.crosshair.standing.moving_offset = 0.7
	self.arblast.crosshair.standing.kick_offset = 0.6
	self.arblast.crosshair.crouching.offset = 0.3
	self.arblast.crosshair.crouching.moving_offset = 0.6
	self.arblast.crosshair.crouching.kick_offset = 0.4
	self.arblast.crosshair.steelsight.hidden = true
	self.arblast.crosshair.steelsight.offset = 0
	self.arblast.crosshair.steelsight.moving_offset = 0
	self.arblast.crosshair.steelsight.kick_offset = 0.4
	self.arblast.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.arblast.autohit = autohit_smg_default
	self.arblast.aim_assist = aim_assist_smg_default
	self.arblast.weapon_hold = "arblast"
	self.arblast.animations = {
		equip_id = "equip_arblast",
		recoil_steelsight = true
	}
	self.arblast.global_value = "steel"
	self.arblast.texture_bundle_folder = "steel"
	self.arblast.panic_suppression_chance = 0.2
	self.arblast.ignore_damage_upgrades = true
	self.arblast.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 20,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 28
	}
	self.arblast.stats_modifiers = {damage = 100}
	self.frankish = {
		categories = {"crossbow"},
		projectile_type_index = 20,
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.frankish.sounds.fire = "frankish_fire"
	self.frankish.sounds.fire_single = "frankish_fire"
	self.frankish.sounds.fire_auto = "frankish_fire"
	self.frankish.sounds.dryfire = "secondary_dryfire"
	self.frankish.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.frankish.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.frankish.timers = {
		reload_not_empty = 1.5,
		reload_empty = 1.5,
		unequip = 0.7,
		equip = 0.5
	}
	self.frankish.name_id = "bm_w_frankish"
	self.frankish.desc_id = "bm_w_frankish_desc"
	self.frankish.description_id = "des_frankish"
	self.frankish.muzzleflash = "effects/payday2/particles/weapons/shells/shell_empty"
	self.frankish.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.frankish.use_data = {selection_index = 2}
	self.frankish.DAMAGE = 1
	self.frankish.CLIP_AMMO_MAX = 1
	self.frankish.NR_CLIPS_MAX = 50
	self.frankish.AMMO_MAX = self.frankish.CLIP_AMMO_MAX * self.frankish.NR_CLIPS_MAX
	self.frankish.AMMO_PICKUP = self:_pickup_chance(0, 1)
	self.frankish.FIRE_MODE = "single"
	self.frankish.fire_mode_data = {fire_rate = 1.5}
	self.frankish.CAN_TOGGLE_FIREMODE = false
	self.frankish.single = {fire_rate = 0.05}
	self.frankish.spread = {
		standing = self.new_m4.spread.standing * 0.7,
		crouching = self.new_m4.spread.standing * 0.7,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.standing * 0.7,
		moving_crouching = self.new_m4.spread.standing * 0.7,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.frankish.kick = {standing = {
		-0.2,
		0.4,
		-1,
		1
	}}
	self.frankish.kick.crouching = self.frankish.kick.standing
	self.frankish.kick.steelsight = self.frankish.kick.standing
	self.frankish.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.frankish.crosshair.standing.offset = 0.4
	self.frankish.crosshair.standing.moving_offset = 0.7
	self.frankish.crosshair.standing.kick_offset = 0.6
	self.frankish.crosshair.crouching.offset = 0.3
	self.frankish.crosshair.crouching.moving_offset = 0.6
	self.frankish.crosshair.crouching.kick_offset = 0.4
	self.frankish.crosshair.steelsight.hidden = true
	self.frankish.crosshair.steelsight.offset = 0
	self.frankish.crosshair.steelsight.moving_offset = 0
	self.frankish.crosshair.steelsight.kick_offset = 0.4
	self.frankish.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.frankish.autohit = autohit_smg_default
	self.frankish.aim_assist = aim_assist_smg_default
	self.frankish.weapon_hold = "frankish"
	self.frankish.animations = {
		equip_id = "equip_frankish",
		recoil_steelsight = true
	}
	self.frankish.global_value = "steel"
	self.frankish.texture_bundle_folder = "steel"
	self.frankish.panic_suppression_chance = 0.2
	self.frankish.ignore_damage_upgrades = true
	self.frankish.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 75,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 29
	}
	self.frankish.stats_modifiers = {damage = 10}
	self.long = {
		categories = {"bow"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		projectile_type_index = 23,
		not_allowed_in_bleedout = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.long.sounds.charge_release = "long_release"
	self.long.sounds.charge_release_fail = "bow_release_fail"
	self.long.sounds.charge = "long_charge"
	self.long.sounds.charge_cancel = "bow_charge_cancel"
	self.long.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.long.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.long.timers = {reload_not_empty = 1.5}
	self.long.timers.reload_empty = self.long.timers.reload_not_empty
	self.long.timers.unequip = 0.85
	self.long.timers.equip = 0.85
	self.long.charge_data = {max_t = 1.5}
	self.long.name_id = "bm_w_long"
	self.long.desc_id = "bm_w_long_desc"
	self.long.description_id = "des_long"
	self.long.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.long.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.long.use_data = {
		selection_index = 2,
		align_place = "left_hand"
	}
	self.long.DAMAGE = 6
	self.long.CLIP_AMMO_MAX = 1
	self.long.NR_CLIPS_MAX = 35
	self.long.AMMO_MAX = self.long.CLIP_AMMO_MAX * self.long.NR_CLIPS_MAX
	self.long.AMMO_PICKUP = self:_pickup_chance(0, self.long.use_data.selection_index)
	self.long.FIRE_MODE = "single"
	self.long.fire_mode_data = {fire_rate = 0.2}
	self.long.single = {fire_rate = 0.2}
	self.long.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.long.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.long.kick.crouching = self.long.kick.standing
	self.long.kick.steelsight = self.long.kick.standing
	self.long.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.long.crosshair.standing.offset = 0.16
	self.long.crosshair.standing.moving_offset = 0.7
	self.long.crosshair.crouching.offset = 0.07
	self.long.crosshair.crouching.moving_offset = 0.7
	self.long.crosshair.crouching.kick_offset = 0.3
	self.long.crosshair.steelsight.hidden = true
	self.long.crosshair.steelsight.offset = 0
	self.long.crosshair.steelsight.moving_offset = 0
	self.long.crosshair.steelsight.kick_offset = 0.1
	self.long.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.long.autohit = autohit_shotgun_default
	self.long.aim_assist = aim_assist_shotgun_default
	self.long.animations = {
		equip_id = "equip_long",
		recoil_steelsight = false
	}
	self.long.global_value = "steel"
	self.long.texture_bundle_folder = "steel"
	self.long.panic_suppression_chance = 0.2
	self.long.ignore_damage_upgrades = true
	self.long.stats = {
		zoom = 5,
		total_ammo_mod = 21,
		damage = 20,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 29
	}
	self.long.stats_modifiers = {damage = 100}
	self.par = {
		categories = {"lmg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.par.sounds.fire = "svinet_fire_single"
	self.par.sounds.fire_single = "svinet_fire_single"
	self.par.sounds.fire_auto = "svinet_fire"
	self.par.sounds.stop_fire = "svinet_stop"
	self.par.sounds.dryfire = "primary_dryfire"
	self.par.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.par.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.par.timers = {
		reload_not_empty = 6.5,
		reload_empty = 6.5,
		unequip = 0.9,
		equip = 0.9,
		deploy_bipod = 0.85
	}
	self.par.bipod_camera_spin_limit = 40
	self.par.bipod_camera_pitch_limit = 15
	self.par.bipod_weapon_translation = Vector3(-8.5, 10, -5)
	self.par.bipod_deploy_multiplier = 1
	self.par.name_id = "bm_w_par"
	self.par.desc_id = "bm_w_par_desc"
	self.par.description_id = "des_par"
	self.par.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.par.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
	self.par.use_data = {selection_index = 2}
	self.par.DAMAGE = 1
	self.par.CLIP_AMMO_MAX = 200
	self.par.NR_CLIPS_MAX = 2
	self.par.AMMO_MAX = self.par.CLIP_AMMO_MAX * self.par.NR_CLIPS_MAX
	self.par.AMMO_PICKUP = self:_pickup_chance(self.par.AMMO_MAX, 1)
	self.par.FIRE_MODE = "auto"
	self.par.fire_mode_data = {fire_rate = 0.066}
	self.par.CAN_TOGGLE_FIREMODE = false
	self.par.auto = {fire_rate = 0.076}
	self.par.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight,
		bipod = default_bipod_spread
	}
	self.par.kick = {standing = {
		-0.2,
		0.8,
		-1,
		1.4
	}}
	self.par.kick.crouching = self.par.kick.standing
	self.par.kick.steelsight = self.par.kick.standing
	self.par.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.par.crosshair.standing.offset = 0.16
	self.par.crosshair.standing.moving_offset = 1
	self.par.crosshair.standing.kick_offset = 0.8
	self.par.crosshair.crouching.offset = 0.1
	self.par.crosshair.crouching.moving_offset = 0.6
	self.par.crosshair.crouching.kick_offset = 0.4
	self.par.crosshair.steelsight.hidden = true
	self.par.crosshair.steelsight.offset = 0
	self.par.crosshair.steelsight.moving_offset = 0
	self.par.crosshair.steelsight.kick_offset = 0.14
	self.par.shake = {
		fire_multiplier = 0.5,
		fire_steelsight_multiplier = -0.5
	}
	self.par.autohit = autohit_lmg_default
	self.par.aim_assist = aim_assist_lmg_default
	self.par.weapon_hold = "par"
	self.par.animations = {
		equip_id = "equip_par",
		recoil_steelsight = true,
		bipod_enter = "bipod_enter",
		bipod_exit = "bipod_exit",
		bipod_recoil = "bipod_recoil",
		bipod_recoil_enter = "bipod_recoil",
		bipod_recoil_loop = "bipod_recoil_loop",
		bipod_recoil_exit = "bipod_recoil_exit"
	}
	self.par.texture_bundle_folder = "par"
	self.par.panic_suppression_chance = 0.2
	self.par.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 37,
		alert_size = 8,
		spread = 9,
		spread_moving = 8,
		recoil = 10,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 2
	}
	self.sparrow = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.sparrow.sounds.fire = "sparrow_fire"
	self.sparrow.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.sparrow.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.sparrow.sounds.dryfire = "secondary_dryfire"
	self.sparrow.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.sparrow.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.sparrow.name_id = "bm_w_sparrow"
	self.sparrow.desc_id = "bm_w_sparrow_desc"
	self.sparrow.description_id = "des_sparrow"
	self.sparrow.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.sparrow.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.sparrow.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sparrow.use_data = {selection_index = 1}
	self.sparrow.DAMAGE = 1
	self.sparrow.CLIP_AMMO_MAX = 12
	self.sparrow.NR_CLIPS_MAX = 5
	self.sparrow.AMMO_MAX = self.sparrow.CLIP_AMMO_MAX * self.sparrow.NR_CLIPS_MAX
	self.sparrow.AMMO_PICKUP = self:_pickup_chance(self.sparrow.AMMO_MAX, 1)
	self.sparrow.FIRE_MODE = "single"
	self.sparrow.fire_mode_data = {fire_rate = 0.25}
	self.sparrow.single = {fire_rate = 0.25}
	self.sparrow.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.sparrow.kick = {standing = self.glock_17.kick.standing}
	self.sparrow.kick.crouching = self.sparrow.kick.standing
	self.sparrow.kick.steelsight = self.sparrow.kick.standing
	self.sparrow.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.sparrow.crosshair.standing.offset = 0.1
	self.sparrow.crosshair.standing.moving_offset = 0.4
	self.sparrow.crosshair.standing.kick_offset = 0.3
	self.sparrow.crosshair.crouching.offset = 0.1
	self.sparrow.crosshair.crouching.moving_offset = 0.5
	self.sparrow.crosshair.crouching.kick_offset = 0.2
	self.sparrow.crosshair.steelsight.hidden = true
	self.sparrow.crosshair.steelsight.offset = 0
	self.sparrow.crosshair.steelsight.moving_offset = 0
	self.sparrow.crosshair.steelsight.kick_offset = 0.1
	self.sparrow.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.sparrow.autohit = autohit_pistol_default
	self.sparrow.aim_assist = aim_assist_pistol_default
	self.sparrow.weapon_hold = "colt_1911"
	self.sparrow.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.sparrow.global_value = "berry"
	self.sparrow.texture_bundle_folder = "rip"
	self.sparrow.panic_suppression_chance = 0.2
	self.sparrow.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 120,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 9,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.model70 = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.model70.sounds.fire = "model70_fire"
	self.model70.sounds.dryfire = "primary_dryfire"
	self.model70.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.model70.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.model70.timers = {
		reload_not_empty = 3.35,
		reload_empty = 4.5,
		unequip = 0.45,
		equip = 0.75
	}
	self.model70.name_id = "bm_w_model70"
	self.model70.desc_id = "bm_w_model70_desc"
	self.model70.description_id = "des_model70"
	self.model70.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.model70.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.model70.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.model70.DAMAGE = 1
	self.model70.CLIP_AMMO_MAX = 5
	self.model70.NR_CLIPS_MAX = 6
	self.model70.AMMO_MAX = self.model70.CLIP_AMMO_MAX * self.model70.NR_CLIPS_MAX
	self.model70.AMMO_PICKUP = {
		0.7,
		1
	}
	self.model70.FIRE_MODE = "single"
	self.model70.fire_mode_data = {fire_rate = 1}
	self.model70.CAN_TOGGLE_FIREMODE = false
	self.model70.single = {fire_rate = 20}
	self.model70.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.model70.kick = {standing = {
		3,
		4.8,
		-0.3,
		0.3
	}}
	self.model70.kick.crouching = self.model70.kick.standing
	self.model70.kick.steelsight = self.model70.kick.standing
	self.model70.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.model70.crosshair.standing.offset = 1.14
	self.model70.crosshair.standing.moving_offset = 1.8
	self.model70.crosshair.standing.kick_offset = 1.6
	self.model70.crosshair.crouching.offset = 1.1
	self.model70.crosshair.crouching.moving_offset = 1.6
	self.model70.crosshair.crouching.kick_offset = 1.4
	self.model70.crosshair.steelsight.hidden = true
	self.model70.crosshair.steelsight.offset = 1
	self.model70.crosshair.steelsight.moving_offset = 1
	self.model70.crosshair.steelsight.kick_offset = 1.14
	self.model70.shake = {
		fire_multiplier = 3.5,
		fire_steelsight_multiplier = -3.5
	}
	self.model70.autohit = autohit_snp_default
	self.model70.aim_assist = aim_assist_snp_default
	self.model70.weapon_hold = "model70"
	self.model70.animations = {
		equip_id = "equip_model70",
		recoil_steelsight = true
	}
	self.model70.texture_bundle_folder = "berry"
	self.model70.can_shoot_through_enemy = true
	self.model70.can_shoot_through_shield = true
	self.model70.can_shoot_through_wall = true
	self.model70.panic_suppression_chance = 0.2
	self.model70.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 150,
		alert_size = 7,
		spread = 24,
		spread_moving = 24,
		recoil = 4,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 6
	}
	self.model70.armor_piercing_chance = 1
	self.model70.stats_modifiers = {damage = 2}
	self.m37 = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.m37.sounds.fire = "m37_fire"
	self.m37.sounds.dryfire = "shotgun_dryfire"
	self.m37.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.m37.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.m37.timers = {
		shotgun_reload_enter = 0.5,
		shotgun_reload_exit_empty = 0.7,
		shotgun_reload_exit_not_empty = 0.3,
		shotgun_reload_shell = 0.65,
		shotgun_reload_first_shell_offset = 0,
		unequip = 0.85,
		equip = 0.85
	}
	self.m37.name_id = "bm_w_m37"
	self.m37.desc_id = "bm_w_m37_desc"
	self.m37.description_id = "des_m37"
	self.m37.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.m37.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
	self.m37.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.m37.DAMAGE = 6
	self.m37.damage_near = 2000
	self.m37.damage_far = 3000
	self.m37.rays = 12
	self.m37.CLIP_AMMO_MAX = 7
	self.m37.NR_CLIPS_MAX = 4
	self.m37.AMMO_MAX = self.m37.CLIP_AMMO_MAX * self.m37.NR_CLIPS_MAX
	self.m37.AMMO_PICKUP = self:_pickup_chance(self.m37.AMMO_MAX, 1)
	self.m37.FIRE_MODE = "single"
	self.m37.fire_mode_data = {fire_rate = 0.575}
	self.m37.single = {fire_rate = 0.575}
	self.m37.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.m37.kick = {standing = {
		1.9,
		2,
		-0.2,
		0.2
	}}
	self.m37.kick.crouching = self.m37.kick.standing
	self.m37.kick.steelsight = {
		1.5,
		1.7,
		-0.2,
		0.2
	}
	self.m37.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.m37.crosshair.standing.offset = 0.7
	self.m37.crosshair.standing.moving_offset = 0.7
	self.m37.crosshair.standing.kick_offset = 0.8
	self.m37.crosshair.crouching.offset = 0.65
	self.m37.crosshair.crouching.moving_offset = 0.65
	self.m37.crosshair.crouching.kick_offset = 0.75
	self.m37.crosshair.steelsight.hidden = true
	self.m37.crosshair.steelsight.offset = 0
	self.m37.crosshair.steelsight.moving_offset = 0
	self.m37.crosshair.steelsight.kick_offset = 0
	self.m37.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.m37.autohit = autohit_shotgun_default
	self.m37.aim_assist = aim_assist_shotgun_default
	self.m37.weapon_hold = "m37"
	self.m37.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.m37.texture_bundle_folder = "peta"
	self.m37.global_value = "peta"
	self.m37.panic_suppression_chance = 0.2
	self.m37.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 155,
		alert_size = 7,
		spread = 12,
		spread_moving = 12,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 22
	}
	self.china = {
		categories = {"grenade_launcher"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		projectile_type_index = 27,
		projectile_type_indices = {launcher_incendiary = 28},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.china.sounds.fire = "china_fire"
	self.china.sounds.dryfire = "shotgun_dryfire"
	self.china.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.china.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.china.timers = {
		shotgun_reload_enter = 0.83,
		shotgun_reload_exit_empty = 2,
		shotgun_reload_exit_not_empty = 1,
		shotgun_reload_shell = 0.83,
		shotgun_reload_first_shell_offset = 0,
		unequip = 0.6,
		equip = 1
	}
	self.china.name_id = "bm_w_china"
	self.china.desc_id = "bm_w_china_desc"
	self.china.description_id = "des_china"
	self.china.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.china.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.china.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.china.DAMAGE = 6
	self.china.damage_near = 2000
	self.china.damage_far = 3000
	self.china.rays = 6
	self.china.CLIP_AMMO_MAX = 3
	self.china.NR_CLIPS_MAX = 2
	self.china.AMMO_MAX = self.china.CLIP_AMMO_MAX * self.china.NR_CLIPS_MAX
	self.china.AMMO_PICKUP = {
		0.05,
		0.65
	}
	self.china.FIRE_MODE = "single"
	self.china.fire_mode_data = {fire_rate = 1.2}
	self.china.single = {fire_rate = 1.2}
	self.china.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.china.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.china.kick.crouching = self.china.kick.standing
	self.china.kick.steelsight = self.china.kick.standing
	self.china.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.china.crosshair.standing.offset = 0.16
	self.china.crosshair.standing.moving_offset = 0.8
	self.china.crosshair.standing.kick_offset = 0.6
	self.china.crosshair.standing.hidden = true
	self.china.crosshair.crouching.offset = 0.08
	self.china.crosshair.crouching.moving_offset = 0.7
	self.china.crosshair.crouching.kick_offset = 0.4
	self.china.crosshair.crouching.hidden = true
	self.china.crosshair.steelsight.hidden = true
	self.china.crosshair.steelsight.offset = 0
	self.china.crosshair.steelsight.moving_offset = 0
	self.china.crosshair.steelsight.kick_offset = 0.1
	self.china.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.china.autohit = autohit_shotgun_default
	self.china.aim_assist = aim_assist_shotgun_default
	self.china.animations = {
		equip_id = "equip_china",
		recoil_steelsight = true
	}
	self.china.global_value = "pal"
	self.china.texture_bundle_folder = "lupus"
	self.china.panic_suppression_chance = 0.2
	self.china.ignore_damage_upgrades = true
	self.china.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 130,
		alert_size = 7,
		spread = 25,
		spread_moving = 6,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 18
	}
	self.china.stats_modifiers = {damage = 10}
	self.sr2 = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.sr2.sounds.fire = "sr2_fire_single"
	self.sr2.sounds.fire_single = "sr2_fire_single"
	self.sr2.sounds.fire_auto = "sr2_fire"
	self.sr2.sounds.stop_fire = "sr2_stop"
	self.sr2.sounds.dryfire = "secondary_dryfire"
	self.sr2.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.sr2.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.sr2.timers = {
		reload_not_empty = 2.07,
		reload_empty = 4,
		unequip = 0.55,
		equip = 0.5
	}
	self.sr2.name_id = "bm_w_sr2"
	self.sr2.desc_id = "bm_w_sr2_desc"
	self.sr2.description_id = "des_sr2"
	self.sr2.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.sr2.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.sr2.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.sr2.use_data = {selection_index = 1}
	self.sr2.DAMAGE = 1
	self.sr2.CLIP_AMMO_MAX = 32
	self.sr2.NR_CLIPS_MAX = 5
	self.sr2.AMMO_MAX = self.cobray.CLIP_AMMO_MAX * self.cobray.NR_CLIPS_MAX
	self.sr2.AMMO_PICKUP = self:_pickup_chance(self.cobray.AMMO_MAX, 3)
	self.sr2.FIRE_MODE = "auto"
	self.sr2.fire_mode_data = {fire_rate = 0.08}
	self.sr2.CAN_TOGGLE_FIREMODE = true
	self.sr2.auto = {fire_rate = 0.08}
	self.sr2.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.sr2.kick = {
		standing = {
			-0.6,
			1.2,
			-1,
			1
		},
		crouching = self.cobray.kick.standing,
		steelsight = self.cobray.kick.standing
	}
	self.sr2.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.sr2.crosshair.standing.offset = 0.4
	self.sr2.crosshair.standing.moving_offset = 0.7
	self.sr2.crosshair.standing.kick_offset = 0.6
	self.sr2.crosshair.crouching.offset = 0.3
	self.sr2.crosshair.crouching.moving_offset = 0.6
	self.sr2.crosshair.crouching.kick_offset = 0.4
	self.sr2.crosshair.steelsight.hidden = true
	self.sr2.crosshair.steelsight.offset = 0
	self.sr2.crosshair.steelsight.moving_offset = 0
	self.sr2.crosshair.steelsight.kick_offset = 0.4
	self.sr2.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.sr2.autohit = autohit_smg_default
	self.sr2.aim_assist = aim_assist_smg_default
	self.sr2.animations = {
		equip_id = "equip_cobray",
		recoil_steelsight = true
	}
	self.sr2.texture_bundle_folder = "coco"
	self.sr2.panic_suppression_chance = 0.2
	self.sr2.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 25
	}
	self.x_sr2 = {
		categories = {
			"akimbo",
			"smg"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_sr2.sounds.fire = "sr2_x_fire"
	self.x_sr2.sounds.fire_single = "sr2_x_fire_single"
	self.x_sr2.sounds.fire_auto = "sr2_x_fire"
	self.x_sr2.sounds.stop_fire = "sr2_x_stop"
	self.x_sr2.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_sr2.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_sr2.sounds.dryfire = "secondary_dryfire"
	self.x_sr2.timers = {
		reload_not_empty = 2,
		reload_empty = 2.5,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_sr2.name_id = "bm_w_x_sr2"
	self.x_sr2.desc_id = "bm_w_x_sr2_desc"
	self.x_sr2.description_id = "des_x_sr2"
	self.x_sr2.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_sr2.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_sr2.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_sr2.use_data = {selection_index = 2}
	self.x_sr2.DAMAGE = 1
	self.x_sr2.CLIP_AMMO_MAX = 64
	self.x_sr2.NR_CLIPS_MAX = 3
	self.x_sr2.AMMO_MAX = self.x_sr2.CLIP_AMMO_MAX * self.x_sr2.NR_CLIPS_MAX
	self.x_sr2.AMMO_PICKUP = self:_pickup_chance(self.x_sr2.AMMO_MAX, 1)
	self.x_sr2.FIRE_MODE = "auto"
	self.x_sr2.fire_mode_data = {fire_rate = 0.08}
	self.x_sr2.single = {fire_rate = 0.08}
	self.x_sr2.CAN_TOGGLE_FIREMODE = true
	self.x_sr2.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_sr2.kick = {standing = {
		1.4,
		1.2,
		-0.5,
		0.5
	}}
	self.x_sr2.kick.crouching = self.x_sr2.kick.standing
	self.x_sr2.kick.steelsight = self.x_sr2.kick.standing
	self.x_sr2.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_sr2.crosshair.standing.offset = 0.2
	self.x_sr2.crosshair.standing.moving_offset = 0.6
	self.x_sr2.crosshair.standing.kick_offset = 0.4
	self.x_sr2.crosshair.crouching.offset = 0.1
	self.x_sr2.crosshair.crouching.moving_offset = 0.6
	self.x_sr2.crosshair.crouching.kick_offset = 0.3
	self.x_sr2.crosshair.steelsight.hidden = true
	self.x_sr2.crosshair.steelsight.offset = 0
	self.x_sr2.crosshair.steelsight.moving_offset = 0
	self.x_sr2.crosshair.steelsight.kick_offset = 0.1
	self.x_sr2.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_sr2.autohit = autohit_smg_default
	self.x_sr2.aim_assist = aim_assist_smg_default
	self.x_sr2.weapon_hold = "x_sr2"
	self.x_sr2.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true
	}
	self.x_sr2.panic_suppression_chance = 0.2
	self.x_sr2.texture_bundle_folder = "coco"
	self.x_sr2.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 40,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 25
	}
	self.pl14 = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.pl14.sounds.fire = "pl14_fire"
	self.pl14.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.pl14.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.pl14.sounds.dryfire = "secondary_dryfire"
	self.pl14.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.pl14.timers = {
		reload_not_empty = 1.47,
		reload_empty = 2.12,
		unequip = 0.5,
		equip = 0.35
	}
	self.pl14.name_id = "bm_w_pl14"
	self.pl14.desc_id = "bm_w_pl14_desc"
	self.pl14.description_id = "des_pl14"
	self.pl14.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.pl14.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.pl14.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.pl14.use_data = {selection_index = 1}
	self.pl14.DAMAGE = 1
	self.pl14.CLIP_AMMO_MAX = 12
	self.pl14.NR_CLIPS_MAX = 5
	self.pl14.AMMO_MAX = self.pl14.CLIP_AMMO_MAX * self.pl14.NR_CLIPS_MAX
	self.pl14.AMMO_PICKUP = self:_pickup_chance(self.pl14.AMMO_MAX, 1)
	self.pl14.FIRE_MODE = "single"
	self.pl14.fire_mode_data = {fire_rate = 0.25}
	self.pl14.single = {fire_rate = 0.25}
	self.pl14.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.pl14.kick = {standing = self.glock_17.kick.standing}
	self.pl14.kick.crouching = self.pl14.kick.standing
	self.pl14.kick.steelsight = self.pl14.kick.standing
	self.pl14.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.pl14.crosshair.standing.offset = 0.1
	self.pl14.crosshair.standing.moving_offset = 0.4
	self.pl14.crosshair.standing.kick_offset = 0.3
	self.pl14.crosshair.crouching.offset = 0.1
	self.pl14.crosshair.crouching.moving_offset = 0.5
	self.pl14.crosshair.crouching.kick_offset = 0.2
	self.pl14.crosshair.steelsight.hidden = true
	self.pl14.crosshair.steelsight.offset = 0
	self.pl14.crosshair.steelsight.moving_offset = 0
	self.pl14.crosshair.steelsight.kick_offset = 0.1
	self.pl14.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.pl14.autohit = autohit_pistol_default
	self.pl14.aim_assist = aim_assist_pistol_default
	self.pl14.weapon_hold = "colt_1911"
	self.pl14.animations = {
		equip_id = "equip_glock",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.pl14.texture_bundle_folder = "mad"
	self.pl14.panic_suppression_chance = 0.2
	self.pl14.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 120,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 9,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.x_mp5 = {
		categories = {
			"akimbo",
			"smg"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_mp5.sounds.fire = "mp5_x_fire"
	self.x_mp5.sounds.fire_single = "mp5_x_fire_single"
	self.x_mp5.sounds.fire_auto = "mp5_x_fire"
	self.x_mp5.sounds.stop_fire = "mp5_x_stop"
	self.x_mp5.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_mp5.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_mp5.sounds.dryfire = "secondary_dryfire"
	self.x_mp5.timers = {
		reload_not_empty = 2.5,
		reload_empty = 3,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_mp5.name_id = "bm_w_x_mp5"
	self.x_mp5.desc_id = "bm_w_x_mp5_desc"
	self.x_mp5.description_id = "des_x_mp5"
	self.x_mp5.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_mp5.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_mp5.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_mp5.use_data = {selection_index = 2}
	self.x_mp5.DAMAGE = 1
	self.x_mp5.CLIP_AMMO_MAX = 60
	self.x_mp5.NR_CLIPS_MAX = 4
	self.x_mp5.AMMO_MAX = self.x_mp5.CLIP_AMMO_MAX * self.x_mp5.NR_CLIPS_MAX
	self.x_mp5.AMMO_PICKUP = self:_pickup_chance(self.x_mp5.AMMO_MAX, 1)
	self.x_mp5.FIRE_MODE = "auto"
	self.x_mp5.fire_mode_data = {fire_rate = 0.08}
	self.x_mp5.single = {fire_rate = 0.08}
	self.x_mp5.CAN_TOGGLE_FIREMODE = true
	self.x_mp5.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_mp5.kick = {standing = {
		1.4,
		1.2,
		-0.5,
		0.5
	}}
	self.x_mp5.kick.crouching = self.x_mp5.kick.standing
	self.x_mp5.kick.steelsight = self.x_mp5.kick.standing
	self.x_mp5.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_mp5.crosshair.standing.offset = 0.2
	self.x_mp5.crosshair.standing.moving_offset = 0.6
	self.x_mp5.crosshair.standing.kick_offset = 0.4
	self.x_mp5.crosshair.crouching.offset = 0.1
	self.x_mp5.crosshair.crouching.moving_offset = 0.6
	self.x_mp5.crosshair.crouching.kick_offset = 0.3
	self.x_mp5.crosshair.steelsight.hidden = true
	self.x_mp5.crosshair.steelsight.offset = 0
	self.x_mp5.crosshair.steelsight.moving_offset = 0
	self.x_mp5.crosshair.steelsight.kick_offset = 0.1
	self.x_mp5.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_mp5.autohit = autohit_smg_default
	self.x_mp5.aim_assist = aim_assist_smg_default
	self.x_mp5.weapon_hold = "x_akmsu"
	self.x_mp5.animations = {
		has_steelsight_stance = true,
		recoil_steelsight = true
	}
	self.x_mp5.panic_suppression_chance = 0.2
	self.x_mp5.texture_bundle_folder = "dos"
	self.x_mp5.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 36,
		alert_size = 7,
		spread = 8,
		spread_moving = 8,
		recoil = 20,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 17,
		concealment = 23
	}
	self.x_akmsu = {
		categories = {
			"akimbo",
			"smg"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_akmsu.sounds.fire = "akmsu_x_fire"
	self.x_akmsu.sounds.fire_single = "akmsu_x_fire_single"
	self.x_akmsu.sounds.fire_auto = "akmsu_x_fire"
	self.x_akmsu.sounds.stop_fire = "akmsu_x_stop"
	self.x_akmsu.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_akmsu.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_akmsu.sounds.dryfire = "secondary_dryfire"
	self.x_akmsu.timers = {
		reload_not_empty = 3,
		reload_empty = 3.5,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_akmsu.name_id = "bm_w_x_akmsu"
	self.x_akmsu.desc_id = "bm_w_x_akmsu_desc"
	self.x_akmsu.description_id = "des_x_akmsu"
	self.x_akmsu.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.x_akmsu.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_akmsu.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.x_akmsu.use_data = {selection_index = 2}
	self.x_akmsu.DAMAGE = 1
	self.x_akmsu.CLIP_AMMO_MAX = 60
	self.x_akmsu.NR_CLIPS_MAX = 2
	self.x_akmsu.AMMO_MAX = self.x_akmsu.CLIP_AMMO_MAX * self.x_akmsu.NR_CLIPS_MAX
	self.x_akmsu.AMMO_PICKUP = self:_pickup_chance(self.x_akmsu.AMMO_MAX, 1)
	self.x_akmsu.FIRE_MODE = "auto"
	self.x_akmsu.fire_mode_data = {fire_rate = 0.073}
	self.x_akmsu.single = {fire_rate = 0.073}
	self.x_akmsu.CAN_TOGGLE_FIREMODE = true
	self.x_akmsu.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_akmsu.kick = {standing = {
		1.4,
		1.2,
		-0.5,
		0.5
	}}
	self.x_akmsu.kick.crouching = self.x_akmsu.kick.standing
	self.x_akmsu.kick.steelsight = self.x_akmsu.kick.standing
	self.x_akmsu.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_akmsu.crosshair.standing.offset = 0.2
	self.x_akmsu.crosshair.standing.moving_offset = 0.6
	self.x_akmsu.crosshair.standing.kick_offset = 0.4
	self.x_akmsu.crosshair.crouching.offset = 0.1
	self.x_akmsu.crosshair.crouching.moving_offset = 0.6
	self.x_akmsu.crosshair.crouching.kick_offset = 0.3
	self.x_akmsu.crosshair.steelsight.hidden = true
	self.x_akmsu.crosshair.steelsight.offset = 0
	self.x_akmsu.crosshair.steelsight.moving_offset = 0
	self.x_akmsu.crosshair.steelsight.kick_offset = 0.1
	self.x_akmsu.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_akmsu.autohit = autohit_smg_default
	self.x_akmsu.aim_assist = aim_assist_smg_default
	self.x_akmsu.weapon_hold = "x_akmsu"
	self.x_akmsu.animations = {
		has_steelsight_stance = true,
		recoil_steelsight = true
	}
	self.x_akmsu.panic_suppression_chance = 0.2
	self.x_akmsu.texture_bundle_folder = "dos"
	self.x_akmsu.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 16,
		spread_moving = 16,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 21
	}
	self.tecci = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.tecci.sounds.fire = "tecci_fire_single"
	self.tecci.sounds.fire_single = "tecci_fire_single"
	self.tecci.sounds.fire_auto = "tecci_fire"
	self.tecci.sounds.stop_fire = "tecci_stop"
	self.tecci.sounds.dryfire = "primary_dryfire"
	self.tecci.sounds.enter_steelsight = "m4_tighten"
	self.tecci.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.tecci.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.tecci.timers = {
		reload_not_empty = 3.8,
		reload_empty = 4.7,
		unequip = 0.6,
		equip = 0.6
	}
	self.tecci.name_id = "bm_w_tecci"
	self.tecci.desc_id = "bm_w_tecci_desc"
	self.tecci.description_id = "des_tecci"
	self.tecci.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.tecci.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.tecci.use_data = {selection_index = 2}
	self.tecci.DAMAGE = 1
	self.tecci.CLIP_AMMO_MAX = 100
	self.tecci.NR_CLIPS_MAX = 2
	self.tecci.AMMO_MAX = self.tecci.CLIP_AMMO_MAX * self.tecci.NR_CLIPS_MAX
	self.tecci.AMMO_PICKUP = self:_pickup_chance(self.tecci.AMMO_MAX, 2)
	self.tecci.FIRE_MODE = "auto"
	self.tecci.fire_mode_data = {fire_rate = 0.09}
	self.tecci.CAN_TOGGLE_FIREMODE = true
	self.tecci.auto = {fire_rate = 0.1}
	self.tecci.spread = {standing = 3}
	self.tecci.spread.crouching = self.tecci.spread.standing * 0.4
	self.tecci.spread.steelsight = self.tecci.spread.standing * 0.4
	self.tecci.spread.moving_standing = self.tecci.spread.standing
	self.tecci.spread.moving_crouching = self.tecci.spread.standing
	self.tecci.spread.moving_steelsight = self.tecci.spread.steelsight
	self.tecci.kick = {standing = {
		0.6,
		0.8,
		-1,
		1
	}}
	self.tecci.kick.crouching = self.tecci.kick.standing
	self.tecci.kick.steelsight = self.tecci.kick.standing
	self.tecci.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.tecci.crosshair.standing.offset = 0.16
	self.tecci.crosshair.standing.moving_offset = 0.7
	self.tecci.crosshair.standing.kick_offset = 0.5
	self.tecci.crosshair.crouching.offset = 0.07
	self.tecci.crosshair.crouching.moving_offset = 0.7
	self.tecci.crosshair.crouching.kick_offset = 0.3
	self.tecci.crosshair.steelsight.hidden = true
	self.tecci.crosshair.steelsight.offset = 0
	self.tecci.crosshair.steelsight.moving_offset = 0
	self.tecci.crosshair.steelsight.kick_offset = 0.1
	self.tecci.shake = {
		fire_multiplier = 0.6,
		fire_steelsight_multiplier = -0.6
	}
	self.tecci.autohit = autohit_rifle_default
	self.tecci.aim_assist = aim_assist_rifle_default
	self.tecci.weapon_hold = "tecci"
	self.tecci.animations = {}
	self.famas.animations.equip_id = "equip_tecci"
	self.tecci.animations.recoil_steelsight = true
	self.tecci.global_value = "opera"
	self.tecci.texture_bundle_folder = "opera"
	self.tecci.transition_duration = 0.02
	self.tecci.panic_suppression_chance = 0.2
	self.tecci.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 38,
		alert_size = 7,
		spread = 7,
		spread_moving = 10,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 20
	}
	self.hajk = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.hajk.sounds.fire = "hajk_fire_single"
	self.hajk.sounds.fire_single = "hajk_fire_single"
	self.hajk.sounds.fire_auto = "hajk_fire"
	self.hajk.sounds.stop_fire = "hajk_stop"
	self.hajk.sounds.dryfire = "primary_dryfire"
	self.hajk.sounds.enter_steelsight = "m4_tighten"
	self.hajk.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.hajk.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.hajk.timers = {
		reload_not_empty = 2,
		reload_empty = 3.5,
		unequip = 0.6,
		equip = 0.6
	}
	self.hajk.name_id = "bm_w_hajk"
	self.hajk.desc_id = "bm_w_hajk_desc"
	self.hajk.description_id = "des_hajk"
	self.hajk.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.hajk.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.hajk.use_data = {selection_index = 1}
	self.hajk.DAMAGE = 1
	self.hajk.CLIP_AMMO_MAX = 30
	self.hajk.NR_CLIPS_MAX = 3
	self.hajk.AMMO_MAX = self.hajk.CLIP_AMMO_MAX * self.hajk.NR_CLIPS_MAX
	self.hajk.AMMO_PICKUP = self:_pickup_chance(self.hajk.AMMO_MAX, 1)
	self.hajk.FIRE_MODE = "auto"
	self.hajk.fire_mode_data = {fire_rate = 0.08}
	self.hajk.CAN_TOGGLE_FIREMODE = true
	self.hajk.auto = {fire_rate = 0.08}
	self.hajk.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.hajk.kick = {standing = {
		-0.6,
		1.2,
		-1,
		1
	}}
	self.hajk.kick.crouching = self.hajk.kick.standing
	self.hajk.kick.steelsight = self.hajk.kick.standing
	self.hajk.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.hajk.crosshair.standing.offset = 0.4
	self.hajk.crosshair.standing.moving_offset = 0.7
	self.hajk.crosshair.standing.kick_offset = 0.6
	self.hajk.crosshair.crouching.offset = 0.3
	self.hajk.crosshair.crouching.moving_offset = 0.6
	self.hajk.crosshair.crouching.kick_offset = 0.4
	self.hajk.crosshair.steelsight.hidden = true
	self.hajk.crosshair.steelsight.offset = 0
	self.hajk.crosshair.steelsight.moving_offset = 0
	self.hajk.crosshair.steelsight.kick_offset = 0.4
	self.hajk.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.hajk.autohit = autohit_smg_default
	self.hajk.aim_assist = aim_assist_smg_default
	self.hajk.animations = {
		equip_id = "equip_hajk",
		recoil_steelsight = true
	}
	self.hajk.texture_bundle_folder = "born"
	self.hajk.global_value = "born"
	self.hajk.panic_suppression_chance = 0.2
	self.hajk.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 19,
		spread_moving = 15,
		recoil = 18,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 18
	}
	self.boot = {
		categories = {"shotgun"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.boot.sounds.fire = "boot_fire"
	self.boot.sounds.dryfire = "shotgun_dryfire"
	self.boot.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.boot.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.boot.timers = {
		shotgun_reload_enter = 0.733,
		shotgun_reload_exit_empty = 1.1,
		shotgun_reload_exit_not_empty = 0.75,
		shotgun_reload_shell = 0.33,
		shotgun_reload_first_shell_offset = 0,
		unequip = 0.55,
		equip = 0.85
	}
	self.boot.name_id = "bm_w_boot"
	self.boot.desc_id = "bm_w_boot_desc"
	self.boot.description_id = "des_boot"
	self.boot.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.boot.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.boot.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.boot.DAMAGE = 6
	self.boot.damage_near = 2000
	self.boot.damage_far = 3000
	self.boot.rays = 12
	self.boot.CLIP_AMMO_MAX = 7
	self.boot.NR_CLIPS_MAX = 3
	self.boot.AMMO_MAX = self.boot.CLIP_AMMO_MAX * self.boot.NR_CLIPS_MAX
	self.boot.AMMO_PICKUP = self:_pickup_chance(self.boot.AMMO_MAX, 1)
	self.boot.FIRE_MODE = "single"
	self.boot.fire_mode_data = {fire_rate = 0.75}
	self.boot.single = {fire_rate = 0.75}
	self.boot.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.boot.kick = {standing = {
		1.9,
		2,
		-0.2,
		0.2
	}}
	self.boot.kick.crouching = self.boot.kick.standing
	self.boot.kick.steelsight = {
		1.5,
		1.7,
		-0.2,
		0.2
	}
	self.boot.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.boot.crosshair.standing.offset = 0.7
	self.boot.crosshair.standing.moving_offset = 0.7
	self.boot.crosshair.standing.kick_offset = 0.8
	self.boot.crosshair.crouching.offset = 0.65
	self.boot.crosshair.crouching.moving_offset = 0.65
	self.boot.crosshair.crouching.kick_offset = 0.75
	self.boot.crosshair.steelsight.hidden = true
	self.boot.crosshair.steelsight.offset = 0
	self.boot.crosshair.steelsight.moving_offset = 0
	self.boot.crosshair.steelsight.kick_offset = 0
	self.boot.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.boot.autohit = autohit_shotgun_default
	self.boot.aim_assist = aim_assist_shotgun_default
	self.boot.weapon_hold = "boot"
	self.boot.animations = {
		equip_id = "equip_r870_shotgun",
		recoil_steelsight = true
	}
	self.boot.texture_bundle_folder = "wild"
	self.boot.global_value = "wild"
	self.boot.panic_suppression_chance = 0.2
	self.boot.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 155,
		alert_size = 7,
		spread = 13,
		spread_moving = 12,
		recoil = 8,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 20
	}
	self.packrat = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.packrat.sounds.fire = "packrat_fire"
	self.packrat.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.packrat.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.packrat.sounds.dryfire = "secondary_dryfire"
	self.packrat.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.packrat.timers = {
		reload_not_empty = 1.52,
		reload_empty = 2.32,
		unequip = 0.5,
		equip = 0.35
	}
	self.packrat.name_id = "bm_w_packrat"
	self.packrat.desc_id = "bm_w_packrat_desc"
	self.packrat.description_id = "des_packrat"
	self.packrat.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.packrat.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.packrat.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.packrat.use_data = {selection_index = 1}
	self.packrat.DAMAGE = 1
	self.packrat.CLIP_AMMO_MAX = 15
	self.packrat.NR_CLIPS_MAX = 6
	self.packrat.AMMO_MAX = self.packrat.CLIP_AMMO_MAX * self.packrat.NR_CLIPS_MAX
	self.packrat.AMMO_PICKUP = self:_pickup_chance(self.packrat.AMMO_MAX, 1)
	self.packrat.FIRE_MODE = "single"
	self.packrat.fire_mode_data = {fire_rate = 0.166}
	self.packrat.single = {fire_rate = 0.166}
	self.packrat.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.packrat.kick = {standing = self.glock_17.kick.standing}
	self.packrat.kick.crouching = self.packrat.kick.standing
	self.packrat.kick.steelsight = self.packrat.kick.standing
	self.packrat.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.packrat.crosshair.standing.offset = 0.1
	self.packrat.crosshair.standing.moving_offset = 0.4
	self.packrat.crosshair.standing.kick_offset = 0.3
	self.packrat.crosshair.crouching.offset = 0.1
	self.packrat.crosshair.crouching.moving_offset = 0.5
	self.packrat.crosshair.crouching.kick_offset = 0.2
	self.packrat.crosshair.steelsight.hidden = true
	self.packrat.crosshair.steelsight.offset = 0
	self.packrat.crosshair.steelsight.moving_offset = 0
	self.packrat.crosshair.steelsight.kick_offset = 0.1
	self.packrat.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.packrat.autohit = autohit_pistol_default
	self.packrat.aim_assist = aim_assist_pistol_default
	self.packrat.weapon_hold = "packrat"
	self.packrat.animations = {
		equip_id = "equip_packrat",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.packrat.global_value = "pim"
	self.packrat.texture_bundle_folder = "pim"
	self.packrat.panic_suppression_chance = 0.2
	self.packrat.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 66,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 16,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.schakal = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.schakal.sounds.fire = "schakal_fire_single"
	self.schakal.sounds.fire_single = "schakal_fire_single"
	self.schakal.sounds.fire_auto = "schakal_fire"
	self.schakal.sounds.stop_fire = "schakal_stop"
	self.schakal.sounds.dryfire = "secondary_dryfire"
	self.schakal.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.schakal.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.schakal.timers = {
		reload_not_empty = 2.36,
		reload_empty = 3.62,
		unequip = 0.6,
		equip = 0.5
	}
	self.schakal.name_id = "bm_w_schakal"
	self.schakal.desc_id = "bm_w_schakal_desc"
	self.schakal.description_id = "des_schakal"
	self.schakal.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.schakal.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.schakal.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.schakal.use_data = {selection_index = 1}
	self.schakal.DAMAGE = 1
	self.schakal.CLIP_AMMO_MAX = 30
	self.schakal.NR_CLIPS_MAX = 3
	self.schakal.AMMO_MAX = self.schakal.CLIP_AMMO_MAX * self.schakal.NR_CLIPS_MAX
	self.schakal.AMMO_PICKUP = self:_pickup_chance(self.schakal.AMMO_MAX, 1)
	self.schakal.FIRE_MODE = "auto"
	self.schakal.fire_mode_data = {fire_rate = 0.092}
	self.schakal.CAN_TOGGLE_FIREMODE = true
	self.schakal.auto = {fire_rate = 0.092}
	self.schakal.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.schakal.kick = {standing = {
		-0.2,
		0.4,
		-1,
		1
	}}
	self.schakal.kick.crouching = self.schakal.kick.standing
	self.schakal.kick.steelsight = self.schakal.kick.standing
	self.schakal.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.schakal.crosshair.standing.offset = 0.4
	self.schakal.crosshair.standing.moving_offset = 0.7
	self.schakal.crosshair.standing.kick_offset = 0.6
	self.schakal.crosshair.crouching.offset = 0.3
	self.schakal.crosshair.crouching.moving_offset = 0.6
	self.schakal.crosshair.crouching.kick_offset = 0.4
	self.schakal.crosshair.steelsight.hidden = true
	self.schakal.crosshair.steelsight.offset = 0
	self.schakal.crosshair.steelsight.moving_offset = 0
	self.schakal.crosshair.steelsight.kick_offset = 0.4
	self.schakal.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.schakal.autohit = autohit_smg_default
	self.schakal.aim_assist = aim_assist_smg_default
	self.schakal.weapon_hold = "schakal"
	self.schakal.animations = {
		equip_id = "equip_schakal",
		recoil_steelsight = true
	}
	self.schakal.global_value = "pim"
	self.schakal.texture_bundle_folder = "pim"
	self.schakal.panic_suppression_chance = 0.2
	self.schakal.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 16,
		spread_moving = 14,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 24
	}
	self.desertfox = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.desertfox.sounds.fire = "desertfox_fire"
	self.desertfox.sounds.dryfire = "primary_dryfire"
	self.desertfox.sounds.enter_steelsight = "lmg_steelsight_enter"
	self.desertfox.sounds.leave_steelsight = "lmg_steelsight_exit"
	self.desertfox.timers = {
		reload_not_empty = 2.72,
		reload_empty = 3.86,
		unequip = 0.45,
		equip = 0.75
	}
	self.desertfox.name_id = "bm_w_desertfox"
	self.desertfox.desc_id = "bm_w_desertfox_desc"
	self.desertfox.description_id = "des_desertfox"
	self.desertfox.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.desertfox.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.desertfox.use_data = {
		selection_index = 2,
		align_place = "right_hand"
	}
	self.desertfox.DAMAGE = 1
	self.desertfox.CLIP_AMMO_MAX = 5
	self.desertfox.NR_CLIPS_MAX = 6
	self.desertfox.AMMO_MAX = self.desertfox.CLIP_AMMO_MAX * self.desertfox.NR_CLIPS_MAX
	self.desertfox.AMMO_PICKUP = {
		0.7,
		1
	}
	self.desertfox.FIRE_MODE = "single"
	self.desertfox.fire_mode_data = {fire_rate = 1}
	self.desertfox.CAN_TOGGLE_FIREMODE = false
	self.desertfox.single = {fire_rate = 20}
	self.desertfox.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.desertfox.kick = {standing = {
		3,
		4.8,
		-0.3,
		0.3
	}}
	self.desertfox.kick.crouching = self.desertfox.kick.standing
	self.desertfox.kick.steelsight = self.desertfox.kick.standing
	self.desertfox.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.desertfox.crosshair.standing.offset = 1.14
	self.desertfox.crosshair.standing.moving_offset = 1.8
	self.desertfox.crosshair.standing.kick_offset = 1.6
	self.desertfox.crosshair.crouching.offset = 1.1
	self.desertfox.crosshair.crouching.moving_offset = 1.6
	self.desertfox.crosshair.crouching.kick_offset = 1.4
	self.desertfox.crosshair.steelsight.hidden = true
	self.desertfox.crosshair.steelsight.offset = 1
	self.desertfox.crosshair.steelsight.moving_offset = 1
	self.desertfox.crosshair.steelsight.kick_offset = 1.14
	self.desertfox.shake = {
		fire_multiplier = 3.5,
		fire_steelsight_multiplier = -3.5
	}
	self.desertfox.autohit = autohit_snp_default
	self.desertfox.aim_assist = aim_assist_snp_default
	self.desertfox.weapon_hold = "desertfox"
	self.desertfox.animations = {
		equip_id = "equip_desertfox",
		recoil_steelsight = true
	}
	self.desertfox.global_value = "pim"
	self.desertfox.texture_bundle_folder = "pim"
	self.desertfox.can_shoot_through_enemy = true
	self.desertfox.can_shoot_through_shield = true
	self.desertfox.can_shoot_through_wall = true
	self.desertfox.panic_suppression_chance = 0.2
	self.desertfox.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 150,
		alert_size = 7,
		spread = 20,
		spread_moving = 24,
		recoil = 4,
		value = 10,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 19
	}
	self.desertfox.armor_piercing_chance = 1
	self.desertfox.stats_modifiers = {damage = 2}
	self.x_packrat = {
		categories = {
			"akimbo",
			"pistol"
		},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_packrat.sounds.fire = "packrat_fire"
	self.x_packrat.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_packrat.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_packrat.sounds.dryfire = "secondary_dryfire"
	self.x_packrat.sounds.magazine_empty = "wp_akimbo_pistol_slide_lock"
	self.x_packrat.timers = {
		reload_not_empty = 3.17,
		reload_empty = 4,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_packrat.name_id = "bm_w_x_packrat"
	self.x_packrat.desc_id = "bm_w_x_packrat_desc"
	self.x_packrat.description_id = "des_x_packrat"
	self.x_packrat.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_packrat.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_packrat.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.x_packrat.use_data = {selection_index = 2}
	self.x_packrat.DAMAGE = 1
	self.x_packrat.CLIP_AMMO_MAX = 30
	self.x_packrat.NR_CLIPS_MAX = 3
	self.x_packrat.AMMO_MAX = self.x_packrat.CLIP_AMMO_MAX * self.x_packrat.NR_CLIPS_MAX
	self.x_packrat.AMMO_PICKUP = self:_pickup_chance(self.x_packrat.AMMO_MAX, 1)
	self.x_packrat.FIRE_MODE = "single"
	self.x_packrat.fire_mode_data = {fire_rate = 0.166}
	self.x_packrat.single = {fire_rate = 0.166}
	self.x_packrat.spread = {
		standing = self.colt_1911.spread.standing,
		crouching = self.colt_1911.spread.crouching,
		steelsight = self.colt_1911.spread.steelsight,
		moving_standing = self.colt_1911.spread.moving_standing,
		moving_crouching = self.colt_1911.spread.moving_crouching,
		moving_steelsight = self.colt_1911.spread.moving_steelsight
	}
	self.x_packrat.kick = {standing = {
		1.6,
		1.3,
		-0.3,
		0.3
	}}
	self.x_packrat.kick.crouching = self.x_packrat.kick.standing
	self.x_packrat.kick.steelsight = self.x_packrat.kick.standing
	self.x_packrat.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_packrat.crosshair.standing.offset = 0.2
	self.x_packrat.crosshair.standing.moving_offset = 0.6
	self.x_packrat.crosshair.standing.kick_offset = 0.4
	self.x_packrat.crosshair.crouching.offset = 0.1
	self.x_packrat.crosshair.crouching.moving_offset = 0.6
	self.x_packrat.crosshair.crouching.kick_offset = 0.3
	self.x_packrat.crosshair.steelsight.hidden = true
	self.x_packrat.crosshair.steelsight.offset = 0
	self.x_packrat.crosshair.steelsight.moving_offset = 0
	self.x_packrat.crosshair.steelsight.kick_offset = 0.1
	self.x_packrat.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_packrat.autohit = autohit_pistol_default
	self.x_packrat.aim_assist = aim_assist_pistol_default
	self.x_packrat.weapon_hold = "jowi_pistol"
	self.x_packrat.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.x_packrat.global_value = "pim"
	self.x_packrat.texture_bundle_folder = "pim"
	self.x_packrat.panic_suppression_chance = 0.2
	self.x_packrat.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 66,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 16,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 27
	}
	self.rota = {
		categories = {"shotgun"},
		has_magazine = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.rota.sounds.fire = "rota_fire"
	self.rota.sounds.dryfire = "shotgun_dryfire"
	self.rota.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.rota.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.rota.timers = {
		reload_not_empty = 2.55,
		reload_empty = 2.55,
		unequip = 0.6,
		equip = 0.6
	}
	self.rota.name_id = "bm_w_rota"
	self.rota.desc_id = "bm_w_rota_desc"
	self.rota.description_id = "des_rota"
	self.rota.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.rota.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.rota.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.rota.DAMAGE = 6
	self.rota.damage_near = 2000
	self.rota.damage_far = 3000
	self.rota.rays = 12
	self.rota.CLIP_AMMO_MAX = 6
	self.rota.NR_CLIPS_MAX = 9
	self.rota.AMMO_MAX = self.rota.CLIP_AMMO_MAX * self.rota.NR_CLIPS_MAX
	self.rota.AMMO_PICKUP = self:_pickup_chance(self.rota.AMMO_MAX, 4)
	self.rota.FIRE_MODE = "single"
	self.rota.fire_mode_data = {fire_rate = 0.18}
	self.rota.CAN_TOGGLE_FIREMODE = false
	self.rota.single = {fire_rate = 0.18}
	self.rota.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.rota.kick = {standing = self.r870.kick.standing}
	self.rota.kick.crouching = self.rota.kick.standing
	self.rota.kick.steelsight = self.r870.kick.steelsight
	self.rota.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.rota.crosshair.standing.offset = 0.7
	self.rota.crosshair.standing.moving_offset = 0.7
	self.rota.crosshair.standing.kick_offset = 0.8
	self.rota.crosshair.crouching.offset = 0.65
	self.rota.crosshair.crouching.moving_offset = 0.65
	self.rota.crosshair.crouching.kick_offset = 0.75
	self.rota.crosshair.steelsight.hidden = true
	self.rota.crosshair.steelsight.offset = 0
	self.rota.crosshair.steelsight.moving_offset = 0
	self.rota.crosshair.steelsight.kick_offset = 0
	self.rota.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 1.25
	}
	self.rota.autohit = autohit_shotgun_default
	self.rota.aim_assist = aim_assist_shotgun_default
	self.rota.weapon_hold = "rota"
	self.rota.animations = {
		equip_id = "equip_rota",
		recoil_steelsight = true
	}
	self.rota.texture_bundle_folder = "rota"
	self.rota.global_value = "rota"
	self.rota.panic_suppression_chance = 0.2
	self.rota.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 42,
		alert_size = 7,
		spread = 15,
		spread_moving = 8,
		recoil = 12,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 13
	}
	self.arbiter = {
		categories = {"grenade_launcher"},
		projectile_type_index = 33,
		projectile_type_indices = {launcher_incendiary = 34},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.arbiter.sounds.fire = "arbiter_fire"
	self.arbiter.sounds.dryfire = "shotgun_dryfire"
	self.arbiter.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.arbiter.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.arbiter.timers = {
		reload_not_empty = 3.34,
		reload_empty = 4.5,
		unequip = 0.6,
		equip = 0.6
	}
	self.arbiter.name_id = "bm_w_arbiter"
	self.arbiter.desc_id = "bm_w_arbiter_desc"
	self.arbiter.description_id = "des_arbiter"
	self.arbiter.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.arbiter.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.arbiter.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.arbiter.DAMAGE = 6
	self.arbiter.damage_near = 2000
	self.arbiter.damage_far = 3000
	self.arbiter.rays = 6
	self.arbiter.CLIP_AMMO_MAX = 5
	self.arbiter.NR_CLIPS_MAX = 3
	self.arbiter.AMMO_MAX = self.arbiter.CLIP_AMMO_MAX * self.arbiter.NR_CLIPS_MAX
	self.arbiter.AMMO_PICKUP = {
		0.05,
		0.65
	}
	self.arbiter.FIRE_MODE = "single"
	self.arbiter.fire_mode_data = {fire_rate = 0.75}
	self.arbiter.single = {fire_rate = 1}
	self.arbiter.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.arbiter.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.arbiter.kick.crouching = self.arbiter.kick.standing
	self.arbiter.kick.steelsight = self.arbiter.kick.standing
	self.arbiter.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.arbiter.crosshair.standing.offset = 0.16
	self.arbiter.crosshair.standing.moving_offset = 0.8
	self.arbiter.crosshair.standing.kick_offset = 0.6
	self.arbiter.crosshair.standing.hidden = true
	self.arbiter.crosshair.crouching.offset = 0.08
	self.arbiter.crosshair.crouching.moving_offset = 0.7
	self.arbiter.crosshair.crouching.kick_offset = 0.4
	self.arbiter.crosshair.crouching.hidden = true
	self.arbiter.crosshair.steelsight.hidden = true
	self.arbiter.crosshair.steelsight.offset = 0
	self.arbiter.crosshair.steelsight.moving_offset = 0
	self.arbiter.crosshair.steelsight.kick_offset = 0.1
	self.arbiter.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.arbiter.autohit = autohit_shotgun_default
	self.arbiter.aim_assist = aim_assist_shotgun_default
	self.arbiter.animations = {
		equip_id = "equip_arbiter",
		recoil_steelsight = true
	}
	self.arbiter.global_value = "tango"
	self.arbiter.texture_bundle_folder = "tng"
	self.arbiter.panic_suppression_chance = 0.2
	self.arbiter.ignore_damage_upgrades = true
	self.arbiter.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 70,
		alert_size = 7,
		spread = 25,
		spread_moving = 6,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 18
	}
	self.arbiter.stats_modifiers = {damage = 10}
	self.arbiter.unlock_func = "has_unlocked_arbiter"
	self.contraband = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.contraband.sounds.fire = "contraband_fire_single"
	self.contraband.sounds.fire_single = "contraband_fire_single"
	self.contraband.sounds.fire_auto = "contraband_fire"
	self.contraband.sounds.stop_fire = "contraband_stop"
	self.contraband.sounds.dryfire = "primary_dryfire"
	self.contraband.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.contraband.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.contraband.timers = {
		reload_not_empty = 2.55,
		reload_empty = 3.2,
		unequip = 0.6,
		equip = 0.5
	}
	self.contraband.name_id = "bm_w_contraband"
	self.contraband.desc_id = "bm_w_contraband_desc"
	self.contraband.description_id = "des_contraband"
	self.contraband.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.contraband.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.contraband.use_data = {selection_index = 2}
	self.contraband.DAMAGE = 1
	self.contraband.CLIP_AMMO_MAX = 20
	self.contraband.NR_CLIPS_MAX = 2
	self.contraband.AMMO_MAX = self.contraband.CLIP_AMMO_MAX * self.contraband.NR_CLIPS_MAX
	self.contraband.AMMO_PICKUP = self:_pickup_chance(self.contraband.AMMO_MAX, 1)
	self.contraband.FIRE_MODE = "single"
	self.contraband.fire_mode_data = {fire_rate = 0.098}
	self.contraband.CAN_TOGGLE_FIREMODE = true
	self.contraband.auto = {fire_rate = 0.098}
	self.contraband.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.contraband.kick = {standing = self.new_m4.kick.standing}
	self.contraband.kick.crouching = self.contraband.kick.standing
	self.contraband.kick.steelsight = self.contraband.kick.standing
	self.contraband.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.contraband.crosshair.standing.offset = 0.14
	self.contraband.crosshair.standing.moving_offset = 0.8
	self.contraband.crosshair.standing.kick_offset = 0.6
	self.contraband.crosshair.crouching.offset = 0.1
	self.contraband.crosshair.crouching.moving_offset = 0.6
	self.contraband.crosshair.crouching.kick_offset = 0.4
	self.contraband.crosshair.steelsight.hidden = true
	self.contraband.crosshair.steelsight.offset = 0
	self.contraband.crosshair.steelsight.moving_offset = 0
	self.contraband.crosshair.steelsight.kick_offset = 0.14
	self.contraband.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.contraband.autohit = autohit_rifle_default
	self.contraband.aim_assist = aim_assist_rifle_default
	self.contraband.weapon_hold = "contraband"
	self.contraband.animations = {
		equip_id = "equip_contraband",
		recoil_steelsight = true
	}
	self.contraband.global_value = "chico"
	self.contraband.texture_bundle_folder = "chico"
	self.contraband.panic_suppression_chance = 0.2
	self.contraband.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 7,
		spread = 19,
		spread_moving = 15,
		recoil = 12,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 8,
		concealment = 8
	}
	self.contraband_m203 = {
		categories = {"grenade_launcher"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.contraband_m203.sounds.fire = "contrabandm203_fire"
	self.contraband_m203.sounds.dryfire = "shotgun_dryfire"
	self.contraband_m203.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.contraband_m203.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.contraband_m203.timers = {
		reload_not_empty = 2.45,
		reload_empty = 2.45,
		unequip = 0.6,
		equip = 0.6,
		equip_underbarrel = 0.4,
		unequip_underbarrel = 0.4
	}
	self.contraband_m203.name_id = "bm_w_contraband_m203"
	self.contraband_m203.desc_id = "bm_w_contraband_m203_desc"
	self.contraband_m203.description_id = "des_contraband_m203"
	self.contraband_m203.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.contraband_m203.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.contraband_m203.use_data = {
		selection_index = 3,
		align_place = "right_hand"
	}
	self.contraband_m203.DAMAGE = 6
	self.contraband_m203.damage_near = 2000
	self.contraband_m203.damage_far = 3000
	self.contraband_m203.rays = 6
	self.contraband_m203.CLIP_AMMO_MAX = 1
	self.contraband_m203.NR_CLIPS_MAX = 3
	self.contraband_m203.AMMO_MAX = self.contraband_m203.CLIP_AMMO_MAX * self.contraband_m203.NR_CLIPS_MAX
	self.contraband_m203.AMMO_PICKUP = self:_pickup_chance(20, 1)
	self.contraband_m203.FIRE_MODE = "single"
	self.contraband_m203.fire_mode_data = {fire_rate = 0.75}
	self.contraband_m203.single = {fire_rate = 0.75}
	self.contraband_m203.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.contraband_m203.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.contraband_m203.kick.crouching = self.contraband_m203.kick.standing
	self.contraband_m203.kick.steelsight = self.contraband_m203.kick.standing
	self.contraband_m203.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.contraband_m203.crosshair.standing.offset = 0.16
	self.contraband_m203.crosshair.standing.moving_offset = 0.8
	self.contraband_m203.crosshair.standing.kick_offset = 0.6
	self.contraband_m203.crosshair.standing.hidden = true
	self.contraband_m203.crosshair.crouching.offset = 0.08
	self.contraband_m203.crosshair.crouching.moving_offset = 0.7
	self.contraband_m203.crosshair.crouching.kick_offset = 0.4
	self.contraband_m203.crosshair.crouching.hidden = true
	self.contraband_m203.crosshair.steelsight.hidden = true
	self.contraband_m203.crosshair.steelsight.offset = 0
	self.contraband_m203.crosshair.steelsight.moving_offset = 0
	self.contraband_m203.crosshair.steelsight.kick_offset = 0.1
	self.contraband_m203.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.contraband_m203.autohit = autohit_shotgun_default
	self.contraband_m203.aim_assist = aim_assist_shotgun_default
	self.contraband_m203.animations = {
		equip_id = "equip_contraband_m203",
		recoil_steelsight = true
	}
	self.contraband_m203.global_value = "gage_pack_assault"
	self.contraband_m203.texture_bundle_folder = "gage_pack_assault"
	self.contraband_m203.panic_suppression_chance = 0.2
	self.contraband_m203.ignore_damage_upgrades = true
	self.contraband_m203.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 130,
		alert_size = 7,
		spread = 25,
		spread_moving = 6,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 18
	}
	self.contraband_m203.stats_modifiers = {damage = 10}
	self.ray = {
		categories = {"grenade_launcher"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		has_description = true,
		projectile_type_index = 37,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.ray.sounds.fire = "ray_fire"
	self.ray.sounds.dryfire = "shotgun_dryfire"
	self.ray.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.ray.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.ray.timers = {
		reload_not_empty = 6,
		reload_empty = 5.75,
		unequip = 0.85,
		equip = 0.85
	}
	self.ray.name_id = "bm_w_ray"
	self.ray.desc_id = "bm_w_ray_desc"
	self.ray.description_id = "des_ray"
	self.ray.muzzleflash = "effects/payday2/particles/weapons/50cal_auto_fps"
	self.ray.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.ray.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.ray.DAMAGE = 6
	self.ray.damage_near = 1000
	self.ray.damage_far = 2000
	self.ray.rays = 6
	self.ray.CLIP_AMMO_MAX = 4
	self.ray.NR_CLIPS_MAX = 2
	self.ray.AMMO_MAX = self.ray.CLIP_AMMO_MAX * self.ray.NR_CLIPS_MAX
	self.ray.AMMO_PICKUP = self:_pickup_chance(0, 1)
	self.ray.FIRE_MODE = "single"
	self.ray.fire_mode_data = {fire_rate = 1}
	self.ray.single = {fire_rate = 0.1}
	self.ray.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.ray.kick = {standing = {
		2.9,
		3,
		-0.5,
		0.5
	}}
	self.ray.kick.crouching = self.ray.kick.standing
	self.ray.kick.steelsight = self.ray.kick.standing
	self.ray.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.ray.crosshair.standing.offset = 0.16
	self.ray.crosshair.standing.moving_offset = 0.8
	self.ray.crosshair.standing.kick_offset = 0.6
	self.ray.crosshair.standing.hidden = true
	self.ray.crosshair.crouching.offset = 0.08
	self.ray.crosshair.crouching.moving_offset = 0.7
	self.ray.crosshair.crouching.kick_offset = 0.4
	self.ray.crosshair.crouching.hidden = true
	self.ray.crosshair.steelsight.hidden = true
	self.ray.crosshair.steelsight.offset = 0
	self.ray.crosshair.steelsight.moving_offset = 0
	self.ray.crosshair.steelsight.kick_offset = 0.1
	self.ray.shake = {
		fire_multiplier = 2,
		fire_steelsight_multiplier = 2
	}
	self.ray.headbob = {multiplier = 0.3}
	self.ray.autohit = autohit_shotgun_default
	self.ray.aim_assist = aim_assist_shotgun_default
	self.ray.animations = {
		equip_id = "equip_ray",
		recoil_steelsight = true,
		thq_align_anim = "thq"
	}
	self.ray.global_value = "friend"
	self.ray.texture_bundle_folder = "friend"
	self.ray.panic_suppression_chance = 0.2
	self.ray.ignore_damage_upgrades = true
	self.ray.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 50,
		alert_size = 7,
		spread = 25,
		spread_moving = 25,
		recoil = 25,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 2,
		concealment = 5
	}
	self.ray.stats_modifiers = {damage = 100}
	self.tti = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.tti.sounds.fire = "tti_fire"
	self.tti.sounds.dryfire = "primary_dryfire"
	self.tti.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.tti.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.tti.timers = {
		reload_not_empty = 2.3,
		reload_empty = 3.3,
		unequip = 0.9,
		equip = 0.9
	}
	self.tti.name_id = "bm_w_tti"
	self.tti.desc_id = "bm_w_tti_desc"
	self.tti.description_id = "des_tti"
	self.tti.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.tti.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.tti.use_data = {selection_index = 2}
	self.tti.DAMAGE = 1
	self.tti.CLIP_AMMO_MAX = 20
	self.tti.NR_CLIPS_MAX = 2
	self.tti.AMMO_MAX = self.tti.CLIP_AMMO_MAX * self.tti.NR_CLIPS_MAX
	self.tti.AMMO_PICKUP = self:_pickup_chance(self.tti.AMMO_MAX, 5)
	self.tti.FIRE_MODE = "single"
	self.tti.fire_mode_data = {fire_rate = 0.4}
	self.tti.CAN_TOGGLE_FIREMODE = false
	self.tti.single = {fire_rate = 0.4}
	self.tti.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.tti.kick = {standing = {
		2,
		3.8,
		-0.3,
		0.3
	}}
	self.tti.kick.crouching = self.tti.kick.standing
	self.tti.kick.steelsight = self.tti.kick.standing
	self.tti.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.tti.crosshair.standing.offset = 1.14
	self.tti.crosshair.standing.moving_offset = 1.8
	self.tti.crosshair.standing.kick_offset = 1.6
	self.tti.crosshair.crouching.offset = 1.1
	self.tti.crosshair.crouching.moving_offset = 1.6
	self.tti.crosshair.crouching.kick_offset = 1.4
	self.tti.crosshair.steelsight.hidden = true
	self.tti.crosshair.steelsight.offset = 1
	self.tti.crosshair.steelsight.moving_offset = 1
	self.tti.crosshair.steelsight.kick_offset = 1.14
	self.tti.shake = {
		fire_multiplier = 1.1,
		fire_steelsight_multiplier = -1.1
	}
	self.tti.autohit = autohit_snp_default
	self.tti.aim_assist = aim_assist_snp_default
	self.tti.weapon_hold = "tti"
	self.tti.animations = {
		equip_id = "equip_tti",
		recoil_steelsight = true
	}
	self.tti.panic_suppression_chance = 0.2
	self.tti.global_value = "spa"
	self.tti.texture_bundle_folder = "spa"
	self.tti.can_shoot_through_enemy = true
	self.tti.can_shoot_through_shield = true
	self.tti.can_shoot_through_wall = true
	self.tti.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 8,
		spread = 20,
		spread_moving = 24,
		recoil = 2,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 16
	}
	self.tti.armor_piercing_chance = 1
	self.tti.stats_modifiers = {damage = 1}
	self.siltstone = {
		categories = {"snp"},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.siltstone.sounds.fire = "siltstone_fire"
	self.siltstone.sounds.dryfire = "primary_dryfire"
	self.siltstone.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.siltstone.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.siltstone.timers = {
		reload_not_empty = 2.3,
		reload_empty = 3.3,
		unequip = 0.9,
		equip = 0.9
	}
	self.siltstone.name_id = "bm_w_siltstone"
	self.siltstone.desc_id = "bm_w_siltstone_desc"
	self.siltstone.description_id = "des_siltstone"
	self.siltstone.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.siltstone.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.siltstone.use_data = {selection_index = 2}
	self.siltstone.DAMAGE = 1
	self.siltstone.CLIP_AMMO_MAX = 10
	self.siltstone.NR_CLIPS_MAX = 3
	self.siltstone.AMMO_MAX = self.siltstone.CLIP_AMMO_MAX * self.siltstone.NR_CLIPS_MAX
	self.siltstone.AMMO_PICKUP = {
		0.7,
		1
	}
	self.siltstone.FIRE_MODE = "single"
	self.siltstone.fire_mode_data = {fire_rate = 1}
	self.siltstone.CAN_TOGGLE_FIREMODE = false
	self.siltstone.single = {fire_rate = 1}
	self.siltstone.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.siltstone.kick = {standing = {
		2,
		3.8,
		-0.3,
		0.3
	}}
	self.siltstone.kick.crouching = self.siltstone.kick.standing
	self.siltstone.kick.steelsight = self.siltstone.kick.standing
	self.siltstone.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.siltstone.crosshair.standing.offset = 1.14
	self.siltstone.crosshair.standing.moving_offset = 1.8
	self.siltstone.crosshair.standing.kick_offset = 1.6
	self.siltstone.crosshair.crouching.offset = 1.1
	self.siltstone.crosshair.crouching.moving_offset = 1.6
	self.siltstone.crosshair.crouching.kick_offset = 1.4
	self.siltstone.crosshair.steelsight.hidden = true
	self.siltstone.crosshair.steelsight.offset = 1
	self.siltstone.crosshair.steelsight.moving_offset = 1
	self.siltstone.crosshair.steelsight.kick_offset = 1.14
	self.siltstone.shake = {
		fire_multiplier = 1.1,
		fire_steelsight_multiplier = -1.1
	}
	self.siltstone.autohit = autohit_snp_default
	self.siltstone.aim_assist = aim_assist_snp_default
	self.siltstone.weapon_hold = "siltstone"
	self.siltstone.animations = {
		equip_id = "equip_siltstone",
		recoil_steelsight = true
	}
	self.siltstone.panic_suppression_chance = 0.2
	self.siltstone.global_value = "grv"
	self.siltstone.texture_bundle_folder = "grv"
	self.siltstone.can_shoot_through_enemy = true
	self.siltstone.can_shoot_through_shield = true
	self.siltstone.can_shoot_through_wall = true
	self.siltstone.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 150,
		alert_size = 8,
		spread = 19,
		spread_moving = 24,
		recoil = 2,
		value = 9,
		extra_ammo = 6,
		reload = 11,
		suppression = 12,
		concealment = 16
	}
	self.siltstone.armor_piercing_chance = 1
	self.siltstone.stats_modifiers = {damage = 2}
	self.flint = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.flint.sounds.fire = "flint_fire_single"
	self.flint.sounds.fire_single = "flint_fire_single"
	self.flint.sounds.fire_auto = "flint_fire"
	self.flint.sounds.stop_fire = "flint_stop"
	self.flint.sounds.dryfire = "primary_dryfire"
	self.flint.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.flint.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.flint.timers = {
		reload_not_empty = 2.26,
		reload_empty = 3.37,
		unequip = 0.5,
		equip = 0.5
	}
	self.flint.name_id = "bm_w_ak12"
	self.flint.desc_id = "bm_w_ak12_desc"
	self.flint.description_id = "des_ak47"
	self.flint.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.flint.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.flint.use_data = {selection_index = 2}
	self.flint.DAMAGE = 1
	self.flint.CLIP_AMMO_MAX = 35
	self.flint.NR_CLIPS_MAX = 3
	self.flint.AMMO_MAX = self.flint.CLIP_AMMO_MAX * self.flint.NR_CLIPS_MAX
	self.flint.AMMO_PICKUP = self:_pickup_chance(self.flint.AMMO_MAX, 1)
	self.flint.FIRE_MODE = "auto"
	self.flint.fire_mode_data = {fire_rate = 0.092}
	self.flint.CAN_TOGGLE_FIREMODE = true
	self.flint.auto = {fire_rate = 0.092}
	self.flint.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.flint.kick = {
		standing = self.new_m4.kick.standing,
		crouching = self.ak74.kick.standing,
		steelsight = self.ak74.kick.standing
	}
	self.flint.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.flint.crosshair.standing.offset = 0.16
	self.flint.crosshair.standing.moving_offset = 0.8
	self.flint.crosshair.standing.kick_offset = 0.6
	self.flint.crosshair.crouching.offset = 0.08
	self.flint.crosshair.crouching.moving_offset = 0.7
	self.flint.crosshair.crouching.kick_offset = 0.4
	self.flint.crosshair.steelsight.hidden = true
	self.flint.crosshair.steelsight.offset = 0
	self.flint.crosshair.steelsight.moving_offset = 0
	self.flint.crosshair.steelsight.kick_offset = 0.1
	self.flint.shake = {
		fire_multiplier = 0.7,
		fire_steelsight_multiplier = -0.7
	}
	self.flint.autohit = autohit_rifle_default
	self.flint.aim_assist = aim_assist_rifle_default
	self.flint.weapon_hold = "flint"
	self.flint.animations = {
		equip_id = "equip_flint",
		recoil_steelsight = true,
		thq_align_anim = "thq"
	}
	self.flint.global_value = "grv"
	self.flint.texture_bundle_folder = "grv"
	self.flint.panic_suppression_chance = 0.2
	self.flint.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 16,
		spread_moving = 11,
		recoil = 16,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 10,
		concealment = 16
	}
	self.coal = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.coal.sounds.fire = "coal_fire_single"
	self.coal.sounds.fire_single = "coal_fire_single"
	self.coal.sounds.fire_auto = "coal_fire"
	self.coal.sounds.stop_fire = "coal_stop"
	self.coal.sounds.dryfire = "secondary_dryfire"
	self.coal.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.coal.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.coal.timers = {
		reload_not_empty = 3.25,
		reload_empty = 4.25,
		unequip = 0.6,
		equip = 0.5
	}
	self.coal.name_id = "bm_w_coal"
	self.coal.desc_id = "bm_w_coal_desc"
	self.coal.description_id = "des_ak47"
	self.coal.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.coal.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.coal.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.coal.use_data = {selection_index = 1}
	self.coal.DAMAGE = 1
	self.coal.CLIP_AMMO_MAX = 64
	self.coal.NR_CLIPS_MAX = 2
	self.coal.AMMO_MAX = self.coal.CLIP_AMMO_MAX * self.coal.NR_CLIPS_MAX
	self.coal.AMMO_PICKUP = self:_pickup_chance(self.coal.AMMO_MAX, 1)
	self.coal.FIRE_MODE = "auto"
	self.coal.fire_mode_data = {fire_rate = 0.092}
	self.coal.CAN_TOGGLE_FIREMODE = true
	self.coal.auto = {fire_rate = 0.092}
	self.coal.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.coal.kick = {standing = {
		-0.2,
		0.4,
		-1,
		1
	}}
	self.coal.kick.crouching = self.coal.kick.standing
	self.coal.kick.steelsight = self.coal.kick.standing
	self.coal.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.coal.crosshair.standing.offset = 0.4
	self.coal.crosshair.standing.moving_offset = 0.7
	self.coal.crosshair.standing.kick_offset = 0.6
	self.coal.crosshair.crouching.offset = 0.3
	self.coal.crosshair.crouching.moving_offset = 0.6
	self.coal.crosshair.crouching.kick_offset = 0.4
	self.coal.crosshair.steelsight.hidden = true
	self.coal.crosshair.steelsight.offset = 0
	self.coal.crosshair.steelsight.moving_offset = 0
	self.coal.crosshair.steelsight.kick_offset = 0.4
	self.coal.shake = {
		fire_multiplier = 0.5,
		fire_steelsight_multiplier = -0.5
	}
	self.coal.autohit = autohit_smg_default
	self.coal.aim_assist = aim_assist_smg_default
	self.coal.weapon_hold = "coal"
	self.coal.animations = {
		equip_id = "equip_coal",
		recoil_steelsight = true
	}
	self.coal.global_value = "grv"
	self.coal.texture_bundle_folder = "grv"
	self.coal.panic_suppression_chance = 0.2
	self.coal.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 14,
		spread_moving = 14,
		recoil = 14,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 24
	}
	self.lemming = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.lemming.sounds.fire = "lemming_fire"
	self.lemming.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.lemming.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.lemming.sounds.dryfire = "secondary_dryfire"
	self.lemming.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.lemming.timers = {
		reload_not_empty = 1.5,
		reload_empty = 2.15,
		unequip = 0.5,
		equip = 0.35
	}
	self.lemming.name_id = "bm_w_lemming"
	self.lemming.desc_id = "bm_w_lemming_desc"
	self.lemming.description_id = "des_lemming"
	self.lemming.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.lemming.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.lemming.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.lemming.use_data = {selection_index = 1}
	self.lemming.DAMAGE = 1
	self.lemming.CLIP_AMMO_MAX = 15
	self.lemming.NR_CLIPS_MAX = 3
	self.lemming.AMMO_MAX = self.lemming.CLIP_AMMO_MAX * self.lemming.NR_CLIPS_MAX
	self.lemming.AMMO_PICKUP = self:_pickup_chance(self.lemming.AMMO_MAX, 6)
	self.lemming.FIRE_MODE = "single"
	self.lemming.fire_mode_data = {fire_rate = 0.1}
	self.lemming.single = {fire_rate = 0.1}
	self.lemming.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.lemming.kick = {standing = self.glock_17.kick.standing}
	self.lemming.kick.crouching = self.lemming.kick.standing
	self.lemming.kick.steelsight = self.lemming.kick.standing
	self.lemming.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.lemming.crosshair.standing.offset = 0.2
	self.lemming.crosshair.standing.moving_offset = 0.4
	self.lemming.crosshair.standing.kick_offset = 0.3
	self.lemming.crosshair.crouching.offset = 0.1
	self.lemming.crosshair.crouching.moving_offset = 0.5
	self.lemming.crosshair.crouching.kick_offset = 0.2
	self.lemming.crosshair.steelsight.hidden = true
	self.lemming.crosshair.steelsight.offset = 0
	self.lemming.crosshair.steelsight.moving_offset = 0
	self.lemming.crosshair.steelsight.kick_offset = 0.1
	self.lemming.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.lemming.autohit = autohit_pistol_default
	self.lemming.aim_assist = aim_assist_pistol_default
	self.lemming.weapon_hold = "packrat"
	self.lemming.animations = {
		equip_id = "equip_packrat",
		recoil_steelsight = true,
		magazine_empty = "last_recoil"
	}
	self.lemming.global_value = "pd2_clan"
	self.lemming.texture_bundle_folder = "fi7"
	self.lemming.panic_suppression_chance = 0.2
	self.lemming.can_shoot_through_enemy = true
	self.lemming.can_shoot_through_shield = true
	self.lemming.can_shoot_through_wall = true
	self.lemming.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 120,
		alert_size = 7,
		spread = 17,
		spread_moving = 18,
		recoil = 12,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.lemming.armor_piercing_chance = 1
	self.chinchilla = {
		categories = {
			"pistol",
			"revolver"
		},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.chinchilla.sounds.fire = "chinchilla_fire"
	self.chinchilla.sounds.dryfire = "secondary_dryfire"
	self.chinchilla.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.chinchilla.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.chinchilla.timers = {
		reload_not_empty = 2.97,
		reload_empty = 2.97,
		unequip = 0.5,
		equip = 0.45
	}
	self.chinchilla.FIRE_MODE = "single"
	self.chinchilla.fire_mode_data = {fire_rate = 0.166}
	self.chinchilla.single = {fire_rate = 0.166}
	self.chinchilla.name_id = "bm_w_chinchilla"
	self.chinchilla.desc_id = "bm_w_chinchilla_desc"
	self.chinchilla.description_id = "des_chinchilla"
	self.chinchilla.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.chinchilla.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.chinchilla.use_data = {selection_index = 1}
	self.chinchilla.DAMAGE = 2
	self.chinchilla.CLIP_AMMO_MAX = 6
	self.chinchilla.NR_CLIPS_MAX = 9
	self.chinchilla.AMMO_MAX = self.chinchilla.CLIP_AMMO_MAX * self.chinchilla.NR_CLIPS_MAX
	self.chinchilla.AMMO_PICKUP = self:_pickup_chance(self.chinchilla.AMMO_MAX, 1)
	self.chinchilla.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.chinchilla.kick = {standing = self.glock_17.kick.standing}
	self.chinchilla.kick.crouching = self.chinchilla.kick.standing
	self.chinchilla.kick.steelsight = self.chinchilla.kick.standing
	self.chinchilla.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.chinchilla.crosshair.standing.offset = 0.2
	self.chinchilla.crosshair.standing.moving_offset = 0.6
	self.chinchilla.crosshair.standing.kick_offset = 0.4
	self.chinchilla.crosshair.crouching.offset = 0.1
	self.chinchilla.crosshair.crouching.moving_offset = 0.6
	self.chinchilla.crosshair.crouching.kick_offset = 0.3
	self.chinchilla.crosshair.steelsight.hidden = true
	self.chinchilla.crosshair.steelsight.offset = 0
	self.chinchilla.crosshair.steelsight.moving_offset = 0
	self.chinchilla.crosshair.steelsight.kick_offset = 0.1
	self.chinchilla.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.chinchilla.autohit = autohit_pistol_default
	self.chinchilla.aim_assist = aim_assist_pistol_default
	self.chinchilla.weapon_hold = "raging_bull"
	self.chinchilla.animations = {
		equip_id = "equip_raging_bull",
		recoil_steelsight = true
	}
	self.chinchilla.texture_bundle_folder = "max"
	self.chinchilla.panic_suppression_chance = 0.2
	self.chinchilla.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 180,
		alert_size = 7,
		spread = 20,
		spread_moving = 5,
		recoil = 2,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 28
	}
	self.x_chinchilla = {
		categories = {
			"akimbo",
			"pistol",
			"revolver"
		},
		upgrade_blocks = {weapon = {"clip_ammo_increase"}},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_chinchilla.sounds.fire = "chinchilla_x_fire"
	self.x_chinchilla.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_chinchilla.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_chinchilla.sounds.dryfire = "secondary_dryfire"
	self.x_chinchilla.timers = {
		reload_not_empty = 3.47,
		reload_empty = 3.47,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_chinchilla.name_id = "bm_w_x_chinchilla"
	self.x_chinchilla.desc_id = "bm_w_x_chinchilla_desc"
	self.x_chinchilla.description_id = "des_x_chinchilla"
	self.x_chinchilla.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.x_chinchilla.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.x_chinchilla.use_data = {selection_index = 2}
	self.x_chinchilla.DAMAGE = 1
	self.x_chinchilla.CLIP_AMMO_MAX = 12
	self.x_chinchilla.NR_CLIPS_MAX = 6
	self.x_chinchilla.AMMO_MAX = self.x_chinchilla.CLIP_AMMO_MAX * self.x_chinchilla.NR_CLIPS_MAX
	self.x_chinchilla.AMMO_PICKUP = self:_pickup_chance(self.x_chinchilla.AMMO_MAX, 1)
	self.x_chinchilla.FIRE_MODE = "single"
	self.x_chinchilla.fire_mode_data = {fire_rate = 0.166}
	self.x_chinchilla.single = {fire_rate = 0.166}
	self.x_chinchilla.spread = {
		standing = self.colt_1911.spread.standing,
		crouching = self.colt_1911.spread.crouching,
		steelsight = self.colt_1911.spread.steelsight,
		moving_standing = self.colt_1911.spread.moving_standing,
		moving_crouching = self.colt_1911.spread.moving_crouching,
		moving_steelsight = self.colt_1911.spread.moving_steelsight
	}
	self.x_chinchilla.kick = {standing = {
		1.6,
		1.3,
		-0.3,
		0.3
	}}
	self.x_chinchilla.kick.crouching = self.x_chinchilla.kick.standing
	self.x_chinchilla.kick.steelsight = self.x_chinchilla.kick.standing
	self.x_chinchilla.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_chinchilla.crosshair.standing.offset = 0.2
	self.x_chinchilla.crosshair.standing.moving_offset = 0.6
	self.x_chinchilla.crosshair.standing.kick_offset = 0.4
	self.x_chinchilla.crosshair.crouching.offset = 0.1
	self.x_chinchilla.crosshair.crouching.moving_offset = 0.6
	self.x_chinchilla.crosshair.crouching.kick_offset = 0.3
	self.x_chinchilla.crosshair.steelsight.hidden = true
	self.x_chinchilla.crosshair.steelsight.offset = 0
	self.x_chinchilla.crosshair.steelsight.moving_offset = 0
	self.x_chinchilla.crosshair.steelsight.kick_offset = 0.1
	self.x_chinchilla.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_chinchilla.autohit = autohit_pistol_default
	self.x_chinchilla.aim_assist = aim_assist_pistol_default
	self.x_chinchilla.weapon_hold = "x_chinchilla"
	self.x_chinchilla.animations = {
		second_gun_versions = {
			reload_not_empty = "reload_not_empty_left",
			reload = "reload_left"
		},
		has_steelsight_stance = true,
		recoil_steelsight = true
	}
	self.x_chinchilla.texture_bundle_folder = "max"
	self.x_chinchilla.panic_suppression_chance = 0.2
	self.x_chinchilla.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 180,
		alert_size = 7,
		spread = 20,
		spread_moving = 5,
		recoil = 2,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 7,
		concealment = 28
	}
	self.breech = {
		categories = {"pistol"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.breech.sounds.fire = "breech_fire"
	self.breech.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.breech.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.breech.sounds.dryfire = "secondary_dryfire"
	self.breech.sounds.magazine_empty = "wp_pistol_slide_lock"
	self.breech.timers = {
		reload_not_empty = 1.33,
		reload_empty = 2.1,
		unequip = 0.5,
		equip = 0.35
	}
	self.breech.name_id = "bm_w_breech"
	self.breech.desc_id = "bm_w_breech_desc"
	self.breech.description_id = "des_breech"
	self.breech.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.breech.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.breech.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.breech.use_data = {selection_index = 1}
	self.breech.DAMAGE = 1
	self.breech.CLIP_AMMO_MAX = 8
	self.breech.NR_CLIPS_MAX = 7
	self.breech.AMMO_MAX = self.breech.CLIP_AMMO_MAX * self.breech.NR_CLIPS_MAX
	self.breech.AMMO_PICKUP = self:_pickup_chance(self.breech.AMMO_MAX, 1)
	self.breech.FIRE_MODE = "single"
	self.breech.fire_mode_data = {fire_rate = 0.166}
	self.breech.single = {fire_rate = 0.166}
	self.breech.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.breech.kick = {standing = self.glock_17.kick.standing}
	self.breech.kick.crouching = self.breech.kick.standing
	self.breech.kick.steelsight = self.breech.kick.standing
	self.breech.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.breech.crosshair.standing.offset = 0.1
	self.breech.crosshair.standing.moving_offset = 0.4
	self.breech.crosshair.standing.kick_offset = 0.3
	self.breech.crosshair.crouching.offset = 0.1
	self.breech.crosshair.crouching.moving_offset = 0.5
	self.breech.crosshair.crouching.kick_offset = 0.2
	self.breech.crosshair.steelsight.hidden = true
	self.breech.crosshair.steelsight.offset = 0
	self.breech.crosshair.steelsight.moving_offset = 0
	self.breech.crosshair.steelsight.kick_offset = 0.1
	self.breech.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.breech.autohit = autohit_pistol_default
	self.breech.aim_assist = aim_assist_pistol_default
	self.breech.weapon_hold = "breech"
	self.breech.animations = {
		equip_id = "equip_breech",
		magazine_empty = "last_recoil",
		recoil_steelsight = true
	}
	self.breech.texture_bundle_folder = "old"
	self.breech.panic_suppression_chance = 0.2
	self.breech.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 180,
		alert_size = 7,
		spread = 20,
		spread_moving = 18,
		recoil = 7,
		value = 4,
		extra_ammo = 6,
		reload = 11,
		suppression = 15,
		concealment = 29
	}
	self.breech.unlock_func = "has_unlocked_breech"
	self.ching = {
		categories = {"assault_rifle"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.ching.sounds.fire = "ching_fire"
	self.ching.sounds.fire_single = "ching_fire"
	self.ching.sounds.dryfire = "primary_dryfire"
	self.ching.sounds.magazine_empty = "ching_magazine_empty"
	self.ching.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.ching.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.ching.timers = {
		reload_not_empty = 2.56,
		reload_empty = 1.52,
		unequip = 0.6,
		equip = 0.55
	}
	self.ching.name_id = "bm_w_ching"
	self.ching.desc_id = "bm_w_ching_desc"
	self.ching.description_id = "des_ching"
	self.ching.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.ching.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
	self.ching.effects = {magazine_empty = {
		parent = "a_shell",
		effect = "effects/payday2/particles/weapons/magazine/ching_clip"
	}}
	self.ching.use_data = {selection_index = 2}
	self.ching.DAMAGE = 2
	self.ching.CLIP_AMMO_MAX = 8
	self.ching.NR_CLIPS_MAX = 9
	self.ching.AMMO_MAX = self.ching.CLIP_AMMO_MAX * self.ching.NR_CLIPS_MAX
	self.ching.AMMO_PICKUP = self:_pickup_chance(self.ching.AMMO_MAX, 1)
	self.ching.FIRE_MODE = "single"
	self.ching.fire_mode_data = {fire_rate = 0.1}
	self.ching.CAN_TOGGLE_FIREMODE = false
	self.ching.single = {fire_rate = 0.1}
	self.ching.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.ching.kick = {standing = self.new_m4.kick.standing}
	self.ching.kick.crouching = self.ching.kick.standing
	self.ching.kick.steelsight = self.ching.kick.standing
	self.ching.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.ching.crosshair.standing.offset = 0.16
	self.ching.crosshair.standing.moving_offset = 0.8
	self.ching.crosshair.standing.kick_offset = 0.6
	self.ching.crosshair.crouching.offset = 0.08
	self.ching.crosshair.crouching.moving_offset = 0.7
	self.ching.crosshair.crouching.kick_offset = 0.4
	self.ching.crosshair.steelsight.hidden = true
	self.ching.crosshair.steelsight.offset = 0
	self.ching.crosshair.steelsight.moving_offset = 0
	self.ching.crosshair.steelsight.kick_offset = 0.1
	self.ching.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1
	}
	self.ching.autohit = autohit_rifle_default
	self.ching.aim_assist = aim_assist_rifle_default
	self.ching.animations = {
		fire = "recoil",
		equip_id = "equip_ching",
		magazine_empty = "last_recoil",
		recoil_steelsight = true
	}
	self.ching.texture_bundle_folder = "old"
	self.ching.panic_suppression_chance = 0.2
	self.ching.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 160,
		alert_size = 7,
		spread = 22,
		spread_moving = 20,
		recoil = 10,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 4,
		concealment = 20
	}
	self.ching.unlock_func = "has_unlocked_ching"
	self.erma = {
		categories = {"smg"},
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.erma.sounds.fire = "erma_fire_single"
	self.erma.sounds.fire_single = "erma_fire_single"
	self.erma.sounds.fire_auto = "erma_fire"
	self.erma.sounds.stop_fire = "erma_stop"
	self.erma.sounds.dryfire = "secondary_dryfire"
	self.erma.sounds.magazine_empty = "wp_rifle_slide_lock"
	self.erma.sounds.enter_steelsight = "secondary_steel_sight_enter"
	self.erma.sounds.leave_steelsight = "secondary_steel_sight_exit"
	self.erma.timers = {
		reload_not_empty = 1.9,
		reload_empty = 3.05,
		unequip = 0.5,
		equip = 0.6
	}
	self.erma.name_id = "bm_w_erma"
	self.erma.desc_id = "bm_w_erma_desc"
	self.erma.description_id = "des_erma"
	self.erma.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
	self.erma.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.erma.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
	self.erma.use_data = {selection_index = 1}
	self.erma.DAMAGE = 1
	self.erma.CLIP_AMMO_MAX = 40
	self.erma.NR_CLIPS_MAX = 2
	self.erma.AMMO_MAX = self.erma.CLIP_AMMO_MAX * self.erma.NR_CLIPS_MAX
	self.erma.AMMO_PICKUP = self:_pickup_chance(self.erma.AMMO_MAX, 1)
	self.erma.FIRE_MODE = "auto"
	self.erma.fire_mode_data = {fire_rate = 0.1}
	self.erma.auto = {fire_rate = 0.1}
	self.erma.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.erma.kick = {standing = self.mp9.kick.standing}
	self.erma.kick.crouching = self.erma.kick.standing
	self.erma.kick.steelsight = self.erma.kick.standing
	self.erma.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.erma.crosshair.standing.offset = 0.4
	self.erma.crosshair.standing.moving_offset = 0.7
	self.erma.crosshair.standing.kick_offset = 0.6
	self.erma.crosshair.crouching.offset = 0.3
	self.erma.crosshair.crouching.moving_offset = 0.6
	self.erma.crosshair.crouching.kick_offset = 0.4
	self.erma.crosshair.steelsight.hidden = true
	self.erma.crosshair.steelsight.offset = 0
	self.erma.crosshair.steelsight.moving_offset = 0
	self.erma.crosshair.steelsight.kick_offset = 0.4
	self.erma.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.erma.autohit = autohit_smg_default
	self.erma.aim_assist = aim_assist_smg_default
	self.erma.weapon_hold = "erma"
	self.erma.animations = {
		equip_id = "equip_erma",
		magazine_empty = "last_recoil",
		recoil_steelsight = true
	}
	self.erma.texture_bundle_folder = "old"
	self.erma.panic_suppression_chance = 0.2
	self.erma.stats = {
		zoom = 1,
		total_ammo_mod = 21,
		damage = 80,
		alert_size = 7,
		spread = 18,
		spread_moving = 18,
		recoil = 12,
		value = 5,
		extra_ammo = 6,
		reload = 11,
		suppression = 14,
		concealment = 24
	}
	self.erma.unlock_func = "has_unlocked_erma"
	self.basset = {
		categories = {"shotgun"},
		has_magazine = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.basset.sounds.fire = "basset_fire"
	self.basset.sounds.dryfire = "shotgun_dryfire"
	self.basset.sounds.stop_fire = "basset_stop"
	self.basset.sounds.enter_steelsight = "primary_steel_sight_enter"
	self.basset.sounds.leave_steelsight = "primary_steel_sight_exit"
	self.basset.timers = {
		reload_not_empty = 2.16,
		reload_empty = 2.9,
		unequip = 0.55,
		equip = 0.55
	}
	self.basset.name_id = "bm_w_basset"
	self.basset.desc_id = "bm_w_basset_desc"
	self.basset.description_id = "des_basset"
	self.basset.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.basset.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.basset.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.basset.use_data = {
		selection_index = 1,
		align_place = "right_hand"
	}
	self.basset.DAMAGE = 6
	self.basset.damage_near = 2000
	self.basset.damage_far = 3000
	self.basset.rays = 12
	self.basset.CLIP_AMMO_MAX = 8
	self.basset.NR_CLIPS_MAX = 13
	self.basset.AMMO_MAX = self.basset.CLIP_AMMO_MAX * self.basset.NR_CLIPS_MAX
	self.basset.AMMO_PICKUP = self:_pickup_chance(self.basset.AMMO_MAX, 4)
	self.basset.FIRE_MODE = "auto"
	self.basset.fire_mode_data = {fire_rate = 0.2}
	self.basset.CAN_TOGGLE_FIREMODE = true
	self.basset.auto = {fire_rate = 0.2}
	self.basset.spread = {
		standing = self.r870.spread.standing,
		crouching = self.r870.spread.crouching,
		steelsight = self.r870.spread.steelsight,
		moving_standing = self.r870.spread.moving_standing,
		moving_crouching = self.r870.spread.moving_crouching,
		moving_steelsight = self.r870.spread.moving_steelsight
	}
	self.basset.kick = {standing = self.r870.kick.standing}
	self.basset.kick.crouching = self.basset.kick.standing
	self.basset.kick.steelsight = self.r870.kick.steelsight
	self.basset.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.basset.crosshair.standing.offset = 0.7
	self.basset.crosshair.standing.moving_offset = 0.7
	self.basset.crosshair.standing.kick_offset = 0.8
	self.basset.crosshair.crouching.offset = 0.65
	self.basset.crosshair.crouching.moving_offset = 0.65
	self.basset.crosshair.crouching.kick_offset = 0.75
	self.basset.crosshair.steelsight.hidden = true
	self.basset.crosshair.steelsight.offset = 0
	self.basset.crosshair.steelsight.moving_offset = 0
	self.basset.crosshair.steelsight.kick_offset = 0
	self.basset.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = 1.25
	}
	self.basset.autohit = autohit_shotgun_default
	self.basset.aim_assist = aim_assist_shotgun_default
	self.basset.weapon_hold = "basset"
	self.basset.animations = {
		equip_id = "equip_basset",
		recoil_steelsight = true
	}
	self.basset.texture_bundle_folder = "dsg"
	self.basset.panic_suppression_chance = 0.2
	self.basset.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 18,
		alert_size = 7,
		spread = 4,
		spread_moving = 8,
		recoil = 13,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 21
	}
	self.x_basset = {
		categories = {
			"akimbo",
			"shotgun"
		},
		has_magazine = true,
		allow_akimbo_autofire = true,
		damage_melee = damage_melee_default,
		damage_melee_effect_mul = damage_melee_effect_multiplier_default,
		sounds = {}
	}
	self.x_basset.sounds.fire = "basset_x_fire"
	self.x_basset.sounds.fire_single = "basset_x_fire_single"
	self.x_basset.sounds.fire_auto = "basset_x_fire"
	self.x_basset.sounds.stop_fire = "basset_x_stop"
	self.x_basset.sounds.enter_steelsight = "pistol_steel_sight_enter"
	self.x_basset.sounds.leave_steelsight = "pistol_steel_sight_exit"
	self.x_basset.sounds.dryfire = "secondary_dryfire"
	self.x_basset.timers = {
		reload_not_empty = 3,
		reload_empty = 3.5,
		unequip = 0.5,
		equip = 0.5
	}
	self.x_basset.name_id = "bm_w_x_basset"
	self.x_basset.desc_id = "bm_w_x_basset_desc"
	self.x_basset.description_id = "des_x_basset"
	self.x_basset.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
	self.x_basset.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
	self.x_basset.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
	self.x_basset.use_data = {selection_index = 2}
	self.x_basset.DAMAGE = 4
	self.x_basset.damage_near = 2000
	self.x_basset.damage_far = 3000
	self.x_basset.rays = 12
	self.x_basset.use_shotgun_reload = false
	self.x_basset.CLIP_AMMO_MAX = 16
	self.x_basset.NR_CLIPS_MAX = 6
	self.x_basset.AMMO_MAX = self.x_basset.CLIP_AMMO_MAX * self.x_basset.NR_CLIPS_MAX
	self.x_basset.AMMO_PICKUP = self:_pickup_chance(self.x_basset.AMMO_MAX, 1)
	self.x_basset.FIRE_MODE = "auto"
	self.x_basset.fire_mode_data = {fire_rate = 0.18}
	self.x_basset.single = {fire_rate = 0.18}
	self.x_basset.CAN_TOGGLE_FIREMODE = true
	self.x_basset.spread = {
		standing = self.new_m4.spread.standing,
		crouching = self.new_m4.spread.crouching,
		steelsight = self.new_m4.spread.steelsight,
		moving_standing = self.new_m4.spread.moving_standing,
		moving_crouching = self.new_m4.spread.moving_crouching,
		moving_steelsight = self.new_m4.spread.moving_steelsight
	}
	self.x_basset.kick = {standing = {
		1.4,
		1.2,
		-0.5,
		0.5
	}}
	self.x_basset.kick.crouching = self.x_basset.kick.standing
	self.x_basset.kick.steelsight = self.x_basset.kick.standing
	self.x_basset.crosshair = {
		standing = {},
		crouching = {},
		steelsight = {}
	}
	self.x_basset.crosshair.standing.offset = 0.2
	self.x_basset.crosshair.standing.moving_offset = 0.6
	self.x_basset.crosshair.standing.kick_offset = 0.4
	self.x_basset.crosshair.crouching.offset = 0.1
	self.x_basset.crosshair.crouching.moving_offset = 0.6
	self.x_basset.crosshair.crouching.kick_offset = 0.3
	self.x_basset.crosshair.steelsight.hidden = true
	self.x_basset.crosshair.steelsight.offset = 0
	self.x_basset.crosshair.steelsight.moving_offset = 0
	self.x_basset.crosshair.steelsight.kick_offset = 0.1
	self.x_basset.shake = {
		fire_multiplier = 1,
		fire_steelsight_multiplier = -1
	}
	self.x_basset.autohit = autohit_smg_default
	self.x_basset.aim_assist = aim_assist_smg_default
	self.x_basset.weapon_hold = "x_akmsu"
	self.x_basset.animations = {
		has_steelsight_stance = true,
		recoil_steelsight = true
	}
	self.x_basset.texture_bundle_folder = "dsg"
	self.x_basset.panic_suppression_chance = 0.2
	self.x_basset.stats = {
		zoom = 3,
		total_ammo_mod = 21,
		damage = 18,
		alert_size = 7,
		spread = 4,
		spread_moving = 8,
		recoil = 13,
		value = 1,
		extra_ammo = 6,
		reload = 11,
		suppression = 5,
		concealment = 21
	}
end

-- Lines: 20154 to 20257
function WeaponTweakData:_init_data_offhand_weapons()
	self.b92fs_primary = deep_clone(self.b92fs)
	self.b92fs_primary.parent_weapon_id = "b92fs"
	self.b92fs_primary.use_data.selection_index = 2
	self.b92fs_primary.animations.reload_name_id = "b92fs"
	self.b92fs_primary.use_stance = "b92fs"
	self.b92fs_primary.texture_name = "b92fs"
	self.b92fs_primary.AMMO_MAX = math.round(self.b92fs_primary.AMMO_MAX * 0.75)
	self.glock_18c_primary = deep_clone(self.glock_18c)
	self.glock_18c_primary.parent_weapon_id = "glock_18c"
	self.glock_18c_primary.use_data.selection_index = 2
	self.glock_18c_primary.animations.reload_name_id = "glock_18c"
	self.glock_18c_primary.use_stance = "glock_18c"
	self.glock_18c_primary.texture_name = "glock_18c"
	self.glock_18c_primary.AMMO_MAX = math.round(self.glock_18c_primary.AMMO_MAX * 0.75)
	self.olympic_primary = deep_clone(self.olympic)
	self.olympic_primary.parent_weapon_id = "olympic"
	self.olympic_primary.use_data.selection_index = 2
	self.olympic_primary.animations.reload_name_id = "olympic"
	self.olympic_primary.use_stance = "olympic"
	self.olympic_primary.texture_name = "olympic"
	self.olympic_primary.AMMO_MAX = math.round(self.olympic_primary.AMMO_MAX * 0.75)
	self.akmsu_primary = deep_clone(self.akmsu)
	self.akmsu_primary.parent_weapon_id = "akmsu"
	self.akmsu_primary.use_data.selection_index = 2
	self.akmsu_primary.animations.reload_name_id = "akmsu"
	self.akmsu_primary.use_stance = "akmsu"
	self.akmsu_primary.texture_name = "akmsu"
	self.akmsu_primary.AMMO_MAX = math.round(self.akmsu_primary.AMMO_MAX * 0.75)
	self.deagle_primary = deep_clone(self.deagle)
	self.deagle_primary.parent_weapon_id = "deagle"
	self.deagle_primary.use_data.selection_index = 2
	self.deagle_primary.animations.reload_name_id = "deagle"
	self.deagle_primary.use_stance = "deagle"
	self.deagle_primary.texture_name = "deagle"
	self.deagle_primary.weapon_hold = "deagle"
	self.deagle_primary.AMMO_MAX = math.round(self.deagle_primary.AMMO_MAX * 0.75)
	self.colt_1911_primary = deep_clone(self.colt_1911)
	self.colt_1911_primary.parent_weapon_id = "colt_1911"
	self.colt_1911_primary.use_data.selection_index = 2
	self.colt_1911_primary.animations.reload_name_id = "colt_1911"
	self.colt_1911_primary.use_stance = "colt_1911"
	self.colt_1911_primary.texture_name = "colt_1911"
	self.colt_1911_primary.weapon_hold = "colt_1911"
	self.colt_1911_primary.AMMO_MAX = math.round(self.colt_1911_primary.AMMO_MAX * 0.75)
	self.raging_bull_primary = deep_clone(self.new_raging_bull)
	self.raging_bull_primary.parent_weapon_id = "new_raging_bull"
	self.raging_bull_primary.use_data.selection_index = 2
	self.raging_bull_primary.animations.reload_name_id = "new_raging_bull"
	self.raging_bull_primary.use_stance = "new_raging_bull"
	self.raging_bull_primary.texture_name = "new_raging_bull"
	self.raging_bull_primary.AMMO_MAX = math.round(self.raging_bull_primary.AMMO_MAX * 0.75)
	self.ak74_secondary = deep_clone(self.ak74)
	self.ak74_secondary.parent_weapon_id = "ak74"
	self.ak74_secondary.use_data.selection_index = 1
	self.ak74_secondary.animations.reload_name_id = "ak74"
	self.ak74_secondary.use_stance = "ak74"
	self.ak74_secondary.texture_name = "ak74"
	self.ak74_secondary.AMMO_MAX = math.round(self.ak74_secondary.AMMO_MAX * 0.75)
	self.aug_secondary = deep_clone(self.aug)
	self.aug_secondary.parent_weapon_id = "aug"
	self.aug_secondary.use_data.selection_index = 1
	self.aug_secondary.animations.reload_name_id = "aug"
	self.aug_secondary.use_stance = "aug"
	self.aug_secondary.texture_name = "aug"
	self.aug_secondary.weapon_hold = "aug"
	self.aug_secondary.AMMO_MAX = math.round(self.aug_secondary.AMMO_MAX * 0.75)
	self.saw_secondary = deep_clone(self.saw)
	self.saw_secondary.parent_weapon_id = "saw"
	self.saw_secondary.use_data.selection_index = 1
	self.saw_secondary.animations.reload_name_id = "saw"
	self.saw_secondary.use_stance = "saw"
	self.saw_secondary.texture_name = "saw"
	self.saw_secondary.weapon_hold = "saw"
	self.saw_secondary.AMMO_MAX = math.round(self.saw_secondary.AMMO_MAX * 0.75)
	self.s552_secondary = deep_clone(self.s552)
	self.s552_secondary.parent_weapon_id = "s552"
	self.s552_secondary.use_data.selection_index = 1
	self.s552_secondary.animations.reload_name_id = "s552"
	self.s552_secondary.use_stance = "s552"
	self.s552_secondary.texture_name = "s552"
	self.s552_secondary.weapon_hold = "s552"
	self.s552_secondary.AMMO_MAX = math.round(self.s552_secondary.AMMO_MAX * 0.75)
	self.m4_secondary = deep_clone(self.new_m4)
	self.m4_secondary.parent_weapon_id = "new_m4"
	self.m4_secondary.use_data.selection_index = 1
	self.m4_secondary.animations.reload_name_id = "new_m4"
	self.m4_secondary.use_stance = "new_m4"
	self.m4_secondary.texture_name = "new_m4"
	self.m4_secondary.weapon_hold = "new_m4"
	self.m4_secondary.AMMO_MAX = math.round(self.m4_secondary.AMMO_MAX * 0.75)
end

-- Lines: 20263 to 20557
function WeaponTweakData:_create_table_structure()
	self.c45_npc = {
		usage = "is_pistol",
		sounds = {},
		use_data = {}
	}
	self.x_c45_npc = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {}
	}
	self.beretta92_npc = {
		usage = "is_pistol",
		sounds = {},
		use_data = {}
	}
	self.raging_bull_npc = {
		usage = "is_revolver",
		sounds = {},
		use_data = {}
	}
	self.m4_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m14_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m14_sniper_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {}
	}
	self.r870_npc = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.benelli_npc = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.mossberg_npc = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.mp5_npc = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mac11_npc = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m79_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.glock_18_npc = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.ak47_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.g36_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mp9_npc = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.saiga_npc = {
		usage = "is_shotgun_mag",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.sentry_gun = {
		sounds = {},
		auto = {}
	}
	self.swat_van_turret_module = {
		sounds = {},
		auto = {}
	}
	self.ceiling_turret_module = {
		sounds = {},
		auto = {}
	}
	self.s552_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.scar_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.hk21_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m249_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.contraband_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.contraband_m203_npc = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mini_npc = {
		usage = "mini",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.c45_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {}
	}
	self.x_c45_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {}
	}
	self.colt_1911_primary_crew = deep_clone(self.c45_crew)
	self.beretta92_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {}
	}
	self.beretta92_primary_crew = deep_clone(self.beretta92_crew)
	self.raging_bull_crew = {
		usage = "is_revolver",
		sounds = {},
		use_data = {}
	}
	self.raging_bull_primary_crew = deep_clone(self.raging_bull_crew)
	self.m4_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m4_secondary_crew = deep_clone(self.m4_crew)
	self.m14_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.r870_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.benelli_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.mossberg_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.mp5_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.glock_18_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.glock_18c_primary_crew = deep_clone(self.glock_18_crew)
	self.ak47_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.g36_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.g17_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {}
	}
	self.mp9_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.olympic_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.olympic_primary_crew = deep_clone(self.olympic_crew)
	self.m16_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.aug_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.aug_secondary_crew = deep_clone(self.aug_crew)
	self.ak74_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.ak74_secondary_crew = deep_clone(self.ak74_crew)
	self.ak5_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.p90_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.amcar_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mac10_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.akmsu_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.akmsu_primary_crew = deep_clone(self.akmsu_crew)
	self.akm_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.akm_gold_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.deagle_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {}
	}
	self.deagle_primary_crew = deep_clone(self.deagle_crew)
	self.serbu_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.saiga_crew = {
		usage = "is_shotgun_mag",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.huntsman_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.saw_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {}
	}
	self.saw_secondary_crew = deep_clone(self.saw_crew)
	self.sentry_gun = {
		sounds = {},
		auto = {}
	}
	self.usp_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.g22c_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.judge_crew = {
		usage = "is_revolver",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m45_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.s552_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.s552_secondary_crew = deep_clone(self.s552_crew)
	self.ppk_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mp7_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.scar_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.p226_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.hk21_crew = {
		usage = "is_lmg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m249_crew = {
		usage = "is_lmg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.rpk_crew = {
		usage = "is_lmg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m95_crew = {
		usage = "is_sniper",
		anim_usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.msr_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.r93_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.fal_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.ben_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.striker_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.ksg_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.gre_m79_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.g3_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.galil_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.famas_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.scorpion_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.tec9_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.uzi_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.jowi_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_1911_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_b92fs_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_deagle_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.g26_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.spas12_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mg42_crew = {
		usage = "is_lmg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.c96_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.sterling_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mosin_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m1928_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.l85a2_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.hs2000_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.vhs_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m134_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.rpg7_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.cobray_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.b682_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_g22c_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_g17_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_usp_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.flamethrower_mk2_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m32_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.aa12_crew = {
		usage = "is_shotgun_mag",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.peacemaker_crew = {
		usage = "is_revolver",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.winchester1874_crew = {
		usage = "is_sniper",
		anim_usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.plainsrider_crew = {
		usage = "bow",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mateba_crew = {
		usage = "is_revolver",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.asval_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.sub2000_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.wa2000_crew = {
		usage = "is_sniper",
		anim_usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.polymer_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.hunter_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.baka_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.arblast_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.frankish_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.long_crew = {
		usage = "bow",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.par_crew = {
		usage = "is_lmg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.sparrow_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.model70_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m37_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.china_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.sr2_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_sr2_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.pl14_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_mp5_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_akmsu_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.tecci_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.hajk_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.boot_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.packrat_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.schakal_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.desertfox_crew = {
		usage = "is_sniper",
		anim_usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_packrat_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.rota_crew = {
		usage = "is_shotgun_mag",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.arbiter_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.contraband_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.contraband_m203_crew = {
		usage = "is_shotgun_pump",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.ray_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.tti_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.siltstone_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.flint_crew = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.coal_crew = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.lemming_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.chinchilla_crew = {
		usage = "is_revolver",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_chinchilla_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.breech_crew = {
		usage = "is_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.ching_crew = {
		usage = "is_sniper",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.erma_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.basset_crew = {
		usage = "is_bullpup",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.x_basset_crew = {
		usage = "akimbo_pistol",
		sounds = {},
		use_data = {},
		auto = {}
	}
end

-- Lines: 20560 to 20561
function WeaponTweakData:_precalculate_values_wip()
end

-- Lines: 20564 to 20572
function WeaponTweakData:_precalculate_values()
	for k, v in pairs(self) do
		if v.CLIP_AMMO_MAX and v.NR_CLIPS_MAX and not v.AMMO_MAX then
			v.AMMO_MAX = v.CLIP_AMMO_MAX * v.NR_CLIPS_MAX
		end
	end

	self.g26_crew.AMMO_MAX = 150
end

