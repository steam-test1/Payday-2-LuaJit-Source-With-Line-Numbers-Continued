-- Lines 4-6
function GenericDLCManager:has_afp()
	return self:is_dlc_unlocked("afp")
end

-- Lines 9-11
function GenericDLCManager:has_anv()
	return self:is_dlc_unlocked("anv")
end

-- Lines 14-16
function GenericDLCManager:has_atw()
	return self:is_dlc_unlocked("atw")
end

-- Lines 19-21
function GenericDLCManager:has_bex()
	return self:is_dlc_unlocked("bex")
end

-- Lines 34-36
function GenericDLCManager:has_ess()
	return self:is_dlc_unlocked("ess")
end

-- Lines 39-41
function GenericDLCManager:has_fex()
	return self:is_dlc_unlocked("fex")
end

-- Lines 44-46
function GenericDLCManager:has_flm()
	return self:is_dlc_unlocked("flm")
end

-- Lines 54-56
function GenericDLCManager:has_ghx()
	return self:is_dlc_unlocked("ghx")
end

-- Lines 59-61
function GenericDLCManager:has_gpo()
	return self:is_dlc_unlocked("gpo")
end

-- Lines 64-66
function GenericDLCManager:has_hnd()
	return self:is_dlc_unlocked("hnd")
end

-- Lines 69-71
function GenericDLCManager:has_inf()
	return self:is_dlc_unlocked("inf")
end

-- Lines 74-76
function GenericDLCManager:has_ja21()
	return self:is_dlc_unlocked("ja21")
end

-- Lines 79-81
function GenericDLCManager:has_maw()
	return self:is_dlc_unlocked("maw")
end

-- Lines 84-86
function GenericDLCManager:has_mbs()
	return self:is_dlc_unlocked("mbs")
end

-- Lines 94-96
function GenericDLCManager:has_mex()
	return self:is_dlc_unlocked("mex")
end

-- Lines 99-101
function GenericDLCManager:has_mmh()
	return self:is_dlc_unlocked("mmh")
end

-- Lines 104-106
function GenericDLCManager:has_mwm()
	return self:is_dlc_unlocked("mwm")
end

-- Lines 109-111
function GenericDLCManager:has_mxw()
	return self:is_dlc_unlocked("mxw")
end

-- Lines 114-116
function GenericDLCManager:has_ocp()
	return self:is_dlc_unlocked("ocp")
end

-- Lines 119-121
function GenericDLCManager:has_pex()
	return self:is_dlc_unlocked("pex")
end

-- Lines 124-126
function GenericDLCManager:has_pgo()
	return self:is_dlc_unlocked("pgo")
end

-- Lines 129-131
function GenericDLCManager:has_scm()
	return self:is_dlc_unlocked("scm")
end

-- Lines 134-136
function GenericDLCManager:has_sdm()
	return self:is_dlc_unlocked("sdm")
end

-- Lines 139-141
function GenericDLCManager:has_sft()
	return self:is_dlc_unlocked("sft")
end

-- Lines 144-146
function GenericDLCManager:has_shl()
	return self:is_dlc_unlocked("shl")
end

-- Lines 149-151
function GenericDLCManager:has_skm()
	return self:is_dlc_unlocked("skm")
end

-- Lines 154-156
function GenericDLCManager:has_smo()
	return self:is_dlc_unlocked("smo")
end

-- Lines 159-161
function GenericDLCManager:has_sms()
	return self:is_dlc_unlocked("sms")
end

-- Lines 164-166
function GenericDLCManager:has_sus()
	return self:is_dlc_unlocked("sus")
end

-- Lines 169-171
function GenericDLCManager:has_svc()
	return self:is_dlc_unlocked("svc")
end

-- Lines 174-176
function GenericDLCManager:has_tam()
	return self:is_dlc_unlocked("tam")
end

-- Lines 179-181
function GenericDLCManager:has_tar()
	return self:is_dlc_unlocked("tar")
end

-- Lines 189-191
function GenericDLCManager:has_tjp()
	return self:is_dlc_unlocked("tjp")
end

-- Lines 194-196
function GenericDLCManager:has_toon()
	return self:is_dlc_unlocked("toon")
end

