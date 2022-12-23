local cfg = {}

cfg.groups = {
    ["Developer"] = {
        "dev.menu",
        "cardev.menu",
        "admin.addcar",
        "admin.spawnGun",
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.managecommunitypot",
        "admin.moneymenu",
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
        "admin.tickets"
    },
    ["Founder"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.spawnGun",
        "admin.addcar",
        "admin.managecommunitypot",
        "admin.moneymenu",
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
        "admin.tickets",
        "cardev.menu"
    },
    ["Staff Manager"] = {
        "admin.managecommunitypot",
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.addcar",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.managecommunitypot",
        "cardev.menu",
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
        "admin.tickets"
    },
    ["Community Manager"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.addcar",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
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
        "admin.tickets"
    },
    ["Head Admin"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
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
        "admin.tickets"
    },
    ["Senior Admin"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.tickets"
    },
    ["Admin"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.noclip",
        "admin.tickets"
    },
    ["Senior Mod"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.slap",
        "admin.tp2player",
        "admin.freeze",
        "admin.screenshot",
        "admin.video",
        "admin.spectate",
        "admin.tickets",
    },
    ["Moderator"] = {
        "admin.ban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.screenshot",
        "admin.spectate",
        "admin.tickets",
        "admin.slap",
        "admin.revive",
    },
    ["Support Team"] = {
        "admin.kick",
        "admin.spectate",
        "admin.tp2player",
        "admin.freeze",
        "admin.tickets",
        "admin.screenshot",
        "admin.ban",
    },
    ["Trial Staff"] = {
        "admin.kick",
        "admin.tp2player",
        "admin.freeze",
        "admin.tickets",
        "admin.screenshot",
    },
    ["cardev"] = {
        "cardev.menu"
    },
    -- [Police Groups]
    ["Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.maxarmour",
        "police.loadshop2",
        "police.announce"
    },
    ["Commissioner"] = {
        "cop.whitelisted"
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
        "cop.whitelisted"
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
        "cop.whitelisted"
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
        "cop.whitelisted"
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
        "cop.whitelisted"
    },
    ["Chief Superintendent Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.maxarmour",
    },
    ["Chief Superintendent"] = {
        "cop.whitelisted"
    },
    ["Superintendent Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.maxarmour",
    },
    ["Superintendent"] = {
        "cop.whitelisted"
    },
    ["Chief Inspector Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury"
    },
    ["Chief Inspector"] = {
        "cop.whitelisted"
    },
    ["Inspector Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury"
    },
    ["Inspector"] = {
        "cop.whitelisted"
    },
    ["Sergeant Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury"
    },
    ["Sergeant"] = {
        "cop.whitelisted"
    },
    ["Special Constable Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.maxarmour",
        "police.loadshop2",
    },
    ["Special Constable"] = {
        "cop.whitelisted"
    },
    ["Senior Constable Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury"
    },
    ["Senior Constable"] = {
        "cop.whitelisted"
    },
    ["Police Constable Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury"
    },
    ["Police Constable"] = {
        "cop.whitelisted"
    },
    ["PCSO Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury"
    },
    ["PCSO"] = {
        "cop.whitelisted"
    },
    ["NHS Head Chief Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Assistant Chief Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Deputy Chief Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Captain Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Consultant Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Specialist Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Senior Doctor Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Doctor Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Junior Doctor Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Critical Care Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Paramedic Clocked"] = {
        "nhs.onduty.permission"
    },
    ["NHS Trainee Paramedic Clocked"] = {
        "nhs.onduty.permission"
    },
     --
    --[[ NHS Clock On Groups ]] ["NHS Head Chief"] = {
        "nhs.whitelisted"
    },
    ["NHS Assistant Chief"] = {
        "nhs.whitelisted"
    },
    ["NHS Deputy Chief Officer"] = {
        "nhs.whitelisted"
    },
    ["NHS Captain"] = {
        "nhs.whitelisted"
    },
    ["NHS Consultant"] = {
        "nhs.whitelisted"
    },
    ["NHS Specialist"] = {
        "nhs.whitelisted"
    },
    ["NHS Senior Doctor"] = {
        "nhs.whitelisted"
    },
    ["NHS Doctor"] = {
        "nhs.whitelisted"
    },
    ["NHS Junior Doctor"] = {
        "nhs.whitelisted"
    },
    ["NHS Critical Care"] = {
        "nhs.whitelisted"
    },
    ["NHS Paramedic"] = {
        "nhs.whitelisted"
    },
    ["NHS Trainee Paramedic"] = {
        "nhs.whitelisted"
    },
    -- ILLEGAL LICENSES --
    ["Weed"] = {},
    ["Cocaine"] = {},
    ["Heroin"] = {},
    ["Meth"] = {},
    ["LSD"] = {},
    -- LEGAL LICENSES --
    ["Copper"] = {},
    ["Gold"] = {},
    ["Diamond"] = {},
    ["Gang"] = {
        "gang.whitelisted"
    },
    ["Highroller"] = {
        "casino.highrollers"
    },
    ["Rebel"] = {
        "rebellicense.whitelisted"
    },
    ["AdvancedRebel"] = {
        "advancedrebel.license"
    },
    -- DONATOR GROUPS --
    ["Supporter"] = {
        "vip.gunstore"
    },
    ["Platinum"] = {
        "vip.gunstore"
    },
    ["Godfather"] = {
        "vip.gunstore"
    },
    ["Underboss"] = {
        "vip.gunstore"
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
    ["Royal Mail Driver"] = {},
    ["Bus Driver"] = {},
    ["Deliveroo"] = {},
    ["Scuba Diver"] = {},
    ["Pilot"] = {},
    ["G4S Driver"] = {},
    ["Taco Seller"] = {},
    ["Burger Shot Cook"] = {}
}

-- groups are added dynamically using the API or the menu, but you can add group when an user join here
cfg.users = {}

-- group selectors
-- _config
--- x,y,z, blipid, blipcolor, permissions (optional)

cfg.selectors = {}

return cfg
