-- Lines 4-6
function GenericDLCManager:has_afp()
	return self:is_dlc_unlocked("afp")
end

-- Lines 9-11
function GenericDLCManager:has_bex()
	return self:is_dlc_unlocked("bex")
end

-- Lines 24-26
function GenericDLCManager:has_flm()
	return self:is_dlc_unlocked("flm")
end

-- Lines 34-36
function GenericDLCManager:has_ghx()
	return self:is_dlc_unlocked("ghx")
end

-- Lines 39-41
function GenericDLCManager:has_maw()
	return self:is_dlc_unlocked("maw")
end

-- Lines 44-46
function GenericDLCManager:has_mbs()
	return self:is_dlc_unlocked("mbs")
end

-- Lines 54-56
function GenericDLCManager:has_mex()
	return self:is_dlc_unlocked("mex")
end

-- Lines 59-61
function GenericDLCManager:has_mmh()
	return self:is_dlc_unlocked("mmh")
end

-- Lines 64-66
function GenericDLCManager:has_mwm()
	return self:is_dlc_unlocked("mwm")
end

-- Lines 69-71
function GenericDLCManager:has_scm()
	return self:is_dlc_unlocked("scm")
end

-- Lines 74-76
function GenericDLCManager:has_sdm()
	return self:is_dlc_unlocked("sdm")
end

-- Lines 79-81
function GenericDLCManager:has_sft()
	return self:is_dlc_unlocked("sft")
end

-- Lines 84-86
function GenericDLCManager:has_skm()
	return self:is_dlc_unlocked("skm")
end

-- Lines 89-91
function GenericDLCManager:has_smo()
	return self:is_dlc_unlocked("smo")
end

-- Lines 94-96
function GenericDLCManager:has_sms()
	return self:is_dlc_unlocked("sms")
end

-- Lines 99-101
function GenericDLCManager:has_svc()
	return self:is_dlc_unlocked("svc")
end

-- Lines 104-106
function GenericDLCManager:has_tam()
	return self:is_dlc_unlocked("tam")
end

-- Lines 109-111
function GenericDLCManager:has_tar()
	return self:is_dlc_unlocked("tar")
end

-- Lines 119-121
function GenericDLCManager:has_tjp()
	return self:is_dlc_unlocked("tjp")
end

-- Lines 124-126
function GenericDLCManager:has_toon()
	return self:is_dlc_unlocked("toon")
end

-- Lines 129-131
function GenericDLCManager:has_trd()
	return self:is_dlc_unlocked("trd")
end

-- Lines 134-136
function GenericDLCManager:has_wcs()
	return self:is_dlc_unlocked("wcs")
end

-- Lines 139-141
function GenericDLCManager:has_xmn()
	return self:is_dlc_unlocked("xmn")
end

-- Lines 144-292
function WINDLCManager:init_generated()
	Global.dlc_manager.all_dlc_data.afp = {
		app_id = "1255151",
		no_install = true,
		webpage = "ovk.af/bexwpyb"
	}
	Global.dlc_manager.all_dlc_data.bex = {
		app_id = "1252200",
		no_install = true,
		webpage = "ovk.af/bexheistyb"
	}
	Global.dlc_manager.all_dlc_data.flm = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.ghx = {
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
	Global.dlc_manager.all_dlc_data.wcs = {
		app_id = "1255152",
		no_install = true,
		webpage = "ovk.af/bexwcp1yb"
	}
	Global.dlc_manager.all_dlc_data.xmn = {
		app_id = "218620",
		no_install = true
	}
end
