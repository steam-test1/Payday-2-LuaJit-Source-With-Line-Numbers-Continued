-- Lines 2-31
function BlackMarketTweakData:get_glove_value(glove_id, character_name, key, player_style, material_variation)
	if key == nil then
		return
	end

	glove_id = glove_id or "default"

	if glove_id == "default" then
		glove_id = self.suit_default_gloves[player_style]

		if glove_id == false then
			return false
		end
	end

	local data = self.gloves[glove_id or "default"]

	if data == nil then
		return nil
	end

	character_name = CriminalsManager.convert_old_to_new_character_workname(character_name)
	local character_value = data.characters and data.characters[character_name] and data.characters[character_name][key]

	if character_value ~= nil then
		return character_value
	end

	local tweak_value = data and data[key]

	return tweak_value
end

-- Lines 33-76
function BlackMarketTweakData:build_glove_list(tweak_data)
	local x_td, y_td, x_gv, y_gv, x_sn, y_sn = nil

	-- Lines 37-73
	local function sort_func(x, y)
		if x == "default" then
			return true
		end

		if y == "default" then
			return false
		end

		x_td = self.gloves[x]
		y_td = self.gloves[y]

		if x_td.unlocked ~= y_td.unlocked then
			return x_td.unlocked
		end

		x_gv = x_td.global_value or x_td.dlc or "normal"
		y_gv = y_td.global_value or y_td.dlc or "normal"
		x_sn = x_gv and tweak_data.lootdrop.global_values[x_gv].sort_number or 0
		y_sn = y_gv and tweak_data.lootdrop.global_values[y_gv].sort_number or 0
		x_sn = x_sn + (x_td.gv_sort_number or 0)
		y_sn = y_sn + (y_td.gv_sort_number or 0)

		if x_sn ~= y_sn then
			return x_sn < y_sn
		end

		x_sn = x_td.sort_number or 0
		y_sn = y_td.sort_number or 0

		if x_sn ~= y_sn then
			return x_sn < y_sn
		end

		return x < y
	end

	self.glove_list = table.map_keys(self.gloves, sort_func)
end

