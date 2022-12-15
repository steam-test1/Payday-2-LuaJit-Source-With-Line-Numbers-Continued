EnvEffectTweakData = EnvEffectTweakData or class()

-- Lines 6-33
function EnvEffectTweakData:init()
	self.lightning = {
		event_name = "thunder_struck",
		min_interval = 10,
		rnd_interval = 10
	}
	self.lightning_tag = {
		event_name = "thunder_struck_muffled",
		min_interval = 30,
		rnd_interval = 40
	}
	self.rain = {
		effect_name = Idstring("effects/particles/rain/rain_01_a"),
		ripples = true
	}
	self.rain_only = {
		effect_name = Idstring("effects/particles/rain/rain_only"),
		ripples = true
	}
	self.snow = {
		effect_name = Idstring("effects/particles/snow/snow_01")
	}
	self.snow_slow = {
		effect_name = Idstring("effects/particles/snow/snow_slow")
	}
end

-- Lines 35-55
function EnvEffectTweakData:molotov_fire()
	local params = {
		sound_event = "molotov_impact",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 1500,
		sound_event_burning = "no_sound",
		player_damage = 2,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.5,
		burn_duration = 15,
		is_molotov = true,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		fire_dot_data = {
			dot_trigger_chance = 35,
			dot_damage = 15,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.5
		}
	}

	return params
end

-- Lines 57-76
function EnvEffectTweakData:trip_mine_fire()
	local params = {
		sound_event = "molotov_impact",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 15000,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 15000,
		sound_event_burning = "no_sound",
		player_damage = 2,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.5,
		burn_duration = 10,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		fire_dot_data = {
			dot_trigger_chance = 35,
			dot_damage = 15,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.5
		}
	}

	return params
end

-- Lines 78-97
function EnvEffectTweakData:incendiary_fire()
	local params = {
		sound_event = "gl_explode",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		player_damage = 2,
		sound_event_impact_duration = 6,
		burn_tick_period = 0.5,
		burn_duration = 10,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		fire_dot_data = {
			dot_trigger_chance = 35,
			dot_damage = 15,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.5
		}
	}

	return params
end

-- Lines 99-118
function EnvEffectTweakData:incendiary_fire_arbiter()
	local params = {
		sound_event = "gl_explode",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		player_damage = 2,
		sound_event_impact_duration = 6,
		burn_tick_period = 0.5,
		burn_duration = 3,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		fire_dot_data = {
			dot_trigger_chance = 35,
			dot_damage = 15,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.5
		}
	}

	return params
end

-- Lines 121-142
function EnvEffectTweakData:triad_boss_aoe_fire()
	local params = {
		sound_event = "PENT_Boss_Molotov_Drop",
		range = 100,
		curve_pow = 1,
		no_fire_alert = true,
		sound_event_burning = "no_sound",
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		damage = 4,
		player_damage = 4,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.2,
		burn_duration = 1,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade_pent_boss",
		fire_dot_data = {
			dot_trigger_chance = 35,
			dot_damage = 15,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.5
		}
	}

	return params
end

-- Lines 167-188
function EnvEffectTweakData:snowman_boss_aoe_fire()
	local params = {
		sound_event = "snowmolo_impact",
		range = 100,
		curve_pow = 1,
		no_fire_alert = true,
		sound_event_burning = "no_sound",
		sound_event_burning_stop = "snowmolo_burn_loop_stop",
		damage = 1.3,
		player_damage = 1.3,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.2,
		burn_duration = 1,
		effect_name = "effects/payday2/particles/character/snowman_molotov"
	}

	return params
end
