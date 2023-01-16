local cfg = {}

cfg.groups = {

    -- $$$$$$\ $$$$$$$$\  $$$$$$\  $$$$$$$$\ $$$$$$$$\ 
    -- $$  __$$\\__$$  __|$$  __$$\ $$  _____|$$  _____|
    -- $$ /  \__|  $$ |   $$ /  $$ |$$ |      $$ |      
    -- \$$$$$$\    $$ |   $$$$$$$$ |$$$$$\    $$$$$\    
    --  \____$$\   $$ |   $$  __$$ |$$  __|   $$  __|   
    -- $$\   $$ |  $$ |   $$ |  $$ |$$ |      $$ |      
    -- \$$$$$$  |  $$ |   $$ |  $$ |$$ |      $$ |      
    --  \______/   \__|   \__|  \__|\__|      \__|      
                                                                                                                                                  
    ["Developer"] = {
        "dev.menu",
        "cardev.menu",
        "admin.addcar",
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
        "admin.tickets",
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
        "cardev.menu",
        "vip.gunstore",
        "vip.garage",
        "police.dev"
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
        "admin.tp2player",
        "admin.freeze",
        "admin.screenshot",
        "admin.spectate",
        "admin.tickets",
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
   
    -- $$\      $$\ $$$$$$$\  $$$$$$$\  
    -- $$$\    $$$ |$$  __$$\ $$  __$$\ 
    -- $$$$\  $$$$ |$$ |  $$ |$$ |  $$ |
    -- $$\$$\$$ $$ |$$$$$$$  |$$ |  $$ |
    -- $$ \$$$  $$ |$$  ____/ $$ |  $$ |
    -- $$ |\$  /$$ |$$ |      $$ |  $$ |
    -- $$ | \_/ $$ |$$ |      $$$$$$$  |
    -- \__|     \__|\__|      \_______/ 
                                     
                                                              
    ["Large Arms Access"] = {
        "police.loadshop2",
        "police.maxarmour"
    }, 
    ["Police Horse Trained"] = {}, 
    ["K9 Trained"] = {}, 
    ["Drone Trained"] = {},
    ["NPAS Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.npas",
    },
    ["NPAS"] = {
        "cop.whitelisted"
    },
    ["Trident Command Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.undercover",
        "police.tridentcommand",
    },
    ["Trident Command"] = {
        "cop.whitelisted"
    },
    ["Trident Officer Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.undercover",
        "police.tridentofficer",
    },
    ["Trident Officer"] = {
        "cop.whitelisted"
    },
    ["Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.announce",
        "police.commissioner",
    },
    ["Commissioner"] = {
        "cop.whitelisted"
    },
    ["Deputy Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.announce",
        "police.deputycommissioner",
    },
    ["Deputy Commissioner"] = {
        "cop.whitelisted"
    },
    ["Assistant Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.announce",
        "police.assistantcommissioner",
    },
    ["Assistant Commissioner"] = {
        "cop.whitelisted"
    },
    ["Dep. Asst. Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.announce",
        "police.deputyassistantcommissioner",
    },
    ["Dep. Asst. Commissioner"] = {
        "cop.whitelisted"
    },
    ["Commander Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.announce",
        "police.commander",
    },
    ["Commander"] = {
        "cop.whitelisted"
    },
    ["Chief Superintendent Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.chiefsuperintendent",
    },
    ["Chief Superintendent"] = {
        "cop.whitelisted"
    },
    ["Superintendent Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.superintendent",
    },
    ["Superintendent"] = {
        "cop.whitelisted"
    },
    ["Special Constable Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.specialconstable",
        "police.announce",
    },
    ["Special Constable"] = {
        "cop.whitelisted"
    },
    ["Chief Inspector Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.chiefinspector",
    },
    ["Chief Inspector"] = {
        "cop.whitelisted"
    },
    ["Inspector Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.inspector",
    },
    ["Inspector"] = {
        "cop.whitelisted"
    },
    ["Sergeant Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.sergeant",
    },
    ["Sergeant"] = {
        "cop.whitelisted"
    },
    ["Senior Constable Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.seniorconstable",
    },
    ["Senior Constable"] = {
        "cop.whitelisted"
    },
    ["PC Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.constable",
    },
    ["PC"] = {
        "cop.whitelisted"
    },
    ["PCSO Clocked"] = {
        "cop.whitelisted",
        "police.onduty.permission",
        "police.armoury",
        "police.pcso",
    },
    ["PCSO"] = {
        "cop.whitelisted"
    },

    -- $$\   $$\ $$\   $$\  $$$$$$\  
    -- $$$\  $$ |$$ |  $$ |$$  __$$\ 
    -- $$$$\ $$ |$$ |  $$ |$$ /  \__|
    -- $$ $$\$$ |$$$$$$$$ |\$$$$$$\  
    -- $$ \$$$$ |$$  __$$ | \____$$\ 
    -- $$ |\$$$ |$$ |  $$ |$$\   $$ |
    -- $$ | \$$ |$$ |  $$ |\$$$$$$  |
    -- \__|  \__|\__|  \__| \______/ 
                                                        
    
    ["NHS Head Chief Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.headchief",
    },
    ["NHS Head Chief"] = {
        "nhs.whitelisted",
    },
    ["NHS Assistant Chief Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.assistantchief",
    },
    ["NHS Assistant Chief"] = {
        "nhs.whitelisted",
    },
    ["NHS Deputy Chief Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.deputychief",
    },
    ["NHS Deputy Chief"] = {
        "nhs.whitelisted",
    },
    ["NHS Captain Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
    },
    ["NHS Captain"] = {
        "nhs.whitelisted",
        "nhs.captain",
    },
    ["NHS Consultant Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.consultant",
    },
    ["NHS Consultant"] = {
        "nhs.whitelisted",
    },
    ["NHS Specialist Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.specialist",
    },
    ["NHS Specialist"] = {
        "nhs.whitelisted",
    },
    ["NHS Senior Doctor Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.seniordoctor",
    },
    ["NHS Senior Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Doctor Clocked"] = {
        "nhs.whitelisted",
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.doctor",
    },
    ["NHS Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Junior Doctor Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.juniordoctor",
    },
    ["NHS Junior Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Critical Care Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.criticalcare",
    },
    ["NHS Critical Care"] = {
        "nhs.whitelisted",
    },
    ["NHS Paramedic Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.paramedic",
    },
    ["NHS Paramedic"] = {
        "nhs.whitelisted",
    },
    ["NHS Trainee Paramedic Clocked"] = {
        "nhs.onduty.permission",
        "nhs.whitelisted",
        "nhs.traineeparamedic",
    },
    ["NHS Trainee Paramedic"] = {
        "nhs.whitelisted",
    },
    
    -- $$\       $$$$$$\  $$$$$$\  $$$$$$$$\ $$\   $$\  $$$$$$\  $$$$$$$$\  $$$$$$\  
    -- $$ |      \_$$  _|$$  __$$\ $$  _____|$$$\  $$ |$$  __$$\ $$  _____|$$  __$$\ 
    -- $$ |        $$ |  $$ /  \__|$$ |      $$$$\ $$ |$$ /  \__|$$ |      $$ /  \__|
    -- $$ |        $$ |  $$ |      $$$$$\    $$ $$\$$ |\$$$$$$\  $$$$$\    \$$$$$$\  
    -- $$ |        $$ |  $$ |      $$  __|   $$ \$$$$ | \____$$\ $$  __|    \____$$\ 
    -- $$ |        $$ |  $$ |  $$\ $$ |      $$ |\$$$ |$$\   $$ |$$ |      $$\   $$ |
    -- $$$$$$$$\ $$$$$$\ \$$$$$$  |$$$$$$$$\ $$ | \$$ |\$$$$$$  |$$$$$$$$\ \$$$$$$  |
    -- \________|\______| \______/ \________|\__|  \__| \______/ \________| \______/ 
                        
    ["Weed"] = {},
    ["Cocaine"] = {},
    ["Meth"] = {},
    ["Heroin"] = {},
    ["LSD"] = {},
    ["Copper"] = {},
    ["Limestone"] = {},
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
    
    -- $$$$$$$\   $$$$$$\  $$\   $$\  $$$$$$\ $$$$$$$$\  $$$$$$\  $$$$$$$\  
    -- $$  __$$\ $$  __$$\ $$$\  $$ |$$  __$$\\__$$  __|$$  __$$\ $$  __$$\ 
    -- $$ |  $$ |$$ /  $$ |$$$$\ $$ |$$ /  $$ |  $$ |   $$ /  $$ |$$ |  $$ |
    -- $$ |  $$ |$$ |  $$ |$$ $$\$$ |$$$$$$$$ |  $$ |   $$ |  $$ |$$$$$$$  |
    -- $$ |  $$ |$$ |  $$ |$$ \$$$$ |$$  __$$ |  $$ |   $$ |  $$ |$$  __$$< 
    -- $$ |  $$ |$$ |  $$ |$$ |\$$$ |$$ |  $$ |  $$ |   $$ |  $$ |$$ |  $$ |
    -- $$$$$$$  | $$$$$$  |$$ | \$$ |$$ |  $$ |  $$ |    $$$$$$  |$$ |  $$ |
    -- \_______/  \______/ \__|  \__|\__|  \__|  \__|    \______/ \__|  \__|
                                                                         
    ["Supporter"] = {
        "vip.gunstore",
        "vip.garage",
    },
    ["Premium"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Supreme"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Kingpin"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Rainmaker"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Baller"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    
    -- $$\      $$\ $$$$$$\  $$$$$$\   $$$$$$\  
    -- $$$\    $$$ |\_$$  _|$$  __$$\ $$  __$$\ 
    -- $$$$\  $$$$ |  $$ |  $$ /  \__|$$ /  \__|
    -- $$\$$\$$ $$ |  $$ |  \$$$$$$\  $$ |      
    -- $$ \$$$  $$ |  $$ |   \____$$\ $$ |      
    -- $$ |\$  /$$ |  $$ |  $$\   $$ |$$ |  $$\ 
    -- $$ | \_/ $$ |$$$$$$\ \$$$$$$  |\$$$$$$  |
    -- \__|     \__|\______| \______/  \______/ 
                                                                                   
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
    ["Burger Shot Cook"] = {},
}

return cfg
