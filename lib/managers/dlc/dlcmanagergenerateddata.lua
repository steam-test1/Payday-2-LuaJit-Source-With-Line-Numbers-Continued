
-- Lines: 14 to 15
function GenericDLCManager:has_flm()
	return self:is_dlc_unlocked("flm")
end

-- Lines: 24 to 25
function GenericDLCManager:has_mmh()
	return self:is_dlc_unlocked("mmh")
end

-- Lines: 29 to 30
function GenericDLCManager:has_sdm()
	return self:is_dlc_unlocked("sdm")
end

-- Lines: 34 to 35
function GenericDLCManager:has_sft()
	return self:is_dlc_unlocked("sft")
end

-- Lines: 39 to 40
function GenericDLCManager:has_tam()
	return self:is_dlc_unlocked("tam")
end

-- Lines: 54 to 55
function GenericDLCManager:has_tjp()
	return self:is_dlc_unlocked("tjp")
end

-- Lines: 59 to 60
function GenericDLCManager:has_toon()
	return self:is_dlc_unlocked("toon")
end

-- Lines: 80 to 135
function WINDLCManager:init_generated()
	Global.dlc_manager.all_dlc_data.flm = {}
	Global.dlc_manager.all_dlc_data.flm.app_id = "218620"
	Global.dlc_manager.all_dlc_data.flm.no_install = true
	Global.dlc_manager.all_dlc_data.mmh = {}
	Global.dlc_manager.all_dlc_data.mmh.app_id = "218620"
	Global.dlc_manager.all_dlc_data.mmh.no_install = true
	Global.dlc_manager.all_dlc_data.sdm = {}
	Global.dlc_manager.all_dlc_data.sdm.app_id = "218620"
	Global.dlc_manager.all_dlc_data.sdm.no_install = true
	Global.dlc_manager.all_dlc_data.sft = {}
	Global.dlc_manager.all_dlc_data.sft.app_id = "218620"
	Global.dlc_manager.all_dlc_data.sft.no_install = true
	Global.dlc_manager.all_dlc_data.tam = {}
	Global.dlc_manager.all_dlc_data.tam.app_id = "218620"
	Global.dlc_manager.all_dlc_data.tam.no_install = true
	Global.dlc_manager.all_dlc_data.tjp = {}
	Global.dlc_manager.all_dlc_data.tjp.app_id = "218620"
	Global.dlc_manager.all_dlc_data.tjp.no_install = true
	Global.dlc_manager.all_dlc_data.toon = {}
	Global.dlc_manager.all_dlc_data.toon.app_id = "218620"
	Global.dlc_manager.all_dlc_data.toon.no_install = true
end

