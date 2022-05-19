
local cfg = {}


cfg.groups = {
	["dev"] = {

        "dev.menu",
        "dev.spawncar",
        "dev.spawnweapon",
        "dev.deletecar",
        "dev.fixcar",

        "admin.menu",
        "admin.warn",
        "admin.showwarn",
        "admin.ban",
        "admin.kick",
        "admin.nof10kick",
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
			
		"admin.staffAddGroups",
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.licenseAddGroups",
		"admin.donoAddGroups",

		"group.add.vipgarage",
        "group.add.founder",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.moderator",
        "group.add.trial",
        "group.add",

		"group.remove.vipgarage",
        "group.remove.founder",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.moderator",
        "group.remove.trial",
		"group.remove",
		
		"admin.whitelisted",
		"admin.tickets",
		"admin.teleport", -- [Access to Teleport to Legion etc]
	},
	["founder"] = {
		"admin.menu",
        "admin.warn",
        "admin.showwarn",
        "admin.ban",
        "admin.kick",
        "admin.nof10kick",
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

		"group.add.vipgarage",
        "group.add.founder",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.moderator",
        "group.add.trial",
        "group.add",

		"group.remove.vipgarage",
        "group.remove.founder",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.moderator",
        "group.remove.trial",
		"group.remove",
		"founder.perm",
		
		"admin.whitelisted",
		"admin.tickets",
		
		"vehicle.delete",
		"admin.teleport", -- [Access to Teleport to Legion etc]
	},
	["staffmanager"] = {
		"admin.menu",
        "admin.warn",
        "admin.showwarn",
        "admin.ban",
        "admin.kick",
        "admin.nof10kick",
        "admin.revive",
        "admin.tp2player",
        "admin.summon",
        "admin.freeze",
        "admin.getgroups",
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
		
		"admin.povAddGroups",
		"admin.mpdAddGroups",
		"admin.nhsAddGroups",

        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.moderator",
        "group.add.trial",

		"group.remove.vipgarage",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.moderator",
        "group.remove.trial",
		"group.remove",
		
		"admin.whitelisted",
		"admin.tickets",
		"admin.teleport", -- [Access to Teleport to Legion etc]
	},
	["commanager"] = {
	"admin.menu",
	"admin.warn",
	"admin.showwarn",
	"admin.ban",
	"admin.kick",
	"admin.nof10kick",
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
	"admin.idsabovehead",
	"vehicle.delete",
		
	"admin.staffAddGroups",
	"admin.povAddGroups",
	"admin.mpdAddGroups",
	"admin.nhsAddGroups",

	"group.add.headadmin",
	"group.add.senioradmin",
	"group.add.administrator",
	"group.add.moderator",
	"group.add.trial",

	"group.remove.headadmin",
	"group.remove.senioradmin",
	"group.remove.administrator",
	"group.remove.moderator",
	"group.remove.trial",
	"group.remove",
	
	"admin.whitelisted",
	"admin.tickets",
	"admin.teleport", -- [Access to Teleport to Legion etc]
	  },
	["headadmin"] = {
	"admin.menu",
    "admin.warn",
    "admin.showwarn",
    "admin.ban",
    "admin.kick",
    "admin.nof10kick",
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
	"admin.teleport", -- [Access to Teleport to Legion etc]
  },
  ["senioradmin"] = {
	"admin.menu",
	"admin.warn",
	"admin.showwarn",
	"admin.ban",
	"admin.kick",
	"admin.nof10kick",
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
	"admin.teleport", -- [Access to Teleport to Legion etc]
  },
  ["administrator"] = {
	"admin.menu",
	"admin.warn",
	"admin.showwarn",
	"admin.ban",
	"admin.kick",
	"admin.nof10kick",
	"admin.revive",
	"admin.tp2player",
	"admin.summon",
	"admin.freeze",
	"admin.spectate",
	"admin.screenshot",
	"admin.slap",
	"admin.tp2waypoint",
	"admin.tp2coords",

	"admin.whitelisted",
	"admin.tickets",
	"admin.spawnBmx",
	"staff.mode",
	"admin.idsabovehead",
	"vehicle.delete",
	"admin.teleport", -- [Access to Teleport to Legion etc]
  },
  ["srmoderator"] = {
    "admin.menu",
    "admin.warn",
    "admin.showwarn",
    "admin.ban",
    "admin.kick",
    "admin.nof10kick",
    "admin.revive",
    "admin.tp2player",
    "admin.summon",
    "admin.freeze",
    "admin.screenshot",

    "admin.whitelisted",
    "admin.tickets",
    "admin.spawnBmx",
	"staff.mode",
	"admin.idsabovehead",
	"vehicle.delete",
	"admin.teleport", -- [Access to Teleport to Legion etc]
    },
  ["moderator"] = {
	"admin.menu",
	"admin.warn",
	"admin.showwarn",
	"admin.ban",
	"admin.kick",
	"admin.nof10kick",
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
	"admin.teleport", -- [Access to Teleport to Legion etc]
  },
  ["supportteam"] = {
    "admin.menu",
	"admin.warn",
	"admin.showwarn",
	"admin.kick",
	"admin.nof10kick",
	"admin.revive",
	"admin.tp2player",
	"admin.summon",
	"admin.freeze",
	"admin.whitelisted",
	"admin.tickets",
	"admin.spawnBmx",
	"staff.mode",
	"admin.idsabovehead",
	"vehicle.delete",
	"admin.teleport", -- [Access to Teleport to Legion etc]
  },
  ["trialstaff"] = {
    "admin.menu",
	"admin.warn",
	"admin.showwarn",
	"admin.kick",
	"admin.nof10kick",
	"admin.summon",
	"admin.freeze",
	"admin.whitelisted",
	"admin.tickets",
	"admin.spawnBmx",
	"staff.mode",
	"admin.idsabovehead",
	"vehicle.delete",
  },

  -- [Police Groups]
  ["Commissioner Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
	"police.putinveh",
	"cop.glock",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"commissioner.paycheck",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"com.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Commissioner"] = {
    "commissioner.clockon",
	"clockon.menu",
  },

  ["Deputy Commissioner Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
	"police.getoutveh",
	"deputycommissioner.paycheck",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
	"police.seize.weapons",
	"cop.glock",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"depcom.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Deputy Commissioner"] = {
    "depcommissioner.clockon",
	"clockon.menu",
  },

  ["Assistant Commissioner Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
	"police.putinveh",
	"assistantcommissioner.paycheck",
    "police.getoutveh",
	"police.service",
	"cop.glock",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"assistcom.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Assistant Commissioner"] = {
    "asscommissioner.clockon",
	"clockon.menu",
  },

  ["Deputy Assistant Commissioner Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
	"police.getoutveh",
	"assistantdeputycommissioner.paycheck",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"cop.glock",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"depassist.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Deputy Assistant Commissioner"] = {
    "depasscommissioner.clockon",
	"clockon.menu",
  },

  ["Commander Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"commander.paycheck",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"cop.glock",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"com.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Commander"] = {
    "commander.clockon",
	"clockon.menu",
  },

  ["Chief Superintendent Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
	"police.putinveh",
	"chiefsuperintendent.paycheck",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
	"police.seize.items",
	"cop.glock",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"chiefsupt.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Chief Superintendent"] = {
    "chiefsupint.clockon",
	"clockon.menu",
  },

  ["Superintendent Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
	"cop.glock",
	"police.wanted",
	"superintendent.paycheck",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"supt.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Superintendent"] = {
    "superint.clockon",
	"clockon.menu",
  },

  ["Chief Inspector Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
	"police.service",
	"chiefinspector.paycheck",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
	"cop.glock",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"chiefinspector.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Chief Inspector"] = {
    "chiefinsp.clockon",
	"clockon.menu",
  },

  ["Inspector Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"inspector.paycheck",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
	"cop.glock",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"inspector.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Inspector"] = {
    "inspector.clockon",
	"clockon.menu",
  },

  ["Sergeant Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"sergeant.paycheck",
	"police.easy_unjail",
	"cop.glock",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"sergeant.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Sergeant"] = {
    "sgt.clockon",
	"clockon.menu",
  },

  ["Special Police Constable Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"cop.glock",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
	"police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"spc.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Special Police Constable"] = {
    "specialpc.clockon",
	"clockon.menu",
  },

  ["Senior Police Constable Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
	"police.wanted",
	"cop.glock",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
	"police.announce",
	"spc.paycheck",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"response.armor",
	"seniorpc.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Senior Police Constable"] = {
    "srpc.clockon",
	"clockon.menu",
  },

  ["Police Constable Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
      onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"cop.glock",
	"response.armor",
	"policeconstable.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["Police Constable"] = {
    "pc.clockon",
	"clockon.menu",
  },

  ["PCSO Clocked"] = {
    _config = { gtype = "job",
	  onjoin = function(player) ARMAclient.setCop(player,{true}) end,
	  onspawn = function(player) ARMAclient.setCop(player,{true}) end,
	  onleave = function(player)
		local user_id = ARMA.getUserId(player)
		TriggerEvent("ARMA:ClockingOff")   
		TriggerClientEvent("ARMA:ClockingOff123",source)		
		ARMAclient.setCop(player,{false})
		TriggerClientEvent("DeleteBlipsALL", player)
	  end
	},
	"Chief.cloakroom",
    "police.pc",
    --"police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.service",
	"police.drag",
	"police.easy_cuff",
	"police.easy_fine",
	"police.easy_jail",
	"police.easy_unjail",
	"police.spikes",
	"police.menu",
    "police.check",
	"toggle.service",
	"police.freeze",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    --"police.jail",
    --"police.fine",
    "police.announce",
    --"-police.store_weapons",
    "police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.vehicle",
	"police.loadshop",
	"emergency.market",
	"emergency.revive",
	"emergency.shop",
	"cop.whitelisted",
	"cop.glock",
	"pcso.armor",
	"pcso.paycheck",
	"police.menu_interaction",
	"police.perms",
	"police.mission",
	"police.armoury",
	"cop.keycard",
	"police.smartsigns",
  },

  ["PCSO"] = {
    "pcso.clockon",
	"clockon.menu",
  },

  ["SCO-19"] = {
    "sco.armoury",
  },

  -- [Drug Groups]
  ["Scrap"] = {
    "scrap.job",
  },
  ["Weed"] = {
    "weed.job",
  },
  ["Cocaine"] = {
    "cocaine.job",
  },
  ["Gold"] = {
    "gold.job",
  },

  ["Diamond"] = {
    "diamond.job",
  },

  ["Heroin"] = {
    "heroin.job",
  },

  ["LSD"] = {
    "lsd.job",
  },

  -- [Gang Whitelist/ Rebel]
  ["Gang"] = {
    "gang.whitelist",
  },

  ["Rebel"] = {
    "rebel.whitelist",
  },

  -- [Donator Groups]

  	["Starter"] = {
		"vip.perm",
	},

	["VIP"] = {
		"vip.perm",
	},

	["Recruit"] = {
		"vip.perm",
	},

	["Soldier"] = {
		"vip.perm",
	},

	["Warrior"] = {
		"vip.perm",
	},
	["Champion"] = {
		"vip.perm",
	},

  -- [Staff On/ Off Flag]
  ["staffon"] = {},
  ["staffoff"] = {},

  -- [Cosmetics]
  	-- [Watches]
	["Rolex"] = {},
	["AP"] = {},
	-- [Chain]
	["Gold Chain"] = {},
	-- [Vests]
	["Army Black Armed Vest"] = {},
	["Army Green Armed Vest"] = {},
	["Army Black Ammo Vest"] = {},
	["Army Green Ammo Vest"] = {},
	["Army Black Large Vest"] = {},
	["Army Green Large Vest"] = {},
	["Standard Grey Vest"] = {},
	["Small Army Green Vest"] = {},
	["Camo Green Vest"] = {},
	["Blue Untar Vest"] = {},
	["British Grey Armed Vest"] = {},
	["Pink Icons Vest"] = {},

}

-- groups are added dynamically using the API or the menu, but you can add group when an user join here
cfg.users = {
  [1] = { -- give superadmin and admin group to the first created user on the database
    "founder",
    "dev",
  }
}

-- group selectors
-- _config
--- x,y,z, blipid, blipcolor, permissions (optional)

cfg.selectors = {}

return cfg
