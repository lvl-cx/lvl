
fx_version 'cerulean'
games {  'gta5' }

description "ARMA MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@arma/lib/utils.lua",
  "MySQL.lua"
}

