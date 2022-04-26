
fx_version 'cerulean'
games {  'gta5' }

description "ATM MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@atm/lib/utils.lua",
  "MySQL.lua"
}

