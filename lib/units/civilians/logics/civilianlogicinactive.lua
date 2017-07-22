require("lib/units/enemies/cop/logics/CopLogicInactive")

CivilianLogicInactive = class(CopLogicInactive)

-- Lines: 10 to 12
function CivilianLogicInactive.on_enemy_weapons_hot(data)
	data.unit:brain():set_attention_settings(nil)
end

-- Lines: 16 to 22
function CivilianLogicInactive._register_attention(data, my_data)
	if data.unit:character_damage():dead() and managers.groupai:state():whisper_mode() then
		data.unit:brain():set_attention_settings({"civ_enemy_corpse_sneak"})
	else
		data.unit:brain():set_attention_settings(nil)
	end
end

-- Lines: 26 to 31
function CivilianLogicInactive._set_interaction(data, my_data)
	if data.unit:character_damage():dead() and not managers.groupai:state():whisper_mode() then
		data.unit:interaction():set_tweak_data("corpse_dispose")
		data.unit:interaction():set_active(true, true, true)
	end
end

return
