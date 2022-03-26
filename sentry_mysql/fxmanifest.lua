
fx_version 'cerulean'
games {  'gta5' }

description "Sentry MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@sentry/lib/utils.lua",
  "MySQL.lua"
}

