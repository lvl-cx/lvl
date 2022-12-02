
local cfg = {}


cfg.groups = {
	["Developer"] = {
        "dev.menu",
        "dev.spawncar",
        "dev.spawnweapon",
        "dev.deletecar",
        "dev.fixcar",
		"dev.givemoney",
		"dev.tp2coords",
	    "dev.getcoords",
		"cardev.menu",
		"chat.announce",
		"admin.addcar",
		"admin.spawnGun",
        "admin.menu",
        "admin.warn",
		"admin.vehmenu",
        "admin.showwarn",
        "admin.ban",
		"admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.summon",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.slap",
        "admin.givemoney",
        "admin.tp2waypoint",
        "admin.tp2coords",
		"admin.removewarn",
		"admin.spawnBmx",
		"admin.idsabovehead",
		"admin.noclip",
		"admin.managecommunitypot",
		"admin.moneymenu",
		"admin.staffblips",
		
			
		"admin.staffAddGroups",
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.licenseAddGroups",
		"admin.donoAddGroups",

		"group.add.vip",
        "group.add.founder",
        "group.add.operationsmanager",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
		"group.add.pov",
        "group.add",

		"group.remove.vip",
        "group.remove.founder",
        "group.remove.operationsmanager",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
		"group.remove.pov",
		"group.remove",
		
		"admin.whitelisted",
		"admin.tickets",
	},
	["Founder"] = {
		
		"admin.menu",
        "admin.warn",
        "admin.showwarn",
        "admin.ban",
		"admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.summon",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.slap",
        "admin.givemoney",
        "admin.tp2waypoint",
        "admin.tp2coords",
		"admin.removewarn",
		"admin.spawnBmx",
		"admin.noclip",
    	"staff.mode",
		"admin.vehmenu",
		"admin.spawnGun",
		"admin.addcar",
		"admin.idsabovehead",
		"admin.smartsigns",
		"admin.staffAddGroups",
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.licenseAddGroups",
		"admin.donoAddGroups",
		"admin.nhsAddGroups",
		"admin.managecommunitypot",
		"admin.moneymenu",
		"admin.staffblips",

		"group.add.vip",
        "group.add.founder",
        "group.add.operationsmanager",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
		"group.add.pov",
        "group.add",

		"group.remove.vip",
        "group.remove.founder",
        "group.remove.operationsmanager",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
		"group.remove.pov",
		"group.remove",
		
		"admin.whitelisted",
		"admin.tickets",
		
		"vehicle.delete",
		"chat.announce",
		"cardev.menu",
	},
	["Staff Manager"] = {
		"dev.menu",
        "dev.spawncar",
        "dev.deletecar",
        "dev.fixcar",
		"dev.tp2coords",
	    "dev.getcoords",
		"admin.vehmenu",
		"admin.special",
		"admin.managecommunitypot",
		"admin.staffblips",
		
		"admin.menu",
        "admin.warn",
        "admin.showwarn",
        "admin.ban",
		"admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.summon",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
		"admin.addcar",
        "admin.screenshot",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
		"admin.removewarn",
		"admin.spawnBmx",
		"admin.noclip",
		"admin.managecommunitypot",
    	"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		"cardev.menu",
		"admin.staffAddGroups",
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.nhsAddGroups",
		"group.add.vip",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
		"group.add.pov",
        "group.add",

		"group.remove.vip",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
		"group.remove.pov",
		"group.remove",
		
		"admin.whitelisted",
		"admin.tickets",
		"chat.announce",
	},
	["Community Manager"] = {
		
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.ban",
		"admin.unban",
		"admin.kick",
		"admin.revive",
		"admin.tp2player",
		"admin.summon",
		"admin.addcar",
		"admin.freeze",
		"admin.getgroups",
		"admin.spectate",
		"admin.screenshot",
		"admin.slap",
		"admin.staffblips",
		"admin.givemoney",
		"admin.tp2waypoint",
		"admin.tp2coords",
		"admin.removewarn",
		"admin.spawnBmx",
		"admin.noclip",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		"admin.staffAddGroups",
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.nhsAddGroups",

        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
		"group.add.pov",
        "group.add",

        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
		"group.remove.pov",
		"group.remove",
		
		"admin.whitelisted",
		"admin.tickets",
		"chat.announce",
	  },
	["Head Admin"] = {
		
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.ban",
		"admin.unban",
		"admin.kick",
		"admin.revive",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.spectate",
		"admin.screenshot",
		"admin.slap",
		"admin.tp2waypoint",
		"admin.tp2coords",
		"admin.removewarn",
		"admin.spawnBmx",
		"admin.noclip",
		"admin.staffblips",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		"admin.staffAddGroups",
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.nhsAddGroups",
		"admin.donoAddGroups",

		
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
		"group.add.pov",
        "group.add",

        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
		"group.remove.pov",
		"group.remove",
		
		
		"admin.whitelisted",
		"admin.tickets",
		"chat.announce",
  },
  ["Senior Admin"] = {
	
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.ban",
		"admin.unban",
		"admin.kick",
		"admin.revive",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.spectate",
		"admin.screenshot",
		"admin.slap",
		"admin.tp2waypoint",
		"admin.tp2coords",
		"admin.removewarn",
		"admin.spawnBmx",
		"admin.noclip",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		
		"admin.whitelisted",
		"admin.tickets",
  },
  ["Admin"] = {
	
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.ban",
		"admin.unban",
		"admin.kick",
		"admin.revive",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.spectate",
		"admin.screenshot",
		"admin.slap",
		"admin.tp2waypoint",
		"admin.tp2coords",
		"admin.noclip",

		"admin.whitelisted",
		"admin.tickets",
		"admin.spawnBmx",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
  },
  ["Senior Mod"] = {
	
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.ban",
		"admin.unban",
		"admin.kick",
		"admin.revive",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.screenshot",
		"admin.spectate",

		"admin.whitelisted",
		"admin.tickets",
		"admin.spawnBmx",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
    },
  ["Moderator"] = {
	
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.ban",
		"admin.kick",
		"admin.revive",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.screenshot",
		"admin.spectate",

		"admin.whitelisted",
		"admin.tickets",
		"admin.spawnBmx",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		
  },
  ["Support Team"] = {
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.kick",
		"admin.spectate",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.whitelisted",
		"admin.tickets",
		"admin.spawnBmx",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		"admin.ban",
		
  },
  ["Trial Staff"] = {
		"admin.menu",
		"admin.warn",
		"admin.showwarn",
		"admin.kick",
		"admin.tp2player",
		"admin.summon",
		"admin.freeze",
		"admin.whitelisted",
		"admin.tickets",
		"admin.spawnBmx",
		"staff.mode",
		"admin.idsabovehead",
		"vehicle.delete",
		
  },

  ["cardev"] = {
	"cardev.menu",
  },

  -- [Police Groups]
  ["Commissioner Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
	"police.loadshop2",
	"police.announce",
  },

  ["Commissioner"] = {
	"cop.whitelisted",
  },

  ["Deputy Commissioner Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
	"police.loadshop2",
	"police.announce",
  },

  ["Deputy Commissioner"] = {
	"cop.whitelisted",
  },

  ["Assistant Commissioner Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
	"police.loadshop2",
	"police.announce",
  },

  ["Assistant Commissioner"] = {
	"cop.whitelisted",
  },

  ["Deputy Assistant Commissioner Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
	"police.loadshop2",
	"police.announce",
  },

  ["Deputy Assistant Commissioner"] = {
	"cop.whitelisted",
  },

  ["Commander Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
	"police.loadshop2",
	"police.announce",
  },

  ["Commander"] = {
	"cop.whitelisted",
  },

  ["Chief Superintendent Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
  },

  ["Chief Superintendent"] = {
	"cop.whitelisted",
  },

  ["Superintendent Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
	"police.maxarmour",
  },

  ["Superintendent"] = {
	"cop.whitelisted",
  },

  ["Chief Inspector Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["Chief Inspector"] = {
	"cop.whitelisted",
  },

  ["Inspector Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["Inspector"] = {
	"cop.whitelisted",
  },

  ["Sergeant Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["Sergeant"] = {
	"cop.whitelisted",
  },

  ["Special Constable Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["Special Constable"] = {
	"cop.whitelisted",
  },

  ["Senior Constable Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["Senior Constable"] = {
	"cop.whitelisted",
  },

  ["Police Constable Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["Police Constable"] = {
	"cop.whitelisted",
  },

  ["PCSO Clocked"] = {
	"cop.whitelisted",
	"police.onduty.permission",
	"police.armoury",
  },

  ["PCSO"] = {
	"cop.whitelisted",
  },

  ["NHS Head Chief Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Assistant Chief Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Deputy Chief Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Captain Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Consultant Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Specialist Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Senior Doctor Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Doctor Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Junior Doctor Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Critical Care Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Paramedic Clocked"] = {
    "nhs.onduty.permission",
  },

  ["NHS Trainee Paramedic Clocked"] = {
    "nhs.onduty.permission",
  },

  --[[ NHS Clock On Groups ]]--
  ["NHS Head Chief"] = {
	"nhs.whitelisted",
  },

  ["NHS Assistant Chief"] = {
	"nhs.whitelisted",
  },

  ["NHS Deputy Chief Officer"] = {
	"nhs.whitelisted",
  },

  ["NHS Captain"] = {
	"nhs.whitelisted",
  },

  ["NHS Consultant"] = {
	"nhs.whitelisted",
  },

  ["NHS Specialist"] = {
	"nhs.whitelisted",
  },

  ["NHS Senior Doctor"] = {
	"nhs.whitelisted",
  },

  ["NHS Doctor"] = {
	"nhs.whitelisted",
  },

  ["NHS Junior Doctor"] = {
	"nhs.whitelisted",
  },

  ["NHS Critical Care"] = {
	"nhs.whitelisted",
  },

  ["NHS Paramedic"] = {
	"nhs.whitelisted",
  },

  ["NHS Trainee Paramedic"] = {
	"nhs.whitelisted",
  },

-- ILLEGAL LICENSES --
  ["Weed"] = {
    "weed.job",
  },
  ["Cocaine"] = {
    "cocaine.job",
  },
  ["Heroin"] = {
    "heroin.job",
  },
  ["LSD"] = {
    "lsd.job",
  },

-- LEGAL LICENSES --
  ["Scrap"] = {
    "scrap.job",
  },
  ["Gold"] = {
    "gold.job",
  },
  ["Diamond"] = {
    "diamond.job",
  },

-- HOUR REWARDS --
  ["10hrs"] = {},
  ["25hrs"] = {},
  ["50hrs"] = {},
  ["100hrs"] = {},
  ["250hrs"] = {},
  ["500hrs"] = {},

  ["Gang"] = {
    "gang.whitelisted",
  },
  ["highroller"] = {
    "casino.highrollers",
  },

  ["Rebel"] = {
    "rebellicense.whitelisted",
  },
  ["AdvancedRebel"] = {
    "advancedrebel.license",
  },

-- DONATOR GROUPS --
  ["Supporter"] = {
  	"vip.gunstore",
  },  
  ["Platinum"] = {
  	"vip.gunstore",
  },  
  ["Godfather"] = {
  	"vip.gunstore",
  },  
  ["Underboss"] = {
  	"vip.gunstore",
  },

-- POV GROUP --
  ["pov"] = {
  	"pov.list"
  },

  ["DJ"] = {
	"dj.menu"
  },
  ["PilotLicense"] = {
	"air.whitelisted"
  },
  
  ["Cinematic"] = {},
  ["TutorialDone"] = {},
  ["polblips"] = {},

  -- Default Jobs
  ["AA Mechanic"] = {},
  ["Royal Mail Driver"] = {},
  ["Bus Driver"] = {},
  ["Deliveroo"] = {},
  ["Fisherman"] = {},
  ["Scuba Diver"] = {},
  ["Pilot"] = {},
  ["G4S Driver"] = {},
  ["Lorry Driver"] = {},
  ["Taco Seller"] = {},
  ["Burger Shot Cook"] = {},

}

-- groups are added dynamically using the API or the menu, but you can add group when an user join here
cfg.users = {
}

-- group selectors
-- _config
--- x,y,z, blipid, blipcolor, permissions (optional)

cfg.selectors = {}

return cfg
