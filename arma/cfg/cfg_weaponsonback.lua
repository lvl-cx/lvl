local cfg = {}

cfg.weapons = {
    --?Melee's
	{name = 'WEAPON_BROOM', bone = 24818, x=-0.60,y=-0.15,z=0.13, xRot=50.0,yRot=90.0, zRot=2.0, category = 'melee', model = `w_me_broom`},
	{name = 'WEAPON_SLEDGEHAMMER', bone = 24818, x=-0.35,y=-0.10,z=0.13, xRot=190.0,yRot=180.0, zRot=105.0, category = 'melee', model = `w_me_sledgehammer`},
	{name = 'WEAPON_TRAFFICSIGN', bone = 24818, x=-0.45,y=-0.10,z=0.13, xRot=190.0,yRot=180.0, zRot=105.0, category = 'melee', model = `w_me_trafficsign`},
	{name = 'WEAPON_SHOVEL', bone = 24818, x=0.32,y=-0.10,z=0.10, xRot=5.0,yRot=200.0, zRot=80.0, category = 'melee', model = `w_me_shovel`},
	{name = 'WEAPON_GUITAR', bone = 24818, x=0.32,y=-0.15,z=0.13, xRot=0.0,yRot=-90.0, zRot=0.0, category = 'melee', model = `w_me_guitar`},
	{name = 'WEAPON_DILDO', bone = 58271, x=-0.01,y=0.1,z=-0.07, xRot=-35,yRot=0.10, zRot=-100.0, category = 'melee', model = `w_me_dildo`},
	{name = 'WEAPON_CRICKETBAT', bone = 24818, x=0.32,y=-0.15,z=0.13, xRot=55.0,yRot=-90.0, zRot=0.0, category = 'melee', model = `w_me_cricketbat`},
	{name = 'WEAPON_FIREAXE', bone = 24818, x=0.32,y=-0.15,z=0.13, xRot=0.0,yRot=-90.0, zRot=0.0, category = 'melee', model = `w_me_fireaxe`},


    -- --?PD SMGs/Rifles
	{name = 'WEAPON_PDM4A1', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_m4a1`},
	{name = 'WEAPON_AR15', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_ar15`},
	{name = 'WEAPON_MP5', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'smg', model = `w_sb_mp5`},
	{name = 'WEAPON_SIGMCX', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_sigmcx`},
	{name = 'WEAPON_G36', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_g36`},
    {name = 'WEAPON_SPAR17', bone = 24818, x=0.00,y=0.19,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_spar17`},
	{name = 'WEAPON_STING', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'smg', model = `w_sb_sting`},
	{name = 'WEAPON_MK18SOG', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_mk18sog`},
	{name = 'WEAPON_PDTX15', bone = 24818, x=0.00,y=0.22,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_tx15dml`},
	{name = 'WEAPON_NIGHTSTICK', bone = 51826, x=-0.1,y=0.1,z=0.07, xRot=180.0,yRot=140.0, zRot=90.0, category = 'melee', model = `w_me_nightstick`},

    -- --?CIV SMGs/Rifles/Shotguns
	{name = 'WEAPON_EF88', bone = 24818, x=0.05,y=-0.12,z=-0.13, xRot=100.0,yRot=-3.0, zRot=5.0, category = 'assault', model = `w_ar_ef88`},
	{name = 'WEAPON_SPAR16', bone = 24818, x=-0.02,y=-0.12,z=-0.13, xRot=100.0,yRot=-3.0, zRot=5.0, category = 'assault', model = `w_ar_spar16`},
	{name = 'WEAPON_SPAZ12', bone = 24818, x=0.1,y=-0.12,z=-0.13, xRot=100.0,yRot=-3.0, zRot=5.0, category = 'shotgun', model = `w_ar_spaz12`},
	{name = 'WEAPON_RPK16', bone = 24818, x=-0.05,y=-0.12,z=-0.13, xRot=100.0,yRot=-3.0, zRot=5.0, category = 'heavy', model = `w_mg_rpk16`},

    -- --?Mosin/spec snipers
	{name = 'WEAPON_MOSIN', bone = 24818, x=-0.12,y=-0.12,z=-0.13, xRot=100.0,yRot=-3.0, zRot=5.0, category = 'assault', model = `w_ar_mosin`},
	{name = 'WEAPON_MANDO', bone = 24818, x=0.3,y=0.22,z=-0.2, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_mando`},
	{name = 'WEAPON_DILDET', bone = 24818, x=-0.35,y=-0.12,z=-0.13, xRot=100.0,yRot=100.0, zRot=5.0, category = 'assault', model = `w_ar_dildet`},
}

return cfg