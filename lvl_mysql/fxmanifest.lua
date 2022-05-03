
fx_version 'cerulean'
games {  'gta5' }

description "LVL MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@lvl/lib/utils.lua",
  "MySQL.lua"
}

