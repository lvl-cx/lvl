fx_version 'cerulean'
games {  'gta5' }

description "RP module/framework"

dependency "ghmattimysql"
dependency "arma_mysql"

ui_page "ui/index.html"

shared_scripts {
  "cfg/cfg_crypto.lua",
  "sharedcfg/*",
  "armacore/cfg/cfg_*.lua",
  --"cfg/cfg_*.lua",
  "shared/*.lua",
}


-- client files
files{
  "cfg/client.lua",
  "cfg/cfg_*.lua",
  "cfg/atms.lua",
  "cfg/weapons.lua",
  "cfg/skinshops.lua",
  "cfg/blips_markers.lua",
  "ui/index.html",
  "ui/design.css",
  "ui/index.css",
  "ui/main.js",
  "ui/index.js",
  "ui/Menu.js",
  "ui/ProgressBar.js",
  "ui/WPrompt.js",
  "ui/RequestManager.js",
  "ui/SoundManager.js",
  "ui/AnnounceManager.js",
  "ui/Div.js",
  "ui/dynamic_classes.js",
  "ui/fonts/Pdown.woff",
  "ui/fonts/GTA.woff",
  'ui/sounds/*',
  "ui/killfeed/img/*.png",
  "ui/killfeed/font/stratum2-bold-webfont.woff",
  "ui/killfeed/index.js",
  "ui/killfeed/style.css",
  "ui/progress/*",
  "ui/pnc/js/index.js",
  "ui/pnc/js/vue.min.js",
  "ui/pnc/js/fine_types.js",
  "ui/pnc/css/index.css",
  "ui/pnc/css/modal.css",
  "ui/pnc/fonts/modes.ttf",
  "ui/pnc/img/tax.png",
  "ui/pnc/img/plates.png",
  "ui/pnc/components/*.js",
  "ui/pnc/components/*.html",

  'audio/sfx/resident/explosions.awc',
  'audio/sfx/resident/vehicles.awc',
  'audio/sfx/resident/weapons.awc',
  'audio/sfx/weapons_player/lmg_combat.awc',
  'audio/sfx/weapons_player/lmg_mg_player.awc',
  'audio/sfx/weapons_player/mgn_sml_am83_vera.awc',
  'audio/sfx/weapons_player/mgn_sml_am83_verb.awc',
  'audio/sfx/weapons_player/mgn_sml_sc__l.awc',
  'audio/sfx/weapons_player/ptl_50cal.awc',
  'audio/sfx/weapons_player/ptl_combat.awc',
  'audio/sfx/weapons_player/ptl_pistol.awc',
  'audio/sfx/weapons_player/ptl_px4.awc',
  'audio/sfx/weapons_player/ptl_rubber.awc',
  'audio/sfx/weapons_player/sht_bullpup.awc',
  'audio/sfx/weapons_player/sht_pump.awc',
  'audio/sfx/weapons_player/smg_micro.awc',
  'audio/sfx/weapons_player/smg_smg.awc',
  'audio/sfx/weapons_player/snp_heavy.awc',
  'audio/sfx/weapons_player/snp_rifle.awc',
  'audio/sfx/weapons_player/spl_grenade_player.awc',
  'audio/sfx/weapons_player/spl_minigun_player.awc',
  'audio/sfx/weapons_player/spl_prog_ar_player.awc',
  'audio/sfx/weapons_player/spl_railgun.awc',
  'audio/sfx/weapons_player/spl_rpg_player.awc',
  'audio/sfx/weapons_player/spl_tank_player.awc',
}


-- client scripts
client_scripts{
  "rageui/RMenu.lua",
	"rageui/menu/RageUI.lua",
	"rageui/menu/Menu.lua",
	"rageui/menu/MenuController.lua",
	"rageui/components/*.lua",
	"rageui/menu/elements/*.lua",
	"rageui/menu/items/*.lua",
	"rageui/menu/panels/*.lua",
	"rageui/menu/windows/*.lua",
  "lib/cl_mouse.lua",
  "lib/cl_thread.lua",
  "lib/cl_cache.lua",
  "lib/cl_util.lua",
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "utils/cl_*.lua",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/police.lua",
  "client/lockcar-client.lua",
  "client/admin.lua",
  "client/enumerators.lua",
  "client/inventory.lua",
  "client/clothing.lua",
  "client/atms.lua",
  "client/garages.lua",
  "client/adminmenu.lua",
  "client/LsCustomsMenu.lua",
  "client/LsCustoms.lua",
  "client/warningsystem.lua",
  "client/cl_*.lua",
  "armacore/client/cl_*.lua",
  "armacore/cfg/cfg_*.lua",
  "cfg/client.lua",
  -- "hotkeys/hotkeys.lua"
}
-- server scripts
server_scripts{ 
  "lib/utils.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",

  -- basic implementations
  "modules/basic_atm.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/LsCustoms.lua",
  "modules/server_commands.lua",
  "modules/warningsystem.lua",
  "modules/sv_*.lua",
  "servercfg/*.lua",
  "armacore/modules/sv_*.lua",
  -- "modules/hotkeys.lua"
}

data_file 'AUDIO_WAVEPACK' 'audio/sfx/resident'
data_file 'AUDIO_WAVEPACK' 'audio/sfx/weapons_player'