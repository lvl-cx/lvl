fx_version 'adamant'
games { 'gta5' }

client_scripts {
	'tattoomenu.lua',
	'config.lua',
	'client.lua'
}


file 'AllTattoos.json'

server_scripts {
    "@vrp/lib/utils.lua",
    "@mysql-async/lib/MySQL.lua",
    "server.lua",
}