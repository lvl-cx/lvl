fx_version 'cerulean'
games { 'gta5' }
author 'JamesUK'

ui_page 'nui/inventory.html'

client_scripts {
    '@arma/client_min/Tunnel.lua',
    '@arma/client_min/Proxy.lua',
    'client.lua'
}

server_scripts {
    'serverutils.lua',
    'server.lua'
}

files {
    'nui/*',
    'nui/assets/*'
}
