Config = {}

-- Maximum distance at which to interact with stationary instrument objects
Config.MaxInteractDistance = 2.0

-- Interactions with instruments
Config.Instruments = {
	['piano'] = {
		attachTo = {
			models = {
				'p_nbmpiano01x',
				'p_nbxpiano01x',
				'p_piano02x',
				'p_piano03x',
				'sha_man_piano01'
			},
			position = vector3(0.0, -0.77, 0.55),
			rotation = vector3(0.0, 0.0, 0.0)
		},
		inactiveAnimation = {
			dict = 'ai_gestures@instruments@piano@male@normal',
			name = 'piano_base',
			flag = 1
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@piano@male@normal',
			name = 'piano_fast_l_-1_0_+1_r_-1_0_+1_chords_01',
			flag = 1
		}
	},
	['trumpet'] = {
		props = {
			{
				model = 'p_trumpet01x',
				bone = 'PH_L_HAND',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			}
		},
		inactiveAnimation = {
			dict = 'amb_misc@world_human_trumpet@male_a@base',
			name = 'base',
			flag = 25
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@trumpet@standing@140bpm',
			name = 'upbeat_cen_002',
			flag = 25
		}
	},
	['guitar'] = {
		props = {
			{
				model = 'p_guitar01x',
				bone = 'PH_R_HAND', 'XH_R_HAND00',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			}
		},
		inactiveAnimation = {
			dict = 'ai_gestures@instruments@guitar@seated@80bpm',
			name = 'generic_01',
			flag = 25
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@guitar@seated@120bpm',
			name = 'upbeat_picking_fast_chords_rt_0_+1_03',
			flag = 25
		}
	},
	['harp'] = {
		attachTo = {
			models = {
				'p_harp01x'
			},
			position = vector3(0.0, 0.0, 0.0),
			rotation = vector3(0.0, 0.0, 90.0)
		},
		inactiveAnimation = {
			dict = 'ai_gestures@instruments@band_test',
			name = 'p_base',
			flag = 1
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@band_test',
			name = 'p_playing',
			flag = 1
		}
	},
	['harmonica'] = {
		props = {
			{
				model = 'p_harmonica01x',
				bone = 'PH_R_HAND',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			}
		},
		inactiveAnimation = {
			female = {
				dict = 'amb_misc@prop_human_seat_bench@harmonica@resting@female_a@base',
				name = 'base',
				flag = 25
			},
			male = {
				dict = 'amb_misc@prop_human_seat_bench@harmonica@resting@male_a@base',
				name = 'base',
				flag = 25
			},
		},
		activeAnimation = {
			female = {
				dict = 'ai_gestures@instruments@harmonica@seated@female@120bpm',
				name = 'spine_bwd_01',
				flag = 25
			},
			male = {
				dict = 'ai_gestures@instruments@harmonica@seated@120bpm',
				name = 'spine_bwd_01',
				flag = 25
			}
		}
	},
	['concertina'] = {
		props = {
			{
				model = 'p_cs_concertina01x',
				bone = 'PH_R_HAND',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			}
		},
		inactiveAnimation = {
			dict = 'amb_misc@prop_human_seat_bench@concertina@male_a@base',
			name = 'base',
			flag = 25
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@concertina@seated@120bpm',
			name = 'longs_med_01',
			flag = 25
		}
	},
	['banjo'] = {
		props = {
			{
				model = 'p_banjo01x',
				bone = 'PH_R_HAND', 'XH_R_HAND00',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			}
		},
		inactiveAnimation = {
			dict = 'ai_gestures@instruments@banjo@seated@male@normal',
			name = 'banjo_base',
			flag = 25
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@banjo@seated@120bpm',
			name = 'spine_0_hand_0_01',
			flag = 25
		}
	},
	['fiddle'] = {
		props = {
			{
				model = 'p_fiddle01x',
				bone = 'PH_L_HAND',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			},
			{
				model = 'p_bow01x',
				bone = 'PH_R_HAND',
				position = vector3(0.0, 0.0, 0.0),
				rotation = vector3(0.0, 0.0, 0.0)
			}
		},
		inactiveAnimation = {
			dict = 'ai_gestures@instruments@fiddle@standing@female@normal',
			name = 'fiddle_base',
			flag = 25
		},
		activeAnimation = {
			dict = 'ai_gestures@instruments@fiddle@standing@female@normal',
			name = 'fiddle_low_long_shorts_-1_01',
			flag= 25
		}
	}
}