-- Lines 199-201
function GenericDLCManager:has_trd()
	return self:is_dlc_unlocked("trd")
end

-- Lines 204-206
function GenericDLCManager:has_wcc()
	return self:is_dlc_unlocked("wcc")
end

-- Lines 209-211
function GenericDLCManager:has_wcc_s01()
	return self:is_dlc_unlocked("wcc_s01")
end

-- Lines 214-216
function GenericDLCManager:has_wcc_s02()
	return self:is_dlc_unlocked("wcc_s02")
end

-- Lines 219-221
function GenericDLCManager:has_wcs()
	return self:is_dlc_unlocked("wcs")
end

-- Lines 224-226
function GenericDLCManager:has_xm20()
	return self:is_dlc_unlocked("xm20")
end

-- Lines 229-231
function GenericDLCManager:has_xmn()
	return self:is_dlc_unlocked("xmn")
end

-- Lines 239-490
function WINDLCManager:init_generated()
	Global.dlc_manager.all_dlc_data.afp = {
		app_id = "1255151",
		no_install = true,
		webpage = "ovk.af/bexwpyb"
	}
	Global.dlc_manager.all_dlc_data.anv = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.atw = {
		app_id = "1351060",
		no_install = true,
		webpage = "https://ovk.af/pexwpyb"
	}
	Global.dlc_manager.all_dlc_data.bex = {
		app_id = "1252200",
		no_install = true,
		webpage = "ovk.af/bexheistyb"
	}
	Global.dlc_manager.all_dlc_data.ess = {
		app_id = "1303240",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.fex = {
		app_id = "1449450",
		no_install = true,
		webpage = "https://ovk.af/FEXBMHYB"
	}
	Global.dlc_manager.all_dlc_data.flm = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.ghx = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.gpo = {
		app_id = "1449440",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.hnd = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.inf = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.ja21 = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.maw = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.mbs = {
		app_id = "1255150",
		no_install = true,
		webpage = "ovk.af/bextp2yb"
	}
	Global.dlc_manager.all_dlc_data.mex = {
		app_id = "1184411",
		no_install = true,
		webpage = "https://ovk.af/ingame2BorderCrossing"
	}
	Global.dlc_manager.all_dlc_data.mmh = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.mwm = {
		app_id = "1184412",
		no_install = true,
		webpage = "https://ovk.af/ingame2CartelOptics"
	}
	Global.dlc_manager.all_dlc_data.mxw = {
		app_id = "1449441",
		no_install = true,
		webpage = "https://ovk.af/FEXGWPYB"
	}
	Global.dlc_manager.all_dlc_data.ocp = {
		app_id = "1449442",
		no_install = true,
		webpage = "https://ovk.af/FEXWCP3YB"
	}
	Global.dlc_manager.all_dlc_data.pex = {
		app_id = "1347750",
		no_install = true,
		webpage = "https://ovk.af/pexheistyb"
	}
	Global.dlc_manager.all_dlc_data.pgo = {
		app_id = "1449440",
		no_install = true,
		webpage = "https://ovk.af/FEXTP3YB"
	}
	Global.dlc_manager.all_dlc_data.scm = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.sdm = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.sft = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.shl = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.skm = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.smo = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.sms = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.sus = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.svc = {
		app_id = "1257320",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.tam = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.tar = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.tjp = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.toon = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.trd = {
		app_id = "1184410",
		no_install = true,
		webpage = "https://ovk.af/ingame2TailorPack"
	}
	Global.dlc_manager.all_dlc_data.wcc = {
		app_id = "1347751",
		no_install = true,
		webpage = "https://ovk.af/pexwcp2yb"
	}
	Global.dlc_manager.all_dlc_data.wcc_s01 = {
		app_id = "1349280",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.wcc_s02 = {
		app_id = "1349281",
		no_install = true,
		webpage = "https://ovk.af/pexlcyb"
	}
	Global.dlc_manager.all_dlc_data.wcs = {
		app_id = "1255152",
		no_install = true,
		webpage = "ovk.af/bexwcp1yb"
	}
	Global.dlc_manager.all_dlc_data.xm20 = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.xmn = {
		app_id = "218620",
		no_install = true
	}
end