-- Lines 78-1226
function BlackMarketTweakData:_init_gloves(tweak_data)
	local characters_female, characters_female_big, characters_male, characters_male_big = self:_get_character_groups()
	local characters_all = table.list_union(characters_female, characters_male, characters_female_big, characters_male_big)

	-- Lines 82-87
	local function set_characters_data(glove_id, characters, data)
		self.gloves[glove_id].characters = self.gloves[glove_id].characters or {}

		for _, key in ipairs(characters) do
			self.gloves[glove_id].characters[key] = data
		end
	end

	self.gloves = {}
	self.glove_list = {}
	self.glove_adapter = {
		unit = "units/pd2_dlc_hnd/characters/hnd_forearms/hnd_forearms",
		third_material = "units/pd2_dlc_hnd/characters/hnd_forearms/hnd_forearms_third",
		character_sequence = {
			bonnie = "set_arms_female",
			dragon = "set_arms_male_02",
			myh = "set_arms_male",
			chico = "set_arms_male_02",
			dragan = "set_arms_male",
			ecp_male = "set_arms_male",
			ecp_female = "set_arms_female",
			max = "set_arms_male_sangres",
			old_hoxton = "set_arms_male",
			jowi = "set_arms_male",
			wild = "set_arms_male",
			joy = "set_arms_female_joy",
			dallas = "set_arms_male",
			jacket = "set_arms_male",
			jimmy = "set_arms_male",
			bodhi = "set_arms_male_bodhi",
			wolf = "set_arms_male",
			sokol = "set_arms_male",
			hoxton = "set_arms_male",
			female_1 = "set_arms_female",
			chains = "set_arms_male_chains",
			sydney = "set_arms_female_sydney"
		},
		player_style_exclude_list = {
			"none",
			"slaughterhouse",
			"texvest",
			"newhorizon",
			"bikervest"
		}
	}
	self.suit_default_gloves = {
		gangstercoat = "heist_default",
		badsanta = "heist_default",
		sparkle = "heist_default",
		moneysuit = "heist_default",
		jumpsuit = "heat",
		poolrepair = "heist_default",
		gunslinger = "heist_default",
		overkillpunk = "heist_default",
		nightwalker = "tasslefringe",
		winter_suit = "sneak",
		miami = "heist_default",
		hippie = "rainbow_mittens",
		enforcer = "heist_default",
		general = "heist_default",
		t800 = "heist_default",
		highinttech = "heist_default",
		cybertrench = "heist_default",
		xmas_tuxedo = "heist_default",
		sneak_suit = "sneak",
		mariachi = "mariatchi",
		gentleman = "heist_default",
		cargocasual = "heist_default",
		newhorizon = "darkmat",
		elfsuit = "heist_default",
		puffervest = "heist_default",
		bthekid = "txbull",
		mocow = "ranchdiesel",
		sambass = "txsuede",
		classyske = "heist_default",
		tux = "heist_default",
		continental = "continental",
		leatherfluff = "heist_default",
		sleekygent = "beigedriver",
		lowinttech = "heist_default",
		bossflag = "heist_default",
		boss = "heist_default",
		rusbear = "heist_default",
		texvest = "heist_default",
		roclown = "roclogrip",
		thug = "heist_default",
		bikervest = "heist_default",
		clown_2 = "heist_default",
		dodsuit = "heist_default",
		desperado = "desperado",
		hiphop = "bonemittens",
		lonorwa = "heist_default",
		corl = "heist_default",
		esport = "esport",
		ghostly = "tornrags",
		murky_suit = "murky",
		cyberhoodie = "heist_default",
		elegantscarf = "heist_default",
		cassidy = "txrider",
		hitman = "heist_default",
		clown = "heist_clown",
		railroad = "heist_default",
		fighterpilot = "heist_default",
		bullranch = "heist_default",
		candycane = "heist_default",
		bunny = "heist_default",
		slaughterhouse = "heist_default",
		traditional = "heist_default",
		kungfumaster = "heist_default",
		scrub = "heist_default",
		bikerjacket = "heist_default",
		hacksuit = "hackglove",
		peacoat = "saints",
		baron = "jesterstripe",
		darkprince = "devilclaws",
		leather = "heist_default",
		punk = "punk",
		cartelboss = "heist_default",
		raincoat = "heist_default",
		jessjames = "txrivet",
		cable_guy = "heist_default",
		jail_pd2_clan = "heist_default",
		gangzsta = "heist_default"
	}
	self.gloves.default = {
		name_id = "bm_gloves_default",
		desc_id = "bm_gloves_default_desc",
		texture_bundle_folder = "hnd",
		unlocked = true
	}
	self.gloves.heist_default = {
		name_id = "bm_gloves_heistwrinkled",
		desc_id = "bm_gloves_heistwrinkled_desc",
		texture_bundle_folder = "hnd",
		gv_sort_number = -1000,
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_heistwrinkled/hnd_glv_heistwrinkled",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_heistwrinkled/hnd_glv_heistwrinkled_third"
	}
	self.gloves.saints = {
		name_id = "bm_gloves_saintsleather",
		desc_id = "bm_gloves_saintsleather_desc",
		texture_bundle_folder = "hnd",
		global_value = "trd",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_saintsleather/hnd_glv_saintsleather",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_saintsleather/hnd_glv_saintsleather_third"
	}
	self.gloves.heist_clown = {
		name_id = "bm_gloves_heistwrinkled_purple",
		desc_id = "bm_gloves_heistwrinkled_purple_desc",
		texture_bundle_folder = "hnd",
		global_value = "trd",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_heistwrinkled_purple/hnd_glv_heistwrinkled_purple",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_heistwrinkled_purple/hnd_glv_heistwrinkled_purple_third"
	}
	self.gloves.heat = {
		name_id = "bm_gloves_heatleather",
		desc_id = "bm_gloves_heatleather_desc",
		texture_bundle_folder = "hnd",
		global_value = "trd",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_heatleather/hnd_glv_heatleather",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_heatleather/hnd_glv_heatleather_third"
	}
	self.gloves.sneak = {
		name_id = "bm_gloves_sneak",
		desc_id = "bm_gloves_sneak_desc",
		texture_bundle_folder = "hnd",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_sneakgloves/hnd_glv_sneakgloves",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_sneakgloves/hnd_glv_sneakgloves_third"
	}
	self.gloves.overkillpunk = {
		name_id = "bm_gloves_overkillpunk",
		desc_id = "bm_gloves_overkillpunk_desc",
		texture_bundle_folder = "in33",
		global_value = "in33",
		sort_number = 1,
		unit = "units/pd2_dlc_in33/characters/glv_overkillpunk/glv_overkillpunk",
		third_material = "units/pd2_dlc_in33/characters/glv_overkillpunk/glv_overkillpunk_third"
	}
	self.gloves.murky = {
		name_id = "bm_gloves_murky",
		desc_id = "bm_gloves_murky_desc",
		texture_bundle_folder = "hnd",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_murkygloves/hnd_glv_murkygloves",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_murkygloves/hnd_glv_murkygloves_third"
	}
	self.gloves.mariatchi = {
		name_id = "bm_gloves_heistwrinkled_white",
		desc_id = "bm_gloves_heistwrinkled_white_desc",
		texture_bundle_folder = "hnd",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_heistwrinkled_white/hnd_glv_heistwrinkled_white",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_heistwrinkled_white/hnd_glv_heistwrinkled_white_third"
	}
	self.gloves.punk = {
		name_id = "bm_gloves_punkleather",
		desc_id = "bm_gloves_punkleather_desc",
		texture_bundle_folder = "hnd",
		global_value = "mbs",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_punkleather/hnd_glv_punkleather",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_punkleather/hnd_glv_punkleather_third"
	}
	self.gloves.desperado = {
		name_id = "bm_gloves_desperadoleather",
		desc_id = "bm_gloves_desperadoleather_desc",
		texture_bundle_folder = "hnd",
		global_value = "mbs",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_desperadoleather/hnd_glv_desperadoleather",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_desperadoleather/hnd_glv_desperadoleather_third"
	}
	self.gloves.bonemittens = {
		name_id = "bm_gloves_bonemittens",
		desc_id = "bm_gloves_bonemittens_desc",
		texture_bundle_folder = "hnd",
		global_value = "mbs",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_bonemittens/hnd_glv_bonemittens",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_bonemittens/hnd_glv_bonemittens_third"
	}
	self.gloves.rainbow_mittens = {
		name_id = "bm_gloves_rainbowmittens",
		desc_id = "bm_gloves_rainbowmittens_desc",
		texture_bundle_folder = "hnd",
		global_value = "mbs",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_rainbowmittens/hnd_glv_rainbowmittens",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_rainbowmittens/hnd_glv_rainbowmittens_third"
	}
	self.gloves.esport = {
		name_id = "bm_gloves_esport",
		desc_id = "bm_gloves_esport_desc",
		texture_bundle_folder = "hnd",
		global_value = "ess",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_esport/hnd_glv_esport",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_esport/hnd_glv_esport_third"
	}
	self.gloves.kids = {
		name_id = "bm_gloves_kidswool",
		desc_id = "bm_gloves_kidswool_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_kidswool/hnd_glv_kidswool",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_kidswool/hnd_glv_kidswool_third"
	}
	self.gloves.driver = {
		name_id = "bm_gloves_driverleather",
		desc_id = "bm_gloves_driverleather_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_driverleather/hnd_glv_driverleather",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_driverleather/hnd_glv_driverleather_third"
	}
	self.gloves.fancy = {
		name_id = "bm_gloves_fancycloth",
		desc_id = "bm_gloves_fancycloth_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_fancycloth/hnd_glv_fancycloth",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_fancycloth/hnd_glv_fancycloth_third"
	}
	self.gloves.tactical = {
		name_id = "bm_gloves_tactical",
		desc_id = "bm_gloves_tactical_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_tactical/hnd_glv_tactical",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_tactical/hnd_glv_tactical_third"
	}
	self.gloves.biker = {
		name_id = "bm_gloves_biker",
		desc_id = "bm_gloves_biker_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_third"
	}
	self.gloves.biker_red = {
		name_id = "bm_gloves_biker_red",
		desc_id = "bm_gloves_biker_red_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_red",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_red_third"
	}
	self.gloves.biker_orange = {
		name_id = "bm_gloves_biker_orange",
		desc_id = "bm_gloves_biker_orange_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_orange",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_orange_third"
	}
	self.gloves.biker_blue = {
		name_id = "bm_gloves_biker_blue",
		desc_id = "bm_gloves_biker_blue_desc",
		texture_bundle_folder = "gpo",
		global_value = "pgo",
		unit = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_blue",
		third_material = "units/pd2_dlc_hnd/characters/hnd_glv_biker/hnd_glv_biker_blue_third"
	}
	self.gloves.continental = {
		name_id = "bm_gloves_continental",
		desc_id = "bm_gloves_continental_desc",
		texture_bundle_folder = "anv",
		global_value = "anv",
		unit = "units/pd2_dlc_anv/characters/anv_glv_continental/anv_glv_continental",
		third_material = "units/pd2_dlc_anv/characters/anv_glv_continental/anv_glv_continental_third"
	}
	self.gloves.sportsbike = {
		name_id = "bm_gloves_sportsbike",
		desc_id = "bm_gloves_sportsbike_desc",
		texture_bundle_folder = "pgo",
		global_value = "pgo",
		unit = "units/pd2_dlc_pgo/characters/pgo_glv_sportsbike/pgo_glv_sportsbike",
		third_material = "units/pd2_dlc_pgo/characters/pgo_glv_sportsbike/pgo_glv_sportsbike_third"
	}
	self.gloves.hockey = {
		name_id = "bm_gloves_hockey",
		desc_id = "bm_gloves_hockey_desc",
		texture_bundle_folder = "pgo",
		global_value = "pgo",
		unit = "units/pd2_dlc_pgo/characters/pgo_glv_hockey/pgo_glv_hockey",
		third_material = "units/pd2_dlc_pgo/characters/pgo_glv_hockey/pgo_glv_hockey_third"
	}
	self.gloves.bananabike = {
		name_id = "bm_gloves_bananabike",
		desc_id = "bm_gloves_bananabike_desc",
		texture_bundle_folder = "pgo",
		global_value = "pgo",
		unit = "units/pd2_dlc_pgo/characters/pgo_glv_bananabike/pgo_glv_bananabike",
		third_material = "units/pd2_dlc_pgo/characters/pgo_glv_bananabike/pgo_glv_bananabike_third"
	}
	self.gloves.chopper = {
		name_id = "bm_gloves_chopper",
		desc_id = "bm_gloves_chopper_desc",
		texture_bundle_folder = "pgo",
		global_value = "pgo",
		unit = "units/pd2_dlc_pgo/characters/pgo_glv_chopper/pgo_glv_chopper",
		third_material = "units/pd2_dlc_pgo/characters/pgo_glv_chopper/pgo_glv_chopper_third"
	}
	self.gloves.neoncity = {
		name_id = "bm_gloves_neoncity",
		desc_id = "bm_gloves_neoncity_desc",
		texture_bundle_folder = "inf",
		global_value = "inf",
		sort_number = 2,
		unit = "units/pd2_dlc_inf3/characters/glv_neoncity/glv_neoncity",
		third_material = "units/pd2_dlc_inf3/characters/glv_neoncity/glv_neoncity_third"
	}
	self.gloves.molten = {
		name_id = "bm_gloves_molten",
		desc_id = "bm_gloves_molten_desc",
		texture_bundle_folder = "inf",
		global_value = "inf",
		sort_number = 4,
		unit = "units/pd2_dlc_inf3/characters/glv_molten/glv_molten",
		third_material = "units/pd2_dlc_inf3/characters/glv_molten/glv_molten_third"
	}
	self.gloves.cosmos = {
		name_id = "bm_gloves_cosmos",
		desc_id = "bm_gloves_cosmos_desc",
		texture_bundle_folder = "inf",
		global_value = "inf",
		sort_number = 3,
		unit = "units/pd2_dlc_inf3/characters/glv_cosmos/glv_cosmos",
		third_material = "units/pd2_dlc_inf3/characters/glv_cosmos/glv_cosmos_third"
	}
	self.gloves.tiger = {
		name_id = "bm_gloves_tiger",
		desc_id = "bm_gloves_tiger_desc",
		texture_bundle_folder = "inf",
		global_value = "inf",
		unit = "units/pd2_dlc_inf3/characters/glv_tiger/glv_tiger",
		third_material = "units/pd2_dlc_inf3/characters/glv_tiger/glv_tiger_third"
	}
	self.gloves.wool = {
		name_id = "bm_gloves_wool",
		desc_id = "bm_gloves_wool_desc",
		texture_bundle_folder = "in31",
		global_value = "in31",
		sort_number = 1,
		unit = "units/pd2_dlc_in31/characters/glv_wool/glv_wool",
		third_material = "units/pd2_dlc_in31/characters/glv_wool/glv_wool_third"
	}
	self.gloves.silver = {
		name_id = "bm_gloves_silver",
		desc_id = "bm_gloves_silver_desc",
		texture_bundle_folder = "in31",
		global_value = "in31",
		sort_number = 2,
		unit = "units/pd2_dlc_in31/characters/glv_silver/glv_silver",
		third_material = "units/pd2_dlc_in31/characters/glv_silver/glv_silver_third"
	}
	self.gloves.redstripe = {
		name_id = "bm_gloves_tstp_redstripe",
		desc_id = "bm_gloves_tstp_redstripe_desc",
		texture_bundle_folder = "tstp",
		global_value = "tstp",
		sort_number = 1,
		unit = "units/pd2_dlc_tstp/characters/tstp_glv_redstripe/tstp_glv_redstripe",
		third_material = "units/pd2_dlc_tstp/characters/tstp_glv_redstripe/tstp_glv_redstripe_third"
	}
	self.gloves.flame = {
		name_id = "bm_gloves_tstp_flame",
		desc_id = "bm_gloves_tstp_flame_desc",
		texture_bundle_folder = "tstp",
		global_value = "tstp",
		sort_number = 2,
		unit = "units/pd2_dlc_tstp/characters/tstp_glv_flame/tstp_glv_flame",
		third_material = "units/pd2_dlc_tstp/characters/tstp_glv_flame/tstp_glv_flame_third"
	}
	self.gloves.reddragon = {
		name_id = "bm_gloves_tstp_reddragon",
		desc_id = "bm_gloves_tstp_reddragon_desc",
		texture_bundle_folder = "tstp",
		global_value = "tstp",
		sort_number = 3,
		unit = "units/pd2_dlc_tstp/characters/tstp_glv_reddragon/tstp_glv_reddragon",
		third_material = "units/pd2_dlc_tstp/characters/tstp_glv_reddragon/tstp_glv_reddragon_third"
	}
	self.gloves.blackdragon = {
		name_id = "bm_gloves_tstp_blackdragon",
		desc_id = "bm_gloves_tstp_blackdragon_desc",
		texture_bundle_folder = "tstp",
		global_value = "tstp",
		sort_number = 4,
		unit = "units/pd2_dlc_tstp/characters/tstp_glv_blackdragon/tstp_glv_blackdragon",
		third_material = "units/pd2_dlc_tstp/characters/tstp_glv_blackdragon/tstp_glv_blackdragon_third"
	}
	self.gloves.tiger_red = {
		name_id = "bm_gloves_tiger_red",
		desc_id = "bm_gloves_tiger_red_desc",
		texture_bundle_folder = "pda10",
		global_value = "pda10",
		sort_number = 1,
		unit = "units/pd2_dlc_pda10/characters/glv_tiger_red/glv_tiger_red",
		third_material = "units/pd2_dlc_pda10/characters/glv_tiger_red/glv_tiger_red_third"
	}
	self.gloves.tiger_neon = {
		name_id = "bm_gloves_tiger_neon",
		desc_id = "bm_gloves_tiger_neon_desc",
		texture_bundle_folder = "pda10",
		global_value = "pda10",
		unit = "units/pd2_dlc_pda10/characters/glv_tiger_neon/glv_tiger_neon",
		third_material = "units/pd2_dlc_pda10/characters/glv_tiger_neon/glv_tiger_neon_third"
	}
	self.gloves.goldnet = {
		name_id = "bm_gloves_goldnet",
		desc_id = "bm_gloves_goldnet_desc",
		texture_bundle_folder = "in32",
		global_value = "in32",
		sort_number = 1,
		unit = "units/pd2_dlc_in32/characters/in32_glv_goldnet/glv_goldnet",
		third_material = "units/pd2_dlc_in32/characters/in32_glv_goldnet/glv_goldnet_third"
	}
	self.gloves.postmoto = {
		name_id = "bm_gloves_postmoto",
		desc_id = "bm_gloves_postmoto_desc",
		texture_bundle_folder = "in32",
		global_value = "in32",
		sort_number = 2,
		unit = "units/pd2_dlc_in32/characters/in32_glv_postmoto/glv_postmoto",
		third_material = "units/pd2_dlc_in32/characters/in32_glv_postmoto/glv_postmoto_third"
	}
	self.gloves.techlow_tortoise = {
		name_id = "bm_gloves_techlow_tortoise",
		desc_id = "bm_gloves_techlow_tortoise_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techlow_tortoise/glv_techlow_tortoise",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techlow_tortoise/glv_techlow_tortoise_third"
	}
	self.gloves.techlow_dragon = {
		name_id = "bm_gloves_techlow_dragon",
		desc_id = "bm_gloves_techlow_dragon_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techlow_dragon/glv_techlow_dragon",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techlow_dragon/glv_techlow_dragon_third"
	}
	self.gloves.techlow_tiger = {
		name_id = "bm_gloves_techlow_tiger",
		desc_id = "bm_gloves_techlow_tiger_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techlow_tiger/glv_techlow_tiger",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techlow_tiger/glv_techlow_tiger_third"
	}
	self.gloves.techlow_bird = {
		name_id = "bm_gloves_techlow_bird",
		desc_id = "bm_gloves_techlow_bird_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techlow_bird/glv_techlow_bird",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techlow_bird/glv_techlow_bird_third"
	}
	self.gloves.techhigh_tiger = {
		name_id = "bm_gloves_techhigh_tiger",
		desc_id = "bm_gloves_techhigh_tiger_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techhigh_tiger/glv_techhigh_tiger",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techhigh_tiger/glv_techhigh_tiger_third"
	}
	self.gloves.techhigh_tortoise = {
		name_id = "bm_gloves_techhigh_tortoise",
		desc_id = "bm_gloves_techhigh_tortoise_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techhigh_tortoise/glv_techhigh_tortoise",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techhigh_tortoise/glv_techhigh_tortoise_third"
	}
	self.gloves.techhigh_dragon = {
		name_id = "bm_gloves_techhigh_dragon",
		desc_id = "bm_gloves_techhigh_dragon_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techhigh_dragon/glv_techhigh_dragon",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techhigh_dragon/glv_techhigh_dragon_third"
	}
	self.gloves.techhigh_bird = {
		name_id = "bm_gloves_techhigh_bird",
		desc_id = "bm_gloves_techhigh_bird_desc",
		texture_bundle_folder = "sdtp",
		global_value = "sdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_sdtp/characters/glv_techhigh_bird/glv_techhigh_bird",
		third_material = "units/pd2_dlc_sdtp/characters/glv_techhigh_bird/glv_techhigh_bird_third"
	}
	self.gloves.jesterstripe = {
		name_id = "bm_gloves_jesterstripe",
		desc_id = "bm_gloves_jesterstripe_desc",
		texture_bundle_folder = "pda8",
		global_value = "pda8",
		sort_number = 1,
		unit = "units/pd2_dlc_pda8/characters/glv_jesterstripe/glv_jesterstripe",
		third_material = "units/pd2_dlc_pda8/characters/glv_jesterstripe/glv_jesterstripe_third"
	}
	self.gloves.mnk = {
		name_id = "bm_gloves_mnk",
		desc_id = "bm_gloves_mnk_desc",
		texture_bundle_folder = "cctp",
		global_value = "cctp",
		sort_number = 1,
		unit = "units/pd2_dlc_cctp/characters/glv_mnk/glv_mnk",
		third_material = "units/pd2_dlc_cctp/characters/glv_mnk/glv_mnk_third"
	}
	self.gloves.mnt = {
		name_id = "bm_gloves_mnt",
		desc_id = "bm_gloves_mnt_desc",
		texture_bundle_folder = "cctp",
		global_value = "cctp",
		sort_number = 1,
		unit = "units/pd2_dlc_cctp/characters/glv_mnt/glv_mnt",
		third_material = "units/pd2_dlc_cctp/characters/glv_mnt/glv_mnt_third"
	}
	self.gloves.tgr = {
		name_id = "bm_gloves_tgr",
		desc_id = "bm_gloves_tgr_desc",
		texture_bundle_folder = "cctp",
		global_value = "cctp",
		sort_number = 1,
		unit = "units/pd2_dlc_cctp/characters/glv_tgr/glv_tgr",
		third_material = "units/pd2_dlc_cctp/characters/glv_tgr/glv_tgr_third"
	}
	self.gloves.vpr = {
		name_id = "bm_gloves_vpr",
		desc_id = "bm_gloves_vpr_desc",
		texture_bundle_folder = "cctp",
		global_value = "cctp",
		sort_number = 1,
		unit = "units/pd2_dlc_cctp/characters/glv_vpr/glv_vpr",
		third_material = "units/pd2_dlc_cctp/characters/glv_vpr/glv_vpr_third"
	}
	self.gloves.biker_yellow_led = {
		name_id = "bm_gloves_bike_yellow_led",
		desc_id = "bm_gloves_bike_yellow_led_desc",
		texture_bundle_folder = "gdtp",
		global_value = "gdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_gdtp/characters/glv_biker_yellow_led/glv_biker_yellow_led",
		third_material = "units/pd2_dlc_gdtp/characters/glv_biker_yellow_led/glv_biker_yellow_led_third"
	}
	self.gloves.biker_red_led = {
		name_id = "bm_gloves_bike_red_led",
		desc_id = "bm_gloves_bike_red_led_desc",
		texture_bundle_folder = "gdtp",
		global_value = "gdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_gdtp/characters/glv_biker_red_led/glv_biker_red_led",
		third_material = "units/pd2_dlc_gdtp/characters/glv_biker_red_led/glv_biker_red_led_third"
	}
	self.gloves.spikeknuckle = {
		name_id = "bm_gloves_spikeknuckle",
		desc_id = "bm_gloves_spikeknuckle_desc",
		texture_bundle_folder = "gdtp",
		global_value = "gdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_gdtp/characters/glv_spikeknuckle/glv_spikeknuckle",
		third_material = "units/pd2_dlc_gdtp/characters/glv_spikeknuckle/glv_spikeknuckle_third"
	}
	self.gloves.dragonscale = {
		name_id = "bm_gloves_dragonscale",
		desc_id = "bm_gloves_dragonscale_desc",
		texture_bundle_folder = "gdtp",
		global_value = "gdtp",
		sort_number = 1,
		unit = "units/pd2_dlc_gdtp/characters/glv_dragonscale/glv_dragonscale",
		third_material = "units/pd2_dlc_gdtp/characters/glv_dragonscale/glv_dragonscale_third"
	}
	self.gloves.hardwork = {
		name_id = "bm_gloves_hardwork",
		desc_id = "bm_gloves_hardwork_desc",
		texture_bundle_folder = "txt1",
		global_value = "txt1",
		sort_number = 1,
		unit = "units/pd2_dlc_txt1/characters/glv_hardwork/glv_hardwork",
		third_material = "units/pd2_dlc_txt1/characters/glv_hardwork/glv_hardwork_third"
	}
	self.gloves.texriding = {
		name_id = "bm_gloves_texriding",
		desc_id = "bm_gloves_texriding_desc",
		texture_bundle_folder = "txt1",
		global_value = "txt1",
		sort_number = 1,
		unit = "units/pd2_dlc_txt1/characters/glv_texriding/glv_texriding",
		third_material = "units/pd2_dlc_txt1/characters/glv_texriding/glv_texriding_third"
	}
	self.gloves.blackstar = {
		name_id = "bm_gloves_blackstar",
		desc_id = "bm_gloves_blackstar_desc",
		texture_bundle_folder = "txt1",
		global_value = "txt1",
		sort_number = 1,
		unit = "units/pd2_dlc_txt1/characters/glv_blackstar/glv_blackstar",
		third_material = "units/pd2_dlc_txt1/characters/glv_blackstar/glv_blackstar_third"
	}
	self.gloves.workranch = {
		name_id = "bm_gloves_workranch",
		desc_id = "bm_gloves_workranch_desc",
		texture_bundle_folder = "txt1",
		global_value = "txt1",
		sort_number = 1,
		unit = "units/pd2_dlc_txt1/characters/glv_workranch/glv_workranch",
		third_material = "units/pd2_dlc_txt1/characters/glv_workranch/glv_workranch_third"
	}
	self.gloves.ranchdiesel = {
		name_id = "bm_gloves_ranchdiesel",
		desc_id = "bm_gloves_ranchdiesel_desc",
		texture_bundle_folder = "rat",
		global_value = "rat_ranchdiesel",
		sort_number = 1,
		unit = "units/pd2_dlc_rat/characters/glv_ranchdiesel/glv_ranchdiesel",
		third_material = "units/pd2_dlc_rat/characters/glv_ranchdiesel/glv_ranchdiesel_third"
	}
	self.gloves.darkmat = {
		name_id = "bm_gloves_darkmat",
		desc_id = "bm_gloves_darkmat_desc",
		texture_bundle_folder = "prim",
		global_value = "prim_darkmat",
		sort_number = 1,
		unit = "units/pd2_dlc_prim/characters/glv_darkmat/glv_darkmat",
		third_material = "units/pd2_dlc_prim/characters/glv_darkmat/glv_darkmat_third"
	}
	self.gloves.chromecross = {
		name_id = "bm_gloves_chromecross",
		desc_id = "bm_gloves_chromecross_desc",
		texture_bundle_folder = "txt2",
		global_value = "txt2",
		sort_number = 1,
		unit = "units/pd2_dlc_txt2/characters/glv_chromecross/glv_chromecross",
		third_material = "units/pd2_dlc_txt2/characters/glv_chromecross/glv_chromecross_third"
	}
	self.gloves.redhand = {
		name_id = "bm_gloves_redhand",
		desc_id = "bm_gloves_redhand_desc",
		texture_bundle_folder = "txt2",
		global_value = "txt2",
		sort_number = 1,
		unit = "units/pd2_dlc_txt2/characters/glv_redhand/glv_redhand",
		third_material = "units/pd2_dlc_txt2/characters/glv_redhand/glv_redhand_third"
	}
	self.gloves.leatherspark = {
		name_id = "bm_gloves_leatherspark",
		desc_id = "bm_gloves_leatherspark_desc",
		texture_bundle_folder = "pda9",
		global_value = "pda9",
		sort_number = 1,
		unit = "units/pd2_dlc_pda9/characters/glv_leatherspark/glv_leatherspark",
		third_material = "units/pd2_dlc_pda9/characters/glv_leatherspark/glv_leatherspark_third"
	}
	self.gloves.dodskull = {
		name_id = "bm_gloves_dodskull",
		desc_id = "bm_gloves_dodskull_desc",
		texture_bundle_folder = "tma1",
		global_value = "tma1",
		sort_number = 1,
		unit = "units/pd2_dlc_tma1/characters/glv_dodskull/glv_dodskull",
		third_material = "units/pd2_dlc_tma1/characters/glv_dodskull/glv_dodskull_third"
	}
	self.gloves.railwork = {
		name_id = "bm_gloves_railwork",
		desc_id = "bm_gloves_railwork_desc",
		texture_bundle_folder = "trt",
		global_value = "trt_railwork",
		sort_number = 1,
		unit = "units/pd2_dlc_trt/characters/glv_railwork/glv_railwork",
		third_material = "units/pd2_dlc_trt/characters/glv_railwork/glv_railwork_third"
	}
	self.gloves.devilclaws = {
		name_id = "bm_gloves_devilclaws",
		desc_id = "bm_gloves_devilclaws_desc",
		texture_bundle_folder = "h22",
		global_value = "h22_devilclaws",
		sort_number = 1,
		unit = "units/pd2_dlc_h22/characters/glv_devilclaws/glv_devilclaws",
		third_material = "units/pd2_dlc_h22/characters/glv_devilclaws/glv_devilclaws_third"
	}
	self.gloves.tasslefringe = {
		name_id = "bm_gloves_tasslefringe",
		desc_id = "bm_gloves_tasslefringe_desc",
		texture_bundle_folder = "h22",
		global_value = "h22_tasslefringe",
		sort_number = 1,
		unit = "units/pd2_dlc_h22/characters/glv_tasslefringe/glv_tasslefringe",
		third_material = "units/pd2_dlc_h22/characters/glv_tasslefringe/glv_tasslefringe_third"
	}
	self.gloves.tornrags = {
		name_id = "bm_gloves_tornrags",
		desc_id = "bm_gloves_tornrags_desc",
		texture_bundle_folder = "h22",
		global_value = "h22_tornrags",
		sort_number = 1,
		unit = "units/pd2_dlc_h22/characters/glv_tornrags/glv_tornrags",
		third_material = "units/pd2_dlc_h22/characters/glv_tornrags/glv_tornrags_third"
	}
	self.gloves.beigedriver = {
		name_id = "bm_gloves_beigedriver",
		desc_id = "bm_gloves_beigedriver_desc",
		texture_bundle_folder = "cot",
		global_value = "cot_beigedriver",
		sort_number = 1,
		unit = "units/pd2_dlc_cot/characters/glv_beigedriver/glv_beigedriver",
		third_material = "units/pd2_dlc_cot/characters/glv_beigedriver/glv_beigedriver_third"
	}
	self.gloves.txbull = {
		name_id = "bm_gloves_txbull",
		desc_id = "bm_gloves_txbull_desc",
		texture_bundle_folder = "txt4",
		global_value = "txt4",
		sort_number = 1,
		unit = "units/pd2_dlc_txt4/characters/glv_txbull/glv_txbull",
		third_material = "units/pd2_dlc_txt4/characters/glv_txbull/glv_txbull_third"
	}
	self.gloves.txrider = {
		name_id = "bm_gloves_txrider",
		desc_id = "bm_gloves_txrider_desc",
		texture_bundle_folder = "txt4",
		global_value = "txt4",
		sort_number = 1,
		unit = "units/pd2_dlc_txt4/characters/glv_txrider/glv_txrider",
		third_material = "units/pd2_dlc_txt4/characters/glv_txrider/glv_txrider_third"
	}
	self.gloves.txrivet = {
		name_id = "bm_gloves_txrivet",
		desc_id = "bm_gloves_txrivet_desc",
		texture_bundle_folder = "txt4",
		global_value = "txt4",
		sort_number = 1,
		unit = "units/pd2_dlc_txt4/characters/glv_txrivet/glv_txrivet",
		third_material = "units/pd2_dlc_txt4/characters/glv_txrivet/glv_txrivet_third"
	}
	self.gloves.txsuede = {
		name_id = "bm_gloves_txsuede",
		desc_id = "bm_gloves_txsuede_desc",
		texture_bundle_folder = "txt4",
		global_value = "txt4",
		sort_number = 1,
		unit = "units/pd2_dlc_txt4/characters/glv_txsuede/glv_txsuede",
		third_material = "units/pd2_dlc_txt4/characters/glv_txsuede/glv_txsuede_third"
	}
	self.gloves.roclogrip = {
		name_id = "bm_gloves_roclogrip",
		desc_id = "bm_gloves_roclogrip_desc",
		texture_bundle_folder = "dot",
		global_value = "dot_roclogrip_glv",
		sort_number = 1,
		unit = "units/pd2_dlc_dot/characters/glv_roclogrip/glv_roclogrip",
		third_material = "units/pd2_dlc_dot/characters/glv_roclogrip/glv_roclogrip_third"
	}
	self.gloves.hackglove = {
		name_id = "bm_gloves_hackglove",
		desc_id = "bm_gloves_hackglove_desc",
		texture_bundle_folder = "lrfo",
		global_value = "lrfo",
		sort_number = 1,
		unit = "units/pd2_dlc_lrfo/characters/glv_hackglove/glv_hackglove",
		third_material = "units/pd2_dlc_lrfo/characters/glv_hackglove/glv_hackglove_third"
	}
end
