cfg = {
	Guild_ID = '975490533344559154',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '975490533344559154', 
		['Police'] = '1073655663630237848', 
		['NHS'] = '1062753698528382976',
		-- ['HMP'] = '1016844313591812128',
		-- ['LFB'] = '1016858643293024308',
  	},
	RoleList = {},

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1045151481352957952,
		['Staff Manager'] = 975490533394903098,
		['Community Manager'] = 975490533394903097,
		['Head Admin'] = 975490533394903096,
		['Senior Admin'] = 975490533394903094,
		['Admin'] = 975490533394903093,
		['Senior Mod'] = 975490533394903092,
		['Moderator'] = 975490533394903091,
		['Support Team'] = 975490533394903090,
		['Trial Staff'] = 975490533373911099,
		['cardev'] = 975490533373911098,
		['Cinematic'] = 1064073136666071101,
	},

	['Police'] = {
		['Commissioner'] = 1073655663923835022,
		['Deputy Commissioner'] = 1073655663923835021,
		['Assistant Commissioner'] = 1073655663923835020,
		['Dep. Asst. Commissioner'] = 1073655663877689487,
		['Commander'] = 1073655663877689486,
		['Chief Superintendent'] = 1073655663877689481,
		['Superintendent'] = 1073655663877689480,
		['Chief Inspector'] = 1073655663848341625,
		['Inspector'] = 1073655663848341624,
		['Sergeant'] = 1073655663848341622,
		['Special Constable'] = 1073655663848341619,
		['Senior Constable'] = 1073655663848341621,
		['PC'] = 1073655663848341620,
		['PCSO'] = 1073655663848341618,
		['Large Arms Access'] = 1074048877755371530,
		['Police Horse Trained'] = 1074478298047991858,
		['Drone Trained'] = 1074478546791174164,
		['NPAS'] = 1074046939324219502,
		['Trident Officer'] = 991819633097183322,
		['Trident Command'] = 991809551802310767,
		['K9 Trained'] = 991813474906820629,
	},

	['NHS'] = {
		['NHS Head Chief'] = 1062753858419441664,
		['NHS Assistant Chief'] = 1062753858910167072,
		['NHS Deputy Chief'] = 1062753859950362684,
		['NHS Captain'] = 1062753860432699432,
		['NHS Consultant'] = 1062753873682518039,
		['NHS Specialist'] = 1062753874781405184,
		['NHS Senior Doctor'] = 1062753878975729744,
		['NHS Doctor'] = 1062753879877484565,
		['NHS Junior Doctor'] = 1062753880481472602,
		['NHS Critical Care Paramedic'] = 1062753881072869526,
		['NHS Paramedic'] = 1062753887917965372,
		['NHS Trainee Paramedic'] = 1062753888572280882,
		['Drone Trained'] = 1065226113158234134,
		['HEMS'] = 1065228761198493726,
	},

	-- ['HMP'] = {
	-- 	['Governor'] = 1017619823804547113,
	-- 	['Deputy Governor'] = 1017619884177358882,
	-- 	['Divisional Commander'] = 1017619931526877246,
	-- 	['Custodial Supervisor'] = 1017619970349334590,
	-- 	['Custodial Officer'] = 1017620004373544992,
	-- 	['Honourable Guard'] = 1017620044798251148,
	-- 	['Supervising Officer'] = 1017620085654958080,
	-- 	['Principal Officer'] = 1017620118433431653,
	-- 	['Specialist Officer'] = 1017620166990888960,
	-- 	['Senior Officer'] = 1017620204655755317,
	-- 	['Prison Officer'] = 1017620239686582403,
	-- 	['Trainee Prison Officer'] = 1017620274537046086,
	-- },

	-- ['LFB'] = {
	-- 	['Chief Fire Command'] = 1017621455120379944,
	-- 	['Divisional Command'] = 1017621512255197254,
	-- 	['Sector Command'] = 1017621546212261888,
	-- 	['Honourable Firefighter'] = 1017621584850190417,
	-- 	['Leading Firefighter'] = 1017621616416538677,
	-- 	['Specialist Firefighter'] = 1017621659332644865,
	-- 	['Advanced Firefighter'] = 1017621694740959233,
	-- 	['Senior Firefighter'] = 1017621729885036597,
	-- 	['Firefighter'] = 1017621763531751434,
	-- 	['Junior Firefighter'] = 1017621801355976756,
	-- 	['Provisional Firefighter'] = 1017621836089016420,
	-- },
	
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'OTg4MTIwODUwNTQ2OTYyNTAy.GVh8Qn.Utj8WomTHLRDGSJ6vhjF23EbwIOsRwt6mRa1To'

return cfg