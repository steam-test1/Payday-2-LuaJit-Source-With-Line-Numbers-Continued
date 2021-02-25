-- Lines 14-16
function GenericDLCManager:has_flm()
	return self:is_dlc_unlocked("flm")
end

-- Lines 24-26
function GenericDLCManager:has_ghx()
	return self:is_dlc_unlocked("ghx")
end

-- Lines 39-41
function GenericDLCManager:has_mmh()
	return self:is_dlc_unlocked("mmh")
end

-- Lines 44-46
function GenericDLCManager:has_sdm()
	return self:is_dlc_unlocked("sdm")
end

-- Lines 49-51
function GenericDLCManager:has_sft()
	return self:is_dlc_unlocked("sft")
end

-- Lines 54-56
function GenericDLCManager:has_skm()
	return self:is_dlc_unlocked("skm")
end

-- Lines 59-61
function GenericDLCManager:has_smo()
	return self:is_dlc_unlocked("smo")
end

-- Lines 64-66
function GenericDLCManager:has_sms()
	return self:is_dlc_unlocked("sms")
end

-- Lines 69-71
function GenericDLCManager:has_tam()
	return self:is_dlc_unlocked("tam")
end

-- Lines 74-76
function GenericDLCManager:has_tar()
	return self:is_dlc_unlocked("tar")
end

-- Lines 84-86
function GenericDLCManager:has_tjp()
	return self:is_dlc_unlocked("tjp")
end

-- Lines 89-91
function GenericDLCManager:has_toon()
	return self:is_dlc_unlocked("toon")
end

-- Lines 94-185
function WINDLCManager:init_generated()
	Global.dlc_manager.all_dlc_data.flm = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.ghx = {
		app_id = "218620",
		no_install = true
	}
	Global.dlc_manager.all_dlc_data.mmh = {
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
end
