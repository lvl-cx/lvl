cfg = {
	Guild_ID = '975490533344559154',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '975490533344559154', 
		['Police'] = '991799285681233930', 
		-- ['NHS'] = '1005632218133180487',
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
		['Commissioner'] = 991804031561379890,
		['Deputy Commissioner'] = 991804033176178748,
		['Assistant Commissioner'] = 991804033377505400,
		['Dep. Asst. Commissioner'] = 991804034723893278,
		['Commander'] = 991804034958774273,
		['Chief Superintendent'] = 991804037357908108,
		['Superintendent'] = 991804075404447764,
		['Chief Inspector'] = 991805761434959982,
		['Inspector'] = 991805761678229564,
		['Sergeant'] = 991815810333036725,
		['Special Constable'] = 991817168465449000,
		['Senior Constable'] = 991815812371464282,
		['PC'] = 991815812312739950,
		['PCSO'] = 991815812967051344,
		['Large Arms Access'] = 991813471475859538,
		['Police Horse Trained'] = 991813474667737088,
		['Drone Trained'] = 1060270118229254235,
		['NPAS'] = 991815823779975168,
		['Trident Officer'] = 991819633097183322,
		['Trident Command'] = 991809551802310767,
		['K9 Trained'] = 991813474906820629,
	}

	-- ['NHS'] = {
	-- 	['NHS Head Chief'] = 1013072143208157234,
	-- 	['NHS Assistant Chief'] = 1013072231695388743,
	-- 	['NHS Deputy Chief'] = 1013072284061270127,
	-- 	['NHS Captain'] = 1017618355047383141,
	-- 	['NHS Specialist'] = 1017618411284615260,
	-- 	['NHS Senior Doctor'] = 1017618467731554364,
	-- 	['NHS Doctor'] = 1017618570940780576,
	-- 	['NHS Junior Doctor'] = 1017618604541362277,
	-- 	['NHS Critical Care Paramedic'] = 1017618670559698995,
	-- 	['NHS Paramedic'] = 1017618728348811306,
	-- 	['NHS Trainee Paramedic'] = 1017618794333614140,
	-- 	['Drone Trained'] = 1022642333696675840,
	-- },

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


cfg.Bot_Token = 'OTg4MTIwODUwNTQ2OTYyNTAy.GcITZ7.dvzSCOOX9do7-jhT3CIQvq3P02xxHmUuWKW7ug'

return cfg