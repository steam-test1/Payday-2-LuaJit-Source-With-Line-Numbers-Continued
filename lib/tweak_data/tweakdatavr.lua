TweakDataVR = TweakDataVR or class()

-- Lines: 3 to 2994
function TweakDataVR:init()
	self.melee_offsets = {
		default = {rotation = Rotation(0, 70)},
		types = {fists = {rotation = Rotation(180, 70, 180)}},
		weapons = {
			boxing_gloves = {
				rotation = Rotation(0, 0, 90),
				position = Vector3(0, -17, -2),
				hit_point = Vector3(-2, 20, 0)
			},
			dingdong = {position = Vector3(0, 4, 13)},
			fists = {hit_point = Vector3(0, 3, 0)},
			catch = {
				rotation = Rotation(0, 110, 180),
				hit_point = Vector3(5, 0, -20)
			},
			nin = {
				rotation = Rotation(),
				hit_point = Vector3(0, 20, 8)
			},
			ostry = {
				rotation = Rotation(0, 0, -90),
				hit_point = Vector3(-12, 42, 0)
			},
			scoutknife = {position = Vector3(0, 0, 3)},
			fairbair = {rotation = Rotation(90, 90, 20)},
			bowie = {
				rotation = Rotation(180, 110, 0),
				position = Vector3(0, 0, 3)
			},
			twins = {rotation = Rotation(90, 90, 20)},
			baseballbat = {position = Vector3(0, 2, 10)},
			sandsteel = {position = Vector3(0, 2, 6.5)},
			cutters = {rotation = Rotation(180, 110, 0)},
			alien_maul = {position = Vector3(0, 8, 26)},
			barbedwire = {position = Vector3(0, 0, 0)},
			beardy = {position = Vector3(0, 8, 26)},
			buck = {
				rotation = Rotation(90, 90, 20),
				hit_point = Vector3(4, 0, 2)
			},
			brick = {
				rotation = Rotation(0, -20, 0),
				position = Vector3(0, 5, 10),
				hit_point = Vector3(0, 0, 18)
			},
			tiger = {
				hand_flip = true,
				rotation = Rotation(175, 85, 180),
				hit_point = Vector3(0, 0, 8)
			},
			zeus = {
				hit_point = Vector3(0, 0, 10),
				rotation = Rotation(180, 110, 0)
			},
			freedom = {position = Vector3(0, 4, 15)},
			great = {position = Vector3(0, 1, 4)}
		},
		bayonets = {wpn_fps_snp_mosin_ns_bayonet = {hit_point = Vector3(0, 30, -3)}}
	}
	self.weapon_offsets = {
		default = {position = Vector3(0, -1, 2)},
		weapons = {
			mosin = {position = Vector3(0, -6, 2)},
			m134 = {position = Vector3(-6, 27, 0)},
			l85a2 = {position = Vector3(0, -4, 2)},
			m1928 = {position = Vector3(0, -4, 2)},
			r93 = {position = Vector3(0, -4, 2)},
			wa2000 = {position = Vector3(0, -2, 2)},
			ak5 = {position = Vector3(0, 2, 2)},
			fal = {position = Vector3(0, 2, 2)},
			akmsu = {position = Vector3(0, 2, 2)}
		}
	}
	self.throwable_offsets = {
		default = {},
		wpn_prj_ace = {
			grip = "grip_wpn",
			position = Vector3(0, 0, -3),
			rotation = Rotation(0, 30, 0)
		},
		wpn_prj_target = {
			grip = "grip_wpn",
			position = Vector3(0, 0, 3),
			rotation = Rotation(0, 70, 0)
		},
		wpn_prj_hur = {
			grip = "grip_wpn",
			position = Vector3(0, 0, 3),
			rotation = Rotation(180, 110, -40)
		}
	}
	self.locked = {
		melee_weapons = {
			weapon = true,
			road = true
		},
		weapons = {
			r93 = true,
			model70 = true,
			par = true,
			long = true,
			flamethrower_mk2 = true,
			msr = true,
			frankish = true,
			mosin = true,
			contraband = true,
			wa2000 = true,
			tti = true,
			siltstone = true,
			arblast = true,
			m134 = true,
			rpk = true,
			saw = true,
			mg42 = true,
			winchester1874 = true,
			ray = true,
			hunter = true,
			rpg7 = true,
			m32 = true,
			m249 = true,
			m95 = true,
			saw_secondary = true,
			china = true,
			desertfox = true,
			arbiter = true,
			gre_m79 = true,
			plainsrider = true,
			hk21 = true
		},
		skills = {
			rifleman = {
				effect = "less",
				version = "basic"
			},
			shotgun_cqb = {
				effect = "less",
				version = "ace"
			},
			close_by = {
				effect = "none",
				version = "basic"
			},
			overkill = {
				effect = "less",
				version = "ace"
			},
			shock_and_awe = {
				effect = "none",
				version = "basic"
			},
			awareness = {
				effect = "none",
				version = "ace"
			},
			silence_expert = {
				effect = "less",
				version = "basic"
			},
			equilibrium = {
				effect = "none",
				version = "basic"
			},
			running_from_death = {
				effect = "less",
				version = "basic"
			}
		},
		perks = {[4] = {[9] = {effect = "less"}}}
	}
	self.weapon_kick = {
		return_speed = 10,
		kick_speed = 200,
		kick_mul = 1.5,
		max_kick = 20
	}
	self.weapon_assist = {
		weapons = {
			rpk = {position = Vector3(0, 30, -2)},
			mosin = {
				grip = "idle_wpn",
				position = Vector3(0, 40, 0)
			},
			polymer = {position = Vector3(0, 27, -5)},
			m134 = {points = {
				{position = Vector3(0, 0, 0)},
				{position = Vector3(14, 0, 0)}
			}},
			aug = {position = Vector3(0, 15, -4)},
			tecci = {position = Vector3(0, 24, 0)},
			l85a2 = {position = Vector3(0, 19, -4)},
			mp9 = {position = Vector3(0, 15, -5)},
			rota = {position = Vector3(0, 15, -2)},
			rpg7 = {position = Vector3(0, -15, -2)},
			amcar = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 3)
			},
			spas12 = {
				grip = "idle_wpn",
				position = Vector3(-1, 35, 0)
			},
			contraband = {
				grip = "idle_wpn",
				position = Vector3(-1, 30, 0)
			},
			famas = {
				grip = "idle_wpn",
				position = Vector3(-1, 15, 0)
			},
			m1928 = {position = Vector3(0, 26, 0)},
			r93 = {
				grip = "idle_wpn",
				position = Vector3(-1, 26, 0)
			},
			wa2000 = {
				grip = "idle_wpn",
				position = Vector3(-1, 35, 0)
			},
			siltstone = {
				grip = "idle_wpn",
				position = Vector3(-1, 32, 2)
			},
			aa12 = {
				grip = "idle_wpn",
				position = Vector3(-1, 25, 3)
			},
			hk21 = {position = Vector3(-5, 38, 4)},
			gre_m79 = {
				grip = "idle_wpn",
				position = Vector3(-1, 20, -2)
			},
			saw_secondary = {points = {
				{position = Vector3(-10, 25, 6)},
				{position = Vector3(8, 32, 8)}
			}},
			saw = {points = {
				{position = Vector3(-10, 25, 6)},
				{position = Vector3(8, 32, 8)}
			}},
			new_m4 = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 3)
			},
			striker = {position = Vector3(0, 28, 0)},
			mg42 = {
				grip = "idle_wpn",
				position = Vector3(-2, 35, 4)
			},
			m95 = {
				grip = "idle_wpn",
				position = Vector3(-2, 20, 4)
			},
			m32 = {position = Vector3(0, 37, -2)},
			mp7 = {position = Vector3(0, 15, -2)},
			g3 = {
				grip = "idle_wpn",
				position = Vector3(-2, 30, 2)
			},
			m16 = {
				grip = "idle_wpn",
				position = Vector3(-2, 32, 4)
			},
			new_m14 = {
				grip = "idle_wpn",
				position = Vector3(-2, 32, 4)
			},
			boot = {
				grip = "idle_wpn",
				position = Vector3(-2, 28, 2)
			},
			arblast = {
				grip = "idle_wpn",
				position = Vector3(-2, 32, 0)
			},
			uzi = {position = Vector3(0, 15, -2)},
			sub2000 = {
				grip = "idle_wpn",
				position = Vector3(-2, 28, 2)
			},
			sterling = {position = Vector3(-10, 10, 6)},
			schakal = {position = Vector3(0, 23, -2)},
			ksg = {position = Vector3(0, 22, -2)},
			cobray = {position = Vector3(0, 15, -4)},
			akm_gold = {
				grip = "idle_wpn",
				position = Vector3(-2, 32, 4)
			},
			g36 = {
				grip = "idle_wpn",
				position = Vector3(-2, 24, 2)
			},
			flint = {
				grip = "idle_wpn",
				position = Vector3(-2, 24, 2)
			},
			m37 = {
				grip = "idle_wpn",
				position = Vector3(-2, 40, 0)
			},
			arbiter = {
				grip = "idle_wpn",
				position = Vector3(-2, 20, 4)
			},
			saiga = {
				grip = "idle_wpn",
				position = Vector3(-2, 32, 4)
			},
			vhs = {
				grip = "idle_wpn",
				position = Vector3(-2, 18, 2)
			},
			desertfox = {
				grip = "idle_wpn",
				position = Vector3(-2, 24, 4)
			},
			ak74 = {
				grip = "idle_wpn",
				position = Vector3(0, 32, 4)
			},
			akm = {
				grip = "idle_wpn",
				position = Vector3(0, 33, 4)
			},
			olympic = {
				grip = "idle_wpn",
				position = Vector3(0, 22, 4)
			},
			m45 = {position = Vector3(0, 23, -3)},
			p90 = {position = Vector3(0, 10, -5)},
			scar = {
				grip = "idle_wpn",
				position = Vector3(-1, 27, 3)
			},
			sr2 = {position = Vector3(0, 15, 2)},
			s552 = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 0)
			},
			b682 = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 0)
			},
			new_mp5 = {
				grip = "idle_wpn",
				position = Vector3(-2, 20, 4)
			},
			tti = {
				grip = "idle_wpn",
				position = Vector3(-2, 27, 2)
			},
			ak5 = {
				grip = "idle_wpn",
				position = Vector3(-2, 30, 4)
			},
			fal = {
				grip = "idle_wpn",
				position = Vector3(-2, 30, 4)
			},
			galil = {
				grip = "idle_wpn",
				position = Vector3(-2, 27, 2)
			},
			vhs = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 0)
			},
			ching = {
				grip = "idle_wpn",
				position = Vector3(-2, 35, 4)
			},
			asval = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 1)
			},
			r870 = {
				grip = "idle_wpn",
				position = Vector3(-2, 40, 0)
			},
			huntsman = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 2)
			},
			benelli = {
				grip = "idle_wpn",
				position = Vector3(-2, 32, 2)
			},
			serbu = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 0)
			},
			basset = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 0)
			},
			akmsu = {
				grip = "idle_wpn",
				position = Vector3(-2, 27, 3)
			},
			hajk = {position = Vector3(0, 25, -1)},
			coal = {
				grip = "idle_wpn",
				position = Vector3(-2, 25, 0)
			},
			erma = {position = Vector3(0, 30, -4)}
		},
		limits = {
			max = 40,
			min = 5
		}
	}
	self.reload_buff = 0.2
	self.reload_speed_mul = 1.2
	self.reload_timelines = {
		default_keys = {
			pos = Vector3(),
			rot = Rotation()
		},
		glock_17 = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		glock_18c = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		deagle = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -3, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -3, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -1.6, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -1.6, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		colt_1911 = {
			start = {
				{
					time = 0,
					sound = "wp_usp_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -4, -12)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_usp_clip_out",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -12)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -12)
				},
				{
					time = 0.6,
					sound = "wp_usp_mantel_back",
					pos = Vector3()
				}
			}
		},
		b92fs = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		new_raging_bull = {
			start = {
				{
					time = 0,
					anims = {{
						anim_group = "reload",
						to = 0.7,
						from = 0.2,
						part = "upper_reciever"
					}}
				},
				{
					time = 0,
					sound = "wp_rbull_drum_open"
				},
				{
					time = 0.9,
					sound = "wp_rbull_shells_out"
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_rbull_shells_in"
				},
				{
					time = 0.5,
					sound = "wp_rbull_drum_close",
					pos = Vector3()
				}
			}
		},
		usp = {
			start = {
				{
					time = 0,
					sound = "wp_usp_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_usp_clip_out",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.6,
					sound = "wp_usp_mantel_back",
					pos = Vector3()
				}
			}
		},
		g22c = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		ppk = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2.5, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2.5, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		p226 = {
			start = {
				{
					time = 0,
					sound = "wp_usp_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_usp_clip_out",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2.5, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2.5, -10)
				},
				{
					time = 0.6,
					sound = "wp_usp_mantel_back",
					pos = Vector3()
				}
			}
		},
		g26 = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -3, -10)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		c96 = {
			start = {
				{
					time = 0,
					sound = "wp_c96_mantel_back"
				},
				{time = 0.05}
			},
			finish = {
				{
					time = 0,
					sound = "wp_c96_mantel_back",
					anims = {{
						anim_group = "reload",
						to = 2.7,
						from = 2.6,
						part = "magazine"
					}}
				},
				{
					time = 0,
					sound = "wp_c96_second_slide"
				},
				{
					time = 0.5,
					sound = "wp_c96_release"
				},
				{
					time = 0.99,
					anims = {{
						anim_group = "reload",
						to = 0,
						part = "magazine"
					}}
				}
			}
		},
		hs2000 = {
			start = {
				{
					time = 0,
					sound = "wp_usp_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_usp_clip_out",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.6,
					sound = "wp_usp_mantel_back",
					pos = Vector3()
				}
			}
		},
		peacemaker = {
			start = {
				{
					time = 0,
					sound = "wp_pmkr45_cylinder_click_02",
					anims = {{
						anim_group = "reload",
						from = 2.7
					}}
				},
				{
					time = 0.5,
					sound = "wp_pmkr45_shell_land"
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_pmkr45_load_bullet"
				},
				{
					time = 0.5,
					sound = "wp_foley_generic_lever_release",
					pos = Vector3()
				}
			}
		},
		mateba = {
			start = {
				{
					time = 0,
					sound = "wp_mateba_open_barrel",
					anims = {{
						anim_group = "reload",
						to = 0.7,
						from = 0.3,
						part = "magazine"
					}}
				},
				{
					time = 0.15,
					visible = false,
					sound = "wp_mateba_empty_barrel",
					pos = Vector3()
				}
			},
			finish = {
				{
					visible = true,
					time = 0,
					sound = "wp_mateba_put_in_bullets",
					pos = Vector3(),
					anims = {{
						anim_group = "reload",
						to = 3.535,
						from = 3.2,
						part = "magazine"
					}}
				},
				{
					time = 0.99,
					sound = "wp_mateba_close_barrel",
					pos = Vector3(),
					anims = {{
						anim_group = "reload",
						to = 4,
						from = 4,
						part = "magazine"
					}}
				}
			}
		},
		sparrow = {
			start = {
				{
					time = 0,
					sound = "wp_pmkr45_open_latch"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_pmkr45_load_bullet",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.6,
					sound = "wp_pmkr45_close_latch",
					pos = Vector3()
				}
			}
		},
		pl14 = {
			start = {
				{
					time = 0,
					sound = "wp_sparrow_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_sparrow_mag_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.6,
					sound = "wp_sparrow_cock",
					pos = Vector3()
				}
			}
		},
		packrat = {
			start = {
				{
					time = 0,
					sound = "wp_packrat_mag_throw"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -6, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_packrat_mag_in",
					visible = true,
					pos = Vector3(0, -6, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2.5, -7)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2.5, -7)
				},
				{
					time = 0.6,
					sound = "wp_packrat_slide_release",
					pos = Vector3()
				}
			}
		},
		lemming = {
			start = {
				{
					time = 0,
					sound = "wp_lemming_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_lemming_mag_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.6,
					sound = "wp_lemming_mantle_forward",
					pos = Vector3()
				}
			}
		},
		chinchilla = {
			start = {
				{
					time = 0,
					sound = "wp_chinchilla_cylinder_out",
					anims = {{
						anim_group = "reload",
						to = 0.5
					}}
				},
				{
					time = 0.02,
					sound = "wp_chinchilla_eject_shells"
				},
				{
					time = 0.15,
					pos = Vector3(),
					rot = Rotation()
				},
				{
					time = 0.17,
					pos = Vector3(0, -5, 0),
					rot = Rotation(0, 0, 0)
				},
				{
					time = 0.25,
					visible = false,
					pos = Vector3(-20, -20, 0),
					rot = Rotation(-160, 0, 0)
				},
				{
					time = 0.26,
					pos = Vector3(0, -20, 0),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_chinchilla_insert",
					visible = true,
					pos = Vector3(0, -20, 0)
				},
				{
					time = 0.5,
					sound = "wp_chinchilla_cylinder_in",
					pos = Vector3(),
					anims = {{
						anim_group = "reload",
						from = 2.7
					}}
				}
			}
		},
		breech = {
			start = {
				{
					time = 0,
					sound = "wp_breech_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -13, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_breech_clip_slide_in",
					visible = true,
					pos = Vector3(0, -13, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -6, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -6, -10)
				},
				{
					time = 0.6,
					sound = "wp_breech_lock_release",
					pos = Vector3()
				}
			}
		},
		shrew = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		mp9 = {
			start = {
				{
					time = 0,
					sound = "wp_mac10_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mac10_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_mac10_lever_release",
					pos = Vector3()
				}
			}
		},
		olympic = {
			start = {
				{
					time = 0,
					sound = "wp_m4_clip_grab_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m4_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m4_lever_release",
					pos = Vector3()
				}
			}
		},
		akmsu = {
			start = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_ak47_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		p90 = {
			start = {
				{
					time = 0,
					sound = "wp_p90_clip_slide_out"
				},
				{
					time = 0.01,
					pos = Vector3(0, -1, 2),
					rot = Rotation(0, -5, 0)
				},
				{
					time = 0.03,
					pos = Vector3(0, -1.2, 2.2),
					rot = Rotation(0, -5, 0)
				},
				{
					time = 0.04,
					pos = Vector3(0, -15, 4),
					rot = Rotation(0, 0, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(10, -15, 4),
					rot = Rotation(1, -4, -4)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_p90_clip_slide_in",
					visible = true,
					pos = Vector3(0, -15, 4),
					rot = Rotation(0, 0, 0)
				},
				{
					time = 0.01,
					pos = Vector3(0, -1.2, 2.2),
					rot = Rotation(0, -5, 0)
				},
				{
					time = 0.45,
					pos = Vector3(0, -1, 2),
					rot = Rotation(0, -5, 0)
				},
				{
					time = 0.5,
					sound = "wp_p90_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		new_mp5 = {
			start = {
				{
					time = 0,
					sound = "wp_mp5_clip_grab"
				},
				{
					time = 0.02,
					pos = Vector3(0, 2, -4),
					rot = Rotation(0, 20, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 2, -20),
					rot = Rotation(0, 10, 0)
				},
				{
					time = 0.051,
					pos = Vector3(0, 2, -10),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mp5_clip_slide_in",
					visible = true,
					pos = Vector3(0, 2, -10),
					rot = Rotation()
				},
				{
					time = 0.04,
					pos = Vector3(0, 2, -4),
					rot = Rotation()
				},
				{
					time = 0.045,
					pos = Vector3(0, 2, -4),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_mp5_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		mac10 = {
			start = {
				{
					time = 0,
					sound = "wp_mac10_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mac10_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_mac10_lever_release",
					pos = Vector3()
				}
			}
		},
		m45 = {
			start = {
				{
					time = 0,
					sound = "wp_m45_clip_grab_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m45_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m45_lever_release",
					pos = Vector3()
				}
			}
		},
		mp7 = {
			start = {
				{
					time = 0,
					sound = "wp_mp7_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mp7_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.2,
					pos = Vector3(0, 0, -7.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -7)
				},
				{
					time = 0.6,
					sound = "wp_mp7_lever_release",
					pos = Vector3()
				}
			}
		},
		scorpion = {
			start = {
				{
					time = 0,
					sound = "wp_scorpion_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_scorpion_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_scorpion_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		tec9 = {
			start = {
				{
					time = 0,
					sound = "wp_tec9_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_tec9_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_tec9_lever_release",
					pos = Vector3()
				}
			}
		},
		uzi = {
			start = {
				{
					time = 0,
					sound = "wp_uzi_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_uzi_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_uzi_clip_lever_release",
					pos = Vector3()
				}
			}
		},
		sterling = {
			start = {
				{
					time = 0,
					sound = "wp_sterling_clip_remove"
				},
				{
					time = 0.019,
					pos = Vector3(-3, 4, 0),
					rot = Rotation(0, 0, 0)
				},
				{
					time = 0.02,
					pos = Vector3(-3, 4, 0),
					rot = Rotation(-30, 0, 0)
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(-20, 0, 0),
					rot = Rotation(-60, 0, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_sterling_clip_insert",
					visible = true,
					pos = Vector3(-10, 0, 0),
					rot = Rotation()
				},
				{
					time = 0.1,
					pos = Vector3(-5, 0, 0),
					rot = Rotation(-30, 0, 0)
				},
				{
					time = 0.56,
					pos = Vector3(-5, 0, 0),
					rot = Rotation(-30, 0, 0)
				},
				{
					time = 0.6,
					sound = "wp_sterling_lever_pull",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		m1928 = {
			start = {
				{
					time = 0,
					sound = "wp_m1928_mag_empty_out"
				},
				{
					time = 0.01,
					pos = Vector3(-4, 0, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(-8, 0, -10)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m1928_mag_slide_in",
					visible = true,
					pos = Vector3(-8, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(-4, 0, -0.5)
				},
				{
					time = 0.56,
					pos = Vector3(-4, 0, -0.1)
				},
				{
					time = 0.6,
					sound = "wp_m1928_lever_release",
					pos = Vector3()
				}
			}
		},
		cobray = {
			start = {
				{
					time = 0,
					sound = "wp_cobray_mag_slipping"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_cobray_mag_slap",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_cobray_lever_release",
					pos = Vector3()
				}
			}
		},
		polymer = {
			start = {
				{
					time = 0,
					sound = "wp_polymer_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_polymer_mag_in",
					visible = true,
					pos = Vector3(0, -7, -15)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3.5, -11)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3.5, -10)
				},
				{
					time = 0.6,
					sound = "wp_polymer_button_press",
					pos = Vector3()
				}
			}
		},
		baka = {
			start = {
				{
					time = 0,
					sound = "wp_baka_mag_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_baka_mag_slide_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_baka_lever_release",
					pos = Vector3()
				}
			}
		},
		sr2 = {
			start = {
				{
					time = 0,
					sound = "wp_sr2_pull_out_mag"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_sr2_put_in_mag",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.5,
					sound = "wp_sr2_release_lever",
					pos = Vector3()
				}
			}
		},
		hajk = {
			start = {
				{
					time = 0,
					sound = "hajk_push_mag_release"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "hajk_push_in_mag",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "hajk_release_lever",
					pos = Vector3()
				}
			}
		},
		schakal = {
			start = {
				{
					time = 0,
					sound = "wp_schakal_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_schakal_mag_in",
					visible = true,
					pos = Vector3(0, 2.5, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0.9, -3.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0.9, -3.5)
				},
				{
					time = 0.6,
					sound = "wp_schakal_bolt_slap",
					pos = Vector3()
				}
			}
		},
		coal = {
			start = {
				{
					time = 0,
					sound = "wp_coal_mag_out_back"
				},
				{
					time = 0.001,
					pos = Vector3(0, 0, 0),
					rot = Rotation(0, 5, 0)
				},
				{
					time = 0.025,
					pos = Vector3(0, 0, 0),
					rot = Rotation(0, 6, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -12),
					rot = Rotation(0, 40, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_coal_mag_in_back",
					visible = true,
					pos = Vector3(0, 0, -12),
					rot = Rotation(0, 40, 0)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, 0),
					rot = Rotation(0, 6, 0)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, 0),
					rot = Rotation(0, 5, 0)
				},
				{
					time = 0.6,
					sound = "wp_coal_release_lever",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		erma = {
			start = {
				{
					time = 0,
					sound = "wp_erma_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_erma_mag_in",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -3.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -3.5)
				},
				{
					time = 0.6,
					sound = "wp_erma_slide_release",
					pos = Vector3()
				}
			}
		},
		serbu = {
			start = {
				{
					time = 0,
					sound = "wp_polymer_mag_out"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_polymer_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_polymer_button_press",
					pos = Vector3()
				}
			}
		},
		judge = {
			start = {
				{
					time = 0,
					sound = "wp_rbull_drum_open"
				},
				{
					time = 0.02,
					sound = "wp_rbull_shells_out"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_rbull_shells_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_rbull_drum_close",
					pos = Vector3()
				}
			}
		},
		striker = {
			start = {
				{
					time = 0,
					sound = "wp_reinbeck_reload_cock"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_reinbeck_shell_insert",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_reinbeck_reload_cock",
					pos = Vector3()
				}
			}
		},
		m37 = {
			start = {
				{
					visible = false,
					time = 0,
					sound = "wp_m37_reload_enter",
					rot = Rotation()
				},
				{
					time = 0.03,
					pos = Vector3(0, -10, -20),
					rot = Rotation(0, 10, 0)
				}
			},
			finish = {
				{
					time = 0,
					anims = {{
						anim_group = "reload_exit",
						to = 0.7,
						from = 0.2,
						part = "foregrip"
					}}
				},
				{
					time = 0,
					sound = "wp_m37_insert_shell",
					visible = true,
					pos = Vector3(0, -10, -20),
					rot = Rotation(0, 10, 0)
				},
				{
					time = 0.1,
					pos = Vector3(0, -5, -3),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -1),
					rot = Rotation(0, 5, 0)
				},
				{
					time = 0.6,
					sound = "wp_m37_reload_exit_push_handle",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		rota = {
			start = {
				{
					time = 0,
					sound = "wp_rota_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_rota_slide_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4),
					rot = Rotation(0, 10, 60)
				},
				{
					time = 0.8,
					pos = Vector3(0, 0, -3),
					rot = Rotation(0, 10, 60)
				},
				{
					time = 0.99,
					sound = "wp_rota_rotate_mag",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		basset = {
			start = {
				{
					time = 0,
					sound = "basset_mag_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "basset_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "basset_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		rpg7 = {
			start = {
				{
					time = 0,
					visible = false
				},
				{
					time = 0.03,
					pos = Vector3(0, 80, -10),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_rpg_grenade_slide_01",
					visible = true,
					pos = Vector3(0, 80, 0),
					rot = Rotation()
				},
				{
					time = 0.11,
					pos = Vector3(0, 5, 0),
					rot = Rotation(0, 0, 60)
				},
				{
					time = 0.7,
					pos = Vector3(0, 5, 0),
					rot = Rotation(0, 0, 40)
				},
				{
					time = 0.99,
					sound = "wp_rpg_safety_click_01",
					pos = Vector3(0, 0, 0.1),
					rot = Rotation()
				}
			}
		},
		hunter = {
			start = {{
				time = 0,
				sound = "wp_dragon_lever_pull",
				anims = {{
					anim_group = "reload",
					to = 0.5
				}}
			}},
			finish = {
				{
					time = 0,
					sound = "wp_dragon_insert_arrow",
					visible = true,
					pos = Vector3(0, -20, 0)
				},
				{
					time = 0.5,
					sound = "wp_dragon_lever_release",
					pos = Vector3(),
					anims = {{
						anim_group = "reload",
						from = 2.7
					}}
				}
			}
		},
		china = {
			start = {
				{
					time = 0,
					visible = false
				},
				{
					time = 0.03,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_china_push_in_shell",
					visible = true,
					pos = Vector3(0, -10, -20),
					rot = Rotation(0, 0, -10)
				},
				{
					time = 0.3,
					sound = "wp_china_push_in_shell",
					visible = true,
					pos = Vector3(0, -10, -8),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.8,
					sound = "wp_china_push_in_shell",
					visible = true,
					pos = Vector3(0, -8, -5),
					rot = Rotation(0, 20, 0)
				},
				{
					time = 0.9,
					sound = "wp_china_push_in_shell",
					visible = true,
					pos = Vector3(0, -7, -2),
					rot = Rotation(0, 20, 0)
				},
				{
					time = 0.99,
					sound = "wp_china_push_handle",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		arbiter = {
			start = {
				{
					time = 0,
					visible = false
				},
				{
					time = 0.03,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "arbiter_mag_in",
					visible = true,
					pos = Vector3(0, -60, 0)
				},
				{
					time = 0.5,
					sound = "arbiter_release_lever",
					pos = Vector3()
				}
			}
		},
		ray = {
			start = {
				{
					time = 0,
					visible = false
				},
				{
					time = 0.03,
					pos = Vector3(0, -40, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ray_push_down_01",
					visible = true,
					pos = Vector3(0, -40, 0)
				},
				{
					time = 0.5,
					sound = "wp_ray_hit",
					pos = Vector3()
				}
			}
		},
		new_m4 = {
			start = {
				{
					time = 0,
					sound = "wp_m4_clip_grab_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m4_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m4_lever_release",
					pos = Vector3()
				}
			}
		},
		amcar = {
			start = {
				{
					time = 0,
					sound = "wp_m4_clip_grab_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m4_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m4_lever_release",
					pos = Vector3()
				}
			}
		},
		m16 = {
			start = {
				{
					time = 0,
					sound = "wp_m16_clip_grab_throw"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m16_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m16_lever_release",
					pos = Vector3()
				}
			}
		},
		ak74 = {
			start = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_ak47_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		akm = {
			start = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_ak47_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		akm_gold = {
			start = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_ak47_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		ak5 = {
			start = {
				{
					time = 0,
					sound = "wp_m4_clip_grab_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m4_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m4_lever_release",
					pos = Vector3()
				}
			}
		},
		aug = {
			start = {
				{
					time = 0,
					sound = "wp_aug_clip_grab_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_aug_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_aug_lever_release",
					pos = Vector3()
				}
			}
		},
		g36 = {
			start = {
				{
					time = 0,
					sound = "wp_g36_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g36_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_g36_clip_in_hit",
					pos = Vector3()
				}
			}
		},
		new_m14 = {
			start = {
				{
					time = 0,
					sound = "wp_m14_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m14_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m14_lever_release",
					pos = Vector3()
				}
			}
		},
		s552 = {
			start = {
				{
					time = 0,
					sound = "wp_sig553_clip_grab"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_sig553_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_sig553_lever_punch",
					pos = Vector3()
				}
			}
		},
		scar = {
			start = {
				{
					time = 0,
					sound = "wp_scar_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_scar_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_scar_push_release",
					pos = Vector3()
				}
			}
		},
		fal = {
			start = {
				{
					time = 0,
					sound = "wp_fn_fal_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_fn_fal_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_fn_fal_lever_release",
					pos = Vector3()
				}
			}
		},
		g3 = {
			start = {
				{
					time = 0,
					sound = "wp_g3_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g3_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_g3_lever_release",
					pos = Vector3()
				}
			}
		},
		galil = {
			start = {
				{
					time = 0,
					sound = "wp_galil_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_galil_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_galil_lever_release",
					pos = Vector3()
				}
			}
		},
		famas = {
			start = {
				{
					time = 0,
					sound = "wp_famas_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_famas_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_famas_lever_release",
					pos = Vector3()
				}
			}
		},
		l85a2 = {
			start = {
				{
					time = 0,
					sound = "wp_l85_mag_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_l85_mag_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_l85_lever_release",
					pos = Vector3()
				}
			}
		},
		vhs = {
			start = {
				{
					time = 0,
					sound = "wp_vhs_mag_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_vhs_mag_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_vhs_lever_release",
					pos = Vector3()
				}
			}
		},
		asval = {
			start = {
				{
					time = 0,
					sound = "asval_mag_click_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "asval_mag_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "asval_release_lever",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		sub2000 = {
			start = {
				{
					time = 0,
					sound = "sub2k_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "sub2k_mag_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -1.5, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, -1.5, -4.5)
				},
				{
					time = 0.6,
					sound = "sub2k_release_lever",
					pos = Vector3()
				}
			}
		},
		tecci = {
			start = {
				{
					time = 0,
					sound = "wp_tecci_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_tecci_mag_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_tecci_bolt_release",
					pos = Vector3()
				}
			}
		},
		contraband = {
			start = {
				{
					time = 0,
					sound = "contraband_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "contraband_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "contraband_bolt_release",
					pos = Vector3()
				}
			}
		},
		contraband_m203 = {
			start = {
				{
					time = 0,
					sound = "contraband_grenade_pull_handle"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "contraband_grenade_shell_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "contraband_grenade_push_handle",
					pos = Vector3()
				}
			}
		},
		flint = {
			start = {
				{
					time = 0,
					sound = "wp_flint_mag_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_flint_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_flint_cock_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		ching = {
			start = {
				{
					visible = false,
					time = 0,
					sound = "ching_bolt_back"
				},
				{
					time = 0.05,
					pos = Vector3(0, 0, 10),
					rot = Rotation(0, 10, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "ching_clip_in",
					visible = true,
					pos = Vector3(0, 0, 10),
					rot = Rotation(0, 10, 0)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, 2),
					rot = Rotation(0, 5, 0)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, 2)
				},
				{
					time = 0.6,
					sound = "ching_bolt_forward",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		jowi = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -3, -10)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2, -7)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		x_1911 = {
			start = {
				{
					time = 0,
					sound = "wp_usp_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -4, -12)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_usp_clip_out",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -12)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -12)
				},
				{
					time = 0.6,
					sound = "wp_usp_mantel_back",
					pos = Vector3()
				}
			}
		},
		x_b92fs = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		x_deagle = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -3, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -3, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -1.6, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -1.6, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		x_g22c = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		x_g17 = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		x_usp = {
			start = {
				{
					time = 0,
					sound = "wp_usp_clip_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -5, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_usp_clip_out",
					visible = true,
					pos = Vector3(0, -5, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -3, -10)
				},
				{
					time = 0.6,
					sound = "wp_usp_mantel_back",
					pos = Vector3()
				}
			}
		},
		x_sr2 = {
			start = {
				{
					time = 0,
					sound = "wp_sr2_pull_out_mag"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_sr2_put_in_mag",
					visible = true,
					pos = Vector3(0, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.5,
					sound = "wp_sr2_release_lever",
					pos = Vector3()
				}
			}
		},
		x_mp5 = {
			start = {
				{
					time = 0,
					sound = "wp_mp5_clip_grab"
				},
				{
					time = 0.02,
					pos = Vector3(0, 2, -4),
					rot = Rotation(0, 20, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 2, -20),
					rot = Rotation(0, 10, 0)
				},
				{
					time = 0.051,
					pos = Vector3(0, 2, -10),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mp5_clip_slide_in",
					visible = true,
					pos = Vector3(0, 2, -10),
					rot = Rotation()
				},
				{
					time = 0.04,
					pos = Vector3(0, 2, -4),
					rot = Rotation()
				},
				{
					time = 0.045,
					pos = Vector3(0, 2, -4),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_mp5_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		x_akmsu = {
			start = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_ak47_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		x_packrat = {
			start = {
				{
					time = 0,
					sound = "wp_packrat_mag_throw"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -6, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_packrat_mag_in",
					visible = true,
					pos = Vector3(0, -6, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -2.5, -7)
				},
				{
					time = 0.56,
					pos = Vector3(0, -2.5, -7)
				},
				{
					time = 0.6,
					sound = "wp_packrat_slide_release",
					pos = Vector3()
				}
			}
		},
		x_chinchilla = {
			start = {
				{
					time = 0,
					sound = "wp_chinchilla_cylinder_out",
					anims = {{
						anim_group = "reload",
						to = 0.5
					}}
				},
				{
					time = 0.02,
					sound = "wp_chinchilla_eject_shells"
				},
				{
					time = 0.15,
					pos = Vector3(),
					rot = Rotation()
				},
				{
					time = 0.17,
					pos = Vector3(0, -5, 0),
					rot = Rotation(0, 0, 0)
				},
				{
					time = 0.25,
					visible = false,
					pos = Vector3(-20, -20, 0),
					rot = Rotation(-160, 0, 0)
				},
				{
					time = 0.26,
					pos = Vector3(0, -20, 0),
					rot = Rotation()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_chinchilla_insert",
					visible = true,
					pos = Vector3(0, -20, 0)
				},
				{
					time = 0.5,
					sound = "wp_chinchilla_cylinder_in",
					pos = Vector3(),
					anims = {{
						anim_group = "reload",
						from = 2.7
					}}
				}
			}
		},
		x_shrew = {
			start = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, -7, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_g17_clip_slide_in",
					visible = true,
					pos = Vector3(0, -7, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.56,
					pos = Vector3(0, -4, -10)
				},
				{
					time = 0.6,
					sound = "wp_g17_lever_release",
					pos = Vector3()
				}
			}
		},
		x_basset = {
			start = {
				{
					time = 0,
					sound = "basset_mag_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "basset_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "basset_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		r870 = {
			start = {
				{
					time = 0,
					sound = "wp_famas_clip_out"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_famas_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_famas_lever_release",
					pos = Vector3()
				}
			}
		},
		saiga = {
			start = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_ak47_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_ak47_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		huntsman = {
			start = {
				{
					time = 0,
					sound = "wp_huntsman_barrel_open"
				},
				{
					time = 0.02,
					sound = "wp_huntsman_shell_out"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_huntsman_shell_insert",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.4,
					sound = "wp_huntsman_barrel_close"
				},
				{
					time = 0.5,
					sound = "wp_huntsman_lock_click",
					pos = Vector3()
				}
			}
		},
		benelli = {
			start = {
				{
					time = 0,
					sound = "wp_reinbeck_reload_cock"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_reinbeck_shell_insert",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_benelli_lever_release",
					pos = Vector3()
				}
			}
		},
		ksg = {
			start = {
				{
					time = 0,
					sound = "wp_reinbeck_reload_cock"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_reinbeck_shell_insert",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_benelli_lever_release",
					pos = Vector3()
				}
			}
		},
		spas12 = {
			start = {
				{
					time = 0,
					sound = "wp_reinbeck_reload_cock"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_reinbeck_shell_insert",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_benelli_lever_release",
					pos = Vector3()
				}
			}
		},
		b682 = {
			start = {{
				time = 0,
				sound = "wp_b682_barrel_open_01",
				anims = {{
					anim_group = "reload",
					to = 1,
					from = 0.3,
					part = "barrel"
				}}
			}},
			finish = {
				{
					time = 0,
					sound = "wp_b682_load_shell_01",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_b682_barrel_close_01",
					pos = Vector3()
				}
			}
		},
		aa12 = {
			start = {
				{
					time = 0,
					sound = "wp_aa12_clip_out"
				},
				{
					time = 0.01,
					pos = Vector3(0, 0.1, -4)
				},
				{
					time = 0.06,
					pos = Vector3(0, 0.1, -4)
				},
				{
					time = 0.1,
					visible = false,
					pos = Vector3(0, 2, -30)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_aa12_clip_in",
					visible = true,
					pos = Vector3(0, 2, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0.1, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0.1, -4.5)
				},
				{
					time = 0.6,
					sound = "wp_aa12_lever_pull",
					pos = Vector3()
				}
			}
		},
		boot = {
			custom_mag_unit = "units/pd2_dlc_wild/weapons/wpn_fps_sho_boot_pts/wpn_fps_sho_boot_m_standard",
			start = {
				{
					time = 0,
					sound = "boot_reload_enter"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "boot_push_in_shell",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "boot_reload_empty_push_handle",
					pos = Vector3()
				}
			}
		},
		hk21 = {
			start = {
				{
					time = 0,
					sound = "wp_hk21_box_out"
				},
				{
					time = 0.01,
					pos = Vector3(-5, 0, -1)
				},
				{
					time = 0.03,
					pos = Vector3(-5, 0, -1)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_hk21_box_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(-5, 0, -1)
				},
				{
					time = 0.56,
					pos = Vector3(-5, 0, -1)
				},
				{
					time = 0.6,
					sound = "wp_hk21_lever_release",
					pos = Vector3()
				}
			}
		},
		m249 = {
			start = {
				{
					time = 0,
					sound = "wp_m249_box_out"
				},
				{
					time = 0.01,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.03,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m249_box_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.56,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.6,
					sound = "wp_m249_lever_release",
					pos = Vector3()
				}
			}
		},
		rpk = {
			start = {
				{
					time = 0,
					sound = "wp_rpk_box_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_rpk_box_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_rpk_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		mg42 = {
			start = {
				{
					time = 0,
					sound = "wp_mg42_cover_open"
				},
				{
					time = 0.01,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.03,
					sound = "wp_mg42_box_remove",
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mg42_box_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.56,
					sound = "wp_mg42_cover_close",
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.6,
					sound = "wp_mg42_lever_release",
					pos = Vector3()
				}
			}
		},
		par = {
			start = {
				{
					time = 0,
					sound = "wp_svinet_mag_out"
				},
				{
					time = 0.01,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.03,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_svinet_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.56,
					pos = Vector3(-2, 0, -2)
				},
				{
					time = 0.6,
					sound = "wp_svinet_lever_release",
					pos = Vector3()
				}
			}
		},
		m95 = {
			start = {
				{
					time = 0,
					sound = "wp_m95_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m95_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m95_lever_release",
					pos = Vector3()
				}
			}
		},
		msr = {
			start = {
				{
					time = 0,
					sound = "wp_msr_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_msr_clip_slide_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_msr_lever_release",
					pos = Vector3()
				}
			}
		},
		r93 = {
			start = {
				{
					time = 0,
					sound = "wp_blazer_clip_slide_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_blazer_clip_punch_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_blazer_lever_release",
					pos = Vector3()
				}
			}
		},
		mosin = {
			start = {
				{
					time = 0,
					sound = "wp_nagant_pull_bolt_back"
				},
				{time = 0.03}
			},
			finish = {
				{
					time = 0,
					sound = "wp_nagant_second_slide"
				},
				{
					time = 0.4,
					sound = "wp_nagant_push_bolt"
				},
				{
					time = 0.5,
					sound = "wp_nagant_push_bolt_side"
				}
			}
		},
		winchester1874 = {
			start = {
				{
					time = 0,
					sound = "wp_m1873_lever_pull"
				},
				{time = 0.03}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m1873_bullet_in"
				},
				{
					time = 0.5,
					sound = "wp_m1873_lever_push"
				}
			}
		},
		wa2000 = {
			start = {
				{
					time = 0,
					sound = "lakner_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "lakner_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "lakner_lever_release",
					pos = Vector3()
				}
			}
		},
		model70 = {
			start = {
				{
					time = 0,
					sound = "wp_m70_mag_out_01"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_m70_mag_in_01",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_m70_pull_lever_01",
					pos = Vector3()
				}
			}
		},
		desertfox = {
			start = {
				{
					time = 0,
					sound = "wp_desertfox_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_desertfox_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_desertfox_push_bolt",
					pos = Vector3()
				}
			}
		},
		tti = {
			start = {
				{
					time = 0,
					sound = "wp_tti_mag_out"
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 5, -20),
					rot = Rotation(0, 30, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_tti_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.1,
					pos = Vector3(0, 0, -4.5)
				},
				{
					time = 0.56,
					pos = Vector3(0, 0, -4)
				},
				{
					time = 0.6,
					sound = "wp_tti_release_lever",
					pos = Vector3()
				}
			}
		},
		siltstone = {
			start = {
				{
					time = 0,
					sound = "wp_siltstone_mag_out"
				},
				{
					time = 0.02,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(0, 10, -20),
					rot = Rotation(0, 60, 0)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_siltstone_mag_in",
					visible = true,
					pos = Vector3(0, 0, -20),
					rot = Rotation()
				},
				{
					time = 0.3,
					pos = Vector3(0, 4, -1),
					rot = Rotation(0, 30, 0)
				},
				{
					time = 0.5,
					sound = "wp_siltstone_lever_release",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		flamethrower_mk2 = {
			start = {
				{
					time = 0,
					sound = "wp_flamethrower_unlock_tank"
				},
				{
					time = 0.01,
					sound = "wp_flamethrower_pull_out_tank"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, -20, 0),
					rot = Rotation(0, 0, 180)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_flamethrower_push_in_tank",
					visible = true,
					pos = Vector3(0, -20, 0),
					rot = Rotation(0, 0, 180)
				},
				{
					time = 0.5,
					sound = "wp_flamethrower_insert_tank",
					pos = Vector3(),
					rot = Rotation()
				}
			}
		},
		gre_m79 = {
			start = {
				{
					time = 0,
					sound = "wp_gl40_lock_open"
				},
				{
					time = 0.01,
					sound = "wp_gl40_barrel_open"
				},
				{
					time = 0.02,
					sound = "wp_gl40_shell_out"
				},
				{time = 0.03}
			},
			finish = {
				{
					time = 0,
					sound = "wp_gl40_shell_in"
				},
				{
					time = 0.99,
					sound = "wp_gl40_barrel_close",
					pos = Vector3()
				}
			}
		},
		saw = {
			start = {
				{
					time = 0,
					sound = "wp_saw_blade_grab_throw"
				},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, -20)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_saw_blade_load",
					visible = true,
					pos = Vector3(0, 0, -20)
				},
				{
					time = 0.5,
					sound = "wp_saw_blade_spin",
					pos = Vector3()
				}
			}
		},
		m134 = {
			start = {
				{
					time = 0,
					sound = "wp_minigun_belt_out"
				},
				{
					time = 0.001,
					pos = Vector3(4, 0, -1)
				},
				{
					time = 0.03,
					sound = "wp_minigun_box_out",
					pos = Vector3(4, 0, -1)
				},
				{
					time = 0.05,
					visible = false,
					pos = Vector3(20, 0, -10)
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_minigun_box_in",
					visible = true,
					pos = Vector3(20, 0, -10)
				},
				{
					time = 0.1,
					pos = Vector3(4, 0, -1)
				},
				{
					time = 0.88,
					pos = Vector3(4, 0, -1)
				},
				{
					time = 0.9,
					sound = "wp_minigun_belt_in",
					pos = Vector3()
				}
			}
		},
		m32 = {
			start = {
				{
					time = 0,
					sound = "wp_mgl_open"
				},
				{
					time = 0.02,
					sound = "wp_mgl_drag_out_empty_shell"
				},
				{
					time = 0.03,
					pos = Vector3()
				}
			},
			finish = {
				{
					time = 0,
					sound = "wp_mgl_rotate_mag",
					pos = Vector3()
				},
				{
					time = 0.5,
					sound = "wp_mgl_close_mag",
					pos = Vector3()
				}
			}
		},
		plainsrider = {
			start = {
				{time = 0},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, 0)
				}
			},
			finish = {
				{
					time = 0,
					visible = true,
					pos = Vector3(0, 0, 0)
				},
				{
					time = 0.5,
					sound = "wp_bow_new_arrow",
					pos = Vector3()
				}
			}
		},
		arblast = {
			start = {
				{time = 0},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, 0)
				}
			},
			finish = {
				{
					time = 0,
					visible = true,
					pos = Vector3(0, 0, 0)
				},
				{
					time = 0.5,
					sound = "wp_arblast_arrow_click_01",
					pos = Vector3()
				}
			}
		},
		frankish = {
			start = {
				{time = 0},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, 0)
				}
			},
			finish = {
				{
					time = 0,
					visible = true,
					pos = Vector3(0, 0, 0)
				},
				{
					time = 0.5,
					sound = "wp_frankish_new_arrow",
					pos = Vector3()
				}
			}
		},
		long = {
			start = {
				{time = 0},
				{
					time = 0.03,
					visible = false,
					pos = Vector3(0, 0, 0)
				}
			},
			finish = {
				{
					time = 0,
					visible = true,
					pos = Vector3(0, 0, 0)
				},
				{
					time = 0.5,
					sound = "wp_long_new_arrow",
					pos = Vector3()
				}
			}
		}
	}
	self.weapon_sound_overrides = {x_sr2 = {sounds = {
		fire_single = "sr2_fire_single",
		fire = "sr2_fire_single",
		fire_auto = "sr2_fire",
		stop_fire = "sr2_stop"
	}}}
	self.wall_check_delay = 0.2
	self.loading_screens = {loading = {
		loading_root = {
			visible = true,
			position = Vector3(0, 500, 150),
			rotation = Rotation(0, 0, 0),
			children = {loading_spin = {
				visible = true,
				width = 50,
				order = 3,
				position = Vector3(0, 0, 0),
				rotation = Rotation(0, 0, 0),
				texture = Idstring("guis/dlcs/vr/textures/loading/icon_loading")
			}}
		},
		floor = {
			width = 800,
			visible = true,
			order = 2,
			position = Vector3(0, 0, 0),
			rotation = Rotation(0, -90, 0),
			texture = Idstring("guis/dlcs/vr/textures/loading/floor_df")
		},
		roof = {
			width = 1000,
			visible = true,
			order = 2,
			position = Vector3(0, 0, 500),
			rotation = Rotation(0, 90, 0),
			texture = Idstring("guis/dlcs/vr/textures/loading/darkness_df")
		},
		darkness_below = {
			width = 10000,
			visible = true,
			order = 2,
			position = Vector3(0, 0, -10),
			rotation = Rotation(0, -90, 0),
			color = Color(1, 1, 1, 1),
			texture = Idstring("guis/dlcs/vr/textures/loading/darkness_df")
		},
		logo = {
			width = 1400,
			visible = true,
			order = 2,
			position = Vector3(0, 1000, 300),
			rotation = Rotation(0, 0, 0),
			texture = Idstring("guis/dlcs/vr/textures/loading/logotype_df")
		},
		background_pattern = {
			width = 4000,
			visible = true,
			order = 2,
			position = Vector3(0, 2000, 1000),
			rotation = Rotation(0, 0, 0),
			texture = Idstring("guis/dlcs/vr/textures/loading/front_bg_pattern_df")
		}
	}}
	self.mask_offsets = {default = {
		position = Vector3(0, -5, 5),
		rotation = Rotation(180, 135, 0)
	}}
	self.autowarp_length = {
		short = 0.65,
		long = 1
	}
	self.heartbeat_time = 5
	self.driving = {
		muscle = {
			max_angle = 170,
			steering_pos = Vector3(-40, 51, 110),
			middle_pos = Vector3(-40, 44, 94),
			exit_pos = {
				driver = {
					position = Vector3(-70, 35, 75),
					direction = Vector3(-1, 0, 0)
				},
				passenger_back_left = {
					position = Vector3(-70, -55, 75),
					direction = Vector3(-1, 0, 0)
				},
				passenger_back_right = {
					position = Vector3(70, -55, 75),
					direction = Vector3(1, 0, 0)
				},
				passenger_front = {
					position = Vector3(70, 35, 75),
					direction = Vector3(1, 0, 0)
				}
			}
		},
		falcogini = {
			max_angle = 170,
			steering_pos = Vector3(-36, 50, 90),
			middle_pos = Vector3(-36, 45, 72),
			exit_pos = {
				driver = {
					position = Vector3(-69, 18, 66),
					direction = Vector3(-1, 0, 0)
				},
				passenger_front = {
					position = Vector3(69, 18, 66),
					direction = Vector3(1, 0, 0)
				}
			}
		},
		forklift = {
			max_angle = 90,
			steering_pos = Vector3(-9, 43, 150),
			middle_pos = Vector3(-9, 31, 140),
			exit_pos = {
				driver = {
					position = Vector3(-50, 0, 140),
					direction = Vector3(-1, 0, 0)
				},
				passenger_front = {
					position = Vector3(0, -130, 130),
					direction = Vector3(0, 0, -1),
					up = Vector3(0, -1, 0)
				}
			}
		},
		boat_rib_1 = {
			max_angle = 30,
			inverted = true,
			steering_pos = Vector3(-6, -100, 68),
			middle_pos = Vector3(-6, -170, 68),
			steering_dir = Vector3(0, 0, -1),
			steering_up = Vector3(0, 1, 0),
			exit_pos = {
				driver = {
					position = Vector3(-75, -130, 120),
					direction = Vector3(-1, 0, 0)
				},
				passenger_front = {
					position = Vector3(130, 130, 120),
					direction = Vector3(1, 0, 0)
				},
				passenger_back_right = {
					position = Vector3(130, -30, 120),
					direction = Vector3(1, 0, 0)
				},
				passenger_back_left = {
					position = Vector3(-130, 30, 120),
					direction = Vector3(-1, 0, 0)
				}
			}
		},
		bike_2 = {
			max_angle = 20,
			steering_pos = {
				left = Vector3(-38, 28, 105),
				right = Vector3(38, 28, 105)
			},
			exit_pos = {driver = {
				position = Vector3(-70, 0, 120),
				direction = Vector3(-1, 0, 0)
			}}
		},
		box_truck_1 = {
			max_angle = 90,
			steering_pos = Vector3(-48, 250, 165),
			middle_pos = Vector3(-48, 232, 155),
			exit_pos = {
				driver = {
					position = Vector3(-82, 235, 130),
					direction = Vector3(0, 0, -1),
					up = Vector3(0, 1, 0)
				},
				passenger_front = {
					position = Vector3(82, 235, 130),
					direction = Vector3(0, 0, -1),
					up = Vector3(0, 1, 0)
				},
				passenger_back_right = {
					position = Vector3(82, -300, 150),
					direction = Vector3(1, 0, 0)
				},
				passenger_back_left = {
					position = Vector3(-82, -300, 150),
					direction = Vector3(-1, 0, 0)
				}
			}
		}
	}
end

-- Lines: 2996 to 3007
function TweakDataVR:is_locked(category, id, ...)
	local locked = self.locked[category] and self.locked[category][id]

	if type(locked) == "table" then
		local args = {...}

		for _, v in ipairs(args) do
			if not locked[v] then
				return false
			end

			locked = locked[v]
		end
	end

	return locked
end

-- Lines: 3018 to 3029
function TweakDataVR:get_offset_by_id(id)
	if tweak_data.blackmarket.melee_weapons[id] then
		return self:_get_melee_offset_by_id(id)
	elseif tweak_data.weapon[id] then
		return self:_get_weapon_offset_by_id(id)
	elseif tweak_data.blackmarket.masks[id] then
		return self:_get_mask_offsets_by_id(id)
	elseif tweak_data.blackmarket.projectiles[id] then
		return self:_get_throwable_offsets_by_id(id)
	end

	return {}
end


-- Lines: 3032 to 3036
local function combine_offset(offset, new)
	for key, value in pairs(new) do
		offset[key] = offset[key] or value
	end
end


-- Lines: 3038 to 3049
function TweakDataVR:_get_melee_offset_by_id(id)
	local offset = {}
	local tweak = tweak_data.blackmarket.melee_weapons[id]

	if self.melee_offsets.weapons[id] then
		combine_offset(offset, self.melee_offsets.weapons[id])
	end

	if tweak and self.melee_offsets.types[tweak.type] then
		combine_offset(offset, self.melee_offsets.types[tweak.type])
	end

	combine_offset(offset, self.melee_offsets.default)

	return offset
end

-- Lines: 3052 to 3059
function TweakDataVR:_get_weapon_offset_by_id(id)
	local offset = {}

	if self.weapon_offsets.weapons[id] then
		combine_offset(offset, self.weapon_offsets.weapons[id])
	end

	combine_offset(offset, self.weapon_offsets.default)

	return offset
end

-- Lines: 3062 to 3065
function TweakDataVR:_get_mask_offsets_by_id(id)
	local offset = {}

	combine_offset(offset, self.mask_offsets.default)

	return offset
end

-- Lines: 3068 to 3075
function TweakDataVR:_get_throwable_offsets_by_id(id)
	local offset = {}

	if self.throwable_offsets[id] then
		combine_offset(offset, self.throwable_offsets[id])

		offset.grip = self.throwable_offsets[id].grip
	end

	combine_offset(offset, self.throwable_offsets.default)

	return offset
end

